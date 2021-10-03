local addon, ns = ...
local PVPSound = ns.PVPSound
local PS = ns.PS
local L = ns.L

local API = PVPSound.API
local mod
if PS.isRetail then
	mod = API:RegisterMod(1339, "pvp", "Warsong Gulch", 489)
else
	mod = API:RegisterMod(1460, "pvp", "Warsong Gulch", 489)
end

local MyZone = "Zone_WarsongGulch" -- I don't want to rewrite some code here, so I use this


--------------------------------------------------
-- Resourses----------------------------------
-- Horde Score
local WSGandTPHobjectives = {HordeScore = nil}
-- Alliance Score
local WSGandTPAobjectives = {AllianceScore = nil}
-- Flag Positions
local AllianceFlagPositionX
local AllianceFlagPositionY
local HordeFlagPositionX
local HordeFlagPositionY

-- Last scored team. Uses to play sound
local LastScored

local function FreeResourses()
	AllianceFlagPositionX = nil
	AllianceFlagPositionY = nil
	HordeFlagPositionX = nil
	HordeFlagPositionY = nil
	WSGandTPHobjectives = {HordeScore = nil}
	WSGandTPAobjectives = {AllianceScore = nil}
	LastScored = nil
end

--------------------------------------------------
-- objective functions------------------------
local function WSGandTPAget_objective(id)
	if id then
		return "AllianceScore"
	else
		return false
	end
end

local function WSGandTPAobj_state(id)
	if id == 0 then
		return 0 -- Alliance Score: 0/X
	elseif id == 1 then
		return 1 -- Alliance Score: 1/X
	elseif id == 2 then
		return 2 -- Alliance Score: 2/X
	elseif id == 3 then
		return 3 -- Alliance Score: 3/X
	elseif id == 4 then
		return 4 -- Alliance Score: 4/X
	elseif id == 5 then
		return 5 -- Alliance Score: 5/X
	elseif id == 6 then
		return 6 -- Alliance Score: 6/X
	elseif id == 7 then
		return 7 -- Alliance Score: 7/X
	elseif id == 8 then
		return 8 -- Alliance Score: 8/X
	elseif id == 9 then
		return 9 -- Alliance Score: 9/X
	elseif id == 10 then
		return 10 -- Alliance Score: 10/X
	else
		return 0
	end
end

local function WSGandTPHget_objective(id)
	if id then
		return "HordeScore"
	else
		return false
	end
end

local function WSGandTPHobj_state(id)
	if id == 0 then
		return 0 -- Horde Score: 0/X
	elseif id == 1 then
		return 1 -- Horde Score: 1/X
	elseif id == 2 then
		return 2 -- Horde Score: 2/X
	elseif id == 3 then
		return 3 -- Horde Score: 3/X
	elseif id == 4 then
		return 4 -- Horde Score: 4/X
	elseif id == 5 then
		return 5 -- Horde Score: 5/X
	elseif id == 6 then
		return 6 -- Horde Score: 6/X
	elseif id == 7 then
		return 7 -- Horde Score: 7/X
	elseif id == 8 then
		return 8 -- Horde Score: 8/X
	elseif id == 9 then
		return 9 -- Horde Score: 9/X
	elseif id == 10 then
		return 10 -- Horde Score: 10/X
	else
		return 0
	end
end

--------------------------------------------------
-- Initialize Flag positions and Score------------
local function InitScoreAndFlagPosition()
	if C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(2) then
		-- Alliance Score
		local AllianceScoreInit = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(2).leftBarValue
		WSGandTPAobjectives.AllianceScore = nil
		WSGandTPAobjectives.AllianceScore = AllianceScoreInit
		-- Horde Score
		local HordeScoreInit = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(2).rightBarValue
		WSGandTPHobjectives.HordeScore = nil
		WSGandTPHobjectives.HordeScore = HordeScoreInit
	end
	--flag positions
	AllianceFlagPositionX = nil
	AllianceFlagPositionY = nil
	HordeFlagPositionX = nil
	HordeFlagPositionY = nil
