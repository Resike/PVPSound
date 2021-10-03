local addon, ns = ...
local PVPSound = ns.PVPSound
local PS = ns.PS
local L = ns.L

local API = PVPSound.API
local mod = API:RegisterMod(1334, "pvp", "Wintergrasp", 2118)
local modBF = API:RegisterMod(123, "None", "Wintergrasp Battlefield", nil)

local MyZone = "Zone_Wintergrasp" -- I don't want to rewrite some code here, so I use this

-- There is alot of wiered (is active check, is BG over check, check for win via POI and so on) code here, because BF version is stil supported,

--------------------------------------------------
-- Resourses and functions---------------------
local BgIsOver
local WgAttacker
local WGobjectives = {FlamewatchTower = nil, ShadowsightTower = nil, WintersEdgeTower = nil, WintergraspFortressTowerNE = nil, WintergraspFortressTowerNW = nil, WintergraspFortressTowerSE = nil, WintergraspFortressTowerSW = nil, WintergraspFortress = nil, TowerWalls = nil}

--We have pairs of IDs because BG and battlefield versions have different IDs
--6XXX for BG, 2XXX for BF
local function WGget_objective(id)
	if id == 6066 or id == 2143 then
		return "FlamewatchTower"
	elseif id == 6067 or id == 2141 then
		return "ShadowsightTower"
	elseif id == 6065 or id == 2142 then
		return "WintersEdgeTower"
	elseif id == 6053 or id == 2146 then
		return "WintergraspFortressTowerNE"
	elseif id == 6052 or id == 2147 then
		return "WintergraspFortressTowerNW"
	elseif id == 6054 or id == 2145 then
		return "WintergraspFortressTowerSE"
	elseif id == 6055 or id == 2144 then
		return "WintergraspFortressTowerSW"
	elseif id == 2222 or id == 2223 or id == 2224 or id == 2225 or id == 2226 or id == 2227 or id == 2228 or id == 2230 or id == 2231 or id == 2232 or
		id == 2233 or id == 2234 or id == 2235 or id == 2236 or id == 2237 or id == 2238 or id == 2239 or id == 2240 or id == 2241 or id == 2242 or id == 2243 or id == 2244 or
		id == 2245 or id == 6028 or id == 6029 or id == 6030 or id == 6031 or id == 6032 or id == 6033 or id == 6034 or id == 6035 or id == 6036 or id == 6037 or id == 6038 or
		id == 6039 or id == 6040 or id == 6041 or id == 6042 or id == 6043 or id == 6045 or id == 6046 or id == 6047 or id == 6048 or id == 6049 or id == 6050 or id == 6051 or
		id == 2229 or id == 6056 then --these two ids are for WG gates
		return "TowerWalls"
	elseif id == 2246 or id == 6027 then
		return "WintergraspFortress"
	else
		return false
	end
end

local function WGobj_state(id)
	if id == 11 then
		return 1 -- Alliance Towers Undamaged
	elseif id == 10 then
		return 2 -- Horde Towers Undamaged
	elseif id == 50 then
		return 3 -- Alliance Towers Heavily Damaged
	elseif id == 51 then
		return 4 -- Alliance Towers Destroyed
	elseif id == 52 then
		return 5 -- Horde Towers Heavily Damaged
	elseif id == 53 then
		return 6 -- Horde Towers Destroyed
	elseif id == 88 or id == 91 or id == 97 or id == 100 or id == 79 or id == 82 then
		return 9 -- Walls destroyed
	elseif id == 77 or id == 78 or id == 80 or id == 81 then
		return 10 -- fortress is ok
	elseif id == 79 or id == 82 then
		return 11 -- fortrss destroyed
	else
		return 0
	end
end

local function FreeResourses()
	BgIsOver = nil
	WgAttacker = nil
	WGobjectives = {FlamewatchTower = nil, ShadowsightTower = nil, WintersEdgeTower = nil, WintergraspFortressTowerNE = nil, WintergraspFortressTowerNW = nil, WintergraspFortressTowerSE = nil, WintergraspFortressTowerSW = nil, WintergraspFortress = nil, TowerWalls = nil}
end

-- check is active or not
-- mostly needed for BF versions
local function IsActive(zoneId)
	if zoneId == 123 and (select(5, GetWorldPVPAreaInfo(1))) == 0 then
		return true
	elseif zoneId == 1334 then
		return true
	else
		return false
	end
end

