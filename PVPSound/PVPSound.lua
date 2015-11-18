--[[
	   _          _     _         _        _           _      _          _
	 _/\\___   _ /\\  _/\\___    /\\__  __/\\___  ___ /\\   _/\\___   __/\\___
	(_   _ _))/ \\ \\(_   _ _)) /    \\(_     _))/  //\ \\ (_      ))(_  ____))
	 /  |))\\ \:'/ // /  |))\\ _\  \_// /  _  \\ \:.\\_\ \\ /  :   \\ /   _ \\
	/:. ___//  \  // /:. ___//// \:.\  /:.(_)) \\ \  :.  ///:. |   ///:. |_\ \\
	\_ \\     (_  _))\_ \\    \\__  /  \  _____//(_   ___))\___|  // \  _____//
	  \//       \//    \//       \\/    \//        \//4.0.0     \//   \//

	PVPSound
	Copyright (c) 2010-2013 Resperger Dániel (Resike)
	E-Mail: reske@gmail.com
	All rights reserved.
	See the accompanying "!Licence.txt" for more information.
	The addon can be found at:
	http://www.curse.com/addons/wow/pvpsound
	http://www.wowinterface.com/downloads/info19569-PVPSound.html
	If downloaded from any other source then it's considered an illegal version.
--]]

local addon, ns = ...
local PVPSound = ns.PVPSound
local PVPSoundOptions = ns.PVPSoundOptions
local PS = ns.PS
local L = ns.L

local bit = bit
local getglobal = getglobal
local print = print
local select = select
local string = string
local table = table
local tonumber = tonumber
local tostring = tostring

--[[local GetBuildInfo = GetBuildInfo
local GetMapLandmarkInfo = GetMapLandmarkInfo
local SendChatMessage = SendChatMessage
local GetTime = GetTime
local UnitGUID = UnitGUID
local UnitName = UnitName]]

local PVPSoundFrame = CreateFrame("Frame", nil)
PVPSoundFrame:RegisterEvent("ADDON_LOADED")

function PVPSound:OnLoad()
	if PS_EnableAddon == true then
		PVPSoundFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		PVPSoundFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		PVPSoundFrame:RegisterEvent("PLAYER_DEAD")
		PVPSoundFrame:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
		PVPSoundFrame:RegisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE")
		PVPSoundFrame:RegisterEvent("CHAT_MSG_BG_SYSTEM_HORDE")
		PVPSoundFrame:RegisterEvent("CHAT_MSG_MONSTER_YELL")
		PVPSoundFrame:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
		PVPSoundFrame:RegisterEvent("WORLD_MAP_UPDATE")
	end
end

local PVPSoundFrameTwo = CreateFrame("Frame", nil)

function PVPSound:OnLoadTwo()
	if PS_EnableAddon == true then
		PVPSoundFrameTwo:RegisterEvent("PLAYER_TARGET_CHANGED")
		PVPSoundFrameTwo:RegisterEvent("UNIT_HEALTH")
		PVPSoundFrameTwo:RegisterEvent("UNIT_MAXHEALTH")
		PVPSoundFrameTwo:RegisterEvent("UPDATE_WORLD_STATES")
	end
end

local PVPSoundFrameThree = CreateFrame("Frame", nil)

function PVPSound:OnLoadThree()
	if PS_EnableAddon == true then
		PVPSoundFrameThree:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end

function PVPSound:RegisterEvents()
	PVPSoundFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	PVPSoundFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	PVPSoundFrame:RegisterEvent("PLAYER_DEAD")
	PVPSoundFrame:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
	PVPSoundFrame:RegisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE")
	PVPSoundFrame:RegisterEvent("CHAT_MSG_BG_SYSTEM_HORDE")
	PVPSoundFrame:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	PVPSoundFrame:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	PVPSoundFrame:RegisterEvent("WORLD_MAP_UPDATE")
	PVPSoundFrameTwo:RegisterEvent("PLAYER_TARGET_CHANGED")
	PVPSoundFrameTwo:RegisterEvent("UNIT_HEALTH")
	PVPSoundFrameTwo:RegisterEvent("UNIT_MAXHEALTH")
	PVPSoundFrameTwo:RegisterEvent("UPDATE_WORLD_STATES")
	PVPSoundFrameThree:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function PVPSound:UnregisterEvents()
	PVPSoundFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	PVPSoundFrame:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	PVPSoundFrame:UnregisterEvent("PLAYER_DEAD")
	PVPSoundFrame:UnregisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
	PVPSoundFrame:UnregisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE")
	PVPSoundFrame:UnregisterEvent("CHAT_MSG_BG_SYSTEM_HORDE")
	PVPSoundFrame:UnregisterEvent("CHAT_MSG_MONSTER_YELL")
	PVPSoundFrame:UnregisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	PVPSoundFrame:UnregisterEvent("WORLD_MAP_UPDATE")
	PVPSoundFrameTwo:UnregisterEvent("PLAYER_TARGET_CHANGED")
	PVPSoundFrameTwo:UnregisterEvent("UNIT_HEALTH")
	PVPSoundFrameTwo:UnregisterEvent("UNIT_MAXHEALTH")
	PVPSoundFrameTwo:UnregisterEvent("UPDATE_WORLD_STATES")
	PVPSoundFrameThree:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

-- Build Version
local WowBuildInfo

-- Settings
local TimerReset
local ResetTime
local MultiKillTime
local RankStep

-- Player
local MyFaction
local MyGender

-- Battlegrounds
local IsRated
local BgIsOver
local SotaAttacker
local SotaRoundOver
local IocAllianceGateDown
local IocHordeGateDown
local AlreadyPlaySound
local LastScored

-- Battlefields
local TbAttacker
local WgAttacker

-- Zones
local MyZone
local InstanceType
local CurrentZoneId
local CurrentZoneText

-- Kills
local MultiKills
local CurrentStreak
local LastKill
local FirstKill
local FirstMultiKill

-- Deaths
local KilledMe
local KilledBy
local KilledWho
local GotKilledBy

-- Enemys
local ToEnemy
local FromEnemy
local ToEnemyPlayer
local ToEnemyPlayerAndNPC
local FromMyPets
local FromEnemyPlayer
local FromEnemyPlayerAndNPC

-- Killing Settings
function PVPSound:KillingSettings()
	TimerReset = false						-- Resets every timer and counter
	ResetTime = 1800						-- Automatically resets everything when no kills made in 30 minutes
	MultiKillTime = 16						-- If you get the Multi Kills in 16 sec difference you gain a Multi Kill rank, else resets
	RankStep = 1							-- How many kills need for the next rank after the First Blood
	PS.KillTime = 60						-- If you get the Kills in 60 sec difference you gain a rank, else just replays your last rank and rank gaining continuing from that rank
	PS.PaybackKillTime = 90					-- The time you can revenge the players they killed you, or the players can revenge you whom you killed
	PS.RecentlyKilledTime = 1.500			-- The time in you cant gain more then one kill on the same target
	PS.RecentlyPaybackTime = 1.500			-- The time in you cant gain more then one payback and retribution kill
end

-- Default Settings
function PVPSound:DefaultSettings()
	if PS_EnableAddon == nil then
		PS_EnableAddon = true
	end
	if PS_AddonLanguage == nil then
		PS_AddonLanguage = "English"
		PVPSound:English()
	end
	if PS_Mode == nil then
		PS_Mode = "PVP"
	end
	if PS_Emote == nil then
		PS_Emote = true
	end
	if PS_EmoteMode == nil then
		PS_EmoteMode = true
	end
	if PS_DeathMessage == nil then
		PS_DeathMessage = true
	end
	if PS_KillSound == nil then
		PS_KillSound = true
	end
	if PS_MultiKillSound == nil then
		PS_MultiKillSound = true
	end
	if PS_PetKill == nil then
		PS_PetKill = true
	end
	if PS_PaybackSound == nil then
		PS_PaybackSound = true
	end
	if PS_BattlegroundSound == nil then
		PS_BattlegroundSound = true
	end
	if PS_SoundEffect == nil then
		PS_SoundEffect = true
	end
	if PS_KillSoundEngine == nil then
		PS_KillSoundEngine = true
	end
	if PS_BattlegroundSoundEngine == nil then
		PS_BattlegroundSoundEngine = true
	end
	if PS_DataShare == nil then
		PS_DataShare = true
	end
	if PS_KillSct == nil then
		PS_KillSct = true
	end
	if PS_MultiKillSct == nil then
		PS_MultiKillSct = true
	end
	if PS_PaybackSct == nil then
		PS_PaybackSct = true
	end
	if PS_SctEngine == nil then
		PS_SctEngine = true
	end
	-- Intended name
	if PSSctFrame == nil then
		if MikSBT then
			PSSctFrame = "Notification"
		elseif Parrot then
			PSSctFrame = "Notification"
		elseif SCT then
			PSSctFrame = "Frame 1"
		elseif xCT then
			PSSctFrame = "Frame 3"
		elseif xCT_Plus then
			PSSctFrame = "General"
		end
	end
	if PS_HideServerName == nil then
		PS_HideServerName = true
	end
	if PS_Channel == nil then
		PS_Channel = "Master"
	end
	if PS_KillSoundPackName == nil then
		PS_KillSoundPackName = "UnrealTournament3"
	end
	if PS_KillSoundPackLanguage == nil then
		PS_KillSoundPackLanguage = "Eng"
	end
	if PS_SoundPackName == nil then
		PS_SoundPackName = "UnrealTournament3"
	end
	if PS_SoundPackLanguage == nil then
		PS_SoundPackLanguage = "Eng"
	end
	-- Data Share Register
	if PS_DataShare == true then
		RegisterAddonMessagePrefix("PVPSound")
	end
end

function PVPSound:SetAddonLanguage()
	if PS_AddonLanguage == "English" then
		PVPSound:English()
	elseif PS_AddonLanguage == "German" then
		PVPSound:German()
	elseif PS_AddonLanguage == "Spanish" then
		PVPSound:Spanish()
	elseif PS_AddonLanguage == "LatinAmericanSpanish" then
		PVPSound:LatinAmericanSpanish()
	elseif PS_AddonLanguage == "French" then
		PVPSound:French()
	elseif PS_AddonLanguage == "Italian" then
		PVPSound:Italian()
	elseif PS_AddonLanguage == "Korean" then
		PVPSound:Korean()
	elseif PS_AddonLanguage == "Portuguese" then
		PVPSound:Portuguese()
	elseif PS_AddonLanguage == "Russian" then
		PVPSound:Russian()
	elseif PS_AddonLanguage == "SimplifiedChinese" then
		PVPSound:SimplifiedChinese()
	elseif PS_AddonLanguage == "TraditionalChinese" then
		PVPSound:TraditionalChinese()
	end
end

function PVPSound:TimerReset()
	TimerReset = true
end

-- Alterac Valley
local AVobjectives = {ColdtoothMine = nil, DunBaldarNorthBunker = nil, DunBaldarSouthBunker = nil, EastFrostwolfTower = nil, FrostwolfGraveyard = nil, FrostwolfReliefHut = nil, IcebloodGraveyard = nil, IcebloodTower = nil, IcewingBunker = nil, IrondeepMine = nil, SnowfallGraveyard = nil, StonehearthBunker = nil, StonehearthGraveyard = nil, StormpikeAidStation = nil, StormpikeGraveyard = nil, TowerPoint = nil, WestFrostwolfTower = nil}

local function AVget_objective(id)
	if id >= 101 and id <= 103 then
		return "ColdtoothMine"
	elseif id == 206 or id == 211 or id == 212 then
		return "DunBaldarNorthBunker"
	elseif id == 306 or id == 311 or id == 312 then
		return "DunBaldarSouthBunker"
	elseif id == 406 or id == 409 or id <= 410 then
		return "EastFrostwolfTower"
	elseif id == 504 or id == 513 or id == 514 or id == 515 then
		return "FrostwolfGraveyard"
	elseif id == 604 or id == 613 or id == 614 or id == 615 then
		return "FrostwolfReliefHut"
	elseif id == 704 or id == 713 or id == 714 or id == 715 then
		return "IcebloodGraveyard"
	elseif id == 806 or id == 809 or id == 810 then
		return "IcebloodTower"
	elseif id == 906 or id == 911 or id == 912 then
		return "IcewingBunker"
	elseif id >= 1001 and id <= 1003 then
		return "IrondeepMine"
	elseif id == 1104 or id == 1108 or id == 1113 or id == 1114 or id == 1115 then
		return "SnowfallGraveyard"
	elseif id == 1206 or id == 1211 or id == 1212 then
		return "StonehearthBunker"
	elseif id == 1304 or id == 1313 or id == 1314 or id == 1315 then
		return "StonehearthGraveyard"
	elseif id == 1404 or id == 1413 or id == 1414 or id == 1415 then
		return "StormpikeAidStation"
	elseif id == 1504 or id == 1513 or id == 1514 or id == 1515 then
		return "StormpikeGraveyard"
	elseif id == 1606 or id == 1609 or id == 1610 then
		return "TowerPoint"
	elseif id == 1706 or id == 1709 or id == 1710 then
		return "WestFrostwolfTower"
	else
		return false
	end
end

local function AVobj_state(id)
	if id == 103 or id == 211 or id == 311 or id == 515 or id == 615 or id == 715 or id == 911 or id == 1003 or id == 1115 or id == 1211 or id == 1315 or id == 1415 or id == 1515 then
		return 1 -- Alliance Bases
	elseif id == 102 or id == 410 or id == 513 or id == 613 or id == 713 or id == 810 or id == 1002 or id == 1113 or id == 1313 or id == 1413 or id == 1513 or id == 1610 or id == 1710 then
		return 2 -- Horde Bases
	elseif id == 409 or id == 504 or id == 604 or id == 704 or id == 809 or id == 1104 or id == 1304 or id == 1404 or id == 1504 or id == 1609 or id == 1709 then
		return 3 -- Alliance trys to capture
	elseif id == 212 or id == 312 or id == 514 or id == 614 or id == 714 or id == 912 or id == 1114 or id == 1212 or id == 1314 or id == 1414 or id == 1514 then
		return 4 -- Horde trys to capture
	elseif id == 206 or id == 306 or id == 406 or id == 806 or id == 906 or id == 1206 or id == 1606 or id == 1706 then
		return 5 -- Destoryed Bunker/Tower
	elseif id == 101 or id == 1001 then
		return 6 -- Uncontrolled
	else 
		return 0
	end
end

-- Time Remaining
local TimeRemainingobjectives = {TimeRemaining = nil}

local function TimeRemainingget_objective(id)
	if id then
		return "TimeRemaining"
	else
		return false
	end
end

local function TimeRemainingobj_state(id)
	if id == 5 then
		return 1 -- Time Remaining: 5:59-5:00
	elseif id == 4 then
		return 2 -- Time Remaining: 4:59-4:00
	elseif id == 3 then
		return 3 -- Time Remaining: 3:59-3:00
	elseif id == 2 then
		return 4 -- Time Remaining: 2:59-2:00
	elseif id == 1 then
		return 5 -- Time Remaining: 1:59-1:00
	elseif id == 0 then
		return 6 -- Time Remaining: 0:59-0:00
	else
		return 0
	end
end

-- Warsong Gulch and Twin Peaks Alliance Score
local WSGandTPAobjectives = {AllianceScore = nil}

local function WSGandTPAget_objective(id)
	if id then
		return "AllianceScore"
	else
		return false
	end
end

local function WSGandTPAobj_state(id)
	if id == 0 then
		return 1 -- Alliance Score: 0/3
	elseif id == 1 then
		return 2 -- Alliance Score: 1/3
	elseif id == 2 then
		return 3 -- Alliance Score: 2/3
	elseif id == 3 then
		return 4 -- Alliance Score: 3/3
	else
		return 0
	end
end

-- Warsong Gulch and Twin Peaks Horde Score
local WSGandTPHobjectives = {HordeScore = nil}

local function WSGandTPHget_objective(id)
	if id then
		return "HordeScore"
	else
		return false
	end
end

local function WSGandTPHobj_state(id)
	if id == 0 then
		return 1 -- Horde Score: 0/3
	elseif id == 1 then
		return 2 -- Horde Score: 1/3
	elseif id == 2 then
		return 3 -- Horde Score: 2/3
	elseif id == 3 then
		return 4 -- Horde Score: 3/3
	else
		return 0
	end
end

-- Arathi Basin
local ABobjectives = {Blacksmith = nil, Farm = nil, GoldMine = nil, LumberMill = nil, Stables = nil}

local function ABget_objective(id)
	if id >= 126 and id <= 130 then
		return "Blacksmith"
	elseif id >= 231 and id <= 235 then
		return "Farm"
	elseif id >= 316 and id <= 320 then
		return "GoldMine"
	elseif id >= 421 and id <= 425 then
		return "LumberMill"
	elseif id >= 536 and id <= 540 then
		return "Stables"
	else
		return false
	end
end

local function ABobj_state(id)
	if id == 128 or id == 233 or id == 318 or id == 423 or id == 538 then
		return 1 -- Alliance Bases
	elseif id == 130 or id == 235 or id == 320 or id == 425 or id == 540 then
		return 2 -- Horde Bases
	elseif id == 127 or id == 232 or id == 317 or id == 422 or id == 537 then
		return 3 -- Alliance trys to capture
	elseif id == 129 or id == 234 or id == 319 or id == 424 or id == 539 then
		return 4 -- Horde trys to capture
	else
		return 0
	end
end

-- The Battle for Gilneas
local TBFGobjectives = {Lighthouse = nil, Mines = nil, Waterworks = nil}

local function TBFGget_objective(id)
	if id == 106 or id == 109 or id == 110 or id == 111 or id <= 112 then
		return "Lighthouse"
	elseif id >= 216 and id <= 220 then
		return "Mines"
	elseif id >= 326 and id <= 330 then
		return "Waterworks"
	else
		return false
	end
end

local function TBFGobj_state(id)
	if id == 111 or id == 218 or id == 328 then
		return 1 -- Alliance Bases
	elseif id == 110 or id == 220 or id == 330 then
		return 2 -- Horde Bases
	elseif id == 109 or id == 217 or id == 327 then
		return 3 -- Alliance trys to capture
	elseif id == 112 or id == 219 or id == 329 then
		return 4 -- Horde trys to capture
	else
		return 0
	end
end

-- Deepwind Gorge
local DGobjectives = {CenterMine = nil, GoblinMine = nil, PandarenMine = nil}

local function DGget_objective(id)
	if id >= 116 and id <= 120 then
		return "CenterMine"
	elseif id >= 216 and id <= 220 then
		return "GoblinMine"
	elseif id >= 316 and id <= 320 then
		return "PandarenMine"
	else
		return false
	end
end

local function DGobj_state(id)
	if id == 118 or id == 218 or id == 318 then
		return 1 -- Alliance Bases
	elseif id == 120 or id == 220 or id == 320 then
		return 2 -- Horde Bases
	elseif id == 117 or id == 217 or id == 317 then
		return 3 -- Alliance trys to capture
	elseif id == 119 or id == 219 or id == 319 then
		return 4 -- Horde trys to capture
	else
		return 0
	end
end

-- Isle of Conquest
local IOCobjectives = {AllianceGateE = nil, AllianceGateW = nil, AllianceGateS = nil, HordeGateE = nil, HordeGateW = nil, HordeGateN = nil, Quarry = nil, Workshop = nil, Hangar = nil, Docks = nil, Refinerie = nil}

local function IOCget_objective(id)
	if id >= 16 and id <= 20 then
		return "Quarry"
	elseif id >= 135 and id <= 139 then
		return "Workshop"
	elseif id >= 140 and id <= 144 then
		return "Hangar"
	elseif id >= 145 and id <= 149 then
		return "Docks"
	elseif id >= 150 and id <= 154 then
		return "Refinerie"
	elseif id == 180 or id == 182 then
		return "AllianceGateE"
	elseif id == 280 or id == 282 then
		return "AllianceGateW"
	elseif id == 380 or id == 382 then
		return "AllianceGateS"
	elseif id == 477 or id == 479 then
		return "HordeGateE"
	elseif id == 577 or id == 579 then
		return "HordeGateW"
	elseif id == 677 or id == 679 then
		return "HordeGateN"
	else
		return false
	end
end

local function IOCobj_state(id)
	if id == 18 or id == 136 or id == 141 or id == 146 or id == 151 then
		return 1 -- Alliance Bases
	elseif id == 20 or id == 138 or id == 143 or id == 148 or id == 153 then
		return 2 -- Horde Bases
	elseif id == 17 or id == 137 or id == 142 or id == 147 or id == 152 then
		return 3 -- Alliance trys to capture
	elseif id == 19 or id == 139 or id == 144 or id == 149 or id == 154 then
		return 4 -- Horde trys to capture
	elseif id == 180 or id == 280 or id == 380 then
		return 5 -- Alliance Gate Undamaged
	elseif id == 477 or id == 577 or id == 677 then
		return 6 -- Horde Gate Undamaged
	elseif id == 182 or id == 282 or id == 382 then
		return 7 -- Alliance Gate Destroyed
	elseif id == 479 or id == 579 or id == 679 then
		return 8 -- Horde Gate Destroyed
	else
		return 0
	end
end

-- Strand of the Ancients
local SOTAobjectives = {ChamberofAncientRelics = nil, EastGraveyard = nil, GateoftheBlueSapphire = nil, GateoftheGreenEmerald = nil, GateofthePurpleAmethyst = nil, GateoftheRedSun = nil, GateoftheYellowMoon = nil, SouthGraveyard = nil, WestGraveyard = nil}

local function SOTAget_objective(id)
	if id >= 177 and id <= 182 then
		return "ChamberofAncientRelics"
	elseif id == 213 or id == 215 then
		return "EastGraveyard"
	elseif id >= 80 and id <= 82 then
		return "GateoftheBlueSapphire"
	elseif id >= 108 and id <= 110 then
		return "GateoftheGreenEmerald"
	elseif id >= 105 and id <= 107 then
		return "GateofthePurpleAmethyst"
	elseif id >= 77 and id <= 79 then
		return "GateoftheRedSun"
	elseif id >= 702 and id <= 704 then
		return "GateoftheYellowMoon"
	elseif id == 813 or id == 815 then
		return "SouthGraveyard"
	elseif id == 913 or id == 915 then
		return "WestGraveyard"
	else
		return false
	end
end

local function SOTAobj_state(id)
	if id == 215 or id == 815 or id == 915 then
		return 1 -- Alliance Graveyards
	elseif id == 213 or id == 813 or id == 913 then
		return 2 -- Horde Graveyards
	elseif id == 177 or id == 180 then
		return 3 -- Chamber Gate Undamaged
	elseif id == 178 or id == 181 then
		return 4 -- Chamber Gate Damaged
	elseif id == 179 or id == 182 then
		return 5 -- Chamber Gate Destroyed
	elseif id == 80 or id == 108 or id == 105 or id == 77 or id == 702 then
		return 6 -- Other Gates Undamaged
	elseif id == 81 or id == 109 or id == 106 or id == 78 or id == 703 then
		return 7 -- Other Gates Damaged
	elseif id == 82 or id == 110 or id == 107 or id == 79 or id == 704 then
		return 8 -- Other Gates Destroyed
	else
		return 0
	end
end

-- Eye of the Storm
local EOTSobjectives = {BloodElfTower = nil, DraeneiRuins = nil, FelReaverRuins = nil, MageTower = nil}

local function EOTSget_objective(id)
	if id == 106 or id == 109 or id == 110 or id == 111 or id == 112 then
		return "BloodElfTower"
	elseif id == 206 or id == 209 or id == 210 or id == 211 or id == 212 then
		return "DraeneiRuins"
	elseif id == 306 or id == 309 or id == 310 or id == 311 or id == 312 then
		return "FelReaverRuins"
	elseif id == 406 or id == 409 or id == 410 or id == 411 or id == 412 then
		return "MageTower"
	else
		return false
	end
end

