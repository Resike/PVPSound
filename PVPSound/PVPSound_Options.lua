local addon, ns = ...
local PVPSound = ns.PVPSound
local PVPSoundOptions = ns.PVPSoundOptions
local PS = ns.PS
local L = ns.L

local font = GameFontWhiteSmall

function PVPSoundOptions:OptionsAddonIsLoaded()
	PVPSoundOptions:OptionsInitalize(PVPSoundOptionsFrame)
	PVPSoundOptions:OptionsUpdateLocalization()
	PVPSoundOptions:OptionsUpdateFonts()
	PVPSoundOptions:OptionsSetSoundPackLocalizations()
end

function PVPSoundOptions:OptionsInitalize(self)
	-- Slash Commands
	SlashCmdList["PVPSound"] = function(msg)
		PVPSound:SlashCommands(msg)
	end
	SLASH_PVPSound1 = "/ps"
	SLASH_PVPSound2 = "/pvpsound"
	self:SetBackdropColor(0.1, 0.1, 0.1)
	self:SetBackdropBorderColor(0.9, 1.0, 0.9)
	PVPSoundOptionsHeader:SetText("PVPSound "..GetAddOnMetadata("PVPSound", "Version"))
	PVPSoundOptions:OptionsInitalizeButtons()
	tinsert(UISpecialFrames, self:GetName())
end

function PVPSoundOptions:OptionsTabFramesInitalize(self)
	self:SetBackdropColor(0.1, 0.1, 0.1)
	self:SetBackdropBorderColor(0.0, 0.0, 0.0)
end

function PVPSoundOptions:OptionsTabInitalize(self, width)
	PanelTemplates_DeselectTab(self)
	PanelTemplates_TabResize(self, width)
	getglobal(self:GetName().."HighlightTexture"):SetWidth(self:GetTextWidth() + 28)
end

function PVPSoundOptions:OptionsSetText(self, postfix, text)
	PVPSound:SetAddonLanguage()
	local name = self:GetName()
	local frame
	if postfix == nil or postfix == "" then
		frame = getglobal(name)
	else
		frame = getglobal(name..postfix)
	end
	frame:SetText(L[text])
end

function PVPSoundOptions:OptionsShowToopTip(self, text)
	PVPSoundGameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 18, 18)
	PVPSoundGameTooltip:SetText(L[text], nil, nil, nil, nil, 1)
end

function PVPSoundOptions:OptionsToggleMenu()
	PVPSoundOptions:OptionsInitalizeButtons()
	if (PVPSoundOptionsFrame:IsVisible()) then
		PVPSoundOptionsFrame:Hide()
	else
		PVPSoundOptionsFrame:Show()
	end
end

function PVPSoundOptions:OptionsInitalizeButtons()
	PVPSoundOptions:OptionsEnableAddonButtonInitalize(PVPSoundEnableAddonButton)
	PVPSoundOptions:OptionsKillSoundButtonInitalize(PVPSoundKillSoundButton)
	PVPSoundOptions:OptionsMultiKillSoundButtonInitalize(PVPSoundMultiKillSoundButton)
end

function PVPSoundOptions:OptionsStartMoving(self, button)
	if button == "LeftButton" then
		self:StartMoving()
	end
end

function PVPSoundOptions:OptionsStopMoving(self, button)
	self:StopMovingOrSizing()
end

function PVPSoundOptions:OptionsTabActive(active, all)
	PlaySound("igCharacterInfoTab", PS_Channel)
	for i = 1, all do
		if i == active then
			getglobal("PVPSoundTab"..i.."Frame"):Show()
			PVPSoundOptions:OptionsPanelTemplatesSelectTab(getglobal("PVPSoundTab"..i))
		else
			getglobal("PVPSoundTab"..i.."Frame"):Hide()
			PVPSoundOptions:OptionsPanelTemplatesDeselectTab(getglobal("PVPSoundTab"..i))
		end
	end
end

function PVPSoundOptions:OptionsPanelTemplatesSelectTab(tab)
	local name = tab:GetName()
	_G[name.."Left"]:Hide()
	_G[name.."Middle"]:Hide()
	_G[name.."Right"]:Hide()
	tab:Disable()
	_G[name.."Text"]:SetPoint("CENTER", tab, "CENTER", (tab.selectedTextX or 0), (tab.selectedTextY or - 3))
	_G[name.."LeftDisabled"]:Show()
	_G[name.."MiddleDisabled"]:Show()
	_G[name.."RightDisabled"]:Show()
	if (PVPSoundGameTooltip:IsOwned(tab)) then
		PVPSoundGameTooltip:Hide()
	end
end

function PVPSoundOptions:OptionsPanelTemplatesDeselectTab(tab)
	local name = tab:GetName()
	_G[name.."Left"]:Show()
	_G[name.."Middle"]:Show()
	_G[name.."Right"]:Show()
	tab:Enable()
	_G[name.."Text"]:SetPoint("CENTER", tab, "CENTER", (tab.deselectedTextX or 0), (tab.deselectedTextY or 2))
	_G[name.."LeftDisabled"]:Hide()
	_G[name.."MiddleDisabled"]:Hide()
	_G[name.."RightDisabled"]:Hide()
end

function PVPSoundOptions:OptionsEnableAddonButtonInitalize(self)
	if PS_EnableAddon == true then
		self:SetChecked(true)
	else
		self:SetChecked(false)
	end
end

function PVPSoundOptions:OptionsEnableAddonButtonToggle(self)
	if self:GetChecked() then
		PS_EnableAddon = true
		PVPSound:RegisterEvents()
		PVPSound:RegisterDataEvents()
		PVPSoundKillSoundButton:Enable()
		PVPSoundKillSoundButtonText:SetTextColor(1, 1, 1)
		PVPSoundMultiKillSoundButton:Enable()
		PVPSoundMultiKillSoundButtonText:SetTextColor(1, 1, 1)
		UIDropDownMenu_EnableDropDown(PVPSoundKillSoundPackDropDown)
		UIDropDownMenu_EnableDropDown(PVPSoundKillSoundPackLanguageDropDown)
		UIDropDownMenu_EnableDropDown(PVPSoundSoundPackDropDown)
		UIDropDownMenu_EnableDropDown(PVPSoundSoundPackLanguageDropDown)
		UIDropDownMenu_EnableDropDown(PVPSoundSoundChannelDropDown)
		UIDropDownMenu_EnableDropDown(PVPSoundModeDropDown)
	else
		PS_EnableAddon = false
		PVPSound:UnregisterEvents()
		PVPSound:UnregisterDataEvents()
		PVPSoundKillSoundButton:Disable()
		PVPSoundKillSoundButtonText:SetTextColor(0.5, 0.5, 0.5)
		PVPSoundMultiKillSoundButton:Disable()
		PVPSoundMultiKillSoundButtonText:SetTextColor(0.5, 0.5, 0.5)
		UIDropDownMenu_DisableDropDown(PVPSoundKillSoundPackDropDown)
		UIDropDownMenu_DisableDropDown(PVPSoundKillSoundPackLanguageDropDown)
		UIDropDownMenu_DisableDropDown(PVPSoundSoundPackDropDown)
		UIDropDownMenu_DisableDropDown(PVPSoundSoundPackLanguageDropDown)
		UIDropDownMenu_DisableDropDown(PVPSoundSoundChannelDropDown)
		UIDropDownMenu_DisableDropDown(PVPSoundModeDropDown)
	end
	--print(PS_EnableAddon)
end

function PVPSoundOptions:OptionsKillSoundButtonInitalize(self)
	if PVPSoundEnableAddonButton:GetChecked() then
		self:Enable()
		PVPSoundKillSoundButtonText:SetTextColor(1, 1, 1)
	else
		self:Disable()
		PVPSoundKillSoundButtonText:SetTextColor(0.5, 0.5, 0.5)
	end
	if PS_KillSound == true then
		self:SetChecked(true)
	else
		self:SetChecked(false)
	end
end

function PVPSoundOptions:OptionsKillSoundButtonToggle(self)
	if self:GetChecked() then
		PS_KillSound = true
	else
		PS_KillSound = false
	end
	--print(PS_KillSound)
end

function PVPSoundOptions:OptionsMultiKillSoundButtonInitalize(self)
	if PVPSoundEnableAddonButton:GetChecked() then
		self:Enable()
		PVPSoundMultiKillSoundButtonText:SetTextColor(1, 1, 1)
	else
		self:Disable()
		PVPSoundMultiKillSoundButtonText:SetTextColor(0.5, 0.5, 0.5)
	end
	if PS_MultiKillSound == true then
		self:SetChecked(true)
	else
		self:SetChecked(false)
	end
end

function PVPSoundOptions:OptionsMultiKillSoundButtonToggle(self)
	if self:GetChecked() then
		PS_MultiKillSound = true
	else
		PS_MultiKillSound = false
	end
	--print(PS_MultiKillSound)
end

