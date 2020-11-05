local addon, ns = ...
local PVPSound = ns.PVPSound
local PS = ns.PS

local PVPSoundSoundEngineFrame = CreateFrame("Frame")
local TimeSinceLastUpdate = 0

local PVPSoundKillSoundEngineFrame = CreateFrame("Frame")
local TimeSinceLastKillUpdate = 0

local PVPSoundEffectSoundEngineFrame = CreateFrame("Frame")
local TimeSinceLastEffectUpdate = 0

local PVPSound_SoundQueue 						= { }
local PVPSound_KillSoundQueue 					= { }
local PVPSound_SoundEffectQueue 				= { }

local PVPSound_NextUpdate 						= 0.3100
local PVPSound_NextKillUpdate					= 0.3000
local PVPSound_NextEffectUpdate					= 0.3000

local _G, string, table = _G, string, table

local PlaySoundFile = PlaySoundFile

-- Sound Queue
function PVPSound:AddToQueue(file)
	-- This function will add file to the Sound Queue to be played
	-- If the sound could not be found in the sound lengths table then just play it
	-- This is a table of soundlengths according to the selected SoundPack
	if (PS_SoundPackName == "UnrealTournament3" or PS_SoundPackName == "Custom") and PS_BattlegroundSoundEngine == true then
		if file ~= nil then
			local SoundLengthTable = _G["PVPSound_"..PS.SoundPack.."Durations"]
			if SoundLengthTable ~= nil then
				local FileFoundLength
				-- Is there .mp3 at the end?
				--print(string.find(string.lower(file), ".mp3", string.len(file) - 4), file)
				if (not string.find(string.lower(file), ".mp3", string.len(file) - 4)) then
					-- If not then add it
					file = file..".mp3"
				end
				for i = 1, table.getn(SoundLengthTable) do
					if string.upper(SoundLengthTable[i].dir) == string.upper(file) then
						FileFoundLength = SoundLengthTable[i].duration
					end
				end
				if FileFoundLength then
					local Table = {dir = file, length = FileFoundLength}
					-- Insert the sound into the Sound Queue
					table.insert(PVPSound_SoundQueue, Table)
				else
					-- Not in the sound table so just play it
					PlaySoundFile(file, PS_Channel)
				end
			else
				PlaySoundFile(file, PS_Channel)
			end
		end
	else
		-- We've got lengths for the supported SoundPacks only, if that's not selected or SoundEngine is disabled then just play it
		if file ~= nil then
			PlaySoundFile(file, PS_Channel)
		end
	end

	if #PVPSound_SoundQueue > 0 and not PVPSoundSoundEngineFrame:GetScript("OnUpdate") then
		PVPSound_NextUpdate = 0

		PVPSoundSoundEngineFrame:SetScript("OnUpdate", PVPSound.UpdateSoundEngine)
	end
end

function PVPSound:ClearSoundQueue()
	-- This function will clear all the sounds from the Sound Queue
	for i = table.getn(PVPSound_SoundQueue), 1, - 1 do
		table.remove(PVPSound_SoundQueue, i)
	end

	PVPSoundSoundEngineFrame:SetScript("OnUpdate", nil)
end

function PVPSound:PlayNextSound()
	-- This function will play the next sound in the Sound Queue and return how long that sound will be played
	-- If there is no sound in the Sound Queue it will just return 0.3100
	if PVPSound:SoundInQueue() then
		local x
		PlaySoundFile(PVPSound_SoundQueue[1].dir, PS_Channel)
		x = PVPSound_SoundQueue[1].length
		table.remove(PVPSound_SoundQueue, 1)

		return x
	else
		return 0.3100
	end
end

function PVPSound:SoundInQueue()
	-- This function will return 1 if there is a sound in the Sound Queue, nil otherwise
	if table.getn(PVPSound_SoundQueue) > 0 then
		return 1
	else
		return nil
	end
end

function PVPSound:UpdateSoundEngine(elapsed)
	if PS_EnableAddon == true then
		if PS_BattlegroundSoundEngine == true then
			TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed
			while TimeSinceLastUpdate > PVPSound_NextUpdate do
				TimeSinceLastUpdate = TimeSinceLastUpdate - PVPSound_NextUpdate

				if #PVPSound_SoundQueue == 0 then
					PVPSoundSoundEngineFrame:SetScript("OnUpdate", nil)
				end

				PVPSound_NextUpdate = PVPSound:PlayNextSound()
			end
		end
	end