local function EOTSobj_state(id)
	if id == 106 or id == 206 or id == 306 or id == 406 then
		return 1 -- Uncontrolled
	elseif id == 111 or id == 211 or id == 311 or id == 411 then
		return 2 -- Alliance Base
	elseif id == 110 or id == 210 or id == 310 or id == 410 then
		return 3 -- Horde Base
	elseif id == 109 or id == 209 or id == 309 or id == 409 then
		return 4 -- Alliance trys to capture
	elseif id == 112 or id == 212 or id == 312 or id == 412 then
		return 5 -- Horde trys to capture
	else
		return 0
	end
end

-- Eye of the Storm Victory Points
--[[local EOTSWINobjectives = {VictoryPoints = nil}

local function EOTSWINget_objective(id)
	if id then
		return "VictoryPoints"
	else
		return false
	end
end

local function EOTSWINobj_state(id)
	if id == 1600 then
		return 1 -- Victory Points: 1600/1600
	else
		return 2 -- Victory Points: 0-1599/1600
	end
end]]

-- Silvershard Mines Resources
local SMWINobjectives = {Resources = nil}

local function SMWINget_objective(id)
	if id then
		return "Resources"
	else
		return false
	end
end

local function SMWINobj_state(id)
	if id == 1600 then
		return 1 -- Resources: 1600/1600
	else
		return 2 -- Resources: 0-1599/1600
	end
end

-- Wintergrasp
local WGobjectives = {FlamewatchTower = nil, FortressGraveyard = nil, ShadowsightTower = nil, WintersEdgeTower = nil, WintergraspFortressTowerNE = nil, WintergraspFortressTowerNW = nil, WintergraspFortressTowerSE = nil, WintergraspFortressTowerSW = nil,}

local function WGget_objective(id)
	if id == 13 or id == 15 then
		return "FortressGraveyard"
	elseif id == 110 or id == 111 or id == 150 or id == 151 or id == 152 or id == 153 then
		return "FlamewatchTower"
	elseif id == 210 or id == 211 or id == 250 or id == 251 or id == 252 or id == 253 then
		return "ShadowsightTower"
	elseif id == 310 or id == 311 or id == 350 or id == 351 or id == 352 or id == 353 then
		return "WintersEdgeTower"
	elseif id == 410 or id == 411 or id == 450 or id == 451 or id == 452 or id == 453 then
		return "WintergraspFortressTowerNE"
	elseif id == 510 or id == 511 or id == 550 or id == 551 or id == 552 or id == 553 then
		return "WintergraspFortressTowerNW"
	elseif id == 610 or id == 611 or id == 650 or id == 651 or id == 652 or id == 653 then
		return "WintergraspFortressTowerSE"
	elseif id == 710 or id == 711 or id == 750 or id == 751 or id == 752 or id == 753 then
		return "WintergraspFortressTowerSW"
	else
		return false
	end
end

local function WGobj_state(id)
	if id == 111 or id == 211 or id == 311 or id == 411 or id == 511 or id == 611 or id == 711 then
		return 1 -- Alliance Towers Undamaged
	elseif id == 110 or id == 210 or id == 310 or id == 410 or id == 510 or id == 610 or id == 710 then
		return 2 -- Horde Towers Undamaged
	elseif id == 150 or id == 250 or id == 350 or id == 450 or id == 550 or id == 650 or id == 750 then
		return 3 -- Alliance Towers Heavily Damaged
	elseif id == 151 or id == 251 or id == 351 or id == 451 or id == 551 or id == 651 or id == 751 then
		return 4 -- Alliance Towers Destroyed
	elseif id == 152 or id == 252 or id == 352 or id == 452 or id == 552 or id == 652 or id == 752 then
		return 5 -- Horde Towers Heavily Damaged
	elseif id == 153 or id == 253 or id == 353 or id == 453 or id == 553 or id == 653 or id == 753 then
		return 6 -- Horde Towers Destroyed
	elseif id == 13 then
		return 7 -- Horde Graveyard
	elseif id == 15 then
		return 8 -- Alliance Graveyard
	else
		return 0
	end
end

-- Tol Barad
local TBobjectives = {BaradinHold = nil, IroncladGarrison = nil, Slagworks = nil, WardensVigil = nil, EastSpire = nil, SouthSpire = nil, WestSpire = nil}

local function TBget_objective(id)
	if id == 46 or id == 48 then
		return "BaradinHold"
	elseif id >= 109 and id <= 112 then
		return "IroncladGarrison"
	elseif id >= 227 and id <= 230 then
		return "Slagworks"
	elseif id >= 309 and id <= 312 then
		return "WardensVigil"
	elseif id == 410 or id == 411 or id == 450 or id == 452 or id == 455 then
		return "EastSpire"
	elseif id == 510 or id == 511 or id == 550 or id == 552 or id == 555 then
		return "SouthSpire"
	elseif id == 610 or id == 611 or id == 650 or id == 652 or id == 655 then
		return "WestSpire"
	else
		return false
	end
end

local function TBobj_state(id)
	if id == 46 or id == 111 or id == 228 or id == 311 then
		return 1 -- Alliance Bases
	elseif id == 48 or id == 110 or id == 230 or id == 310 then
		return 2 -- Horde Bases
	elseif id == 109 or id == 227 or id == 309 then
		return 3 -- Alliance trys to capture
	elseif id == 112 or id == 229 or id == 312 then
		return 4 -- Horde trys to capture
	elseif id == 411 or id == 511 or id == 611 then
		return 5 -- Alliance Towers Undamaged
	elseif id == 410 or id == 510 or id == 610 then
		return 6 -- Horde Towers Undamaged
	elseif id == 450 or id == 550 or id == 650 then
		return 7 -- Alliance Towers Heavily Damaged
	elseif id == 452 or id == 552 or id == 652 then
		return 8 -- Horde Towers Heavily Damaged
	elseif id == 455 or id == 555 or id == 655 then
		return 9 -- Towers Destroyed
	else
		return 0
	end
end

-- Alterac Valley and Isle of Conquest Alliance Reinforcements
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

-- Alterac Valley and Isle of Conquest Horde Reinforcements
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

local TargetHealthObjectives = {Percent = nil}

local function TargetHealthGetObjective(healthPercent)
	if healthPercent then
		return "Percent"
	else
		return false
	end
end

local function TargetHealthState(healthPercent)
	if healthPercent then
		if healthPercent >= 0.2 then
			return 1
		elseif healthPercent < 0.2 and UnitIsDeadOrGhost("target") ~= 1 then
			return 2
		else
			return false
		end
	end
end

