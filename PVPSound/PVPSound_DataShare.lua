local addon, ns = ...
local PVPSound = ns.PVPSound
local L = ns.L

local PVPSoundDataFrame = CreateFrame("Frame", nil)
PVPSoundDataFrame:RegisterEvent("ADDON_LOADED")

function PVPSound:DataOnLoad()
	if PS_EnableAddon then
		PVPSoundDataFrame:RegisterEvent("CHAT_MSG_ADDON")
		PVPSoundDataFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	end
end

function PVPSound:RegisterDataEvents()
	if not PS_DataShare then
		return
	end

	PVPSoundDataFrame:RegisterEvent("CHAT_MSG_ADDON")
	PVPSoundDataFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
end

function PVPSound:UnregisterDataEvents()
	PVPSoundDataFrame:UnregisterEvent("CHAT_MSG_ADDON")
	PVPSoundDataFrame:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
end

-- Sprees
local DeathSpree

-- Names
local SenderName
local KillerName
local KillerNameServer

local print, select, tostring, string = print, select, tostring, string

local UnitName = UnitName

-- PVPSound Addon Data Sharing
function PVPSound:DataOnEvent(event, prefix, message, channel, sender, ...)
	if PS_DataShare then
		if event == "ADDON_LOADED" then
			local Addon = select(1, ...)
			if Addon == "PVPSound" then
				if PS_EnableAddon then
					PVPSound:DataOnLoad()
				end
			end
		end

		if event == "CHAT_MSG_ADDON" then
			-- If the Sent Data is from the registered prefix
			if prefix == "PVPSound" then
				-- If the sender is not nil and its not the player
				if sender ~= nil and sender ~= UnitName("player") then
					-- If the message is not nil
					if message ~= nil then
						-- Death Data Share
						if string.find(message, ":") then
							DeathSpree = tostring(string.match(message, "(.+):"))
							KillerNameServer = tostring(string.match(message, ":(.+)"))
							if KillerNameServer ~= nil then
								-- If the killer is NPC
								if string.sub(KillerNameServer, - 1) == "!" then
									KillerName = KillerNameServer
								 -- If the killer is from CrossRealm
								else
									-- If not suicide
									if KillerNameServer ~= sender then
										if string.find(KillerNameServer, "-") and PS_HideServerName ~= false then
											KillerName = tostring(string.match(KillerNameServer, "(.+)-"))
											-- If from -Azjol-Nerub
											if string.find(KillerNameServer, "-") and PS_HideServerName ~= false then
												KillerName = tostring(string.match(KillerNameServer, "(.+)-"))
											end
										else
											KillerName = tostring(KillerNameServer)
										end
									end
								end
								if DeathSpree ~= nil then
									if KillerName ~= nil then
										-- If the killer is NPC
										if string.sub(KillerName, - 1) == "!" then
											KillerName = string.sub(KillerName, 1, string.len(KillerName) - 1)
											if SenderName ~= nil and DeathSpree ~= nil and KillerName ~= nil then
												PVPSound:PrintDeath(SenderName, DeathSpree, KillerName)
											end
										else
											-- If sender is from CrossRealm
											if string.find(sender, "-") and PS_HideServerName ~= false then
												SenderName = tostring(string.match(sender, "(.+)-"))
												-- If from -Azjol-Nerub
												if string.find(SenderName, "-") and PS_HideServerName ~= false then
													SenderName = tostring(string.match(SenderName, "(.+)-"))
													if SenderName ~= nil and DeathSpree ~= nil and KillerName ~= nil then
														PVPSound:PrintDeath(SenderName, DeathSpree, KillerName)
													end
												else
													if SenderName ~= nil and DeathSpree ~= nil and KillerName ~= nil then
														PVPSound:PrintDeath(SenderName, DeathSpree, KillerName)
													end
												end
											else
												SenderName = tostring(sender)
												if SenderName ~= nil and DeathSpree ~= nil and KillerName ~= nil then
													PVPSound:PrintDeath(SenderName, DeathSpree, KillerName)
												end
											end
										end
									end
								end
							end
						else
							-- Nil everything
							DeathSpree = nil
							SenderName = nil
							KillerName = nil
							KillerNameServer = nil
						end
					end
				end
			end
		elseif event == "ZONE_CHANGED_NEW_AREA" then
			-- Nil everything
			DeathSpree = nil
			SenderName = nil
			KillerName = nil
			KillerNameServer = nil
		end
	end
end

PVPSoundDataFrame:SetScript("OnEvent", PVPSound.DataOnEvent)

function PVPSound:PrintDeath(sender, message, killer)
	print("|cFFFF4500"..sender..L["'s"].." "..message.." "..L["was over by"].." "..killer..".|cFFFFFFFF")
end
