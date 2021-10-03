local addon, ns = ...
local PVPSound = ns.PVPSound
local PS = ns.PS
local L = ns.L

local API = PVPSound.API
local mod
if PS.isRetail then
	mod = API:RegisterMod(112, "pvp", "Eye of the Storm", 566)
else
	mod = API:RegisterMod(1956, "pvp", "Eye of the Storm", 566)
end

local MyZone = "Zone_EyeoftheStorm" -- I don't want to rewrite some code here, so I use this

--------------------------------------------------
-- EOTS Resourses and functions---------------------

-- EOTS POI objectives
local EOTSobjectives = {BloodElfTower = nil, DraeneiRuins = nil, FelReaverRuins = nil, MageTower = nil}

local function FreeResourses()
	EOTSobjectives = {BloodElfTower = nil, DraeneiRuins = nil, FelReaverRuins = nil, MageTower = nil}
end

-- objectives getter
local function EOTSget_objective(id)
	if id == 1941 or id == 1942 or id == 1943 then
		return "BloodElfTower"
	elseif id == 1950 or id == 1951 or id == 1952 then
		return "DraeneiRuins"
	elseif id == 1944 or id == 1945 or id == 1946 then
		return "FelReaverRuins"
	elseif id == 1947 or id == 1948 or id == 1949 then
		return "MageTower"
	else
		return false
	end
end

-- horde attack and alliance attack states should be added for RBG
local function EOTSobj_state(id)
	if id == 1941 or id == 1944 or id == 1947 or id == 1950 then
		return 1 -- Uncontrolled
	elseif id == 1942 or id == 1945 or id == 1948 or id == 1951 then
		return 2 -- Alliance Base
	elseif id == 1943 or id == 1946 or id == 1949 or id == 1952 then
		return 3 -- Horde Base
	else
		return 0
	end
end

--------------------------------------------------
-- on event functions ----------------------------	

function mod:CHAT_MSG_BG_SYSTEM_ALLIANCE(event, EventMessage)
	if string.find(EventMessage, L["Alliance have captured"]) or string.find(EventMessage, L["Horde have captured"]) then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
	end
end

function mod:CHAT_MSG_BG_SYSTEM_HORDE(event, EventMessage)
	if string.find(EventMessage, L["Alliance have captured"]) or string.find(EventMessage, L["Horde have captured"]) then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
	end
end

 -- same as previous two functions, but for RBG
function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, EventMessage)
	if string.find(EventMessage, L["Alliance have captured"]) then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
	elseif string.find(EventMessage, L["Horde have captured"]) then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
	end
end

function mod:AREA_POIS_UPDATED()				
	local CurrentZoneId = self.zoneId
	local POIs = C_AreaPoiInfo.GetAreaPOIForMap(CurrentZoneId)

	for i = 1, #POIs do
		local textureIndex = POIs[i]

		if textureIndex then
			local type = EOTSget_objective(textureIndex)
			if type then
				if EOTSobj_state(EOTSobjectives[type]) == 1 and EOTSobj_state(textureIndex) == 2 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
					-- Alliance Dominating
					local ABases = 0
					for k, v in pairs(EOTSobjectives) do
						if k ~= type and EOTSobj_state(v) == 2 then
							ABases = ABases + 1
						end
					end
					if ABases == 3 then
						if PS_BattlegroundSoundEngine == true then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
						end
					end
				elseif EOTSobj_state(EOTSobjectives[type]) == 1 and EOTSobj_state(textureIndex) == 3 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
					-- Horde Dominating
					local HBases = 0
					for k, v in pairs(EOTSobjectives) do
						if k ~= type and EOTSobj_state(v) == 3 then
							HBases = HBases + 1
						end
					end
					if HBases == 3 then
						if PS_BattlegroundSoundEngine == true then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
						end
					end

				elseif EOTSobj_state(EOTSobjectives[type]) == 2 and EOTSobj_state(textureIndex) == 1 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
				elseif EOTSobj_state(EOTSobjectives[type]) == 3 and EOTSobj_state(textureIndex) == 1 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
				elseif EOTSobj_state(EOTSobjectives[type]) == 2 and EOTSobj_state(textureIndex) == 5 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
				elseif EOTSobj_state(EOTSobjectives[type]) == 3 and EOTSobj_state(textureIndex) == 4 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")

				end
				EOTSobjectives[type] = textureIndex
			end
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
	API.RegisterEvent(self, "CHAT_MSG_BG_SYSTEM_ALLIANCE")
	API.RegisterEvent(self, "CHAT_MSG_BG_SYSTEM_HORDE")
	API.RegisterEvent(self, "CHAT_MSG_RAID_BOSS_EMOTE")	
	API.RegisterEvent(self, "AREA_POIS_UPDATED")
	if PS.isRetail then
		API.RegisterEvent(self, "PVP_MATCH_COMPLETE")
	end
	if not self.loaded then
		API:Announce("BG")
	end
	API:ObjInit(self.zoneId, EOTSobjectives, EOTSget_objective)
	self.loaded = true
end

function mod:Unload()
	API:UnregisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE")
	API:UnregisterEvent("CHAT_MSG_BG_SYSTEM_HORDE")
	API:UnregisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")	
	API:UnregisterEvent("AREA_POIS_UPDATED")
	if PS.isRetail then
		API:UnregisterEvent("PVP_MATCH_COMPLETE")
	end
	FreeResourses()
	self.loaded = false
end