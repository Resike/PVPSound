local addon, ns = ...
local PVPSound = ns.PVPSound
local PS = ns.PS

local API = {}
PVPSound.API = API

----------------------
-- Dumping module info
function API:DumpInfo()
	if self == API then
		PVPSound:Error("Module expected")
	else
		if self.name then
			print("Name: ", self.name)
		end
		if self.zoneId then
			print("Zone id: ", self.zoneId)
		end
		if self.loaded then
			print("Loaded: ", self.loaded)
		end
	end
end

-- Dump all modules with loaded state
function API:DumpModules()
	local i = 1
	for _, v in pairs(PVPSound.modules) do
		print(i, v.name, v.loaded)
		i = i + 1
	end
end

-----------------
-- Event handling

local eventMap = {}
local BGFrame = CreateFrame("Frame", "BGFrame", nil)

BGFrame:SetScript("OnEvent", function(frame, event, ...)
		for k, v in pairs(eventMap[event]) do
			if type(v) == "function" then
				v(event, ...)
			else
				k[v](k, event, ...)
			end
		end
	end)


function API:ShowRegisteredEvents()
	for k, t in pairs(eventMap) do
		print("event: ", k)
		for k, v in pairs(t) do
			print("    module: " , k, " function: ", v)
		end
	end
end

function API:RegisterEvent(event, func)
	-- if func parameter not used, this function should be called via dot operation with module instead self
	-- func parameter should be stand alone function (not table function), because in event handler it will be called like f(event,...)
	-- and event named table function of addon will be called like f(self, event,...)
	if type(event) ~= "string" then
		PVPSound:Error("RegisterEvent: Event name should be string to register it")
		return false
	elseif (not func) and (not self[event]) then
		PVPSound:Error("RegisterEvent: module "..tostring(self).." don't have function named "..event)
		return false	
	elseif func and type(func) ~= "function" then
		PVPSound:Error("RegisterEvent: Function reference expected")
		return false
	end

	if BGFrame then
		BGFrame:RegisterEvent(event)
		if not eventMap[event] then eventMap[event] = {} end
		eventMap[event][self] = func or event
		return true
	else
		PVPSound:Error("RegisterEvent: API frame not initialized")
		return false
	end
end

function API:UnregisterEvent(event)
	if BGFrame and (type(event) == "string") then
		eventMap[event] = nil
		BGFrame:UnregisterEvent(event)
		return true
	elseif type(event) ~= "string" then
		PVPSound:Error("UnregisterEvent: Event name should be string to urregister it")
		return false
	else
		PVPSound:Error("RegisterEvent: API frame not initialized")
		return false
	end
end

function API:UnregisterAllEvents()
	if BGFrame then
		for k, v in pairs(eventMap) do
			BGFrame:UnregisterEvent(k)
			eventMap[k] = nil
		end
		return true
	else
		return false
	end
end

-------------------------------
-- Module registration function

-- zoneId field should be a number. It used to load module for correponding uiMapID
-- pvptype is type (pvp,arena...) and should be a string
-- name also should be a string
-- This func returns table for module
function API:RegisterMod(zoneId, pvptype, name, instId)
	local mod = {}
	mod.name = name or "default_module_name"
	if zoneId and type(zoneId) == "number" then
		mod.zoneId = zoneId
	else
		PVPSound:Error("zone id should be a number to register module "..mod.name)
		return false
	end

	if pvptype and type(pvptype) == "string" then
		mod.type = pvptype
	else
		PVPSound:Error("pvptype should be a string to register module "..mod.name)
		return false
	end

	if instId and type(zoneId) == "number" then
		mod.instId = instId
	elseif instId then
		PVPSound:Error("zinstance id should be a number to register module "..mod.name)
		return false
	else
		mod.instId = nil
	end

	-- default methods and fields
	mod.loaded = false
	function mod:Initialize()
		if not mod.loaded then
			API:Announce("BG")
		end
		mod.loaded = true
	end

	function mod:Unload()
		API:UnregisterAllEvents()
		mod.loaded = false
	end

	PVPSound.modules[zoneId] = mod
	return mod
end

-----------------------------------
-- BG and Arena Team announcer when BG starts
function API:Announce(zone)
	if zone == "BG" then
		local MyFaction
		-- 1 for Alliance
		-- 0 for Horde
		if PS.isRetail then
			MyFaction = GetBattlefieldArenaFaction()
		else
			MyFaction = UnitFactionGroup("player")
			if MyFaction == "Horde" then
				MyFaction = 0
			elseif MyFaction == "Alliance" then
				MyFaction = 1
			end
		end

		if MyFaction == 1 then
			PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\PlayYouAreOnBlue.mp3")
		elseif MyFaction == 0 then
			PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\PlayYouAreOnRed.mp3")
		end
	elseif zone == "Arena" then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\PrepareForBattle.mp3")
	else
		return false
	end
end

