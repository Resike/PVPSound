local addon, ns = ...
local PVPSound = ns.PVPSound
local PS = ns.PS
local L = ns.L

local API = PVPSound.API
local mod = API:RegisterMod(244, "none", "Tol Barad", nil)

local MyZone = "Zone_TolBarad" -- I don't want to rewrite some code here, so I use this

--------------------------------------------------
-- Resourses and functions---------------------
local BgIsOver

local TBobjectives = {BaradinHold = nil, IroncladGarrison = nil, WardensVigil = nil, Slagworks = nil, EastSpire = nil, SouthSpire = nil, WestSpire = nil}

local function TBget_objective(id)
	if id == 2485 or id == 2486 then
		return "BaradinHold"
	elseif id >= 2440 and id <= 2443 then
		return "IroncladGarrison"
	elseif id >= 2444 and id <= 2447 then
		return "WardensVigil"
	elseif id >= 2448 and id <= 2451 then
		return "Slagworks"
	elseif id >= 2459 and id <= 2465 then
		return "EastSpire"
	elseif id >= 2466 and id <= 2472 then
		return "SouthSpire"
	elseif id >= 2452 and id <= 2458 then
		return "WestSpire"
	else
		return false
	end
end

local function TBobj_state(id)
	if id == 2485 or id == 2440 or id == 2444 or id == 2448 then
		return 1 -- Alliance Bases
	elseif id == 2486 or id == 2441 or id == 2445 or id == 2449 then
		return 2 -- Horde Bases
	elseif id == 2442 or id == 2446 or id == 2450 then
		return 3 -- Alliance trys to capture
	elseif id == 2443 or id == 2447 or id == 2451 then
		return 4 -- Horde trys to capture
	elseif id == 2462 or id == 2469 or id == 2452 then
		return 5 -- Alliance Towers Undamaged
	elseif id == 2464 or id == 2471 or id == 2453 then
		return 6 -- Horde Towers Undamaged
	elseif id == 2463 or id == 2470 or id == 2455 then
		return 7 -- Alliance Towers Heavily Damaged
	elseif id == 2465 or id == 2472 or id == 2454 then
		return 8 -- Horde Towers Heavily Damaged
	elseif id == 2460 or id == 2468 or id == 2457 then
		return 9 -- Towers Destroyed
	else
		return 0
	end
end

local function FreeResourses()
	BgIsOver = nil
	TBobjectives = {BaradinHold = nil, IroncladGarrison = nil, WardensVigil = nil, Slagworks = nil, EastSpire = nil, SouthSpire = nil, WestSpire = nil}
end

-- check is active or not
local function IsActive(zoneId)
	if zoneId == 244 and (select(5, GetWorldPVPAreaInfo(2))) == 0 then
		return true
	else
		return false
	end
end

-- Custom BG announcer
-- Tol Barad PlaySounds
-- dont fixed at the moment
-- battle starts without ui reloading or zone chaging events
-- Also, custom announcer uses objective table, so it should be called after first 
-- initialization of objectives
local function AnnounceBG(zoneId)
    local MyFaction = UnitFactionGroup("player")
    local TbAttacker
	if IsActive(zoneId) == true then
		local textureIndex = TBobjectives.BaradinHold
		if textureIndex then
			if textureIndex == 2486 then
				TbAttacker = "Alliance"
			elseif textureIndex == 2485 then
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

-- Initialize timer for time remaining
local function InitTimer()
	API:ResetTimers()
	C_Timer.After(3, function() API:TimeRemaining_check(682) end) --check for C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo existance is already in TimeRemaining_check function
	--delay needed cause UI WIDGETS update occures later then entering wold or zone changing
end

--------------------------------------------------
-- on event functions ----------------------------

function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, EventMessage)
	-- WinSounds
	local textureIndex = TBobjectives.BaradinHold
	local nextBattle = tostring(string.match(C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(688).text, ": (.+)"))
	nextBattle = string.sub(nextBattle, 1, string.len(nextBattle) - 1)
	if textureIndex and nextBattle then
		if BgIsOver ~= true then
			print(nextBattle)
			if nextBattle == "1:00:0" or nextBattle == "1:59:5" or nextBattle == "2:04:5" or nextBattle == "2:09:5" or nextBattle == "2:14:5" then
				if textureIndex == 2485 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeWins.mp3")
					BgIsOver = true
					mod:Unload()
				elseif textureIndex == 2486 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceWins.mp3")
					BgIsOver = true
					mod:Unload()
				end
			end
		end
	end
