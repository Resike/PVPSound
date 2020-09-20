﻿--[[
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
		PVPSoundFrame:RegisterEvent("AREA_POIS_UPDATED") 
	end
end

local PVPSoundFrameTwo = CreateFrame("Frame", nil)

function PVPSound:OnLoadTwo()
	if PS_EnableAddon == true then
		PVPSoundFrameTwo:RegisterEvent("PLAYER_TARGET_CHANGED")
	 	PVPSoundFrameTwo:RegisterEvent("UNIT_HEALTH")
		PVPSoundFrameTwo:RegisterEvent("UNIT_MAXHEALTH")
		--PVPSoundFrameTwo:RegisterEvent("UPDATE_WORLD_STATES") --deleted EVENT (bg activity update)
		--PVPSoundFrameTwo:RegisterEvent("WORLD_STATE_UI_TIMER_UPDATE") --deleted EVENT  
		PVPSoundFrameTwo:RegisterEvent("UPDATE_UI_WIDGET")
		PVPSoundFrameTwo:RegisterEvent("AREA_POIS_UPDATED")
		PVPSoundFrameTwo:RegisterEvent("PVP_MATCH_COMPLETE") --experimental
	end
end

local PVPSoundFrameThree = CreateFrame("Frame", nil)

function PVPSound:OnLoadThree()
	if PS_EnableAddon == true then
		PVPSoundFrameThree:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") --have no payload since 8.0.1
	end
end



--not used?
function PVPSound:RegisterEvents()
	PVPSoundFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	PVPSoundFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	PVPSoundFrame:RegisterEvent("PLAYER_DEAD")
	PVPSoundFrame:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
	PVPSoundFrame:RegisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE")
	PVPSoundFrame:RegisterEvent("CHAT_MSG_BG_SYSTEM_HORDE")
	PVPSoundFrame:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	PVPSoundFrame:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	PVPSoundFrame:RegisterEvent("WORLD_MAP_UPDATE") --deleted
	PVPSoundFrameTwo:RegisterEvent("PLAYER_TARGET_CHANGED")
	PVPSoundFrameTwo:RegisterEvent("UNIT_HEALTH")
	PVPSoundFrameTwo:RegisterEvent("UNIT_MAXHEALTH")
	PVPSoundFrameTwo:RegisterEvent("UPDATE_WORLD_STATES") --deleted
	PVPSoundFrameTwo:RegisterEvent("WORLD_STATE_UI_TIMER_UPDATE") --deleted
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
	PVPSoundFrame:UnregisterEvent("WORLD_MAP_UPDATE") --deleted
	PVPSoundFrameTwo:UnregisterEvent("PLAYER_TARGET_CHANGED")
	PVPSoundFrameTwo:UnregisterEvent("UNIT_HEALTH")
	PVPSoundFrameTwo:UnregisterEvent("UNIT_MAXHEALTH")
	PVPSoundFrameTwo:UnregisterEvent("UPDATE_WORLD_STATES") --deleted
	PVPSoundFrameTwo:UnregisterEvent("WORLD_STATE_UI_TIMER_UPDATE") --deleted
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
		C_ChatInfo.RegisterAddonMessagePrefix("PVPSound") --in 8.0.1 changed to C_ChatInfo namespace
	end
	--finish him/her sounds
	if PS_Execute == nil then
		PS_Execute = false
	end
end

function PVPSound:ConfigDump()
		print("Addon cofig:")
		print("Addon language: ", PS_AddonLanguage)
		print("Kill soundpack name: ", PS_KillSoundPackName)
		print("Kill soundpack language: ", PS_KillSoundPackLanguage)
		print("Soundpack name: ", PS_SoundPackName)
		print("Soundpack language: ", PS_SoundPackLanguage)
		print("Mode: ", PS_Mode)
		print("Emote: ",PS_Emote)
		print("Emote mode: ",PS_EmoteMode)
		print("Death message: ",PS_DeathMessage)
		print("Kill sounds: ",PS_KillSound)
		print("MultiKill Sound: ", PS_MultiKillSound)
		print("PetKill: ", PS_PetKill)
		print("PaybackSound: ", PS_PaybackSound)
		print("BattlegroundSound: ", PS_BattlegroundSound)
		print("SoundEffect: ", PS_SoundEffect)
		print("KillSoundEngine: ", PS_KillSoundEngine)
		print("BattlegroundSoundEngine: ", PS_BattlegroundSoundEngine)
		print("Datashare: ", PS_DataShare)
		print("Kill SCT: ", PS_KillSct)
		print("MultiKill SCT: ", PS_MultiKillSct)
		print("Payback SCT: ", PS_PaybackSct)
		print("SCT engine: ", PS_SctEngine)
		print("SCT Frame: ", PSSctFrame)
		print("Hide server name: ", PS_HideServerName)
		print("Sound channel name: ", PS_Channel)
		print("Finishing sounds: ", PS_Execute)
		print("Reset time= ",ResetTime)
		print("Multikill time= ",MultiKillTime)
		print("Payback time= ",PS.PaybackKillTime)	
		print("Recently killed penalty time= ",PS.RecentlyKilledTime)
		print("Recently payback penalty time= ",PS.RecentlyPaybackTime)
		print("Rank step for kills: ", RankStep)
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
		return 5 -- Time Remaining: 5:59-5:00
	elseif id == 4 then
		return 4 -- Time Remaining: 4:59-4:00
	elseif id == 3 then
		return 3 -- Time Remaining: 3:59-3:00
	elseif id == 2 then
		return 2 -- Time Remaining: 2:59-2:00
	elseif id == 1 then
		return 1 -- Time Remaining: 1:59-1:00
	elseif id == 0 then
		return 0 -- Time Remaining: 0:59-0:00
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

-- Arathi Basin
local ABobjectives = {Blacksmith = nil, Farm = nil, GoldMine = nil, LumberMill = nil, Stables = nil}

--[[local function ABget_objective(id)
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
end]]--

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

-- Deepwind Gorge--redesigned in 8.3.0

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

-- Isle of Conquest
local IOCobjectives = {AllianceGateE = nil, AllianceGateW = nil, AllianceGateS = nil, HordeGateE = nil, HordeGateW = nil, HordeGateN = nil, Quarry = nil, Workshop = nil, Hangar = nil, Docks = nil, Refinerie = nil, HordeKeep = nil, AllianceKeep = nil}

--remade it to POI IDs, not texture IDs, because now the position of POI in POI table not permanent
local function IOCget_objective(id)
	if id >= 2361 and id <= 2365 then
		return "Quarry"
	elseif id >= 2345 and id <= 2349 then
		return "Workshop"
	elseif id >= 2350 and id <= 2355 then
		return "Hangar"
	elseif id >= 2356 and id <= 2360 then
		return "Docks"
	elseif id >= 2366 and id <= 2370 then
		return "Refinerie"
	elseif id == 2377 or id == 2379 then
		return "AllianceGateE"
	elseif id == 2380 or id == 2381 then
		return "AllianceGateW"
	elseif id == 2378 or id == 2382 then
		return "AllianceGateS"
	elseif id == 2373 or id == 2374 then
		return "HordeGateE"
	elseif id == 2375 or id == 2376 then
		return "HordeGateW"
	elseif id == 2371 or id == 2372 then
		return "HordeGateN"
	elseif id >= 2388 and id <= 2392 then
		return "HordeKeep"
	elseif id >= 2383 and id <= 2387 then
		return "AllianceKeep"
	else
		return false
	end
end
--at the moment, state checks a texture index, it will be better to replace it by POI id check
local function IOCobj_state(id)
	if id == 11 or id == 18 or id == 136 or id == 141 or id == 146 or id == 151 then
		return 1 -- Alliance Bases
	elseif id == 10 or id == 20 or id == 138 or id == 143 or id == 148 or id == 153 then
		return 2 -- Horde Bases
	elseif id == 9 or id == 17 or id == 137 or id == 142 or id == 147 or id == 152 then
		return 3 -- Alliance trys to capture
	elseif id == 12 or id == 19 or id == 139 or id == 144 or id == 149 or id == 154 then
		return 4 -- Horde trys to capture
	elseif id == 80 then
		return 5 -- Alliance Gate Undamaged
	elseif id == 77 then
		return 6 -- Horde Gate Undamaged
	elseif id == 82 then
		return 7 -- Alliance Gate Destroyed
	elseif id == 79 then
		return 8 -- Horde Gate Destroyed
	else
		return 0
	end
end


-- Eye of the Storm
local EOTSobjectives = {BloodElfTower = nil, DraeneiRuins = nil, FelReaverRuins = nil, MageTower = nil}

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
	if id == 1500 then
		return 1 -- Resources: 1500/1500
	else
		return 2 -- Resources: 0-1499/1500
	end
end

-- Wintergrasp
local WGobjectives = {FlamewatchTower = nil, ShadowsightTower = nil, WintersEdgeTower = nil, WintergraspFortressTowerNE = nil, WintergraspFortressTowerNW = nil, WintergraspFortressTowerSE = nil, WintergraspFortressTowerSW = nil, WintergraspFortress = nil, TowerWalls = nil}

--getobjective were remade. Now it compares POIs ids, not textures
--we have pairs of IDs because BG and battlefield versions have different IDs
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

-- Tol Barad
local TBobjectives = {BaradinHold = nil, IroncladGarrison = nil, WardensVigil = nil, Slagworks = nil, EastSpire = nil, SouthSpire = nil, WestSpire = nil}

local function TBget_objective(id)
	if id == 46 or id == 48 then
		return "BaradinHold"
	elseif id >= 109 and id <= 112 then
		return "IroncladGarrison"
	elseif id >= 209 and id <= 212 then
		return "WardensVigil"
	elseif id >= 327 and id <= 330 then
		return "Slagworks"
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
		return 11 -- Reinforcements: 11
	elseif id == 10 then
		return 10 -- Reinforcements: 10
	elseif id == 6 then
		return 6 -- Reinforcements: 6
	elseif id == 5 then
		return 5 -- Reinforcements: 5
	elseif id == 2 then
		return 2 -- Reinforcements: 2
	elseif id == 1 then
		return 1 -- Reinforcements: 1
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

--SeethingShore objectives
local SeSobjectives = {AllianceScore = nil, HordeScore = nil}


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

--function just to use the same code in two places
local function InitializeBgs(...)
	MyFaction = UnitFactionGroup("player")
	local self=...	
	CurrentZoneId = C_Map.GetBestMapForUnit("player")
	CurrentZoneText = GetRealZoneText()
	InstanceType = (select(2, IsInInstance()))
	IsRated = C_PvP.IsRatedBattleground()
	print("tech info ",CurrentZoneId,CurrentZoneText,InstanceType,IsRated)
	TimerReset = true


	-- Battlegrounds --need to change zone ids--add new bg
	if CurrentZoneId == 1339 and InstanceType == "pvp" then
		MyZone = "Zone_WarsongGulch"--updated
	elseif (CurrentZoneId == 1366 or CurrentZoneId == 837) and InstanceType == "pvp" then --837 is winter AB
		MyZone = "Zone_ArathiBasin"--updated
	elseif CurrentZoneId == 401 and InstanceType == "pvp" then
		MyZone = "Zone_AlteracValley"
	elseif (CurrentZoneId == 112 or CurrentZoneText == L["Eye of the Storm"]) and InstanceType == "pvp" then 
		MyZone = "Zone_EyeoftheStorm"--updated
	elseif CurrentZoneId == 169 and InstanceType == "pvp" then
		MyZone = "Zone_IsleofConquest"--updated
	elseif CurrentZoneId == 206 and InstanceType == "pvp" then
		MyZone = "Zone_TwinPeaks"--updated
	elseif CurrentZoneId == 275 and InstanceType == "pvp" then
		MyZone = "Zone_TheBattleforGilneas"--updated
	elseif CurrentZoneId == 417 and InstanceType == "pvp" then
		MyZone = "Zone_TempleofKotmogu"--updated
	elseif CurrentZoneId == 423 and InstanceType == "pvp" then
		MyZone = "Zone_SilvershardMines"--updated
	elseif CurrentZoneId == 1576 and InstanceType == "pvp" then
		MyZone = "Zone_DeepwindGorge"--updated
	elseif CurrentZoneId == 907 and InstanceType == "pvp" then
		MyZone = "Zone_SeethingShore"--added
	 -- Battlefields
	elseif CurrentZoneId == 123 or ( CurrentZoneId == 1334 and InstanceType == "pvp") then --1334 is BG version of this zone
		MyZone = "Zone_Wintergrasp"--updated
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

	--world state check
	if MyZone == "Zone_WarsongGulch" or MyZone == "Zone_TwinPeaks" or MyZone == "Zone_TolBarad" or MyZone == "Zone_StrandoftheAncients" or MyZone == "Zone_Arenas" or MyZone == "Zone_SeethingShore" then
		
		
		local i --id of timer widget
		if MyZone == "Zone_StrandoftheAncients" then
			i = 7
		elseif MyZone == "Zone_Arenas" then
			if CurrentZoneText == L["Ashamane's Fall"] or CurrentZoneText == L["Blade's Edge Arena"] then
				i = 4
			elseif CurrentZoneText == L["Nagrand Arena"] then
				i = 6
			elseif CurrentZoneText == L["Dalaran Arena"] or CurrentZoneText == L["Ruins of Lordaeron"] or CurrentZoneText == L["The Tiger's Peak"] or CurrentZoneText == L["Tol'viron Arena"] then
				i = 3
			else
				i = 4
			end
		elseif MyZone == "Zone_TolBarad" then
			i = 1
		elseif MyZone == "Zone_WarsongGulch" or MyZone == "Zone_TwinPeaks" then
			i = 6 --updated
		elseif MyZone == "Zone_SeethingShore" then
			i = 1705
		else
			i = 4
		end
		
		if (C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(i)) ~= nil then --world state text
			-- Time Remaining
			local TimeRemainingInit = tonumber(string.match(C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(i).text, "(%d+)"))
			print ("time remaining ",TimeRemainingInit)
			TimeRemainingobjectives.TimeRemaining = nil
			TimeRemainingobjectives.TimeRemaining = TimeRemainingInit
		end
		--world state 
		
		if (C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(2)) ~= nil then
			-- Alliance Score
			local AllianceScoreInit = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(2).leftBarValue
			WSGandTPAobjectives.AllianceScore = nil
			WSGandTPAobjectives.AllianceScore = AllianceScoreInit
			-- Horde Score
			local HordeScoreInit = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(2).rightBarValue
			WSGandTPHobjectives.HordeScore = nil
			WSGandTPHobjectives.HordeScore = HordeScoreInit
			
			self.AllianceFlagPositionX = nil
			self.AllianceFlagPositionY = nil
			self.HordeFlagPositionX = nil
			self.HordeFlagPositionY = nil
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
		local POIs=C_AreaPoiInfo.GetAreaPOIForMap(CurrentZoneId)
		
		local BloodElfTowerInit
		local DraeneiRuinsInit
		local FelReaverRuinsInit
		local MageTowerInit
		
		for i=1,#POIs do
			if EOTSget_objective(POIs[i]) == "BloodElfTower" then
				BloodElfTowerInit=POIs[i]
			elseif EOTSget_objective(POIs[i]) == "DraeneiRuins" then
				DraeneiRuinsInit=POIs[i]
			elseif EOTSget_objective(POIs[i]) == "FelReaverRuins" then
				FelReaverRuinsInit=POIs[i]
			elseif EOTSget_objective(POIs[i]) == "MageTower" then
				MageTowerInit=POIs[i]
			end
		end
			
		EOTSobjectives.BloodElfTower = nil
		EOTSobjectives.DraeneiRuins = nil
		EOTSobjectives.FelReaverRuins = nil
		EOTSobjectives.MageTower = nil
		if BloodElfTowerInit then
			EOTSobjectives.BloodElfTower = BloodElfTowerInit
		end
		if DraeneiRuinsInit then
			EOTSobjectives.DraeneiRuins = DraeneiRuinsInit
		end
		if FelReaverRuinsInit then
			EOTSobjectives.FelReaverRuins = FelReaverRuinsInit
		end
		if MageTowerInit then
			EOTSobjectives.MageTower = MageTowerInit
		end
	end
	if MyZone == "Zone_ArathiBasin" then
		
		local POIs=C_AreaPoiInfo.GetAreaPOIForMap(CurrentZoneId)
		
		local BlacksmithInit 
		local FarmInit
		local GoldMineInit
		local LumberMillInit
		local StablesInit

		if #POIs==5 then
			for i=1,#POIs do 
				if ABget_objective(C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex) == "Blacksmith" then
					BlacksmithInit=C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				elseif ABget_objective(C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex) == "Farm" then
					FarmInit=C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				elseif ABget_objective(C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex) == "GoldMine" then
					GoldMineInit=C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				elseif ABget_objective(C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex) == "LumberMill" then
					LumberMillInit=C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				elseif ABget_objective(C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex) == "Stables" then
					StablesInit=C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				end
			end
		end
		
		ABobjectives.Blacksmith = nil
		ABobjectives.Farm = nil
		ABobjectives.GoldMine = nil
		ABobjectives.LumberMill = nil
		ABobjectives.Stables = nil
		if BlacksmithInit then
			ABobjectives.Blacksmith = BlacksmithInit
		end
		if FarmInit then
			ABobjectives.Farm = FarmInit
		end
		if GoldMineInit then
			ABobjectives.GoldMine = GoldMineInit
		end
		if LumberMillInit then
			ABobjectives.LumberMill = LumberMillInit
		end
		if StablesInit then
			ABobjectives.Stables = StablesInit
		end
		
	end
	if MyZone == "Zone_AlteracValley" then
		local AVandIOCAInit = tonumber(string.match(select(4, GetWorldStateUIInfo(2)), ": (%d+)"))
		local AVandIOCHInit = tonumber(string.match(select(4, GetWorldStateUIInfo(3)), ": (%d+)"))
		local ColdtoothMineInit = select(4, GetMapLandmarkInfo(1))
		local DunBaldarNorthBunkerInit = select(4, GetMapLandmarkInfo(3))
		local DunBaldarSouthBunkerInit = select(4, GetMapLandmarkInfo(4))
		local EastFrostwolfTowerInit = select(4, GetMapLandmarkInfo(5))
		local FrostwolfGraveyardInit = select(4, GetMapLandmarkInfo(6))
		local FrostwolfReliefHutInit = select(4, GetMapLandmarkInfo(8))
		local IcebloodGraveyardInit = select(4, GetMapLandmarkInfo(10))
		local IcebloodTowerInit = select(4, GetMapLandmarkInfo(11))
		local IcewingBunkerInit = select(4, GetMapLandmarkInfo(12))
		local IrondeepMineInit = select(4, GetMapLandmarkInfo(14))
		local SnowfallGraveyardInit = select(4, GetMapLandmarkInfo(15))
		local StonehearthBunkerInit = select(4, GetMapLandmarkInfo(16))
		local StonehearthGraveyardInit = select(4, GetMapLandmarkInfo(17))
		local StormpikeAidStationInit = select(4, GetMapLandmarkInfo(19))
		local StormpikeGraveyardInit = select(4, GetMapLandmarkInfo(20))
		local TowerPointInit = select(4, GetMapLandmarkInfo(21))
		local WestFrostwolfTowerInit = select(4, GetMapLandmarkInfo(22))
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
		if ColdtoothMineInit then
			AVobjectives.ColdtoothMine = ColdtoothMineInit + 100
		end
		if DunBaldarNorthBunkerInit then
			AVobjectives.DunBaldarNorthBunker = DunBaldarNorthBunkerInit + 200
		end
		if DunBaldarSouthBunkerInit then
			AVobjectives.DunBaldarSouthBunker = DunBaldarSouthBunkerInit + 300
		end
		if EastFrostwolfTowerInit then
			AVobjectives.EastFrostwolfTower = EastFrostwolfTowerInit + 400
		end
		if FrostwolfGraveyardInit then
			AVobjectives.FrostwolfGraveyard = FrostwolfGraveyardInit + 500
		end
		if FrostwolfReliefHutInit then
			AVobjectives.FrostwolfReliefHut = FrostwolfReliefHutInit + 600
		end
		if IcebloodGraveyardInit then
			AVobjectives.IcebloodGraveyard = IcebloodGraveyardInit + 700
		end
		if IcebloodTowerInit then
			AVobjectives.IcebloodTower = IcebloodTowerInit + 800
		end
		if IcewingBunkerInit then
			AVobjectives.IcewingBunker = IcewingBunkerInit + 900
		end
		if IrondeepMineInit then
			AVobjectives.IrondeepMine = IrondeepMineInit + 1000
		end
		if SnowfallGraveyardInit then
			AVobjectives.SnowfallGraveyard = SnowfallGraveyardInit + 1100
		end
		if StonehearthBunkerInit then
			AVobjectives.StonehearthBunker = StonehearthBunkerInit + 1200
		end
		if StonehearthGraveyardInit then
			AVobjectives.StonehearthGraveyard = StonehearthGraveyardInit + 1300
		end
		if StormpikeAidStationInit then
			AVobjectives.StormpikeAidStation = StormpikeAidStationInit + 1400
		end
		if StormpikeGraveyardInit then
			AVobjectives.StormpikeGraveyard = StormpikeGraveyardInit + 1500
		end
		if TowerPointInit then
			AVobjectives.TowerPoint = TowerPointInit + 1600
		end
		if WestFrostwolfTowerInit then
			AVobjectives.WestFrostwolfTower = WestFrostwolfTowerInit + 1700
		end
	end
	if MyZone == "Zone_IsleofConquest" then
		
		--IoC Gate initial check
		--checked in init POI loop
		IocAllianceGateDown = false
		IocHordeGateDown = false
		
		local POIs=C_AreaPoiInfo.GetAreaPOIForMap(CurrentZoneId)
		
		local AllianceGateEInit
		local AllianceGateWInit
		local AllianceGateSInit
		local DocksInit
		local HangarInit
		local HordeGateEInit
		local HordeGateWInit
		local HordeGateNInit
		local QuarryInit
		local RefinerieInit
		local WorkshopInit
		local HordeKeepInit
		local AllianceKeepInit
		
		for i = 1, #POIs do
			if (IOCget_objective(POIs[i]) == "AllianceGateE") then
				AllianceGateEInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				if IOCobj_state(AllianceGateEInit) == 7 then
					IocAllianceGateDown = true
				end
			elseif (IOCget_objective(POIs[i]) == "AllianceGateW") then
				AllianceGateWInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				if IOCobj_state(AllianceGateWInit) == 7 then
					IocAllianceGateDown = true
				end
			elseif (IOCget_objective(POIs[i]) == "AllianceGateS") then
				AllianceGateSInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				if IOCobj_state(AllianceGateSInit) == 7 then
					IocAllianceGateDown = true
				end
			elseif (IOCget_objective(POIs[i]) == "HordeGateE") then
				HordeGateEInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				if IOCobj_state(HordeGateEInit) == 8 then
					IocHordeGateDown = true
				end
			elseif (IOCget_objective(POIs[i]) == "HordeGateW") then
				HordeGateWInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				if IOCobj_state(HordeGateWInit) == 8 then
					IocHordeGateDown = true
				end
			elseif (IOCget_objective(POIs[i]) == "HordeGateN") then
				HordeGateNInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				if IOCobj_state(HordeGateNInit) == 8 then
					IocHordeGateDown = true
				end
			elseif (IOCget_objective(POIs[i]) == "Quarry") then
				QuarryInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
			elseif (IOCget_objective(POIs[i]) == "Refinerie") then
				RefinerieInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
			elseif (IOCget_objective(POIs[i]) == "Workshop") then
				WorkshopInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
			elseif (IOCget_objective(POIs[i]) == "Docks") then
				DocksInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
			elseif (IOCget_objective(POIs[i]) == "Hangar") then
				HangarInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
			elseif (IOCget_objective(POIs[i]) == "HordeKeep") then
				HordeTowerInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
			elseif (IOCget_objective(POIs[i]) == "AllianceKeep") then
				AllianceTowerInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
			end
		end

		IOCobjectives.AllianceGateE = nil
		IOCobjectives.AllianceGateW = nil
		IOCobjectives.AllianceGateS = nil
		IOCobjectives.HordeGateE = nil
		IOCobjectives.HordeGateW = nil
		IOCobjectives.HordeGateN = nil
		IOCobjectives.Quarry = nil
		IOCobjectives.Refinerie = nil
		IOCobjectives.Workshop = nil
		IOCobjectives.Docks = nil
		IOCobjectives.Hangar = nil
		IOCobjectives.HordeKeep = nil
		IOCobjectives.AllianceKeep = nil
		
		if AllianceGateEInit then
			IOCobjectives.AllianceGateE = AllianceGateEInit
		end
		if AllianceGateWInit then
			IOCobjectives.AllianceGateW = AllianceGateWInit
		end
		if AllianceGateSInit then
			IOCobjectives.AllianceGateS = AllianceGateSInit
		end
		if HordeGateEInit then
			IOCobjectives.HordeGateE = HordeGateEInit
		end
		if HordeGateWInit then
			IOCobjectives.HordeGateW = HordeGateWInit
		end
		if HordeGateNInit then
			IOCobjectives.HordeGateN = HordeGateNInit
		end
		if QuarryInit then
			IOCobjectives.Quarry = QuarryInit
		end
		if RefinerieInit then
			IOCobjectives.Refinerie = RefinerieInit
		end
		if WorkshopInit then
			IOCobjectives.Workshop = WorkshopInit
		end
		if DocksInit then
			IOCobjectives.Docks = DocksInit
		end
		if HangarInit then
			IOCobjectives.Hangar = HangarInit
		end
		if HordeTowerInit then
			IOCobjectives.HordeKeep = HordeKeepInit
		end
		if AllianceTowerInit then
			IOCobjectives.AllianceKeep = AllianceKeepInit
		end
		
		--reinforcements init
		local AReinforcementsInit
		local HReinforcementsInit
		
		
		AVandIOCAobjectives.AllianceReinforcements = nil
		AVandIOCHobjectives.HordeReinforcements = nil
		
		if C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1685) then
			AReinforcementsInit = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1685).leftBarValue
			HReinforcementsInit = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1685).rightBarValue
		end
		
		if AReinforcementsInit then 
			AVandIOCAobjectives.AllianceReinforcements = AReinforcementsInit
		end
		if HReinforcementsInit then 
			AVandIOCHobjectives.HordeReinforcements = HReinforcementsInit
		end
		
		
	end
	
	if MyZone == "Zone_TheBattleforGilneas" then
	
		local POIs=C_AreaPoiInfo.GetAreaPOIForMap(CurrentZoneId)
		
		local LighthouseInit
		local MinesInit
		local WaterworksInit

		if #POIs==3 then
			LighthouseInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[1]).textureIndex
			MinesInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[3]).textureIndex
			WaterworksInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[2]).textureIndex
		end
		

		TBFGobjectives.Lighthouse = nil
		TBFGobjectives.Mines = nil
		TBFGobjectives.Waterworks = nil
		if LighthouseInit then
			TBFGobjectives.Lighthouse = LighthouseInit + 100
		end
		if MinesInit then
			TBFGobjectives.Mines = MinesInit + 200
		end
		if WaterworksInit then
			TBFGobjectives.Waterworks = WaterworksInit + 300
		end
	end
	
	if MyZone == "Zone_DeepwindGorge" then
		
		local POIs=C_AreaPoiInfo.GetAreaPOIForMap(CurrentZoneId)
		
		local MarketInit
		local FarmInit
		local RuinsInit
		local ShrineInit
		local QuarryInit

		if #POIs==5 then
			for i=1,#POIs do 
				if DGget_objective(C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex) == "Market" then
					MarketInit=C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				elseif DGget_objective(C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex) == "Farm" then
					FarmInit=C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				elseif DGget_objective(C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex) == "Ruins" then
					RuinsInit=C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				elseif DGget_objective(C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex) == "Shrine" then
					ShrineInit=C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				elseif DGget_objective(C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex) == "Quarry" then
					QuarryInit=C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				end
			end
		end
	
		DGobjectives.Market = nil
		DGobjectives.Farm = nil
		DGobjectives.Ruins = nil
		DGobjectives.Shrine = nil
		DGobjectives.Quarry = nil
		
		if MarketInit then
			DGobjectives.Market = MarketInit
		end
		if FarmInit then
			DGobjectives.Farm = FarmInit
		end
		if RuinsInit then
			DGobjectives.Ruins = RuinsInit
		end
		if ShrineInit then
			DGobjectives.Shrine = ShrineInit
		end
		if QuarryInit then
			DGobjectives.Quarry = QuarryInit
		end
	end
	--there is no win message in SM. should be replaced with PVP_MATCH_COMPELTE event
	--if MyZone == "Zone_SilvershardMines" then
	--	if C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1687) then
	--		local HordeScoreInit = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(2).rightBarValue
	--		local AllianceScoreInit = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(2).leftBarValue
	--				
	--		SMWINobjectives.Resources = nil
	--	if HordeScoreInit then
	--		SMWINobjectives.Resources = tonumber(string.match(HordeScoreInit, "(%d+)/"))
	--	end
	--	if AllianceScoreInit then
	--		SMWINobjectives.Resources = tonumber(string.match(AllianceScoreInit, "(%d+)/"))
	--	end
	--end
	if MyZone == "Zone_Wintergrasp" then
		local isActive
		if CurrentZoneId ==123 and (select(5, GetWorldPVPAreaInfo(1))) == 0 then
			isActive = true
		elseif CurrentZoneId ==1334 then
			isActive = true
		else
			isActive = false
		end
				
		print("isActive: ", isActive)
		if isActive == true then
			BgIsOver = false
			local POIs=C_AreaPoiInfo.GetAreaPOIForMap(CurrentZoneId)
			
			local FlamewatchTowerInit
			local ShadowsightTowerInit
			local WintersEdgeTowerInit
			local WintergraspFortressTowerNEInit
			local WintergraspFortressTowerNWInit
			local WintergraspFortressTowerSEInit
			local WintergraspFortressTowerSWInit
			local TowerWallsInit = 0
			local WintergraspFortressInit
			
			for i=1,#POIs do 
				if WGget_objective(POIs[i]) == "FlamewatchTower" then
					FlamewatchTowerInit=C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				elseif WGget_objective(POIs[i]) == "ShadowsightTower" then
					ShadowsightTowerInit=C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				elseif WGget_objective(POIs[i]) == "WintersEdgeTower" then
					WintersEdgeTowerInit=C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				elseif WGget_objective(POIs[i]) == "WintergraspFortressTowerNE" then
					WintergraspFortressTowerNEInit=C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				elseif WGget_objective(POIs[i]) == "WintergraspFortressTowerNW" then
					WintergraspFortressTowerNWInit=C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				elseif WGget_objective(POIs[i]) == "WintergraspFortressTowerSE" then
					WintergraspFortressTowerSEInit=C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				elseif WGget_objective(POIs[i]) == "WintergraspFortressTowerSW" then
					WintergraspFortressTowerSWInit=C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				elseif WGget_objective(POIs[i]) == "TowerWalls" then
					if WGobj_state(C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex) == 9 then
						TowerWallsInit = TowerWallsInit + 1
					end
				elseif WGget_objective(POIs[i]) == "WintergraspFortress" then
					WintergraspFortressInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
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
	end
	if MyZone == "Zone_TolBarad" then
		local isActive = (select(5, GetWorldPVPAreaInfo(2)))
		if isActive == 0 then
			BgIsOver = false
		end
		--[[local j, k, l, m, n, o
		if (select(5, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(3)))), 1, 4)) == 0.73 and (select(6, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(6, GetMapLandmarkInfo(3)))), 1, 4)) == 0.33 and (select(5, GetMapLandmarkInfo(7))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(7)))), 1, 4)) == 0.52 and (select(6, GetMapLandmarkInfo(7))) ~= nil and tonumber(string.sub(tostring((select(6, GetMapLandmarkInfo(7)))), 1, 4)) == 0.78 then
			j = 4
			k = 5
			l = 8
			m = 2
			n = 6
			o = 9
		elseif (select(5, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(3)))), 1, 4)) == 0.73 and (select(6, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(6, GetMapLandmarkInfo(3)))), 1, 4)) == 0.33 then
			j = 4
			k = 5
			l = 7
			m = 2
			n = 6
			o = 8
		elseif (select(5, GetMapLandmarkInfo(6))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(6)))), 1, 4)) == 0.52 and (select(6, GetMapLandmarkInfo(6))) ~= nil and tonumber(string.sub(tostring((select(6, GetMapLandmarkInfo(6)))), 1, 4)) == 0.78 then
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
		end]]
		local BaradinHoldInit = (select(4, GetMapLandmarkInfo(GetNumMapLandmarks())))
		local IroncladGarrisonInit = (select(4, GetMapLandmarkInfo(1)))
		local WardensVigilInit = (select(4, GetMapLandmarkInfo(2)))
		local SlagworksInit = (select(4, GetMapLandmarkInfo(3)))
		local EastSpireInit = (select(4, GetMapLandmarkInfo(4)))
		local SouthSpireInit = (select(4, GetMapLandmarkInfo(5)))
		local WestSpireInit = (select(4, GetMapLandmarkInfo(6)))
		TBobjectives.BaradinHold = BaradinHoldInit
		if IroncladGarrisonInit then
			TBobjectives.IroncladGarrison = IroncladGarrisonInit + 100
		end
		if WardensVigilInit then
			TBobjectives.WardensVigil = WardensVigilInit + 200
		end
		if SlagworksInit then
			TBobjectives.Slagworks = SlagworksInit + 300
		end
		if EastSpireInit then
			TBobjectives.EastSpire = EastSpireInit + 400
		end
		if SouthSpireInit then
			TBobjectives.SouthSpire = SouthSpireInit + 500
		end
		if WestSpireInit then
			TBobjectives.WestSpire = WestSpireInit + 600
		end
	end
	
	if MyZone == "Zone_SeethingShore" then	
		if (C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1688)) ~= nil then
			-- Alliance Score
			local AllianceScoreInit = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1688).leftBarValue
			SeSobjectives.AllianceScore = nil
			SeSobjectives.AllianceScore = AllianceScoreInit
			-- Horde Score
			local HordeScoreInit = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1688).rightBarValue
			SeSobjectives.HordeScore = nil
			SeSobjectives.HordeScore = HordeScoreInit
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
			PVPSoundOptions:OptionsAddonIsLoaded() --see this later
			-- Addon loaded message
			--print("|cFF50C0FFPVPSound |cFFFFA500"..GetAddOnMetadata("PVPSound", "Version").."|cFF50C0FF loaded.|r")
		end
	end

	if PS_EnableAddon == true then
		if event == "PLAYER_ENTERING_WORLD" then --event fires evry time, loading screen appears
			TimerReset = true
			InitializeBgs(self)
			print(event, " my zone is ", MyZone)
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
						if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance() then --channel choose
							if InstanceType == "pvp" or InstanceType == "arena" or InstanceType == "raid" or InstanceType == "party" or InstanceType == nil then
								C_ChatInfo.SendAddonMessage("PVPSound", Message..":"..GotKilledBy, Channel)
							end
						else
							C_ChatInfo.SendAddonMessage("PVPSound", Message..":"..GotKilledBy, "RAID")
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
						print("|cFFFF4500"..L["You got killed by"].." "..GotKilledBy.."!|r")
					end
					GotKilledBy = nil
				end
				KilledBy = nil
			end
			TimerReset = true
		end

		if PS_BattlegroundSound == true then --only for BG and arena 
			if event == "ZONE_CHANGED_NEW_AREA" then --repeat things we do on player entering world
				BgIsOver = false
				InitializeBgs(self)
				print(event, " my zone is ", MyZone)
				
				-- Battleground PlaySounds
				if MyZone == "Zone_WarsongGulch" or MyZone == "Zone_EyeoftheStorm" or MyZone == "Zone_ArathiBasin" or MyZone == "Zone_AlteracValley" or MyZone == "Zone_IsleofConquest" or MyZone == "Zone_StrandoftheAncients" or MyZone == "Zone_TwinPeaks" or MyZone == "Zone_TheBattleforGilneas" or MyZone == "Zone_TempleofKotmogu" or MyZone == "Zone_SilvershardMines" or MyZone == "Zone_DeepwindGorge" or MyZone == "Zone_SeethingShore" then
					--print("announcement")
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
				 -- Wintergrasp PlaySounds --Wintergasp and Ashran are now also BGs
				elseif MyZone == "Zone_Wintergrasp" then
					TimerReset = true
					KilledMe = nil
					KilledBy = nil
					local isActive
					if CurrentZoneId ==123 and (select(5, GetWorldPVPAreaInfo(1))) == 0 then
						isActive = true
					elseif CurrentZoneId ==1334 then
						isActive = true
					else
						isActive = false
					end
					
					if isActive == true then
						--check texture for west fortress workshop
						--if it's blue - alliance defended
						--else - horde
						--2150 - fortress in BF version, 6074 - in BG version
						local textureIndex
						if CurrentZoneId ==123 then
							textureIndex = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,2150).textureIndex
						else
							textureIndex = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,6074).textureIndex
						end
						if textureIndex then
							if textureIndex == 68 then
								WgAttacker = "Alliance"
							elseif textureIndex == 71 then
								WgAttacker = "Horde"
							end
						end
						print("attacker=",WgAttacker," faction", MyFaction)
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
					local isActive = (select(5, GetWorldPVPAreaInfo(2)))
					if isActive == 0 then
						local textureIndex = (select(4, GetMapLandmarkInfo(GetNumMapLandmarks())))
						if textureIndex then
							if textureIndex == 48 then
								TbAttacker = "Alliance"
							elseif textureIndex == 46 then
								TbAttacker = "Horde"
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
				if MyZone == "Zone_WarsongGulch" or MyZone == "Zone_EyeoftheStorm" or MyZone == "Zone_ArathiBasin" or MyZone == "Zone_AlteracValley" or MyZone == "Zone_IsleofConquest" or MyZone == "Zone_StrandoftheAncients" or MyZone == "Zone_TwinPeaks" or MyZone == "Zone_TheBattleforGilneas" or MyZone == "Zone_TempleofKotmogu" or MyZone == "Zone_SilvershardMines" or MyZone == "Zone_DeepwindGorge" or "Zone_SeethingShore" then
					if (string.find(EventMessage, L["Alliance wins"]) and BgIsOver ~= true) or (string.find(EventMessage, L["Alliance wins secondary"]) and BgIsOver ~= true) or (string.find(EventMessage, L["The Alliance is victorious"]) and BgIsOver ~= true) then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceWins.mp3")
						BgIsOver = true
						PVPSound:ClearPaybackQueue()
						PVPSound:ClearRetributionQueue()
					elseif (string.find(EventMessage, L["Horde wins"]) and BgIsOver ~= true) or (string.find(EventMessage, L["Horde wins secondary"]) and BgIsOver ~= true) or (string.find(EventMessage, L["The Horde is victorious"]) and BgIsOver ~= true) then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeWins.mp3")
						BgIsOver = true
						PVPSound:ClearPaybackQueue()
						PVPSound:ClearRetributionQueue()
					end
				end
			end
			--parsing pvp info from chat
			if event == "CHAT_MSG_BG_SYSTEM_NEUTRAL" then
				local EventMessage = select(1, ...)
				
				-- Tie Game
				if string.find(EventMessage, L["Tie game"]) and BgIsOver ~= true then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HumiliatingDefeat.mp3")
					BgIsOver = true
					PVPSound:ClearPaybackQueue()
					PVPSound:ClearRetributionQueue()
				 -- Warsong Gulch and Twin Peaks Vulnerable
				elseif MyZone == "Zone_WarsongGulch" or MyZone == "Zone_TwinPeaks" then
					
					if string.find(EventMessage, L["Alliance Flag has returned"]) then --i don't see such messages
						
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Flag_Returned.mp3")

						self.AllianceFlagPositionX = nil
						self.AllianceFlagPositionY = nil
					elseif string.find(EventMessage, L["Horde Flag has returned"]) then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Flag_Returned.mp3")

						self.HordeFlagPositionX = nil
						self.HordeFlagPositionY = nil
					elseif string.find(EventMessage, L["vulnerable"]) then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\Overtime.mp3")
					end
				 -- Strand of the Ancients Attack and Defend Sounds
				elseif MyZone == "Zone_StrandoftheAncients" then
					if string.find(EventMessage, L["The battle for the Strand of the Ancients begins in 1 minute"]) or string.find(EventMessage, L["Round 2 of the Battle for the Strand of the Ancients begins in 1 minute"]) then
						for i = 7, 7, 1 do
							local textureIndex = select(4, GetMapLandmarkInfo(i))
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
					elseif string.find(EventMessage, L["Round 2 begins in 30 seconds"]) then
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
						if string.find(EventMessage, L["pickedA"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\Horde_Flag_Taken.mp3")

							--[[if C_PvP.IsInBrawl() then
								return
							end]]

							self.AllianceFlagPositionX = nil
							self.AllianceFlagPositionY = nil
						elseif string.find(EventMessage, L["dropped"]) then
							
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Flag_Dropped.mp3")

							--[[if C_PvP.IsInBrawl() then
								return
							end]]

							for i = 1, 2 do
								local type = select(3, GetBattlefieldFlagPosition(i))

								--if type == "AllianceFlag" then
								if type == 137218 then
									self.AllianceFlagPositionX = select(1, GetBattlefieldFlagPosition(i))
									self.AllianceFlagPositionY = select(2, GetBattlefieldFlagPosition(i))

									break
								end
							end
						elseif string.find(EventMessage, L["returned"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Flag_Returned.mp3")

							--[[if C_PvP.IsInBrawl() then
								return
							end]]

							-- Subzone
							--local CurrentSubZoneText = GetSubZoneText()
							
							-- Horde Flag Taken
							local HordeFlagStatus
							--1 - Alliance flag dropped when Horde flag was taken
							--0 - Alliance flag dropped when Horde flag was not taken
							if (C_UIWidgetManager.GetDoubleStateIconRowVisualizationInfo(1640)) then --1640 is a icon row widget with A & H flag icons
								HordeFlagStatus = C_UIWidgetManager.GetDoubleStateIconRowVisualizationInfo(1640).leftIcons[1].iconState
								print(HordeFlagStatus)
							end
							

							if C_PvP.IsInBrawl() then --need to change for only one type of brawls (wsg scramble)
								--C_PvP.GetActiveBrawlInfo()
								HordeFlagStatus = 0
							end
							--flag save in a flag enemies flagroom
							
							if MyFaction == "Alliance" and HordeFlagStatus == 0 then
								if MyZone == "Zone_WarsongGulch" then
									if self.AllianceFlagPositionX and self.AllianceFlagPositionX ~= 0 and self.AllianceFlagPositionX ~= "" then --subzone check was removed
										if self.AllianceFlagPositionY and self.AllianceFlagPositionY ~= 0 and self.AllianceFlagPositionY ~= "" then
											if self.AllianceFlagPositionX >= 0.503 and self.AllianceFlagPositionX <= 0.545 then
												if self.AllianceFlagPositionY >= 0.884 and self.AllianceFlagPositionY <= 0.934 then
													PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\LastSecondSave.mp3")
												end
											end
										end
									end
								elseif MyZone == "Zone_TwinPeaks" then
									if self.AllianceFlagPositionX and self.AllianceFlagPositionX ~= 0 and self.AllianceFlagPositionX ~= "" then
										if self.AllianceFlagPositionY and self.AllianceFlagPositionY ~= 0 and self.AllianceFlagPositionY ~= "" then
											if self.AllianceFlagPositionX >= 0.452 and self.AllianceFlagPositionX <= 0.509 then
												if self.AllianceFlagPositionY >= 0.795 and self.AllianceFlagPositionY <= 0.908 then
													PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\LastSecondSave.mp3")
												end
											end
										end
									end
								end
							end

							self.AllianceFlagPositionX = nil
							self.AllianceFlagPositionY = nil
						end
					 -- Horde
					elseif event == "CHAT_MSG_BG_SYSTEM_HORDE" then
						if string.find(EventMessage, L["picked"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Flag_Taken.mp3")

							--[[if C_PvP.IsInBrawl() then
								return
							end]]

							self.HordeFlagPositionX = nil
							self.HordeFlagPositionY = nil
						elseif string.find(EventMessage, L["dropped"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Flag_Dropped.mp3")

							--[[if C_PvP.IsInBrawl() then
								return
							end]]

							for i = 1, 2 do
								local type = select(3, GetBattlefieldFlagPosition(i))
								--print("type ",type)
								--if type == "HordeFlag" then
								if type == 137200 then
									self.HordeFlagPositionX = select(1, GetBattlefieldFlagPosition(i))
									self.HordeFlagPositionY = select(2, GetBattlefieldFlagPosition(i))
									--print("HFdropped ",self.HordeFlagPositionX,self.HordeFlagPositionY)
									break
								end
							end
						elseif string.find(EventMessage, L["returned"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Flag_Returned.mp3")

							--[[if C_PvP.IsInBrawl() then
								return
							end]]

							-- Zone
							--local CurrentSubZoneText = GetSubZoneText()
							-- Alliance Flag Taken
							local AllianceFlagStatus
							--1 - Alliance flag dropped when Horde flag was taken
							--0 - Alliance flag dropped when Horde flag was not taken
							if (C_UIWidgetManager.GetDoubleStateIconRowVisualizationInfo(1640)) then --1640 is a icon row widget with A & H flag icons
								AllianceFlagStatus = C_UIWidgetManager.GetDoubleStateIconRowVisualizationInfo(1640).rightIcons[1].iconState
								print(AllianceFlagStatus)
							end

							if C_PvP.IsInBrawl() then
								--C_PvP.GetActiveBrawlInfo()
								AllianceFlagStatus = 0
							end
							
							
							--print(self.HordeFlagPositionX,self.HordeFlagPositionY)
							
							if MyFaction == "Horde" and AllianceFlagStatus == 0 then
								if MyZone == "Zone_WarsongGulch" then
									if self.HordeFlagPositionX and self.HordeFlagPositionX ~= 0 and self.HordeFlagPositionX ~= "" then
										if self.HordeFlagPositionY and self.HordeFlagPositionY ~= 0 and self.HordeFlagPositionY ~= "" then
											
											if self.HordeFlagPositionX >= 0.473 and self.HordeFlagPositionX <= 0.516 then
												if self.HordeFlagPositionY >= 0.111 and self.HordeFlagPositionY <= 0.176 then
													PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\LastSecondSave.mp3")
												end
											end
										end
									end
								elseif MyZone == "Zone_TwinPeaks" then
									if self.HordeFlagPositionX and self.HordeFlagPositionX ~= 0 and self.HordeFlagPositionX ~= "" then
										if self.HordeFlagPositionY and self.HordeFlagPositionY ~= 0 and self.HordeFlagPositionY ~= "" then
											
											if self.HordeFlagPositionX >= 0.563 and self.HordeFlagPositionX <= 0.640 then
												if self.HordeFlagPositionY >= 0.124 and self.HordeFlagPositionY <= 0.252 then
													PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\LastSecondSave.mp3")
												end
											end
										end
									end
								end
							end

							self.HordeFlagPositionX = nil
							self.HordeFlagPositionY = nil
						end
					end
				 -- Deepwind Gorge --there is no carts in DG anymoer
				--[=[elseif MyZone == "Zone_DeepwindGorge" then 
					-- Alliance
					if event == "CHAT_MSG_BG_SYSTEM_ALLIANCE" then
						if string.find(EventMessage, L["taken the"]) or string.find(EventMessage, L["picked"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Flag_Taken.mp3")

							self.AllianceCartPositionX = nil
							self.AllianceCartPositionY = nil
						elseif string.find(EventMessage, L["dropped"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Flag_Dropped.mp3")

							for i = 1, 2 do
								local type = select(3, GetBattlefieldFlagPosition(i))

								if type == "AllianceFlag" then
									self.AllianceCartPositionX = select(1, GetBattlefieldFlagPosition(i))
									self.AllianceCartPositionY = select(2, GetBattlefieldFlagPosition(i))

									break
								end
							end
						elseif string.find(EventMessage, L["returned"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Flag_Returned.mp3")
							if MyFaction == "Alliance" then
								if self.AllianceCartPositionX and self.AllianceCartPositionX ~= 0 and self.AllianceCartPositionX ~= "" then
									if self.AllianceCartPositionY and self.AllianceCartPositionY ~= 0 and self.AllianceCartPositionY ~= "" then
										if self.AllianceCartPositionX >= 0.000 and self.AllianceCartPositionX <= 0.277 then
											if self.AllianceCartPositionY >= 0.272 and self.AllianceCartPositionY <= 0.465 then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\LastSecondSave.mp3")
											end
										end
									end
								end
							end

							self.AllianceCartPositionX = nil
							self.AllianceCartPositionY = nil
						elseif string.find(EventMessage, L["captured"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
						--[[elseif string.find(EventMessage, L["The Alliance is near victory"]) then
							PlaySoundFile("Sound\\Spells\\PVPWarningAlliance.mp3", "Sound")]]
						end
					-- Horde
					elseif event == "CHAT_MSG_BG_SYSTEM_HORDE" then
						if string.find(EventMessage, L["taken the"]) or string.find(EventMessage, L["picked"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Flag_Taken.mp3")

							self.HordeCartPositionX = nil
							self.HordeCartPositionY = nil
						elseif string.find(EventMessage, L["dropped"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Flag_Dropped.mp3")

							for i = 1, 2 do
								local type = select(3, GetBattlefieldFlagPosition(i))

								if type == "HordeFlag" then
									self.HordeCartPositionX = select(1, GetBattlefieldFlagPosition(i))
									self.HordeCartPositionY = select(2, GetBattlefieldFlagPosition(i))

									break
								end
							end
						elseif string.find(EventMessage, L["returned"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Flag_Returned.mp3")
							if MyFaction == "Horde" then
								if self.HordeCartPositionX and self.HordeCartPositionX ~= 0 and self.HordeCartPositionX ~= "" then
									if self.HordeCartPositionY and self.HordeCartPositionY ~= 0 and self.HordeCartPositionY ~= "" then
										if self.HordeCartPositionX >= 0.772 and self.HordeCartPositionX <= 1.000 then
											if self.HordeCartPositionY >= 0.523 and self.HordeCartPositionY <= 0.712 then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\LastSecondSave.mp3")
											end
										end
									end
								end
							end

							self.HordeCartPositionX = nil
							self.HordeCartPositionY = nil
						elseif string.find(EventMessage, L["captured"]) then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
						--[[elseif string.find(EventMessage, L["The Horde is near victory"]) then
							PlaySoundFile("Sound\\Spells\\PVPWarningHorde.mp3", "Sound")]]
						end
					end]=]--
				 -- Eye of the Storm Score Sounds
				elseif MyZone == "Zone_EyeoftheStorm" then
				
					if string.find(EventMessage, L["Alliance have captured"]) or string.find(EventMessage, L["Horde have captured"]) then
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

			elseif event == "CHAT_MSG_MONSTER_YELL" then --do we really need this event?
				-- Alterac Valley
				if MyZone == "Zone_AlteracValley" then
					-- Bunkers --each bunker checked by it's coords--may be there are easier ways to do it
					-- Dun Baldar North Bunker
					for i = 1, GetNumMapLandmarks(), 1 do
						local textureIndex = select(4, GetMapLandmarkInfo(i))
						local x
						if (select(5, GetMapLandmarkInfo(i))) then --x coord of poi
							x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						end
						local y
						if (select(6, GetMapLandmarkInfo(i))) then --y coord of poi
							y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
						end
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
						local textureIndex = select(4, GetMapLandmarkInfo(i))
						local x
						if (select(5, GetMapLandmarkInfo(i))) then
							x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						end
						local y
						if (select(6, GetMapLandmarkInfo(i))) then
							y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
						end
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
						local textureIndex = select(4, GetMapLandmarkInfo(i))
						local x
						if (select(5, GetMapLandmarkInfo(i))) then
							x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						end
						local y
						if (select(6, GetMapLandmarkInfo(i))) then
							y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
						end
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
						local textureIndex = select(4, GetMapLandmarkInfo(i))
						local x
						if (select(5, GetMapLandmarkInfo(i))) then
							x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						end
						local y
						if (select(6, GetMapLandmarkInfo(i))) then
							y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
						end
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
						local textureIndex = select(4, GetMapLandmarkInfo(i))
						local x
						if (select(5, GetMapLandmarkInfo(i))) then
							x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						end
						local y
						if (select(6, GetMapLandmarkInfo(i))) then
							y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
						end
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
						local textureIndex = select(4, GetMapLandmarkInfo(i))
						local x
						if (select(5, GetMapLandmarkInfo(i))) then
							x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						end
						local y
						if (select(6, GetMapLandmarkInfo(i))) then
							y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
						end
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
						local textureIndex = select(4, GetMapLandmarkInfo(i))
						local x
						if (select(5, GetMapLandmarkInfo(i))) then
							x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						end
						local y
						if (select(6, GetMapLandmarkInfo(i))) then
							y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
						end
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
						local textureIndex = select(4, GetMapLandmarkInfo(i))
						local x
						if (select(5, GetMapLandmarkInfo(i))) then
							x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						end
						local y
						if (select(6, GetMapLandmarkInfo(i))) then
							y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
						end
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
						local textureIndex = select(4, GetMapLandmarkInfo(i))
						local x
						if (select(5, GetMapLandmarkInfo(i))) then
							x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						end
						local y
						if (select(6, GetMapLandmarkInfo(i))) then
							y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
						end
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
						local textureIndex = select(4, GetMapLandmarkInfo(i))
						local x
						if (select(5, GetMapLandmarkInfo(i))) then
							x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						end
						local y
						if (select(6, GetMapLandmarkInfo(i))) then
							y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
						end
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
						local textureIndex = select(4, GetMapLandmarkInfo(i))
						local x
						if (select(5, GetMapLandmarkInfo(i))) then
							x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						end
						local y
						if (select(6, GetMapLandmarkInfo(i))) then
							y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
						end
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
						local textureIndex = select(4, GetMapLandmarkInfo(i))
						local x
						if (select(5, GetMapLandmarkInfo(i))) then
							x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						end
						local y
						if (select(6, GetMapLandmarkInfo(i))) then
							y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
						end
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
						local textureIndex = select(4, GetMapLandmarkInfo(i))
						local x
						if (select(5, GetMapLandmarkInfo(i))) then
							x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						end
						local y
						if (select(6, GetMapLandmarkInfo(i))) then
							y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
						end
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
						local textureIndex = select(4, GetMapLandmarkInfo(i))
						local x
						if (select(5, GetMapLandmarkInfo(i))) then
							x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						end
						local y
						if (select(6, GetMapLandmarkInfo(i))) then
							y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
						end
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
						local textureIndex = select(4, GetMapLandmarkInfo(i))
						local x
						if (select(5, GetMapLandmarkInfo(i))) then
							x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						end
						local y
						if (select(6, GetMapLandmarkInfo(i))) then
							y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
						end
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
						local textureIndex = select(4, GetMapLandmarkInfo(i))
						local x
						if (select(5, GetMapLandmarkInfo(i))) then
							x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						end
						local y
						if (select(6, GetMapLandmarkInfo(i))) then
							y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
						end
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
						local textureIndex = select(4, GetMapLandmarkInfo(i))
						local x
						if (select(5, GetMapLandmarkInfo(i))) then
							x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						end
						local y
						if (select(6, GetMapLandmarkInfo(i))) then
							y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
						end
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
					if string.find(EventMessage, L["Alliance has defended"]) and BgIsOver ~= true then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceWins.mp3")
						BgIsOver = true
					elseif string.find(EventMessage, L["Horde has defended"]) and BgIsOver ~= true then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeWins.mp3")
						BgIsOver = true
					end
					local isActive
					if CurrentZoneId ==123 and (select(5, GetWorldPVPAreaInfo(1))) == 0 then
						isActive = true
					elseif CurrentZoneId ==1334 then
						isActive = true
					else
						isActive = false
					end
					if isActive == true then
						BgIsOver = false
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
				 -- Tol Barad
				elseif MyZone == "Zone_TolBarad" then
					local isActive = (select(5, GetWorldPVPAreaInfo(2)))
					if isActive == 0 then
						-- WinSounds
						for i = 1, 1, 1 do
							local textureIndex = select(4, GetMapLandmarkInfo(GetNumMapLandmarks()))
							local x
							if (select(5, GetMapLandmarkInfo(i))) then
								x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
							end
							local y
							if (select(6, GetMapLandmarkInfo(i))) then
								y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
							end
							local nextBattle = tostring(string.match(select(4, GetWorldStateUIInfo(7)), ": (.+)"))
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
					if string.find(EventMessage, L["Round 1"]) then
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
					elseif string.find(EventMessage, L["Let the battle for the Strand of the Ancients begin"]) then
						SotaRoundOver = false
					end
				 -- Eye of the Storm RBG Score Sounds
				elseif MyZone == "Zone_EyeoftheStorm" then
					if string.find(EventMessage, L["Alliance have captured"]) then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
					elseif string.find(EventMessage, L["Horde have captured"]) then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
					end
				 -- Temple of Kotmogu Orb Reset
				elseif MyZone == "Zone_TempleofKotmogu" then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\OrbReturned.mp3")
				 -- Silvershard Mines Cart Arrived
				elseif MyZone == "Zone_SilvershardMines" then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\MineShaftOpening.mp3")
				end

			elseif event == "AREA_POIS_UPDATED" then

				 -- Isle of Conquest
				if MyZone == "Zone_IsleofConquest" then
					-- Gates
					-- Alliance Gate (East)
					local POIs = C_AreaPoiInfo.GetAreaPOIForMap(CurrentZoneId)
					
					for i = 1, #POIs do
						local type = IOCget_objective(POIs[i])
						--print(type) 
						if type then
							local textureIndex = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
							if textureIndex then
								if IOCobj_state(IOCobjectives[type]) == 5 and IOCobj_state(textureIndex) == 7 then
									if IocAllianceGateDown ~= true then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\BarricadeDestroyedBlueCoreIsVulnerable.mp3")
										IocAllianceGateDown = true
									end
								elseif IOCobj_state(IOCobjectives[type]) == 6 and IOCobj_state(textureIndex) == 8 then
									if IocHordeGateDown ~= true then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\BarricadeDestroyedRedCoreIsVulnerable.mp3")
										IocHordeGateDown = true
									end
								elseif IOCobj_state(IOCobjectives[type]) == 3 and IOCobj_state(textureIndex) == 1 then
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
	
				 -- Eye of the Storm
				elseif MyZone == "Zone_EyeoftheStorm" then
					--print("ent")
					local POIs=C_AreaPoiInfo.GetAreaPOIForMap(CurrentZoneId)
									
					for i=1,#POIs do
						print("ent ", POIs[i])
						local textureIndex = POIs[i]
											
						if textureIndex then
							--if x == 0.5 and y == 0.5 then
								local faketextureIndex = textureIndex
								local type = EOTSget_objective(faketextureIndex)
								if type then
									if EOTSobj_state(EOTSobjectives[type]) == 1 and EOTSobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										local ABases = 0
										for k, v in pairs(EOTSobjectives) do
											if k ~= type and EOTSobj_state(v)==2 then
												ABases=ABases+1
											end
										end
										print ("abase ", ABases)	
										if ABases == 3 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end
									elseif EOTSobj_state(EOTSobjectives[type]) == 1 and EOTSobj_state(faketextureIndex) == 3 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										local HBases = 0
										for k, v in pairs(EOTSobjectives) do
											if k ~= type and EOTSobj_state(v)==3 then
												HBases=HBases+1
											end
										end
										print ("hbase ", HBases)
										if HBases==3 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeDominating.mp3")
											end
										end

									elseif EOTSobj_state(EOTSobjectives[type]) == 2 and EOTSobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 3 and EOTSobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 2 and EOTSobj_state(faketextureIndex) == 5 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
									elseif EOTSobj_state(EOTSobjectives[type]) == 3 and EOTSobj_state(faketextureIndex) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")

									end
									EOTSobjectives[type] = faketextureIndex
								end
							--end
						end
					end
					
				 -- Wintergrasp
				elseif MyZone == "Zone_Wintergrasp" then
					local isActive
					if CurrentZoneId ==123 and (select(5, GetWorldPVPAreaInfo(1))) == 0 then
						isActive = true
					elseif CurrentZoneId ==1334 then
						isActive = true
					else
						isActive = false
					end
					
					if isActive == true then
						-- Towers
						local POIs=C_AreaPoiInfo.GetAreaPOIForMap(CurrentZoneId)
						-- Flamewatch Tower
						local destroyedWalls = 0
						for i = 0, #POIs do 
							local type = WGget_objective(POIs[i])
							if type and type ~= "TowerWalls" then
								local faketextureIndex = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
								
								if WGobj_state(WGobjectives[type]) == 1 and WGobj_state(faketextureIndex) == 3 then
									PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_HeavilyDamaged.mp3")
								elseif WGobj_state(WGobjectives[type]) == 3 and WGobj_state(faketextureIndex) == 4 then
									PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Destroyed.mp3")
								elseif WGobj_state(WGobjectives[type]) == 2 and WGobj_state(faketextureIndex) == 5 then
									PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_HeavilyDamaged.mp3")
								elseif WGobj_state(WGobjectives[type]) == 5 and WGobj_state(faketextureIndex) == 6 then
									PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Destroyed.mp3")
								elseif WGobj_state(WGobjectives[type]) == 10 and WGobj_state(faketextureIndex) == 11 then --this only used for battlefield version
									if WgAttacker == "Horde" then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeWins.mp3")
									else
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceWins.mp3")
									end
									BgIsOver = true
								end
								WGobjectives[type] = faketextureIndex
							elseif type == "TowerWalls" then
								if WGobj_state(C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex) == 9 then
									destroyedWalls = destroyedWalls + 1
								end
							end
						end
						
						if destroyedWalls > WGobjectives.TowerWalls then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\BarricadeDestroyed.mp3")
							WGobjectives.TowerWalls = destroyedWalls
						end
						
					end
				 -- Tol Barad
				elseif MyZone == "Zone_TolBarad" then
					-- Baradin Hold
					for i = GetNumMapLandmarks(), GetNumMapLandmarks(), 1 do
						local textureIndex = select(4, GetMapLandmarkInfo(i))
						local x
						if (select(5, GetMapLandmarkInfo(i))) then
							x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
						end
						local y
						if (select(6, GetMapLandmarkInfo(i))) then
							y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
						end
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
					local isActive = (select(5, GetWorldPVPAreaInfo(2)))
					if isActive == 0 then
						BgIsOver = false
						--[[local j, k, l, m, n, o
						if (select(5, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(3)))), 1, 4)) == 0.73 and (select(6, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(6, GetMapLandmarkInfo(3)))), 1, 4)) == 0.33 and (select(5, GetMapLandmarkInfo(7))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(7)))), 1, 4)) == 0.52 and (select(6, GetMapLandmarkInfo(7))) ~= nil and tonumber(string.sub(tostring((select(6, GetMapLandmarkInfo(7)))), 1, 4)) == 0.78 then
							j = 4
							k = 5
							l = 8
							m = 2
							n = 6
							o = 9
						elseif (select(5, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(3)))), 1, 4)) == 0.73 and (select(6, GetMapLandmarkInfo(3))) ~= nil and tonumber(string.sub(tostring((select(6, GetMapLandmarkInfo(3)))), 1, 4)) == 0.33 then
							j = 4
							k = 5
							l = 7
							m = 2
							n = 6
							o = 8
						elseif (select(5, GetMapLandmarkInfo(6))) ~= nil and tonumber(string.sub(tostring((select(5, GetMapLandmarkInfo(6)))), 1, 4)) == 0.52 and (select(6, GetMapLandmarkInfo(6))) ~= nil and tonumber(string.sub(tostring((select(6, GetMapLandmarkInfo(6)))), 1, 4)) == 0.78 then
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
						end]]
						-- Bases
						-- Ironclad Garrison
						for i = 1, 1, 1 do
							local textureIndex = select(4, GetMapLandmarkInfo(i))
							local x
							if (select(5, GetMapLandmarkInfo(i))) then
								x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
							end
							local y
							if (select(6, GetMapLandmarkInfo(i))) then
								y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
							end
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
						-- Warden's Vigil
						for i = 2, 2, 1 do
							local textureIndex = select(4, GetMapLandmarkInfo(i))
							local x
							if (select(5, GetMapLandmarkInfo(i))) then
								x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
							end
							local y
							if (select(6, GetMapLandmarkInfo(i))) then
								y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
							end
							if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
								if x == 0.34 and y == 0.69 then
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
						-- Slagworks
						for i = 3, 3, 1 do
							local textureIndex = select(4, GetMapLandmarkInfo(i))
							local x
							if (select(5, GetMapLandmarkInfo(i))) then
								x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
							end
							local y
							if (select(6, GetMapLandmarkInfo(i))) then
								y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
							end
							if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
								if x == 0.65 and y == 0.65 then
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
						-- West Spire
						for i = 4, 4, 1 do
							local textureIndex = select(4, GetMapLandmarkInfo(i))
							local x
							if (select(5, GetMapLandmarkInfo(i))) then
								x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
							end
							local y
							if (select(6, GetMapLandmarkInfo(i))) then
								y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
							end
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
						-- East Spire
						for i = 5, 5, 1 do
							local textureIndex = select(4, GetMapLandmarkInfo(i))
							local x
							if (select(5, GetMapLandmarkInfo(i))) then
								x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
							end
							local y
							if (select(6, GetMapLandmarkInfo(i))) then
								y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
							end
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
						for i = 6, 6, 1 do
							local textureIndex = select(4, GetMapLandmarkInfo(i))
							local x
							if (select(5, GetMapLandmarkInfo(i))) then
								x = tonumber(string.sub(tostring(select(5, GetMapLandmarkInfo(i))), 1, 4))
							end
							local y
							if (select(6, GetMapLandmarkInfo(i))) then
								y = tonumber(string.sub(tostring(select(6, GetMapLandmarkInfo(i))), 1, 4))
							end
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
					end
				end
			end
		end
	end
end 


PVPSoundFrame:SetScript("OnEvent", PVPSound.OnEvent)

function PVPSound:OnEventTwo(event, ...)
	if PS_EnableAddon == true  then
	--
	--execute sounds can not be places in ideology of kill or bg sounds
	--because it is more about an dueling announcement
	--so it can not be placed in any sound engine queues
	--so i just play the sound file without a queues
	
		if (event == "PLAYER_TARGET_CHANGED" or event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH") and PS_Execute == true then
			local isEnemy = UnitIsEnemy("target","player")

			if UnitExists("target") and isEnemy == true and UnitIsDeadOrGhost("target") == false then

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
					if UnitIsPlayer("target") == true then
						local type = TargetHealthGetObjective(TargetHealthPercent)
						if type then
							if TargetHealthState(TargetHealthObjectives[type]) == 1 and TargetHealthState(TargetHealthPercent) == 2 then
								if TargetGender == "Male" or TargetGender == "Unknown" then
									--PVPSound:AddKillToQueue("Execute", PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\Execute\\FinishHim.mp3")
									PlaySoundFile("Interface\\Addons\\PVPSound\\Sounds\\MortalKombat\\Eng\\Execute\\FinishHim.mp3", PS_Channel)
								elseif TargetGender == "Female" then
									--PVPSound:AddKillToQueue("Execute", PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\Execute\\FinishHer.mp3")
									PlaySoundFile("Interface\\Addons\\PVPSound\\Sounds\\MortalKombat\\Eng\\Execute\\FinishHer.mp3", PS_Channel)
								end
							end
							TargetHealthObjectives[type] = TargetHealthPercent
						end
					end
				elseif PS_Mode == "PVE" then
					if UnitIsPlayer("target") == false then
						local type = TargetHealthGetObjective(TargetHealthPercent)
						if type then
							if TargetHealthState(TargetHealthObjectives[type]) == 1 and TargetHealthState(TargetHealthPercent) == 2 then
								if TargetGender == "Male" or TargetGender == "Unknown" then
									--PVPSound:AddKillToQueue("Execute", PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\Execute\\FinishHim.mp3")
									PlaySoundFile("Interface\\Addons\\PVPSound\\Sounds\\MortalKombat\\Eng\\Execute\\FinishHim.mp3", PS_Channel)
								elseif TargetGender == "Female" then
									--PVPSound:AddKillToQueue("Execute", PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\Execute\\FinishHer.mp3")
									PlaySoundFile("Interface\\Addons\\PVPSound\\Sounds\\MortalKombat\\Eng\\Execute\\FinishHer.mp3", PS_Channel)
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
								--PVPSound:AddKillToQueue("Execute", PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\Execute\\FinishHim.mp3")
								PlaySoundFile("Interface\\Addons\\PVPSound\\Sounds\\MortalKombat\\Eng\\Execute\\FinishHim.mp3", PS_Channel)
							elseif TargetGender == "Female" then
								--PVPSound:AddKillToQueue("Execute", PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\Execute\\FinishHer.mp3")
								PlaySoundFile("Interface\\Addons\\PVPSound\\Sounds\\MortalKombat\\Eng\\Execute\\FinishHer.mp3", PS_Channel)
							end
						end
						TargetHealthObjectives[type] = TargetHealthPercent
					end
				end
			end
		end

		if PS_BattlegroundSound == true then
			if event == "UPDATE_UI_WIDGET" then
				info=...
				--for k,v in pairs(info) do
				--	print(k,v)
				--end	
				
				-- Time Reamining
				if MyZone == "Zone_WarsongGulch" or MyZone == "Zone_TwinPeaks" or MyZone == "Zone_TolBarad" or MyZone == "Zone_StrandoftheAncients" or MyZone == "Zone_Arenas" or MyZone == "Zone_SeethingShore" then --timers does not work
					if BgIsOver ~= true then
						local i
						if MyZone == "Zone_StrandoftheAncients" then
							i = 7
						elseif MyZone == "Zone_Arenas" then
							if CurrentZoneText == L["Ashamane's Fall"] or CurrentZoneText == L["Blade's Edge Arena"] then
								i = 4
							elseif CurrentZoneText == L["Nagrand Arena"] then
								i = 6
							elseif CurrentZoneText == L["Dalaran Arena"] or CurrentZoneText == L["Ruins of Lordaeron"] or CurrentZoneText == L["The Tiger's Peak"] or CurrentZoneText == L["Tol'viron Arena"] then
								i = 3
							else
								i = 4
							end
						elseif MyZone == "Zone_TolBarad" then
							i = 1
						elseif MyZone == "Zone_WarsongGulch" or MyZone == "Zone_TwinPeaks" then
							i = 6 --updated
						elseif MyZone == "Zone_SeethingShore" then
							i = 1705
						else
							i = 4
						end
						
						if (C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(i)) then
							-- Time Remaining
							local TimeRemaining = tonumber(string.match(C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(i).text, "(%d+)"))
							print("time rem ",TimeRemaining)
							if TimeRemaining then
								local type = TimeRemainingget_objective(TimeRemaining)
								if type then
									if TimeRemainingobj_state(TimeRemainingobjectives[type]) == 5 and TimeRemainingobj_state(TimeRemaining) == 4 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\FiveMinutesRemain.mp3")
									elseif TimeRemainingobj_state(TimeRemainingobjectives[type]) == 3 and TimeRemainingobj_state(TimeRemaining) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\ThreeMinutesRemain.mp3")
									elseif TimeRemainingobj_state(TimeRemainingobjectives[type]) == 2 and TimeRemainingobj_state(TimeRemaining) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\TwoMinutesRemain.mp3")
									elseif TimeRemainingobj_state(TimeRemainingobjectives[type]) == 1 and TimeRemainingobj_state(TimeRemaining) == 0 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\OneMinutesRemain.mp3")
									end
									TimeRemainingobjectives[type] = TimeRemaining
								end
							end
						end
					end
				 -- Alterac Valley and Isle of Conquest Kill Countdown
				elseif MyZone == "Zone_AlteracValley" or MyZone == "Zone_IsleofConquest" then
					-- Alliance Reinforcements
					
					if (C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1685)) then
						local faketextureIndex = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1685).leftBarValue
						local type = AVandIOCAget_objective(faketextureIndex)
						if type then
							if AVandIOCAobj_state(AVandIOCAobjectives[type]) == 11 and AVandIOCAobj_state(faketextureIndex) == 10 then
								PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\TenKillsRemain.mp3")
							elseif AVandIOCAobj_state(AVandIOCAobjectives[type]) == 6 and AVandIOCAobj_state(faketextureIndex) == 5 then
								PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\FiveKillsRemain.mp3")
							elseif AVandIOCAobj_state(AVandIOCAobjectives[type]) == 2 and AVandIOCAobj_state(faketextureIndex) == 1 then
								PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\OneKillRemains.mp3")
							end
							AVandIOCAobjectives[type] = faketextureIndex
						end
					-- Horde Reinforcements
						faketextureIndex = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1685).rightBarValue
						type = AVandIOCAget_objective(faketextureIndex)
						if type then
							if AVandIOCHobj_state(AVandIOCHobjectives[type]) == 11 and AVandIOCHobj_state(faketextureIndex) == 10 then
								PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\TenKillsRemain.mp3")
							elseif AVandIOCHobj_state(AVandIOCHobjectives[type]) == 6 and AVandIOCHobj_state(faketextureIndex) == 5 then
								PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\FiveKillsRemain.mp3")
							elseif AVandIOCHobj_state(AVandIOCHobjectives[type]) == 2 and AVandIOCHobj_state(faketextureIndex) == 1 then
								PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\OneKillRemains.mp3")
							end
							AVandIOCHobjectives[type] = faketextureInde
						end
					end
				end
			--elseif event == "UPDATE_UI_WIDGET" then
				
				if MyZone == "Zone_WarsongGulch" or MyZone == "Zone_TwinPeaks" or MyZone == "Zone_TolBarad" or MyZone == "Zone_StrandoftheAncients" then
					
					if (C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(2)) then
						-- Alliance Score
						local AllianceScore = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(2).leftBarValue
						-- Horde Score
						local HordeScore = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(2).rightBarValue
						-- Alliance
						print("scores ",AllianceScore,HordeScore)
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
				
				if MyZone == "Zone_SeethingShore" then
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
				
			elseif event == "AREA_POIS_UPDATED" then
				 -- Arathi Basin
				if MyZone == "Zone_ArathiBasin" then
				
					
					local POIs=C_AreaPoiInfo.GetAreaPOIForMap(CurrentZoneId)
					
					for i=1,#POIs do
						local textureIndex = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
						--local x
						--local y

					
						
						if textureIndex then
							
							--if x == 0.38 and y == 0.27 then
								
								local faketextureIndex = textureIndex-- + 500
								local type = ABget_objective(faketextureIndex)
								if type then
									if ABobj_state(ABobjectives[type]) == 3 and ABobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										local ABases = 0
										for k, v in pairs(ABobjectives) do
											if k ~= type and ABobj_state(v)==1 then
												ABases=ABases+1
											end
										end
										print ("abase ", ABases)	
										if ABases == 4 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end						
																				
									elseif ABobj_state(ABobjectives[type]) == 4 and ABobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										local HBases = 0
										for k, v in pairs(ABobjectives) do
											if k ~= type and ABobj_state(v)==2 then
												HBases=HBases+1
											end
										end
										print ("hbase ", HBases)	
										if HBases == 4 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end	
									elseif ABobj_state(ABobjectives[type]) == 4 and ABobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										local ABases = 0
										for k, v in pairs(ABobjectives) do
											if k ~= type and ABobj_state(v)==1 then
												ABases=ABases+1
											end
										end
										print ("abase ", ABases)	
										if ABases == 4 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end	
									elseif ABobj_state(ABobjectives[type]) == 3 and ABobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										local HBases = 0
										for k, v in pairs(ABobjectives) do
											if k ~= type and ABobj_state(v)==2 then
												HBases=HBases+1
											end
										end
										print ("hbase ", HBases)	
										if HBases == 4 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
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
							--end
						end
					end
						
				
					
				 -- The Battle for Gilneas
				elseif MyZone == "Zone_TheBattleforGilneas" then
					-- Mines
					local POIs=C_AreaPoiInfo.GetAreaPOIForMap(CurrentZoneId)
					
					for i = 3, 3, 1 do
						
						local textureIndex
						local x
						local y
						
						if (C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i])) then
							textureIndex = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
							x = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).position.x
							y = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).position.y
						end
						
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							--if x == 0.63 and y == 0.41 then
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
							--end
						end
					end
					-- Waterworks
					for i = 2, 2, 1 do
						local textureIndex
						local x
						local y
						
						if (C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i])) then
							textureIndex = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
							x = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).position.x
							y = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).position.y
						end
						
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							--if x == 0.61 and y == 0.71 then
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
							--end
						end
					end
					-- Lighthouse
					for i = 1, 1, 1 do
						local textureIndex
						local x
						local y
						
						if (C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i])) then
							textureIndex = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
							x = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).position.x
							y = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).position.y
						end
						
						if textureIndex and x and y and textureIndex ~= 0 and x ~= 0 and y ~= 0 then
							--if x == 0.35 and y == 0.62 then
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
							--end
						end
					end
				 -- Deepwind Gorge
				elseif MyZone == "Zone_DeepwindGorge" then
					
					
					local POIs=C_AreaPoiInfo.GetAreaPOIForMap(CurrentZoneId)
					
					for i=1,#POIs do
						local textureIndex = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
						--local x
						--local y

					
						
						if textureIndex then
							
							--if x == 0.38 and y == 0.27 then
								
								local faketextureIndex = textureIndex
								local type = DGget_objective(faketextureIndex)
								if type then
									if DGobj_state(DGobjectives[type]) == 3 and DGobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										local ABases = 0
										for k, v in pairs(DGobjectives) do
											if k ~= type and DGobj_state(v)==1 then
												ABases=ABases+1
											end
										end
										print ("abase ", ABases)	
										if ABases == 4 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end						
																				
									elseif DGobj_state(DGobjectives[type]) == 4 and DGobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										local HBases = 0
										for k, v in pairs(DGobjectives) do
											if k ~= type and DGobj_state(v)==2 then
												HBases=HBases+1
											end
										end
										print ("hbase ", HBases)	
										if HBases == 4 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end	
									elseif DGobj_state(DGobjectives[type]) == 4 and DGobj_state(faketextureIndex) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
										-- Alliance Dominating
										local ABases = 0
										for k, v in pairs(DGobjectives) do
											if k ~= type and DGobj_state(v)==1 then
												ABases=ABases+1
											end
										end
										print ("abase ", ABases)	
										if ABases == 4 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
											end
										end	
									elseif DGobj_state(DGobjectives[type]) == 3 and DGobj_state(faketextureIndex) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
										-- Horde Dominating
										local HBases = 0
										for k, v in pairs(DGobjectives) do
											if k ~= type and DGobj_state(v)==2 then
												HBases=HBases+1
											end
										end
										print ("hbase ", HBases)	
										if HBases == 4 then
											if PS_BattlegroundSoundEngine == true then
												PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceDominating.mp3")
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
							--end
						end
					end					

				end
			elseif event == "PVP_MATCH_COMPLETE" then
				if MyZone == "Zone_SilvershardMines" or MyZone == "Zone_Wintergrasp" then 
					--for Wintergasp it only works in BG version, for BF version there is old methdos
					local winner=...
				 	if winner == 0 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeWins.mp3")
					else 
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceWins.mp3")
					end
					BgIsOver = true
					PVPSound:ClearPaybackQueue()
					PVPSound:ClearRetributionQueue()
				end
				

			end
		end
	end
end

PVPSoundFrameTwo:SetScript("OnEvent", PVPSound.OnEventTwo)



local floor=math.floor
local ceil=math.ceil

function PVPSound:OnEventThree(event, ...)
	if PS_EnableAddon == true then
		if event == "COMBAT_LOG_EVENT_UNFILTERED" then --no longer have payload
			local _, eventType, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, swingOverkill, spellOverkill
			if WowBuildInfo >= 40200 then
				_, eventType, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, _, swingOverkill, _, _, spellOverkill = CombatLogGetCurrentEventInfo()
			elseif WowBuildInfo >= 40100 then
				_, eventType, _, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, _, swingOverkill, _, _, spellOverkill = CombatLogGetCurrentEventInfo()
			--add classic build
			else
				_, eventType, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, _, swingOverkill, _, _, spellOverkill = CombatLogGetCurrentEventInfo()
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
			
			--check killing source (player, mele pet or range pet)
			if (eventType == "PARTY_KILL" and sourceGUID == UnitGUID("player") and ToEnemy) 
				or ((eventType == "SWING_DAMAGE" and destGUID ~= UnitGUID("player") and FromMyPets and ToEnemy and tonumber(swingOverkill) ~= nil and tonumber(swingOverkill) ~= - 1) and PS_PetKill == true) 
				or (((eventType == "RANGE_DAMAGE" or eventType == "SPELL_DAMAGE" or eventType == "SPELL_PERIODIC_DAMAGE") and destGUID ~= UnitGUID("player") and FromMyPets and ToEnemy and tonumber(spellOverkill) ~= nil and tonumber(spellOverkill) ~= - 1) and PS_PetKill == true) then
				
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
									local Message = L["Streak1Male"]
									SendChatMessage(Message.." "..KillSoundLengthTable[CurrentStreak].name.."!", "EMOTE")
								elseif MyGender == "Female" then
									local Message = L["Streak1Female"]
									SendChatMessage(Message.." "..KillSoundLengthTable[CurrentStreak].name.."!", "EMOTE")
								end
							elseif PS_EmoteMode == false then
								if MyGender == "Male" then
									local Message = L["Streak1Male"]
									print("|cFFFFFF00"..sourceName.." "..Message.." "..KillSoundLengthTable[CurrentStreak].name.."!".."|r")
								elseif MyGender == "Female" then
									local Message = L["Streak1Female"]
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
						if (GetTime() - LastKill <= PS.KillTime) then --rank update condition 
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
											local Message = L["Streak"..CurrentStreak]
											if CurrentStreak > 10 then
												Message = L["Streak10"]
											end
											local Decimal = tonumber(string.match(tostring(CurrentStreak), "%.(%d+)"))
											if Decimal == nil then
												--if rankstep!=1, here can be a situation, when decimals is nil, but CurrentStreak is not an integer. It can be smth like .000...001 or
												--.999...9. In this situation an error "attempt to index field '?' (a nil value" occured
												--to avoid this error we should round our namber
												--The same situation in TriggerKill function
												if (CurrentStreak-floor(CurrentStreak) >0.5) then
													CurrentStreak=ceil(CurrentStreak)
												else 
													CurrentStreak=floor(CurrentStreak)
												end
												
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
											local Message = L["Streak"..CurrentStreak]
											if CurrentStreak > 10 then
												Message = L["Streak10"]
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
						--See comment in upper function in Kills->Emote section
						if (streaknumber-floor(streaknumber)>0.5) then
							streaknumber=ceil(streaknumber)
						else
							streaknumber=floor(streaknumber)
						end
						--print(KillLengthTable[streaknumber])
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