function PVPSoundOptions.OptionsDropDownMenuInitialize(self)
	local info = UIDropDownMenu_CreateInfo()
	local name = self:GetName()
	if name == "PVPSoundKillSoundPackDropDown" then
		UIDropDownMenu_SetWidth(self, 164)
		PVPSoundOptions:OptionsSetKillSoundPack()
		if PVPSoundEnableAddonButton:GetChecked() then
			UIDropDownMenu_EnableDropDown(PVPSoundKillSoundPackDropDown)
		else
			UIDropDownMenu_DisableDropDown(PVPSoundKillSoundPackDropDown)
		end
		PVPSoundOptions:OptionsSetKillSoundPackText(self)
		info.text = L["Devil May Cry"]
		info.fontObject = font
		if PS_KillSoundPackName == "DevilMayCry" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsKillSoundPack(name, "DevilMayCry")
		end
		UIDropDownMenu_AddButton(info)
		info.text = L["Dota 2"]
		info.fontObject = font
		if PS_KillSoundPackName == "Dota2" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsKillSoundPack(name, "Dota2")
		end
		UIDropDownMenu_AddButton(info)
		info.text = L["Halo 4"]
		info.fontObject = font
		if PS_KillSoundPackName == "Halo4" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsKillSoundPack(name, "Halo4")
		end
		UIDropDownMenu_AddButton(info)
		info.text = L["Unreal Tournament 3"]
		info.fontObject = font
		if PS_KillSoundPackName == "UnrealTournament3" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsKillSoundPack(name, "UnrealTournament3")
		end
		UIDropDownMenu_AddButton(info)
		info.text = L["Custom"]
		info.fontObject = font
		if PS_KillSoundPackName == "Custom" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsKillSoundPack(name, "Custom")
		end
		UIDropDownMenu_AddButton(info)
	elseif name == "PVPSoundKillSoundPackLanguageDropDown" then
		UIDropDownMenu_SetWidth(self, 164)
		PVPSoundOptions:OptionsSetKillSoundPack()
		if PVPSoundEnableAddonButton:GetChecked() then
			UIDropDownMenu_EnableDropDown(PVPSoundKillSoundPackLanguageDropDown)
		else
			UIDropDownMenu_DisableDropDown(PVPSoundKillSoundPackLanguageDropDown)
		end
		PVPSoundOptions:OptionsSetKillSoundPackLanguageText(self)
		if PS_KillSoundPackName == "Custom" then
			info.text = L["Default"]
			info.fontObject = font
			if PS_KillSoundPackLanguage == "Default" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsKillSoundPackLanguage(name, "Default")
			end
			UIDropDownMenu_AddButton(info)
		elseif PS_KillSoundPackName == "DevilMayCry" then
			info.text = L["English"]
			info.fontObject = font
			if PS_KillSoundPackLanguage == "Eng" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsKillSoundPackLanguage(name, "Eng")
			end
			UIDropDownMenu_AddButton(info)
		elseif PS_KillSoundPackName == "Dota2" then
			info.text = L["Axe"]
			info.fontObject = font
			if PS_KillSoundPackLanguage == "Axe" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsKillSoundPackLanguage(name, "Axe")
			end
			UIDropDownMenu_AddButton(info)
			info.text = L["Bastion"]
			info.fontObject = font
			if PS_KillSoundPackLanguage == "Bastion" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsKillSoundPackLanguage(name, "Bastion")
			end
			UIDropDownMenu_AddButton(info)
			info.text = L["ClockWerk"]
			info.fontObject = font
			if PS_KillSoundPackLanguage == "ClockWerk" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsKillSoundPackLanguage(name, "ClockWerk")
			end
			UIDropDownMenu_AddButton(info)
			info.text = L["DefenseGrid"]
			info.fontObject = font
			if PS_KillSoundPackLanguage == "DefenseGrid" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsKillSoundPackLanguage(name, "DefenseGrid")
			end
			UIDropDownMenu_AddButton(info)
			info.text = L["Glados"]
			info.fontObject = font
			if PS_KillSoundPackLanguage == "Glados" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsKillSoundPackLanguage(name, "Glados")
			end
			UIDropDownMenu_AddButton(info)
			info.text = L["Juggernaut"]
			info.fontObject = font
			if PS_KillSoundPackLanguage == "Juggernaut" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsKillSoundPackLanguage(name, "Juggernaut")
			end
			UIDropDownMenu_AddButton(info)
			info.text = L["Lina"]
			info.fontObject = font
			if PS_KillSoundPackLanguage == "Lina" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsKillSoundPackLanguage(name, "Lina")
			end
			UIDropDownMenu_AddButton(info)
			info.text = L["NaturesProphet"]
			info.fontObject = font
			if PS_KillSoundPackLanguage == "NaturesProphet" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsKillSoundPackLanguage(name, "NaturesProphet")
			end
			UIDropDownMenu_AddButton(info)
			info.text = L["Pflax"]
			info.fontObject = font
			if PS_KillSoundPackLanguage == "Pflax" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsKillSoundPackLanguage(name, "Pflax")
			end
			UIDropDownMenu_AddButton(info)
			info.text = L["Pirate"]
			info.fontObject = font
			if PS_KillSoundPackLanguage == "Pirate" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsKillSoundPackLanguage(name, "Pirate")
			end
			UIDropDownMenu_AddButton(info)
			info.text = L["StanleyParable"]
			info.fontObject = font
			if PS_KillSoundPackLanguage == "StanleyParable" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsKillSoundPackLanguage(name, "StanleyParable")
			end
			UIDropDownMenu_AddButton(info)
			info.text = L["StormSpirit"]
			info.fontObject = font
			if PS_KillSoundPackLanguage == "StormSpirit" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsKillSoundPackLanguage(name, "StormSpirit")
			end
			UIDropDownMenu_AddButton(info)
			info.text = L["Trine"]
			info.fontObject = font
			if PS_KillSoundPackLanguage == "Trine" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsKillSoundPackLanguage(name, "Trine")
			end
			UIDropDownMenu_AddButton(info)
		elseif PS_KillSoundPackName == "Halo4" then
			info.text = L["English"]
			info.fontObject = font
			if PS_KillSoundPackLanguage == "Eng" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsKillSoundPackLanguage(name, "Eng")
			end
			UIDropDownMenu_AddButton(info)
		else
			info.text = L["English"]
			info.fontObject = font
			if PS_KillSoundPackLanguage == "Eng" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsKillSoundPackLanguage(name, "Eng")
			end
			UIDropDownMenu_AddButton(info)
			info.text = L["German"]
			info.fontObject = font
			if PS_KillSoundPackLanguage == "Deu" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsKillSoundPackLanguage(name, "Deu")
			end
			UIDropDownMenu_AddButton(info)
			info.text = L["Spanish"]
			info.fontObject = font
			if PS_KillSoundPackLanguage == "Esn" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsKillSoundPackLanguage(name, "Esn")
			end
			UIDropDownMenu_AddButton(info)
			info.text = L["French"]
			info.fontObject = font
			if PS_KillSoundPackLanguage == "Fra" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsKillSoundPackLanguage(name, "Fra")
			end
			UIDropDownMenu_AddButton(info)
			info.text = L["Italian"]
			info.fontObject = font
			if PS_KillSoundPackLanguage == "Ita" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsKillSoundPackLanguage(name, "Ita")
			end
			UIDropDownMenu_AddButton(info)
			info.text = L["Russian"]
			info.fontObject = font
			if PS_KillSoundPackLanguage == "Rus" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsKillSoundPackLanguage(name, "Rus")
			end
			UIDropDownMenu_AddButton(info)
		end
	elseif name == "PVPSoundSoundPackDropDown" then
		UIDropDownMenu_SetWidth(self, 164)
		PVPSoundOptions:OptionsSetSoundPack()
		if PVPSoundEnableAddonButton:GetChecked() then
			UIDropDownMenu_EnableDropDown(PVPSoundSoundPackDropDown)
		else
			UIDropDownMenu_DisableDropDown(PVPSoundSoundPackDropDown)
		end
		PVPSoundOptions:OptionsSetSoundPackText(self)
		info.text = L["Unreal Tournament 3"]
		info.fontObject = font
		if PS_SoundPackName == "UnrealTournament3" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsSoundPack(name, "UnrealTournament3")
		end
		UIDropDownMenu_AddButton(info)
		info.text = L["Custom"]
		info.fontObject = font
		if PS_SoundPackName == "Custom" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsSoundPack(name, "Custom")
		end
		UIDropDownMenu_AddButton(info)
	elseif name == "PVPSoundSoundPackLanguageDropDown" then
		UIDropDownMenu_SetWidth(self, 164)
		PVPSoundOptions:OptionsSetSoundPack()
		if PVPSoundEnableAddonButton:GetChecked() then
			UIDropDownMenu_EnableDropDown(PVPSoundSoundPackLanguageDropDown)
		else
			UIDropDownMenu_DisableDropDown(PVPSoundSoundPackLanguageDropDown)
		end
		PVPSoundOptions:OptionsSetSoundPackLanguageText(self)
		if PS_SoundPackLanguage == "Default" then
			info.text = L["Default"]
			info.fontObject = font
			if PS_SoundPackLanguage == "Default" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsSoundPackLanguage(name, "Default")
			end
			UIDropDownMenu_AddButton(info)
		else
			info.text = L["English"]
			info.fontObject = font
			if PS_SoundPackLanguage == "Eng" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsSoundPackLanguage(name, "Eng")
			end
			UIDropDownMenu_AddButton(info)
			info.text = L["German"]
			info.fontObject = font
			if PS_SoundPackLanguage == "Deu" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsSoundPackLanguage(name, "Deu")
			end
			UIDropDownMenu_AddButton(info)
			info.text = L["Spanish"]
			info.fontObject = font
			if PS_SoundPackLanguage == "Esn" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsSoundPackLanguage(name, "Esn")
			end
			UIDropDownMenu_AddButton(info)
			info.text = L["French"]
			info.fontObject = font
			if PS_SoundPackLanguage == "Fra" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsSoundPackLanguage(name, "Fra")
			end
			UIDropDownMenu_AddButton(info)
			info.text = L["Italian"]
			info.fontObject = font
			if PS_SoundPackLanguage == "Ita" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsSoundPackLanguage(name, "Ita")
			end
			UIDropDownMenu_AddButton(info)
			info.text = L["Russian"]
			info.fontObject = font
			if PS_SoundPackLanguage == "Rus" then
				info.checked = true
			else
				info.checked = false
			end
			info.func = function(self)
				PVPSoundOptions:OptionsSoundPackLanguage(name, "Rus")
			end
			UIDropDownMenu_AddButton(info)
		end
	elseif name == "PVPSoundSoundChannelDropDown" then
		UIDropDownMenu_SetWidth(self, 164)
		if PVPSoundEnableAddonButton:GetChecked() then
			UIDropDownMenu_EnableDropDown(PVPSoundSoundChannelDropDown)
		else
			UIDropDownMenu_DisableDropDown(PVPSoundSoundChannelDropDown)
		end
		PVPSoundOptions:OptionsSetSoundChannelText(self)
		info.text = L["Master"]
		info.fontObject = font
		if PS_Channel == "Master" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsSoundChannel(name, "Master")
		end
		UIDropDownMenu_AddButton(info)
		info.text = L["Sound"]
		info.fontObject = font
		if PS_Channel == "Sound" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsSoundChannel(name, "Sound")
		end
		UIDropDownMenu_AddButton(info)
		info.text = L["Music"]
		info.fontObject = font
		if PS_Channel == "Music" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsSoundChannel(name, "Music")
		end
		UIDropDownMenu_AddButton(info)
		info.text = L["Ambience"]
		info.fontObject = font
		if PS_Channel == "Ambience" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsSoundChannel(name, "Ambience")
		end
		UIDropDownMenu_AddButton(info)
	elseif name == "PVPSoundModeDropDown" then
		UIDropDownMenu_SetWidth(self, 164)
		if PVPSoundEnableAddonButton:GetChecked() then
			UIDropDownMenu_EnableDropDown(PVPSoundModeDropDown)
		else
			UIDropDownMenu_DisableDropDown(PVPSoundModeDropDown)
		end
		PVPSoundOptions:OptionsSetModeText(self)
		info.text = L["PVP"]
		info.fontObject = font
		if PS_Mode == "PVP" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsMode(name, "PVP")
		end
		UIDropDownMenu_AddButton(info)
		info.text = L["PVE"]
		info.fontObject = font
		if PS_Mode == "PVE" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsMode(name, "PVE")
		end
		UIDropDownMenu_AddButton(info)
		info.text = L["PVP and PVE"]
		info.fontObject = font
		if PS_Mode == "PVPandPVE" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsMode(name, "PVPandPVE")
		end
		UIDropDownMenu_AddButton(info)
	elseif name == "PVPSoundLanguageDropDown" then
		UIDropDownMenu_SetWidth(self, 164)
		PVPSoundOptions:OptionsSetAddonLanguageText(self)
		PVPSound:SetAddonLanguage()
		info.text = "English"
		info.fontObject = GameFontWhiteSmall
		if PS_AddonLanguage == "English" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsAddonLanguage(name, "English")
		end
		UIDropDownMenu_AddButton(info)
		info.text = "German"
		info.fontObject = GameFontWhiteSmall
		if PS_AddonLanguage == "German" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsAddonLanguage(name, "German")
		end
		UIDropDownMenu_AddButton(info)
		info.text = "Español"
		info.fontObject = GameFontWhiteSmall
		if PS_AddonLanguage == "Spanish" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsAddonLanguage(name, "Spanish")
		end
		UIDropDownMenu_AddButton(info)
		info.text = "El español de América"
		info.fontObject = GameFontWhiteSmall
		if PS_AddonLanguage == "LatinAmericanSpanish" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsAddonLanguage(name, "LatinAmericanSpanish")
		end
		UIDropDownMenu_AddButton(info)
		info.text = "Français"
		info.fontObject = GameFontWhiteSmall
		if PS_AddonLanguage == "French" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsAddonLanguage(name, "French")
		end
		UIDropDownMenu_AddButton(info)
		info.text = "Italiano"
		info.fontObject = GameFontWhiteSmall
		if PS_AddonLanguage == "Italian" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsAddonLanguage(name, "Italian")
		end
		UIDropDownMenu_AddButton(info)
		info.text = "한국의"
		info.fontObject = GameFontNormalSmallLeft_KO
		if PS_AddonLanguage == "Korean" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsAddonLanguage(name, "Korean")
		end
		UIDropDownMenu_AddButton(info)
		info.text = "Português"
		info.fontObject = GameFontWhiteSmall
		if PS_AddonLanguage == "Portuguese" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsAddonLanguage(name, "Portuguese")
		end
		UIDropDownMenu_AddButton(info)
		info.text = "Русский"
		info.fontObject = GameFontNormalSmallLeft_RU
		if PS_AddonLanguage == "Russian" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsAddonLanguage(name, "Russian")
		end
		UIDropDownMenu_AddButton(info)
		info.text = "简体中国"
		info.fontObject = GameFontNormalSmallLeft_ZH
		if PS_AddonLanguage == "SimplifiedChinese" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsAddonLanguage(name, "SimplifiedChinese")
		end
		UIDropDownMenu_AddButton(info)
		info.text = "繁體中文"
		info.fontObject = GameFontNormalSmallLeft_ZH
		if PS_AddonLanguage == "TraditionalChinese" then
			info.checked = true
		else
			info.checked = false
		end
		info.func = function(self)
			PVPSoundOptions:OptionsAddonLanguage(name, "TraditionalChinese")
		end
		UIDropDownMenu_AddButton(info)
	end