function PVPSound:OnEvent(event, ...)
	if event == "ADDON_LOADED" then
		local Addon = ...
		if Addon == "PVPSound" then
			local _
			_, _, _, WowBuildInfo = GetBuildInfo()
			PVPSound:KillingSettings()
			PVPSound:DefaultSettings()
			PVPSound:SetAddonLanguage()
			-- SoundPack Settings
			if PS_KillSoundPackName == "DevilMayCry" then
				PS.KillSoundPackDirectory = "Interface\\Addons\\PVPSound\\Sounds\\"..PS_KillSoundPackName
			elseif PS_KillSoundPackName == "Dota2" then
				PS.KillSoundPackDirectory = "Interface\\Addons\\PVPSound\\Sounds\\"..PS_KillSoundPackName
			elseif PS_KillSoundPackName == "Halo4" then
				PS.KillSoundPackDirectory = "Interface\\Addons\\PVPSound\\Sounds\\"..PS_KillSoundPackName
			elseif PS_KillSoundPackName == "UnrealTournament3" then
				PS.KillSoundPackDirectory = "Interface\\Addons\\PVPSound\\Sounds\\"..PS_KillSoundPackName
			elseif PS_KillSoundPackName == "Custom" then
				PS.KillSoundPackDirectory = "Interface\\Addons\\PVPSound_CustomSoundPack\\Sounds\\"..PS_KillSoundPackName
			end
			if PS_SoundPackName == "UnrealTournament3" then
				PS.SoundPackDirectory = "Interface\\Addons\\PVPSound\\Sounds\\"..PS_SoundPackName
			elseif PS_SoundPackName == "Custom" then
				PS.SoundPackDirectory = "Interface\\Addons\\PVPSound_CustomSoundPack\\Sounds\\"..PS_SoundPackName
			end
			PS.KillSoundPack = PS_KillSoundPackName..""..PS_KillSoundPackLanguage
			PS.SoundPack = PS_SoundPackName..""..PS_SoundPackLanguage
			if PS_EnableAddon == true then
				PVPSound:OnLoad()
				PVPSound:OnLoadTwo()
				PVPSound:OnLoadThree()
			end
			PVPSoundOptions:OptionsAddonIsLoaded()
			-- Addon loaded message
			--print("|cFF50C0FFPVPSound |cFFFFA500"..GetAddOnMetadata("PVPSound", "Version").."|cFF50C0FF loaded.|r")
		end
	end

	if PS_EnableAddon == true then
		if event == "PLAYER_ENTERING_WORLD" then
			MyFaction = UnitFactionGroup("player")
			SetMapToCurrentZone()
			CurrentZoneId = GetCurrentMapAreaID()
			CurrentZoneText = GetRealZoneText()
			InstanceType = (select(2, IsInInstance()))
			IsRated = IsRatedBattleground()
			TimerReset = true
			-- Battlegrounds
			if CurrentZoneId == 443 and InstanceType == "pvp" then
				MyZone = "Zone_WarsongGulch"
			elseif CurrentZoneId == 461 and InstanceType == "pvp" then
				MyZone = "Zone_ArathiBasin"
			elseif CurrentZoneId == 401 and InstanceType == "pvp" then
				MyZone = "Zone_AlteracValley"
			elseif (CurrentZoneId == 482 or CurrentZoneText == L["Eye of the Storm"]) and InstanceType == "pvp" then
				MyZone = "Zone_EyeoftheStorm"
			elseif CurrentZoneId == 540 and InstanceType == "pvp" then
				MyZone = "Zone_IsleofConquest"
			elseif CurrentZoneId == 512 and InstanceType == "pvp" then
				MyZone = "Zone_StrandoftheAncients"
			elseif CurrentZoneId == 626 and InstanceType == "pvp" then
				MyZone = "Zone_TwinPeaks"
			elseif CurrentZoneId == 736 and InstanceType == "pvp" then
				MyZone = "Zone_TheBattleforGilneas"
			elseif CurrentZoneId == 856 and InstanceType == "pvp" then
				MyZone = "Zone_TempleofKotmogu"
			elseif CurrentZoneId == 860 and InstanceType == "pvp" then
				MyZone = "Zone_SilvershardMines"
			elseif CurrentZoneId == 935 and InstanceType == "pvp" then
				MyZone = "Zone_DeepwindGorge"
			 -- Battlefields
			elseif CurrentZoneId == 501 then
				MyZone = "Zone_Wintergrasp"
			elseif CurrentZoneId == 708 then
				MyZone = "Zone_TolBarad"
			 -- Arenas
			elseif InstanceType == "arena" then
				MyZone = "Zone_Arenas"
			else
				MyZone = ""
			end
			-- Payback Kill time
			if MyZone == "Zone_AlteracValley" or MyZone == "Zone_IsleofConquest" or MyZone == "Zone_Wintergrasp" or MyZone == "Zone_TolBarad" then
				PS.PaybackKillTime = 120
			else
				PS.PaybackKillTime = 90
			end
			-- Player's Gender
			if UnitSex("player") == 2 then
				MyGender = "Male"
			elseif UnitSex("player") == 3 then
				MyGender = "Female"
			end
			if MyZone == "Zone_IsleofConquest" then
				IocAllianceGateDown = false
				IocHordeGateDown = false
				-- Alliance Gates
				for i = 9, 11, 1 do 
					if (select(3, GetMapLandmarkInfo(i))) == 82 then
						IocAllianceGateDown = true
					end
				end
				-- Horde Gates
				for i = 6, 8, 1 do 
					if (select(3, GetMapLandmarkInfo(i))) == 79 then
						IocHordeGateDown = true
					end
				end
			end
			if MyZone == "Zone_WarsongGulch" or MyZone == "Zone_TwinPeaks" or MyZone == "Zone_TolBarad" or MyZone == "Zone_StrandoftheAncients" --[[or MyZone == "Zone_Arenas"]] then
				local i
				if MyZone == "Zone_StrandoftheAncients" then
					i = 7
				--[[elseif MyZone == "Zone_Arenas" then
					i = 6]]
				else
					i = 4
				end
				if (select(4, GetWorldStateUIInfo(i))) ~= nil then
					-- Time Remaining
					local TimeRemainingInit = tonumber(string.match(select(4, GetWorldStateUIInfo(i)), "(%d+)"))
					TimeRemainingobjectives.TimeRemaining = nil
					TimeRemainingobjectives.TimeRemaining = TimeRemainingInit
				end
				if (select(4, GetWorldStateUIInfo(2))) ~= nil and (select(4, GetWorldStateUIInfo(3))) ~= nil then
					-- Alliance Score
					local AllianceScoreInit = tonumber(string.match(select(4, GetWorldStateUIInfo(2)), "(%d)/"))
					WSGandTPAobjectives.AllianceScore = nil
					WSGandTPAobjectives.AllianceScore = AllianceScoreInit
					-- Horde Score
					local HordeScoreInit = tonumber(string.match(select(4, GetWorldStateUIInfo(3)), "(%d)/"))
					WSGandTPHobjectives.HordeScore = nil
					WSGandTPHobjectives.HordeScore = HordeScoreInit
				end
			end
			if MyZone == "Zone_EyeoftheStorm" then
				--[[if IsRated == false then
					EOTSWINobjectives.VictoryPoints = nil
					local EOTSWINInit = tonumber(string.match(select(4, GetWorldStateUIInfo(3)), "(%d+)/"))
					EOTSWINobjectives.VictoryPoints = EOTSWINInit
					local EOTSWINInit = tonumber(string.match(select(4, GetWorldStateUIInfo(4)), "(%d+)/"))
					EOTSWINobjectives.VictoryPoints = EOTSWINInit
				end]]
				local BloodElfTowerInit = select(3, GetMapLandmarkInfo(1))
				local DraeneiRuinsInit = select(3, GetMapLandmarkInfo(4))
				local FelReaverRuinsInit = select(3, GetMapLandmarkInfo(3))
				local MageTowerInit = select(3, GetMapLandmarkInfo(3))
				EOTSobjectives.BloodElfTower = nil
				EOTSobjectives.DraeneiRuins = nil
				EOTSobjectives.FelReaverRuins = nil
				EOTSobjectives.MageTower = nil
				EOTSobjectives.BloodElfTower = BloodElfTowerInit + 100
				EOTSobjectives.DraeneiRuins = DraeneiRuinsInit + 200
				EOTSobjectives.FelReaverRuins = FelReaverRuinsInit + 300
				EOTSobjectives.MageTower = MageTowerInit + 400
			end
			if MyZone == "Zone_ArathiBasin" then
				local BlacksmithInit = select(3, GetMapLandmarkInfo(2))
				local FarmInit = select(3, GetMapLandmarkInfo(5))
				local GoldMineInit = select(3, GetMapLandmarkInfo(4))
				local LumberMillInit = select(3, GetMapLandmarkInfo(3))
				local StablesInit = select(3, GetMapLandmarkInfo(1))
				ABobjectives.Blacksmith = nil
				ABobjectives.Farm = nil
				ABobjectives.GoldMine = nil
				ABobjectives.LumberMill = nil
				ABobjectives.Stables = nil
				ABobjectives.Blacksmith = BlacksmithInit + 100
				ABobjectives.Farm = FarmInit + 200
				ABobjectives.GoldMine = GoldMineInit + 300
				ABobjectives.LumberMill = LumberMillInit + 400
				ABobjectives.Stables = StablesInit + 500
			end
			if MyZone == "Zone_AlteracValley" then
				local AVandIOCAInit = tonumber(string.match(select(4, GetWorldStateUIInfo(2)), ": (%d+)"))
				local AVandIOCHInit = tonumber(string.match(select(4, GetWorldStateUIInfo(3)), ": (%d+)"))
				local ColdtoothMineInit = select(3, GetMapLandmarkInfo(1))
				local DunBaldarNorthBunkerInit = select(3, GetMapLandmarkInfo(3))
				local DunBaldarSouthBunkerInit = select(3, GetMapLandmarkInfo(4))
				local EastFrostwolfTowerInit = select(3, GetMapLandmarkInfo(5))
				local FrostwolfGraveyardInit = select(3, GetMapLandmarkInfo(6))
				local FrostwolfReliefHutInit = select(3, GetMapLandmarkInfo(8))
				local IcebloodGraveyardInit = select(3, GetMapLandmarkInfo(10))
				local IcebloodTowerInit = select(3, GetMapLandmarkInfo(11))
				local IcewingBunkerInit = select(3, GetMapLandmarkInfo(12))
				local IrondeepMineInit = select(3, GetMapLandmarkInfo(14))
				local SnowfallGraveyardInit = select(3, GetMapLandmarkInfo(15))
				local StonehearthBunkerInit = select(3, GetMapLandmarkInfo(16))
				local StonehearthGraveyardInit = select(3, GetMapLandmarkInfo(17))
				local StormpikeAidStationInit = select(3, GetMapLandmarkInfo(19))
				local StormpikeGraveyardInit = select(3, GetMapLandmarkInfo(20))
				local TowerPointInit = select(3, GetMapLandmarkInfo(21))
				local WestFrostwolfTowerInit = select(3, GetMapLandmarkInfo(22))
				AVandIOCAobjectives.AllianceReinforcements = nil
				AVandIOCHobjectives.HordeReinforcements = nil
				AVobjectives.ColdtoothMine = nil
				AVobjectives.DunBaldarNorthBunker = nil
				AVobjectives.DunBaldarSouthBunker = nil
				AVobjectives.EastFrostwolfTower = nil
				AVobjectives.FrostwolfGraveyard = nil
				AVobjectives.FrostwolfReliefHut = nil
				AVobjectives.IcebloodGraveyard = nil
				AVobjectives.IcebloodTower = nil
				AVobjectives.IcewingBunker = nil
				AVobjectives.IrondeepMine = nil
				AVobjectives.SnowfallGraveyard = nil
				AVobjectives.StonehearthBunker = nil
				AVobjectives.StonehearthGraveyard = nil
				AVobjectives.StormpikeAidStation = nil
				AVobjectives.StormpikeGraveyard = nil
				AVobjectives.TowerPoint = nil
				AVobjectives.WestFrostwolfTower = nil
				AVandIOCAobjectives.AllianceReinforcements = AVandIOCAInit
				AVandIOCHobjectives.HordeReinforcements = AVandIOCHInit
				AVobjectives.ColdtoothMine = ColdtoothMineInit + 100
				AVobjectives.DunBaldarNorthBunker = DunBaldarNorthBunkerInit + 200
				AVobjectives.DunBaldarSouthBunker = DunBaldarSouthBunkerInit + 300
				AVobjectives.EastFrostwolfTower = EastFrostwolfTowerInit + 400
				AVobjectives.FrostwolfGraveyard = FrostwolfGraveyardInit + 500
				AVobjectives.FrostwolfReliefHut = FrostwolfReliefHutInit + 600
				AVobjectives.IcebloodGraveyard = IcebloodGraveyardInit + 700
				AVobjectives.IcebloodTower = IcebloodTowerInit + 800
				AVobjectives.IcewingBunker = IcewingBunkerInit + 900
				AVobjectives.IrondeepMine = IrondeepMineInit + 1000
				AVobjectives.SnowfallGraveyard = SnowfallGraveyardInit + 1100
				AVobjectives.StonehearthBunker = StonehearthBunkerInit + 1200
				AVobjectives.StonehearthGraveyard = StonehearthGraveyardInit + 1300
				AVobjectives.StormpikeAidStation = StormpikeAidStationInit + 1400
				AVobjectives.StormpikeGraveyard = StormpikeGraveyardInit + 1500
				AVobjectives.TowerPoint = TowerPointInit + 1600
				AVobjectives.WestFrostwolfTower = WestFrostwolfTowerInit + 1700
			end
			if MyZone == "Zone_IsleofConquest" then
				--[[local j, k, l, m, n, o, p, q, r, s, t
				if (select(4, GetMapLandmarkInfo(5))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(5)))), 1, 4)) == 0.51 and (select(5, GetMapLandmarkInfo(5))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(5)))), 1, 4)) == 0.77 and (select(4, GetMapLandmarkInfo(11))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(11)))), 1, 4)) == 0.48 and (select(5, GetMapLandmarkInfo(11))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(11)))), 1, 4)) == 0.28 then
					j = 1
					k = 2
					l = 3
					m = 6
					n = 7
					o = 8
					p = 9
					q = 10
					r = 13
					s = 14
					t = 15
				elseif (select(4, GetMapLandmarkInfo(5))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(5)))), 1, 4)) == 0.51 and (select(5, GetMapLandmarkInfo(5))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(5)))), 1, 4)) == 0.77 then
					j = 1
					k = 2
					l = 3
					m = 6
					n = 7
					o = 8
					p = 9
					q = 10
					r = 12
					s = 13
					t = 14
				elseif (select(4, GetMapLandmarkInfo(11))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(11)))), 1, 4)) == 0.48 and (select(5, GetMapLandmarkInfo(11))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(11)))), 1, 4)) == 0.28 then
					j = 1
					k = 2
					l = 3
					m = 5
					n = 6
					o = 7
					p = 8
					q = 9
					r = 12
					s = 13
					t = 14
				else
					j = 1
					k = 2
					l = 3
					m = 5
					n = 6
					o = 7
					p = 8
					q = 9
					r = 11
					s = 12
					t = 13
				end]]
				local AllianceGateEInit = select(3, GetMapLandmarkInfo(9))
				local AllianceGateWInit = select(3, GetMapLandmarkInfo(10))
				local AllianceGateSInit = select(3, GetMapLandmarkInfo(11))
				local DocksInit = select(3, GetMapLandmarkInfo(3))
				local HangarInit = select(3, GetMapLandmarkInfo(2))
				local HordeGateEInit = select(3, GetMapLandmarkInfo(7))
				local HordeGateWInit = select(3, GetMapLandmarkInfo(8))
				local HordeGateNInit = select(3, GetMapLandmarkInfo(6))
				local QuarryInit = select(3, GetMapLandmarkInfo(4))
				local RefinerieInit = select(3, GetMapLandmarkInfo(5))
				local WorkshopInit = select(3, GetMapLandmarkInfo(1))
				IOCobjectives.AllianceGateE = nil
				IOCobjectives.AllianceGateW = nil
				IOCobjectives.AllianceGateS = nil
				IOCobjectives.Docks = nil
				IOCobjectives.Hangar = nil
				IOCobjectives.HordeGateE = nil
				IOCobjectives.HordeGateW = nil
				IOCobjectives.HordeGateN = nil
				IOCobjectives.Quarry = nil
				IOCobjectives.Refinerie = nil
				IOCobjectives.Workshop = nil
				IOCobjectives.AllianceGateE = AllianceGateEInit + 100
				IOCobjectives.AllianceGateW = AllianceGateWInit + 200
				IOCobjectives.AllianceGateS = AllianceGateSInit + 300
				IOCobjectives.Docks = DocksInit
				IOCobjectives.Hangar = HangarInit
				IOCobjectives.HordeGateE = HordeGateEInit + 400
				IOCobjectives.HordeGateW = HordeGateWInit + 500
				IOCobjectives.HordeGateN = HordeGateNInit + 600
				IOCobjectives.Quarry = QuarryInit
				IOCobjectives.Refinerie = RefinerieInit
				IOCobjectives.Workshop = WorkshopInit
			end
			if MyZone == "Zone_StrandoftheAncients" then
				local j, k, l, m, n, o, p, q, r
				if (select(4, GetMapLandmarkInfo(2))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(2)))), 1, 4)) == 0.54 and (select(5, GetMapLandmarkInfo(2))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(2)))), 1, 4)) == 0.46 then
					j = 1
					k = 2
					l = 3
					m = 4
					n = 5
					o = 6
					p = 7
					q = 9
					r = 12
				elseif (select(4, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(3)))), 1, 4)) == 0.54 and (select(5, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(3)))), 1, 4)) == 0.46 then
					j = 2
					k = 3
					l = 4
					m = 5
					n = 6
					o = 7
					p = 8
					q = 9
					r = 12
				else
					j = 1
					k = 2
					l = 3
					m = 4
					n = 5
					o = 6
					p = nil
					q = nil
					r = nil
				end
				local ChamberofAncientRelicsInit = select(3, GetMapLandmarkInfo(j))
				local EastGraveyardInit = select(3, GetMapLandmarkInfo(k))
				local GateoftheBlueSapphireInit = select(3, GetMapLandmarkInfo(3))
				local GateoftheGreenEmeraldInit = select(3, GetMapLandmarkInfo(4))
				local GateofthePurpleAmethystInit = select(3, GetMapLandmarkInfo(1))
				local GateoftheRedSunInit = select(3, GetMapLandmarkInfo(2))
				local GateoftheYellowMoonInit
				local SouthGraveyardInit
				local WestGraveyardInit
				if p ~= nil then
					GateoftheYellowMoonInit = select(3, GetMapLandmarkInfo(p))
				end
				if q ~= nil then
					SouthGraveyardInit = select(3, GetMapLandmarkInfo(q))
				end
				if r ~= nil then
					WestGraveyardInit = select(3, GetMapLandmarkInfo(r))
				end
				SOTAobjectives.ChamberofAncientRelics = nil
				SOTAobjectives.EastGraveyard = nil
				SOTAobjectives.GateoftheBlueSapphire = nil
				SOTAobjectives.GateoftheGreenEmerald = nil
				SOTAobjectives.GateofthePurpleAmethyst = nil
				SOTAobjectives.GateoftheRedSun = nil
				SOTAobjectives.GateoftheYellowMoon = nil
				SOTAobjectives.SouthGraveyard = nil
				SOTAobjectives.WestGraveyard = nil
				SOTAobjectives.ChamberofAncientRelics = ChamberofAncientRelicsInit + 100
				SOTAobjectives.EastGraveyard = EastGraveyardInit + 200
				SOTAobjectives.GateoftheBlueSapphire = GateoftheBlueSapphireInit
				SOTAobjectives.GateoftheGreenEmerald = GateoftheGreenEmeraldInit
				SOTAobjectives.GateofthePurpleAmethyst = GateofthePurpleAmethystInit
				SOTAobjectives.GateoftheRedSun = GateoftheRedSunInit
				if p ~= nil then
					SOTAobjectives.GateoftheYellowMoon = GateoftheYellowMoonInit + 600 -- Intended
				end
				if q ~= nil then
					SOTAobjectives.SouthGraveyard = SouthGraveyardInit + 800
				end
				if r ~= nil then
					SOTAobjectives.WestGraveyard = WestGraveyardInit + 900
				end
			end
			if MyZone == "Zone_TheBattleforGilneas" then
				local LighthouseInit = select(3, GetMapLandmarkInfo(3))
				local MinesInit = select(3, GetMapLandmarkInfo(1))
				local WaterworksInit = select(3, GetMapLandmarkInfo(2))
				TBFGobjectives.Lighthouse = nil
				TBFGobjectives.Mines = nil
				TBFGobjectives.Waterworks = nil
				TBFGobjectives.Lighthouse = LighthouseInit + 100
				TBFGobjectives.Mines = MinesInit + 200
				TBFGobjectives.Waterworks = WaterworksInit + 300
			end
			if MyZone == "Zone_DeepwindGorge" then
				local CentralMineInit = select(3, GetMapLandmarkInfo(3))
				local GoblinMineInit = select(3, GetMapLandmarkInfo(2))
				local PandarenMineInit = select(3, GetMapLandmarkInfo(1))
				DGobjectives.CentralMine = nil
				DGobjectives.GoblinMine = nil
				DGobjectives.PandarenMine = nil
				DGobjectives.CentralMine = CentralMineInit + 100
				DGobjectives.GoblinMine = GoblinMineInit + 200
				DGobjectives.PandarenMine = PandarenMineInit + 300
			end
			if MyZone == "Zone_SilvershardMines" then
				local HordeScoreInit = (select(4, GetMapLandmarkInfo(2)))
				local AllianceScoreInit = (select(4, GetMapLandmarkInfo(3)))
				SMWINobjectives.Resources = nil
				if HordeScoreInit then
					SMWINobjectives.Resources = tonumber(string.match(select(4, GetWorldStateUIInfo(2)), "(%d+)/"))
				end
				if AllianceScoreInit then
					SMWINobjectives.Resources = tonumber(string.match(select(4, GetWorldStateUIInfo(3)), "(%d+)/"))
				end
			end
			if MyZone == "Zone_Wintergrasp" then
				local isActive = select(3, GetWorldPVPAreaInfo(1))
				if isActive == true then
					BgIsOver = false
				end
				local FlamewatchTowerInit = select(3, GetMapLandmarkInfo(5))
				local FortressGraveyardInit = select(3, GetMapLandmarkInfo(6))
				local ShadowsightTowerInit = select(3, GetMapLandmarkInfo(9))
				local WintersEdgeTowerInit = select(3, GetMapLandmarkInfo(15))
				local WintergraspFortressTowerNEInit = select(3, GetMapLandmarkInfo(18))
				local WintergraspFortressTowerNWInit = select(3, GetMapLandmarkInfo(19))
				local WintergraspFortressTowerSEInit = select(3, GetMapLandmarkInfo(20))
				local WintergraspFortressTowerSWInit = select(3, GetMapLandmarkInfo(21))
				WGobjectives.FlamewatchTower = nil
				WGobjectives.FortressGraveyard = nil
				WGobjectives.ShadowsightTower = nil
				WGobjectives.WintersEdgeTower = nil
				WGobjectives.WintergraspFortressTowerNE = nil
				WGobjectives.WintergraspFortressTowerNW = nil
				WGobjectives.WintergraspFortressTowerSE = nil
				WGobjectives.WintergraspFortressTowerSW = nil
				WGobjectives.FlamewatchTower = FlamewatchTowerInit + 100
				WGobjectives.FortressGraveyard = FortressGraveyardInit
				WGobjectives.ShadowsightTower = ShadowsightTowerInit + 200
				WGobjectives.WintersEdgeTower = WintersEdgeTowerInit + 300
				WGobjectives.WintergraspFortressTowerNE = WintergraspFortressTowerNEInit + 400
				WGobjectives.WintergraspFortressTowerNW = WintergraspFortressTowerNWInit + 500
				WGobjectives.WintergraspFortressTowerSE = WintergraspFortressTowerSEInit + 600
				WGobjectives.WintergraspFortressTowerSW = WintergraspFortressTowerSWInit + 700
			end
			if MyZone == "Zone_TolBarad" then
				local isActive = select(3, GetWorldPVPAreaInfo(2))
				if isActive == true then
					BgIsOver = false
				end
				local j, k, l, m, n, o
				if (select(4, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(3)))), 1, 4)) == 0.73 and (select(5, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(3)))), 1, 4)) == 0.33 and (select(4, GetMapLandmarkInfo(7))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(7)))), 1, 4)) == 0.52 and (select(5, GetMapLandmarkInfo(7))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(7)))), 1, 4)) == 0.78 then
					j = 4
					k = 5
					l = 8
					m = 2
					n = 6
					o = 9
				elseif (select(4, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(3)))), 1, 4)) == 0.73 and (select(5, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(3)))), 1, 4)) == 0.33 then
					j = 4
					k = 5
					l = 7
					m = 2
					n = 6
					o = 8
				elseif (select(4, GetMapLandmarkInfo(6))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(6)))), 1, 4)) == 0.52 and (select(5, GetMapLandmarkInfo(6))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(6)))), 1, 4)) == 0.78 then
					j = 3
					k = 4
					l = 7
					m = 2
					n = 5
					o = 8
				else
					j = 3
					k = 4
					l = 6
					m = 2
					n = 5
					o = 7
				end
				local BaradinHoldInit = select(3, GetMapLandmarkInfo(1))
				local IroncladGarrisonInit = select(3, GetMapLandmarkInfo(j))
				local SlagworksInit = select(3, GetMapLandmarkInfo(k))
				local WardensVigilInit = select(3, GetMapLandmarkInfo(l))
				local EastSpireInit = select(3, GetMapLandmarkInfo(m))
				local SouthSpireInit = select(3, GetMapLandmarkInfo(n))
				local WestSpireInit = select(3, GetMapLandmarkInfo(o))
				TBobjectives.BaradinHold = nil
				TBobjectives.IroncladGarrison = nil
				TBobjectives.Slagworks = nil
				TBobjectives.WardensVigil = nil
				TBobjectives.EastSpire = nil
				TBobjectives.SouthSpire = nil
				TBobjectives.WestSpire = nil
				TBobjectives.BaradinHold = BaradinHoldInit
				TBobjectives.IroncladGarrison = IroncladGarrisonInit + 100
				TBobjectives.Slagworks = SlagworksInit + 200
				TBobjectives.WardensVigil = WardensVigilInit + 300
				TBobjectives.EastSpire = EastSpireInit + 400
				TBobjectives.SouthSpire = SouthSpireInit + 500
				TBobjectives.WestSpire = WestSpireInit + 600
			end
		end

		if event == "PLAYER_DEAD" then
			local Channel
			if WowBuildInfo >= 50100 then
				Channel = "INSTANCE_CHAT"
			elseif WowBuildInfo >= 40200 then
				Channel = "BATTLEGROUND"
			elseif WowBuildInfo >= 40100 then
				Channel = "BATTLEGROUND"
			else
				Channel = "BATTLEGROUND"
			end
			-- Death Data Share
			if KilledBy ~= nil then
				if PS_DataShare == true then
					if CurrentStreak ~= nil then
						local KillSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."KillDurations")
						local Message
						if CurrentStreak <= table.getn(KillSoundLengthTable) then
							Message = KillSoundLengthTable[CurrentStreak].name
						else
							Message = KillSoundLengthTable[table.getn(KillSoundLengthTable)].name
						end
						if string.find(KilledBy, "!") then
							GotKilledBy = string.sub(KilledBy, 1, string.len(KilledBy) - 1)
						else
							GotKilledBy = tostring(KilledBy)
						end
						if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance() then
							if InstanceType == "pvp" or InstanceType == "arena" or InstanceType == "raid" or InstanceType == "party" or InstanceType == nil then
								SendAddonMessage("PVPSound", Message..":"..GotKilledBy, Channel)
							end
						else
							SendAddonMessage("PVPSound", Message..":"..GotKilledBy, "RAID")
						end
					end
				end
				-- Death Messages
				if PS_DeathMessage == true then
					if string.sub(KilledBy, - 1) == "!" then
						GotKilledBy = string.sub(KilledBy, 1, string.len(KilledBy) - 1)
					else
						if string.find(KilledBy, "-") and PS_HideServerName ~= false then
							GotKilledBy = tostring(string.match(KilledBy, "(.+)-"))
							if string.find(GotKilledBy, "-") then
								GotKilledBy = tostring(string.match(GotKilledBy, "(.+)-"))
							end
						else
							GotKilledBy = tostring(KilledBy)
						end
					end
					if GotKilledBy ~= nil then
						print("|cFFFF4500"..Msg_YouGotKilledBy.." "..GotKilledBy.."!|r")
					end
					GotKilledBy = nil
				end
				KilledBy = nil
			end
			TimerReset = true
		end

		if PS_BattlegroundSound == true then
			if event == "ZONE_CHANGED_NEW_AREA" then
				SetMapToCurrentZone()
				CurrentZoneId = GetCurrentMapAreaID()
				CurrentZoneText = GetRealZoneText()
				InstanceType = (select(2, IsInInstance()))
				IsRated = IsRatedBattleground()
				BgIsOver = false
				-- Battlegrounds
				if CurrentZoneId == 443 and InstanceType == "pvp" then
					MyZone = "Zone_WarsongGulch"
				elseif CurrentZoneId == 461 and InstanceType == "pvp" then
					MyZone = "Zone_ArathiBasin"
				elseif CurrentZoneId == 401 and InstanceType == "pvp" then
					MyZone = "Zone_AlteracValley"
				elseif (CurrentZoneId == 482 or CurrentZoneText == L["Eye of the Storm"]) and InstanceType == "pvp" then
					MyZone = "Zone_EyeoftheStorm"
				elseif CurrentZoneId == 540 and InstanceType == "pvp" then
					MyZone = "Zone_IsleofConquest"
				elseif CurrentZoneId == 512 and InstanceType == "pvp" then
					MyZone = "Zone_StrandoftheAncients"
					SotaRoundOver = false
				elseif CurrentZoneId == 626 and InstanceType == "pvp" then
					MyZone = "Zone_TwinPeaks"
				elseif CurrentZoneId == 736 and InstanceType == "pvp" then
					MyZone = "Zone_TheBattleforGilneas"
				elseif CurrentZoneId == 856 and InstanceType == "pvp" then
					MyZone = "Zone_TempleofKotmogu"
				elseif CurrentZoneId == 860 and InstanceType == "pvp" then
					MyZone = "Zone_SilvershardMines"
				elseif CurrentZoneId == 935 and InstanceType == "pvp" then
					MyZone = "Zone_DeepwindGorge"
				 -- Battlefields
				elseif CurrentZoneId == 501 then
					MyZone = "Zone_Wintergrasp"
				elseif CurrentZoneId == 708 then
					MyZone = "Zone_TolBarad"
				 -- Arenas
				elseif InstanceType == "arena" then
					MyZone = "Zone_Arenas"
				else
					MyZone = ""
				end
				-- Payback Kill time
				if MyZone == "Zone_AlteracValley" or MyZone == "Zone_IsleofConquest" or MyZone == "Zone_Wintergrasp" or MyZone == "Zone_TolBarad" then
					PS.PaybackKillTime = 120
				else
					PS.PaybackKillTime = 90
				end
				-- Initialization
				if MyZone == "Zone_IsleofConquest" then
					IocAllianceGateDown = false
					IocHordeGateDown = false
					-- Alliance Gates
					for i = 9, 11, 1 do 
						if select(3, GetMapLandmarkInfo(i)) == 82 then
							IocAllianceGateDown = true
						end
					end
					-- Horde Gates
					for i = 6, 8, 1 do 
						if select(3, GetMapLandmarkInfo(i)) == 79 then
							IocHordeGateDown = true
						end
					end
				end
				if MyZone == "Zone_WarsongGulch" or MyZone == "Zone_TwinPeaks" or MyZone == "Zone_TolBarad" or MyZone == "Zone_StrandoftheAncients" --[[or MyZone == "Zone_Arenas"]] then
					local i
					if MyZone == "Zone_StrandoftheAncients" then
						i = 7
					--[[elseif MyZone == "Zone_Arenas" then
						i = 6]]
					else
						i = 4
					end
					if (select(4, GetWorldStateUIInfo(i))) ~= nil then
						-- Time Remaining
						local TimeRemainingInit = tonumber(string.match(select(4, GetWorldStateUIInfo(i)), "(%d+)"))
						TimeRemainingobjectives.TimeRemaining = nil
						TimeRemainingobjectives.TimeRemaining = TimeRemainingInit
					end
					if (select(4, GetWorldStateUIInfo(2))) ~= nil and (select(4, GetWorldStateUIInfo(3))) ~= nil then
						-- Alliance Score
						local AllianceScoreInit = tonumber(string.match(select(4, GetWorldStateUIInfo(2)), "(%d)/"))
						WSGandTPAobjectives.AllianceScore = nil
						WSGandTPAobjectives.AllianceScore = AllianceScoreInit
						-- Horde Score
						local HordeScoreInit = tonumber(string.match(select(4, GetWorldStateUIInfo(3)), "(%d)/"))
						WSGandTPHobjectives.HordeScore = nil
						WSGandTPHobjectives.HordeScore = HordeScoreInit
					end
				end
				if MyZone == "Zone_EyeoftheStorm" then
					--[[if IsRated == false then
						EOTSWINobjectives.VictoryPoints = nil
						local EOTSWINInit = tonumber(string.match(select(4, GetWorldStateUIInfo(3)), "(%d+)/"))
						EOTSWINobjectives.VictoryPoints = EOTSWINInit
						local EOTSWINInit = tonumber(string.match(select(4, GetWorldStateUIInfo(4)), "(%d+)/"))
						EOTSWINobjectives.VictoryPoints = EOTSWINInit
					end]]
					local BloodElfTowerInit = (select(3, GetMapLandmarkInfo(1)))
					local DraeneiRuinsInit = (select(3, GetMapLandmarkInfo(4)))
					local FelReaverRuinsInit = (select(3, GetMapLandmarkInfo(2)))
					local MageTowerInit = (select(3, GetMapLandmarkInfo(3)))
					EOTSobjectives.BloodElfTower = nil
					EOTSobjectives.DraeneiRuins = nil
					EOTSobjectives.FelReaverRuins = nil
					EOTSobjectives.MageTower = nil
					EOTSobjectives.BloodElfTower = BloodElfTowerInit + 100
					EOTSobjectives.DraeneiRuins = DraeneiRuinsInit + 200
					EOTSobjectives.FelReaverRuins = FelReaverRuinsInit + 300
					EOTSobjectives.MageTower = MageTowerInit + 400
				end
				if MyZone == "Zone_ArathiBasin" then
					local BlacksmithInit = (select(3, GetMapLandmarkInfo(2)))
					local FarmInit = (select(3, GetMapLandmarkInfo(5)))
					local GoldMineInit = (select(3, GetMapLandmarkInfo(4)))
					local LumberMillInit = (select(3, GetMapLandmarkInfo(3)))
					local StablesInit = (select(3, GetMapLandmarkInfo(1)))
					ABobjectives.Blacksmith = nil
					ABobjectives.Farm = nil
					ABobjectives.GoldMine = nil
					ABobjectives.LumberMill = nil
					ABobjectives.Stables = nil
					ABobjectives.Blacksmith = BlacksmithInit + 100
					ABobjectives.Farm = FarmInit + 200
					ABobjectives.GoldMine = GoldMineInit + 300
					ABobjectives.LumberMill = LumberMillInit + 400
					ABobjectives.Stables = StablesInit + 500
				end
				if MyZone == "Zone_AlteracValley" then
					local AllianceReinforcements = (select(4, GetWorldStateUIInfo(2)))
					local AVandIOCAInit
					if AllianceReinforcements then
						AVandIOCAInit = tonumber(string.match(AllianceReinforcements, ": (%d+)"))
					end
					local HordeReinforcements = (select(4, GetWorldStateUIInfo(3)))
					local AVandIOCHInit
					if HordeReinforcements then
						AVandIOCHInit = tonumber(string.match(HordeReinforcements, ": (%d+)"))
					end
					local ColdtoothMineInit = (select(3, GetMapLandmarkInfo(1)))
					local DunBaldarNorthBunkerInit = (select(3, GetMapLandmarkInfo(3)))
					local DunBaldarSouthBunkerInit = (select(3, GetMapLandmarkInfo(4)))
					local EastFrostwolfTowerInit = (select(3, GetMapLandmarkInfo(5)))
					local FrostwolfGraveyardInit = (select(3, GetMapLandmarkInfo(6)))
					local FrostwolfReliefHutInit = (select(3, GetMapLandmarkInfo(8)))
					local IcebloodGraveyardInit = (select(3, GetMapLandmarkInfo(10)))
					local IcebloodTowerInit = (select(3, GetMapLandmarkInfo(11)))
					local IcewingBunkerInit = (select(3, GetMapLandmarkInfo(12)))
					local IrondeepMineInit = (select(3, GetMapLandmarkInfo(14)))
					local SnowfallGraveyardInit = (select(3, GetMapLandmarkInfo(15)))
					local StonehearthBunkerInit = (select(3, GetMapLandmarkInfo(16)))
					local StonehearthGraveyardInit = (select(3, GetMapLandmarkInfo(17)))
					local StormpikeAidStationInit = (select(3, GetMapLandmarkInfo(19)))
					local StormpikeGraveyardInit = (select(3, GetMapLandmarkInfo(20)))
					local TowerPointInit = (select(3, GetMapLandmarkInfo(21)))
					local WestFrostwolfTowerInit = (select(3, GetMapLandmarkInfo(22)))
					AVandIOCAobjectives.AllianceReinforcements = nil
					AVandIOCHobjectives.HordeReinforcements = nil
					AVobjectives.ColdtoothMine = nil
					AVobjectives.DunBaldarNorthBunker = nil
					AVobjectives.DunBaldarSouthBunker = nil
					AVobjectives.EastFrostwolfTower = nil
					AVobjectives.FrostwolfGraveyard = nil
					AVobjectives.FrostwolfReliefHut = nil
					AVobjectives.IcebloodGraveyard = nil
					AVobjectives.IcebloodTower = nil
					AVobjectives.IcewingBunker = nil
					AVobjectives.IrondeepMine = nil
					AVobjectives.SnowfallGraveyard = nil
					AVobjectives.StonehearthBunker = nil
					AVobjectives.StonehearthGraveyard = nil
					AVobjectives.StormpikeAidStation = nil
					AVobjectives.StormpikeGraveyard = nil
					AVobjectives.TowerPoint = nil
					AVobjectives.WestFrostwolfTower = nil
					AVandIOCAobjectives.AllianceReinforcements = AVandIOCAInit
					AVandIOCHobjectives.HordeReinforcements = AVandIOCHInit
					AVobjectives.ColdtoothMine = ColdtoothMineInit + 100
					AVobjectives.DunBaldarNorthBunker = DunBaldarNorthBunkerInit + 200
					AVobjectives.DunBaldarSouthBunker = DunBaldarSouthBunkerInit + 300
					AVobjectives.EastFrostwolfTower = EastFrostwolfTowerInit + 400
					AVobjectives.FrostwolfGraveyard = FrostwolfGraveyardInit + 500
					AVobjectives.FrostwolfReliefHut = FrostwolfReliefHutInit + 600
					AVobjectives.IcebloodGraveyard = IcebloodGraveyardInit + 700
					AVobjectives.IcebloodTower = IcebloodTowerInit + 800
					AVobjectives.IcewingBunker = IcewingBunkerInit + 900
					AVobjectives.IrondeepMine = IrondeepMineInit + 1000
					AVobjectives.SnowfallGraveyard = SnowfallGraveyardInit + 1100
					AVobjectives.StonehearthBunker = StonehearthBunkerInit + 1200
					AVobjectives.StonehearthGraveyard = StonehearthGraveyardInit + 1300
					AVobjectives.StormpikeAidStation = StormpikeAidStationInit + 1400
					AVobjectives.StormpikeGraveyard = StormpikeGraveyardInit + 1500
					AVobjectives.TowerPoint = TowerPointInit + 1600
					AVobjectives.WestFrostwolfTower = WestFrostwolfTowerInit + 1700
				end
				if MyZone == "Zone_IsleofConquest" then
					--[[local j, k, l, m, n, o, p, q, r, s, t
					if (select(4, GetMapLandmarkInfo(5))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(5)))), 1, 4)) == 0.51 and (select(5, GetMapLandmarkInfo(5))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(5)))), 1, 4)) == 0.77 and (select(4, GetMapLandmarkInfo(11))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(11)))), 1, 4)) == 0.48 and (select(5, GetMapLandmarkInfo(11))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(11)))), 1, 4)) == 0.28 then
						j = 1
						k = 2
						l = 3
						m = 6
						n = 7
						o = 8
						p = 9
						q = 10
						r = 13
						s = 14
						t = 15
					elseif (select(4, GetMapLandmarkInfo(5))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(5)))), 1, 4)) == 0.51 and (select(5, GetMapLandmarkInfo(5))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(5)))), 1, 4)) == 0.77 then
						j = 1
						k = 2
						l = 3
						m = 6
						n = 7
						o = 8
						p = 9
						q = 10
						r = 12
						s = 13
						t = 14
					elseif (select(4, GetMapLandmarkInfo(11))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(11)))), 1, 4)) == 0.48 and (select(5, GetMapLandmarkInfo(11))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(11)))), 1, 4)) == 0.28 then
						j = 1
						k = 2
						l = 3
						m = 5
						n = 6
						o = 7
						p = 8
						q = 9
						r = 12
						s = 13
						t = 14
					else
						j = 1
						k = 2
						l = 3
						m = 5
						n = 6
						o = 7
						p = 8
						q = 9
						r = 11
						s = 12
						t = 13
					end]]
					local AllianceGateEInit = (select(3, GetMapLandmarkInfo(9)))
					local AllianceGateWInit = (select(3, GetMapLandmarkInfo(10)))
					local AllianceGateSInit = (select(3, GetMapLandmarkInfo(11)))
					local DocksInit = (select(3, GetMapLandmarkInfo(3)))
					local HangarInit = (select(3, GetMapLandmarkInfo(2)))
					local HordeGateEInit = (select(3, GetMapLandmarkInfo(7)))
					local HordeGateWInit = (select(3, GetMapLandmarkInfo(8)))
					local HordeGateNInit = (select(3, GetMapLandmarkInfo(6)))
					local QuarryInit = (select(3, GetMapLandmarkInfo(4)))
					local RefinerieInit = (select(3, GetMapLandmarkInfo(5)))
					local WorkshopInit = (select(3, GetMapLandmarkInfo(1)))
					IOCobjectives.AllianceGateE = nil
					IOCobjectives.AllianceGateW = nil
					IOCobjectives.AllianceGateS = nil
					IOCobjectives.Docks = nil
					IOCobjectives.Hangar = nil
					IOCobjectives.HordeGateE = nil
					IOCobjectives.HordeGateW = nil
					IOCobjectives.HordeGateN = nil
					IOCobjectives.Quarry = nil
					IOCobjectives.Refinerie = nil
					IOCobjectives.Workshop = nil
					IOCobjectives.AllianceGateE = AllianceGateEInit + 100
					IOCobjectives.AllianceGateW = AllianceGateWInit + 200
					IOCobjectives.AllianceGateS = AllianceGateSInit + 300
					IOCobjectives.Docks = DocksInit
					IOCobjectives.Hangar = HangarInit
					IOCobjectives.HordeGateE = HordeGateEInit + 400
					IOCobjectives.HordeGateW = HordeGateWInit + 500
					IOCobjectives.HordeGateN = HordeGateNInit + 600
					IOCobjectives.Quarry = QuarryInit
					IOCobjectives.Refinerie = RefinerieInit
					IOCobjectives.Workshop = WorkshopInit
				end
				if MyZone == "Zone_StrandoftheAncients" then
					local j, k, l, m, n, o, p, q, r
					if (select(4, GetMapLandmarkInfo(2))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(2)))), 1, 4)) == 0.54 and (select(5, GetMapLandmarkInfo(2))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(2)))), 1, 4)) == 0.46 then
						j = 1
						k = 2
						l = 3
						m = 4
						n = 5
						o = 6
						p = 7
						q = 9
						r = 12
					elseif (select(4, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(3)))), 1, 4)) == 0.54 and (select(5, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(3)))), 1, 4)) == 0.46 then
						j = 2
						k = 3
						l = 4
						m = 5
						n = 6
						o = 7
						p = 8
						q = 9
						r = 12
					else
						j = 1
						k = 2
						l = 3
						m = 4
						n = 5
						o = 6
						p = nil
						q = nil
						r = nil
					end
					local ChamberofAncientRelicsInit = (select(3, GetMapLandmarkInfo(j)))
					local EastGraveyardInit = (select(3, GetMapLandmarkInfo(k)))
					local GateoftheBlueSapphireInit = (select(3, GetMapLandmarkInfo(3)))
					local GateoftheGreenEmeraldInit = (select(3, GetMapLandmarkInfo(4)))
					local GateofthePurpleAmethystInit = (select(3, GetMapLandmarkInfo(1)))
					local GateoftheRedSunInit = (select(3, GetMapLandmarkInfo(2)))
					local GateoftheYellowMoonInit
					local SouthGraveyardInit
					local WestGraveyardInit
					if p ~= nil then
						GateoftheYellowMoonInit = (select(3, GetMapLandmarkInfo(p)))
					end
					if q ~= nil then
						SouthGraveyardInit = (select(3, GetMapLandmarkInfo(q)))
					end
					if r ~= nil then
						WestGraveyardInit = (select(3, GetMapLandmarkInfo(r)))
					end
					SOTAobjectives.ChamberofAncientRelics = nil
					SOTAobjectives.EastGraveyard = nil
					SOTAobjectives.GateoftheBlueSapphire = nil
					SOTAobjectives.GateoftheGreenEmerald = nil
					SOTAobjectives.GateofthePurpleAmethyst = nil
					SOTAobjectives.GateoftheRedSun = nil
					SOTAobjectives.GateoftheYellowMoon = nil
					SOTAobjectives.SouthGraveyard = nil
					SOTAobjectives.WestGraveyard = nil
					SOTAobjectives.ChamberofAncientRelics = ChamberofAncientRelicsInit + 100
					SOTAobjectives.EastGraveyard = EastGraveyardInit + 200
					SOTAobjectives.GateoftheBlueSapphire = GateoftheBlueSapphireInit
					SOTAobjectives.GateoftheGreenEmerald = GateoftheGreenEmeraldInit
					SOTAobjectives.GateofthePurpleAmethyst = GateofthePurpleAmethystInit
					SOTAobjectives.GateoftheRedSun = GateoftheRedSunInit
					if p ~= nil then
						SOTAobjectives.GateoftheYellowMoon = GateoftheYellowMoonInit + 600 -- Intended
					end
					if q ~= nil then
						SOTAobjectives.SouthGraveyard = SouthGraveyardInit + 800
					end
					if r ~= nil then
						SOTAobjectives.WestGraveyard = WestGraveyardInit + 900
					end
				end
				if MyZone == "Zone_TheBattleforGilneas" then
					local LighthouseInit = (select(3, GetMapLandmarkInfo(3)))
					local MinesInit = (select(3, GetMapLandmarkInfo(1)))
					local WaterworksInit = (select(3, GetMapLandmarkInfo(2)))
					TBFGobjectives.Lighthouse = nil
					TBFGobjectives.Mines = nil
					TBFGobjectives.Waterworks = nil
					TBFGobjectives.Lighthouse = LighthouseInit + 100
					TBFGobjectives.Mines = MinesInit + 200
					TBFGobjectives.Waterworks = WaterworksInit + 300
				end
				if MyZone == "Zone_DeepwindGorge" then
					local CentralMineInit = (select(3, GetMapLandmarkInfo(3)))
					local GoblinMineInit = (select(3, GetMapLandmarkInfo(2)))
					local PandarenMineInit = (select(3, GetMapLandmarkInfo(1)))
					DGobjectives.CentralMine = nil
					DGobjectives.GoblinMine = nil
					DGobjectives.PandarenMine = nil
					DGobjectives.CentralMine = CentralMineInit + 100
					DGobjectives.GoblinMine = GoblinMineInit + 200
					DGobjectives.PandarenMine = PandarenMineInit + 300
				end
				if MyZone == "Zone_SilvershardMines" then
					local HordeScoreInit = (select(4, GetMapLandmarkInfo(2)))
					local AllianceScoreInit = (select(4, GetMapLandmarkInfo(3)))
					SMWINobjectives.Resources = nil
					if HordeScoreInit then
						SMWINobjectives.Resources = tonumber(string.match(select(4, GetWorldStateUIInfo(2)), "(%d+)/"))
					end
					if AllianceScoreInit then
						SMWINobjectives.Resources = tonumber(string.match(select(4, GetWorldStateUIInfo(3)), "(%d+)/"))
					end
				end
				if MyZone == "Zone_Wintergrasp" then
					local isActive = select(3, GetWorldPVPAreaInfo(1))
					if isActive == true then
						BgIsOver = false
					end
					local FlamewatchTowerInit = (select(3, GetMapLandmarkInfo(5)))
					local FortressGraveyardInit = (select(3, GetMapLandmarkInfo(6)))
					local ShadowsightTowerInit = (select(3, GetMapLandmarkInfo(9)))
					local WintersEdgeTowerInit = (select(3, GetMapLandmarkInfo(15)))
					local WintergraspFortressTowerNEInit = (select(3, GetMapLandmarkInfo(18)))
					local WintergraspFortressTowerNWInit = (select(3, GetMapLandmarkInfo(19)))
					local WintergraspFortressTowerSEInit = (select(3, GetMapLandmarkInfo(20)))
					local WintergraspFortressTowerSWInit = (select(3, GetMapLandmarkInfo(21)))
					WGobjectives.FlamewatchTower = nil
					WGobjectives.FortressGraveyard = nil
					WGobjectives.ShadowsightTower = nil
					WGobjectives.WintersEdgeTower = nil
					WGobjectives.WintergraspFortressTowerNE = nil
					WGobjectives.WintergraspFortressTowerNW = nil
					WGobjectives.WintergraspFortressTowerSE = nil
					WGobjectives.WintergraspFortressTowerSW = nil
					WGobjectives.FlamewatchTower = FlamewatchTowerInit + 100
					WGobjectives.FortressGraveyard = FortressGraveyardInit
					WGobjectives.ShadowsightTower = ShadowsightTowerInit + 200
					WGobjectives.WintersEdgeTower = WintersEdgeTowerInit + 300
					WGobjectives.WintergraspFortressTowerNE = WintergraspFortressTowerNEInit + 400
					WGobjectives.WintergraspFortressTowerNW = WintergraspFortressTowerNWInit + 500
					WGobjectives.WintergraspFortressTowerSE = WintergraspFortressTowerSEInit + 600
					WGobjectives.WintergraspFortressTowerSW = WintergraspFortressTowerSWInit + 700
				end
				if MyZone == "Zone_TolBarad" then
					local isActive = (select(3, GetWorldPVPAreaInfo(2)))
					if isActive == true then
						BgIsOver = false
					end
					local j, k, l, m, n, o
					if (select(4, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(3)))), 1, 4)) == 0.73 and (select(5, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(3)))), 1, 4)) == 0.33 and (select(4, GetMapLandmarkInfo(7))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(7)))), 1, 4)) == 0.52 and (select(5, GetMapLandmarkInfo(7))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(7)))), 1, 4)) == 0.78 then
						j = 4
						k = 5
						l = 8
						m = 2
						n = 6
						o = 9
					elseif (select(4, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(3)))), 1, 4)) == 0.73 and (select(5, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(3)))), 1, 4)) == 0.33 then
						j = 4
						k = 5
						l = 7
						m = 2
						n = 6
						o = 8
					elseif (select(4, GetMapLandmarkInfo(6))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(6)))), 1, 4)) == 0.52 and (select(5, GetMapLandmarkInfo(6))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(6)))), 1, 4)) == 0.78 then
						j = 3
						k = 4
						l = 7
						m = 2
						n = 5
						o = 8
					else
						j = 3
						k = 4
						l = 6
						m = 2
						n = 5
						o = 7
					end
					local BaradinHoldInit = (select(3, GetMapLandmarkInfo(1)))
					local IroncladGarrisonInit = (select(3, GetMapLandmarkInfo(j)))
					local SlagworksInit = (select(3, GetMapLandmarkInfo(k)))
					local WardensVigilInit = (select(3, GetMapLandmarkInfo(l)))
					local EastSpireInit = (select(3, GetMapLandmarkInfo(m)))
					local SouthSpireInit = (select(3, GetMapLandmarkInfo(n)))
					local WestSpireInit = (select(3, GetMapLandmarkInfo(o)))
					TBobjectives.BaradinHold = nil
					TBobjectives.IroncladGarrison = nil
					TBobjectives.Slagworks = nil
					TBobjectives.WardensVigil = nil
					TBobjectives.EastSpire = nil
					TBobjectives.SouthSpire = nil
					TBobjectives.WestSpire = nil
					TBobjectives.BaradinHold = BaradinHoldInit
					TBobjectives.IroncladGarrison = IroncladGarrisonInit + 100
					TBobjectives.Slagworks = SlagworksInit + 200
					TBobjectives.WardensVigil = WardensVigilInit + 300
					TBobjectives.EastSpire = EastSpireInit + 400
					TBobjectives.SouthSpire = SouthSpireInit + 500
					TBobjectives.WestSpire = WestSpireInit + 600
				end
				-- Battleground PlaySounds
				if MyZone == "Zone_WarsongGulch" or MyZone == "Zone_EyeoftheStorm" or MyZone == "Zone_ArathiBasin" or MyZone == "Zone_AlteracValley" or MyZone == "Zone_IsleofConquest" or MyZone == "Zone_StrandoftheAncients" or MyZone == "Zone_TwinPeaks" or MyZone == "Zone_TheBattleforGilneas" or MyZone == "Zone_TempleofKotmogu" or MyZone == "Zone_SilvershardMines" or MyZone == "Zone_DeepwindGorge" then
					TimerReset = true
					KilledMe = nil
					KilledBy = nil
					if IsRated == true then
						local AllianceSpellName = (select(1, GetSpellInfo(81748)))
						local HordeSpellName = (select(1, GetSpellInfo(81744)))
						-- Alliance RBG buff
						if MyFaction == "Horde" and AllianceSpellName ~= nil and (select(11, UnitBuff("player", AllianceSpellName))) == 81748 and AlreadyPlaySound ~= true then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\PlayYouAreOnBlue.mp3")
							AlreadyPlaySound = true
						 -- Horde RBG buff
						elseif MyFaction == "Alliance" and HordeSpellName ~= nil and (select(11, UnitBuff("player", HordeSpellName))) == 81744 and AlreadyPlaySound ~= true then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\PlayYouAreOnRed.mp3")
							AlreadyPlaySound = true
						else
							if MyFaction == "Alliance" and AlreadyPlaySound ~= true then
								PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\PlayYouAreOnBlue.mp3")
								AlreadyPlaySound = true
							elseif MyFaction == "Horde" and AlreadyPlaySound ~= true then
								PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\PlayYouAreOnRed.mp3")
								AlreadyPlaySound = true
							end
						end
					else
						if MyFaction == "Alliance" and AlreadyPlaySound ~= true then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\PlayYouAreOnBlue.mp3")
							AlreadyPlaySound = true
						elseif MyFaction == "Horde" and AlreadyPlaySound ~= true then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\PlayYouAreOnRed.mp3")
							AlreadyPlaySound = true
						end
					end
				 -- Arena PlaySounds
				elseif MyZone == "Zone_Arenas" then
					TimerReset = true
					KilledMe = nil
					KilledBy = nil
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\PrepareForBattle.mp3")
				 -- Wintergrasp PlaySounds
				elseif MyZone == "Zone_Wintergrasp" then
					TimerReset = true
					KilledMe = nil
					KilledBy = nil
					local isActive = (select(3, GetWorldPVPAreaInfo(1)))
					if isActive == true then
						for i = 7, 7, 1 do
							local textureIndex = select(3, GetMapLandmarkInfo(i))
							if textureIndex then
								if textureIndex == 68 then
									WgAttacker = "Alliance"
								elseif textureIndex == 71 then
									WgAttacker = "Horde"
								end
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
				 -- Tol Barad PlaySounds
				elseif MyZone == "Zone_TolBarad" then
					TimerReset = true
					KilledMe = nil
					KilledBy = nil
					local isActive = (select(3, GetWorldPVPAreaInfo(2)))
					if isActive == true then
						for i = 1, 1, 1 do
							local textureIndex = (select(3, GetMapLandmarkInfo(i)))
							if textureIndex then
								if textureIndex == 48 then
									TbAttacker = "Alliance"
								elseif textureIndex == 46 then
									TbAttacker = "Horde"
								end
							end
						end
						if TbAttacker == "Alliance" and MyFaction == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\PlayYouAreOnBlueAttackTheEnemyCore.mp3")
						elseif TbAttacker == "Alliance" and MyFaction == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\PlayYouAreOnRedDefendYourCore.mp3")
						elseif TbAttacker == "Horde" and MyFaction == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\PlayYouAreOnBlueDefendYourCore.mp3")
						elseif TbAttacker == "Horde" and MyFaction == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\PlayYouAreOnRedAttackTheEnemyCore.mp3")
						end
					end
				end
				 -- This stuff needs to be here
				AlreadyPlaySound = false
			end

			-- Battleground WinSounds
			if event == "CHAT_MSG_BG_SYSTEM_NEUTRAL" or event == "CHAT_MSG_BG_SYSTEM_ALLIANCE" or event == "CHAT_MSG_BG_SYSTEM_HORDE" or event == "CHAT_MSG_MONSTER_YELL" then
				local EventMessage = select(1, ...)
				if MyZone == "Zone_WarsongGulch" or MyZone == "Zone_EyeoftheStorm" or MyZone == "Zone_ArathiBasin" or MyZone == "Zone_AlteracValley" or MyZone == "Zone_IsleofConquest" or MyZone == "Zone_StrandoftheAncients" or MyZone == "Zone_TwinPeaks" or MyZone == "Zone_TheBattleforGilneas" or MyZone == "Zone_TempleofKotmogu" or MyZone == "Zone_SilvershardMines" or MyZone == "Zone_DeepwindGorge" then
					if (string.find(EventMessage, BG_ALLIANCE_WINS) and BgIsOver ~= true) or (string.find(EventMessage, BG_ALLIANCE_WINS_TWO) and BgIsOver ~= true) or (string.find(EventMessage, L["The Alliance is victorious"]) and BgIsOver ~= true) then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceWins.mp3")
						BgIsOver = true
						PVPSound:ClearPaybackQueue()
						PVPSound:ClearRetributionQueue()
					elseif (string.find(EventMessage, BG_HORDE_WINS) and BgIsOver ~= true) or (string.find(EventMessage, BG_HORDE_WINS_TWO) and BgIsOver ~= true) or (string.find(EventMessage, L["The Horde is victorious"]) and BgIsOver ~= true) then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeWins.mp3")
						BgIsOver = true
						PVPSound:ClearPaybackQueue()
						PVPSound:ClearRetributionQueue()
					end
				end
			end

			if event == "CHAT_MSG_BG_SYSTEM_NEUTRAL" then
				local EventMessage = select(1, ...)
				-- Tie Game
				if string.find(EventMessage, BG_TIE_GAME) and BgIsOver ~= true then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HumiliatingDefeat.mp3")
					BgIsOver = true
					PVPSound:ClearPaybackQueue()
					PVPSound:ClearRetributionQueue()
				 -- Warsong Gulch and Twin Peaks Vulnerable
				elseif MyZone == "Zone_WarsongGulch" or MyZone == "Zone_TwinPeaks" then
					if string.find(EventMessage, BG_ALLIANCE_FLAG_RETURNED) then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Flag_Returned.mp3")
					elseif string.find(EventMessage, BG_HORDE_FLAG_RETURNED) then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Flag_Returned.mp3")
					elseif string.find(EventMessage, BG_VULNERABLE) then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\Overtime.mp3")
					end
				 -- Strand of the Ancients Attack and Defend Sounds
				elseif MyZone == "Zone_StrandoftheAncients" then
					if string.find(EventMessage, BG_SOTA_ROUND_ONE) or string.find(EventMessage, BG_SOTA_ROUND_TWO) then
						for i = 7, 7, 1 do
							local textureIndex = select(3, GetMapLandmarkInfo(i))
							if textureIndex then
								if textureIndex == 46 then
									SotaAttacker = "Horde"
								else
									SotaAttacker = "Alliance"
								end
							end
						end
						if SotaAttacker == "Alliance" and MyFaction == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\AttackTheEnemyCore.mp3")
						elseif SotaAttacker == "Alliance" and MyFaction == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\DefendYourCore.mp3")
						elseif SotaAttacker == "Horde" and MyFaction == "Alliance" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\DefendYourCore.mp3")
						elseif SotaAttacker == "Horde" and MyFaction == "Horde" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\AttackTheEnemyCore.mp3")
						end
					elseif string.find(EventMessage, BG_SOTA_ROUND_TWO_TWO) then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\FinalRound.mp3")
						SotaRoundOver = false
					end
				end

			elseif event == "CHAT_MSG_BG_SYSTEM_ALLIANCE" or event == "CHAT_MSG_BG_SYSTEM_HORDE" then
				local EventMessage = select(1, ...)
				-- Warsong Gulch and Twin Peaks
				if MyZone == "Zone_WarsongGulch" or MyZone == "Zone_TwinPeaks" then
					-- Alliance
					if event == "CHAT_MSG_BG_SYSTEM_ALLIANCE" then
						-- Alliance Flag Coordinates
						local AllianceFlagPositionX
						local AllianceFlagPositionY
						if string.find(EventMessage, L["picked"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Flag_Taken.mp3")
						elseif string.find(EventMessage, BG_DROPPED) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Flag_Dropped.mp3")
							if (select(1, GetBattlefieldFlagPosition(1))) ~= nil then
								AllianceFlagPositionX = select(1, GetBattlefieldFlagPosition(1))
							end
							if (select(2, GetBattlefieldFlagPosition(1))) ~= nil then
								AllianceFlagPositionY = select(2, GetBattlefieldFlagPosition(1))
							end
						elseif string.find(EventMessage, BG_RETURNED) then
							-- Subzone
							local CurrentSubZoneText = GetSubZoneText()
							-- Horde Flag Taken
							local HordeFlagIsTaken
							if (select(2, GetWorldStateUIInfo(2))) ~= nil then
								HordeFlagIsTaken = select(2, GetWorldStateUIInfo(2))
							end
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Flag_Returned.mp3")
							if MyFaction == "Alliance" and HordeFlagIsTaken == 1 and (CurrentSubZoneText == L["Warsong Flag Room"] or CurrentSubZoneText == L["Dragonmaw Forge"]) then
								if MyZone == "Zone_WarsongGulch" then
									if AllianceFlagPositionX and AllianceFlagPositionX ~= 0 and AllianceFlagPositionX ~= "" then
										if AllianceFlagPositionY and AllianceFlagPositionY ~= nil and AllianceFlagPositionY ~= "" then
											if AllianceFlagPositionX >= 0.503 and AllianceFlagPositionX <= 0.545 then
												if AllianceFlagPositionY >= 0.884 and AllianceFlagPositionY <= 0.934 then
													PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\LastSecondSave.mp3")
												end
											end
										end
									end
								elseif MyZone == "Zone_TwinPeaks" then
									if AllianceFlagPositionX and AllianceFlagPositionX ~= 0 and AllianceFlagPositionX ~= "" then
										if AllianceFlagPositionY and AllianceFlagPositionY ~= nil and AllianceFlagPositionY ~= "" then
											if AllianceFlagPositionX >= 0.452 and AllianceFlagPositionX <= 0.509 then
												if AllianceFlagPositionY >= 0.795 and AllianceFlagPositionY <= 0.908 then
													PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\LastSecondSave.mp3")
												end
											end
										end
									end
								end
							end
						end
					 -- Horde
					elseif event == "CHAT_MSG_BG_SYSTEM_HORDE" then
						-- Horde Flag Coordinates
						local HordeFlagPositionX
						local HordeFlagPositionY
						if string.find(EventMessage, L["picked"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Flag_Taken.mp3")
						elseif string.find(EventMessage, BG_DROPPED) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Flag_Dropped.mp3")
							if (select(1, GetBattlefieldFlagPosition(2))) ~= nil then
								HordeFlagPositionX = select(1, GetBattlefieldFlagPosition(2))
							end
							if (select(2, GetBattlefieldFlagPosition(2))) ~= nil then
								HordeFlagPositionY = select(2, GetBattlefieldFlagPosition(2))
							end
						elseif string.find(EventMessage, BG_RETURNED) then
							-- Zone
							local CurrentSubZoneText = GetSubZoneText()
							-- Alliance Flag Taken
							local AllianceFlagIsTaken
							if (select(2, GetWorldStateUIInfo(3))) ~= nil then
								AllianceFlagIsTaken = select(2, GetWorldStateUIInfo(3))
							end
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Flag_Returned.mp3")
							if MyFaction == "Horde" and AllianceFlagIsTaken == 1 and (CurrentSubZoneText == L["Silverwing Hold"] or CurrentSubZoneText == L["Wildhammer Stronghold"]) then
								if MyZone == "Zone_WarsongGulch" then
									if HordeFlagPositionX and HordeFlagPositionX ~= 0 and HordeFlagPositionX ~= "" then
										if HordeFlagPositionY and HordeFlagPositionY ~= 0 and HordeFlagPositionY ~= "" then
											if HordeFlagPositionX >= 0.473 and HordeFlagPositionX <= 0.516 then
												if HordeFlagPositionY >= 0.111 and HordeFlagPositionY <= 0.176 then
													PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\LastSecondSave.mp3")
												end
											end
										end
									end
								elseif MyZone == "Zone_TwinPeaks" then
									if HordeFlagPositionX and HordeFlagPositionX ~= 0 and HordeFlagPositionX ~= "" then
										if HordeFlagPositionY and HordeFlagPositionY ~= 0 and HordeFlagPositionY ~= "" then
											if HordeFlagPositionX >= 0.563 and HordeFlagPositionX <= 0.640 then
												if HordeFlagPositionY >= 0.124 and HordeFlagPositionY <= 0.252 then
													PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\LastSecondSave.mp3")
												end
											end
										end
									end
								end
							end
						end
					end
				 -- Deepwind Gorge
				elseif MyZone == "Zone_DeepwindGorge" then
					-- Alliance
					if event == "CHAT_MSG_BG_SYSTEM_ALLIANCE" then
						-- Alliance Flag Coordinates
						local AllianceFlagPositionX
						local AllianceFlagPositionY
						-- Player Coordinates
						local PlayerPositionX
						local PlayerPositionY
						if string.find(EventMessage, L["taken the"]) or string.find(EventMessage, L["picked"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Flag_Taken.mp3")
						elseif string.find(EventMessage, L["dropped"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Flag_Dropped.mp3")
							if (select(1, GetBattlefieldFlagPosition(1))) ~= nil then
								AllianceFlagPositionX = select(1, GetBattlefieldFlagPosition(1))
							end
							if (select(2, GetBattlefieldFlagPosition(1))) ~= nil then
								AllianceFlagPositionY = select(2, GetBattlefieldFlagPosition(1))
							end
							SetMapToCurrentZone()
							PlayerPositionX, PlayerPositionY = GetPlayerMapPosition("player")
						elseif string.find(EventMessage, L["returned"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Flag_Returned.mp3")
							if MyFaction == "Alliance" then
								if AllianceFlagPositionX and AllianceFlagPositionX ~= 0 and AllianceFlagPositionX ~= "" then
									if AllianceFlagPositionY and AllianceFlagPositionY ~= nil and AllianceFlagPositionY ~= "" then
										if AllianceFlagPositionX >= 0.000 and AllianceFlagPositionX <= 0.277 then
											if AllianceFlagPositionY >= 0.272 and AllianceFlagPositionY <= 0.465 then
												if PlayerPositionX >= 0.000 and PlayerPositionX <= 0.277 then
													if PlayerPositionY >= 0.272 and PlayerPositionY <= 0.456 then
														PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\LastSecondSave.mp3")
													end
												end
											end
										end
									end
								end
							end
						elseif string.find(EventMessage, L["captured"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						--[[elseif string.find(EventMessage, L["The Alliance is near victory"]) then
							PlaySoundFile("Sound\\Spells\\PVPWarningAlliance.mp3", "Sound")]]
						end
					-- Horde
					elseif event == "CHAT_MSG_BG_SYSTEM_HORDE" then
						-- Horde Flag Coordinates
						local HordeFlagPositionX
						local HordeFlagPositionY
						-- Player Coordinates
						local PlayerPositionX
						local PlayerPositionY
						if string.find(EventMessage, L["taken the"]) or string.find(EventMessage, L["picked"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Flag_Taken.mp3")
						elseif string.find(EventMessage, L["dropped"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Flag_Dropped.mp3")
							if (select(1, GetBattlefieldFlagPosition(2))) ~= nil then
								HordeFlagPositionX = select(1, GetBattlefieldFlagPosition(2))
							end
							if (select(2, GetBattlefieldFlagPosition(2))) ~= nil then
								HordeFlagPositionY = select(2, GetBattlefieldFlagPosition(2))
							end
							SetMapToCurrentZone()
							PlayerPositionX, PlayerPositionY = GetPlayerMapPosition("player")
						elseif string.find(EventMessage, L["returned"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Flag_Returned.mp3")
							if MyFaction == "Horde" then
								if HordeFlagPositionX and HordeFlagPositionX ~= 0 and HordeFlagPositionX ~= "" then
									if HordeFlagPositionY and HordeFlagPositionY ~= nil and HordeFlagPositionY ~= "" then
										if HordeFlagPositionX >= 0.772 and HordeFlagPositionX <= 1.000 then
											if HordeFlagPositionY >= 0.523 and HordeFlagPositionY <= 0.712 then
												if PlayerPositionX >= 0.772 and PlayerPositionX <= 1.000 then
													if PlayerPositionY >= 0.523 and PlayerPositionY <= 0.712 then
														PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\LastSecondSave.mp3")
													end
												end
											end
										end
									end
								end
							end
						elseif string.find(EventMessage, L["captured"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						--[[elseif string.find(EventMessage, L["The Horde is near victory"]) then
							PlaySoundFile("Sound\\Spells\\PVPWarningHorde.mp3", "Sound")]]
						end
					end
				 -- Eye of the Storm Score Sounds
				elseif MyZone == "Zone_EyeoftheStorm" then
					if string.find(EventMessage, BG_CAPTURED) then
						if event == "CHAT_MSG_BG_SYSTEM_ALLIANCE" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						elseif event == "CHAT_MSG_BG_SYSTEM_HORDE" then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						end
					end
				 -- Temple of Kotmogu
				elseif MyZone == "Zone_TempleofKotmogu" then
					if event == "CHAT_MSG_BG_SYSTEM_ALLIANCE" then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Orb_PickedUp.mp3")
					elseif event == "CHAT_MSG_BG_SYSTEM_HORDE" then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Orb_PickedUp.mp3")
					end
				 -- Silvershard Mines
				elseif MyZone == "Zone_SilvershardMines" then
					if event == "CHAT_MSG_BG_SYSTEM_ALLIANCE" then
						if string.find(EventMessage, L["captured"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						end
					elseif event == "CHAT_MSG_BG_SYSTEM_HORDE" then
						if string.find(EventMessage, L["captured"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						end
					end
				end

			elseif event == "CHAT_MSG_MONSTER_YELL" then
				-- Alterac Valley
				if MyZone == "Zone_AlteracValley" then
					-- Bunkers
					-- Dun Baldar North Bunker
					for i = 1, GetNumMapLandmarks(), 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.45 and y == 0.14 then
								local faketextureIndex = textureIndex + 200
								local type = AVget_objective(faketextureIndex)
								if type then
									if AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 1 and AVobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 5 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Destroyed.mp3")
									end
									AVobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Dun Baldar South Bunker
					for i = 1, GetNumMapLandmarks(), 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if (x == 0.43 and y == 0.18) or (x == 0.44 and y == 0.18) then
								local faketextureIndex = textureIndex + 300
								local type = AVget_objective(faketextureIndex)
								if type then
									if AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 1 and AVobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 5 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Destroyed.mp3")
									end
									AVobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Icewing Bunker
					for i = 1, GetNumMapLandmarks(), 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.50 and y == 0.31 then
								local faketextureIndex = textureIndex + 900
								local type = AVget_objective(faketextureIndex)
								if type then
									if AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 1 and AVobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 5 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Destroyed.mp3")
									end
									AVobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Stonehearth Bunker
					for i = 1, GetNumMapLandmarks(), 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.52 and y == 0.44 then
								local faketextureIndex = textureIndex + 1200
								local type = AVget_objective(faketextureIndex)
								if type then
									if AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 1 and AVobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 5 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Destroyed.mp3")
									end
									AVobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Towers
					-- East Frostwolf Tower
					for i = 1, GetNumMapLandmarks(), 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.49 and y == 0.84 then
								local faketextureIndex = textureIndex + 400
								local type = AVget_objective(faketextureIndex)
								if type then
									if AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 2 and AVobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 5 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Destroyed.mp3")
									end
									AVobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Iceblood Tower
					for i = 1, GetNumMapLandmarks(), 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.48 and y == 0.58 then
								local faketextureIndex = textureIndex + 800
								local type = AVget_objective(faketextureIndex)
								if type then
									if AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 2 and AVobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 5 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Destroyed.mp3")
									end
									AVobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Tower Point
					for i = 1, GetNumMapLandmarks(), 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.50 and y == 0.65 then
								local faketextureIndex = textureIndex + 1600
								local type = AVget_objective(faketextureIndex)
								if type then
									if AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 2 and AVobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 5 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Destroyed.mp3")
									end
									AVobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- West Frostwolf Tower
					for i = 1, GetNumMapLandmarks(), 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.48 and y == 0.84 then
								local faketextureIndex = textureIndex + 1700
								local type = AVget_objective(faketextureIndex)
								if type then
									if AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 2 and AVobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 5 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Destroyed.mp3")
									end
									AVobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Graveyards
					-- Frostwolf Graveyard
					for i = 1, GetNumMapLandmarks(), 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.49 and y == 0.76 then
								local faketextureIndex = textureIndex + 500
								local type = AVget_objective(faketextureIndex)
								if type then
									if AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 1 and AVobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 2 and AVobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Offense.mp3")
									end
									AVobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Frostwolf Relief Hut
					--[[for i = 1, GetNumMapLandmarks(), 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.49 and y == 0.88 then
								local faketextureIndex = textureIndex + 600
								local type = AVget_objective(faketextureIndex)
								if type then
									if AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 1 and AVobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 2 and AVobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Offense.mp3")
									end
									AVobjectives[type] = faketextureIndex
								end
							end
						end
					end]]--
					-- Iceblood Graveyard
					for i = 1, GetNumMapLandmarks(), 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.51 and y == 0.57 then
								local faketextureIndex = textureIndex + 700
								local type = AVget_objective(faketextureIndex)
								if type then
									if AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 1 and AVobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 2 and AVobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Offense.mp3")
									end
									AVobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Snowfall Graveyard
					for i = 1, GetNumMapLandmarks(), 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.44 and y == 0.45 then
								local faketextureIndex = textureIndex + 1100
								local type = AVget_objective(faketextureIndex)
								if type then
									if AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 1 and AVobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 2 and AVobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Offense.mp3")
									end
									AVobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Stonehearth Graveyard
					for i = 1, GetNumMapLandmarks(), 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.51 and y == 0.36 then
								local faketextureIndex = textureIndex + 1300
								local type = AVget_objective(faketextureIndex)
								if type then
									if AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 1 and AVobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 2 and AVobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Offense.mp3")
									end
									AVobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Stormpike Aid Station
					--[[for i = 1, GetNumMapLandmarks(), 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.42 and y == 0.15 then
								local faketextureIndex = textureIndex + 1400
								local type = AVget_objective(faketextureIndex)
								if type then
									if AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 1 and AVobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 2 and AVobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Offense.mp3")
									end
									AVobjectives[type] = faketextureIndex
								end
							end
						end
					end]]--
					-- Stormpike Graveyard
					for i = 1, GetNumMapLandmarks(), 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.49 and y == 0.14 then
								local faketextureIndex = textureIndex + 1500
								local type = AVget_objective(faketextureIndex)
								if type then
									if AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 1 and AVobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 2 and AVobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 3 and AVobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Offense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Offense.mp3")
									end
									AVobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Mines
					-- Coldtooth Mine
					--[[for i = 1, GetNumMapLandmarks(), 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.46 and y == 0.71 then
								local faketextureIndex = textureIndex + 100
								local type = AVget_objective(faketextureIndex)
								if type then
									if AVobj_state(AVobjectives[type]) == 6 and AVobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 6 and AVobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 2 and AVobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 1 and AVobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
									end
									AVobjectives[type] = faketextureIndex
								end
							end
						end
					end]]--
					-- Irondeep Mine
					--[[for i = 1, GetNumMapLandmarks(), 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.49 and y == 0.10 then
								local faketextureIndex = textureIndex + 1000
								local type = AVget_objective(faketextureIndex)
								if type then
									if AVobj_state(AVobjectives[type]) == 6 and AVobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 6 and AVobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 2 and AVobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
									elseif AVobj_state(AVobjectives[type]) == 1 and AVobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
									end
									AVobjectives[type] = faketextureIndex
								end
							end
						end
					end]]--
				end

			elseif event == "CHAT_MSG_RAID_BOSS_EMOTE" then
				local EventMessage = select(1, ...)
				-- Wintergrasp
				if MyZone == "Zone_Wintergrasp" then
					-- WinSounds
					if string.find(EventMessage, BF_WG_ALLIANCE_WIN_DEFENDED) and BgIsOver ~= true then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceWins.mp3")
						BgIsOver = true
					elseif string.find(EventMessage, BF_WG_HORDE_WIN_DEFENDED) and BgIsOver ~= true then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeWins.mp3")
						BgIsOver = true
					end
					local isActive = select(3, GetWorldPVPAreaInfo(1))
					if isActive == true then
						BgIsOver = false
						-- Workshops
						if string.find(EventMessage, BF_WG_ALLIANCE_ATTACKED) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
						elseif string.find(EventMessage, BF_WG_ALLIANCE_CAPTURED) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
						elseif string.find(EventMessage, BF_WG_HORDE_ATTACKED) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
						elseif string.find(EventMessage, BF_WG_HORDE_CAPTURED) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
						end
					end
				 -- Tol Barad
				elseif MyZone == "Zone_TolBarad" then
					local isActive = select(3, GetWorldPVPAreaInfo(2))
					if isActive == false then
						-- WinSounds
						for i = 1, 1, 1 do
							local textureIndex = select(3, GetMapLandmarkInfo(i))
							local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
							local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
							local nextBattle = tostring(string.match(select(4, GetWorldStateUIInfo(9)), ": (.+)"))
							nextBattle = string.sub(nextBattle, 1, string.len(nextBattle) - 1)
							if textureIndex and x and y and nextBattle then
								if x == 0.51 and y == 0.54 then
									if BgIsOver ~= true then
										if nextBattle == "1:59:5" or nextBattle == "2:04:5" or nextBattle == "2:09:5" or nextBattle == "2:14:5" then
											if textureIndex == 48 then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeWins.mp3")
												BgIsOver = true
											elseif textureIndex == 46 then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceWins.mp3")
												BgIsOver = true
											end
										end
									end
								end
							end
						end
					end
				 -- Strand of the Ancients Round One Finished
				elseif MyZone == "Zone_StrandoftheAncients" then
					if string.find(EventMessage, BG_SOTA_ROUND_ONE_FINISHED) then
						SOTAobjectives.ChamberofAncientRelics = nil
						SOTAobjectives.EastGraveyard = nil
						SOTAobjectives.GateoftheBlueSapphire = nil
						SOTAobjectives.GateoftheGreenEmerald = nil
						SOTAobjectives.GateofthePurpleAmethyst = nil
						SOTAobjectives.GateoftheRedSun = nil
						SOTAobjectives.GateoftheYellowMoon = nil
						SOTAobjectives.SouthGraveyard = nil
						SOTAobjectives.WestGraveyard = nil
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\EndOfRound.mp3")
						SotaRoundOver = true
					elseif string.find(EventMessage, BG_SOTA_LET_THE_BATTLE) then
						SotaRoundOver = false
					end
				 -- Eye of the Storm RBG Score Sounds
				elseif MyZone == "Zone_EyeoftheStorm" then
					if string.find(EventMessage, BG_EOTSRBG_ALLIANCE_CAPTURED) then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
					elseif string.find(EventMessage, BG_EOTSRBG_HORDE_CAPTURED) then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
					end
				 -- Temple of Kotmogu Orb Reset
				elseif MyZone == "Zone_TempleofKotmogu" then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\OrbReturned.mp3")
				 -- Silvershard Mines Cart Arrived
				elseif MyZone == "Zone_SilvershardMines" then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\MineShaftOpening.mp3")
				end

			elseif event == "WORLD_MAP_UPDATE" then
				-- Strand of the Ancients
				if MyZone == "Zone_StrandoftheAncients" then
					--[[local j, k, l, m, n, o, p
					if (select(4, GetMapLandmarkInfo(2))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(2)))), 1, 4)) == 0.54 and (select(5, GetMapLandmarkInfo(2))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(2)))), 1, 4)) == 0.46 then
						j = 1
						k = 2
						l = 3
						m = 4
						n = 5
						o = 6
						p = 7
					elseif (select(4, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(3)))), 1, 4)) == 0.54 and (select(5, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(3)))), 1, 4)) == 0.46 then
						j = 2
						k = 3
						l = 4
						m = 5
						n = 6
						o = 7
						p = 8
					else
						j = 1
						k = nil
						l = 2
						m = 3
						n = 4
						o = 5
						p = 6
					end]]
					if SotaRoundOver ~= true then
						--if k ~= nil then
							-- Graveyards
							-- East Graveyard
							for i = 8, 8, 1 do
								local textureIndex = select(3, GetMapLandmarkInfo(i))
								local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
								local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
								if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
									if x == 0.54 and y == 0.46 then
										local faketextureIndex = textureIndex + 200
										local type = SOTAget_objective(faketextureIndex)
										if type then
											if SOTAobj_state(SOTAobjectives[type]) == 2 and SOTAobj_state(faketextureIndex) == 1 then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
											elseif SOTAobj_state(SOTAobjectives[type]) == 1 and SOTAobj_state(faketextureIndex) == 2 then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
											end
											SOTAobjectives[type] = faketextureIndex
										end
									end
								end
							end
							-- South Graveyard
							for i = 9, 10, 1 do
								local textureIndex = select(3, GetMapLandmarkInfo(i))
								local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
								local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
								if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
									if (x == 0.49 and y == 0.56) or (x == 0.49 and y == 0.57) then
										local faketextureIndex = textureIndex + 800
										local type = SOTAget_objective(faketextureIndex)
										if type then
											if SOTAobj_state(SOTAobjectives[type]) == 2 and SOTAobj_state(faketextureIndex) == 1 then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
											elseif SOTAobj_state(SOTAobjectives[type]) == 1 and SOTAobj_state(faketextureIndex) == 2 then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
											end
											SOTAobjectives[type] = faketextureIndex
										end
									end
								end
							end
							-- West Graveyard
							for i = 9, 12, 3 do
								local textureIndex = select(3, GetMapLandmarkInfo(i))
								local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
								local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
								if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
									if x == 0.44 and y == 0.49 then
										local faketextureIndex = textureIndex + 900
										local type = SOTAget_objective(faketextureIndex)
										if type then
											if SOTAobj_state(SOTAobjectives[type]) == 2 and SOTAobj_state(faketextureIndex) == 1 then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
											elseif SOTAobj_state(SOTAobjectives[type]) == 1 and SOTAobj_state(faketextureIndex) == 2 then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
											end
											SOTAobjectives[type] = faketextureIndex
										end
									end
								end
							end
						--end
					end
					-- Gates
					-- Chamber of Ancient Relics
					for i = 11, 12, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.51 and y == 0.86 then
								local faketextureIndex = textureIndex + 100
								local type = SOTAget_objective(faketextureIndex)
								if type then
									if SOTAobj_state(SOTAobjectives[type]) == 4 and SOTAobj_state(faketextureIndex) == 5 then
										local textureIndex = select(3, GetMapLandmarkInfo(7))
										if textureIndex == 46 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\BarricadeDestroyedBlueCoreIsVulnerable.mp3")
										else
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\BarricadeDestroyedRedCoreIsVulnerable.mp3")
										end
									end
									SOTAobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Gate of the Blue Sapphire
					for i = 3, 3, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.57 and y == 0.38 then
								local faketextureIndex = textureIndex
								local type = SOTAget_objective(faketextureIndex)
								if type then
									if SOTAobj_state(SOTAobjectives[type]) == 7 and SOTAobj_state(faketextureIndex) == 8 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\BarricadeDestroyed.mp3")
									end
									SOTAobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Gate of the Green Emerald
					for i = 4, 4, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.39 and y == 0.40 then
								-- Intended
								local faketextureIndex = textureIndex
								local type = SOTAget_objective(faketextureIndex)
								if type then
									if SOTAobj_state(SOTAobjectives[type]) == 7 and SOTAobj_state(faketextureIndex) == 8 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\BarricadeDestroyed.mp3")
									end
									SOTAobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Gate of the Purple Amethyst
					for i = 1, 1, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.40 and y == 0.57 then
								local faketextureIndex = textureIndex
								local type = SOTAget_objective(faketextureIndex)
								if type then
									if SOTAobj_state(SOTAobjectives[type]) == 7 and SOTAobj_state(faketextureIndex) == 8 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\BarricadeDestroyed.mp3")
									end
									SOTAobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Gate of the Red Sun
					for i = 2, 2, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.57 and y == 0.55 then
								local faketextureIndex = textureIndex
								local type = SOTAget_objective(faketextureIndex)
								if type then
									if SOTAobj_state(SOTAobjectives[type]) == 7 and SOTAobj_state(faketextureIndex) == 8 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\BarricadeDestroyed.mp3")
									end
									SOTAobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Gate of the Yellow Moon
					for i = 10, 11, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.51 and y == 0.70 then
								local faketextureIndex = textureIndex + 600
								local type = SOTAget_objective(faketextureIndex)
								if type then
									if SOTAobj_state(SOTAobjectives[type]) == 7 and SOTAobj_state(faketextureIndex) == 8 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\BarricadeDestroyed.mp3")
									end
									SOTAobjectives[type] = faketextureIndex
								end
							end
						end
					end
				 -- Isle of Conquest
				elseif MyZone == "Zone_IsleofConquest" then
					--[[local j, k, l, m, n, o, p, q, r, s, t
					if (select(4, GetMapLandmarkInfo(5))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(5)))), 1, 4)) == 0.51 and (select(5, GetMapLandmarkInfo(5))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(5)))), 1, 4)) == 0.77 and (select(4, GetMapLandmarkInfo(11))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(11)))), 1, 4)) == 0.48 and (select(5, GetMapLandmarkInfo(11))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(11)))), 1, 4)) == 0.28 then
						j = 1
						k = 2
						l = 3
						m = 6
						n = 7
						o = 8
						p = 9
						q = 10
						r = 13
						s = 14
						t = 15
					elseif (select(4, GetMapLandmarkInfo(5))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(5)))), 1, 4)) == 0.51 and (select(5, GetMapLandmarkInfo(5))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(5)))), 1, 4)) == 0.77 then
						j = 1
						k = 2
						l = 3
						m = 6
						n = 7
						o = 8
						p = 9
						q = 10
						r = 12
						s = 13
						t = 14
					elseif (select(4, GetMapLandmarkInfo(11))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(11)))), 1, 4)) == 0.48 and (select(5, GetMapLandmarkInfo(11))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(11)))), 1, 4)) == 0.28 then
						j = 1
						k = 2
						l = 3
						m = 5
						n = 6
						o = 7
						p = 8
						q = 9
						r = 12
						s = 13
						t = 14
					else
						j = 1
						k = 2
						l = 3
						m = 5
						n = 6
						o = 7
						p = 8
						q = 9
						r = 11
						s = 12
						t = 13
					end]]
					-- Gates
					-- Alliance Gate (East)
					for i = 9, 9, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.53 and y == 0.76 then
								local faketextureIndex = textureIndex + 100
								local type = IOCget_objective(faketextureIndex)
								if type then
									if IOCobj_state(IOCobjectives[type]) == 5 and IOCobj_state(faketextureIndex) == 7 then
										if IocAllianceGateDown ~= true then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\BarricadeDestroyedBlueCoreIsVulnerable.mp3")
											IocAllianceGateDown = true
										end
									end
									IOCobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Alliance Gate (West)
					for i = 10, 10, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.48 and y == 0.76 then
								local faketextureIndex = textureIndex + 200
								local type = IOCget_objective(faketextureIndex)
								if type then
									if IOCobj_state(IOCobjectives[type]) == 5 and IOCobj_state(faketextureIndex) == 7 then
										if IocAllianceGateDown ~= true then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\BarricadeDestroyedBlueCoreIsVulnerable.mp3")
											IocAllianceGateDown = true
										end
									end
									IOCobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Alliance Gate (Front)
					for i = 11, 11, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.51 and y == 0.73 then
								local faketextureIndex = textureIndex + 300
								local type = IOCget_objective(faketextureIndex)
								if type then
									if IOCobj_state(IOCobjectives[type]) == 5 and IOCobj_state(faketextureIndex) == 7 then
										if IocAllianceGateDown ~= true then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\BarricadeDestroyedBlueCoreIsVulnerable.mp3")
											IocAllianceGateDown = true
										end
									end
									IOCobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Horde Gate (East)
					for i = 7, 7, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.51 and y == 0.27 then
								local faketextureIndex = textureIndex + 400
								local type = IOCget_objective(faketextureIndex)
								if type then
									if IOCobj_state(IOCobjectives[type]) == 6 and IOCobj_state(faketextureIndex) == 8 then
										if IocHordeGateDown ~= true then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\BarricadeDestroyedRedCoreIsVulnerable.mp3")
											IocHordeGateDown = true
										end
									end
									IOCobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Horde Gate (West)
					for i = 8, 8, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.45 and y == 0.27 then
								local faketextureIndex = textureIndex + 500
								local type = IOCget_objective(faketextureIndex)
								if type then
									if IOCobj_state(IOCobjectives[type]) == 6 and IOCobj_state(faketextureIndex) == 8 then
										if IocHordeGateDown ~= true then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\BarricadeDestroyedRedCoreIsVulnerable.mp3")
											IocHordeGateDown = true
										end
									end
									IOCobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Horde Gate (Front)
					for i = 6, 6, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.48 and y == 0.31 then
								local faketextureIndex = textureIndex + 600
								local type = IOCget_objective(faketextureIndex)
								if type then
									if IOCobj_state(IOCobjectives[type]) == 6 and IOCobj_state(faketextureIndex) == 8 then
										if IocHordeGateDown ~= true then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\BarricadeDestroyedRedCoreIsVulnerable.mp3")
											IocHordeGateDown = true
										end
									end
									IOCobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Bases
					-- Docks
					for i = 3, 3, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.34 and y == 0.51 then
								local type = IOCget_objective(textureIndex)
								if type then
									if IOCobj_state(IOCobjectives[type]) == 3 and IOCobj_state(textureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
									elseif IOCobj_state(IOCobjectives[type]) == 4 and IOCobj_state(textureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
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
					-- Hangar
					for i = 2, 2, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.62 and y == 0.57 then
								local type = IOCget_objective(textureIndex)
								if type then
									if IOCobj_state(IOCobjectives[type]) == 3 and IOCobj_state(textureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
									elseif IOCobj_state(IOCobjectives[type]) == 4 and IOCobj_state(textureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
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
					-- Quarry
					for i = 4, 4, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.64 and y == 0.83 then
								local type = IOCget_objective(textureIndex)
								if type then
									if IOCobj_state(IOCobjectives[type]) == 3 and IOCobj_state(textureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
									elseif IOCobj_state(IOCobjectives[type]) == 4 and IOCobj_state(textureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
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
					-- Refinery
					for i = 5, 5, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.34 and y == 0.24 then
								local type = IOCget_objective(textureIndex)
								if type then
									if IOCobj_state(IOCobjectives[type]) == 3 and IOCobj_state(textureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
									elseif IOCobj_state(IOCobjectives[type]) == 4 and IOCobj_state(textureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
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
					-- Workshop
					for i = 1, 1, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.50 and y == 0.52 then
								local type = IOCget_objective(textureIndex)
								if type then
									if IOCobj_state(IOCobjectives[type]) == 3 and IOCobj_state(textureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
									elseif IOCobj_state(IOCobjectives[type]) == 4 and IOCobj_state(textureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
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
				 -- Eye of the Storm
				elseif MyZone == "Zone_EyeoftheStorm" then
					-- Blood Elf Tower
					for i = 1, 1, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 3))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 3))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.5 and y == 0.5 then
								local faketextureIndex = textureIndex + 100
								local type = EOTSget_objective(faketextureIndex)
								if type then
									if EOTSobj_state(EOTSobjectives[type]) == 1 and EOTSobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if EOTSobjectives.DraeneiRuins == 211 and EOTSobjectives.FelReaverRuins == 311 and EOTSobjectives.MageTower == 411 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif EOTSobj_state(EOTSobjectives[type]) == 1 and EOTSobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if EOTSobjectives.DraeneiRuins == 210 and EOTSobjectives.FelReaverRuins == 310 and EOTSobjectives.MageTower == 410 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif EOTSobj_state(EOTSobjectives[type]) == 4 and EOTSobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if EOTSobjectives.DraeneiRuins == 211 and EOTSobjectives.FelReaverRuins == 311 and EOTSobjectives.MageTower == 411 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif EOTSobj_state(EOTSobjectives[type]) == 5 and EOTSobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if EOTSobjectives.DraeneiRuins == 210 and EOTSobjectives.FelReaverRuins == 310 and EOTSobjectives.MageTower == 410 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif EOTSobj_state(EOTSobjectives[type]) == 2 and EOTSobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 3 and EOTSobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 3 and EOTSobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 2 and EOTSobj_state(faketextureIndex) == 5 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 4 and EOTSobj_state(faketextureIndex) == 5 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 5 and EOTSobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									end
									EOTSobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Draenei Ruins
					for i = 4, 4, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 3))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 3))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.5 and y == 0.4 then
								local faketextureIndex = textureIndex + 200
								local type = EOTSget_objective(faketextureIndex)
								if type then
									if EOTSobj_state(EOTSobjectives[type]) == 1 and EOTSobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if EOTSobjectives.BloodElfTower == 111 and EOTSobjectives.FelReaverRuins == 311 and EOTSobjectives.MageTower == 411 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif EOTSobj_state(EOTSobjectives[type]) == 1 and EOTSobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if EOTSobjectives.BloodElfTower == 110 and EOTSobjectives.FelReaverRuins == 310 and EOTSobjectives.MageTower == 410 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif EOTSobj_state(EOTSobjectives[type]) == 4 and EOTSobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if EOTSobjectives.BloodElfTower == 111 and EOTSobjectives.FelReaverRuins == 311 and EOTSobjectives.MageTower == 411 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif EOTSobj_state(EOTSobjectives[type]) == 5 and EOTSobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if EOTSobjectives.BloodElfTower == 110 and EOTSobjectives.FelReaverRuins == 310 and EOTSobjectives.MageTower == 410 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif EOTSobj_state(EOTSobjectives[type]) == 2 and EOTSobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 3 and EOTSobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 3 and EOTSobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 2 and EOTSobj_state(faketextureIndex) == 5 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 4 and EOTSobj_state(faketextureIndex) == 5 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 5 and EOTSobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									end
									EOTSobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Fel Reaver Ruins
					for i = 2, 2, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 3))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 3))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.4 and y == 0.5 then
								local faketextureIndex = textureIndex + 300
								local type = EOTSget_objective(faketextureIndex)
								if type then
									if EOTSobj_state(EOTSobjectives[type]) == 1 and EOTSobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if EOTSobjectives.BloodElfTower == 111 and EOTSobjectives.DraeneiRuins == 211 and EOTSobjectives.MageTower == 411 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif EOTSobj_state(EOTSobjectives[type]) == 1 and EOTSobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if EOTSobjectives.BloodElfTower == 110 and EOTSobjectives.DraeneiRuins == 210 and EOTSobjectives.MageTower == 410 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif EOTSobj_state(EOTSobjectives[type]) == 4 and EOTSobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if EOTSobjectives.BloodElfTower == 111 and EOTSobjectives.DraeneiRuins == 211 and EOTSobjectives.MageTower == 411 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif EOTSobj_state(EOTSobjectives[type]) == 5 and EOTSobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if EOTSobjectives.BloodElfTower == 110 and EOTSobjectives.DraeneiRuins == 210 and EOTSobjectives.MageTower == 410 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif EOTSobj_state(EOTSobjectives[type]) == 2 and EOTSobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 3 and EOTSobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 3 and EOTSobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 2 and EOTSobj_state(faketextureIndex) == 5 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 4 and EOTSobj_state(faketextureIndex) == 5 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 5 and EOTSobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									end
									EOTSobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Mage Tower
					for i = 3, 3, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 3))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 3))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.4 and y == 0.4 then
								local faketextureIndex = textureIndex + 400
								local type = EOTSget_objective(faketextureIndex)
								if type then
									if EOTSobj_state(EOTSobjectives[type]) == 1 and EOTSobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if EOTSobjectives.BloodElfTower == 111 and EOTSobjectives.DraeneiRuins == 211 and EOTSobjectives.FelReaverRuins == 311 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif EOTSobj_state(EOTSobjectives[type]) == 1 and EOTSobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if EOTSobjectives.BloodElfTower == 110 and EOTSobjectives.DraeneiRuins == 210 and EOTSobjectives.FelReaverRuins == 310 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif EOTSobj_state(EOTSobjectives[type]) == 4 and EOTSobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if EOTSobjectives.BloodElfTower == 111 and EOTSobjectives.DraeneiRuins == 211 and EOTSobjectives.FelReaverRuins == 311 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif EOTSobj_state(EOTSobjectives[type]) == 5 and EOTSobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if EOTSobjectives.BloodElfTower == 110 and EOTSobjectives.DraeneiRuins == 210 and EOTSobjectives.FelReaverRuins == 310 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif EOTSobj_state(EOTSobjectives[type]) == 2 and EOTSobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 3 and EOTSobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 3 and EOTSobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 2 and EOTSobj_state(faketextureIndex) == 5 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 4 and EOTSobj_state(faketextureIndex) == 5 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 5 and EOTSobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									end
									EOTSobjectives[type] = faketextureIndex
								end
							end
						end
					end
				 -- Wintergrasp
				elseif MyZone == "Zone_Wintergrasp" then
					-- Fortress Graveyard
					for i = 35, 35, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							local faketextureIndex = textureIndex
							local type = WGget_objective(faketextureIndex)
							if x == 0.48 and y == 0.08 then
								if BgIsOver ~= true then
									if type then
										if WGobj_state(WGobjectives[type]) == 7 and WGobj_state(faketextureIndex) == 8 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceWins.mp3")
											BgIsOver = true
										elseif WGobj_state(WGobjectives[type]) == 8 and WGobj_state(faketextureIndex) == 7 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeWins.mp3")
											BgIsOver = true
										end
										WGobjectives[type] = faketextureIndex
									end
								end
							end
						end
					end
					local isActive = select(3, GetWorldPVPAreaInfo(1))
					if isActive == true then
						-- Towers
						-- Flamewatch Tower
						for i = 3, 3, 1 do
							local textureIndex = select(3, GetMapLandmarkInfo(i))
							local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
							local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
							if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
								if x == 0.80 and y == 0.63 then
									local faketextureIndex = textureIndex + 100
									local type = WGget_objective(faketextureIndex)
									if type then
										if WGobj_state(WGobjectives[type]) == 1 and WGobj_state(faketextureIndex) == 3 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_HeavilyDamaged.mp3")
										elseif WGobj_state(WGobjectives[type]) == 3 and WGobj_state(faketextureIndex) == 4 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Destroyed.mp3")
										elseif WGobj_state(WGobjectives[type]) == 2 and WGobj_state(faketextureIndex) == 5 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_HeavilyDamaged.mp3")
										elseif WGobj_state(WGobjectives[type]) == 5 and WGobj_state(faketextureIndex) == 6 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Destroyed.mp3")
										end
										WGobjectives[type] = faketextureIndex
									end
								end
							end
						end
						-- Shadowsight Tower
						for i = 1, 1, 1 do
							local textureIndex = select(3, GetMapLandmarkInfo(i))
							local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
							local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
							if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
								if x == 0.23 and y == 0.58 then
									local faketextureIndex = textureIndex + 200
									local type = WGget_objective(faketextureIndex)
									if type then
										if WGobj_state(WGobjectives[type]) == 1 and WGobj_state(faketextureIndex) == 3 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_HeavilyDamaged.mp3")
										elseif WGobj_state(WGobjectives[type]) == 3 and WGobj_state(faketextureIndex) == 4 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Destroyed.mp3")
										elseif WGobj_state(WGobjectives[type]) == 2 and WGobj_state(faketextureIndex) == 5 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_HeavilyDamaged.mp3")
										elseif WGobj_state(WGobjectives[type]) == 5 and WGobj_state(faketextureIndex) == 6 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Destroyed.mp3")
										end
										WGobjectives[type] = faketextureIndex
									end
								end
							end
						end
						-- Winter's Edge Tower
						for i = 2, 2, 1 do
							local textureIndex = select(3, GetMapLandmarkInfo(i))
							local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
							local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
							if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
								if x == 0.50 and y == 0.66 then
									local faketextureIndex = textureIndex + 300
									local type = WGget_objective(faketextureIndex)
									if type then
										if WGobj_state(WGobjectives[type]) == 1 and WGobj_state(faketextureIndex) == 3 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_HeavilyDamaged.mp3")
										elseif WGobj_state(WGobjectives[type]) == 3 and WGobj_state(faketextureIndex) == 4 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Destroyed.mp3")
										elseif WGobj_state(WGobjectives[type]) == 2 and WGobj_state(faketextureIndex) == 5 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_HeavilyDamaged.mp3")
										elseif WGobj_state(WGobjectives[type]) == 5 and WGobj_state(faketextureIndex) == 6 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Destroyed.mp3")
										end
										WGobjectives[type] = faketextureIndex
									end
								end
							end
						end
						-- Wintergrasp Fortress Tower (NE)
						for i = 6, 6, 1 do
							local textureIndex = select(3, GetMapLandmarkInfo(i))
							local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
							local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
							if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
								if x == 0.57 and y == 0.22 then
									local faketextureIndex = textureIndex + 400
									local type = WGget_objective(faketextureIndex)
									if type then
										if WGobj_state(WGobjectives[type]) == 1 and WGobj_state(faketextureIndex) == 3 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_HeavilyDamaged.mp3")
										elseif WGobj_state(WGobjectives[type]) == 3 and WGobj_state(faketextureIndex) == 4 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Destroyed.mp3")
										elseif WGobj_state(WGobjectives[type]) == 2 and WGobj_state(faketextureIndex) == 5 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_HeavilyDamaged.mp3")
										elseif WGobj_state(WGobjectives[type]) == 5 and WGobj_state(faketextureIndex) == 6 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Destroyed.mp3")
										end
										WGobjectives[type] = faketextureIndex
									end
								end
							end
						end
						-- Wintergrasp Fortress Tower (NW)
						for i = 7, 7, 1 do
							local textureIndex = select(3, GetMapLandmarkInfo(i))
							local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
							local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
							if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
								if x == 0.43 and y == 0.22 then
									local faketextureIndex = textureIndex + 500
									local type = WGget_objective(faketextureIndex)
									if type then
										if WGobj_state(WGobjectives[type]) == 1 and WGobj_state(faketextureIndex) == 3 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_HeavilyDamaged.mp3")
										elseif WGobj_state(WGobjectives[type]) == 3 and WGobj_state(faketextureIndex) == 4 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Destroyed.mp3")
										elseif WGobj_state(WGobjectives[type]) == 2 and WGobj_state(faketextureIndex) == 5 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_HeavilyDamaged.mp3")
										elseif WGobj_state(WGobjectives[type]) == 5 and WGobj_state(faketextureIndex) == 6 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Destroyed.mp3")
										end
										WGobjectives[type] = faketextureIndex
									end
								end
							end
						end
						-- Wintergrasp Fortress Tower (SE)
						for i = 5, 5, 1 do
							local textureIndex = select(3, GetMapLandmarkInfo(i))
							local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
							local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
							if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
								if x == 0.53 and y == 0.27 then
									local faketextureIndex = textureIndex + 600
									local type = WGget_objective(faketextureIndex)
									if type then
										if WGobj_state(WGobjectives[type]) == 1 and WGobj_state(faketextureIndex) == 3 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_HeavilyDamaged.mp3")
										elseif WGobj_state(WGobjectives[type]) == 3 and WGobj_state(faketextureIndex) == 4 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Destroyed.mp3")
										elseif WGobj_state(WGobjectives[type]) == 2 and WGobj_state(faketextureIndex) == 5 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_HeavilyDamaged.mp3")
										elseif WGobj_state(WGobjectives[type]) == 5 and WGobj_state(faketextureIndex) == 6 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Destroyed.mp3")
										end
										WGobjectives[type] = faketextureIndex
									end
								end
							end
						end
						-- Wintergrasp Fortress Tower (SW)
						for i = 4, 4, 1 do
							local textureIndex = select(3, GetMapLandmarkInfo(i))
							local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
							local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
							if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
								if x == 0.46 and y == 0.28 then
									local faketextureIndex = textureIndex + 700
									local type = WGget_objective(faketextureIndex)
									if type then
										if WGobj_state(WGobjectives[type]) == 1 and WGobj_state(faketextureIndex) == 3 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_HeavilyDamaged.mp3")
										elseif WGobj_state(WGobjectives[type]) == 3 and WGobj_state(faketextureIndex) == 4 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Destroyed.mp3")
										elseif WGobj_state(WGobjectives[type]) == 2 and WGobj_state(faketextureIndex) == 5 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_HeavilyDamaged.mp3")
										elseif WGobj_state(WGobjectives[type]) == 5 and WGobj_state(faketextureIndex) == 6 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Destroyed.mp3")
										end
										WGobjectives[type] = faketextureIndex
									end
								end
							end
						end
					end
				 -- Tol Barad
				elseif MyZone == "Zone_TolBarad" then
					-- Baradin Hold
					for i = 1, GetNumMapLandmarks(), 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.51 and y == 0.54 then
								local faketextureIndex = textureIndex
								local type = TBget_objective(faketextureIndex)
								if BgIsOver ~= true then
									if type then
										if TBobj_state(TBobjectives[type]) == 2 and TBobj_state(faketextureIndex) == 1 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceWins.mp3")
											BgIsOver = true
										elseif TBobj_state(TBobjectives[type]) == 1 and TBobj_state(faketextureIndex) == 2 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeWins.mp3")
											BgIsOver = true
										end
										TBobjectives[type] = faketextureIndex
									end
								end
							end
						end
					end
					local isActive = select(3, GetWorldPVPAreaInfo(2))
					if isActive == true then
						BgIsOver = false
						local j, k, l, m, n, o
						if (select(4, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(3)))), 1, 4)) == 0.73 and (select(5, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(3)))), 1, 4)) == 0.33 and (select(4, GetMapLandmarkInfo(7))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(7)))), 1, 4)) == 0.52 and (select(5, GetMapLandmarkInfo(7))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(7)))), 1, 4)) == 0.78 then
							j = 4
							k = 5
							l = 8
							m = 2
							n = 6
							o = 9
						elseif (select(4, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(3)))), 1, 4)) == 0.73 and (select(5, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(3)))), 1, 4)) == 0.33 then
							j = 4
							k = 5
							l = 7
							m = 2
							n = 6
							o = 8
						elseif (select(4, GetMapLandmarkInfo(6))) ~= nil and tonumber(string.sub(tostring((select(4, GetMapLandmarkInfo(6)))), 1, 4)) == 0.52 and (select(5, GetMapLandmarkInfo(6))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(6)))), 1, 4)) == 0.78 then
							j = 3
							k = 4
							l = 7
							m = 2
							n = 5
							o = 8
						else
							j = 3
							k = 4
							l = 6
							m = 2
							n = 5
							o = 7
						end
						-- Bases
						-- Ironclad Garrison
						for i = j, j, 1 do
							local textureIndex = select(3, GetMapLandmarkInfo(i))
							local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
							local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
							if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
								if x == 0.51 and y == 0.26 then
									local faketextureIndex = textureIndex + 100
									local type = TBget_objective(faketextureIndex)
									if type then
										if TBobj_state(TBobjectives[type]) == 3 and TBobj_state(faketextureIndex) == 1 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										elseif TBobj_state(TBobjectives[type]) == 4 and TBobj_state(faketextureIndex) == 2 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										elseif TBobj_state(TBobjectives[type]) == 4 and TBobj_state(faketextureIndex) == 1 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										elseif TBobj_state(TBobjectives[type]) == 3 and TBobj_state(faketextureIndex) == 2 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										elseif TBobj_state(TBobjectives[type]) == 1 and TBobj_state(faketextureIndex) == 4 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
										elseif TBobj_state(TBobjectives[type]) == 2 and TBobj_state(faketextureIndex) == 3 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
										elseif TBobj_state(TBobjectives[type]) == 3 and TBobj_state(faketextureIndex) == 4 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
										elseif TBobj_state(TBobjectives[type]) == 4 and TBobj_state(faketextureIndex) == 3 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
										end
										TBobjectives[type] = faketextureIndex
									end
								end
							end
						end
						-- Slagworks
						for i = k, k, 1 do
							local textureIndex = select(3, GetMapLandmarkInfo(i))
							local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
							local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
							if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
								if x == 0.65 and y == 0.65 then
									local faketextureIndex = textureIndex + 200
									local type = TBget_objective(faketextureIndex)
									if type then
										if TBobj_state(TBobjectives[type]) == 3 and TBobj_state(faketextureIndex) == 1 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										elseif TBobj_state(TBobjectives[type]) == 4 and TBobj_state(faketextureIndex) == 2 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										elseif TBobj_state(TBobjectives[type]) == 4 and TBobj_state(faketextureIndex) == 1 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										elseif TBobj_state(TBobjectives[type]) == 3 and TBobj_state(faketextureIndex) == 2 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										elseif TBobj_state(TBobjectives[type]) == 1 and TBobj_state(faketextureIndex) == 4 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
										elseif TBobj_state(TBobjectives[type]) == 2 and TBobj_state(faketextureIndex) == 3 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
										elseif TBobj_state(TBobjectives[type]) == 3 and TBobj_state(faketextureIndex) == 4 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
										elseif TBobj_state(TBobjectives[type]) == 4 and TBobj_state(faketextureIndex) == 3 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
										end
										TBobjectives[type] = faketextureIndex
									end
								end
							end
						end
						-- Warden's Vigil
						for i = l, l, 1 do
							local textureIndex = select(3, GetMapLandmarkInfo(i))
							local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
							local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
							if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
								if x == 0.34 and y == 0.69 then
									local faketextureIndex = textureIndex + 300
									local type = TBget_objective(faketextureIndex)
									if type then
										if TBobj_state(TBobjectives[type]) == 3 and TBobj_state(faketextureIndex) == 1 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										elseif TBobj_state(TBobjectives[type]) == 4 and TBobj_state(faketextureIndex) == 2 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										elseif TBobj_state(TBobjectives[type]) == 4 and TBobj_state(faketextureIndex) == 1 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										elseif TBobj_state(TBobjectives[type]) == 3 and TBobj_state(faketextureIndex) == 2 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										elseif TBobj_state(TBobjectives[type]) == 1 and TBobj_state(faketextureIndex) == 4 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
										elseif TBobj_state(TBobjectives[type]) == 2 and TBobj_state(faketextureIndex) == 3 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
										elseif TBobj_state(TBobjectives[type]) == 3 and TBobj_state(faketextureIndex) == 4 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
										elseif TBobj_state(TBobjectives[type]) == 4 and TBobj_state(faketextureIndex) == 3 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
										end
										TBobjectives[type] = faketextureIndex
									end
								end
							end
						end
						-- Towers
						-- East Spire
						for i = m, m, 1 do
							local textureIndex = select(3, GetMapLandmarkInfo(i))
							local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
							local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
							if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
								if x == 0.73 and y == 0.33 then
									local faketextureIndex = textureIndex + 400
									local type = TBget_objective(faketextureIndex)
									if type then
										if TBobj_state(TBobjectives[type]) == 5 and TBobj_state(faketextureIndex) == 7 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_HeavilyDamaged.mp3")
										elseif TBobj_state(TBobjectives[type]) == 7 and TBobj_state(faketextureIndex) == 9 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Destroyed.mp3")
										elseif TBobj_state(TBobjectives[type]) == 6 and TBobj_state(faketextureIndex) == 8 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_HeavilyDamaged.mp3")
										elseif TBobj_state(TBobjectives[type]) == 8 and TBobj_state(faketextureIndex) == 9 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Destroyed.mp3")
										end
										TBobjectives[type] = faketextureIndex
									end
								end
							end
						end
						-- South Spire
						for i = n, n, 1 do
							local textureIndex = select(3, GetMapLandmarkInfo(i))
							local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
							local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
							if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
								if x == 0.52 and y == 0.78 then
									local faketextureIndex = textureIndex + 500
									local type = TBget_objective(faketextureIndex)
									if type then
										if TBobj_state(TBobjectives[type]) == 5 and TBobj_state(faketextureIndex) == 7 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_HeavilyDamaged.mp3")
										elseif TBobj_state(TBobjectives[type]) == 7 and TBobj_state(faketextureIndex) == 9 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Destroyed.mp3")
										elseif TBobj_state(TBobjectives[type]) == 6 and TBobj_state(faketextureIndex) == 8 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_HeavilyDamaged.mp3")
										elseif TBobj_state(TBobjectives[type]) == 8 and TBobj_state(faketextureIndex) == 9 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Destroyed.mp3")
										end
										TBobjectives[type] = faketextureIndex
									end
								end
							end
						end
						-- West Spire
						for i = o, o, 1 do
							local textureIndex = select(3, GetMapLandmarkInfo(i))
							local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
							local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
							if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
								if x == 0.26 and y == 0.28 then
									local faketextureIndex = textureIndex + 600
									local type = TBget_objective(faketextureIndex)
									if type then
										if TBobj_state(TBobjectives[type]) == 5 and TBobj_state(faketextureIndex) == 7 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_HeavilyDamaged.mp3")
										elseif TBobj_state(TBobjectives[type]) == 7 and TBobj_state(faketextureIndex) == 9 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Destroyed.mp3")
										elseif TBobj_state(TBobjectives[type]) == 6 and TBobj_state(faketextureIndex) == 8 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_HeavilyDamaged.mp3")
										elseif TBobj_state(TBobjectives[type]) == 8 and TBobj_state(faketextureIndex) == 9 then
											PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Destroyed.mp3")
										end
										TBobjectives[type] = faketextureIndex
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

