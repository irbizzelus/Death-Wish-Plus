-- Bain/Locke's hostage kill voice line fix by Dorpenka
function DialogManager:queue_narrator_dialog(id, params)
	return self:queue_dialog(self._narrator_prefix .. id, params)
end