end

-- Sound Packs
function PVPSoundOptions:OptionsSetKillSoundPackText(self)
	if PS_KillSoundPackName == "DevilMayCry" then
		UIDropDownMenu_SetText(self, L["Devil May Cry"])
	elseif PS_KillSoundPackName == "Dota2" then
		UIDropDownMenu_SetText(self, L["Dota 2"])
	elseif PS_KillSoundPackName == "Halo4" then
		UIDropDownMenu_SetText(self, L["Halo 4"])
	elseif PS_KillSoundPackName == "UnrealTournament3" then
		UIDropDownMenu_SetText(self, L["Unreal Tournament 3"])
	elseif PS_KillSoundPackName == "Custom" then
		UIDropDownMenu_SetText(self, L["Custom"])
	end
end

function PVPSoundOptions:OptionsKillSoundPack(name, soundpackname)
	local frame = getglobal(name)
	if soundpackname == "Dota2" then
		PVPSoundOptions:OptionsSetText(PVPSoundKillSoundPackLanguageDropDown, "Label", "Kill Sound Pack Type")
	else
		PVPSoundOptions:OptionsSetText(PVPSoundKillSoundPackLanguageDropDown, "Label", "Kill Sound Pack Language")
	end
	if soundpackname == "DevilMayCry" then
		PS_KillSoundPackName = soundpackname
		if PS_KillSoundPackLanguage ~= "Eng" then
			PS_KillSoundPackLanguage = "Eng"
			UIDropDownMenu_SetText(PVPSoundKillSoundPackLanguageDropDown, L["English"])
		end
		PVPSoundOptions:OptionsSetKillSoundPack()
		UIDropDownMenu_SetText(frame, L["Devil May Cry"])
		local TestSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."TestDurations")
		PlaySoundFile(TestSoundLengthTable[1].dir, PS_Channel)
		CloseDropDownMenus()
	elseif soundpackname == "Dota2" then
		PS_KillSoundPackName = soundpackname
		if PS_KillSoundPackLanguage ~= "Axe" and PS_KillSoundPackLanguage ~= "Bastion" and PS_KillSoundPackLanguage ~= "ClockWerk" and PS_KillSoundPackLanguage ~= "DefenseGrid" and PS_KillSoundPackLanguage ~= "Glados" and PS_KillSoundPackLanguage ~= "Juggernaut" and PS_KillSoundPackLanguage ~= "Lina" and PS_KillSoundPackLanguage ~= "NaturesProphet" and PS_KillSoundPackLanguage ~= "Pflax" and PS_KillSoundPackLanguage ~= "Pirate" and PS_KillSoundPackLanguage ~= "StanleyParable" and PS_KillSoundPackLanguage ~= "StormSpirit" and PS_KillSoundPackLanguage ~= "Trine" then
			PS_KillSoundPackLanguage = "Axe"
			UIDropDownMenu_SetText(PVPSoundKillSoundPackLanguageDropDown, L["Axe"])
		end
		PVPSoundOptions:OptionsSetKillSoundPack()
		UIDropDownMenu_SetText(frame, L["Dota 2"])
		local TestSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."TestDurations")
		PlaySoundFile(TestSoundLengthTable[1].dir, PS_Channel)
		CloseDropDownMenus()
	elseif soundpackname == "Halo4" then
		PS_KillSoundPackName = soundpackname
		if PS_KillSoundPackLanguage ~= "Eng" then
			PS_KillSoundPackLanguage = "Eng"
			UIDropDownMenu_SetText(PVPSoundKillSoundPackLanguageDropDown, L["English"])
		end
		PVPSoundOptions:OptionsSetKillSoundPack()
		UIDropDownMenu_SetText(frame, L["Halo 4"])
		local TestSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."TestDurations")
		PlaySoundFile(TestSoundLengthTable[1].dir, PS_Channel)
		CloseDropDownMenus()
	elseif soundpackname == "UnrealTournament3" then
		PS_KillSoundPackName = soundpackname
		if PS_KillSoundPackLanguage ~= "Deu" and PS_KillSoundPackLanguage ~= "Eng" and PS_KillSoundPackLanguage ~= "Esn" and PS_KillSoundPackLanguage ~= "Fra" and PS_KillSoundPackLanguage ~= "Ita" and PS_KillSoundPackLanguage ~= "Rus" then
			PS_KillSoundPackLanguage = "Eng"
			UIDropDownMenu_SetText(PVPSoundKillSoundPackLanguageDropDown, L["English"])
		end
		PVPSoundOptions:OptionsSetKillSoundPack()
		UIDropDownMenu_SetText(frame, L["Unreal Tournament 3"])
		local TestSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."TestDurations")
		PlaySoundFile(TestSoundLengthTable[1].dir, PS_Channel)
		CloseDropDownMenus()
	elseif soundpackname == "Custom" then
		PS_KillSoundPackName = soundpackname
		if PS_KillSoundPackLanguage ~= "Default" then
			PS_KillSoundPackLanguage = "Default"
			UIDropDownMenu_SetText(PVPSoundKillSoundPackLanguageDropDown, L["Default"])
		end
		PVPSoundOptions:OptionsSetKillSoundPack()
		UIDropDownMenu_SetText(frame, L["Custom"])
		local TestSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."TestDurations")
		PlaySoundFile(TestSoundLengthTable[1].dir, PS_Channel)
		CloseDropDownMenus()
	end
	PVPSoundOptions:OptionsSetSoundPackLocalizations()
	--print(PS_KillSoundPackName)
end

function PVPSoundOptions:OptionsSetSoundPackText(self)
	if PS_SoundPackName == "UnrealTournament3" then
		UIDropDownMenu_SetText(self, L["Unreal Tournament 3"])
	elseif PS_SoundPackName == "Custom" then
		UIDropDownMenu_SetText(self, L["Custom"])
	end
end

