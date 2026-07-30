function MainMenu:initGameCenter()
	local achievement_button = ui.ImageButton:new()
	achievement_button.name = "gcAchievementButton"
	achievement_button:setImage("BUTTON_ACHIEVEMENTS", "BUTTON_ACHIEVEMENTS_DISABLED")
	achievement_button.returnValue = "GOTO_ACHIEVEMENTS"
	self:addChild(achievement_button)
	
	local achievement_spinner = ui.Image:new()
	achievement_spinner.name = "spinner"
	achievement_spinner:setImage("GC_LOADING")
	achievement_button:addChild(achievement_spinner)
	
	local leaderboards_button = ui.ImageButton:new()
	leaderboards_button.name = "gcLeaderboardsButton"
	leaderboards_button:setImage("BUTTON_LEADERBOARDS", "BUTTON_LEADERBOARDS_DISABLED")
	leaderboards_button.returnValue = "GOTO_LEADERBOARDS"
	self:addChild(leaderboards_button)
	
	local leaderboards_spinner = ui.Image:new()
	leaderboards_spinner.name = "spinner"
	leaderboards_spinner:setImage("GC_LOADING")
	leaderboards_button:addChild(leaderboards_spinner)
	
	if gameCenterEnabled then
		self.game_center_state = "ENABLED"
	else
		self.game_center_state = "DISABLED"
	end
end

function MainMenu:refreshGameCenterButtons()
	self:resetGameCenterButtons()

	_G.table.insert(self.mid_buttons, 1, "gcAchievementButton")
	_G.table.insert(self.mid_buttons, 1, "gcLeaderboardsButton")
	
	if gameCenterEnabled then
		self.game_center_state = "ENABLED"
	else
		self.game_center_state = "DISABLED"
	end
end

function MainMenu:resetGameCenterButtons()
	local achievement_button = self:getChild("gcAchievementButton")
	local leaderboards_button = self:getChild("gcLeaderboardsButton")
	local achievement_spinner = achievement_button:getChild("spinner")
	local leaderboards_spinner = leaderboards_button:getChild("spinner")
	achievement_button:setImage("BUTTON_ACHIEVEMENTS", "BUTTON_ACHIEVEMENTS_DISABLED")
	leaderboards_button:setImage("BUTTON_LEADERBOARDS", "BUTTON_LEADERBOARDS_DISABLED")
	achievement_button:setEnabled(true)
	leaderboards_button:setEnabled(true)
	achievement_spinner.visible = false
	leaderboards_spinner.visible = false
	if gameCenterEnabled then
		self.game_center_state = "ENABLED"
	else
		self.game_center_state = "DISABLED"
	end
end

function MainMenu:setGameCenterEnabled(enabled)

	local achievement_button = self:getChild("gcAchievementButton")
	local leaderboards_button = self:getChild("gcLeaderboardsButton")
	local achievement_spinner = achievement_button:getChild("spinner")
	local leaderboards_spinner = leaderboards_button:getChild("spinner")

	if enabled then
		local old_state = self.game_center_state
		self.game_center_state = "ENABLED"
		
		if old_state == "INITIALISING_ACHIEVEMENTS" then
			print("Going to achievements after init...\n")
			self:gotoAchievements()
		elseif old_state == "INITIALISING_LEADERBOARDS" then
			print("Going to leaderboards after init...\n")
			self:gotoLeaderboards()
		end
	else
		self.game_center_state = "DISABLED"
		achievement_button:setImage("BUTTON_ACHIEVEMENTS", "BUTTON_ACHIEVEMENTS_DISABLED")
		leaderboards_button:setImage("BUTTON_LEADERBOARDS", "BUTTON_LEADERBOARDS_DISABLED")
		achievement_button:setEnabled(true)
		leaderboards_button:setEnabled(true)
		achievement_spinner.visible = false
		leaderboards_spinner.visible = false
	end
end

function MainMenu:gotoAchievements()

	local achievement_button = self:getChild("gcAchievementButton")
	local leaderboards_button = self:getChild("gcLeaderboardsButton")
	local achievement_spinner = achievement_button:getChild("spinner")
	local leaderboards_spinner = leaderboards_button:getChild("spinner")

	if self.game_center_state == "DISABLED" then
		print("Initialising gamecenter...\n")
		initGameCenter()
		self.game_center_state = "INITIALISING_ACHIEVEMENTS"
		achievement_button:setImage("BUTTON_EMPTY", "BUTTON_ACHIEVEMENTS_DISABLED")
		leaderboards_button:setImage("BUTTON_EMPTY", "BUTTON_LEADERBOARDS_DISABLED")
		achievement_spinner.visible = true
		leaderboards_spinner.visible = true
	elseif self.game_center_state == "ENABLED" then
		print("Showing achievements...\n")
		showAchievements()
		self.game_center_state = "LOADING_ACHIEVEMENTS"
		achievement_button:setImage("BUTTON_EMPTY", "BUTTON_ACHIEVEMENTS_DISABLED")
		leaderboards_button:setImage("BUTTON_LEADERBOARDS", "BUTTON_LEADERBOARDS_DISABLED")
		leaderboards_button:setEnabled(false)
		achievement_spinner.visible = true
		leaderboards_spinner.visible = false
	end
end

function MainMenu:gotoLeaderboards()

	local achievement_button = self:getChild("gcAchievementButton")
	local leaderboards_button = self:getChild("gcLeaderboardsButton")
	local achievement_spinner = achievement_button:getChild("spinner")
	local leaderboards_spinner = leaderboards_button:getChild("spinner")

	if self.game_center_state == "DISABLED" then
		print("Initialising gamecenter...\n")
		initGameCenter()
		self.game_center_state = "INITIALISING_LEADERBOARDS"
		achievement_button:setImage("BUTTON_EMPTY", "BUTTON_ACHIEVEMENTS_DISABLED")
		leaderboards_button:setImage("BUTTON_EMPTY", "BUTTON_LEADERBOARDS_DISABLED")
		achievement_spinner.visible = true
		leaderboards_spinner.visible = true
	elseif self.game_center_state == "ENABLED" then
		print("Showing leaderboards...\n")
		showLeaderboards()
		self.game_center_state = "LOADING_LEADERBOARDS"
		achievement_button:setImage("BUTTON_ACHIEVEMENTS", "BUTTON_ACHIEVEMENTS_DISABLED")
		leaderboards_button:setImage("BUTTON_EMPTY", "BUTTON_LEADERBOARDS_DISABLED")
		achievement_button:setEnabled(false)
		achievement_spinner.visible = false
		leaderboards_spinner.visible = true
	end
end

function MainMenu:updateGameCenter(dt, time)
	local achievement_button = self:getChild("gcAchievementButton")
	local leaderboards_button = self:getChild("gcLeaderboardsButton")
	local achievement_spinner = achievement_button:getChild("spinner")
	local leaderboards_spinner = leaderboards_button:getChild("spinner")
	achievement_spinner.angle = achievement_spinner.angle + dt * 10
	leaderboards_spinner.angle = leaderboards_spinner.angle + dt * 10
end

function EpisodeSelection:enableGameCenter()

end

function EpisodeSelection:disableGameCenter()

end

filename="game_center.lua"
