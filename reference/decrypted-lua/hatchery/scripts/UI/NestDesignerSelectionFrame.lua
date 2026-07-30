NestDesignerSelectionFrame = ui.Frame:new()
Frame = ui.Frame

function NestDesignerSelectionFrame:init()
	Frame.init(self)	
	
	self.worldScale = 1
	local cancelButton = ui.ScallableButton:new()
	cancelButton.name = "cancelButton"
	cancelButton:setImage("H_BTN_NO")
	cancelButton.returnValue = "CANCEL"
	cancelButton.sound = getHatcherySound("cancel")
	self:addChild(cancelButton)
	cancelButton.activateOnRelease = true
	
	self.lastClickedButton = nil		
	
end


function NestDesignerSelectionFrame:setup(eventCancel, nests)
	
	self.itemTypeToInsert = itemTypeToInsert
	
	local cancelButton = self:getChild("cancelButton")	
	cancelButton.returnValue = eventCancel
	
	self.nestButtons = {}
	
	for k, v in _G.pairs(nests) do
		local nestButton = ui.TextButton:new()
		nestButton.name = "nestButton" .. v.name
		nestButton.font = "FONT_HATCHERY"
		nestButton.text = v.name
		nestButton.nest = v
		nestButton.returnValue = (hatcheryEvents.EID_NEST_DESIGNER_ITEM_SELECTED)
		nestButton.hanchor = "LEFT"
		self:addChild(nestButton)
		
		_G.table.insert(self.nestButtons, nestButton)
	end
	
	self.lastClickedButton = nil	
	
	
	self:layout()
	
	
	
end

function NestDesignerSelectionFrame:draw(x, y)
	ui.Frame.draw(self, x, y)	
end


function NestDesignerSelectionFrame:getClickedButtonItem()
	if self.lastClickedButton ~= nil then	
		return self.lastClickedButton			
	end
	
	return nil
end


function NestDesignerSelectionFrame:layout()
	Frame.layout(self)			
	
	local buttonsY = gamelua.screenHeight - 50
	local buttonX = 100
	local cancelButton = self:getChild("cancelButton")	
	cancelButton.y = buttonsY
	cancelButton.x = gamelua.screenWidth * 0.5 - buttonX
	
	local startX = 500
	local startY = 50
	local diffY = 50
	
	local y = startY
	for k, v in _G.pairs(self.nestButtons) do
		v.x = startX
		v.y = y
		
		y = y + diffY
	end
end


function NestDesignerSelectionFrame:getSelectedNest()
	return self.selectedNest
end

function NestDesignerSelectionFrame:onPointerEvent(eventType,x,y)
	local result,meta = Frame.onPointerEvent(self, eventType,x, y)
	
	if result == hatcheryEvents.EID_NEST_DESIGNER_ITEM_SELECTED then		
		
		self.selectedNest = meta.nest
	end
	
	return result, meta
end


filename="NestDesignerSelectionFrame.lua"