end

function mod:AREA_POIS_UPDATED()
    local POIs = C_AreaPoiInfo.GetAreaPOIForMap(mod.zoneId)
    for i = 1, #POIs do
        local type = TBget_objective(POIs[i])
        if type then
            -- Baradin Hold
            if type == "BaradinHold" and BgIsOver ~= true then
                if TBobj_state(TBobjectives[type]) == 2 and TBobj_state(POIs[i]) == 1 then
                    PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceWins.mp3")
                    BgIsOver = true
					mod:Unload()
                elseif TBobj_state(TBobjectives[type]) == 1 and TBobj_state(POIs[i]) == 2 then
                    PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeWins.mp3")
                    BgIsOver = true
					mod:Unload()
                end
            --Spires
            elseif string.find(type, "Spire") then
                if TBobj_state(TBobjectives[type]) == 5 and TBobj_state(POIs[i]) == 7 then
                    PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_HeavilyDamaged.mp3")
                elseif TBobj_state(TBobjectives[type]) == 7 and TBobj_state(POIs[i]) == 9 then
                    PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Destroyed.mp3")
                elseif TBobj_state(TBobjectives[type]) == 6 and TBobj_state(POIs[i]) == 8 then
                    PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_HeavilyDamaged.mp3")
                elseif TBobj_state(TBobjectives[type]) == 8 and TBobj_state(POIs[i]) == 9 then
                    PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Destroyed.mp3")
                end
            --Towers
            else
                if TBobj_state(TBobjectives[type]) == 3 and TBobj_state(POIs[i]) == 1 then
                    PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
                elseif TBobj_state(TBobjectives[type]) == 4 and TBobj_state(POIs[i]) == 2 then
                    PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
                elseif TBobj_state(TBobjectives[type]) == 4 and TBobj_state(POIs[i]) == 1 then
                    PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Defense.mp3")
                elseif TBobj_state(TBobjectives[type]) == 3 and TBobj_state(POIs[i]) == 2 then
                    PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Defense.mp3")
                elseif TBobj_state(TBobjectives[type]) == 1 and TBobj_state(POIs[i]) == 4 then
                    PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
                elseif TBobj_state(TBobjectives[type]) == 2 and TBobj_state(POIs[i]) == 3 then
                    PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
                elseif TBobj_state(TBobjectives[type]) == 3 and TBobj_state(POIs[i]) == 4 then
                    PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Base_Offense.mp3")
                elseif TBobj_state(TBobjectives[type]) == 4 and TBobj_state(POIs[i]) == 3 then
                    PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Base_Offense.mp3")
                end
            end
            TBobjectives[type] = POIs[i]
        end
    end
end

-- The point of using this event is that, when you enter BF zone, when BF is not active
-- this event is registered.
-- It fires when you cross the bridge on the enter to the main zone.
-- So each time you'll try to enter the zone, addon will try try to be initialized
-- And when it finally become active (battle begins, gates open) UPDATE_ALL_UI_WIDGETS will be uregisterd and BG will be announeced
function mod:UPDATE_ALL_UI_WIDGETS()
	self.loaded = false -- for correct unloading on zone changing
	mod:Initialize()
end

--------------------------------------------------
-- module start and end poins --------------------
function mod:Initialize()
	if IsActive(self.zoneId) then
		API:UnregisterEvent("UPDATE_ALL_UI_WIDGETS")
		API.RegisterEvent(self, "AREA_POIS_UPDATED")
		API.RegisterEvent(self, "CHAT_MSG_RAID_BOSS_EMOTE")
		API:ObjInit(self.zoneId, TBobjectives, TBget_objective)
		if not self.loaded then
			AnnounceBG(self.zoneId)
		end
		PS.PaybackKillTime = 120
		BgIsOver = false
        InitTimer()
		self.loaded = true
	else
		API.RegisterEvent(self, "UPDATE_ALL_UI_WIDGETS")
		self.loaded = true
	end
end

function mod:Unload()
	PS.PaybackKillTime = 90
	API:UnregisterEvent("AREA_POIS_UPDATED")
	API:UnregisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	API:UnregisterEvent("UPDATE_ALL_UI_WIDGETS")
	FreeResourses()
	self.loaded = false
end
