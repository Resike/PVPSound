--[[
	   _          _     _         _        _           _      _          _
	 _/\\___   _ /\\  _/\\___    /\\__  __/\\___  ___ /\\   _/\\___   __/\\___
	(_   _ _))/ \\ \\(_   _ _)) /    \\(_     _))/  //\ \\ (_      ))(_  ____))
	 /  |))\\ \:'/ // /  |))\\ _\  \_// /  _  \\ \:.\\_\ \\ /  :   \\ /   _ \\
	/:. ___//  \  // /:. ___//// \:.\  /:.(_)) \\ \  :.  ///:. |   ///:. |_\ \\
	\_ \\     (_  _))\_ \\    \\__  /  \  _____//(_   ___))\___|  // \  _____//
	  \//       \//    \//       \\/    \//        \//4.0.0     \//   \//

	PVPSound
	Copyright (c) 2010-2020 Resperger Dániel (Resike)
	E-Mail: reske@gmail.com
	All rights reserved.
	See the accompanying "!Licence.txt" for more information.
	The addon can be found at:
	http://www.curse.com/addons/wow/pvpsound
	http://www.wowinterface.com/downloads/info19569-PVPSound.html
--]]

local addon, ns = ...
local PVPSound = ns.PVPSound
local PVPSoundOptions = ns.PVPSoundOptions
local PS = ns.PS
local L = ns.L



local bit = bit
local ceil = ceil
local floor = floor
local getglobal = getglobal
local pairs = pairs
local print = print
local select = select
local string = string
local table = table
local tonumber = tonumber
local tostring = tostring

local C_AreaPoiInfo = C_AreaPoiInfo
local C_ChatInfo = C_ChatInfo
local C_Map = C_Map
local C_PvP = C_PvP
local C_Timer = C_Timer
local C_UIWidgetManager = C_UIWidgetManager

local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local CreateFrame = CreateFrame
local GetAddOnCPUUsage = GetAddOnCPUUsage
local GetAddOnMemoryUsage = GetAddOnMemoryUsage
local GetBattlefieldFlagPosition = GetBattlefieldFlagPosition
local GetBuildInfo = GetBuildInfo
local GetRealZoneText = GetRealZoneText
local GetSpellInfo = GetSpellInfo
local GetTime = GetTime
local GetWorldPVPAreaInfo = GetWorldPVPAreaInfo
local IsInGroup = IsInGroup
local IsInInstance = IsInInstance
local PlaySoundFile = PlaySoundFile
local SendChatMessage = SendChatMessage
local UnitBuff = UnitBuff
local UnitExists = UnitExists
local UnitFactionGroup = UnitFactionGroup
local UnitGUID = UnitGUID
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsEnemy = UnitIsEnemy
local UnitIsPlayer = UnitIsPlayer
local UnitName = UnitName
local UnitSex = UnitSex
local UpdateAddOnCPUUsage = UpdateAddOnCPUUsage
local UpdateAddOnMemoryUsage = UpdateAddOnMemoryUsage

local CombatLog_Object_IsA = CombatLog_Object_IsA

local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE

--[[local GetBuildInfo = GetBuildInfo
local GetMapLandmarkInfo = GetMapLandmarkInfo
local SendChatMessage = SendChatMessage
local GetTime = GetTime
local UnitGUID = UnitGUID
local UnitName = UnitName]]

--addon modules table
PVPSound.modules = { }


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
		PVPSoundFrame:RegisterEvent("LOADING_SCREEN_DISABLED")
	end
end

local PVPSoundFrameTwo = CreateFrame("Frame", nil)

