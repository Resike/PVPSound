local addon, ns = ...
local PVPSound = ns.PVPSound
local PVPSoundOptions = ns.PVPSoundOptions
local PS = ns.PS
local L = ns.L

local API = PVPSound.API
local mod = API:RegisterMod(1366, "pvp", "Arathi Basin", 2107)
local mod_w = API:RegisterMod(837, "pvp", "Arathi Basin Winter", 1681)


local MyZone = "Zone_ArathiBasin" -- I don't want to rewrite some code here, so I use this

--------------------------------------------------
-- AB Resourses and functions---------------------

-- AB POI objectives
local ABobjectives = {Blacksmith = nil, Farm = nil, GoldMine = nil, LumberMill = nil, Stables = nil}

local function FreeResourses()
	ABobjectives = {Blacksmith = nil, Farm = nil, GoldMine = nil, LumberMill = nil, Stables = nil}
end
-- objectives getter
local function ABget_objective(id)
	if id >= 26 and id <= 30 then
		return "Blacksmith"
	elseif id >= 31 and id <= 35 then
		return "Farm"
	elseif id >= 16 and id <= 20 then
		return "GoldMine"
	elseif id >= 21 and id <= 25 then
		return "LumberMill"
	elseif id >= 36 and id <= 40 then
		return "Stables"
	else
		return false
	end
end

local function ABobj_state(id)
	if id == 28 or id == 33 or id == 18 or id == 23 or id == 38 then
		return 1 -- Alliance Bases
	elseif id == 30 or id == 35 or id == 20 or id == 25 or id == 40 then
		return 2 -- Horde Bases
	elseif id == 27 or id == 32 or id == 17 or id == 22 or id == 37 then
		return 3 -- Alliance trys to capture
	elseif id == 29 or id == 34 or id == 19 or id == 24 or id == 39 then
		return 4 -- Horde trys to capture
	else
		return 0
	end
end
	
--------------------------------------------------
-- on event functions ----------------------------	
	
function mod:AREA_POIS_UPDATED()
	local CurrentZoneId = self.zoneId
	PVPSound:Debug("zoneId: "..CurrentZoneId)
	local POIs = C_AreaPoiInfo.GetAreaPOIForMap(CurrentZoneId)
	
	
	for i = 1, #POIs do
		local textureIndex
		if C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]) then
			textureIndex = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
		end
		if textureIndex then
			local type = ABget_objective(textureIndex)
			if type then
				if ABobj_state(ABobjectives[type]) == 3 and ABobj_state(textureIndex) == 1 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
					-- Alliance Dominating
					local ABases = 0
					for k, v in pairs(ABobjectives) do
						if k ~= type and ABobj_state(v) == 1 then
							ABases = ABases + 1
						end
					end

					if ABases == 4 then
						if PS_BattlegroundSoundEngine == true then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
						end
					end
	
				elseif ABobj_state(ABobjectives[type]) == 4 and ABobj_state(textureIndex) == 2 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
					-- Horde Dominating
					local HBases = 0
					for k, v in pairs(ABobjectives) do
						if k ~= type and ABobj_state(v) == 2 then
							HBases = HBases + 1
						end
					end

					if HBases == 4 then
						if PS_BattlegroundSoundEngine == true then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
						end
					end
				elseif ABobj_state(ABobjectives[type]) == 4 and ABobj_state(textureIndex) == 1 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
					-- Alliance Dominating
					local ABases = 0
					for k, v in pairs(ABobjectives) do
						if k ~= type and ABobj_state(v) == 1 then
							ABases = ABases + 1
						end
					end

					if ABases == 4 then
						if PS_BattlegroundSoundEngine == true then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
						end
					end
				elseif ABobj_state(ABobjectives[type]) == 3 and ABobj_state(textureIndex) == 2 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
					-- Horde Dominating
					local HBases = 0
					for k, v in pairs(ABobjectives) do
						if k ~= type and ABobj_state(v) == 2 then
							HBases = HBases + 1
						end
					end

					if HBases == 4 then
						if PS_BattlegroundSoundEngine == true then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
						end
					end
				elseif ABobj_state(ABobjectives[type]) == 1 and ABobj_state(textureIndex) == 4 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
				elseif ABobj_state(ABobjectives[type]) == 2 and ABobj_state(textureIndex) == 3 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
				elseif ABobj_state(ABobjectives[type]) == 3 and ABobj_state(textureIndex) == 4 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
				elseif ABobj_state(ABobjectives[type]) == 4 and ABobj_state(textureIndex) == 3 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
				end
				ABobjectives[type] = textureIndex
			end
		end
	end
end
mod_w.AREA_POIS_UPDATED = mod.AREA_POIS_UPDATED

function mod:PVP_MATCH_COMPLETE(event, winner)
	API:AnnounceWinner("BG", winner)
	self:Unload()
end
mod_w.PVP_MATCH_COMPLETE = mod.PVP_MATCH_COMPLETE

--------------------------------------------------
-- module start and end poins --------------------
function mod:Initialize()
	API.RegisterEvent(self, "PVP_MATCH_COMPLETE")
	API.RegisterEvent(self, "AREA_POIS_UPDATED")
	PVPSound:Debug(self.loaded)
	if not self.loaded then
		API:AnnounceBG()
	end
	API:ObjInit(self.zoneId, ABobjectives, ABget_objective, 1)
	self.loaded = true
end
mod_w.Initialize = mod.Initialize

function mod:Unload()
	API:UnregisterEvent("PVP_MATCH_COMPLETE")
	API:UnregisterEvent("AREA_POIS_UPDATED")
	FreeResourses()
	self.loaded = false
end
mod_w.Unload = mod.Unload