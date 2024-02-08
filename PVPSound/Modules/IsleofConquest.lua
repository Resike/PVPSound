local addon, ns = ...
local PVPSound = ns.PVPSound
local PS = ns.PS

local API = PVPSound.API
local mod = API:RegisterMod(169, "pvp", "Isle of Conquest", 628)

local MyZone = "Zone_IsleofConquest" -- I don't want to rewrite some code here, so I use this

--------------------------------------------------
-- IoC Resourses and functions---------------------

-- IoC POI objectives
local IOCobjectives = {AllianceGateE = nil, AllianceGateW = nil, AllianceGateS = nil, HordeGateE = nil, HordeGateW = nil, HordeGateN = nil, Quarry = nil, Workshop = nil, Hangar = nil, Docks = nil, Refinerie = nil, HordeKeep = nil, AllianceKeep = nil}
-- IoC gates status
local IocAllianceGateDown
local IocHordeGateDown

-- objective getter
local function IOCget_objective(id)
	if id >= 2361 and id <= 2365 then
		return "Quarry"
	elseif id >= 2345 and id <= 2349 then
		return "Workshop"
	elseif id >= 2350 and id <= 2355 then
		return "Hangar"
	elseif id >= 2356 and id <= 2360 then
		return "Docks"
	elseif id >= 2366 and id <= 2370 then
		return "Refinerie"
	elseif id == 2377 or id == 2379 then
		return "AllianceGateE"
	elseif id == 2380 or id == 2381 then
		return "AllianceGateW"
	elseif id == 2378 or id == 2382 then
		return "AllianceGateS"
	elseif id == 2373 or id == 2374 then
		return "HordeGateE"
	elseif id == 2375 or id == 2376 then
		return "HordeGateW"
	elseif id == 2371 or id == 2372 then
		return "HordeGateN"
	elseif id >= 2388 and id <= 2392 then
		return "HordeKeep"
	elseif id >= 2383 and id <= 2387 then
		return "AllianceKeep"
	else
		return false
	end
end

local function IOCobj_state(id)
	if id == 2345 or id == 2350 or id == 2358 or id == 2362 or id == 2367 or id == 2384 or id == 2389 then
		return 1 -- Alliance Bases
	elseif id == 2346 or id == 2352 or id == 2357 or id == 2363 or id == 2366 or id == 2387 or id == 2388 then
		return 2 -- Horde Bases
	elseif id == 2347 or id == 2353 or id == 2356 or id == 2364 or id == 2369 or id == 2385 or id == 2390 then
		return 3 -- Alliance trys to capture
	elseif id == 2348 or id == 2354 or id == 2359 or id == 2365 or id == 2368 or id == 2386 or id == 2391 then
		return 4 -- Horde trys to capture
	elseif id == 2377 or id == 2380 or id == 2382 then
		return 5 -- Alliance Gate Undamaged
	elseif id == 2371 or id == 2373 or id == 2375 then
		return 6 -- Horde Gate Undamaged
	elseif id == 2378 or id == 2379 or id == 2381 then
		return 7 -- Alliance Gate Destroyed
	elseif id == 2372 or id == 2374 or id == 2376 then
		return 8 -- Horde Gate Destroyed
	else
		return 0
	end
end

-- Alliance Reinforcements
local AVandIOCAobjectives = {AllianceReinforcements = nil}

local function AVandIOCAget_objective(id)
	if id then
		return "AllianceReinforcements"
	else
		return false
	end
end

local function AVandIOCAobj_state(id)
	if id == 11 then
		return 11 -- Reinforcements: 11
	elseif id == 10 then
		return 10 -- Reinforcements: 10
	elseif id == 6 then
		return 6 -- Reinforcements: 6
	elseif id == 5 then
		return 5 -- Reinforcements: 5
	elseif id == 2 then
		return 2 -- Reinforcements: 2
	elseif id == 1 then
		return 1 -- Reinforcements: 1
	else
		return 0
	end
end

-- Horde Reinforcements
local AVandIOCHobjectives = {HordeReinforcements = nil}

local function AVandIOCHget_objective(id)
	if id then
		return "HordeReinforcements"
	else
		return false
	end
end

local function AVandIOCHobj_state(id)
	if id == 11 then
		return 1 -- Reinforcements: 11
	elseif id == 10 then
		return 2 -- Reinforcements: 10
	elseif id == 6 then
		return 3 -- Reinforcements: 6
	elseif id == 5 then
		return 4 -- Reinforcements: 5
	elseif id == 2 then
		return 5 -- Reinforcements: 2
	elseif id == 1 then
		return 6 -- Reinforcements: 1
	else
		return 0
	end
end

-- reinforcements initialization
local function InitReinforcements()
	local AReinforcementsInit = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1685) and C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1685).leftBarValue
	local HReinforcementsInit = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1685) and C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1685).rightBarValue
	AVandIOCAobjectives.AllianceReinforcements = nil
	AVandIOCHobjectives.HordeReinforcements = nil
	AVandIOCAobjectives.AllianceReinforcements = AReinforcementsInit
	AVandIOCHobjectives.HordeReinforcements = HReinforcementsInit
end

local function FreeResourses()
	IOCobjectives = {AllianceGateE = nil, AllianceGateW = nil, AllianceGateS = nil, HordeGateE = nil, HordeGateW = nil, HordeGateN = nil, Quarry = nil, Workshop = nil, Hangar = nil, Docks = nil, Refinerie = nil, HordeKeep = nil, AllianceKeep = nil}
	IocAllianceGateDown = nil
	IocHordeGateDown = nil
	AVandIOCAobjectives = {AllianceReinforcements = nil}
	AVandIOCHobjectives = {HordeReinforcements = nil}
end

--------------------------------------------------
-- on event functions ----------------------------