function PVPSound:OnLoadTwo()
	if PS_EnableAddon == true then
		PVPSoundFrameTwo:RegisterEvent("PLAYER_TARGET_CHANGED")
		PVPSoundFrameTwo:RegisterEvent("UNIT_HEALTH")
		PVPSoundFrameTwo:RegisterEvent("UNIT_MAXHEALTH")
		PVPSoundFrameTwo:RegisterEvent("UPDATE_UI_WIDGET")
		PVPSoundFrameTwo:RegisterEvent("AREA_POIS_UPDATED")
		PVPSoundFrameTwo:RegisterEvent("PVP_MATCH_COMPLETE")
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
	PVPSoundFrameTwo:RegisterEvent("PLAYER_TARGET_CHANGED")
	PVPSoundFrameTwo:RegisterEvent("UNIT_HEALTH")
	PVPSoundFrameTwo:RegisterEvent("UNIT_MAXHEALTH")
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
	PVPSoundFrameTwo:UnregisterEvent("PLAYER_TARGET_CHANGED")
	PVPSoundFrameTwo:UnregisterEvent("UNIT_HEALTH")
	PVPSoundFrameTwo:UnregisterEvent("UNIT_MAXHEALTH")
	PVPSoundFrameThree:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

--addon performanse info
function PVPSound:perfDump()
	UpdateAddOnMemoryUsage()
	UpdateAddOnCPUUsage()
	local mem = GetAddOnMemoryUsage(addon)
	local cpu = GetAddOnCPUUsage(addon)
	print("current memory usege: ", mem)
	print("current CPU usege: ", cpu)
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
local AlreadyPlaySound
local LastScored

-- Battlefields
local TbAttacker
local WgAttacker

-- Zones
local MyZone
local InstanceType
local CurrentInstId
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
local ToEnemyNPC
local FromEnemyNPC
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
		C_ChatInfo.RegisterAddonMessagePrefix("PVPSound")
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
		print("Reset time: ",ResetTime)
		print("Multikill time: ",MultiKillTime)
		print("Payback time: ",PS.PaybackKillTime)
		print("Recently killed penalty time: ",PS.RecentlyKilledTime)
		print("Recently payback penalty time: ",PS.RecentlyPaybackTime)
		print("Rank step for kills: ", RankStep)
end

-- Addon error messages function
function PVPSound:Error(msg)
	if type(msg) ~= "string" then
		msg = tostring(msg)
	end
	print("|cFFff9a00PVPSound ERROR:|r |cFFff8100"..msg.."|r")
end

-- Addon debug messages function and switcher
local debug = true
function PVPSound:Debug(msg)
	if debug == true then
		if type(msg) ~= "string" then
			msg = tostring(msg)
		end
		print("|cFFff9a00PVPSound Debug:|r |cFF7FFF00"..msg.."|r")
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

-- resetting queries
function PVPSound:TimerReset()
	TimerReset = true
