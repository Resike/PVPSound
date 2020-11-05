local addon, ns = ...
local PVPSound = ns.PVPSound
local PS = ns.PS

local PVPSoundSctEngineFrame = CreateFrame("Frame")
local TimeSinceLastSctUpdate = 0

local PVPSound_SctQueue 						= { }

local PVPSound_NextSctUpdate 					= 0.3200

local string, table, getglobal = string, table, getglobal

local IsAddOnLoaded = IsAddOnLoaded
local ChatTypeInfo = ChatTypeInfo

-- Sct Queue
function PVPSound:AddSctToQueue(killtype, file, message, frame)
	-- This function will add file to the Sct Queue to be shown
	-- If the file could not be found in the sound lengths table then just show it
	-- This is a table of SoundLengths according to the selected SoundPack
	if (PS_KillSoundPackName == "DevilMayCry" or PS_KillSoundPackName == "Dota2" or PS_KillSoundPackName == "Halo4" or PS_KillSoundPackName == "UnrealTournament3" or PS_KillSoundPackName == "Custom") and PS_SctEngine == true then
		if killtype ~= nil and file ~= nil and message ~= nil and frame ~= nil then
			local SctSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack..killtype.."Durations")
			if SctSoundLengthTable ~= nil then
				local SctFileFoundLength
				for i = 1, table.getn(SctSoundLengthTable), 1 do
					if string.upper(SctSoundLengthTable[i].dir) == string.upper(file) then
						SctFileFoundLength = SctSoundLengthTable[i].duration
					end
				end
				if SctFileFoundLength then
					local SctTable = {message = message, frame = frame, length = SctFileFoundLength}
					-- Insert the Sct into the Sct Queue
					table.insert(PVPSound_SctQueue, SctTable)
				else
					-- Not in the sound table so just show it
					PVPSound:AddToSct(message, frame)
				end
			else
				PVPSound:AddToSct(message, frame)
			end
		end
	else
		-- We've got lengths for UnrealTournament3 and Custom SoundPacks only, if that's not selected or SoundEngine is disabled then just show it
		if message ~= nil and frame ~= nil then
			PVPSound:AddToSct(message, frame)
		end
	end

	if #PVPSound_SctQueue > 0 and not PVPSoundSctEngineFrame:GetScript("OnUpdate") then
		PVPSound_NextSctUpdate = 0

		PVPSoundSctEngineFrame:SetScript("OnUpdate", PVPSound.UpdateSctEngine)
	end
end

function PVPSound:AddToSct(message, frame)
	if message == "nil" and frame ~= nil then
		return false
	elseif message ~= nil and frame ~= nil then
		if PS_KillSct == true and PS_MultiKillSct == true and PS_PaybackSct == true then
			PVPSound:TriggerSct(message.."!", frame)
		elseif PS_KillSct == true and PS_MultiKillSct == true and PS_PaybackSct == false then
			local FoundIt = false
			local KillSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."PaybackKillDurations")
			for i = 1, table.getn(KillSoundLengthTable), 1 do
				if message == KillSoundLengthTable[i].name then
					FoundIt = true
				end
			end
			if FoundIt == false then
				PVPSound:TriggerSct(message.."!", frame)
			end
		elseif PS_KillSct == true and PS_MultiKillSct == false and PS_PaybackSct == true then
			local FoundIt = false
			local KillSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."MultiKillDurations")
			for i = 1, table.getn(KillSoundLengthTable), 1 do
				if message == KillSoundLengthTable[i].name then
					FoundIt = true
				end
			end
			if FoundIt == false then
				PVPSound:TriggerSct(message.."!", frame)
			end
		elseif PS_KillSct == false and PS_MultiKillSct == true and PS_PaybackSct == true then
			local FoundIt = false
			local KillSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."KillDurations")
			for i = 1, table.getn(KillSoundLengthTable), 1 do
				if message == KillSoundLengthTable[i].name then
					FoundIt = true
				end
			end
			if FoundIt == false then
				PVPSound:TriggerSct(message.."!", frame)
			end
		elseif PS_KillSct == true and PS_MultiKillSct == false and PS_PaybackSct == false then
			local FoundIt = false
			local KillSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."MultiKillDurations")
			for i = 1, table.getn(KillSoundLengthTable), 1 do
				if message == KillSoundLengthTable[i].name then
					FoundIt = true
				end
			end
			local KillSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."PaybackKillDurations")
			for i = 1, table.getn(KillSoundLengthTable), 1 do
				if message == KillSoundLengthTable[i].name then
					FoundIt = true
				end
			end
			if FoundIt == false then
				PVPSound:TriggerSct(message.."!", frame)
			end
		elseif PS_KillSct == false and PS_MultiKillSct == true and PS_PaybackSct == false then
			local FoundIt = false
			local KillSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."KillDurations")
			for i = 1, table.getn(KillSoundLengthTable), 1 do
				if message == KillSoundLengthTable[i].name then
					FoundIt = true
				end
			end
			local KillSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."PaybackKillDurations")
			for i = 1, table.getn(KillSoundLengthTable), 1 do
				if message == KillSoundLengthTable[i].name then
					FoundIt = true
				end
			end
			if FoundIt == false then
				PVPSound:TriggerSct(message.."!", frame)
			end
		elseif PS_KillSct == false and PS_MultiKillSct == false and PS_PaybackSct == true then
			local FoundIt = false
			local KillSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."KillDurations")
			for i = 1, table.getn(KillSoundLengthTable), 1 do
				if message == KillSoundLengthTable[i].name then
					FoundIt = true
				end
			end
			local KillSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."MultiKillDurations")
			for i = 1, table.getn(KillSoundLengthTable), 1 do
				if message == KillSoundLengthTable[i].name then
					FoundIt = true
				end
			end
			if FoundIt == false then
				PVPSound:TriggerSct(message.."!", frame)
			end
		end
	end
