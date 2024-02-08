local addon, ns = ...
local PVPSound = ns.PVPSound
local PS = ns.PS
local L = ns.L

local API = PVPSound.API

local mod
if PS.isRetail then
	mod = API:RegisterMod(91, "pvp", "Alterac Valley", 30)
else
	mod = API:RegisterMod(1459, "pvp", "Alterac Valley", 30)
end

local mod_korrak = API:RegisterMod(1537, "pvp", "Korrak's Revenge")

local MyZone = "Zone_AlteracValley" -- I don't want to rewrite some code here, so I use this

--------------------------------------------------
-- AV Resourses and functions---------------------

-- AV POI objectives
local AVobjectives = {ColdtoothMine = nil, DunBaldarNorthBunker = nil, DunBaldarSouthBunker = nil, EastFrostwolfTower = nil, FrostwolfGraveyard = nil, FrostwolfReliefHut = nil, IcebloodGraveyard = nil, IcebloodTower = nil, IcewingBunker = nil, IrondeepMine = nil, SnowfallGraveyard = nil, StonehearthBunker = nil, StonehearthGraveyard = nil, StormpikeAidStation = nil, StormpikeGraveyard = nil, TowerPoint = nil, WestFrostwolfTower = nil}

-- objectives getter
local function AVget_objective(id)
	if id == 1102 or id == 1358 or id == 1359 or id == 6405 or id == 6428 or id == 6429 then --Hcontr -- Acontr -- Koboldcontr
		return "ColdtoothMine"
	elseif id == 1250 or id == 1352 or id == 1353 or id == 1354 or id == 6411 or id == 6422 or id == 6423 or id == 6424 then --Acontr --Destr --Aconfl --Hconfl
		return "DunBaldarNorthBunker"
	elseif id == 1249 or id == 1355 or id == 1356 or id == 1357 or id == 6410 or id == 6425 or id == 6426 or id == 6427 then --Acontr --Destr --Aconfl --Hconfl
		return "DunBaldarSouthBunker"
	elseif id == 1255 or id == 1362 or id == 1363 or id == 1364 or id == 6415 or id == 6430 or id == 6431 or id == 6432 then --Hcontr --Destr --Aconfl --Hconfl
		return "EastFrostwolfTower"
	elseif id == 1527 or id == 1528 or id == 1529 or id == 1530 or id == 6468 or id == 6469 or id == 6470 or id == 6471 then --Hcontr --Destr --Hconfl --Aconfl
		return "WestFrostwolfTower"
	elseif id == 1210 or id == 1368 or id == 1369 or id == 1370 or id == 6409 or id == 6433 or id == 6434 or id == 6435 then --Hcontr --Acontr --Aconfl --Hconfl
		return "FrostwolfGraveyard"
	elseif id == 1351 or id == 1371 or id == 1372 or id == 1373 or id == 6421 or id == 6336 or id == 6437 or id == 6438 then --Hcontr --Acontr --Hconfl --Aconfl
		return "FrostwolfReliefHut"
	elseif id == 1349 or id == 1374 or id == 1375 or id == 1376 or id == 6419 or id == 6439 or id == 6440 or id == 6441 then --Hcontr --Acontr --Aconfl --Hconfl
		return "IcebloodGraveyard"
	elseif id == 1252 or id == 1377 or id == 1378 or id == 1379 or id == 6413 or id == 6442 or id == 6443 or id == 6444 then --Hcontr --Destr --Hconfl --Aconfl
		return "IcebloodTower"
	elseif id == 1251 or id == 1380 or id == 1381 or id == 1382 or id == 6412 or id == 6445 or id == 6446 or id == 6447 then --Acontr --Destr --Aconfl --Hconfl
		return "IcewingBunker"
	elseif id == 1099 or id == 1383 or id == 1384 or id == 6402 or id == 6448 or id == 6449 then --Acontr -- Hcontr -- Troggcontr
		return "IrondeepMine"
	elseif id == 1209 or id == 1386 or id == 1387 or id == 1388 or id == 6408 or id == 6450 or id == 6451 or id == 6452 then --Hcontr --Acontr --Hconfl --Aconfl
		return "SnowfallGraveyard"
	elseif id == 1347 or id == 1389 or id == 1390 or id == 1391 or id == 6417 or id == 6453 or id == 6454 or id == 6455 then --Acontr --Destr --Aconfl --Hconfl
		return "StonehearthBunker"
	elseif id == 1350 or id == 1392 or id == 1393 or id == 1394 or id == 6420 or id == 6456 or id == 6457 or id == 6458 then --Acontr --Hcontr --Aconfl --Hconfl
		return "StonehearthGraveyard"
	elseif id == 1348 or id == 1395 or id == 1396 or id == 1397 or id == 6418 or id == 6459 or id == 6460 or id == 6461 then --Acontr --Hcontr --Aconfl --Hconfl
		return "StormpikeAidStation"
	elseif id == 1208 or id == 1398 or id == 1399 or id == 1400 or id == 6407 or id == 6462 or id == 6463 or id == 6464 then --Acontr --Hcontr --Aconfl --Hconfl
		return "StormpikeGraveyard"
	elseif id == 1254 or id == 1405 or id == 1406 or id == 1407 or id == 6414 or id == 6465 or id == 6466 or id == 6467 then --Hcontr --Destr --Hconfl --Aconfl
		return "TowerPoint"
	else
		return false
	end