end

-- Initialize timer for time remaining
local function InitTimer()
	API:ResetTimers()
	C_Timer.After(3, function() API:TimeRemaining_check(6) end) --check for C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo existance is already in TimeRemaining_check function
	--delay needed cause UI WIDGETS update occures later then entering wold or zone changing
end

--------------------------------------------------
-- on event functions ----------------------------
function mod:CHAT_MSG_BG_SYSTEM_NEUTRAL(event, EventMessage)
	if string.find(EventMessage, L["Alliance Flag has returned"]) then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Flag_Returned.mp3")
		AllianceFlagPositionX = nil
		AllianceFlagPositionY = nil
	elseif string.find(EventMessage, L["Horde Flag has returned"]) then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Flag_Returned.mp3")
		HordeFlagPositionX = nil
		HordeFlagPositionY = nil
	elseif string.find(EventMessage, L["vulnerable"]) then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\Overtime.mp3")
	end
end


function mod:CHAT_MSG_BG_SYSTEM_ALLIANCE(event, EventMessage)
	if string.find(EventMessage, L["pickedA"]) then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\Horde_Flag_Taken.mp3")
		AllianceFlagPositionX = nil
		AllianceFlagPositionY = nil
	elseif string.find(EventMessage, L["dropped"]) then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Flag_Dropped.mp3")

		for i = 1, 2 do
			local type = select(3, GetBattlefieldFlagPosition(i))

			if type == 137218 then -- type for "AllianceFlag"
				AllianceFlagPositionX = select(1, GetBattlefieldFlagPosition(i))
				AllianceFlagPositionY = select(2, GetBattlefieldFlagPosition(i))
				break
			end
		end
	elseif string.find(EventMessage, L["returned"]) then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Flag_Returned.mp3")

		-- Horde Flag Taken
		local HordeFlagStatus
		--1 - Alliance flag dropped when Horde flag was taken
		--0 - Alliance flag dropped when Horde flag was not taken
		if (C_UIWidgetManager.GetDoubleStateIconRowVisualizationInfo(1640)) then --1640 is a icon row widget with A & H flag icons
			HordeFlagStatus = C_UIWidgetManager.GetDoubleStateIconRowVisualizationInfo(1640).leftIcons[1].iconState
		end

		if C_PvP.IsInBrawl() then --need to change for only one type of brawls (wsg scramble)
			--C_PvP.GetActiveBrawlInfo()
			HordeFlagStatus = 0
		end

		--flag save in a flag enemies flagroom
		local MyFaction = UnitFactionGroup("player")
		if MyFaction == "Alliance" and HordeFlagStatus == 0 then
			if AllianceFlagPositionX and AllianceFlagPositionX ~= 0 and AllianceFlagPositionX ~= "" then
				if AllianceFlagPositionY and AllianceFlagPositionY ~= 0 and AllianceFlagPositionY ~= "" then
					if AllianceFlagPositionX >= 0.503 and AllianceFlagPositionX <= 0.545 then
						if AllianceFlagPositionY >= 0.884 and AllianceFlagPositionY <= 0.934 then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\LastSecondSave.mp3")
						end
					end
				end
			end
		end

		AllianceFlagPositionX = nil
		AllianceFlagPositionY = nil
	end
end

