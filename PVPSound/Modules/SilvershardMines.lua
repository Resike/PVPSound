local addon, ns = ...
local PVPSound = ns.PVPSound
local PS = ns.PS
local L = ns.L

local API = PVPSound.API
local mod = API:RegisterMod(423, "pvp", "Silvershard Mines", 727)

local MyZone = "Zone_SilvershardMines" -- I don't want to rewrite some code here, so I use this

--------------------------------------------------
-- on event functions ----------------------------

function mod:CHAT_MSG_BG_SYSTEM_ALLIANCE(event, EventMessage)
	if string.find(EventMessage, L["captured"]) then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\ALLIANCE_Scores.mp3")
	end
end

function mod:CHAT_MSG_BG_SYSTEM_HORDE(event, EventMessage)
	if string.find(EventMessage, L["captured"]) then
		PVPSound:AddToQueue(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\"..MyZone.."\\HORDE_Scores.mp3")
	end
end

function mod:PVP_MATCH_COMPLETE(event, winner)
	API:AnnounceWinner("BG", winner)
	mod:Unload()
end

--------------------------------------------------
-- module start and end poins --------------------
function mod:Initialize()
	API.RegisterEvent(self, "CHAT_MSG_BG_SYSTEM_ALLIANCE")
	API.RegisterEvent(self, "CHAT_MSG_BG_SYSTEM_HORDE")
	API.RegisterEvent(self, "PVP_MATCH_COMPLETE")
	if not self.loaded then
		API:Announce("BG")
	end
	self.loaded = true
end

function mod:Unload()
	API:UnregisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE")
	API:UnregisterEvent("CHAT_MSG_BG_SYSTEM_HORDE")
	API:UnregisterEvent("PVP_MATCH_COMPLETE")
	self.loaded = false
end
