local addon, ns = ...
local PVPSound = ns.PVPSound
local PS = ns.PS

local PVPSoundPaysoundFrame = CreateFrame("Frame")
local TimeSinceLastPayUpdate = 0

local PVPSoundRetributionFrame = CreateFrame("Frame")
local TimeSinceLastRetUpdate = 0

local PVPSoundRecentlyPaybackFrame = CreateFrame("Frame")
local TimeSinceLastRecPayUpdate = 0

local PVPSoundRecentlyKilledFrame = CreateFrame("Frame")
local TimeSinceLastRecKillUpdate = 0

local PVPSound_PaybackQueue						= { }
local PVPSound_RetributionQueue					= { }
local PVPSound_RecentlyPaybackQueue				= { }
local PVPSound_RecentlyKilledQueue				= { }

local PVPSound_NextPayUpdate 					= 0.3300
local PVPSound_NextRetUpdate 					= 0.3300
local PVPSound_NextRecPayUpdate 				= 0.3300
local PVPSound_NextRecKillUpdate 				= 0.3300

local string, upper, table, getn, insert, remove = string, upper, table, getn, insert, remove

-- Payback Queue
function PVPSound:AddToPaybackQueue(name)
	-- This function will add the name and the killtime into the Payback Queue
	if not name then
		return
	end

	local num
	local queued = false

	for i = 1, table.getn(PVPSound_PaybackQueue), 1 do
		-- If the name is already in the queue
		if string.upper(PVPSound_PaybackQueue[i].dir) == string.upper(name) then
			num = i
			queued = true
		end
	end

	if queued then
		PVPSound_PaybackQueue[num].killtime = GetTime()
	else
		local PaybackTable = {dir = name, killtime = GetTime()}
		table.insert(PVPSound_PaybackQueue, PaybackTable)
	end

	if #PVPSound_PaybackQueue > 0 and not PVPSoundPaysoundFrame:GetScript("OnUpdate") then
		PVPSound_NextPayUpdate = 0

		PVPSoundPaysoundFrame:SetScript("OnUpdate", PVPSound.UpdatePaybackSound)
	end
end

function PVPSound:CheckPaybackQueue(name)
	local PaybackKill = false
	for i = 1, table.getn(PVPSound_PaybackQueue), 1 do
		if string.upper(PVPSound_PaybackQueue[i].dir) == string.upper(name) then
			PaybackKill = true
		end
	end
	return PaybackKill
end

function PVPSound:ClearPaybackQueue()
	-- This function will clear all possible Payback names and killtimes from the Payback Queue
	for i = table.getn(PVPSound_PaybackQueue), 1, - 1 do
		table.remove(PVPSound_PaybackQueue, i)
	end

	PVPSoundPaysoundFrame:SetScript("OnUpdate", nil)
end

function PVPSound:DeleteFirstPayback()
	-- This function will delete the first name and killtime from the Payback Queue if its in the queue since more than the Payback Kill time, and return 0.3300
	-- If there is no name and killtime in the Payback Queue it will just return 0.3300
	if PVPSound:PaybackInQueue() then
		if GetTime() - PS.PaybackKillTime > PVPSound_PaybackQueue[1].killtime then
			table.remove(PVPSound_PaybackQueue, 1)
		end
	end

	return 0.3300
end

function PVPSound:PaybackInQueue()
	-- This function will return 1 if there is a name in the Payback Queue, nil otherwise
	if table.getn(PVPSound_PaybackQueue) > 0 then
		return 1
	else
		return nil
	end
end

function PVPSound:UpdatePaybackSound(elapsed)
	if PS_EnableAddon == true then
		if PS_PaybackSound == true then
			TimeSinceLastPayUpdate = TimeSinceLastPayUpdate + elapsed
			while TimeSinceLastPayUpdate > PVPSound_NextPayUpdate do
				
				TimeSinceLastPayUpdate = TimeSinceLastPayUpdate - PVPSound_NextPayUpdate

				if #PVPSound_PaybackQueue == 0 then
					PVPSoundPaysoundFrame:SetScript("OnUpdate", nil)
				end

				PVPSound_NextPayUpdate = PVPSound:DeleteFirstPayback()
			end
		end
	end
end

--PVPSoundPaysoundFrame:SetScript("OnUpdate", PVPSound.UpdatePaybackSound)

-- Retribution Queue
function PVPSound:AddToRetributionQueue(name)
	-- This function will add the name and the killtime into the Retribution queue
	if not name then
		return
	end

	local num
	local queued = false

	for i = 1, table.getn(PVPSound_RetributionQueue), 1 do
		-- If the name is already in the queue
		if string.upper(PVPSound_RetributionQueue[i].dir) == string.upper(name) then
			num = i
			queued = true
		end
	end

	if queued then
		PVPSound_RetributionQueue[num].killtime = GetTime()
	else
		local RetributionTable = {dir = name, killtime = GetTime()}
		table.insert(PVPSound_RetributionQueue, RetributionTable)
	end

	if #PVPSound_RetributionQueue > 0 and not PVPSoundRetributionFrame:GetScript("OnUpdate") then
		PVPSound_NextRetUpdate = 0

		PVPSoundRetributionFrame:SetScript("OnUpdate", PVPSound.UpdateRetributionSound)
	end