function mod:CHAT_MSG_BG_SYSTEM_HORDE(event, EventMessage)
	if string.find(EventMessage, L["picked"]) then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Flag_Taken.mp3")
		HordeFlagPositionX = nil
		HordeFlagPositionY = nil
	elseif string.find(EventMessage, L["dropped"]) then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Flag_Dropped.mp3")

		for i = 1, 2 do
			local type = select(3, GetBattlefieldFlagPosition(i))

			if type == 137200 then -- type for "HordeFlag"
				HordeFlagPositionX = select(1, GetBattlefieldFlagPosition(i))
				HordeFlagPositionY = select(2, GetBattlefieldFlagPosition(i))
				break
			end
		end
	elseif string.find(EventMessage, L["returned"]) then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Flag_Returned.mp3")
		-- Alliance Flag Taken
		local AllianceFlagStatus
		--1 - Alliance flag dropped when Horde flag was taken
		--0 - Alliance flag dropped when Horde flag was not taken
		if (C_UIWidgetManager.GetDoubleStateIconRowVisualizationInfo(1640)) then --1640 is a icon row widget with A & H flag icons
			AllianceFlagStatus = C_UIWidgetManager.GetDoubleStateIconRowVisualizationInfo(1640).rightIcons[1].iconState
		end

		if C_PvP.IsInBrawl() then
			--C_PvP.GetActiveBrawlInfo()
			AllianceFlagStatus = 0
		end

		local MyFaction = UnitFactionGroup("player")
		if MyFaction == "Horde" and AllianceFlagStatus == 0 then
			if HordeFlagPositionX and HordeFlagPositionX ~= 0 and HordeFlagPositionX ~= "" then
				if HordeFlagPositionY and self.HordeFlagPositionY ~= 0 and HordeFlagPositionY ~= "" then
					if HordeFlagPositionX >= 0.473 and HordeFlagPositionX <= 0.516 then
						if HordeFlagPositionY >= 0.111 and HordeFlagPositionY <= 0.176 then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\LastSecondSave.mp3")
						end
					end
				end
			end
		end

		HordeFlagPositionX = nil
		HordeFlagPositionY = nil
	end
end

