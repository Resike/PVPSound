local addon, ns = ...
local PVPSound = ns.PVPSound
local PVPSoundOptions = ns.PVPSoundOptions
local PS = ns.PS
local L = ns.L

local API = PVPSound.API
local mod = API:RegisterMod(907, "pvp", "Seething Shore", 1803)

local MyZone = "Zone_SeethingShore" -- I don't want to rewrite some code here, so I use this

--------------------------------------------------
-- Resourses and functions---------------------

local SeSobjectives = {AllianceScore = nil, HordeScore = nil}

local function FreeResourses()
	SeSobjectives = {AllianceScore = nil, HordeScore = nil}
end

-- Initialize timer for time remaining
local function InitTimer()
	API:ResetTimers()
	C_Timer.After(3, function() API:TimeRemaining_check(1705) end) --check for C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo existance is already in TimeRemaining_check function
	--delay needed cause UI WIDGETS update occures later then entering wold or zone changing
end

local function InitScore()
	if C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1688) then
		SeSobjectives.HordeScore = nil
		SeSobjectives.AllianceScore = nil
		-- Alliance Score
		local AllianceScoreInit = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1688).leftBarValue
		SeSobjectives.AllianceScore = AllianceScoreInit
		-- Horde Score
		local HordeScoreInit = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1688).rightBarValue
		SeSobjectives.HordeScore = HordeScoreInit
	end
end
	
--------------------------------------------------
-- on event functions ----------------------------		
	
function mod:UPDATE_UI_WIDGET()
	if (C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1688)) ~= nil then
		-- Alliance Score
		local AllianceScoreCur = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1688).leftBarValue
		if SeSobjectives.AllianceScore ~= AllianceScoreCur then
			PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
			SeSobjectives.AllianceScore = AllianceScoreCur
		end
		-- Horde Score
		local HordeScoreCur = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1688).rightBarValue
		if SeSobjectives.HordeScore ~= HordeScoreCur then
			PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
			SeSobjectives.HordeScore = HordeScoreCur
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
	InitTimer()
	self.loaded = true
end

function mod:Unload()
	API:StopTimers()
	API:UnregisterEvent("PVP_MATCH_COMPLETE")
	API:UnregisterEvent("UPDATE_UI_WIDGET")
	FreeResourses()
	self.loaded = false
end