end

function PVPSound:CheckRetributionQueue(name)
	local RetributionKill = false
	for i = 1, table.getn(PVPSound_RetributionQueue), 1 do
		if string.upper(PVPSound_RetributionQueue[i].dir) == string.upper(name) then
			RetributionKill = true
		end
	end
	return RetributionKill
end

function PVPSound:ClearRetributionQueue()
	-- This function will clear all possible Retribution names and killtimes from the Retribution Queue
	for i = table.getn(PVPSound_RetributionQueue), 1, - 1 do
		table.remove(PVPSound_RetributionQueue, i)
	end

	PVPSoundRetributionFrame:SetScript("OnUpdate", nil)
end

function PVPSound:DeleteFirstRetribution()
	-- This function will delete the first name and killtime from the Retribution Queue if its in the queue since more than Payback kill time, and return 0.3300
	-- If there is no name and killtime in the Retribution Queue it will just return 0.3300
	if PVPSound:RetributionInQueue() then
		if GetTime() - PS.PaybackKillTime > PVPSound_RetributionQueue[1].killtime then
			table.remove(PVPSound_RetributionQueue, 1)
		end
	end

	return 0.3300
end

function PVPSound:RetributionInQueue()
	-- This function will return 1 if there is a name in the Retribution Queue, nil otherwise
	if table.getn(PVPSound_RetributionQueue) > 0 then
		return 1
	else
		return nil
	end
end

function PVPSound:UpdateRetributionSound(elapsed)
	if PS_EnableAddon == true then
		if PS_PaybackSound == true then
			TimeSinceLastRetUpdate = TimeSinceLastRetUpdate + elapsed
			while TimeSinceLastRetUpdate > PVPSound_NextRetUpdate do
				TimeSinceLastRetUpdate = TimeSinceLastRetUpdate - PVPSound_NextRetUpdate

				if #PVPSound_RetributionQueue == 0 then
					PVPSoundRetributionFrame:SetScript("OnUpdate", nil)
				end

				PVPSound_NextRetUpdate = PVPSound:DeleteFirstRetribution()
			end
		end
	end
end

--PVPSoundRetributionFrame:SetScript("OnUpdate", PVPSound.UpdateRetributionSound)

-- Recenlty Payback Queue
function PVPSound:AddToRecentlyPaybackQueue(name)
	-- This function will add Payback or Retribution to the Recently Payback Queue
	if not name then
		return
	end

	local num
	local queued

	for i = 1, table.getn(PVPSound_RecentlyPaybackQueue), 1 do
		-- If the name is already in the queue
		if string.upper(PVPSound_RecentlyPaybackQueue[i].dir) == string.upper(name) then
			num = i
			queued = true
		end
	end

	if queued then
		PVPSound_RecentlyPaybackQueue[num].killedtime = PS.RecentlyPaybackTime
	else
		local RecentlyPaybackTable = {dir = name, killedtime = PS.RecentlyPaybackTime}
		table.insert(PVPSound_RecentlyPaybackQueue, RecentlyPaybackTable)
	end

	if #PVPSound_RecentlyPaybackQueue > 0 and not PVPSoundRecentlyPaybackFrame:GetScript("OnUpdate") then
		PVPSound_NextRecPayUpdate = 0

		PVPSoundRecentlyPaybackFrame:SetScript("OnUpdate", PVPSound.UpdateRecentlyPayback)
	end
end

function PVPSound:CheckRecentlyPaybackQueue(name)
	local RecentlyPayback = false
	for i = 1, table.getn(PVPSound_RecentlyPaybackQueue), 1 do
		if string.upper(PVPSound_RecentlyPaybackQueue[i].dir) == string.upper(name) then
			RecentlyPayback = true
		end
	end
	return RecentlyPayback
end

function PVPSound:ClearRecentlyPaybackQueue()
	-- This function will clear all Recently Killed names and killedtimes from the Recently Queue
	for i = table.getn(PVPSound_RecentlyPaybackQueue), 1, - 1 do
		table.remove(PVPSound_RecentlyPaybackQueue, i)
	end

	PVPSoundRecentlyPaybackFrame:SetScript("OnUpdate", nil)
end

function PVPSound:DeleteFirstRecentlyPayback()
	-- This function will delete the first Payback or Retribution and killedtime from the Recently Payback Queue if its in the queue since more than Recently Payback time, and return 0.3300
	-- If there is no Payback or Retribution and killedtime in the Recently Payback Queue it will just return 0.3300
	if PVPSound:RecentlyPaybackInQueue() then
		if GetTime() - PS.RecentlyPaybackTime > PVPSound_RecentlyPaybackQueue[1].killedtime then
			table.remove(PVPSound_RecentlyPaybackQueue, 1)
		end
	end

	return 0.3300
