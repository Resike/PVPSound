local addon, ns = ...
local PVPSound = ns.PVPSound
local PS = ns.PS

local API = PVPSound.API
local mod = API:RegisterMod(275, "pvp", "The Battle for Gilneas", 761)

local MyZone = "Zone_TheBattleforGilneas" -- I don't want to rewrite some code here, so I use this

--------------------------------------------------
-- Resourses and functions---------------------

-- POI objectives
local TBFGobjectives = {Lighthouse = nil, Mines = nil, Waterworks = nil}

local function TBFGget_objective(id)
	if id == 2412 then
		return "Lighthouse"
	elseif id == 2404 then
		return "Mines"
	elseif id ==2405 then
		return "Waterworks"
	else
		return false
	end
end

local function TBFGobj_state(id)
	if id == 11 or id == 18 or id == 28 then
		return 1 -- Alliance Bases
	elseif id == 10 or id == 20 or id == 30 then
		return 2 -- Horde Bases
	elseif id == 9 or id == 17 or id == 27 then
		return 3 -- Alliance trys to capture
	elseif id == 12 or id == 19 or id == 29 then
		return 4 -- Horde trys to capture
	else
		return 0
	end
end

local function FreeResourses()
	TBFGobjectives = {Lighthouse = nil, Mines = nil, Waterworks = nil}
end

--------------------------------------------------
-- on event functions ----------------------------	
	
function mod:AREA_POIS_UPDATED()
	local CurrentZoneId = self.zoneId
	local POIs = C_AreaPoiInfo.GetAreaPOIForMap(CurrentZoneId)

	for i = 1, #POIs do
		local textureIndex = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
		if textureIndex then
			local type = TBFGget_objective(POIs[i])
			if type then
				if TBFGobj_state(TBFGobjectives[type]) == 3 and TBFGobj_state(textureIndex) == 1 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
					-- Alliance Dominating
					local ABases = 0
					for k, v in pairs(TBFGobjectives) do
						if k ~= type and TBFGobj_state(v) == 1 then
							ABases = ABases + 1
						end
					end
					if ABases == 2 then
						if PS_BattlegroundSoundEngine == true then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
						end
					end
				elseif TBFGobj_state(TBFGobjectives[type]) == 4 and TBFGobj_state(textureIndex) == 2 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
					-- Horde Dominating
					local HBases = 0
					for k, v in pairs(TBFGobjectives) do
						if k ~= type and TBFGobj_state(v) == 2 then
							HBases = HBases + 1
						end
					end
					if HBases == 2 then
						if PS_BattlegroundSoundEngine == true then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
						end
					end
				elseif TBFGobj_state(TBFGobjectives[type]) == 4 and TBFGobj_state(textureIndex) == 1 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
					-- Alliance Dominating
					local ABases = 0
					for k, v in pairs(TBFGobjectives) do
						if k ~= type and TBFGobj_state(v) == 1 then
							ABases = ABases + 1
						end
					end
					if ABases == 2 then
						if PS_BattlegroundSoundEngine == true then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
						end
					end
				elseif TBFGobj_state(TBFGobjectives[type]) == 3 and TBFGobj_state(textureIndex) == 2 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
					-- Horde Dominating
					local HBases = 0
					for k, v in pairs(TBFGobjectives) do
						if k ~= type and TBFGobj_state(v) == 2 then
							HBases = HBases + 1
						end
					end
					if HBases == 2 then
						if PS_BattlegroundSoundEngine == true then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
						end
					end
				elseif TBFGobj_state(TBFGobjectives[type]) == 1 and TBFGobj_state(textureIndex) == 4 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
				elseif TBFGobj_state(TBFGobjectives[type]) == 2 and TBFGobj_state(textureIndex) == 3 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
				elseif TBFGobj_state(TBFGobjectives[type]) == 3 and TBFGobj_state(textureIndex) == 4 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
				elseif TBFGobj_state(TBFGobjectives[type]) == 4 and TBFGobj_state(textureIndex) == 3 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
				end
				TBFGobjectives[type] = textureIndex
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
		API:Announce("BG")
	end
	API:ObjInit(self.zoneId, TBFGobjectives, TBFGget_objective, 2)
	self.loaded = true
end

function mod:Unload()
	API:UnregisterEvent("PVP_MATCH_COMPLETE")
	API:UnregisterEvent("AREA_POIS_UPDATED")
	FreeResourses()
	self.loaded = false
end