-- Custom objective initializer (for walls counting)
local function ObjectiveInitialize(zoneId)
	local POIs = C_AreaPoiInfo.GetAreaPOIForMap(zoneId)

	local FlamewatchTowerInit
	local ShadowsightTowerInit
	local WintersEdgeTowerInit
	local WintergraspFortressTowerNEInit
	local WintergraspFortressTowerNWInit
	local WintergraspFortressTowerSEInit
	local WintergraspFortressTowerSWInit
	local TowerWallsInit = 0
	local WintergraspFortressInit

	for i = 1, #POIs do
		if WGget_objective(POIs[i]) == "FlamewatchTower" then
			FlamewatchTowerInit = C_AreaPoiInfo.GetAreaPOIInfo(zoneId,POIs[i]).textureIndex
		elseif WGget_objective(POIs[i]) == "ShadowsightTower" then
			ShadowsightTowerInit = C_AreaPoiInfo.GetAreaPOIInfo(zoneId,POIs[i]).textureIndex
		elseif WGget_objective(POIs[i]) == "WintersEdgeTower" then
			WintersEdgeTowerInit = C_AreaPoiInfo.GetAreaPOIInfo(zoneId,POIs[i]).textureIndex
		elseif WGget_objective(POIs[i]) == "WintergraspFortressTowerNE" then
			WintergraspFortressTowerNEInit = C_AreaPoiInfo.GetAreaPOIInfo(zoneId,POIs[i]).textureIndex
		elseif WGget_objective(POIs[i]) == "WintergraspFortressTowerNW" then
			WintergraspFortressTowerNWInit = C_AreaPoiInfo.GetAreaPOIInfo(zoneId,POIs[i]).textureIndex
		elseif WGget_objective(POIs[i]) == "WintergraspFortressTowerSE" then
			WintergraspFortressTowerSEInit = C_AreaPoiInfo.GetAreaPOIInfo(zoneId,POIs[i]).textureIndex
		elseif WGget_objective(POIs[i]) == "WintergraspFortressTowerSW" then
			WintergraspFortressTowerSWInit = C_AreaPoiInfo.GetAreaPOIInfo(zoneId,POIs[i]).textureIndex
		elseif WGget_objective(POIs[i]) == "TowerWalls" then
			if WGobj_state(C_AreaPoiInfo.GetAreaPOIInfo(zoneId,POIs[i]).textureIndex) == 9 then
				TowerWallsInit = TowerWallsInit + 1
			end
		elseif WGget_objective(POIs[i]) == "WintergraspFortress" then
			WintergraspFortressInit = C_AreaPoiInfo.GetAreaPOIInfo(zoneId,POIs[i]).textureIndex
		end
	end

	WGobjectives.FlamewatchTower = nil
	WGobjectives.ShadowsightTower = nil
	WGobjectives.WintersEdgeTower = nil
	WGobjectives.WintergraspFortressTowerNE = nil
	WGobjectives.WintergraspFortressTowerNW = nil
	WGobjectives.WintergraspFortressTowerSE = nil
	WGobjectives.WintergraspFortressTowerSW = nil
	WGobjectives.TowerWalls = nil
	if FlamewatchTowerInit then
		WGobjectives.FlamewatchTower = FlamewatchTowerInit
	end
	if ShadowsightTowerInit then
		WGobjectives.ShadowsightTower = ShadowsightTowerInit

	end
	if WintersEdgeTowerInit then
		WGobjectives.WintersEdgeTower = WintersEdgeTowerInit

	end
	if WintergraspFortressTowerNEInit then
		WGobjectives.WintergraspFortressTowerNE = WintergraspFortressTowerNEInit

	end
	if WintergraspFortressTowerNWInit then
		WGobjectives.WintergraspFortressTowerNW = WintergraspFortressTowerNWInit

	end
	if WintergraspFortressTowerSEInit then
		WGobjectives.WintergraspFortressTowerSE = WintergraspFortressTowerSEInit

	end
	if WintergraspFortressTowerSWInit then
		WGobjectives.WintergraspFortressTowerSW = WintergraspFortressTowerSWInit
	end
	if TowerWallsInit then
		WGobjectives.TowerWalls = TowerWallsInit
	end
	if WintergraspFortressInit then
		WGobjectives.WintergraspFortress = WintergraspFortressInit
	end

end

-- Custom BG announcer
local function AnnounceBG(zoneId)
	local MyFaction = UnitFactionGroup("player")
	--check texture for west fortress workshop
	--if it's blue - alliance defended
	--else - horde
	--2150 - fortress in BF version, 6074 - in BG version
	local textureIndex
	if zoneId == 123 then
		textureIndex = C_AreaPoiInfo.GetAreaPOIInfo(zoneId,2150).textureIndex
	else
		textureIndex = C_AreaPoiInfo.GetAreaPOIInfo(zoneId,6074).textureIndex
	end
	if textureIndex then
		if textureIndex == 68 then
			WgAttacker = "Alliance"
		elseif textureIndex == 71 then
			WgAttacker = "Horde"
		end
	end

	if WgAttacker == "Alliance" and MyFaction == "Alliance" then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\PlayYouAreOnBlueAttackTheEnemyCore.mp3")
	elseif WgAttacker == "Alliance" and MyFaction == "Horde" then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\PlayYouAreOnRedDefendYourCore.mp3")
	elseif WgAttacker == "Horde" and MyFaction == "Alliance" then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\PlayYouAreOnBlueDefendYourCore.mp3")
	elseif WgAttacker == "Horde" and MyFaction == "Horde" then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\PlayYouAreOnRedAttackTheEnemyCore.mp3")
	end