end

--State can be checked by textures in each POI, but it's one more function to call.
--Here we only work with POI array. But negative side is that we need to check too many IDs for each return
local function AVobj_state(id)
	if id == 1358 or id == 1250 or id == 1249 or id == 1368 or id == 1371 or id == 1374 or id == 1251 or id == 1099 or id == 1386 or id == 1347 or id == 1350 or id == 1348 or id == 1208 or id == 6428 or id == 6411 or id == 6410 or id == 6409 or id == 6421 or id == 6419 or id == 6412 or id == 6402 or id == 6450 or id == 6417 or id == 6420 or id == 6418 or id == 6407 then
		return 1 -- Alliance Bases
	elseif id == 1102 or id == 1255 or id == 1527 or id == 1210 or id == 1351 or id == 1349 or id == 1252 or id == 1383 or id == 1209 or id == 1392 or id == 1395 or id == 1398 or id == 1254 or id == 6405 or id == 6415 or id == 6468 or id == 6409 or id == 6421 or id == 6419 or id == 6413 or id == 6448 or id == 6408 or id == 6456 or id == 6459 or id == 6462 or id == 6414 then
		return 2 -- Horde Bases
	elseif id == 1353 or id == 1356 or id == 1363 or id == 1530 or id == 1369 or id == 1373 or id == 1375 or id == 1379 or id == 1381 or id == 1388 or id == 1390 or id == 1393 or id == 1396 or id == 1399 or id == 1407 or id == 6423 or id == 6426 or id == 6431 or id == 6471 or id == 6434 or id == 6438 or id == 6440 or id == 6444 or id == 6446 or id == 6452 or id == 6454 or id == 6457 or id == 6460 or id == 6463 or id == 6467 then
		return 3 -- Alliance trys to capture
	elseif id == 1354 or id == 1357 or id == 1364 or id == 1529 or id == 1370 or id == 1372 or id == 1376 or id == 1378 or id == 1382 or id == 1387 or id == 1391 or id == 1394 or id == 1397 or id == 1400 or id == 1406 or id == 6424 or id == 6427 or id == 6432 or id == 6470 or id == 6435 or id == 6437 or id == 6441 or id == 6443 or id == 6447 or id == 6451 or id == 6455 or id == 6458 or id == 6461 or id == 6464 or id == 6466 then
		return 4 -- Horde trys to capture
	elseif id == 1352 or id == 1355 or id == 1362 or id == 1528 or id == 1377 or id == 1380 or id == 1389 or id == 1405 or id == 6422 or id == 6425 or id == 6430 or id == 6469 or id == 6442 or id == 6445 or id == 6453 or id == 6465 then
		return 5 -- Destoryed Bunker/Tower
	elseif id == 1359 or id == 1384 or id == 6429 or id == 6449 then
		return 6 -- Uncontrolled
	else
		return 0
	end