function PVPSoundOptions:OptionsSoundPack(name, soundpackname)
	local frame = getglobal(name)
	if soundpackname == "UnrealTournament3" then
		PS_SoundPackName = soundpackname
		if PS_SoundPackLanguage ~= "Deu" and PS_SoundPackLanguage ~= "Eng" and PS_SoundPackLanguage ~= "Esn" and PS_SoundPackLanguage ~= "Fra" and PS_SoundPackLanguage ~= "Ita" and PS_SoundPackLanguage ~= "Rus" then
			PS_SoundPackLanguage = "Eng"
			UIDropDownMenu_SetText(PVPSoundSoundPackLanguageDropDown, L["English"])
		end
		PVPSoundOptions:OptionsSetSoundPack()
		UIDropDownMenu_SetText(frame, L["Unreal Tournament 3"])
		PlaySoundFile(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\UnrealTournament3.ogg", PS_Channel)
		CloseDropDownMenus()
	elseif soundpackname == "Custom" then
		PS_SoundPackName = soundpackname
		if PS_SoundPackLanguage ~= "Default" then
			PS_SoundPackLanguage = "Default"
			UIDropDownMenu_SetText(PVPSoundSoundPackLanguageDropDown, L["Default"])
		end
		PVPSoundOptions:OptionsSetSoundPack()
		UIDropDownMenu_SetText(frame, L["Custom"])
		PlaySoundFile(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\UnrealTournament3.ogg", PS_Channel)
		CloseDropDownMenus()
	end
	--print(PS_SoundPackName)
end

-- Sound Pack Languages
function PVPSoundOptions:OptionsSetKillSoundPackLanguageText(self)
	if PS_KillSoundPackLanguage == "Default" then
		UIDropDownMenu_SetText(self, L["Default"])
	elseif PS_KillSoundPackLanguage == "Eng" then
		UIDropDownMenu_SetText(self, L["English"])
	elseif PS_KillSoundPackLanguage == "Deu" then
		UIDropDownMenu_SetText(self, L["German"])
	elseif PS_KillSoundPackLanguage == "Esn" then
		UIDropDownMenu_SetText(self, L["Spanish"])
	elseif PS_KillSoundPackLanguage == "Fra" then
		UIDropDownMenu_SetText(self, L["French"])
	elseif PS_KillSoundPackLanguage == "Ita" then
		UIDropDownMenu_SetText(self, L["Italian"])
	elseif PS_KillSoundPackLanguage == "Rus" then
		UIDropDownMenu_SetText(self, L["Russian"])
	elseif PS_KillSoundPackLanguage == "Axe" then
		UIDropDownMenu_SetText(self, L["Axe"])
	elseif PS_KillSoundPackLanguage == "Bastion" then
		UIDropDownMenu_SetText(self, L["Bastion"])
	elseif PS_KillSoundPackLanguage == "ClockWerk" then
		UIDropDownMenu_SetText(self, L["ClockWerk"])
	elseif PS_KillSoundPackLanguage == "DefenseGrid" then
		UIDropDownMenu_SetText(self, L["DefenseGrid"])
	elseif PS_KillSoundPackLanguage == "Glados" then
		UIDropDownMenu_SetText(self, L["Glados"])
	elseif PS_KillSoundPackLanguage == "Juggernaut" then
		UIDropDownMenu_SetText(self, L["Juggernaut"])
	elseif PS_KillSoundPackLanguage == "Lina" then
		UIDropDownMenu_SetText(self, L["Lina"])
	elseif PS_KillSoundPackLanguage == "NaturesProphet" then
		UIDropDownMenu_SetText(self, L["NaturesProphet"])
	elseif PS_KillSoundPackLanguage == "Pflax" then
		UIDropDownMenu_SetText(self, L["Pflax"])
	elseif PS_KillSoundPackLanguage == "Pirate" then
		UIDropDownMenu_SetText(self, L["Pirate"])
	elseif PS_KillSoundPackLanguage == "StanleyParable" then
		UIDropDownMenu_SetText(self, L["StanleyParable"])
	elseif PS_KillSoundPackLanguage == "StormSpirit" then
		UIDropDownMenu_SetText(self, L["StormSpirit"])
	elseif PS_KillSoundPackLanguage == "Trine" then
		UIDropDownMenu_SetText(self, L["Trine"])
	end
end

function PVPSoundOptions:OptionsKillSoundPackLanguage(name, soundpacklanguage)
	local frame = getglobal(name)
	if soundpacklanguage == "Default" then
		PS_KillSoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["Default"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "Eng" then
		PS_KillSoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["English"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "Deu" then
		PS_KillSoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["German"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "Esn" then
		PS_KillSoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["Spanish"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "Fra" then
		PS_KillSoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["French"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "Ita" then
		PS_KillSoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["Italian"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "Rus" then
		PS_KillSoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["Russian"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "Axe" then
		PS_KillSoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["Axe"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "Bastion" then
		PS_KillSoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["Bastion"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "ClockWerk" then
		PS_KillSoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["ClockWerk"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "DefenseGrid" then
		PS_KillSoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["DefenseGrid"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "Glados" then
		PS_KillSoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["Glados"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "Juggernaut" then
		PS_KillSoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["Juggernaut"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "Lina" then
		PS_KillSoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["Lina"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "NaturesProphet" then
		PS_KillSoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["NaturesProphet"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "Pflax" then
		PS_KillSoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["Pflax"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "Pirate" then
		PS_KillSoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["Pirate"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "StanleyParable" then
		PS_KillSoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["StanleyParable"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "StormSpirit" then
		PS_KillSoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["StormSpirit"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "Trine" then
		PS_KillSoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["Trine"])
		CloseDropDownMenus()
	end
	PVPSoundOptions:OptionsSetKillSoundPack()
	PVPSoundOptions:OptionsSetSoundPackLocalizations()
	local TestSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."TestDurations")
	PlaySoundFile(TestSoundLengthTable[1].dir, PS_Channel)
	--print(PS_KillSoundPackLanguage)
end

function PVPSoundOptions:OptionsSetSoundPackLanguageText(self)
	if PS_SoundPackLanguage == "Default" then
		UIDropDownMenu_SetText(self, L["Default"])
	else
		if PS_SoundPackLanguage == "Eng" then
			UIDropDownMenu_SetText(self, L["English"])
		elseif PS_SoundPackLanguage == "Deu" then
			UIDropDownMenu_SetText(self, L["German"])
		elseif PS_SoundPackLanguage == "Esn" then
			UIDropDownMenu_SetText(self, L["Spanish"])
		elseif PS_SoundPackLanguage == "Fra" then
			UIDropDownMenu_SetText(self, L["French"])
		elseif PS_SoundPackLanguage == "Ita" then
			UIDropDownMenu_SetText(self, L["Italian"])
		elseif PS_SoundPackLanguage == "Rus" then
			UIDropDownMenu_SetText(self, L["Russian"])
		end
	end
end

function PVPSoundOptions:OptionsSoundPackLanguage(name, soundpacklanguage)
	local frame = getglobal(name)
	if soundpacklanguage == "Default" then
		PS_SoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["Default"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "Eng" then
		PS_SoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["English"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "Deu" then
		PS_SoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["German"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "Esn" then
		PS_SoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["Spanish"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "Fra" then
		PS_SoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["French"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "Ita" then
		PS_SoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["Italian"])
		CloseDropDownMenus()
	elseif soundpacklanguage == "Rus" then
		PS_SoundPackLanguage = soundpacklanguage
		UIDropDownMenu_SetText(frame, L["Russian"])
		CloseDropDownMenus()
	end
	PVPSoundOptions:OptionsSetSoundPack()
	PlaySoundFile(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\UnrealTournament3.ogg", PS_Channel)
	--print(PS_SoundPackLanguage)
end

-- Channels
function PVPSoundOptions:OptionsSetSoundChannelText(self)
	if PS_Channel == "Master" then
		UIDropDownMenu_SetText(self, L["Master"])
	elseif PS_Channel == "Sound" then
		UIDropDownMenu_SetText(self, L["Sound"])
	elseif PS_Channel == "Music" then
		UIDropDownMenu_SetText(self, L["Music"])
	elseif PS_Channel == "Ambience" then
		UIDropDownMenu_SetText(self, L["Ambience"])
	end
end

function PVPSoundOptions:OptionsSoundChannel(name, soundchannel)
	local frame = getglobal(name)
	if soundchannel == "Master" then
		PS_Channel = soundchannel
		UIDropDownMenu_SetText(frame, L["Master"])
		CloseDropDownMenus()
	elseif soundchannel == "Sound" then
		PS_Channel = soundchannel
		UIDropDownMenu_SetText(frame, L["Sound"])
		CloseDropDownMenus()
	elseif soundchannel == "Music" then
		PS_Channel = soundchannel
		UIDropDownMenu_SetText(frame, L["Music"])
		CloseDropDownMenus()
	elseif soundchannel == "Ambience" then
		PS_Channel = soundchannel
		UIDropDownMenu_SetText(frame, L["Ambience"])
		CloseDropDownMenus()
	end
	local TestSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."TestDurations")
	PlaySoundFile(TestSoundLengthTable[1].dir, PS_Channel)
	--print(PS_Channel)
end

-- Modes
function PVPSoundOptions:OptionsSetModeText(self)
	if PS_Mode == "PVP" then
		UIDropDownMenu_SetText(self, L["PVP"])
	elseif PS_Mode == "PVE" then
		UIDropDownMenu_SetText(self, L["PVE"])
	elseif PS_Mode == "PVPandPVE" then
		UIDropDownMenu_SetText(self, L["PVP and PVE"])
	end
end

function PVPSoundOptions:OptionsMode(name, mode)
	local frame = getglobal(name)
	if mode == "PVP" then
		PS_Mode = mode
		UIDropDownMenu_SetText(frame, L["PVP"])
		CloseDropDownMenus()
	elseif mode == "PVE" then
		PS_Mode = mode
		UIDropDownMenu_SetText(frame, L["PVE"])
		CloseDropDownMenus()
	elseif mode == "PVPandPVE" then
		PS_Mode = mode
		UIDropDownMenu_SetText(frame, L["PVP and PVE"])
		CloseDropDownMenus()
	end
	--print(PS_Mode)
end

-- Addon Languages
function PVPSoundOptions:OptionsSetAddonLanguageText(self)
	if PS_AddonLanguage == "English" then
		UIDropDownMenu_SetText(self, "English")
	elseif PS_AddonLanguage == "German" then
		UIDropDownMenu_SetText(self, "German")
	elseif PS_AddonLanguage == "Spanish" then
		UIDropDownMenu_SetText(self, "Español")
	elseif PS_AddonLanguage == "LatinAmericanSpanish" then
		UIDropDownMenu_SetText(self, "El español de América")
	elseif PS_AddonLanguage == "French" then
		UIDropDownMenu_SetText(self, "Français")
	elseif PS_AddonLanguage == "Italian" then
		UIDropDownMenu_SetText(self, "Italiano")
	elseif PS_AddonLanguage == "Korean" then
		UIDropDownMenu_SetText(self, "한국의")
	elseif PS_AddonLanguage == "Portuguese" then
		UIDropDownMenu_SetText(self, "Português")
	elseif PS_AddonLanguage == "Russian" then
		UIDropDownMenu_SetText(self, "Русский")
	elseif PS_AddonLanguage == "SimplifiedChinese" then
		UIDropDownMenu_SetText(self, "简体中国")
	elseif PS_AddonLanguage == "TraditionalChinese" then
		UIDropDownMenu_SetText(self, "繁體中文")
	end
end

function PVPSoundOptions:OptionsAddonLanguage(name, language)
	local frame = getglobal(name)
	if language == "English" then
		PS_AddonLanguage = language
		PVPSound:English()
		UIDropDownMenu_SetText(frame, "English")
		CloseDropDownMenus()
	elseif language == "German" then
		PS_AddonLanguage = language
		PVPSound:German()
		UIDropDownMenu_SetText(frame, "German")
		CloseDropDownMenus()
	elseif language == "Spanish" then
		PS_AddonLanguage = language
		PVPSound:Spanish()
		UIDropDownMenu_SetText(frame, "Español")
		CloseDropDownMenus()
	elseif language == "LatinAmericanSpanish" then
		PS_AddonLanguage = language
		PVPSound:LatinAmericanSpanish()
		UIDropDownMenu_SetText(frame, "El español de América")
		CloseDropDownMenus()
	elseif language == "French" then
		PS_AddonLanguage = language
		PVPSound:French()
		UIDropDownMenu_SetText(frame, "Français")
		CloseDropDownMenus()
	elseif language == "Italian" then
		PS_AddonLanguage = language
		PVPSound:Italian()
		UIDropDownMenu_SetText(frame, "Italiano")
		CloseDropDownMenus()
	elseif language == "Korean" then
		PS_AddonLanguage = language
		PVPSound:Korean()
		UIDropDownMenu_SetText(frame, "한국의")
		CloseDropDownMenus()
	elseif language == "Portuguese" then
		PS_AddonLanguage = language
		PVPSound:Portuguese()
		UIDropDownMenu_SetText(frame, "Português")
		CloseDropDownMenus()
	elseif language == "Russian" then
		PS_AddonLanguage = language
		PVPSound:Russian()
		UIDropDownMenu_SetText(frame, "Русский")
		CloseDropDownMenus()
	elseif language == "SimplifiedChinese" then
		PS_AddonLanguage = language
		PVPSound:SimplifiedChinese()
		UIDropDownMenu_SetText(frame, "简体中国")
		CloseDropDownMenus()
	elseif language == "TraditionalChinese" then
		PS_AddonLanguage = language
		PVPSound:TraditionalChinese()
		UIDropDownMenu_SetText(frame, "繁體中文")
		CloseDropDownMenus()
	end
	PVPSoundOptions:OptionsUpdateLocalization()
	PVPSoundOptions:OptionsUpdateFonts()
	UIDropDownMenu_Initialize(frame, PVPSoundOptions.OptionsDropDownMenuInitialize)
	UIDropDownMenu_Initialize(PVPSoundKillSoundPackDropDown, PVPSoundOptions.OptionsDropDownMenuInitialize)
	UIDropDownMenu_Initialize(PVPSoundKillSoundPackLanguageDropDown, PVPSoundOptions.OptionsDropDownMenuInitialize)
	UIDropDownMenu_Initialize(PVPSoundSoundPackDropDown, PVPSoundOptions.OptionsDropDownMenuInitialize)
	UIDropDownMenu_Initialize(PVPSoundSoundPackLanguageDropDown, PVPSoundOptions.OptionsDropDownMenuInitialize)
	UIDropDownMenu_Initialize(PVPSoundSoundChannelDropDown, PVPSoundOptions.OptionsDropDownMenuInitialize)
	UIDropDownMenu_Initialize(PVPSoundModeDropDown, PVPSoundOptions.OptionsDropDownMenuInitialize)
end

function PVPSoundOptions:OptionsUpdateLocalization()
	PVPSoundOptions:OptionsSetText(PVPSoundTab1, nil, "General")
	PVPSoundOptions:OptionsSetText(PVPSoundTab2, nil, "AV")
	PVPSoundOptions:OptionsSetText(PVPSoundTab3, nil, "AB")
	PVPSoundOptions:OptionsSetText(PVPSoundTab4, nil, "DG")
	PVPSoundOptions:OptionsSetText(PVPSoundTab5, nil, "EOTS")
	PVPSoundOptions:OptionsSetText(PVPSoundTab6, nil, "IOC")
	PVPSoundOptions:OptionsSetText(PVPSoundTab7, nil, "SM")
	PVPSoundOptions:OptionsSetText(PVPSoundTab8, nil, "SOTA")
	PVPSoundOptions:OptionsSetText(PVPSoundTab9, nil, "TOK")
	PVPSoundOptions:OptionsSetText(PVPSoundTab10, nil, "TBFG")
	PVPSoundOptions:OptionsSetText(PVPSoundTab11, nil, "TP")
	PVPSoundOptions:OptionsSetText(PVPSoundTab12, nil, "WSG")
	PVPSoundOptions:OptionsSetText(PVPSoundTab13, nil, "TB")
	PVPSoundOptions:OptionsSetText(PVPSoundTab14, nil, "WG")
	PVPSoundOptions:OptionsSetText(PVPSoundTab1Frame, "Text", "General")
	PVPSoundOptions:OptionsSetText(PVPSoundTab2Frame, "Text", "Alterac Valley")
	PVPSoundOptions:OptionsSetText(PVPSoundTab3Frame, "Text", "Arathi Basin")
	PVPSoundOptions:OptionsSetText(PVPSoundTab4Frame, "Text", "Deepwind Gorge")
	PVPSoundOptions:OptionsSetText(PVPSoundTab5Frame, "Text", "Eye of the Storm")
	PVPSoundOptions:OptionsSetText(PVPSoundTab6Frame, "Text", "Isle of Conquest")
	PVPSoundOptions:OptionsSetText(PVPSoundTab7Frame, "Text", "Silvershard Mines")
	PVPSoundOptions:OptionsSetText(PVPSoundTab8Frame, "Text", "Strand of the Ancients")
	PVPSoundOptions:OptionsSetText(PVPSoundTab9Frame, "Text", "Temple of Kotmogu")
	PVPSoundOptions:OptionsSetText(PVPSoundTab10Frame, "Text", "The Battle for Gilneas")
	PVPSoundOptions:OptionsSetText(PVPSoundTab11Frame, "Text", "Twin Peaks")
	PVPSoundOptions:OptionsSetText(PVPSoundTab12Frame, "Text", "Warsong Gulch")
	PVPSoundOptions:OptionsSetText(PVPSoundTab13Frame, "Text", "Tol Barad")
	PVPSoundOptions:OptionsSetText(PVPSoundTab14Frame, "Text", "Wintergrasp")
	PVPSoundOptions:OptionsSetText(PVPSoundLanguageDropDown, "Label", "Addon Language")
	PVPSoundOptions:OptionsSetText(PVPSoundEnableAddonButton, "Text", "Enable addon")
	PVPSoundOptions:OptionsSetText(PVPSoundKillSoundPackDropDown, "Label", "Kill Sound Pack")
	PVPSoundOptions:OptionsSetKillSoundPackText(PVPSoundKillSoundPackDropDown)
	if PS_KillSoundPackName == "Dota2" then
		PVPSoundOptions:OptionsSetText(PVPSoundKillSoundPackLanguageDropDown, "Label", "Kill Sound Pack Type")
	else
		PVPSoundOptions:OptionsSetText(PVPSoundKillSoundPackLanguageDropDown, "Label", "Kill Sound Pack Language")
	end
	PVPSoundOptions:OptionsSetKillSoundPackLanguageText(PVPSoundKillSoundPackLanguageDropDown)
	PVPSoundOptions:OptionsSetText(PVPSoundSoundPackDropDown, "Label", "BG Sound Pack")
	PVPSoundOptions:OptionsSetSoundPackText(PVPSoundSoundPackDropDown)
	PVPSoundOptions:OptionsSetText(PVPSoundSoundPackLanguageDropDown, "Label", "BG Sound Pack Language")
	PVPSoundOptions:OptionsSetSoundPackLanguageText(PVPSoundSoundPackLanguageDropDown)
	PVPSoundOptions:OptionsSetText(PVPSoundSoundChannelDropDown, "Label", "Sound Channel")
	PVPSoundOptions:OptionsSetSoundChannelText(PVPSoundSoundChannelDropDown)
	PVPSoundOptions:OptionsSetText(PVPSoundModeDropDown, "Label", "Mode")
	PVPSoundOptions:OptionsSetModeText(PVPSoundModeDropDown)
	PVPSoundOptions:OptionsSetText(PVPSoundKillSoundButton, "Text", "Enable Kill Sounds")
	PVPSoundOptions:OptionsSetText(PVPSoundMultiKillSoundButton, "Text", "Enable Multi Kill Sounds")
end

function PVPSoundOptions:OptionsUpdateFonts()
	if PS_AddonLanguage == "Korean" then
		PVPSoundFontSmallWhite:SetFont("Fonts\\2002.TTF", 10)
		PVPSoundFontSmallYellowShadow:SetFont("Fonts\\2002.TTF", 10)
		PVPSoundFontSmallWhiteShadow:SetFont("Fonts\\2002.TTF", 10)
		PVPSoundFontMediumYellow:SetFont("Fonts\\2002.TTF", 12)
		PVPSoundFontMediumWhite:SetFont("Fonts\\2002.TTF", 12)
		PVPSoundFontLargeYellow:SetFont("Fonts\\2002.TTF", 16)
		font = GameFontNormalSmallLeft_KO
	elseif PS_AddonLanguage == "Russian" then
		PVPSoundFontSmallWhite:SetFont("Fonts\\FRIZQT___CYR.TTF", 10)
		PVPSoundFontSmallYellowShadow:SetFont("Fonts\\FRIZQT___CYR.TTF", 10)
		PVPSoundFontSmallWhiteShadow:SetFont("Fonts\\FRIZQT___CYR.TTF", 10)
		PVPSoundFontMediumYellow:SetFont("Fonts\\FRIZQT___CYR.TTF", 12)
		PVPSoundFontMediumWhite:SetFont("Fonts\\FRIZQT___CYR.TTF", 12)
		PVPSoundFontLargeYellow:SetFont("Fonts\\FRIZQT___CYR.TTF", 16)
		font = GameFontNormalSmallLeft_RU
	elseif PS_AddonLanguage == "SimplifiedChinese" then
		PVPSoundFontSmallWhite:SetFont("Fonts\\ARKai_T.TTF", 10)
		PVPSoundFontSmallYellowShadow:SetFont("Fonts\\ARKai_T.TTF", 10)
		PVPSoundFontSmallWhiteShadow:SetFont("Fonts\\ARKai_T.TTF", 10)
		PVPSoundFontMediumYellow:SetFont("Fonts\\ARKai_T.TTF", 12)
		PVPSoundFontMediumWhite:SetFont("Fonts\\ARKai_T.TTF", 12)
		PVPSoundFontLargeYellow:SetFont("Fonts\\ARKai_T.TTF", 16)
		font = GameFontNormalSmallLeft_ZH
	elseif PS_AddonLanguage == "TraditionalChinese" then
		PVPSoundFontSmallWhite:SetFont("Fonts\\ARKai_T.TTF", 10)
		PVPSoundFontSmallYellowShadow:SetFont("Fonts\\ARKai_T.TTF", 10)
		PVPSoundFontSmallWhiteShadow:SetFont("Fonts\\ARKai_T.TTF", 10)
		PVPSoundFontMediumYellow:SetFont("Fonts\\ARKai_T.TTF", 12)
		PVPSoundFontMediumWhite:SetFont("Fonts\\ARKai_T.TTF", 12)
		PVPSoundFontLargeYellow:SetFont("Fonts\\ARKai_T.TTF", 16)
		font = GameFontNormalSmallLeft_ZH
	else
		PVPSoundFontSmallWhite:SetFont("Fonts\\FRIZQT__.TTF", 10)
		PVPSoundFontSmallYellowShadow:SetFont("Fonts\\FRIZQT__.TTF", 10)
		PVPSoundFontSmallWhiteShadow:SetFont("Fonts\\FRIZQT__.TTF", 10)
		PVPSoundFontMediumYellow:SetFont("Fonts\\FRIZQT__.TTF", 12)
		PVPSoundFontMediumWhite:SetFont("Fonts\\FRIZQT__.TTF", 12)
		PVPSoundFontLargeYellow:SetFont("Fonts\\FRIZQT__.TTF", 16)
		font = GameFontWhiteSmall
	end
end

function PVPSoundOptions:OptionsSetSoundPackLocalizations()
	if PS_KillSoundPackName == "DevilMayCry" then
		--[[if PS_KillSoundPackLanguage == "Eng" then
			Msg_Streak1Male = "is"
			Msg_Streak1Female = "is"
			Msg_Streak2 = "is"
			Msg_Streak3 = "is"
		end]]
	else
		--[[if PS_KillSoundPackLanguage == "Eng" then
			PVPSound:English()
		elseif PS_KillSoundPackLanguage == "Deu" then
			PVPSound:German()
		elseif PS_KillSoundPackLanguage == "Esn" then
			PVPSound:Spanish()
		elseif PS_KillSoundPackLanguage == "Fra" then
			PVPSound:French()
		elseif PS_KillSoundPackLanguage == "Ita" then
			PVPSound:Italian()
		elseif PS_KillSoundPackLanguage == "Rus" then
			PVPSound:Russian()
		end]]
	end
end

function PVPSoundOptions:OptionsSetKillSoundPack()
	if PS_KillSoundPackName == "DevilMayCry" then
		PS.KillSoundPackDirectory = "Interface\\Addons\\PVPSound\\Sounds\\"..PS_KillSoundPackName
	elseif PS_KillSoundPackName == "Dota2" then
		PS.KillSoundPackDirectory = "Interface\\Addons\\PVPSound\\Sounds\\"..PS_KillSoundPackName
	elseif PS_KillSoundPackName == "Halo4" then
		PS.KillSoundPackDirectory = "Interface\\Addons\\PVPSound\\Sounds\\"..PS_KillSoundPackName
	elseif PS_KillSoundPackName == "UnrealTournament3" then
		PS.KillSoundPackDirectory = "Interface\\Addons\\PVPSound\\Sounds\\"..PS_KillSoundPackName
	elseif PS_KillSoundPackName == "Custom" then
		PS.KillSoundPackDirectory = "Interface\\Addons\\PVPSound_CustomSoundPack\\Sounds\\"..PS_KillSoundPackName
	end
	PS.KillSoundPack = PS_KillSoundPackName..""..PS_KillSoundPackLanguage
	--print(PS.KillSoundPack)
	--print(PS.KillSoundPackDirectory)
end

function PVPSoundOptions:OptionsSetSoundPack()
	if PS_SoundPackName == "UnrealTournament3" then
		PS.SoundPackDirectory = "Interface\\Addons\\PVPSound\\Sounds\\"..PS_SoundPackName
	elseif PS_SoundPackName == "Custom" then
		PS.SoundPackDirectory = "Interface\\Addons\\PVPSound_CustomSoundPack\\Sounds\\"..PS_SoundPackName
	end
	PS.SoundPack = PS_SoundPackName..""..PS_SoundPackLanguage
	--print(PS.SoundPack)
	--print(PS.SoundPackDirectory)
end

-- Slash Commands
function PVPSound:SlashCommands(arg1)
	PVPSound:SetAddonLanguage()
	-- Arg1 is case sensitive
	-- Arg2 is converted to lower case
	local arg2 = string.lower(arg1)
	if arg2 == "" then
		PVPSoundOptions:OptionsToggleMenu()
	elseif arg2 == "slash" then
		PVPSound:PrintSlashMenu()
	elseif arg2 == "enable" then
		PS_EnableAddon = not PS_EnableAddon
		if PS_EnableAddon == true then
			print("|cFF50C0FFEnable Addon: |cFFADFF2F"..Opt_Enable.."|r")
		else
			print("|cFF50C0FFEnable Addon: |cFFFF4500"..Opt_Disable.."|r")
		end
	elseif arg2 == "pvp" then
		PS_Mode = not PS_Mode
		if PS_Mode == true then
			print("|cFF50C0FF"..Opt_Mode..": |cFFADFF2F"..Opt_PVP.."|r")
		else
			print("|cFF50C0FF"..Opt_Mode..": |cFFFF4500"..Opt_PVE.."|r")
		end
	elseif arg2 == "emote" then
		PS_Emote = not PS_Emote
		if PS_Emote == true then
			print("|cFF50C0FF"..Opt_Emotes..": |cFFADFF2F"..Opt_Enable.."|r")
		else
			print("|cFF50C0FF"..Opt_Emotes..": |cFFFF4500"..Opt_Disable.."|r")
		end
	elseif arg2 == "emotemode" or arg2 == "emote mode" then
		PS_EmoteMode = not PS_EmoteMode
		if PS_EmoteMode == true then
			print("|cFF50C0FF"..Opt_EmoteMode..": |cFFADFF2F"..Opt_Emote.."|r")
		else
			print("|cFF50C0FF"..Opt_EmoteMode..": |cFFFF4500"..Opt_ChatMessage.."|r")
		end
	elseif arg2 == "dm" or arg2 == "deathmessage" or arg2 == "death message" or arg2 == "deathmessages" or arg2 == "death messages" then
		PS_DeathMessage = not PS_DeathMessage
		if PS_DeathMessage == true then
			print("|cFF50C0FF"..Opt_DeathMsg..": |cFFADFF2F"..Opt_Enable.."|r")
		else
			print("|cFF50C0FF"..Opt_DeathMsg..": |cFFFF4500"..Opt_Disable.."|r")
		end
	elseif arg2 == "ks" or arg2 == "killsound" or arg2 == "kill sound" or arg2 == "killsounds" or arg2 == "kill sounds" then
		PS_KillSound = not PS_KillSound
		if PS_KillSound == true then
			print("|cFF50C0FF"..Opt_KillSound..": |cFFADFF2F"..Opt_Enable.."|r")
		else
			print("|cFF50C0FF"..Opt_KillSound..": |cFFFF4500"..Opt_Disable.."|r")
		end
	elseif arg2 == "mks" or arg2 == "multikillsound" or arg2 == "multikill sound" or arg2 == "multi kill sound" or arg2 == "multi killsound" or arg2 == "multikillsounds" or arg2 == "multikill sounds" or arg2 == "multi kill sounds" or arg2 == "multi killsounds" then
		PS_MultiKillSound = not PS_MultiKillSound
		if PS_MultiKillSound == true then
			print("|cFF50C0FF"..Opt_MultiKillSound..": |cFFADFF2F"..Opt_Enable.."|r")
		else
			print("|cFF50C0FF"..Opt_MultiKillSound..": |cFFFF4500"..Opt_Disable.."|r")
		end
	elseif arg2 == "pk" or arg2 == "petkill" or arg2 == "pet kill" or arg2 == "petkills" or arg2 == "pet kills" then
		PS_PetKill = not PS_PetKill
		if PS_PetKill == true then
			print("|cFF50C0FF"..Opt_PetKill..": |cFFADFF2F"..Opt_Enable.."|r")
		else
			print("|cFF50C0FF"..Opt_PetKill..": |cFFFF4500"..Opt_Disable.."|r")
		end
	elseif arg2 == "ps" or arg2 == "paysound" or arg2 == "pay sound" or arg2 == "paybacksound" or arg2 == "payback sound" or arg2 == "paysounds" or arg2 == "pay sounds" or arg2 == "paybacksounds" or arg2 == "payback sounds" then
		PS_PaybackSound = not PS_PaybackSound
		if PS_PaybackSound == true then
			print("|cFF50C0FF"..Opt_PaySound..": |cFFADFF2F"..Opt_Enable.."|r")
		else
			print("|cFF50C0FF"..Opt_PaySound..": |cFFFF4500"..Opt_Disable.."|r")
		end
	elseif arg2 == "bs" or arg2 == "bgsound" or arg2 == "bg sound" or arg2 == "battlegroundsound" or arg2 == "battleground sound" or arg2 == "bgsounds" or arg2 == "bg sounds" or arg2 == "battlegroundsounds" or arg2 == "battleground sounds" then
		PS_BattlegroundSound = not PS_BattlegroundSound
		if PS_BattlegroundSound == true then
			print("|cFF50C0FF"..Opt_BgSound..": |cFFADFF2F"..Opt_Enable.."|r")
		else
			print("|cFF50C0FF"..Opt_BgSound..": |cFFFF4500"..Opt_Disable.."|r")
		end
	elseif arg2 == "se" or arg2 == "soundeffect" or arg2 == "sound effect" or arg2 == "effectsound" or arg2 == "effect sound" then
		PS_SoundEffect = not PS_SoundEffect
		if PS_SoundEffect == true then
			print("|cFF50C0FF"..Opt_SoundEffect..": |cFFADFF2F"..Opt_Enable.."|r")
		else
			print("|cFF50C0FF"..Opt_SoundEffect..": |cFFFF4500"..Opt_Disable.."|r")
		end
	elseif arg2 == "kse" or arg2 == "killsoundengine" or arg2 == "killsound engine" or arg2 == "kill sound engine" or arg2 == "kill soundengine" then
		PS_KillSoundEngine = not PS_KillSoundEngine
		if PS_KillSoundEngine == true then
			print("|cFF50C0FF"..Opt_KillSoundEngine..": |cFFADFF2F"..Opt_Enable.."|r")
		else
			print("|cFF50C0FF"..Opt_KillSoundEngine..": |cFFFF4500"..Opt_Disable.."|r")
		end
	elseif arg2 == "bse" or arg2 == "bgsoundengine" or arg2 == "bgsound engine" or arg2 == "bg sound engine" or arg2 == "bg soundengine" or arg2 == "battleground soundengine" or arg2 == "battlegroundsoundengine" or arg2 == "battleground sound engine" or arg2 == "battlegroundsound engine" then
		PS_BattlegroundSoundEngine = not PS_BattlegroundSoundEngine
		if PS_BattlegroundSoundEngine == true then
			print("|cFF50C0FF"..Opt_BgSoundEngine..": |cFFADFF2F"..Opt_Enable.."|r")
		else
			print("|cFF50C0FF"..Opt_BgSoundEngine..": |cFFFF4500"..Opt_Disable.."|r")
		end
	elseif arg2 == "ds" or arg2 == "datashare" or arg2 == "data share" or arg2 == "datasharing" or arg2 == "data sharing" then
		PS_DataShare = not PS_DataShare
		if PS_DataShare == true then
			print("|cFF50C0FF"..Opt_DataShare..": |cFFADFF2F"..Opt_Enable.."|r")
		else
			print("|cFF50C0FF"..Opt_DataShare..": |cFFFF4500"..Opt_Disable.."|r")
		end
	elseif arg2 == "ksct" or arg2 == "killsct" or arg2 == "kill sct" then
		PS_KillSct = not PS_KillSct
		if PS_KillSct == true then
			print("|cFF50C0FF"..Opt_KillSct..": |cFFADFF2F"..Opt_Enable.."|r")
		else
			print("|cFF50C0FF"..Opt_KillSct..": |cFFFF4500"..Opt_Disable.."|r")
		end
	elseif arg2 == "mksct" or arg2 == "multikillsct" or arg2 == "multikill sct" or arg2 == "multi kill sct" or arg2 == "multi killsct" then
		PS_MultiKillSct = not PS_MultiKillSct
		if PS_MultiKillSct == true then
			print("|cFF50C0FF"..Opt_MultiKillSct..": |cFFADFF2F"..Opt_Enable.."|r")
		else
			print("|cFF50C0FF"..Opt_MultiKillSct..": |cFFFF4500"..Opt_Disable.."|r")
		end
	elseif arg2 == "psct" or arg2 == "paybacksct" or arg2 == "payback sct" then
		PS_PaybackSct = not PS_PaybackSct
		if PS_PaybackSct == true then
			print("|cFF50C0FF"..Opt_PaybackSct..": |cFFADFF2F"..Opt_Enable.."|r")
		else
			print("|cFF50C0FF"..Opt_PaybackSct..": |cFFFF4500"..Opt_Disable.."|r")
		end
	elseif arg2 == "scte" or arg2 == "sctengine" or arg2 == "sct engine" then
		PS_SctEngine = not PS_SctEngine
		if PS_SctEngine == true then
			print("|cFF50C0FF"..Opt_SctEngine..": |cFFADFF2F"..Opt_Enable.."|r")
		else
			print("|cFF50C0FF"..Opt_SctEngine..": |cFFFF4500"..Opt_Disable.."|r")
		end
	elseif string.find(arg1, "frame(.+)") then
		if string.find(arg1, "frame ") then
			PSSctFrame = tostring(string.match(arg1, "frame (.+)"))
		else
			PSSctFrame = tostring(string.match(arg1, "frame(.+)"))
		end
		if PSSctFrame ~= nil then
			print("|cFF50C0FF"..Opt_Frame..": |cFFADFF2F["..PSSctFrame.."]|r")
		end
	elseif arg2 == "hsn" or arg2 == "hideservername" or arg2 == "hideserver name" or arg2 == "hide server name" or arg2 == "hide servername" or arg2 == "hideservernames" or arg2 == "hideserver names" or arg2 == "hide server names" or arg2 == "hide servernames" or arg2 == "hs" or arg2 == "hide server" or arg2 == "hideserver" then
		PS_HideServerName = not PS_HideServerName
		if PS_HideServerName == true then
			print("|cFF50C0FF"..Opt_HideServerName..": |cFFADFF2F"..Opt_Enable.."|r")
		else
			print("|cFF50C0FF"..Opt_HideServerName..": |cFFFF4500"..Opt_Disable.."|r")
		end
	elseif arg2 == "cm" or arg2 == "channelmaster" or arg2 == "channel master" then
		PS_Channel = "Master"
		if PS_Channel == "Master" then
			print("|cFF50C0FF"..Opt_Channel..": |cFFADFF2F"..Opt_Master.."|r")
		end
	elseif arg2 == "cs" or arg2 == "channelsound" or arg2 == "channel sound" then
		PS_Channel = "Sound"
		if PS_Channel == "Sound" then
			print("|cFF50C0FF"..Opt_Channel..": |cFFFF4500"..Opt_Sound.."|r")
		end
	elseif arg2 == "cmu" or arg2 == "channelmusic" or arg2 == "channel music" then
		PS_Channel = "Music"
		if PS_Channel == "Music" then
			print("|cFF50C0FF"..Opt_Channel..": |cFFFF4500"..Opt_Music.."|r")
		end
	elseif arg2 == "ca" or arg2 == "channelambience" or arg2 == "channel ambience" then
		PS_Channel = "Ambience"
		if PS_Channel == "Ambience" then
			print("|cFF50C0FF"..Opt_Channel..": |cFFFF4500"..Opt_Ambience.."|r")
		end
	elseif arg2 == "soundpack ut3" or arg2 == "soundpack unrealtournament3" or arg2 == "sp ut3" or arg2 == "sp unrealtournament3" or arg2 == "soundpackut3" or arg2 == "soundpackunrealtournament3" or arg2 == "sput3" or arg2 == "spunrealtournament3" then
		PS_SoundPackName = "UnrealTournament3"
		PS.SoundPackDirectory = "Interface\\Addons\\PVPSound\\Sounds\\"..PS_SoundPackName
		if PS_SoundPackName == "UnrealTournament3" then
			print("|cFF50C0FF"..Opt_SoundPack..": |cFFADFF2F"..Opt_UnrealTournament3.."|r")
		end
		if PS_SoundPackLanguage == "Deu" or PS_SoundPackLanguage == "Eng" or PS_SoundPackLanguage == "Esn" or PS_SoundPackLanguage == "Fra" or PS_SoundPackLanguage == "Ita" or PS_SoundPackLanguage == "Rus" then
			return false
		else
			PS_SoundPackLanguage = "Eng"
			PS.SoundPack = PS_SoundPackName..""..PS_SoundPackLanguage
			print("|cFF50C0FF"..Opt_SoundPackLanguage..": |cFFADFF2F"..Opt_English.."|r")
		end
	elseif arg2 == "soundpack custom" or arg2 == "sp custom" or arg2 == "soundpackcustom" or arg2 == "spcustom" then
		PS_SoundPackName = "Custom"
		PS.SoundPackDirectory = "Interface\\Addons\\PVPSound_CustomSoundPack\\Sounds\\"..PS_SoundPackName
		if PS_SoundPackName == "Custom" then
			print("|cFF50C0FF"..Opt_SoundPack..": |cFFFF4500"..Opt_Custom.."|r")
		end
		if PS_SoundPackLanguage ~= "Default" then
			PS_SoundPackLanguage = "Default"
			PS.SoundPack = PS_SoundPackName..""..PS_SoundPackLanguage
			print("|cFF50C0FF"..Opt_SoundPackLanguage..": |cFFADFF2F"..Opt_Default.."|r")
		end
	elseif arg2 == "language deu" or arg2 == "language deutsch" or arg2 == "languagedeu" or arg2 == "languagedeutsch" or arg2 == "lang deu" or arg2 == "lang deutsch" or arg2 == "langdeu" or arg2 == "langdeutsch" then
		if PS_SoundPackName ~= "Custom" then
			PS_SoundPackLanguage = "Deu"
			PS.SoundPack = PS_SoundPackName..""..PS_SoundPackLanguage
		else
			print("|cFF50C0FF"..Opt_CustomDoesntSupport)
		end
		if PS_SoundPackLanguage == "Deu" then
			print("|cFF50C0FF"..Opt_SoundPackLanguage..": |cFFADFF2F"..Opt_Deutsch.."|r")
		end
	elseif arg2 == "language eng" or arg2 == "language english" or arg2 == "languageeng" or arg2 == "languageenglish" or arg2 == "lang eng" or arg2 == "lang english" or arg2 == "langeng" or arg2 == "langenglish" then
		if PS_SoundPackName ~= "Custom" then
			PS_SoundPackLanguage = "Eng"
			PS.SoundPack = PS_SoundPackName..""..PS_SoundPackLanguage
		else
			print("|cFF50C0FF"..Opt_CustomDoesntSupport)
		end
		if PS_SoundPackLanguage == "Eng" then
			print("|cFF50C0FF"..Opt_SoundPackLanguage..": |cFFADFF2F"..Opt_English.."|r")
		end
	elseif arg2 == "language esn" or arg2 == "language espanol" or arg2 == "languageesn" or arg2 == "languageespanol" or arg2 == "lang esn" or arg2 == "lang espanol" or arg2 == "langesn" or arg2 == "langespanol" or arg2 == "language spa" or arg2 == "language spanish" or arg2 == "languagespa" or arg2 == "languagespanish" or arg2 == "lang spa" or arg2 == "lang spanish" or arg2 == "langspa" or arg2 == "langspanish"then
		if PS_SoundPackName ~= "Custom" then
			PS_SoundPackLanguage = "Esn"
			PS.SoundPack = PS_SoundPackName..""..PS_SoundPackLanguage
		else
			print("|cFF50C0FF"..Opt_CustomDoesntSupport)
		end
		if PS_SoundPackLanguage == "Esn" then
			print("|cFF50C0FF"..Opt_SoundPackLanguage..": |cFFADFF2F"..Opt_Spanish.."|r")
		end
	elseif arg2 == "language fra" or arg2 == "language france" or arg2 == "languagefra" or arg2 == "languagefrance" or arg2 == "lang fra" or arg2 == "lang france" or arg2 == "langfra" or arg2 == "langfrance" then
		if PS_SoundPackName ~= "Custom" then
			PS_SoundPackLanguage = "Fra"
			PS.SoundPack = PS_SoundPackName..""..PS_SoundPackLanguage
		else
			print("|cFF50C0FF"..Opt_CustomDoesntSupport)
		end
		if PS_SoundPackLanguage == "Fra" then
			print("|cFF50C0FF"..Opt_SoundPackLanguage..": |cFFADFF2F"..Opt_France.."|r")
		end
	elseif arg2 == "language ita" or arg2 == "language italian" or arg2 == "languageita" or arg2 == "languageitalian" or arg2 == "lang ita" or arg2 == "lang italian" or arg2 == "langita" or arg2 == "langitalian" then
		if PS_SoundPackName ~= "Custom" then
			PS_SoundPackLanguage = "Ita"
			PS.SoundPack = PS_SoundPackName..""..PS_SoundPackLanguage
		else
			print("|cFF50C0FF"..Opt_CustomDoesntSupport)
		end
		if PS_SoundPackLanguage == "Ita" then
			print("|cFF50C0FF"..Opt_SoundPackLanguage..": |cFFADFF2F"..Opt_Italian.."|r")
		end
	elseif arg2 == "language rus" or arg2 == "language russian" or arg2 == "languagerus" or arg2 == "languagerussian" or arg2 == "lang rus" or arg2 == "lang russian" or arg2 == "langrus" or arg2 == "langrussian" then
		if PS_SoundPackName ~= "Custom" then
			PS_SoundPackLanguage = "Rus"
			PS.SoundPack = PS_SoundPackName..""..PS_SoundPackLanguage
		else
			print("|cFF50C0FF"..Opt_CustomDoesntSupport)
		end
		if PS_SoundPackLanguage == "Rus" then
			print("|cFF50C0FF"..Opt_SoundPackLanguage..": |cFFADFF2F"..Opt_Russian.."|r")
		end
	elseif arg2 == "test" or arg2 == "t" then
		print("|cFF50C0FF"..Opt_Test.."...")
		local TestSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."TestDurations")
		PlaySoundFile(TestSoundLengthTable[1].dir, PS_Channel)
		PVPSound:TriggerSct(TestSoundLengthTable[1].name.."!", PSSctFrame)
	elseif arg2 == "testbg" or arg2 == "bgtest" or arg2 == "tb" or arg2 == "bt" then
		PlaySoundFile(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\UnrealTournament3.ogg", PS_Channel)
	elseif arg2 == "reset" then
		PVPSound:ClearSoundQueue()
		PVPSound:ClearKillSoundQueue()
		PVPSound:ClearSoundEffectQueue()
		PVPSound:ClearPaybackQueue()
		PVPSound:ClearRetributionQueue()
		PVPSound:ClearRecentlyPaybackQueue()
		PVPSound:ClearRecentlyKilledQueue()
		PVPSound:ClearSctQueue()
		PVPSound:TimerReset()
		print("|cFF50C0FF"..Opt_Reset..".|r")
	elseif arg2 == "kt" or arg2 == "killtest" then
		local KillSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."KillDurations")
		for i = 1, table.getn(KillSoundLengthTable), 1 do
			PVPSound:TriggerKill("Kill", i)
		end
	elseif arg2 == "mkt" or arg2 == "multikilltest" then
		local MultiKillSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."MultiKillDurations")
		for i = 1, table.getn(MultiKillSoundLengthTable), 1 do
			PVPSound:TriggerKill("MultiKill", i)
		end
	elseif arg2 == "pkt" or arg2 == "paybackkilltest" then
		local PaybackKillSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."PaybackKillDurations")
		for i = 1, table.getn(PaybackKillSoundLengthTable), 1 do
			PVPSound:TriggerKill("PaybackKill", i)
		end
	elseif arg2 == "id" then
		for i = 1, GetNumMapLandmarks(), 1 do
			local name = select(1, GetMapLandmarkInfo(i))
			local textureIndex = select(3, GetMapLandmarkInfo(i))
			local x = select(4, GetMapLandmarkInfo(i))
			local y = select(5, GetMapLandmarkInfo(i))
			if name and textureIndex and x and y then
				local MessageFormat = "%s %s %s %s %s"
				local Message = format(MessageFormat, i, name, textureIndex, x, y)
				print(Message)
			end
		end
	elseif arg2 == "ui" then
		for i = 1, GetNumWorldStateUI(), 1 do
			local name = select(4, GetWorldStateUIInfo(i))
			if name then
				local MessageFormat = "%s %s"
				local Message = format(MessageFormat, i, name)
				print(Message)
			end
		end
	elseif arg2 == "map" then
		local CurrentZoneId = GetCurrentMapAreaID()
		if CurrentZoneId ~= nil or CurrentZoneId ~= "" then
			print("|cFF50C0FF"..L["Current Zone's ID:"].."|r")
			print(CurrentZoneId)
		end
		local CurrentZoneText = GetRealZoneText()
		if CurrentZoneText ~= nil and CurrentZoneText ~= "" then
			print("|cFF50C0FF"..L["Current Zone's Name:"].."|r")
			print(CurrentZoneText)
		end
		local CurrentSubZoneText = GetSubZoneText()
		if CurrentSubZoneText ~= nil and CurrentSubZoneText ~= "" then
			print("|cFF50C0FF"..L["Current SubZone's Name:"].."|r")
			print(CurrentSubZoneText)
		end
	elseif arg2 == "pos" then
		SetMapToCurrentZone()
		local playerPosX, playerPosY = GetPlayerMapPosition("player")
		print("|cFF50C0FF".."X: ".."|r")
		print(playerPosX)
		print("|cFF50C0FF".."Y: ".."|r")
		print(playerPosY)
	else
		PVPSound:PrintSlashHelp()
	end
end

function PVPSound:PrintSlashHelp()
	print("|cFFFFA500PVPSound "..GetAddOnMetadata("PVPSound", "Version").." "..Opt_CmdList.."|r")
	print("|cFF50C0FF/ps - |cFFFFFFA0"..Opt_HelpStatus.."|r")
	print("|cFF50C0FF/ps pvp - |cFFFFFFA0"..Opt_HelpMode.."|r")
	print("|cFF50C0FF/ps emote - |cFFFFFFA0"..Opt_HelpEmote.."|r")
	print("|cFF50C0FF/ps emotemode - |cFFFFFFA0"..Opt_HelpEmoteMode.."|r")
	print("|cFF50C0FF/ps deathmessage - |cFFFFFFA0"..Opt_HelpDeathMessage.."|r")
	print("|cFF50C0FF/ps killsound - |cFFFFFFA0"..Opt_HelpKillSound.."|r")
	print("|cFF50C0FF/ps multikillsound - |cFFFFFFA0"..Opt_HelpMultiKillSound.."|r")
	print("|cFF50C0FF/ps petkill - |cFFFFFFA0"..Opt_HelpPetKill.."|r")
	print("|cFF50C0FF/ps paysound - |cFFFFFFA0"..Opt_HelpPaybackSound.."|r")
	print("|cFF50C0FF/ps bgsound - |cFFFFFFA0"..Opt_HelpBattlegroundSound.."|r")
	print("|cFF50C0FF/ps soundeffect - |cFFFFFFA0"..Opt_HelpSoundEffect.."|r")
	print("|cFF50C0FF/ps killsoundengine - |cFFFFFFA0"..Opt_HelpKillSoundEngine.."|r")
	print("|cFF50C0FF/ps bgsoundengine - |cFFFFFFA0"..Opt_HelpBattlegroundSoundEngine.."|r")
	print("|cFF50C0FF/ps datashare - |cFFFFFFA0"..Opt_HelpDataShare.."|r")
	print("|cFF50C0FF/ps killsct - |cFFFFFFA0"..Opt_HelpKillSct.."|r")
	print("|cFF50C0FF/ps multikillsct - |cFFFFFFA0"..Opt_HelpMultiKillSct.."|r")
	print("|cFF50C0FF/ps paybacksct - |cFFFFFFA0"..Opt_HelpPaybackSct.."|r")
	print("|cFF50C0FF/ps sctengine - |cFFFFFFA0"..Opt_HelpSctEngine.."|r")
	print("|cFF50C0FF/ps frame'framename' - |cFFFFFFA0"..Opt_HelpFrame.."|r")
	print("|cFF50C0FF/ps hideservername - |cFFFFFFA0"..Opt_HelpHideServerName.."|r")
	print("|cFF50C0FF/ps channel'channelname' - |cFFFFFFA0"..Opt_HelpChannel.."|r")
	print("|cFF50C0FF/ps soundpack'soundpackname' - |cFFFFFFA0"..Opt_HelpSoundPack.."|r")
	print("|cFF50C0FF/ps lang'soundpacklanguage' - |cFFFFFFA0"..Opt_HelpSoundPackLanguage.."|r")
	print("|cFF50C0FF/ps test - |cFFFFFFA0"..Opt_HelpTest.."|r")
	print("|cFF50C0FF/ps reset - |cFFFFFFA0"..Opt_HelpReset.."|r")
	print("|cFF50C0FF/ps help - |cFFFFFFA0"..Opt_HelpCmdList.."|r")
end

function PVPSound:PrintSlashMenu()
	print("|cFFFFA500PVPSound "..GetAddOnMetadata("PVPSound", "Version").." "..Opt_HelpInput.."|r")
	if PS_Mode == true then
		print("|cFF50C0FF"..Opt_Mode..": |cFFADFF2F"..Opt_PVP.."|r")
	else
		print("|cFF50C0FF"..Opt_Mode..": |cFFFF4500"..Opt_PVE.."|r")
	end
	if PS_Emote == true then
		print("|cFF50C0FF"..Opt_Emotes..": |cFFADFF2F"..Opt_Enable.."|r")
	else
		print("|cFF50C0FF"..Opt_Emotes..": |cFFFF4500"..Opt_Disable.."|r")
	end
	if PS_EmoteMode == true then
		print("|cFF50C0FF"..Opt_EmoteMode..": |cFFADFF2F"..Opt_Emote.."|r")
	else
		print("|cFF50C0FF"..Opt_EmoteMode..": |cFFFF4500"..Opt_ChatMessage.."|r")
	end
	if PS_DeathMessage == true then
		print("|cFF50C0FF"..Opt_DeathMsg..": |cFFADFF2F"..Opt_Enable.."|r")
	else
		print("|cFF50C0FF"..Opt_DeathMsg..": |cFFFF4500"..Opt_Disable.."|r")
	end
	if PS_KillSound == true then
		print("|cFF50C0FF"..Opt_KillSound..": |cFFADFF2F"..Opt_Enable.."|r")
	else
		print("|cFF50C0FF"..Opt_KillSound..": |cFFFF4500"..Opt_Disable.."|r")
	end
	if PS_MultiKillSound == true then
		print("|cFF50C0FF"..Opt_MultiKillSound..": |cFFADFF2F"..Opt_Enable.."|r")
	else
		print("|cFF50C0FF"..Opt_MultiKillSound..": |cFFFF4500"..Opt_Disable.."|r")
	end
	if PS_PetKill == true then
		print("|cFF50C0FF"..Opt_PetKill..": |cFFADFF2F"..Opt_Enable.."|r")
	else
		print("|cFF50C0FF"..Opt_PetKill..": |cFFFF4500"..Opt_Disable.."|r")
	end
	if PS_PaybackSound == true then
		print("|cFF50C0FF"..Opt_PaySound..": |cFFADFF2F"..Opt_Enable.."|r")
	else
		print("|cFF50C0FF"..Opt_PaySound..": |cFFFF4500"..Opt_Disable.."|r")
	end
	if PS_BattlegroundSound == true then
		print("|cFF50C0FF"..Opt_BgSound..": |cFFADFF2F"..Opt_Enable.."|r")
	else
		print("|cFF50C0FF"..Opt_BgSound..": |cFFFF4500"..Opt_Disable.."|r")
	end
	if PS_SoundEffect == true then
		print("|cFF50C0FF"..Opt_SoundEffect..": |cFFADFF2F"..Opt_Enable.."|r")
	else
		print("|cFF50C0FF"..Opt_SoundEffect..": |cFFFF4500"..Opt_Disable.."|r")
	end
	if PS_KillSoundEngine == true then
		print("|cFF50C0FF"..Opt_KillSoundEngine..": |cFFADFF2F"..Opt_Enable.."|r")
	else
		print("|cFF50C0FF"..Opt_KillSoundEngine..": |cFFFF4500"..Opt_Disable.."|r")
	end
	if PS_BattlegroundSoundEngine == true then
		print("|cFF50C0FF"..Opt_BgSoundEngine..": |cFFADFF2F"..Opt_Enable.."|r")
	else
		print("|cFF50C0FF"..Opt_BgSoundEngine..": |cFFFF4500"..Opt_Disable.."|r")
	end
	if PS_DataShare == true then
		print("|cFF50C0FF"..Opt_DataShare..": |cFFADFF2F"..Opt_Enable.."|r")
	else
		print("|cFF50C0FF"..Opt_DataShare..": |cFFFF4500"..Opt_Disable.."|r")
	end
	if PS_KillSct == true then
		print("|cFF50C0FF"..Opt_KillSct..": |cFFADFF2F"..Opt_Enable.."|r")
	else
		print("|cFF50C0FF"..Opt_KillSct..": |cFFFF4500"..Opt_Disable.."|r")
	end
	if PS_MultiKillSct == true then
		print("|cFF50C0FF"..Opt_MultiKillSct..": |cFFADFF2F"..Opt_Enable.."|r")
	else
		print("|cFF50C0FF"..Opt_MultiKillSct..": |cFFFF4500"..Opt_Disable.."|r")
	end
	if PS_PaybackSct == true then
		print("|cFF50C0FF"..Opt_PaybackSct..": |cFFADFF2F"..Opt_Enable.."|r")
	else
		print("|cFF50C0FF"..Opt_PaybackSct..": |cFFFF4500"..Opt_Disable.."|r")
	end
	if PS_SctEngine == true then
		print("|cFF50C0FF"..Opt_SctEngine..": |cFFADFF2F"..Opt_Enable.."|r")
	else
		print("|cFF50C0FF"..Opt_SctEngine..": |cFFFF4500"..Opt_Disable.."|r")
	end
	if PSSctFrame ~= nil then
		print("|cFF50C0FF"..Opt_Frame..": |cFFADFF2F["..PSSctFrame.."]|r")
	end	
	if PS_HideServerName == true then
		print("|cFF50C0FF"..Opt_HideServerName..": |cFFADFF2F"..Opt_Enable.."|r")
	else
		print("|cFF50C0FF"..Opt_HideServerName..": |cFFFF4500"..Opt_Disable.."|r")
	end
	if PS_Channel == "Master" then
		print("|cFF50C0FF"..Opt_Channel..": |cFFADFF2F"..Opt_Master.."|r")
	elseif PS_Channel == "Sound" then
		print("|cFF50C0FF"..Opt_Channel..": |cFFFF4500"..Opt_Sound.."|r")
	elseif PS_Channel == "Music" then
		print("|cFF50C0FF"..Opt_Channel..": |cFFFF4500"..Opt_Music.."|r")
	elseif PS_Channel == "Ambience" then
		print("|cFF50C0FF"..Opt_Channel..": |cFFFF4500"..Opt_Ambience.."|r")
	end
	if PS_SoundPackName == "UnrealTournament3" then
		print("|cFF50C0FF"..Opt_SoundPack..": |cFFADFF2F"..Opt_UnrealTournament3.."|r")
	elseif PS_SoundPackName == "Custom" then
		print("|cFF50C0FF"..Opt_SoundPack..": |cFFFF4500"..Opt_Custom.."|r")
	end
	if PS_SoundPackLanguage == "Default" then
		print("|cFF50C0FF"..Opt_SoundPackLanguage..": |cFFADFF2F"..Opt_Default.."|r")
	elseif PS_SoundPackLanguage == "Deu" then
		print("|cFF50C0FF"..Opt_SoundPackLanguage..": |cFFADFF2F"..Opt_Deutsch.."|r")
	elseif PS_SoundPackLanguage == "Eng" then
		print("|cFF50C0FF"..Opt_SoundPackLanguage..": |cFFADFF2F"..Opt_English.."|r")
	elseif PS_SoundPackLanguage == "Esn" then
		print("|cFF50C0FF"..Opt_SoundPackLanguage..": |cFFADFF2F"..Opt_Spanish.."|r")
	elseif PS_SoundPackLanguage == "Fra" then
		print("|cFF50C0FF"..Opt_SoundPackLanguage..": |cFFADFF2F"..Opt_France.."|r")
	elseif PS_SoundPackLanguage == "Ita" then
		print("|cFF50C0FF"..Opt_SoundPackLanguage..": |cFFADFF2F"..Opt_Italian.."|r")
	elseif PS_SoundPackLanguage == "Rus" then
		print("|cFF50C0FF"..Opt_SoundPackLanguage..": |cFFADFF2F"..Opt_Russian.."|r")
	end
end