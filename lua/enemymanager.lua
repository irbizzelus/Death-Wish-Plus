-- enemy ai speed
local function DWP_update_EnemyManager()
	DelayedCalls:Add("DWP_add_faster_enemy_ai_for_DW", 1, function()
		local prefer_FSS = FullSpeedSwarm and FullSpeedSwarm.settings.task_throughput >= 600
		if Network:is_server() and tweak_data and DWP and DWP.DWdifficultycheck and not prefer_FSS and not LIES then
			
			function EnemyManager:reindex_tasks()
				local new_tasks_tbl = {}
				for i=1,#self._queued_tasks do
					local v = self._queued_tasks[i]
					if not v.was_executed then
						table.insert(new_tasks_tbl, v)
					end
				end
				self._queued_tasks = new_tasks_tbl
			end

			function EnemyManager:_update_queued_tasks(t, dt)
				local tasks_executed = 0

				local max_tasks_this_frame = math.ceil(60 * dt)
				
				if not managers.groupai:state():whisper_mode() then -- stelf
					local tasks_per_diff = {
						[1] = 70,
						[2] = 90,
						[3] = 125,
						[4] = 190
					}
					local diff = DWP.settings.difficulty
					if Utils:IsInGameState() and DWP.settings_config and DWP.settings_config.difficulty then
						diff = DWP.settings_config.difficulty
					end
					max_tasks_this_frame = math.ceil(tasks_per_diff[diff] * dt)
				end

				for i=1, #self._queued_tasks do
					local task_data = self._queued_tasks[i]

					if not task_data.t or task_data.t < t then
						self:_execute_queued_task(i)
						tasks_executed = tasks_executed + 1
					elseif task_data.asap then
						self:_execute_queued_task(i)
						tasks_executed = tasks_executed + 1
					end

					if tasks_executed > max_tasks_this_frame then
						break
					end

					i = i + 1
				end

				local next_callback = self._delayed_clbks[#self._delayed_clbks]

				if next_callback and t > next_callback[2] then
					local clbk = table.remove(self._delayed_clbks)[3]

					clbk()
				end
				
				self:reindex_tasks()
			end

			function EnemyManager:_execute_queued_task(i)
				local task = self._queued_tasks[i]
				if task.was_executed then
					return
				end

				task.was_executed = true
				
				self._queued_task_executed = true

				if task.v_cb then
					task.v_cb(task.id)
				end

				task.clbk(task.data)
			end

			function EnemyManager:unqueue_task(id)
				local tasks = self._queued_tasks
				local i = #tasks

				while i > 0 do
					if tasks[i].id == id then
						tasks[i].was_executed = true
						return
					end

					i = i - 1
				end
			end
			
		elseif not tweak_data then
			DWP_update_EnemyManager()
		end
	end)
end
DWP_update_EnemyManager()