end

-- Alliance Reinforcements
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

-- Horde Reinforcements
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

-- A and H reinforcements initialization
local function InitReinforcements()
	local AReinforcementsInit = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1684) and C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1684).leftBarValue
	local HReinforcementsInit = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1684) and C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1684).rightBarValue
	AVandIOCAobjectives.AllianceReinforcements = nil
	AVandIOCHobjectives.HordeReinforcements = nil
	AVandIOCAobjectives.AllianceReinforcements = AReinforcementsInit
	AVandIOCHobjectives.HordeReinforcements = HReinforcementsInit
end

local function FreeResourses()
	AVobjectives = {ColdtoothMine = nil, DunBaldarNorthBunker = nil, DunBaldarSouthBunker = nil, EastFrostwolfTower = nil, FrostwolfGraveyard = nil, FrostwolfReliefHut = nil, IcebloodGraveyard = nil, IcebloodTower = nil, IcewingBunker = nil, IrondeepMine = nil, SnowfallGraveyard = nil, StonehearthBunker = nil, StonehearthGraveyard = nil, StormpikeAidStation = nil, StormpikeGraveyard = nil, TowerPoint = nil, WestFrostwolfTower = nil}
	AVandIOCAobjectives = {AllianceReinforcements = nil}
	AVandIOCHobjectives = {HordeReinforcements = nil}
end

--------------------------------------------------
-- on event functions ----------------------------

function mod:AREA_POIS_UPDATED()
	local CurrentZoneId = self.zoneId
	local POIs = C_AreaPoiInfo.GetAreaPOIForMap(CurrentZoneId)

	for i = 1, #POIs do

		local type = AVget_objective(POIs[i])
		if type then
			--bunker/tower
			if string.find(type, "Tower") or string.find(type, "Bunker") then

				if AVobj_state(AVobjectives[type]) == 4 and AVobj_state(POIs[i]) == 1 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Defense.mp3")
				elseif AVobj_state(AVobjectives[type]) == 1 and AVobj_state(POIs[i]) == 4 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Offense.mp3")
				elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(POIs[i]) == 5 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Destroyed.mp3")
				elseif AVobj_state(AVobjectives[type]) == 3 and AVobj_state(POIs[i]) == 2 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Defense.mp3")
				elseif AVobj_state(AVobjectives[type]) == 2 and AVobj_state(POIs[i]) == 3 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_TowerNode_Offense.mp3")
				elseif AVobj_state(AVobjectives[type]) == 3 and AVobj_state(POIs[i]) == 5 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_TowerNode_Destroyed.mp3")
				end

			--mines
			elseif string.find(type, "Mine") then
				if AVobj_state(AVobjectives[type]) == 6 and AVobj_state(POIs[i]) == 1 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
				elseif AVobj_state(AVobjectives[type]) == 6 and AVobj_state(POIs[i]) == 2 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
				elseif AVobj_state(AVobjectives[type]) == 2 and AVobj_state(POIs[i]) == 1 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
				elseif AVobj_state(AVobjectives[type]) == 1 and AVobj_state(POIs[i]) == 2 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
				end
			--graveyards
			else
				if AVobj_state(AVobjectives[type]) == 3 and AVobj_state(POIs[i]) == 1 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
				elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(POIs[i]) == 2 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
				elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(POIs[i]) == 1 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Defense.mp3")
				elseif AVobj_state(AVobjectives[type]) == 3 and AVobj_state(POIs[i]) == 2 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Defense.mp3")
				elseif AVobj_state(AVobjectives[type]) == 1 and AVobj_state(POIs[i]) == 4 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Offense.mp3")
				elseif AVobj_state(AVobjectives[type]) == 2 and AVobj_state(POIs[i]) == 3 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Offense.mp3")
				elseif AVobj_state(AVobjectives[type]) == 3 and AVobj_state(POIs[i]) == 4 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Node_Offense.mp3")
				elseif AVobj_state(AVobjectives[type]) == 4 and AVobj_state(POIs[i]) == 3 then
					PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Node_Offense.mp3")
				end
			end
			AVobjectives[type] = POIs[i]
		end
	end
