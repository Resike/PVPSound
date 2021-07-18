
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




--later it will be good to add some variety in sounds to SeS and CI




--arena UI WIDGET IDs array. For arena timers
--Each arena has its unique topcenter widget with timeremaining info
--So, I pass thruogh this array until existing arena widget will be found
local arenaUI = {NagrandOld = 742, NagrandLegion = 920, BladesEdge = 740, BladesEdgeLegion = 929, RuinsOfLordaeron = 745, DalaranArena = 741,
				TheRingOfValor = 743, TigersPeak = 738, ShadopanLegion = 925, BlackrookHoldArena = 905, ValsharahArena = 902, TolvirArena = 744,
				HookPoint = 1147, Mugambala = 1144, Robodrome = 2069, BastionArena = 2946}



--function just to use the same code in two places
local function InitializeBgs(...)
	MyFaction = UnitFactionGroup("player")
	local self = ...
	CurrentZoneId = C_Map.GetBestMapForUnit("player")
	CurrentZoneText = GetRealZoneText()
	InstanceType = (select(2, IsInInstance()))
	IsRated = C_PvP.IsRatedBattleground()
	--print("tech info ",CurrentZoneId,CurrentZoneText,InstanceType,IsRated)
	TimerReset = true


	-- Battlegrounds




	 -- Battlefields
	elseif CurrentZoneId == 123 or (CurrentZoneId == 1334 and InstanceType == "pvp") then --1334 is BG version of this zone
		MyZone = "Zone_Wintergrasp"--updated
	elseif CurrentZoneId == 244 then--updated
		MyZone = "Zone_TolBarad"
	elseif CurrentZoneId == 1478 then--updated--only BG
		MyZone = "Zone_Ashran"
	-- Arenas
	elseif InstanceType == "arena" then
		MyZone = "Zone_Arenas"
	else
		MyZone = ""
	end
	-- Payback Kill time
	if MyZone == "Zone_AlteracValley" or MyZone == "Zone_IsleofConquest" or MyZone == "Zone_Wintergrasp" or MyZone == "Zone_TolBarad" or MyZone == "Zone_Ashran" then
		PS.PaybackKillTime = 120
	else
		PS.PaybackKillTime = 90
	end


	--world state check
	if MyZone == "Zone_WarsongGulch" or MyZone == "Zone_TwinPeaks" or MyZone == "Zone_TolBarad" or MyZone == "Zone_SeethingShore" or MyZone == "Zone_TarrenShore" then


		local i --id of timer widget
		if MyZone == "Zone_TolBarad" then
			i = 682 --updated

		if (C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(i)) ~= nil then --world state text
			-- Time Remaining
			C_Timer.After(2, function() TimeRemaining_check(i) end)
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

	if MyZone == "Zone_Arenas" then

		--there will be two timers, because we initialize BGs twice: on entering world and on zone change
		--delay needed cause UI WIDGETS update occures later then entering wold or zone changing
		C_Timer.After(2, function ()
			for k, v in pairs(arenaUI) do
				--print("arena ")
				if TimeRemaining_check(v) then
					break
				end
			end
		end)

	end










	if MyZone == "Zone_Wintergrasp" then
		local isActive
		if CurrentZoneId == 123 and (select(5, GetWorldPVPAreaInfo(1))) == 0 then
			isActive = true
		elseif CurrentZoneId == 1334 then
			isActive = true
		else
			isActive = false
		end

		--print("isActive: ", isActive)
		if isActive == true then
			BgIsOver = false
			local POIs = C_AreaPoiInfo.GetAreaPOIForMap(CurrentZoneId)

			local FlamewatchTowerInit
			local ShadowsightTowerInit
			local WintersEdgeTowerInit
			local WintergraspFortressTowerNEInit
			local WintergraspFortressTowerNWInit
			local WintergraspFortressTowerSEInit
			local WintergraspFortressTowerSWInit
			local TowerWallsInit = 0
			local WintergraspFortressInit

			for i = 1, #POIs do
				if WGget_objective(POIs[i]) == "FlamewatchTower" then
					FlamewatchTowerInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				elseif WGget_objective(POIs[i]) == "ShadowsightTower" then
					ShadowsightTowerInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				elseif WGget_objective(POIs[i]) == "WintersEdgeTower" then
					WintersEdgeTowerInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				elseif WGget_objective(POIs[i]) == "WintergraspFortressTowerNE" then
					WintergraspFortressTowerNEInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				elseif WGget_objective(POIs[i]) == "WintergraspFortressTowerNW" then
					WintergraspFortressTowerNWInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				elseif WGget_objective(POIs[i]) == "WintergraspFortressTowerSE" then
					WintergraspFortressTowerSEInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
				elseif WGget_objective(POIs[i]) == "WintergraspFortressTowerSW" then
					WintergraspFortressTowerSWInit = C_AreaPoiInfo.GetAreaPOIInfo(CurrentZoneId,POIs[i]).textureIndex
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
			ObgInit(TBobjectives, TBget_objective)
		end

	end