end

--PVPSoundSoundEngineFrame:SetScript("OnUpdate", PVPSound.UpdateSoundEngine)

-- Kill Sound Queue
function PVPSound:AddKillToQueue(killtype, file)
	-- This function will add file to the Kill Sound Queue to be played
	-- If the sound could not be found in the sound lengths table then just play it
	-- This is a table of soundlengths according to the selected SoundPack
	if (PS_KillSoundPackName == "DevilMayCry" or PS_KillSoundPackName == "Dota2" or PS_KillSoundPackName == "Halo4" or PS_KillSoundPackName == "UnrealTournament3" or PS_KillSoundPackName == "Custom") and PS_KillSoundEngine == true then
		if killtype ~= nil and file ~= nil then
			local KillSoundLengthTable = _G["PVPSound_"..PS.KillSoundPack..killtype.."Durations"]
			if KillSoundLengthTable ~= nil then
				local KillFileFoundLength
				-- Is there .mp3 at the end?
				--print(string.find(string.lower(file), ".mp3", string.len(file) - 4), file)
				if (not string.find(string.lower(file), ".mp3", string.len(file) - 4)) then
					-- If not then add it
					file = file..".mp3"
				end
				for i = 1, table.getn(KillSoundLengthTable) do
					if string.upper(KillSoundLengthTable[i].dir) == string.upper(file) then
						KillFileFoundLength = KillSoundLengthTable[i].duration
					end
				end
				if KillFileFoundLength then
					local KillTable = {dir = file, length = KillFileFoundLength}
					-- Insert the sound into the Kill Sound Queue
					table.insert(PVPSound_KillSoundQueue, KillTable)
				else
					-- Not in the sound table so just play it
					PlaySoundFile(file, PS_Channel)
				end
			else
				PlaySoundFile(file, PS_Channel)
			end
		end
	else
		-- We've got lengths for the supported SoundPacks only, if that's not selected or SoundEngine is disabled then just play it
		if file ~= nil then
			PlaySoundFile(file, PS_Channel)
		end
	end

	if #PVPSound_KillSoundQueue > 0 and not PVPSoundKillSoundEngineFrame:GetScript("OnUpdate") then
		PVPSound_NextKillUpdate = 0

		PVPSoundKillSoundEngineFrame:SetScript("OnUpdate", PVPSound.UpdateKillSoundEngine)
	end
end

function PVPSound:ClearKillSoundQueue()
	-- This function will clear all the sounds from the Kill Sound Queue
	for i = table.getn(PVPSound_KillSoundQueue), 1, - 1 do
		table.remove(PVPSound_KillSoundQueue, i)
	end

	PVPSoundKillSoundEngineFrame:SetScript("OnUpdate", nil)
end

function PVPSound:PlayNextKillSound()
	-- This function will play the next sound in the Kill Sound Queue and return how long that sound will be played
	-- If there is no sound in the Kill Sound Queue it will just return 0.3000
	if PVPSound:KillSoundInQueue() then
		local x
		PlaySoundFile(PVPSound_KillSoundQueue[1].dir, PS_Channel)
		x = PVPSound_KillSoundQueue[1].length
		table.remove(PVPSound_KillSoundQueue, 1)

		return x
	else
		return 0.3000
	end
end

function PVPSound:KillSoundInQueue()
	-- This function will return 1 if there is a sound in the Kill Sound Queue, nil otherwise
	if table.getn(PVPSound_KillSoundQueue) > 0 then
		return 1
	else
		return nil
	end
end

function PVPSound:UpdateKillSoundEngine(elapsed)
	if PS_EnableAddon == true then
		if PS_KillSoundEngine == true then
			TimeSinceLastKillUpdate = TimeSinceLastKillUpdate + elapsed
			while TimeSinceLastKillUpdate > PVPSound_NextKillUpdate do
				TimeSinceLastKillUpdate = TimeSinceLastKillUpdate - PVPSound_NextKillUpdate

				if #PVPSound_KillSoundQueue == 0 then
					PVPSoundKillSoundEngineFrame:SetScript("OnUpdate", nil)
				end

				PVPSound_NextKillUpdate = PVPSound:PlayNextKillSound()
			end
		end
	end
end

--PVPSoundKillSoundEngineFrame:SetScript("OnUpdate", PVPSound.UpdateKillSoundEngine)

