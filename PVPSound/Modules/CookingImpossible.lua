local addon, ns = ...
local PVPSound = ns.PVPSound
local PVPSoundOptions = ns.PVPSoundOptions
local PS = ns.PS
local L = ns.L

local API = PVPSound.API
local mod = API:RegisterMod(1335, "pvp", "Cooking:Impossible", 1691)

local MyZone = "Zone_CookingImpossible" -- I don't want to rewrite some code here, so I use this

--------------------------------------------------
-- Resourses and functions---------------------

local CIobjectives = {AllianceScore = nil, HordeScore = nil}

local function FreeResourses()
	CIobjectives = {AllianceScore = nil, HordeScore = nil}
end

local function InitScore()
	if C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(967) then
		CIobjectives.HordeScore = nil
		CIobjectives.AllianceScore = nil
		-- Alliance Score
		local AllianceScoreInit = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(967).leftBarValue
		CIobjectives.AllianceScore = AllianceScoreInit
		-- Horde Score
		local HordeScoreInit = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(967).rightBarValue
		CIobjectives.HordeScore = HordeScoreInit
	end
end
	
--------------------------------------------------
-- on event functions ----------------------------		
	
function mod:UPDATE_UI_WIDGET()	
	if C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(967) then
		-- Alliance Score
		local AllianceScoreCur = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(967).leftBarValue
		if CIobjectives.AllianceScore ~= AllianceScoreCur then
			PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
			CIobjectives.AllianceScore = AllianceScoreCur
		end
		-- Horde Score
		local HordeScoreCur = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(967).rightBarValue
		if CIobjectives.HordeScore ~= HordeScoreCur then
			PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
			CIobjectives.HordeScore = HordeScoreCur
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
	API.RegisterEvent(self, "UPDATE_UI_WIDGET")
	if not self.loaded then
		API:AnnounceBG()
	end
	InitScore()
	self.loaded = true
end

function mod:Unload()
	API:UnregisterEvent("PVP_MATCH_COMPLETE")
	API:UnregisterEvent("UPDATE_UI_WIDGET")
	FreeResourses()
	self.loaded = false
end