end

--------------------------------------------------
-- on event functions ----------------------------

function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, EventMessage)
	-- WinSounds (only for BF version)
	if string.find(EventMessage, L["Alliance has defended"]) and BgIsOver ~= true then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceWins.mp3")
		BgIsOver = true
		mod:Unload()
	elseif string.find(EventMessage, L["Horde has defended"]) and BgIsOver ~= true then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeWins.mp3")
		BgIsOver = true
		mod:Unload()
	end

	-- Workshops
	if string.find(EventMessage, L["workshop has been attacked by the Alliance"]) then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
	elseif string.find(EventMessage, L["workshop has been captured by the Alliance"]) then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
	elseif string.find(EventMessage, L["workshop has been attacked by the Horde"]) then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
	elseif string.find(EventMessage, L["workshop has been captured by the Horde"]) then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
	end
end
modBF.CHAT_MSG_RAID_BOSS_EMOTE = mod.CHAT_MSG_RAID_BOSS_EMOTE

function mod:AREA_POIS_UPDATED()
	local POIs = C_AreaPoiInfo.GetAreaPOIForMap(self.zoneId)
	local destroyedWalls = 0
	for i = 0, #POIs do
		local type = WGget_objective(POIs[i])
		if type and type ~= "TowerWalls" then
			local textureIndex = C_AreaPoiInfo.GetAreaPOIInfo(self.zoneId,POIs[i]).textureIndex
			if WGobj_state(WGobjectives[type]) == 1 and WGobj_state(textureIndex) == 3 then
				PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_HeavilyDamaged.mp3")
			elseif WGobj_state(WGobjectives[type]) == 3 and WGobj_state(textureIndex) == 4 then
				PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Destroyed.mp3")
			elseif WGobj_state(WGobjectives[type]) == 2 and WGobj_state(textureIndex) == 5 then
				PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_HeavilyDamaged.mp3")
			elseif WGobj_state(WGobjectives[type]) == 5 and WGobj_state(textureIndex) == 6 then
				PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Destroyed.mp3")
			elseif WGobj_state(WGobjectives[type]) == 10 and WGobj_state(textureIndex) == 11 then --this only used for battlefield version
				if WgAttacker == "Horde" then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeWins.mp3")
				else
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceWins.mp3")
				end
				BgIsOver = true
				mod:Unload()
			end
			WGobjectives[type] = textureIndex
		elseif type == "TowerWalls" then
			if WGobj_state(C_AreaPoiInfo.GetAreaPOIInfo(self.zoneId,POIs[i]).textureIndex) == 9 then
				destroyedWalls = destroyedWalls + 1
			end
		end
	end
	if destroyedWalls > WGobjectives.TowerWalls then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\BarricadeDestroyed.mp3")
		WGobjectives.TowerWalls = destroyedWalls
	end
end
modBF.AREA_POIS_UPDATED = mod.AREA_POIS_UPDATED

function mod:PVP_MATCH_COMPLETE(event, winner)
	API:AnnounceWinner("BG", winner)
	mod:Unload()
end
modBF.PVP_MATCH_COMPLETE = mod.PVP_MATCH_COMPLETE

--------------------------------------------------
-- module start and end poins --------------------
function mod:Initialize()
	if IsActive(self.zoneId) then
		API.RegisterEvent(self, "PVP_MATCH_COMPLETE")
		API.RegisterEvent(self, "AREA_POIS_UPDATED")
		API.RegisterEvent(self, "CHAT_MSG_RAID_BOSS_EMOTE")
		ObjectiveInitialize(self.zoneId)
		BgIsOver = false
		PS.PaybackKillTime = 120
		if not self.loaded then
			AnnounceBG(self.zoneId)
		end
		self.loaded = true
	end
end
modBF.Initialize = mod.Initialize

function mod:Unload()
	PS.PaybackKillTime = 90
	API:UnregisterEvent("PVP_MATCH_COMPLETE")
	API:UnregisterEvent("AREA_POIS_UPDATED")
	API:UnregisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	FreeResourses()
	self.loaded = false
end
modBF.Unload = mod.Unload