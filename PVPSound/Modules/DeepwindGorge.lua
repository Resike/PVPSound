local addon, ns = ...
local PVPSound = ns.PVPSound
local PVPSoundOptions = ns.PVPSoundOptions
local PS = ns.PS
local L = ns.L

local API = PVPSound.API
local mod = API:RegisterMod(1576, "pvp", "Deepwind Gorge", 1105)

local MyZone = "Zone_DeepwindGorge" -- I don't want to rewrite some code here, so I use this

-------------------------------------------------
-- Resourses and functions---------------------

-- POI objectives
local DGobjectives = {Market = nil, Farm = nil, Ruins = nil, Shrine = nil, Quarry = nil}

local function DGget_objective(id)
	if id >= 16 and id <= 20 then
		return "Quarry"
	elseif id >= 31 and id <= 34 then
		return "Farm"
	elseif id >= 205 and id <= 209 then
		return "Market"
	elseif id >= 210 and id <= 214 then
		return "Ruins"
	elseif id >= 215 and id <= 219 then
		return "Shrine"
	else
		return false
	end
end

local function DGobj_state(id)
	if id == 18 or id == 33 or id == 205 or id == 210 or id == 215 then
		return 1 -- Alliance Bases
	elseif id == 20 or id == 35 or id == 206 or id == 211 or id == 216 then
		return 2 -- Horde Bases
	elseif id == 17 or id == 32 or id == 208 or id == 213 or id == 218 then
		return 3 -- Alliance trys to capture
	elseif id == 19 or id == 34 or id == 209 or id == 214 or id == 219 then
		return 4 -- Horde trys to capture
	else
		return 0
	end
end

local function FreeResourses()
	DGobjectives = {Market = nil, Farm = nil, Ruins = nil, Shrine = nil, Quarry = nil}
end

--------------------------------------------------
-- on event functions ----------------------------	

function mod:AREA_POIS_UPDATED()
	local CurrentZoneId = self.zoneId	
	local POIs = C_AreaPoiInfo.GetAreaPOIForMap(CurrentZoneId)

	for i = 1, #POIs do
		local textureIndex = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
		if textureIndex then
			local type = DGget_objective(textureIndex)
			if type then
				if DGobj_state(DGobjectives[type]) == 3 and DGobj_state(textureIndex) == 1 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
					-- Alliance Dominating
					local ABases = 0
					for k, v in pairs(DGobjectives) do
						if k ~= type and DGobj_state(v) == 1 then
							ABases = ABases + 1
						end
					end
					if ABases == 4 then
						if PS_BattlegroundSoundEngine == true then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
						end
					end

				elseif DGobj_state(DGobjectives[type]) == 4 and DGobj_state(textureIndex) == 2 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
					-- Horde Dominating
					local HBases = 0
					for k, v in pairs(DGobjectives) do
						if k ~= type and DGobj_state(v) == 2 then
							HBases = HBases + 1
						end
					end
					if HBases == 4 then
						if PS_BattlegroundSoundEngine == true then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
						end
					end
				elseif DGobj_state(DGobjectives[type]) == 4 and DGobj_state(textureIndex) == 1 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
					-- Alliance Dominating
					local ABases = 0
					for k, v in pairs(DGobjectives) do
						if k ~= type and DGobj_state(v) == 1 then
							ABases = ABases + 1
						end
					end
					if ABases == 4 then
						if PS_BattlegroundSoundEngine == true then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
						end
					end
				elseif DGobj_state(DGobjectives[type]) == 3 and DGobj_state(textureIndex) == 2 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
					-- Horde Dominating
					local HBases = 0
					for k, v in pairs(DGobjectives) do
						if k ~= type and DGobj_state(v) == 2 then
							HBases = HBases + 1
						end
					end
					if HBases == 4 then
						if PS_BattlegroundSoundEngine == true then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
						end
					end
				elseif DGobj_state(DGobjectives[type]) == 1 and DGobj_state(textureIndex) == 4 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
				elseif DGobj_state(DGobjectives[type]) == 2 and DGobj_state(textureIndex) == 3 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
				elseif DGobj_state(DGobjectives[type]) == 3 and DGobj_state(textureIndex) == 4 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
				elseif DGobj_state(DGobjectives[type]) == 4 and DGobj_state(textureIndex) == 3 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
				end
				DGobjectives[type] = textureIndex
			end
		end
	end
end

function mod:PVP_MATCH_COMPLETE(event, winner)
	API:AnnounceWinner("BG", winner)
	self:Unload()
end

--------------------------------------------------
-- module start and end poins --------------------
function mod:Initialize()
	API.RegisterEvent(self, "PVP_MATCH_COMPLETE")
	API.RegisterEvent(self, "AREA_POIS_UPDATED")
	if not self.loaded then
		API:AnnounceBG()
	end
	ObjInit(self.zoneId, DGobjectives, DGget_objective, 2)
	self.loaded = true
end

function mod:Unload()
	API:UnregisterEvent("PVP_MATCH_COMPLETE")
	API:UnregisterEvent("AREA_POIS_UPDATED")
	FreeResourses()
	self.loaded = false
end	