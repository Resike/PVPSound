local addon, ns = ...
local PVPSound = ns.PVPSound

local API = PVPSound.API
local mod = API:RegisterMod(-1, "arena", "Arenas", nil)

--------------------------------------------------
-- Resourses----------------------------------

--arena UI WIDGET IDs array. For arena timers
--Each arena has its unique topcenter widget with timeremaining info
--So, I pass thruogh this array until existing arena widget will be found
local arenaUI = {NagrandOld = 742, NagrandLegion = 920, BladesEdge = 740, BladesEdgeLegion = 929, RuinsOfLordaeron = 745, DalaranArena = 741,
				TheRingOfValor = 743, TigersPeak = 738, ShadopanLegion = 925, BlackrookHoldArena = 905, ValsharahArena = 902, TolvirArena = 744,
				HookPoint = 1147, Mugambala = 1144, Robodrome = 2069, BastionArena = 2946}

-- Initialize timer for time remaining
local function InitTimer()
	API:ResetTimers()
	--there will be two timers, because we initialize BGs twice: on entering world and on zone change
     --delay needed cause UI WIDGETS update occures later then entering wold or zone changing
     C_Timer.After(2, function ()
         for _, v in pairs(arenaUI) do
             --print("arena ")
             if API:TimeRemaining_check(v) then
                 break
             end
         end
     end)
end

--------------------------------------------------
-- on event functions ----------------------------
function mod:PVP_MATCH_COMPLETE(event, winner)
	API:AnnounceWinner("Arena", winner)
	mod:Unload()
end
--------------------------------------------------
-- module start and end poins --------------------
function mod:Initialize()
    API.RegisterEvent(self, "PVP_MATCH_COMPLETE")
	if not self.loaded then
		API:Announce("Arena")
	end
	InitTimer()
	self.loaded = true
end

function mod:Unload()
    API:UnregisterEvent("PVP_MATCH_COMPLETE")
    API:StopTimers()
	self.loaded = false
end