function mod:UPDATE_UI_WIDGET()
	if (C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(2)) then
		-- Alliance Score
		local AllianceScore = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(2).leftBarValue
		-- Horde Score
		local HordeScore = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(2).rightBarValue
		-- Alliance
		--print("scores ",AllianceScore,HordeScore)
		if AllianceScore and HordeScore then
			local type = WSGandTPAget_objective(AllianceScore)
			if type then
				if C_PvP.IsInBrawl() then
					if WSGandTPAobj_state(WSGandTPAobjectives[type]) == 0 and WSGandTPAobj_state(AllianceScore) == 1 and HordeScore == 0 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 0 and WSGandTPAobj_state(AllianceScore) == 1 and HordeScore == 1 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 0 and WSGandTPAobj_state(AllianceScore) == 1 and HordeScore >= 2 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 1 and WSGandTPAobj_state(AllianceScore) == 2 and HordeScore == 0 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Inc_Lead.mp3")
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 1 and WSGandTPAobj_state(AllianceScore) == 2 and HordeScore == 1 then
						if LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Inc_Lead.mp3")
						elseif LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						end
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 1 and WSGandTPAobj_state(AllianceScore) == 2 and HordeScore == 2 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 1 and WSGandTPAobj_state(AllianceScore) == 2 and HordeScore >= 3 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 2 and WSGandTPAobj_state(AllianceScore) == 3 and HordeScore >= 0 and HordeScore <= 1 then
						if LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Inc_Lead.mp3")
						elseif LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						end
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 2 and WSGandTPAobj_state(AllianceScore) == 3 and HordeScore == 2 then
						if LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Inc_Lead.mp3")
						elseif LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						end
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 2 and WSGandTPAobj_state(AllianceScore) == 3 and HordeScore == 3 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 2 and WSGandTPAobj_state(AllianceScore) == 3 and HordeScore >= 4 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 3 and WSGandTPAobj_state(AllianceScore) == 4 and HordeScore >= 0 and HordeScore <= 2 then
						if LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Inc_Lead.mp3")
						elseif LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						end
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 3 and WSGandTPAobj_state(AllianceScore) == 4 and HordeScore == 3 then
						if LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Inc_Lead.mp3")
						elseif LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						end
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 3 and WSGandTPAobj_state(AllianceScore) == 4 and HordeScore == 4 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 3 and WSGandTPAobj_state(AllianceScore) == 4 and HordeScore >= 5 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 4 and WSGandTPAobj_state(AllianceScore) == 5 and HordeScore >= 0 and HordeScore <= 3 then
						if LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Inc_Lead.mp3")
						elseif LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						end
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 4 and WSGandTPAobj_state(AllianceScore) == 5 and HordeScore == 4 then
						if LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Inc_Lead.mp3")
						elseif LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						end
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 4 and WSGandTPAobj_state(AllianceScore) == 5 and HordeScore == 5 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 4 and WSGandTPAobj_state(AllianceScore) == 5 and HordeScore >= 6 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 5 and WSGandTPAobj_state(AllianceScore) == 6 and HordeScore >= 0 and HordeScore <= 4 then
						if LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Inc_Lead.mp3")
						elseif LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						end
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 5 and WSGandTPAobj_state(AllianceScore) == 6 and HordeScore == 5 then
						if LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Inc_Lead.mp3")
						elseif LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						end
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 5 and WSGandTPAobj_state(AllianceScore) == 6 and HordeScore == 6 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 5 and WSGandTPAobj_state(AllianceScore) == 6 and HordeScore >= 7 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 6 and WSGandTPAobj_state(AllianceScore) == 7 and HordeScore >= 0 and HordeScore <= 5 then
						if LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Inc_Lead.mp3")
						elseif LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						end
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 6 and WSGandTPAobj_state(AllianceScore) == 7 and HordeScore == 6 then
						if LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Inc_Lead.mp3")
						elseif LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						end
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 6 and WSGandTPAobj_state(AllianceScore) == 7 and HordeScore == 7 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 6 and WSGandTPAobj_state(AllianceScore) == 7 and HordeScore >= 8 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 7 and WSGandTPAobj_state(AllianceScore) == 8 and HordeScore >= 0 and HordeScore <= 6 then
						if LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Inc_Lead.mp3")
						elseif LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						end
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 7 and WSGandTPAobj_state(AllianceScore) == 8 and HordeScore == 7 then
						if LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Inc_Lead.mp3")
						elseif LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						end
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 7 and WSGandTPAobj_state(AllianceScore) == 8 and HordeScore == 8 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 7 and WSGandTPAobj_state(AllianceScore) == 8 and HordeScore >= 9 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 8 and WSGandTPAobj_state(AllianceScore) == 9 and HordeScore >= 0 and HordeScore <= 7 then
						if LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Inc_Lead.mp3")
						elseif LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						end
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 8 and WSGandTPAobj_state(AllianceScore) == 9 and HordeScore == 8 then
						if LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Inc_Lead.mp3")
						elseif LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						end
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 8 and WSGandTPAobj_state(AllianceScore) == 9 and HordeScore == 9 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
						LastScored = "Alliance"
					end
					if PS_BattlegroundSoundEngine == true then
						-- 10/10 Scores
						if WSGandTPAobj_state(WSGandTPAobjectives[type]) == 9 and WSGandTPAobj_state(AllianceScore) == 10 then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						end
					end
					WSGandTPAobjectives[type] = AllianceScore
				else
					if WSGandTPAobj_state(WSGandTPAobjectives[type]) == 0 and WSGandTPAobj_state(AllianceScore) == 1 and HordeScore == 0 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 0 and WSGandTPAobj_state(AllianceScore) == 1 and HordeScore == 1 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 0 and WSGandTPAobj_state(AllianceScore) == 1 and HordeScore == 2 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 1 and WSGandTPAobj_state(AllianceScore) == 2 and HordeScore == 0 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Inc_Lead.mp3")
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 1 and WSGandTPAobj_state(AllianceScore) == 2 and HordeScore == 1 then
						if LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Inc_Lead.mp3")
						elseif LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						end
						LastScored = "Alliance"
					elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 1 and WSGandTPAobj_state(AllianceScore) == 2 and HordeScore == 2 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
						LastScored = "Alliance"
					end
					if PS_BattlegroundSoundEngine == true then
						-- 3/3 Scores
						if WSGandTPAobj_state(WSGandTPAobjectives[type]) == 2 and WSGandTPAobj_state(AllianceScore) == 3 and HordeScore == 0 then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 2 and WSGandTPAobj_state(AllianceScore) == 3 and HordeScore == 1 then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 2 and WSGandTPAobj_state(AllianceScore) == 3 and HordeScore == 2 then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						end
					end
					WSGandTPAobjectives[type] = AllianceScore
				end
			end
		end
		-- Horde
		if AllianceScore and HordeScore then
			local type = WSGandTPHget_objective(HordeScore)
			if type then
				if C_PvP.IsInBrawl() then
					if WSGandTPHobj_state(WSGandTPHobjectives[type]) == 0 and WSGandTPHobj_state(HordeScore) == 1 and AllianceScore == 0 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 0 and WSGandTPHobj_state(HordeScore) == 1 and AllianceScore == 1 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 0 and WSGandTPHobj_state(HordeScore) == 1 and AllianceScore >= 2 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 1 and WSGandTPHobj_state(HordeScore) == 2 and AllianceScore == 0 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Inc_Lead.mp3")
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 1 and WSGandTPHobj_state(HordeScore) == 2 and AllianceScore == 1 then
						if LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Inc_Lead.mp3")
						elseif LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						end
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 1 and WSGandTPHobj_state(HordeScore) == 2 and AllianceScore == 2 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 1 and WSGandTPHobj_state(HordeScore) == 2 and AllianceScore >= 3 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 2 and WSGandTPHobj_state(HordeScore) == 3 and AllianceScore >= 0 and AllianceScore <= 1 then
						if LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Inc_Lead.mp3")
						elseif LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						end
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 2 and WSGandTPHobj_state(HordeScore) == 3 and AllianceScore == 2 then
						if LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Inc_Lead.mp3")
						elseif LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						end
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 2 and WSGandTPHobj_state(HordeScore) == 3 and AllianceScore == 3 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 2 and WSGandTPHobj_state(HordeScore) == 3 and AllianceScore >= 4 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 3 and WSGandTPHobj_state(HordeScore) == 4 and AllianceScore >= 0 and AllianceScore <= 2 then
						if LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Inc_Lead.mp3")
						elseif LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						end
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 3 and WSGandTPHobj_state(HordeScore) == 4 and AllianceScore == 3 then
						if LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Inc_Lead.mp3")
						elseif LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						end
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 3 and WSGandTPHobj_state(HordeScore) == 4 and AllianceScore == 4 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 3 and WSGandTPHobj_state(HordeScore) == 4 and AllianceScore >= 5 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 4 and WSGandTPHobj_state(HordeScore) == 5 and AllianceScore >= 0 and AllianceScore <= 3 then
						if LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Inc_Lead.mp3")
						elseif LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						end
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 4 and WSGandTPHobj_state(HordeScore) == 5 and AllianceScore == 4 then
						if LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Inc_Lead.mp3")
						elseif LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						end
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 4 and WSGandTPHobj_state(HordeScore) == 5 and AllianceScore == 5 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 4 and WSGandTPHobj_state(HordeScore) == 5 and AllianceScore >= 6 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 5 and WSGandTPHobj_state(HordeScore) == 6 and AllianceScore >= 0 and AllianceScore <= 4 then
						if LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Inc_Lead.mp3")
						elseif LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						end
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 5 and WSGandTPHobj_state(HordeScore) == 6 and AllianceScore == 5 then
						if LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Inc_Lead.mp3")
						elseif LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						end
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 5 and WSGandTPHobj_state(HordeScore) == 6 and AllianceScore == 6 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 5 and WSGandTPHobj_state(HordeScore) == 6 and AllianceScore >= 7 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 6 and WSGandTPHobj_state(HordeScore) == 7 and AllianceScore >= 0 and AllianceScore <= 5 then
						if LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Inc_Lead.mp3")
						elseif LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						end
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 6 and WSGandTPHobj_state(HordeScore) == 7 and AllianceScore == 6 then
						if LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Inc_Lead.mp3")
						elseif LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						end
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 6 and WSGandTPHobj_state(HordeScore) == 7 and AllianceScore == 7 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 6 and WSGandTPHobj_state(HordeScore) == 7 and AllianceScore >= 8 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 7 and WSGandTPHobj_state(HordeScore) == 8 and AllianceScore >= 0 and AllianceScore <= 6 then
						if LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Inc_Lead.mp3")
						elseif LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						end
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 7 and WSGandTPHobj_state(HordeScore) == 8 and AllianceScore == 7 then
						if LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Inc_Lead.mp3")
						elseif LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						end
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 7 and WSGandTPHobj_state(HordeScore) == 8 and AllianceScore == 8 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 7 and WSGandTPHobj_state(HordeScore) == 8 and AllianceScore >= 9 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 8 and WSGandTPHobj_state(HordeScore) == 9 and AllianceScore >= 0 and AllianceScore <= 7 then
						if LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Inc_Lead.mp3")
						elseif LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						end
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 8 and WSGandTPHobj_state(HordeScore) == 9 and AllianceScore == 8 then
						if LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Inc_Lead.mp3")
						elseif LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						end
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 8 and WSGandTPHobj_state(HordeScore) == 9 and AllianceScore == 9 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
						LastScored = "Horde"
					end
					if PS_BattlegroundSoundEngine == true then
						-- 10/10 Scores
						if WSGandTPHobj_state(WSGandTPHobjectives[type]) == 9 and WSGandTPHobj_state(HordeScore) == 10 then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						end
					end
					WSGandTPHobjectives[type] = HordeScore
				else
					if WSGandTPHobj_state(WSGandTPHobjectives[type]) == 0 and WSGandTPHobj_state(HordeScore) == 1 and AllianceScore == 0 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 0 and WSGandTPHobj_state(HordeScore) == 1 and AllianceScore == 1 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 0 and WSGandTPHobj_state(HordeScore) == 1 and AllianceScore == 2 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 1 and WSGandTPHobj_state(HordeScore) == 2 and AllianceScore == 0 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Inc_Lead.mp3")
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 1 and WSGandTPHobj_state(HordeScore) == 2 and AllianceScore == 1 then
						if LastScored == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
						elseif LastScored == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Inc_Lead.mp3")
						else
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						end
						LastScored = "Horde"
					elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 1 and WSGandTPHobj_state(HordeScore) == 2 and AllianceScore == 2 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
						LastScored = "Horde"
					end
					if PS_BattlegroundSoundEngine == true then
						-- 3/3 Scores
						if WSGandTPHobj_state(WSGandTPHobjectives[type]) == 2 and WSGandTPHobj_state(HordeScore) == 3 and AllianceScore == 0 then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 2 and WSGandTPHobj_state(HordeScore) == 3 and AllianceScore == 1 then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 2 and WSGandTPHobj_state(HordeScore) == 3 and AllianceScore == 2 then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						end
					end
					WSGandTPHobjectives[type] = HordeScore
				end
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
	if PS.isRetail then
		API.RegisterEvent(mod, "PVP_MATCH_COMPLETE")
	end
	API.RegisterEvent(mod, "CHAT_MSG_BG_SYSTEM_NEUTRAL")
	API.RegisterEvent(mod, "CHAT_MSG_BG_SYSTEM_HORDE")
	API.RegisterEvent(mod, "CHAT_MSG_BG_SYSTEM_ALLIANCE")
	API.RegisterEvent(mod, "UPDATE_UI_WIDGET")
	if not mod.loaded then
		API:Announce("BG")
	end
	InitScoreAndFlagPosition()
	InitTimer()
	mod.loaded = true
end

function mod:Unload()
	API:StopTimers()
	if PS.isRetail then
		API:UnregisterEvent("PVP_MATCH_COMPLETE")
	end
	API:UnregisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
	API:UnregisterEvent("CHAT_MSG_BG_SYSTEM_HORDE")
	API:UnregisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE")
	API:UnregisterEvent("UPDATE_UI_WIDGET")
	FreeResourses()
	mod.loaded = false
end