PVPSoundFrame:SetScript("OnEvent", PVPSound.OnEvent)

function PVPSound:OnEventTwo(event, ...)
	if PS_EnableAddon == true then
		if event == "PLAYER_TARGET_CHANGED" or event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" then
			local isEnemy = UnitIsEnemy("player", "target")
			if UnitExists("target") and isEnemy == 1 and UnitIsDeadOrGhost("target") ~= 1 then
				local TargetGender
				if UnitSex("target") == 1 then
					TargetGender = "Unknown"
				elseif UnitSex("target") == 2 then
					TargetGender = "Male"
				elseif UnitSex("target") == 3 then
					TargetGender = "Female"
				end
				local TargetHealthPercent = UnitHealth("target") / UnitHealthMax("target")
				if PS_Mode == "PVP" then
					if UnitIsPlayer("target") == 1 then
						local type = TargetHealthGetObjective(TargetHealthPercent)
						if type then
							if TargetHealthState(TargetHealthObjectives[type]) == 1 and TargetHealthState(TargetHealthPercent) == 2 then
								if TargetGender == "Male" or TargetGender == "Unknown" then
									PVPSound:AddKillToQueue("Execute", PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\Execute\\FinishHim.mp3")
								elseif TargetGender == "Female" then
									PVPSound:AddKillToQueue("Execute", PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\Execute\\FinishHer.mp3")
								end
							end
							TargetHealthObjectives[type] = TargetHealthPercent
						end
					end
				elseif PS_Mode == "PVE" then
					if UnitIsPlayer("target") == nil then
						local type = TargetHealthGetObjective(TargetHealthPercent)
						if type then
							if TargetHealthState(TargetHealthObjectives[type]) == 1 and TargetHealthState(TargetHealthPercent) == 2 then
								if TargetGender == "Male" or TargetGender == "Unknown" then
									PVPSound:AddKillToQueue("Execute", PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\Execute\\FinishHim.mp3")
								elseif TargetGender == "Female" then
									PVPSound:AddKillToQueue("Execute", PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\Execute\\FinishHer.mp3")
								end
							end
							TargetHealthObjectives[type] = TargetHealthPercent
						end
					end
				elseif PS_Mode == "PVPandPVE" then
					local type = TargetHealthGetObjective(TargetHealthPercent)
					if type then
						if TargetHealthState(TargetHealthObjectives[type]) == 1 and TargetHealthState(TargetHealthPercent) == 2 then
							if TargetGender == "Male" or TargetGender == "Unknown" then
								PVPSound:AddKillToQueue("Execute", PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\Execute\\FinishHim.mp3")
							elseif TargetGender == "Female" then
								PVPSound:AddKillToQueue("Execute", PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\Execute\\FinishHer.mp3")
							end
						end
						TargetHealthObjectives[type] = TargetHealthPercent
					end
				end
			end
		end

		if PS_BattlegroundSound == true then
			if event == "UPDATE_WORLD_STATES" then
				-- Time Remaining
				if MyZone == "Zone_WarsongGulch" or MyZone == "Zone_TwinPeaks" or MyZone == "Zone_TolBarad" or MyZone == "Zone_StrandoftheAncients" --[[or MyZone == "Zone_Arenas"]] then
					if BgIsOver ~= true then
						local i
						if MyZone == "Zone_StrandoftheAncients" then
							i = 7
						--[[elseif MyZone == "Zone_Arenas" then
							i = 6]]
						else
							i = 4
						end
						if (select(4, GetWorldStateUIInfo(i))) ~= nil then
							-- Time Remaining
							local TimeRemaining = tonumber(string.match(select(4, GetWorldStateUIInfo(i)), "(%d+)"))
							if TimeRemaining then
								local type = TimeRemainingget_objective(TimeRemaining)
								if type then
									if TimeRemainingobj_state(TimeRemainingobjectives[type]) == 1 and TimeRemainingobj_state(TimeRemaining) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\FiveMinutesRemain.mp3")
									elseif TimeRemainingobj_state(TimeRemainingobjectives[type]) == 3 and TimeRemainingobj_state(TimeRemaining) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\ThreeMinutesRemain.mp3")
									elseif TimeRemainingobj_state(TimeRemainingobjectives[type]) == 4 and TimeRemainingobj_state(TimeRemaining) == 5 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\TwoMinutesRemain.mp3")
									elseif TimeRemainingobj_state(TimeRemainingobjectives[type]) == 5 and TimeRemainingobj_state(TimeRemaining) == 6 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\OneMinutesRemain.mp3")
									end
									TimeRemainingobjectives[type] = TimeRemaining
								end
							end
						end
					end
					if (select(4, GetWorldStateUIInfo(2))) ~= nil and (select(4, GetWorldStateUIInfo(3))) ~= nil then
						-- Alliance Score
						local AllianceScore = tonumber(string.match(select(4, GetWorldStateUIInfo(2)), "(%d)/"))
						-- Horde Score
						local HordeScore = tonumber(string.match(select(4, GetWorldStateUIInfo(3)), "(%d)/"))
						-- Alliance
						if AllianceScore and HordeScore then
							local type = WSGandTPAget_objective(AllianceScore)
							if type then
								if WSGandTPAobj_state(WSGandTPAobjectives[type]) == 1 and WSGandTPAobj_state(AllianceScore) == 2 and HordeScore == 0 then
									PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
									LastScored = "Alliance"
								elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 2 and WSGandTPAobj_state(AllianceScore) == 3 and HordeScore == 1 then
									if LastScored == "Alliance" then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
									elseif LastScored == "Horde" then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
									else
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
									end
									LastScored = "Alliance"
								elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 1 and WSGandTPAobj_state(AllianceScore) == 2 and HordeScore == 2 then
									PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
									LastScored = "Alliance"
								elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 1 and WSGandTPAobj_state(AllianceScore) == 2 and HordeScore == 1 then
									PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
									LastScored = "Alliance"
								elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 2 and WSGandTPAobj_state(AllianceScore) == 3 and HordeScore == 2 then
									PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Takes_Lead.mp3")
									LastScored = "Alliance"
								elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 2 and WSGandTPAobj_state(AllianceScore) == 3 and HordeScore == 0 then
									PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Inc_Lead.mp3")
									LastScored = "Alliance"
								end
								if PS_BattlegroundSoundEngine == true then
									-- 3/3 Scores
									if WSGandTPAobj_state(WSGandTPAobjectives[type]) == 3 and WSGandTPAobj_state(AllianceScore) == 4 and HordeScore == 0 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
									elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 3 and WSGandTPAobj_state(AllianceScore) == 4 and HordeScore == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
									elseif WSGandTPAobj_state(WSGandTPAobjectives[type]) == 3 and WSGandTPAobj_state(AllianceScore) == 4 and HordeScore == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
									end
								end
								WSGandTPAobjectives[type] = AllianceScore
							end
						end
						-- Horde
						if AllianceScore and HordeScore then
							local type = WSGandTPHget_objective(HordeScore)
							if type then
								if WSGandTPHobj_state(WSGandTPHobjectives[type]) == 1 and WSGandTPHobj_state(HordeScore) == 2 and AllianceScore == 0 then
									PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
									LastScored = "Horde"
								elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 2 and WSGandTPHobj_state(HordeScore) == 3 and AllianceScore == 1 then
									if LastScored == "Alliance" then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
									elseif LastScored == "Horde" then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
									else
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
									end
									LastScored = "Horde"
								elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 1 and WSGandTPHobj_state(HordeScore) == 2 and AllianceScore == 2 then
									PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
									LastScored = "Horde"
								elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 1 and WSGandTPHobj_state(HordeScore) == 2 and AllianceScore == 1 then
									PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
									LastScored = "Horde"
								elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 2 and WSGandTPHobj_state(HordeScore) == 3 and AllianceScore == 2 then
									PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Takes_Lead.mp3")
									LastScored = "Horde"
								elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 2 and WSGandTPHobj_state(HordeScore) == 3 and AllianceScore == 0 then
									PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Inc_Lead.mp3")
									LastScored = "Horde"
								end
								if PS_BattlegroundSoundEngine == true then
									-- 3/3 Scores
									if WSGandTPHobj_state(WSGandTPHobjectives[type]) == 3 and WSGandTPHobj_state(HordeScore) == 4 and AllianceScore == 0 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
									elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 3 and WSGandTPHobj_state(HordeScore) == 4 and AllianceScore == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
									elseif WSGandTPHobj_state(WSGandTPHobjectives[type]) == 3 and WSGandTPHobj_state(HordeScore) == 4 and AllianceScore == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
									end
								end
								WSGandTPHobjectives[type] = HordeScore
							end
						end
					end
				 -- Arathi Basin
				elseif MyZone == "Zone_ArathiBasin" then
					-- Stables
					for i = 1, 1, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.38 and y == 0.27 then
								local faketextureIndex = textureIndex + 500
								local type = ABget_objective(faketextureIndex)
								if type then
									if ABobj_state(ABobjectives[type]) == 3 and ABobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if ABobjectives.Blacksmith == 128 and ABobjectives.Farm == 233 and ABobjectives.GoldMine == 318 and ABobjectives.LumberMill == 423 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif ABobj_state(ABobjectives[type]) == 4 and ABobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if ABobjectives.Blacksmith == 130 and ABobjectives.Farm == 235 and ABobjectives.GoldMine == 320 and ABobjectives.LumberMill == 425 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif ABobj_state(ABobjectives[type]) == 4 and ABobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if ABobjectives.Blacksmith == 128 and ABobjectives.Farm == 233 and ABobjectives.GoldMine == 318 and ABobjectives.LumberMill == 423 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif ABobj_state(ABobjectives[type]) == 3 and ABobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if ABobjectives.Blacksmith == 130 and ABobjectives.Farm == 235 and ABobjectives.GoldMine == 320 and ABobjectives.LumberMill == 425 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif ABobj_state(ABobjectives[type]) == 1 and ABobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif ABobj_state(ABobjectives[type]) == 2 and ABobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									elseif ABobj_state(ABobjectives[type]) == 3 and ABobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif ABobj_state(ABobjectives[type]) == 4 and ABobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									end
									ABobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Blacksmith
					for i = 2, 2, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.48 and y == 0.44 then
								local faketextureIndex = textureIndex + 100
								local type = ABget_objective(faketextureIndex)
								if type then
									if ABobj_state(ABobjectives[type]) == 3 and ABobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if ABobjectives.Farm == 233 and ABobjectives.GoldMine == 318 and ABobjectives.LumberMill == 423 and ABobjectives.Stables == 538 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif ABobj_state(ABobjectives[type]) == 4 and ABobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if ABobjectives.Farm == 235 and ABobjectives.GoldMine == 320 and ABobjectives.LumberMill == 425 and ABobjectives.Stables == 540 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif ABobj_state(ABobjectives[type]) == 4 and ABobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if ABobjectives.Farm == 233 and ABobjectives.GoldMine == 318 and ABobjectives.LumberMill == 423 and ABobjectives.Stables == 538 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif ABobj_state(ABobjectives[type]) == 3 and ABobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if ABobjectives.Farm == 235 and ABobjectives.GoldMine == 320 and ABobjectives.LumberMill == 425 and ABobjectives.Stables == 540 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif ABobj_state(ABobjectives[type]) == 1 and ABobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif ABobj_state(ABobjectives[type]) == 2 and ABobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									elseif ABobj_state(ABobjectives[type]) == 3 and ABobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif ABobj_state(ABobjectives[type]) == 4 and ABobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									end
									ABobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Lumber Mill
					for i = 3, 3, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.38 and y == 0.59 then
								local faketextureIndex = textureIndex + 400
								local type = ABget_objective(faketextureIndex)
								if type then
									if ABobj_state(ABobjectives[type]) == 3 and ABobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if ABobjectives.Blacksmith == 128 and ABobjectives.Farm == 233 and ABobjectives.GoldMine == 318 and ABobjectives.Stables == 538 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif ABobj_state(ABobjectives[type]) == 4 and ABobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if ABobjectives.Blacksmith == 130 and ABobjectives.Farm == 235 and ABobjectives.GoldMine == 320 and ABobjectives.Stables == 540 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif ABobj_state(ABobjectives[type]) == 4 and ABobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if ABobjectives.Blacksmith == 128 and ABobjectives.Farm == 233 and ABobjectives.GoldMine == 318 and ABobjectives.Stables == 538 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif ABobj_state(ABobjectives[type]) == 3 and ABobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if ABobjectives.Blacksmith == 130 and ABobjectives.Farm == 235 and ABobjectives.GoldMine == 320 and ABobjectives.Stables == 540 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif ABobj_state(ABobjectives[type]) == 1 and ABobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif ABobj_state(ABobjectives[type]) == 2 and ABobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									elseif ABobj_state(ABobjectives[type]) == 3 and ABobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif ABobj_state(ABobjectives[type]) == 4 and ABobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									end
									ABobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Gold Mine
					for i = 4, 4, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.58 and y == 0.28 then
								local faketextureIndex = textureIndex + 300
								local type = ABget_objective(faketextureIndex)
								if type then
									if ABobj_state(ABobjectives[type]) == 3 and ABobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if ABobjectives.Blacksmith == 128 and ABobjectives.Farm == 233 and ABobjectives.LumberMill == 423 and ABobjectives.Stables == 538 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif ABobj_state(ABobjectives[type]) == 4 and ABobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if ABobjectives.Blacksmith == 130 and ABobjectives.Farm == 235 and ABobjectives.LumberMill == 425 and ABobjectives.Stables == 540 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif ABobj_state(ABobjectives[type]) == 4 and ABobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if ABobjectives.Blacksmith == 128 and ABobjectives.Farm == 233 and ABobjectives.LumberMill == 423 and ABobjectives.Stables == 538 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif ABobj_state(ABobjectives[type]) == 3 and ABobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if ABobjectives.Blacksmith == 130 and ABobjectives.Farm == 235 and ABobjectives.LumberMill == 425 and ABobjectives.Stables == 540 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif ABobj_state(ABobjectives[type]) == 1 and ABobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif ABobj_state(ABobjectives[type]) == 2 and ABobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									elseif ABobj_state(ABobjectives[type]) == 3 and ABobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif ABobj_state(ABobjectives[type]) == 4 and ABobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									end
									ABobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Farm
					for i = 5, 5, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.58 and y == 0.58 then
								local faketextureIndex = textureIndex + 200
								local type = ABget_objective(faketextureIndex)
								if type then
									if ABobj_state(ABobjectives[type]) == 3 and ABobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if ABobjectives.Blacksmith == 128 and ABobjectives.GoldMine == 318 and ABobjectives.LumberMill == 423 and ABobjectives.Stables == 538 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif ABobj_state(ABobjectives[type]) == 4 and ABobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if ABobjectives.Blacksmith == 130 and ABobjectives.GoldMine == 320 and ABobjectives.LumberMill == 425 and ABobjectives.Stables == 540 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif ABobj_state(ABobjectives[type]) == 4 and ABobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if ABobjectives.Blacksmith == 128 and ABobjectives.GoldMine == 318 and ABobjectives.LumberMill == 423 and ABobjectives.Stables == 538 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif ABobj_state(ABobjectives[type]) == 3 and ABobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if ABobjectives.Blacksmith == 130 and ABobjectives.GoldMine == 320 and ABobjectives.LumberMill == 425 and ABobjectives.Stables == 540 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif ABobj_state(ABobjectives[type]) == 1 and ABobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif ABobj_state(ABobjectives[type]) == 2 and ABobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									elseif ABobj_state(ABobjectives[type]) == 3 and ABobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif ABobj_state(ABobjectives[type]) == 4 and ABobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									end
									ABobjectives[type] = faketextureIndex
								end
							end
						end
					end
				 -- The Battle for Gilneas
				elseif MyZone == "Zone_TheBattleforGilneas" then
					-- Mines
					for i = 1, 1, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.63 and y == 0.41 then
								local faketextureIndex = textureIndex + 200
								local type = TBFGget_objective(faketextureIndex)
								if type then
									if TBFGobj_state(TBFGobjectives[type]) == 3 and TBFGobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if TBFGobjectives.Lighthouse == 111 and TBFGobjectives.Waterworks == 328 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif TBFGobj_state(TBFGobjectives[type]) == 4 and TBFGobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if TBFGobjectives.Lighthouse == 110 and TBFGobjectives.Waterworks == 330 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif TBFGobj_state(TBFGobjectives[type]) == 4 and TBFGobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if TBFGobjectives.Lighthouse == 111 and TBFGobjectives.Waterworks == 328 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif TBFGobj_state(TBFGobjectives[type]) == 3 and TBFGobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if TBFGobjectives.Lighthouse == 110 and TBFGobjectives.Waterworks == 330 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif TBFGobj_state(TBFGobjectives[type]) == 1 and TBFGobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif TBFGobj_state(TBFGobjectives[type]) == 2 and TBFGobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									elseif TBFGobj_state(TBFGobjectives[type]) == 3 and TBFGobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif TBFGobj_state(TBFGobjectives[type]) == 4 and TBFGobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									end
									TBFGobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Waterworks
					for i = 2, 2, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.61 and y == 0.71 then
								local faketextureIndex = textureIndex + 300
								local type = TBFGget_objective(faketextureIndex)
								if type then
									if TBFGobj_state(TBFGobjectives[type]) == 3 and TBFGobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if TBFGobjectives.Lighthouse == 111 and TBFGobjectives.Mines == 218 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif TBFGobj_state(TBFGobjectives[type]) == 4 and TBFGobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if TBFGobjectives.Lighthouse == 110 and TBFGobjectives.Mines == 220 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif TBFGobj_state(TBFGobjectives[type]) == 4 and TBFGobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if TBFGobjectives.Lighthouse == 111 and TBFGobjectives.Mines == 218 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif TBFGobj_state(TBFGobjectives[type]) == 3 and TBFGobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if TBFGobjectives.Lighthouse == 110 and TBFGobjectives.Mines == 220 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif TBFGobj_state(TBFGobjectives[type]) == 1 and TBFGobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif TBFGobj_state(TBFGobjectives[type]) == 2 and TBFGobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									elseif TBFGobj_state(TBFGobjectives[type]) == 3 and TBFGobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif TBFGobj_state(TBFGobjectives[type]) == 4 and TBFGobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									end
									TBFGobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Lighthouse
					for i = 3, 3, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.35 and y == 0.62 then
								local faketextureIndex = textureIndex + 100
								local type = TBFGget_objective(faketextureIndex)
								if type then
									if TBFGobj_state(TBFGobjectives[type]) == 3 and TBFGobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if TBFGobjectives.Mines == 218 and TBFGobjectives.Waterworks == 328 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif TBFGobj_state(TBFGobjectives[type]) == 4 and TBFGobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if TBFGobjectives.Mines == 220 and TBFGobjectives.Waterworks == 330 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif TBFGobj_state(TBFGobjectives[type]) == 4 and TBFGobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if TBFGobjectives.Mines == 218 and TBFGobjectives.Waterworks == 328 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif TBFGobj_state(TBFGobjectives[type]) == 3 and TBFGobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if TBFGobjectives.Mines == 220 and TBFGobjectives.Waterworks == 330 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif TBFGobj_state(TBFGobjectives[type]) == 1 and TBFGobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif TBFGobj_state(TBFGobjectives[type]) == 2 and TBFGobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									elseif TBFGobj_state(TBFGobjectives[type]) == 3 and TBFGobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif TBFGobj_state(TBFGobjectives[type]) == 4 and TBFGobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									end
									TBFGobjectives[type] = faketextureIndex
								end
							end
						end
					end
				 -- Deepwind Gorge
				elseif MyZone == "Zone_DeepwindGorge" then
					-- Pandaren Mine
					for i = 1, 1, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.58 and y == 0.16 then
								local faketextureIndex = textureIndex + 300
								local type = DGget_objective(faketextureIndex)
								if type then
									if DGobj_state(DGobjectives[type]) == 3 and DGobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if DGobjectives.CenterMine == 118 and DGobjectives.GoblinMine == 218 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif DGobj_state(DGobjectives[type]) == 4 and DGobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if DGobjectives.CenterMine == 120 and DGobjectives.GoblinMine == 220 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif DGobj_state(DGobjectives[type]) == 4 and DGobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if DGobjectives.CenterMine == 118 and DGobjectives.GoblinMine == 218 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif DGobj_state(DGobjectives[type]) == 3 and DGobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if DGobjectives.CenterMine == 120 and DGobjectives.GoblinMine == 220 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif DGobj_state(DGobjectives[type]) == 1 and DGobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif DGobj_state(DGobjectives[type]) == 2 and DGobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									elseif DGobj_state(DGobjectives[type]) == 3 and DGobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif DGobj_state(DGobjectives[type]) == 4 and DGobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									end
									DGobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Goblin Mine
					for i = 2, 2, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.45 and y == 0.81 then
								local faketextureIndex = textureIndex + 200
								local type = DGget_objective(faketextureIndex)
								if type then
									if DGobj_state(DGobjectives[type]) == 3 and DGobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if DGobjectives.CenterMine == 118 and DGobjectives.PandarenMine == 318 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif DGobj_state(DGobjectives[type]) == 4 and DGobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if DGobjectives.CenterMine == 120 and DGobjectives.PandarenMine == 320 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif DGobj_state(DGobjectives[type]) == 4 and DGobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if DGobjectives.CenterMine == 118 and DGobjectives.PandarenMine == 318 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif DGobj_state(DGobjectives[type]) == 3 and DGobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if DGobjectives.CenterMine == 120 and DGobjectives.PandarenMine == 320 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif DGobj_state(DGobjectives[type]) == 1 and DGobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif DGobj_state(DGobjectives[type]) == 2 and DGobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									elseif DGobj_state(DGobjectives[type]) == 3 and DGobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif DGobj_state(DGobjectives[type]) == 4 and DGobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									end
									DGobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Center Mine
					for i = 3, 3, 1 do
						local textureIndex = select(3, GetMapLandmarkInfo(i))
						local x = tonumber(string.sub(tostring(select(4, GetMapLandmarkInfo(i))), 1, 4))
						local y = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							if x == 0.52 and y == 0.49 then
								local faketextureIndex = textureIndex + 100
								local type = DGget_objective(faketextureIndex)
								if type then
									if DGobj_state(DGobjectives[type]) == 3 and DGobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if DGobjectives.GoblinMine == 218 and DGobjectives.PandarenMine == 318 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif DGobj_state(DGobjectives[type]) == 4 and DGobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if DGobjectives.GoblinMine == 220 and DGobjectives.PandarenMine == 320 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif DGobj_state(DGobjectives[type]) == 4 and DGobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										if DGobjectives.GoblinMine == 218 and DGobjectives.PandarenMine == 318 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif DGobj_state(DGobjectives[type]) == 3 and DGobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										if DGobjectives.GoblinMine == 220 and DGobjectives.PandarenMine == 320 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end
									elseif DGobj_state(DGobjectives[type]) == 1 and DGobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif DGobj_state(DGobjectives[type]) == 2 and DGobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									elseif DGobj_state(DGobjectives[type]) == 3 and DGobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif DGobj_state(DGobjectives[type]) == 4 and DGobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									end
									DGobjectives[type] = faketextureIndex
								end
							end
						end
					end
				 -- Eye of the Storm WinSounds
				--[[elseif MyZone == "Zone_EyeoftheStorm" then
					if BgIsOver ~= true then
						if IsRated == false then
							-- Alliance Victory Points
							for i = 3, 3, 1 do
								if (select(4, GetWorldStateUIInfo(i))) ~= nil then
									local faketextureIndex = tonumber(string.match(select(4, GetWorldStateUIInfo(i)), "(%d+)/"))
									if faketextureIndex then
										local type = EOTSWINget_objective(faketextureIndex)
										if BgIsOver ~= true then
											if type then
												if EOTSWINobj_state(EOTSWINobjectives[type]) == 2 and EOTSWINobj_state(faketextureIndex) == 1 then
													PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceWins.mp3")
													BgIsOver = true
													PVPSound:ClearPaybackQueue()
													PVPSound:ClearRetributionQueue()
												end
												EOTSWINobjectives[type] = faketextureIndex
											end
										end
									end
								end
							end
							-- Horde Victory Points
							for i = 4, 4, 1 do
								if (select(4, GetWorldStateUIInfo(i))) ~= nil then
									local faketextureIndex = tonumber(string.match(select(4, GetWorldStateUIInfo(i)), "(%d+)/"))
									if faketextureIndex then
										local type = EOTSWINget_objective(faketextureIndex)
										if BgIsOver ~= true then
											if type then
												if EOTSWINobj_state(EOTSWINobjectives[type]) == 2 and EOTSWINobj_state(faketextureIndex) == 1 then
													PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeWins.mp3")
													BgIsOver = true
													PVPSound:ClearPaybackQueue()
													PVPSound:ClearRetributionQueue()
												end
												EOTSWINobjectives[type] = faketextureIndex
											end
										end
									end
								end
							end
						end
					end]]
				 -- Silvershard Mines WinSounds
				elseif MyZone == "Zone_SilvershardMines" then
					if BgIsOver ~= true then
						-- Alliance Resources
						for i = 2, 2, 1 do
							if (select(4, GetWorldStateUIInfo(i))) ~= nil then
								local faketextureIndex = tonumber(string.match(select(4, GetWorldStateUIInfo(i)), "(%d+)/"))
								if faketextureIndex then
									local type = SMWINget_objective(faketextureIndex)
									if BgIsOver ~= true then
										if type then
											if SMWINobj_state(SMWINobjectives[type]) == 2 and SMWINobj_state(faketextureIndex) == 1 then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceWins.mp3")
												BgIsOver = true
												PVPSound:ClearPaybackQueue()
												PVPSound:ClearRetributionQueue()
											end
											SMWINobjectives[type] = faketextureIndex
										end
									end
								end
							end
						end
						-- Horde Resources
						for i = 3, 3, 1 do
							if (select(4, GetWorldStateUIInfo(i))) ~= nil then
								local faketextureIndex = tonumber(string.match(select(4, GetWorldStateUIInfo(i)), "(%d+)/"))
								if faketextureIndex then
									local type = SMWINget_objective(faketextureIndex)
									if BgIsOver ~= true then
										if type then
											if SMWINobj_state(SMWINobjectives[type]) == 2 and SMWINobj_state(faketextureIndex) == 1 then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeWins.mp3")
												BgIsOver = true
												PVPSound:ClearPaybackQueue()
												PVPSound:ClearRetributionQueue()
											end
											SMWINobjectives[type] = faketextureIndex
										end
									end
								end
							end
						end
					end
				 -- Alterac Valley and Isle of Conquest Countdown
				elseif MyZone == "Zone_AlteracValley" or MyZone == "Zone_IsleofConquest" then
					-- Alliance Reinforcements
					for i = 2, 2, 1 do
						if (select(4, GetWorldStateUIInfo(i))) ~= nil then
							local faketextureIndex = tonumber(string.match(select(4, GetWorldStateUIInfo(i)), ": (%d+)"))
							if faketextureIndex then
								local type = AVandIOCAget_objective(faketextureIndex)
								if type then
									if AVandIOCAobj_state(AVandIOCAobjectives[type]) == 1 and AVandIOCAobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\TenKillsRemain.mp3")
									elseif AVandIOCAobj_state(AVandIOCAobjectives[type]) == 3 and AVandIOCAobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\FiveKillsRemain.mp3")
									elseif AVandIOCAobj_state(AVandIOCAobjectives[type]) == 5 and AVandIOCAobj_state(faketextureIndex) == 6 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\OneKillRemains.mp3")
									end
									AVandIOCAobjectives[type] = faketextureIndex
								end
							end
						end
					end
					-- Horde Reinforcements
					for i = 3, 3, 1 do
						if (select(4, GetWorldStateUIInfo(i))) ~= nil then
							local faketextureIndex = tonumber(string.match(select(4, GetWorldStateUIInfo(i)), ": (%d+)"))
							if faketextureIndex then
								local type = AVandIOCHget_objective(faketextureIndex)
								if type then
									if AVandIOCHobj_state(AVandIOCHobjectives[type]) == 1 and AVandIOCHobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\TenKillsRemain.mp3")
									elseif AVandIOCHobj_state(AVandIOCHobjectives[type]) == 3 and AVandIOCHobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\FiveKillsRemain.mp3")
									elseif AVandIOCHobj_state(AVandIOCHobjectives[type]) == 5 and AVandIOCHobj_state(faketextureIndex) == 6 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\OneKillRemains.mp3")
									end
									AVandIOCHobjectives[type] = faketextureIndex
								end
							end
						end
					end
				end
			end
		end
	end
end

PVPSoundFrameTwo:SetScript("OnEvent", PVPSound.OnEventTwo)

function PVPSound:OnEventThree(event, ...)
	if PS_EnableAddon == true then
		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local _, eventType, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, swingOverkill, spellOverkill
			if WowBuildInfo >= 40200 then
				_, eventType, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, _, swingOverkill, _, _, spellOverkill = ...
			elseif WowBuildInfo >= 40100 then
				_, eventType, _, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, _, swingOverkill, _, _, spellOverkill = ...
			else
				_, eventType, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, _, swingOverkill, _, _, spellOverkill = ...
			end

			local PS_COMBATLOG_FILTER_MY_PETS					= bit.bor (COMBATLOG_OBJECT_AFFILIATION_MINE, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_OBJECT, COMBATLOG_OBJECT_TYPE_GUARDIAN, COMBATLOG_OBJECT_TYPE_PET)
			local PS_COMBATLOG_FILTER_ENEMY_NPCS				= bit.bor (COMBATLOG_OBJECT_AFFILIATION_MASK, COMBATLOG_OBJECT_REACTION_MASK, COMBATLOG_OBJECT_CONTROL_NPC, COMBATLOG_OBJECT_TYPE_NPC)
			local PS_COMBATLOG_FILTER_ENEMY_PLAYERS				= bit.bor (COMBATLOG_OBJECT_AFFILIATION_MASK, COMBATLOG_OBJECT_REACTION_MASK, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PLAYER)
			local PS_COMBATLOG_FILTER_ENEMY_PLAYERS_AND_NPCS	= bit.bor (COMBATLOG_OBJECT_AFFILIATION_MASK, COMBATLOG_OBJECT_REACTION_MASK, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_CONTROL_NPC, COMBATLOG_OBJECT_TYPE_NPC)

			-- To an Enemy
			if destName and not CombatLog_Object_IsA(destFlags, COMBATLOG_OBJECT_NONE) then
				ToEnemyPlayer = CombatLog_Object_IsA(destFlags, PS_COMBATLOG_FILTER_ENEMY_PLAYERS)
				ToEnemyNPC = CombatLog_Object_IsA(destFlags, PS_COMBATLOG_FILTER_ENEMY_NPCS)
				ToEnemyPlayerAndNPC = CombatLog_Object_IsA(destFlags, PS_COMBATLOG_FILTER_ENEMY_PLAYERS_AND_NPCS)
			end
			-- From an Enemy or from My Pets
			if sourceName and not CombatLog_Object_IsA(sourceFlags, COMBATLOG_OBJECT_NONE) then
				FromMyPets = CombatLog_Object_IsA(sourceFlags, PS_COMBATLOG_FILTER_MY_PETS)
				FromEnemyNPC = CombatLog_Object_IsA(sourceFlags, PS_COMBATLOG_FILTER_ENEMY_NPCS)
				FromEnemyPlayer = CombatLog_Object_IsA(sourceFlags, PS_COMBATLOG_FILTER_ENEMY_PLAYERS)
				FromEnemyPlayerAndNPC = CombatLog_Object_IsA(sourceFlags, PS_COMBATLOG_FILTER_ENEMY_PLAYERS_AND_NPCS)
			end
			-- PVP and PVE Mode
			if PS_Mode == "PVP" then
				ToEnemy = ToEnemyPlayer
				FromEnemy = FromEnemyPlayer
			elseif PS_Mode == "PVE" then
				ToEnemy = ToEnemyNPC
				FromEnemy = FromEnemyNPC
			elseif PS_Mode == "PVPandPVE" then
				ToEnemy = ToEnemyPlayerAndNPC
				FromEnemy = FromEnemyPlayerAndNPC
			end

			if (eventType == "PARTY_KILL" and sourceGUID == UnitGUID("player") and ToEnemy) or ((eventType == "SWING_DAMAGE" and destGUID ~= UnitGUID("player") and FromMyPets and ToEnemy and tonumber(swingOverkill) ~= nil and tonumber(swingOverkill) ~= - 1) and PS_PetKill == true) or (((eventType == "RANGE_DAMAGE" or eventType == "SPELL_DAMAGE" or eventType == "SPELL_PERIODIC_DAMAGE") and destGUID ~= UnitGUID("player") and FromMyPets and ToEnemy and tonumber(spellOverkill) ~= nil and tonumber(spellOverkill) ~= - 1) and PS_PetKill == true) then
				if PVPSound:CheckRecentlyKilledQueue(destGUID) ~= true then
					if PS_PaybackSound == true then
						KilledWho = destName
						PVPSound:AddToPaybackQueue(KilledWho)
					end
					-- First Killing
					if not LastKill or (GetTime() - LastKill > ResetTime) or TimerReset then
						CurrentStreak = 1
						PVPSound:TriggerKill("Kill", CurrentStreak)
						-- RetributionKilling (First Blood)
						if PS_PaybackSound == true then
							if PVPSound:CheckRetributionQueue(KilledWho) == true then
								if PVPSound:CheckRecentlyPaybackQueue("Retribution") ~= true then
									PVPSound:TriggerKill("PaybackKill", 2)
								end
								PVPSound:AddToRecentlyPaybackQueue("Retribution")
							end
						end
						-- Emotes and Fake Emotes
						if PS_Emote == true then
							local KillSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."KillDurations")
							if PS_EmoteMode == true then
								if MyGender == "Male" then
									local Message = Msg_Streak1Male
									SendChatMessage(Message.." "..KillSoundLengthTable[CurrentStreak].name.."!", "EMOTE")
								elseif MyGender == "Female" then
									local Message = Msg_Streak1Female
									SendChatMessage(Message.." "..KillSoundLengthTable[CurrentStreak].name.."!", "EMOTE")
								end
							elseif PS_EmoteMode == false then
								if MyGender == "Male" then
									local Message = Msg_Streak1Male
									print("|cFFFFFF00"..sourceName.." "..Message.." "..KillSoundLengthTable[CurrentStreak].name.."!".."|r")
								elseif MyGender == "Female" then
									local Message = Msg_Streak1Female
									print("|cFFFFFF00"..sourceName.." "..Message.." "..KillSoundLengthTable[CurrentStreak].name.."!".."|r")
								end
							end
						end
						if PS_MultiKillSound == true then
							if not LastKill or (GetTime() - LastKill > MultiKillTime) or TimerReset then
								MultiKills = 1
							end
						end
						TimerReset = false
					 -- Killing
					elseif (GetTime() - LastKill <= ResetTime) then
						if (GetTime() - LastKill <= PS.KillTime) then
							FirstKill = LastKill
							if (GetTime() - FirstKill <= PS.KillTime) then
								local KillSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."KillDurations")
								CurrentStreak = CurrentStreak + (1 / RankStep)
								if CurrentStreak > table.getn(KillSoundLengthTable) then
									CurrentStreak = (table.getn(KillSoundLengthTable) - 1) + (1 / RankStep)
								end
								if CurrentStreak <= table.getn(KillSoundLengthTable) then
									PVPSound:TriggerKill("Kill", CurrentStreak)
								end
								-- RetributionKilling (0-60sec)
								if PS_PaybackSound == true then
									if PVPSound:CheckRetributionQueue(KilledWho) == true then
										if PVPSound:CheckRecentlyPaybackQueue("Retribution") ~= true then
											PVPSound:TriggerKill("PaybackKill", 2)
										end
										PVPSound:AddToRecentlyPaybackQueue("Retribution")
									end
								end
								-- Emotes and Fake Emotes
								if PS_Emote == true then
									local KillSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."KillDurations")
									if PS_EmoteMode == true then
										if CurrentStreak > 1 then
											local Message = getglobal("Msg_Streak"..CurrentStreak)
											if CurrentStreak > 10 then
												Message = Msg_Streak10
											end
											local Decimal = tonumber(string.match(tostring(CurrentStreak), "%.(%d+)"))
											if Decimal == nil then
												if CurrentStreak < table.getn(KillSoundLengthTable) then
													SendChatMessage(Message.." "..KillSoundLengthTable[CurrentStreak].name.."!", "EMOTE")
												elseif CurrentStreak == table.getn(KillSoundLengthTable) then
													SendChatMessage(Message.." "..KillSoundLengthTable[CurrentStreak].name.."!!!", "EMOTE")
												else
													SendChatMessage(Message.." "..KillSoundLengthTable[table.getn(KillSoundLengthTable)].name.."!!!", "EMOTE")
												end
											end
										end
									elseif PS_EmoteMode == false then
										if CurrentStreak > 1 then
											local Message = getglobal("Msg_Streak"..CurrentStreak)
											if CurrentStreak > 10 then
												Message = Msg_Streak10
											end
											local Decimal = tonumber(string.match(tostring(CurrentStreak), "%.(%d+)"))
											if Decimal == nil then
												if CurrentStreak < table.getn(KillSoundLengthTable) then
													print("|cFFFFFF00"..sourceName.." "..Message.." "..KillSoundLengthTable[CurrentStreak].name.."!".."|r")
												elseif CurrentStreak == table.getn(KillSoundLengthTable) then
													print("|cFFFFFF00"..sourceName.." "..Message.." "..KillSoundLengthTable[CurrentStreak].name.."!!!".."|r")
												else
													print("|cFFFFFF00"..sourceName.." "..Message.." "..KillSoundLengthTable[table.getn(KillSoundLengthTable)].name.."!!!".."|r")
												end
											end
										end
									end
								end
								-- MultiKilling
								if PS_MultiKillSound == true then
									if (GetTime() - LastKill <= MultiKillTime) then
										FirstMultiKill = LastKill
										if (GetTime() - FirstMultiKill > MultiKillTime) then
											MultiKills = 1
										elseif (GetTime() - FirstMultiKill <= MultiKillTime) then
											if MultiKills then
												MultiKills = MultiKills + 1
												local MultiKillSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."MultiKillDurations")
												if MultiKills - 1 <= table.getn(MultiKillSoundLengthTable) then
													PVPSound:TriggerKill("MultiKill", MultiKills - 1)
												else
													PVPSound:TriggerKill("MultiKill", table.getn(MultiKillSoundLengthTable))
												end
											end
										end
									end
								end
							end
						elseif (GetTime() - LastKill > PS.KillTime) then
							-- If triggers a kill after the Killing Time (60 sec) than replay the last KillSound without emote and SCT
							if PS_KillSound == true then
								if RankStep <= 1 then
									local KillSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."KillDurations")
									PVPSound:AddKillToQueue("Kill", KillSoundLengthTable[CurrentStreak].dir)
									-- Create a blank table in the Sct Queue with "nil" string message
									if PS_KillSct == true or PS_MultiKillSct == true or PS_PaybackSct == true then
										local KillSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."KillDurations")
										PVPSound:AddSctToQueue("Kill", KillSoundLengthTable[CurrentStreak].dir, "nil", PSSctFrame)
									end
								end
							end
							-- RetributionKilling (60-90sec)
							if (GetTime() - LastKill < PS.PaybackKillTime) then
								if PS_PaybackSound == true then
									if PVPSound:CheckRetributionQueue(KilledWho) == true then
										if PVPSound:CheckRecentlyPaybackQueue("Retribution") ~= true then
											PVPSound:TriggerKill("PaybackKill", 2)
										end
										PVPSound:AddToRecentlyPaybackQueue("Retribution")
									end
								end
							end
						end
					end
					-- Reseting MultiKilling
					if PS_MultiKillSound == true then
						if not LastKill or (GetTime() - LastKill > MultiKillTime) then
							MultiKills = 1
						end
					end
					LastKill = GetTime()
				end
				PVPSound:AddToRecentlyKilledQueue(destGUID)
			 -- PaybackKilling
			elseif (eventType == "SWING_DAMAGE" and FromEnemy and destGUID == UnitGUID("player") and tonumber(swingOverkill) ~= nil and tonumber(swingOverkill) ~= - 1) or ((eventType == "RANGE_DAMAGE" or eventType == "SPELL_DAMAGE" or eventType == "SPELL_PERIODIC_DAMAGE") and FromEnemy and destGUID == UnitGUID("player") and tonumber(spellOverkill) ~= nil and tonumber(spellOverkill) ~= - 1) then
				-- If the killer is not nil
				if sourceName ~= nil then
					-- If the killer is not the player
					if sourceName ~= UnitName("player") then
						KilledMe = sourceName
						if FromEnemyPlayer then
							KilledBy = tostring(sourceName)
						elseif FromEnemyNPC then
							KilledBy = tostring(sourceName.."!")
						else
							KilledBy = tostring(sourceName)
						end
						if PS_PaybackSound == true then
							PVPSound:AddToRetributionQueue(KilledMe)
							if PVPSound:CheckPaybackQueue(KilledMe) == true then
								if PVPSound:CheckRecentlyPaybackQueue("Payback") ~= true then
									PVPSound:TriggerKill("PaybackKill", 1)
								end
								PVPSound:AddToRecentlyPaybackQueue("Payback")
							end
						end
					end
				end
			 -- Environmental Deaths
			elseif eventType == "ENVIRONMENTAL" and destGUID == UnitGUID("player") then
				if sourceName ~= nil or sourceName == nil then
					KilledMe = nil
					KilledBy = nil
				end
			end
		end
	end
