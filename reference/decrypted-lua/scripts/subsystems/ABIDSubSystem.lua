ABIDSubSystem = gamelua.subsystems.SubSystem:new()

function ABIDSubSystem:eventTriggered(event)
	local events = gamelua.events
	if event.id == events.EID_ABID_CLICKED then
		gamelua.utils.ABSync.login()
	end

	if event.id == events.EID_GAME_INITIALIZED then
		--utils.ABSync.bootstrap(localSettings.ABIDrefreshToken)
		if gamelua.localSettings ~= nil then
			gamelua.utils.ABSync.bootstrap(gamelua.localSettings.ABIDrefreshToken)
		else
			gamelua.logwarning("ABIDSubSystem: could not bootstrap since localSettings does not exist.")
		end
	end
	
	if event.id == events.EID_GAME_PAUSED then
		if gamelua.deviceModel ~= "android" then
			-- sync synchronously to ensure that the operation completes
			gamelua.utils.ABSync.syncStates()
		end
	end
	
	if event.id == events.EID_GAME_RESUMED then
		self.attemptToSync = true
	end

end


function ABIDSubSystem:update(dt,time)
	if self.attemptToSync == true then
		--print("Synchronizing states [called from update()]\n")
		
		gamelua.utils.ABSync.syncStates()
		self.attemptToSync = false
	end
end
filename="ABIDSubSystem.lua"