end
function PVPSound:KillersReset()
	KilledMe = nil
	KilledBy = nil
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
		if Addon == "PVPSound_test" then
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
		--------------------------------------
		-- modules loading routine
		-- each module must have 2 functions
		-- initialize and unload
		-- these funcs called from event handler of PVPSound frame
		-- each time ZONE_CHANGED_NEW_AREA or PLAYER_ENTERING_WORLD fires
		-- unload function of each "loaded" (loaded parameter setted to true in initialize function) module should be called
		-- it needed to release all events and resourses before initializing new module, and to avoid conflicts like
		-- calling unload function of module right after calling intialize function (such problem occures when unload function called on 
		-- ZONE_CHANGED_NEW_AREA event on API frame and init function called on ZONE_CHANGED_NEW_AREA event in PVPSound frame)
		-- If module don,t have initialize function, it will not be loaded
		-- If module don't have unload function, all events of API frame will automaticlly be unregistered
		-- Also, on each ZONE_CHANGED_NEW_AREA or PLAYER_ENTERING_WORLD event, if module is existed for new zone, PVPSound timer and killing qoueues will be resetted
		--------------------------------------
		if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
			-- on initial login (and when you use portals or smth like this) both events fired, but PLAYER_ENTERING_WORLD fires with wrong zone id (id of parent map)
			-- on TP using both events fired, but PLAYER_ENTERING_WORLD fires with wrong zone id (id of parent map)
			-- on /reload fires only PLAYER_ENTERING_WORLD, but with correct zone id
			
			-- instance id can be used for BGs, but then, we can't use this code open world battlefields as is
			CurrentZoneId = C_Map.GetBestMapForUnit("player")
			InstanceType = (select(2, IsInInstance())) -- check it to aviod uncorrect returm value of GetBestMapForUnit after PLAYER_ENTERING_WORLD event
			CurrentInstId = (select(8, GetInstanceInfo()))
			print(event, CurrentZoneId, CurrentInstId, InstanceType)
			-- Player's Gender
			if UnitSex("player") == 2 then
				MyGender = "Male"
			elseif UnitSex("player") == 3 then
				MyGender = "Female"
			end
			PS.PaybackKillTime = 90

			-- unloading of loaded modules (except the module for zone, where you are)
			if CurrentZoneId then
				PVPSound:Debug("common unloading")
				for _, mod in pairs(PVPSound.modules) do
					if (mod.zoneId ~= CurrentZoneId) and mod.loaded then
						mod:Unload()
						PVPSound:Debug(mod.name.." unloaded")
					end
				end
			else
				PVPSound:Debug("alternative unloading")
				for _, mod in pairs(PVPSound.modules) do
					if (mod.instId ~= CurrentInstId) and mod.loaded then
						mod:Unload()
						PVPSound:Debug(mod.name.." unloaded")
					end
				end
			end
			-- loading BG modules
			-- Some BGs starts in the zone without  areaID (for example winter AB)
			-- for such cases instance ID used
			if CurrentZoneId and PVPSound.modules[CurrentZoneId] and InstanceType == PVPSound.modules[CurrentZoneId].type then
				PVPSound:Debug("common loading")
				PVPSound:TimerReset()
				PVPSound:KillersReset()
				PVPSound.modules[CurrentZoneId]:Initialize()
				PVPSound:Debug(PVPSound.modules[CurrentZoneId].name.." loaded")
			else
				PVPSound:Debug("alternative loading")
				for _, mod in pairs(PVPSound.modules) do
					PVPSound:Debug("try "..mod.name.." instId: "..tostring(mod.instId).." ;cur instanceId: "..(select(8, GetInstanceInfo())))
					if mod.instId == CurrentInstId then
						PVPSound:TimerReset()
						PVPSound:KillersReset()
						mod:Initialize()
						PVPSound:Debug(mod.name.." loaded")
					end
				end
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
	end
end



PVPSoundFrame:SetScript("OnEvent", PVPSound.OnEvent)

function PVPSound:OnEventTwo(event, ...)
	if PS_EnableAddon == true  then
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
	end
end

PVPSoundFrameTwo:SetScript("OnEvent", PVPSound.OnEventTwo)



local PS_COMBATLOG_FILTER_MY_PETS					= bit.bor(COMBATLOG_OBJECT_AFFILIATION_MINE, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_OBJECT, COMBATLOG_OBJECT_TYPE_GUARDIAN, COMBATLOG_OBJECT_TYPE_PET)
local PS_COMBATLOG_FILTER_ENEMY_NPCS				= bit.bor(COMBATLOG_OBJECT_AFFILIATION_MASK, COMBATLOG_OBJECT_REACTION_MASK, COMBATLOG_OBJECT_CONTROL_NPC, COMBATLOG_OBJECT_TYPE_NPC)
local PS_COMBATLOG_FILTER_ENEMY_PLAYERS				= bit.bor(COMBATLOG_OBJECT_AFFILIATION_MASK, COMBATLOG_OBJECT_REACTION_MASK, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PLAYER)
local PS_COMBATLOG_FILTER_ENEMY_PLAYERS_AND_NPCS	= bit.bor(COMBATLOG_OBJECT_AFFILIATION_MASK, COMBATLOG_OBJECT_REACTION_MASK, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_CONTROL_NPC, COMBATLOG_OBJECT_TYPE_NPC)

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
								CurrentStreak = floor(CurrentStreak + 0.5)
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
											if CurrentStreak < table.getn(KillSoundLengthTable) then
												SendChatMessage(Message.." "..KillSoundLengthTable[CurrentStreak].name.."!", "EMOTE")
											elseif CurrentStreak == table.getn(KillSoundLengthTable) then
												SendChatMessage(Message.." "..KillSoundLengthTable[CurrentStreak].name.."!!!", "EMOTE")
											else
												SendChatMessage(Message.." "..KillSoundLengthTable[table.getn(KillSoundLengthTable)].name.."!!!", "EMOTE")
											end
										end
									elseif PS_EmoteMode == false then
										if CurrentStreak > 1 then
											local Message = L["Streak"..CurrentStreak]
											if CurrentStreak > 10 then
												Message = L["Streak10"]
											end
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

