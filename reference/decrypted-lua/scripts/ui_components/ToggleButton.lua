ToggleButton = ImageButton:new()

function ToggleButton:init()
	ImageButton.init(self)
	self.state = 1
	self.toggle_images = {}
end

function ToggleButton:onPointerEvent(eventType, x, y)
	local result, meta, item = ImageButton.onPointerEvent(self, eventType, x, y)
	
	if item == self then
		self.state = self.state + 1
		if self.state > #self.states then
			self.state = 1
		end
		
		ImageButton.setImage(self, self.states[self.state], self.disabled_image)
	end
	
	return result, meta, item
end

function ToggleButton:setImage(state_images, disabled_image)
	self.states = state_images
	ImageButton.setImage(self, state_images[self.state], disabled_image)
end

function ToggleButton:setState(state)
	self.state = state
	ImageButton.setImage(self, self.states[self.state], disabled_image)
end

filename="ToggleButton.lua"