-- winner announcer
-- type is BG or Arena
function API:AnnounceWinner(zone, winner)
	print(winner)
	if zone == "BG" then
		if winner == 0 then
			PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeWins.mp3")
		elseif winner == 1 then
			PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceWins.mp3")
		else
			PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HumiliatingDefeat.mp3")
		end
		--BgIsOver = true -- don't know if we need it
		PVPSound:ClearPaybackQueue()
		PVPSound:ClearRetributionQueue()
	elseif zone == "Arena" then
		--local winner = ...
		local myFaction = GetBattlefieldArenaFaction()
		if winner == myFaction then
			PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\YouHaveWonTheMatch.mp3")
		else
			PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\YouHaveLostTheMatch.mp3")
		end
		--BgIsOver = true -- don't know if we need it
		PVPSound:ClearPaybackQueue()
		PVPSound:ClearRetributionQueue()
	else
		return false
	end
end


-----------------
-- Time Remaining

local TimeRemainingobjectives = {TimeRemaining = nil}

local TimerStopped = false	-- for such situations, when world Zone have timer and its timer id is the same as timer id of bg, you just leave

local function TimeRemainingget_objective(id)
	if id then
		return "TimeRemaining"
	else
		return false
	end
end

local function TimeRemainingobj_state(id)
	if id == 5 then
		return 5 -- Time Remaining: 5:59-5:00
	elseif id == 4 then
		return 4 -- Time Remaining: 4:59-4:00
	elseif id == 3 then
		return 3 -- Time Remaining: 3:59-3:00
	elseif id == 2 then
		return 2 -- Time Remaining: 2:59-2:00
	elseif id == 1 then
		return 1 -- Time Remaining: 1:59-1:00
	elseif id == 0 then
		return 0 -- Time Remaining: 0:59-0:00
	else
		return false
	end
end


function API:TimeRemaining_check(id)
	local delay = 20
	if C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(id) and TimerStopped == false then
		local TimeRemaining = tonumber(string.match(C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(id).text, "(%d+)"))
		local state = TimeRemainingobj_state(TimeRemaining)

		if state == false then
			TimeRemainingobjectives.TimeRemaining = TimeRemaining
			C_Timer.After(delay, function() API:TimeRemaining_check(id) end)
		else
			local type = TimeRemainingget_objective(TimeRemaining)
			if type then
				if TimeRemainingobj_state(TimeRemainingobjectives[type]) == 5 and state == 4 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\FiveMinutesRemain.mp3")
					TimeRemainingobjectives[type] = TimeRemaining
					C_Timer.After(delay, function() API:TimeRemaining_check(id) end)
				elseif TimeRemainingobj_state(TimeRemainingobjectives[type]) == 3 and state == 2 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\ThreeMinutesRemain.mp3")
					TimeRemainingobjectives[type] = TimeRemaining
					C_Timer.After(delay, function() API:TimeRemaining_check(id) end)
				elseif TimeRemainingobj_state(TimeRemainingobjectives[type]) == 2 and state == 1 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\TwoMinutesRemain.mp3")
					TimeRemainingobjectives[type] = TimeRemaining
					C_Timer.After(delay, function() API:TimeRemaining_check(id) end)
				elseif TimeRemainingobj_state(TimeRemainingobjectives[type]) == 1 and state == 0 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\OneMinutesRemain.mp3")
					TimeRemainingobjectives[type] = TimeRemaining
				else
					TimeRemainingobjectives[type] = TimeRemaining
					C_Timer.After(delay, function() API:TimeRemaining_check(id) end)
				end

			end
		end
		return true
	else
		return false
	end
end

-- stops all time remaining timers
function API:StopTimers()
	TimerStopped = true
end

-- resets time remaining timers
-- should be used before any timer initialization
function API:ResetTimers()
	TimerStopped = false
end

--------------------------
-- Objective initializator

function API:ObjInit(zoneId, objectives, get, textureMode)
	-- objectives is BG objectives
	-- get is BG objectives getter
	if (not get) or (type(get) ~= "function") then
		PVPSound:Error("Objective initialization: Getter function expected")
		return false
	end
	if objectives and (type(objectives) ~= "table") then
		PVPSound:Error("Objective initialization: objectives should be a table")
		return false
	end
	if zoneId and (type(zoneId) ~= "number") then
		PVPSound:Error("Objective initialization: zone id should be a number")
		return false
	end

	local POIs = C_AreaPoiInfo.GetAreaPOIForMap(zoneId)
	local objective

	--reset all objectives
	for k, v in pairs(objectives) do
		objectives[k] = nil
	end

	for i = 1, #POIs do
	--if texturemod parameter exists, then check textures, else check POI id
	--textureMode = 1 - in case, where objective get and state methods operate with textureID (Arathi basin)
	--textureMode = 2 - in case, where objective get method operates with POI and it's state method operates with textureID (TBFG)
		if textureMode and textureMode == 1 then
			if (C_AreaPoiInfo.GetAreaPOIInfo(zoneId,POIs[i])) then
				objective = get(C_AreaPoiInfo.GetAreaPOIInfo(zoneId,POIs[i]).textureIndex)
			end
		else
			objective = get(POIs[i])
		end

		if objective then
			if textureMode and (textureMode == 1 or textureMode == 2) then
				if (C_AreaPoiInfo.GetAreaPOIInfo(zoneId,POIs[i])) then
					objectives[objective] = C_AreaPoiInfo.GetAreaPOIInfo(zoneId,POIs[i]).textureIndex
				end
			else
				objectives[objective] = POIs[i]
			end
		end
	end
end