end

function PVPSound:TriggerSct(message, frame)
	-- MSBT
	-- MikSBT.DisplayMessage(message, scrollArea, isSticky, colorR(0-255), colorG(0-255), colorB(0-255), fontSize, fontName, outlineIndex, texturePath)
	if MikSBT then
		MikSBT.DisplayMessage(message, frame, true, 255, 0, 0, nil, nil, nil, nil)
	 -- SCT and SCTD
	 -- Message Frame -- SCT:DisplayMessage(message, color{r = (0.00-10.00), g = (0.00-10.00), b = (0.00-10.00)})
	 -- Frame 1, Frame 2, Frame 3 -- SCT:DisplayText(message, color{r = (0.00-10.00), g = (0.00-10.00), b = (0.00-10.00)}, isCrit, eventtype, frame[(1-3)], anitype, parent, icon)
	elseif SCT then
		if frame == "Message" or frame == "message" or frame == "MESSAGE" or frame == "Frame0" or frame == "Frame 0" or frame == "frame0" or frame == "frame 0" or frame == "FRAME0" or frame == "FRAME 0" or frame == "0" then
			SCT:DisplayMessage(message, {r = 10, g = 0, b = 0})
		elseif frame == "Frame1" or frame == "Frame 1" or frame == "frame1" or frame == "frame 1" or frame == "FRAME1" or frame == "FRAME 1" or frame == "1" then
			SCT:DisplayText(message, {r = 10, g = 0, b = 0}, true, nil, 1, nil, nil, nil)
		elseif frame == "Frame2" or frame == "Frame 2" or frame == "frame2" or frame == "frame 2" or frame == "FRAME2" or frame == "FRAME 2" or frame == "2" then
			SCT:DisplayText(message, {r = 10, g = 0, b = 0}, true, nil, 2, nil, nil, nil)
		elseif frame == "Damage" or frame == "damage" or frame == "DAMAGE" or frame == "Frame3" or frame == "Frame 3" or frame == "frame3" or frame == "frame 3" or frame == "FRAME3" or frame == "FRAME 3" or frame == "3" then
			SCT:DisplayText(message, {r = 10, g = 0, b = 0}, true, nil, 3, nil, nil, nil)
		end
	 -- Parrot
	 -- Parrot:ShowMessage(message, frame, sticky, colorR(0-255), colorG(0-255), colorB(0-255), font, fontsize, outline, icon)
	elseif Parrot then
		Parrot:ShowMessage(message, frame, true, 255, 0, 0, nil, nil, nil, nil)
	 -- xCT
	 -- ct.frames[(1-4)]:AddMessage(message, colorR(0-255), colorG(0-255), colorB(0-255))
	elseif xCT then
		if frame == "Damage" or frame == "damage" or frame == "DAMAGE" or frame == "Frame1" or frame == "Frame 1" or frame == "frame1" or frame == "frame 1" or frame == "FRAME1" or frame == "FRAME 1" or frame == "1" then
			ct.frames[1]:AddMessage(message, 255, 0, 0)
		elseif frame == "Healing" or frame == "healing" or frame == "HEALING" or frame == "Frame2" or frame == "Frame 2" or frame == "frame2" or frame == "frame 2" or frame == "FRAME2" or frame == "FRAME 2" or frame == "2" then
			ct.frames[2]:AddMessage(message, 255, 0, 0)
		elseif frame == "Damage Done" or frame == "damage done" or frame == "DAMAGE DONE" or frame == "Healing Done" or frame == "healing done" or frame == "HEALING DONE" or frame == "Floating Combat Text" or frame == "floating combat text" or frame == "FLOATING COMBAT TEXT" or frame == "Frame3" or frame == "Frame 3" or frame == "frame3" or frame == "frame 3" or frame == "FRAME3" or frame == "FRAME 3" or frame == "3" then
			ct.frames[3]:AddMessage(message, 255, 0, 0)
		elseif frame == "Frame4" or frame == "Frame 4" or frame == "frame4" or frame == "frame 4" or frame == "FRAME4" or frame == "FRAME 4" or frame == "4" then
			ct.frames[4]:AddMessage(message, 255, 0, 0)
		end
	 -- xCT+
	 -- xCT_Plus:AddMessage(frame, message, color{r = (0.00-1.00), g = (0.00-1.00), b = (0.00-1.00)})
	elseif xCT_Plus then
		if frame == "General" or frame == "general" or frame == "GENERAL" then
			xCT_Plus:AddMessage("general", message, {1, 0, 0})
		elseif frame == "Outgoing" or frame == "outgoing" or frame == "OUTGOING" then
			xCT_Plus:AddMessage("outgoing", message, {1, 0, 0})
		elseif frame == "Critical" or frame == "critical" or frame == "CRITICAL" then
			xCT_Plus:AddMessage("critical", message, {1, 0, 0})
		elseif frame == "Damage" or frame == "damage" or frame == "DAMAGE" then
			xCT_Plus:AddMessage("damage", message, {1, 0, 0})
		elseif frame == "Healing" or frame == "healing" or frame == "HEALING" then
			xCT_Plus:AddMessage("healing", message, {1, 0, 0})
		elseif frame == "Power" or frame == "power" or frame == "POWER" then
			xCT_Plus:AddMessage("power", message, {1, 0, 0})
		elseif frame == "Procs" or frame == "procs" or frame == "PROCS" then
			xCT_Plus:AddMessage("procs", message, {1, 0, 0})
		elseif frame == "Loot" or frame == "loot" or frame == "LOOT" then
			xCT_Plus:AddMessage("loot", message, {1, 0, 0})
		end
	 -- Default Blizzard SCT
	 -- CombatText_AddMessage(message, frame, colorR(0.00-1.00), colorG(0.00-1.00), colorB(0.00-1.00))
	elseif IsAddOnLoaded("Blizzard_CombatText") then
		if not COMBAT_TEXT_SCROLL_FUNCTION then
			CombatText_UpdateDisplayedMessages()
		end
		CombatText_AddMessage(message, COMBAT_TEXT_SCROLL_FUNCTION, 1, 0, 0)
	 -- Raid Notice
	 -- RaidNotice_AddMessage(frame, message, color)
	else
		RaidNotice_AddMessage(RaidBossEmoteFrame, message, ChatTypeInfo["RAID_WARNING"])
	end