end
mod_korrak.AREA_POIS_UPDATED = mod.AREA_POIS_UPDATED

function mod:UPDATE_UI_WIDGET()
	-- Alliance Reinforcements
	if (C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1684)) then
		local textureIndex = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1684).leftBarValue
		local type = AVandIOCAget_objective(textureIndex)
		if type then
			if AVandIOCAobj_state(AVandIOCAobjectives[type]) == 11 and AVandIOCAobj_state(textureIndex) == 10 then
				PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\TenKillsRemain.mp3")
			elseif AVandIOCAobj_state(AVandIOCAobjectives[type]) == 6 and AVandIOCAobj_state(textureIndex) == 5 then
				PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\FiveKillsRemain.mp3")
			elseif AVandIOCAobj_state(AVandIOCAobjectives[type]) == 2 and AVandIOCAobj_state(textureIndex) == 1 then
				PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\OneKillRemains.mp3")
			end
			AVandIOCAobjectives[type] = textureIndex
		end
	-- Horde Reinforcements
		textureIndex = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(1684).rightBarValue
		type = AVandIOCHget_objective(textureIndex)
		if type then
			if AVandIOCHobj_state(AVandIOCHobjectives[type]) == 11 and AVandIOCHobj_state(textureIndex) == 10 then
				PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\TenKillsRemain.mp3")
			elseif AVandIOCHobj_state(AVandIOCHobjectives[type]) == 6 and AVandIOCHobj_state(textureIndex) == 5 then
				PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\FiveKillsRemain.mp3")
			elseif AVandIOCHobj_state(AVandIOCHobjectives[type]) == 2 and AVandIOCHobj_state(textureIndex) == 1 then
				PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\CountDown\\OneKillRemains.mp3")
			end
			AVandIOCHobjectives[type] = textureIndex
		end
	end
end
mod_korrak.UPDATE_UI_WIDGET = mod.UPDATE_UI_WIDGET

function mod:PVP_MATCH_COMPLETE(event, winner)
	API:AnnounceWinner("BG", winner)
	self:Unload()
end
mod_korrak.PVP_MATCH_COMPLETE = mod.PVP_MATCH_COMPLETE

local function PVP_MATCH_COMPLETE_CLASSIC(event, message)
	PVPSound:Debug(event..message)
	if string.find(message, L["Alliance wins"]) or string.find(message, L["Alliance wins secondary"]) or string.find(message, L["The Alliance is victorious"])  then
		API:AnnounceWinner("BG", 1)
		mod:Unload()
	elseif string.find(message, L["Horde wins"]) or string.find(message, L["Horde wins secondary"]) or string.find(message, L["The Horde is victorious"]) then
		API:AnnounceWinner("BG", 0)
		mod:Unload()
	end
end

--------------------------------------------------
-- module start and end poins --------------------
function mod:Initialize()
	if PS.isRetail then
		API.RegisterEvent(self, "PVP_MATCH_COMPLETE")
	else
		API.RegisterEvent(self, "CHAT_MSG_MONSTER_YELL", PVP_MATCH_COMPLETE_CLASSIC)
	end
	API.RegisterEvent(self, "AREA_POIS_UPDATED")
	API.RegisterEvent(self, "UPDATE_UI_WIDGET")
	if not self.loaded then
		API:Announce("BG")
	end
	PS.PaybackKillTime = 120
	InitReinforcements()
	API:ObjInit(self.zoneId, AVobjectives, AVget_objective)
	self.loaded = true
end
mod_korrak.Initialize = mod.Initialize

function mod:Unload()
	PS.PaybackKillTime = 90
	if PS.isRetail then
		API:UnregisterEvent("PVP_MATCH_COMPLETE")
	else
		API.UnregisterEvent("CHAT_MSG_MONSTER_YELL")
	end
	API:UnregisterEvent("AREA_POIS_UPDATED")
	API:UnregisterEvent("UPDATE_UI_WIDGET")
	FreeResourses()
	self.loaded = false
end
mod_korrak.Unload = mod.Unload