end

PVPSoundFrameThree:SetScript("OnEvent", PVPSound.OnEventThree)

function PVPSound:TriggerKill(killtype, streaknumber)
	if killtype and streaknumber and streaknumber ~= 0 then
		if killtype == "Kill" then
			local Decimal = tonumber(string.match(tostring(streaknumber), "%.(%d+)"))
			if Decimal == nil then
				local KillLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."KillDurations")
				if streaknumber <= table.getn(KillLengthTable) then
					-- Kills
					if PS_KillSound == true then
						PVPSound:AddKillToQueue(killtype, KillLengthTable[streaknumber].dir)
					end
					-- Sounds Effects
					if PS_SoundEffect == true then
						if streaknumber < table.getn(KillLengthTable) then
							PVPSound:AddEffectToQueue(killtype, KillLengthTable[streaknumber].dir)
						elseif streaknumber == table.getn(KillLengthTable) then
							PVPSound:AddEffectToQueue("", PS.KillSoundPackDirectory.."\\"..PS_KillSoundPackLanguage.."\\Effects\\KillingMaxRank.mp3")
							PVPSound:AddEffectToQueue(killtype, KillLengthTable[streaknumber].dir)
						end
					end
					-- Kill SCT
					if PS_KillSct == true or PS_MultiKillSct == true or PS_PaybackSct == true then
						PVPSound:AddSctToQueue(killtype, KillLengthTable[streaknumber].dir, KillLengthTable[streaknumber].name, PSSctFrame)
					end
				end
			end
		elseif killtype == "MultiKill" then
			local MultiKillLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."MultiKillDurations")
			if streaknumber <= table.getn(MultiKillLengthTable) then
				-- Multi Kills
				if PS_MultiKillSound == true then
					PVPSound:AddKillToQueue(killtype, MultiKillLengthTable[streaknumber].dir)
				end
				-- Multi Kill Sounds Effects
				if PS_SoundEffect == true then
					if streaknumber < table.getn(MultiKillLengthTable) then
						PVPSound:AddEffectToQueue(killtype, MultiKillLengthTable[streaknumber].dir)
					elseif streaknumber == table.getn(MultiKillLengthTable) then
						PVPSound:AddEffectToQueue("", PS.KillSoundPackDirectory.."\\"..PS_KillSoundPackLanguage.."\\Effects\\MultiKillingMaxRank.mp3")
						PVPSound:AddEffectToQueue(killtype, MultiKillLengthTable[streaknumber].dir)
					end
				end
				-- Multi Kill SCT
				if PS_KillSct == true or PS_MultiKillSct == true or PS_PaybackSct == true then
					PVPSound:AddSctToQueue(killtype, MultiKillLengthTable[streaknumber].dir, MultiKillLengthTable[streaknumber].name, PSSctFrame)
				end
			end
		elseif killtype == "PaybackKill" then
			local PaybackKillLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."PaybackKillDurations")
			-- Payback Kills
			if PS_PaybackSound == true then
				PVPSound:AddKillToQueue(killtype, PaybackKillLengthTable[streaknumber].dir)
			end
			-- Payback Kill Sound Effects
			if PS_SoundEffect == true then
				PVPSound:AddEffectToQueue(killtype, PaybackKillLengthTable[streaknumber].dir)
			end
			-- Payback Kill SCT
			if PS_KillSct == true or PS_MultiKillSct == true or PS_PaybackSct == true then
				PVPSound:AddSctToQueue(killtype, PaybackKillLengthTable[streaknumber].dir, PaybackKillLengthTable[streaknumber].name, PSSctFrame)
			end
		end
	end
end