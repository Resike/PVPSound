local addon, ns = ...
local PVPSound = ns.PVPSound
local PS = ns.PS

local API = PVPSound.API
local mod = API:RegisterMod(623, "pvp", "Tarren Mill VS Southshore", 1280)

local MyZone = "Zone_TarrenShore" -- I don't want to rewrite some code here, so I use this

--------------------------------------------------
-- Resourses and functions---------------------

-- Objective is delta between H and A. DeltaScore = HordeScore - AllianceScore
local TMSSobjectives = {DeltaScore = nil}

--state function has returning value not in all range(0,150) (to exclude situation, when team takes a lead twice in a row (fo example: delta = 10, then 9 and then 10 again))
--so it is important to check if it is has value before setting an objective
--but the negative side of this is that if you reload interface (or enter BG) when state is false (for example between 2 and 9), objective will not be initialaized
--and sound will not be played
--so when BG is initializing, if state is false I initialize onjective as 0
--and whe I check objective changeing, I check if it chenged by one (form 1 to 2, or 2 to 3) or from 0 (from 0 to 2 or 0 to 3)
--it seems that it is not the most "beatifull" solution, but it is rather simple
local function TMSSobj_state(id)
	if id >= -1 and id <= 1 then
		return 0 -- score is nearly even
	elseif id >= 10 and id <= 15 then
		return 1 -- horde takes a lead
	elseif id >= 20 and id <= 30 then
		return 2 -- horde incr a lead
	elseif id >= 40 and id <= 150 then
		return 9 -- horde dominating
	elseif id >= -15 and id <= -10 then
		return -1 -- alliance takes a lead
	elseif id >= -30 and id <= -20 then
		return -2 -- alliance incr a lead
	elseif id >= -150 and id <= -40 then
		return -9 -- alliance dominating
	else
		return false
	end
end

-- Initialize timer for time remaining
local function InitTimer()
	API:ResetTimers()
	C_Timer.After(3, function() API:TimeRemaining_check(790) end) --check for C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo existance is already in TimeRemaining_check function
	--delay needed cause UI WIDGETS update occures later then entering wold or zone changing
end

local function InitScore()
	local Hscore
	local Ascore
	if (C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(788)) then
		Ascore = tonumber(string.match(C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(788).text, "(%d+)/"))
	end
	if (C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(789)) then
		Hscore = tonumber(string.match(C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(789).text, "(%d+)/"))
	end
	if Ascore and Hscore and TMSSobj_state(Hscore - Ascore) then
		TMSSobjectives.DeltaScore = Hscore - Ascore
	else
		TMSSobjectives.DeltaScore = 0
	end
end

local function FreeResourses()
	TMSSobjectives = {DeltaScore = nil}
end
--------------------------------------------------
-- on event functions ----------------------------

function mod:UPDATE_UI_WIDGET()
	local Hscore
	local Ascore
	if (C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(788)) then
		Ascore = tonumber(string.match(C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(788).text, "(%d+)/"))
	end
	if (C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(789)) then
		Hscore = tonumber(string.match(C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(789).text, "(%d+)/"))
	end
	if Ascore and Hscore and TMSSobj_state(Hscore - Ascore) then
		if TMSSobj_state(TMSSobjectives.DeltaScore) == 0 and TMSSobj_state(Hscore - Ascore) == 1 then
			PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
		elseif (TMSSobj_state(TMSSobjectives.DeltaScore) == 0 or TMSSobj_state(TMSSobjectives.DeltaScore) == 1) and TMSSobj_state(Hscore - Ascore) == 2 then
			PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Inc_Lead.mp3")
		elseif (TMSSobj_state(TMSSobjectives.DeltaScore) == 0 or TMSSobj_state(TMSSobjectives.DeltaScore) == 2) and TMSSobj_state(Hscore - Ascore) == 9 then
			PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
		elseif TMSSobj_state(TMSSobjectives.DeltaScore) == 0 and TMSSobj_state(Hscore - Ascore) == -1 then
			PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
		elseif (TMSSobj_state(TMSSobjectives.DeltaScore) == 0 or TMSSobj_state(TMSSobjectives.DeltaScore) == -1) and TMSSobj_state(Hscore - Ascore) == -2 then
			PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Inc_Lead.mp3")
		elseif (TMSSobj_state(TMSSobjectives.DeltaScore) == 0 or TMSSobj_state(TMSSobjectives.DeltaScore) == -2) and TMSSobj_state(Hscore - Ascore) == -9 then
			PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")

		end
		TMSSobjectives.DeltaScore = Hscore - Ascore
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
		API:Announce("BG")
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