function PVPSound:TriggerKill(killType, streakNumber)
	if killType and streakNumber and streakNumber ~= 0 then
		if killType == "Kill" then
			local KillLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."KillDurations")
			if streakNumber <= table.getn(KillLengthTable) then
				-- Kills
				if PS_KillSound == true then
					--See comment in upper function in Kills->Emote section
					if (streakNumber - floor(streakNumber) > 0.5) then
						streakNumber = ceil(streakNumber)
					else
						streakNumber = floor(streakNumber)
					end
					--print(KillLengthTable[streakNumber])
					PVPSound:AddKillToQueue(killType, KillLengthTable[streakNumber].dir)
				end
				-- Sounds Effects
				if PS_SoundEffect == true then
					if streakNumber < table.getn(KillLengthTable) then
						PVPSound:AddEffectToQueue(killType, KillLengthTable[streakNumber].dir)
					elseif streakNumber == table.getn(KillLengthTable) then
						PVPSound:AddEffectToQueue("", PS.KillSoundPackDirectory.."\\"..PS_KillSoundPackLanguage.."\\Effects\\KillingMaxRank.mp3")
						PVPSound:AddEffectToQueue(killType, KillLengthTable[streakNumber].dir)
					end
				end
				-- Kill SCT
				if PS_KillSct == true or PS_MultiKillSct == true or PS_PaybackSct == true then
					PVPSound:AddSctToQueue(killType, KillLengthTable[streakNumber].dir, KillLengthTable[streakNumber].name, PSSctFrame)
				end
			end
		elseif killType == "MultiKill" then
			local MultiKillLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."MultiKillDurations")
			if streakNumber <= table.getn(MultiKillLengthTable) then
				-- Multi Kills
				if PS_MultiKillSound == true then
					PVPSound:AddKillToQueue(killType, MultiKillLengthTable[streakNumber].dir)
				end
				-- Multi Kill Sounds Effects
				if PS_SoundEffect == true then
					if streakNumber < table.getn(MultiKillLengthTable) then
						PVPSound:AddEffectToQueue(killType, MultiKillLengthTable[streakNumber].dir)
					elseif streakNumber == table.getn(MultiKillLengthTable) then
						PVPSound:AddEffectToQueue("", PS.KillSoundPackDirectory.."\\"..PS_KillSoundPackLanguage.."\\Effects\\MultiKillingMaxRank.mp3")
						PVPSound:AddEffectToQueue(killType, MultiKillLengthTable[streakNumber].dir)
					end
				end
				-- Multi Kill SCT
				if PS_KillSct == true or PS_MultiKillSct == true or PS_PaybackSct == true then
					PVPSound:AddSctToQueue(killType, MultiKillLengthTable[streakNumber].dir, MultiKillLengthTable[streakNumber].name, PSSctFrame)
				end
			end
		elseif killType == "PaybackKill" then
			local PaybackKillLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."PaybackKillDurations")
			-- Payback Kills
			if PS_PaybackSound == true then
				PVPSound:AddKillToQueue(killType, PaybackKillLengthTable[streakNumber].dir)
			end
			-- Payback Kill Sound Effects
			if PS_SoundEffect == true then
				PVPSound:AddEffectToQueue(killType, PaybackKillLengthTable[streakNumber].dir)
			end
			-- Payback Kill SCT
			if PS_KillSct == true or PS_MultiKillSct == true or PS_PaybackSct == true then
				PVPSound:AddSctToQueue(killType, PaybackKillLengthTable[streakNumber].dir, PaybackKillLengthTable[streakNumber].name, PSSctFrame)
			end
		end
	end
end
