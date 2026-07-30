AchievementPopup = ui.BGBox:new()

function AchievementPopup:new(achievement_id, o)
	local o = o or {}
	o.achievement_id = achievement_id
	return ui.BGBox.new(self, o)
end

function AchievementPopup:init()

	ui.BGBox.init(self)

	self.components =
	{
		left = "ACHIEVEMENT_BG_LEFT",
		center = "ACHIEVEMENT_BG_MIDDLE",
		right = "ACHIEVEMENT_BG_RIGHT",
	}
	
	self.hanchor = "RIGHT"
	self.vanchor = "TOP"
	
	local icon = ui.Image:new()
	icon.name = "icon"
	self:addChild(icon)
	
	local title = ui.Text:new()
	title.name = "title"
	title.text = ""
	title.font = "FONT_GAMECENTER_BASIC"
	title.hanchor = "HCENTER"
	title.vanchor = "TOP"
	self:addChild(title)
	
	local description = ui.Text:new()
	description.name = "description"
	description.text = ""
	description.font = "FONT_GAMECENTER_BASIC"
	description.hanchor = "LEFT"
	description.vanchor = "BOTTOM"
	self:addChild(description)
end

function AchievementPopup:onEntry()
	ui.BGBox.onEntry(self)
	
	self.timer = 2.7
end

function AchievementPopup:layout()
	ui.BGBox.layout(self)
	self.y_base = screenHeight
	
	local achievement = gameCenter.achievements[self.achievement_id]
	
	local title = self:getChild("title")
	local description = self:getChild("description")
	local icon = self:getChild("icon")
	
	title.text = achievement.title or "Achievement Title"
	description.text = achievement.achievedText or "Earned an achievement."
	icon:setImage(achievement.icon)
	
	setFont(title.font)
	local title_h = _G.res.getFontHeight()
	local title_w = _G.res.getStringWidth(title.text)
	
	setFont(description.font)
	local desc_h = _G.res.getFontHeight()
	local desc_w = _G.res.getStringWidth(description.text)
	
	local bg_w, bg_h = _G.res.getSpriteBounds(self.components.right)
	
	local icon_w, icon_h = _G.res.getSpriteBounds(icon.image)
	
	self.width = _G.math.max(title_w, desc_w + icon_w) * 1.2
	self.height = bg_h
	self.x = screenWidth - bg_w
	
	title.x = self.width * -0.5
	title.y = self.height * 0.1
	
	icon.x = self.width * -0.9
	icon.y = self.height * 0.5
	
	description.x = icon.x + icon_w
	description.y = self.height * 0.63
end

function AchievementPopup:update(dt, time)
	ui.BGBox.update(self, dt, time)
	
	local _, box_h = _G.res.getSpriteBounds(self.components.right)
	
	self.timer = self.timer - dt
	
	if self.timer > 2.4 then
		self.y = screenHeight - box_h * ((2.7 - self.timer) / 0.3)
	elseif self.timer > 0.4 then
		self.y = screenHeight - box_h 
	elseif self.timer > 0 then
		self.y = screenHeight - box_h + box_h * ((0.4 - self.timer) / 0.3)
	else
		--temp
		notificationsFrame:removeChild(self)
	end
end

filename="achievements.lua"