function mod:AREA_POIS_UPDATED()
	local CurrentZoneId = self.zoneId
	local POIs = C_AreaPoiInfo.GetAreaPOIForMap(CurrentZoneId)

	-- marked table
	local marked = {}

	-- if POI number greater then 13 (normal value)
	-- mark duplicate POI by counting each objective type
	-- if objective have counter==2 then don't check objective state change and don't play sounds for it
	if #POIs ~= 13 then
		--find and mark duplicated POI
		for k, v in pairs(IOCobjectives) do
			--initialize
			marked[k] = 0
		end
		for i = 1, #POIs do
			--obj counter
			marked[IOCget_objective(POIs[i])] = marked[IOCget_objective(POIs[i])] + 1
		end
	end

	for i = 1, #POIs do
		local type = IOCget_objective(POIs[i])
		if type and (marked[type]~=2) then
			local textureIndex = POIs[i]
			if textureIndex then
				if IOCobj_state(IOCobjectives[type]) == 5 and IOCobj_state(textureIndex) == 7 then
					if IocAllianceGateDown ~= true then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\BarricadeDestroyedBlueCoreIsVulnerable.mp3")
						IocAllianceGateDown = true
					end
				elseif IOCobj_state(IOCobjectives[type]) == 6 and IOCobj_state(textureIndex) == 8 then
					if IocHordeGateDown ~= true then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\BarricadeDestroyedRedCoreIsVulnerable.mp3")
						IocHordeGateDown = true
					end
				elseif IOCobj_state(IOCobjectives[type]) == 3 and IOCobj_state(textureIndex) == 1 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
				elseif IOCobj_state(IOCobjectives[type]) == 3 and IOCobj_state(textureIndex) == 2 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
				elseif IOCobj_state(IOCobjectives[type]) == 4 and IOCobj_state(textureIndex) == 2 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
				elseif IOCobj_state(IOCobjectives[type]) == 4 and IOCobj_state(textureIndex) == 1 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
				elseif IOCobj_state(IOCobjectives[type]) == 1 and IOCobj_state(textureIndex) == 4 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
				elseif IOCobj_state(IOCobjectives[type]) == 2 and IOCobj_state(textureIndex) == 3 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
				elseif IOCobj_state(IOCobjectives[type]) == 3 and IOCobj_state(textureIndex) == 4 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
				elseif IOCobj_state(IOCobjectives[type]) == 4 and IOCobj_state(textureIndex) == 3 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
				end
				IOCobjectives[type] = textureIndex
			end
		end
	end
end

function mod:UPDATE_UI_WIDGET()
	if (C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1685)) then
		local textureIndex = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1685).leftBarValue
		local type = AVandIOCAget_objective(textureIndex)
		if type then
			if AVandIOCAobj_state(AVandIOCAobjectives[type]) == 11 and AVandIOCAobj_state(textureIndex) == 10 then
				PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\TenKillsRemain.mp3")
			elseif AVandIOCAobj_state(AVandIOCAobjectives[type]) == 6 and AVandIOCAobj_state(textureIndex) == 5 then
				PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\FiveKillsRemain.mp3")
			elseif AVandIOCAobj_state(AVandIOCAobjectives[type]) == 2 and AVandIOCAobj_state(textureIndex) == 1 then
				PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\OneKillRemains.mp3")
			end
			AVandIOCAobjectives[type] = textureIndex
		end
	-- Horde Reinforcements
		textureIndex = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1685).rightBarValue
		type = AVandIOCHget_objective(textureIndex)
		if type then
			if AVandIOCHobj_state(AVandIOCHobjectives[type]) == 11 and AVandIOCHobj_state(textureIndex) == 10 then
				PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\TenKillsRemain.mp3")
			elseif AVandIOCHobj_state(AVandIOCHobjectives[type]) == 6 and AVandIOCHobj_state(textureIndex) == 5 then
				PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\FiveKillsRemain.mp3")
			elseif AVandIOCHobj_state(AVandIOCHobjectives[type]) == 2 and AVandIOCHobj_state(textureIndex) == 1 then
				PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\OneKillRemains.mp3")
			end
			AVandIOCHobjectives[type] = textureIndex
		end
	end
end

function mod:PVP_MATCH_COMPLETE(event, winner)
	API:AnnounceWinner("BG", winner)
	mod:Unload()
end

--------------------------------------------------
-- module start and end poins --------------------
function mod:Initialize()
	API.RegisterEvent(self, "PVP_MATCH_COMPLETE")
	API.RegisterEvent(self, "AREA_POIS_UPDATED")
	API.RegisterEvent(self, "UPDATE_UI_WIDGET")
	if not self.loaded then
		API:Announce("BG")
	end
	PS.PaybackKillTime = 120
	InitReinforcements()
	IocAllianceGateDown = false
	IocHordeGateDown = false
	API:ObjInit(self.zoneId, IOCobjectives, IOCget_objective)
	if IOCobj_state(IOCobjectives.HordeGateE) == 8 or IOCobj_state(IOCobjectives.HordeGateW) == 8 or IOCobj_state(IOCobjectives.HordeGateN) == 8 then
		IocHordeGateDown = true
	end
	if IOCobj_state(IOCobjectives.AllianceGateE) == 7 or IOCobj_state(IOCobjectives.AllianceGateW) == 7 or IOCobj_state(IOCobjectives.AllianceGateS) == 7 then
		IocAllianceGateDown = true
	end
	self.loaded = true
end

function mod:Unload()
	PS.PaybackKillTime = 90
	API:UnregisterEvent("PVP_MATCH_COMPLETE")
	API:UnregisterEvent("AREA_POIS_UPDATED")
	API:UnregisterEvent("UPDATE_UI_WIDGET")
	FreeResourses()
	self.loaded = false
end