end

function PVPSound:ClearSctQueue()
	-- This function will clear all the Scts from the Sct Queue
	for i = table.getn(PVPSound_SctQueue), 1, - 1 do
		table.remove(PVPSound_SctQueue, i)
	end

	PVPSoundSctEngineFrame:SetScript("OnUpdate", nil)
end

function PVPSound:PlayNextSct()
	-- This function will play the next Sct in the Sct Queue and return how long that Sct will be played
	-- If there is no Sct in the Sct Queue it will just return 0.3200
	if PVPSound:SctInQueue() then
		local x
		PVPSound:AddToSct(PVPSound_SctQueue[1].message, PVPSound_SctQueue[1].frame)
		x = PVPSound_SctQueue[1].length
		table.remove(PVPSound_SctQueue, 1)
		return x
	else
		return 0.3200
	end
end

function PVPSound:SctInQueue()
	-- This function will return 1 if there is a Sct in the Sct Queue, nil otherwise
	if table.getn(PVPSound_SctQueue) > 0 then
		return 1
	else
		return nil
	end
end

function PVPSound:UpdateSctEngine(elapsed)
	if PS_SctEngine == true then
		TimeSinceLastSctUpdate = TimeSinceLastSctUpdate + elapsed
		while TimeSinceLastSctUpdate > PVPSound_NextSctUpdate do
			TimeSinceLastSctUpdate = TimeSinceLastSctUpdate - PVPSound_NextSctUpdate

			if #PVPSound_SctQueue == 0 then
				PVPSoundSctEngineFrame:SetScript("OnUpdate", nil)
			end

			PVPSound_NextSctUpdate = PVPSound:PlayNextSct()
		end
	end
end

--PVPSoundSctEngineFrame:SetScript("OnUpdate", PVPSound.UpdateSctEngine)