end





function PVPSound:OnEvent(event, ...)
	if PS_EnableAddon == true then	
		if PS_BattlegroundSound == true then --only for BG and arena
			if event == "ZONE_CHANGED_NEW_AREA" then --repeat things we do on player entering world
				BgIsOver = false
				InitializeBgs(self)
				--print(event, " my zone is ", MyZone)

				-- Battleground PlaySounds
				if MyZone == "Zone_WarsongGulch" or MyZone == "Zone_EyeoftheStorm" or MyZone == "Zone_ArathiBasin" or MyZone == "Zone_AlteracValley" or MyZone == "Zone_IsleofConquest" or MyZone == "Zone_TwinPeaks" or MyZone == "Zone_TheBattleforGilneas" or MyZone == "Zone_TempleofKotmogu" or MyZone == "Zone_SilvershardMines" or MyZone == "Zone_DeepwindGorge" or MyZone == "Zone_SeethingShore" or MyZone == "Zone_CookingImpossible" or MyZone == "Zone_TarrenShore" or MyZone == "Zone_Ashran" then
					--print("announcement")
					TimerReset = true
					KilledMe = nil
					KilledBy = nil
					if IsRated == true then
						local AllianceBuff
						local HordeBuff
						for i = 1, 40 do
							local _, _, _, _, _, _, _, _, _, spellID = UnitBuff("player", i, "HELPFUL")
							if spellID == 81748 then
								AllianceBuff = true
							elseif spellID == 81744 then
								HordeBuff = true
							end
						end
						-- Alliance RBG buff
						if MyFaction == "Horde" and AllianceBuff and AlreadyPlaySound ~= true then
							PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\PlayYouAreOnBlue.mp3")
							AlreadyPlaySound = true
						 -- Horde RBG buff
						elseif MyFaction == "Alliance" and HordeBuff and AlreadyPlaySound ~= true then
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
					if CurrentZoneId == 123 and (select(5, GetWorldPVPAreaInfo(1))) == 0 then
						isActive = true
					elseif CurrentZoneId == 1334 then
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
						if CurrentZoneId == 123 then
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
						--print("attacker = ",WgAttacker," faction", MyFaction)
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
				 -- dont fixed at the moment
				 -- battle starts without ui reloading or zone chaging evenst
				elseif MyZone == "Zone_TolBarad" then
					TimerReset = true
					KilledMe = nil
					KilledBy = nil
					local isActive = (select(5, GetWorldPVPAreaInfo(2)))
					if isActive == 0 then
						local textureIndex = TBobjectives.BaradinHold
						if textureIndex then
							if textureIndex == 2485 then
								TbAttacker = "Alliance"
							elseif textureIndex == 2486 then
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

			--parsing pvp info from chat
			if event == "CHAT_MSG_BG_SYSTEM_NEUTRAL" then
				local EventMessage = select(1, ...)

				-- Warsong Gulch and Twin Peaks Vulnerable
				if MyZone == "Zone_WarsongGulch" or MyZone == "Zone_TwinPeaks" then

					if string.find(EventMessage, L["Alliance Flag has returned"]) then

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
					if CurrentZoneId == 123 and (select(5, GetWorldPVPAreaInfo(1))) == 0 then
						isActive = true
					elseif CurrentZoneId == 1334 then
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
						local textureIndex = TBobjectives.BaradinHold

						local nextBattle = tostring(string.match(C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(688).text, ": (.+)"))
						nextBattle = string.sub(nextBattle, 1, string.len(nextBattle) - 1)
						--print(nextBattle)
						if textureIndex and nextBattle then
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
				

			elseif event == "AREA_POIS_UPDATED" then



				 -- Wintergrasp
				elseif MyZone == "Zone_Wintergrasp" then
					local isActive
					if CurrentZoneId == 123 and (select(5, GetWorldPVPAreaInfo(1))) == 0 then
						isActive = true
					elseif CurrentZoneId == 1334 then
						isActive = true
					else
						isActive = false
					end

					if isActive == true then
						-- Towers
						local POIs = C_AreaPoiInfo.GetAreaPOIForMap(CurrentZoneId)
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

					local isActive = (select(5, GetWorldPVPAreaInfo(1)))
					if isActive == 0 then
						local POIs = C_AreaPoiInfo.GetAreaPOIForMap(CurrentZoneId)

						for i = 1, #POIs do
							local type = TBget_objective(POIs[i])

							if type then
								-- Baradin Hold
								if type == "BaradinHold" and BgIsOver ~= true then
									if TBobj_state(TBobjectives[type]) == 2 and TBobj_state(POIs[i]) == 1 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceWins.mp3")
										BgIsOver = true
									elseif TBobj_state(TBobjectives[type]) == 1 and TBobj_state(POIs[i]) == 2 then
										PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeWins.mp3")
										BgIsOver = true
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
				end
			end
		end
	end
