Loader = gamelua.subsystems.SubSystem:new()

function Loader:init()
	gamelua.subsystems.SubSystem.init(self)
	
	self.loading = false
	self.frame = 0
end

function Loader:eventTriggered(event)

	if event.id == gamelua.events.EID_DO_LOADING then
		gamelua.eventManager:notify({ id = gamelua.events.EID_SHOW_LOADING_PAGE })
		self.load_items = event.items
		self.loading = true
		self.completion_event = event.completion_event
		self.loading_frame = self.frame + 1
	end

end

function Loader:update(dt, time)

	if self.loading and self.loading_frame == self.frame then
		for _, v in _G.ipairs(self.load_items) do
			v()
		end
	
		gamelua.eventManager:notify({ id = gamelua.events.EID_HIDE_LOADING_PAGE })
		self.loading = false
		
		gamelua.eventManager:notify(self.completion_event)
	end
	
	self.frame = self.frame + 1
end

filename="loader.lua"
