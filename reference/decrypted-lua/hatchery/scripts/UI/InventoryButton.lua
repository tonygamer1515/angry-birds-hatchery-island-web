InventoryButton = ImageButton:new()

function InventoryButton:init()
	ImageButton.init(self)
	
	local priceTag = Image:new()
	priceTag.name = "priceTag"
	priceTag:setImage("H_ITEM_PRICE_TAG")
	self:addChild(priceTag)
	
	local text = Text:new()
	text.name = "price"
	text.text = "0"
	text.font = "FONT_HATCHERY_NUMBERS"
	self:addChild(text)
	
end

function InventoryButton:setTextFontScale(scale)
	local text = self:getChild("price")
	text.scaleX = scale
	text.scaleY = scale
end


function InventoryButton:setPrice(val)
	self:getChild("price").text = "" .. val
end

function InventoryButton:layout()
	local pt = self:getChild("priceTag")
	pt.y = 5
	
	local text = self:getChild("price")
	text.y = 5
	text.x = 5
end
filename="InventoryButton.lua"