end






function PVPSound:OnEventTwo(event, ...)
	if PS_EnableAddon == true  then
		if PS_BattlegroundSound == true then
			if event == "UPDATE_UI_WIDGET" then


			--elseif event == "UPDATE_UI_WIDGET" then

				if MyZone == "Zone_WarsongGulch" or MyZone == "Zone_TwinPeaks" or MyZone == "Zone_TolBarad" then

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








				end
			elseif event == "PVP_MATCH_COMPLETE" then
				if MyZone == "Zone_SilvershardMines" or MyZone == "Zone_Wintergrasp" or MyZone == "Zone_CookingImpossible" or MyZone == "Zone_Ashran" or MyZone == "Zone_TheBattleforGilneas" or MyZone == "Zone_TarrenShore" or MyZone == "Zone_IsleofConquest"
				   or MyZone == "Zone_WarsongGulch" or MyZone == "Zone_EyeoftheStorm" or MyZone == "Zone_ArathiBasin" or MyZone == "Zone_AlteracValley" or MyZone == "Zone_TwinPeaks" or MyZone == "Zone_TempleofKotmogu" or MyZone == "Zone_SilvershardMines" or MyZone == "Zone_DeepwindGorge" or MyZone == "Zone_SeethingShore" then
					--for Wintergasp it only works in BG version, for BF version there are old methdos
					local winner = ...
					print(winner)
					if winner == 0 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HordeWins.mp3")
					elseif winner == 1 then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\AllianceWins.mp3")
					else
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\HumiliatingDefeat.mp3")
					end
					BgIsOver = true
					PVPSound:ClearPaybackQueue()
					PVPSound:ClearRetributionQueue()
				elseif MyZone == "Zone_Arenas" then
					local winner = ...
					local myFaction = GetBattlefieldArenaFaction()
					if winner == myFaction then
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\YouHaveWonTheMatch.mp3")
					else
						PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\YouHaveLostTheMatch.mp3")
					end
					BgIsOver = true
					PVPSound:ClearPaybackQueue()
					PVPSound:ClearRetributionQueue()
				end


			end
		end
	end
end