end

function PVPSound:RecentlyPaybackInQueue()
	-- This function will return 1 if there is a Payback or Retribution in the Recently Payback Queue, nil otherwise
	if table.getn(PVPSound_RecentlyPaybackQueue) > 0 then
		return 1
	else
		return nil
	end
end

function PVPSound:UpdateRecentlyPayback(elapsed)
	if PS_EnableAddon == true then
		if PS_PaybackSound == true then
			TimeSinceLastRecPayUpdate = TimeSinceLastRecPayUpdate + elapsed
			while TimeSinceLastRecPayUpdate > PVPSound_NextRecPayUpdate do
				TimeSinceLastRecPayUpdate = TimeSinceLastRecPayUpdate - PVPSound_NextRecPayUpdate

				if #PVPSound_RecentlyPaybackQueue == 0 then
					PVPSoundRecentlyPaybackFrame:SetScript("OnUpdate", nil)
				end

				PVPSound_NextRecPayUpdate = PVPSound:DeleteFirstRecentlyPayback()
			end
		end
	end
end

--PVPSoundRecentlyPaybackFrame:SetScript("OnUpdate", PVPSound.UpdateRecentlyPayback)

-- Recenlty Killed Queue
function PVPSound:AddToRecentlyKilledQueue(name)
	-- This function will add the name and the killedtime into the Recently Killed Queue
	if not name then
		return
	end

	local num
	local queued = false

	for i = 1, table.getn(PVPSound_RecentlyKilledQueue), 1 do
		-- If the name is already in the queue
		if string.upper(PVPSound_RecentlyKilledQueue[i].dir) == string.upper(name) then
			num = i
			queued = true
		end
	end

	if queued then
		PVPSound_RecentlyKilledQueue[num].killedtime = GetTime()
	else
		local RecentlyKilledTable = {dir = name, killedtime = GetTime()}
		table.insert(PVPSound_RecentlyKilledQueue, RecentlyKilledTable)
	end

	if #PVPSound_RecentlyKilledQueue > 0 and not PVPSoundRecentlyKilledFrame:GetScript("OnUpdate") then
		PVPSound_NextRecKillUpdate = 0

		PVPSoundRecentlyKilledFrame:SetScript("OnUpdate", PVPSound.UpdateRecentlyKilled)
	end
end

function PVPSound:CheckRecentlyKilledQueue(name)
	local AlreadyKilled = false
	for i = 1, table.getn(PVPSound_RecentlyKilledQueue), 1 do
		if string.upper(PVPSound_RecentlyKilledQueue[i].dir) == string.upper(name) then
			AlreadyKilled = true
		end
	end
	return AlreadyKilled
end

function PVPSound:ClearRecentlyKilledQueue()
	-- This function will clear all Recently Killed names and killedtimes from the Recently Queue
	for i = table.getn(PVPSound_RecentlyKilledQueue), 1, - 1 do
		table.remove(PVPSound_RecentlyKilledQueue, i)
	end

	PVPSoundRecentlyKilledFrame:SetScript("OnUpdate", nil)
end

function PVPSound:DeleteFirstRecentlyKilled()
	-- This function will delete the first name and killedtime from the Recently Queue if its in the queue since more than Recently killed time, and return 0.3300
	-- If there is no name and killedtime in the Recently Queue it will just return 0.3300
	if PVPSound:RecentlyKilledInQueue() then
		if GetTime() - PS.RecentlyKilledTime > PVPSound_RecentlyKilledQueue[1].killedtime then
			table.remove(PVPSound_RecentlyKilledQueue, 1)
		end
	end

	return 0.3300
end

function PVPSound:RecentlyKilledInQueue()
	-- This function will return 1 if there is a name in the Recently Killed Queue, nil otherwise
	if table.getn(PVPSound_RecentlyKilledQueue) > 0 then
		return 1
	else
		return nil
	end
end

function PVPSound:UpdateRecentlyKilled(elapsed)
	if PS_EnableAddon == true then
		if PS_KillSound == true then
			TimeSinceLastRecKillUpdate = TimeSinceLastRecKillUpdate + elapsed
			while TimeSinceLastRecKillUpdate > PVPSound_NextRecKillUpdate do
				TimeSinceLastRecKillUpdate = TimeSinceLastRecKillUpdate - PVPSound_NextRecKillUpdate

				if #PVPSound_RecentlyKilledQueue == 0 then
					PVPSoundRecentlyKilledFrame:SetScript("OnUpdate", nil)
				end

				PVPSound_NextRecKillUpdate = PVPSound:DeleteFirstRecentlyKilled()
			end
		end
	end
end


--PVPSoundRecentlyKilledFrame:SetScript("OnUpdate", PVPSound.UpdateRecentlyKilled)