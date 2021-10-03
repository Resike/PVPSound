local addon, ns = ...
local PVPSound = ns.PVPSound
local PS = ns.PS
local L = ns.L

local API = PVPSound.API
local mod = API:RegisterMod(1478, "pvp", "Ashran", 1191)

local MyZone = "Zone_Ashran" -- I don't want to rewrite some code here, so I use this

--------------------------------------------------
-- on event functions ----------------------------

function mod:PVP_MATCH_COMPLETE(event, winner)
	API:AnnounceWinner("BG", winner)
	mod:Unload()
end

--------------------------------------------------
-- module start and end poins --------------------
function mod:Initialize()
	API.RegisterEvent(self, "PVP_MATCH_COMPLETE")
	if not self.loaded then
		API:Announce("BG")
	end
	PS.PaybackKillTime = 120
	self.loaded = true
end

function mod:Unload()
	PS.PaybackKillTime = 90
	API:UnregisterEvent("PVP_MATCH_COMPLETE")
	self.loaded = false
end