-- Sound Effect Queue
function PVPSound:AddEffectToQueue(killtype, file)
	-- This function will add file to the Effect Sound Queue to be played
	-- If the sound could not be found in the sound lengths table then just play it
	-- This is a table of soundlengths according to the selected SoundPack
	if (PS_KillSoundPackName == "DevilMayCry" or PS_KillSoundPackName == "Dota2" or PS_KillSoundPackName == "Halo4" or PS_KillSoundPackName == "UnrealTournament3" or PS_KillSoundPackName == "Custom") then
		if file ~= nil then
			local SoundEffectLengthTable = _G["PVPSound_"..PS.KillSoundPack..killtype.."Durations"]
			if SoundEffectLengthTable ~= nil then
				local EffectFileFoundLength
				-- Is there .mp3 at the end?
				--print(string.find(string.lower(file), ".mp3", string.len(file) - 4), file)
				if (not string.find(string.lower(file), ".mp3", string.len(file) - 4)) then
					-- If not then add it
					file = file..".mp3"
				end
				for i = 1, table.getn(SoundEffectLengthTable) do
					if string.upper(SoundEffectLengthTable[i].dir) == string.upper(file) then
						EffectFileFoundLength = SoundEffectLengthTable[i].duration
					end
				end
				if EffectFileFoundLength then
					local EffectTable = {dir = file, length = EffectFileFoundLength}
					-- Insert the sound into the Effect Sound Queue
					table.insert(PVPSound_SoundEffectQueue, EffectTable)
				end
			end
		end
	end

	if #PVPSound_SoundEffectQueue > 0 and not PVPSoundEffectSoundEngineFrame:GetScript("OnUpdate") then
		PVPSound_NextEffectUpdate = 0

		PVPSoundEffectSoundEngineFrame:SetScript("OnUpdate", PVPSound.UpdateSoundEffectEngine)
	end
end

function PVPSound:ClearSoundEffectQueue()
	-- This function will clear all the sounds from the Effect Sound Queue
	for i = table.getn(PVPSound_SoundEffectQueue), 1, - 1 do
		table.remove(PVPSound_SoundEffectQueue, i)
	end

	PVPSoundEffectSoundEngineFrame:SetScript("OnUpdate", nil)
end

function PVPSound:PlayNextSoundEffect()
	-- This function will play the next sound in the Effect Sound Queue and return how long that sound will be played or return 0.0001
	-- If there is no sound in the Effect Sound Queue it will just return 0.3000
	if PVPSound:SoundEffectInQueue() then
		if string.upper(PVPSound_SoundEffectQueue[1].dir) == string.upper(PS.KillSoundPackDirectory.."\\"..PS_KillSoundPackLanguage.."\\Effects\\KillingMaxRank.mp3") or string.upper(PVPSound_SoundEffectQueue[1].dir) == string.upper(PS.KillSoundPackDirectory.."\\"..PS_KillSoundPackLanguage.."\\Effects\\MultiKillingMaxRank.mp3") then
			PlaySoundFile(PVPSound_SoundEffectQueue[1].dir, PS_Channel)
			table.remove(PVPSound_SoundEffectQueue, 1)
			return 0.0001
		else
			local x
			x = PVPSound_SoundEffectQueue[1].length
			table.remove(PVPSound_SoundEffectQueue, 1)

			return x
		end
	else
		return 0.3000
	end
end

function PVPSound:SoundEffectInQueue()
	-- This function will return 1 if there is a sound in the Effect Sound Queue, nil otherwise
	if table.getn(PVPSound_SoundEffectQueue) > 0 then
		return 1
	else
		return nil
	end
end

function PVPSound:UpdateSoundEffectEngine(elapsed)
	if PS_EnableAddon == true then
		if PS_SoundEffect == true then
			TimeSinceLastEffectUpdate = TimeSinceLastEffectUpdate + elapsed
			while TimeSinceLastEffectUpdate > PVPSound_NextEffectUpdate do
				TimeSinceLastEffectUpdate = TimeSinceLastEffectUpdate - PVPSound_NextEffectUpdate

				if #PVPSound_SoundEffectQueue == 0 then
					PVPSoundEffectSoundEngineFrame:SetScript("OnUpdate", nil)
				end

				PVPSound_NextEffectUpdate = PVPSound:PlayNextSoundEffect()
			end
		end
	end
end

--PVPSoundEffectSoundEngineFrame:SetScript("OnUpdate", PVPSound.UpdateSoundEffectEngine)
