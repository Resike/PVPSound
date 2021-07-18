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
	self:SetBackdrop({
		bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
		edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
		edgeSize = 32,
		tile = "true",
		tileSize = 200,
		insets = { left = 10, right = 10, top = 10, bottom = 10 }
	})
	self:SetBackdropColor(0.1, 0.1, 0.1)
	self:SetBackdropBorderColor(0.9, 1.0, 0.9)
	PVPSoundOptionsHeader:SetText("PVPSound "..GetAddOnMetadata("PVPSound", "Version"))
	PVPSoundOptions:OptionsInitalizeButtons()
	tinsert(UISpecialFrames, self:GetName())
end

function PVPSoundOptions:OptionsTabFramesInitalize(self)
	self:SetBackdrop({
		bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		edgeSize = 22,
		tile = "true",
		tileSize = 128,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	})
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
		frame = _G[name]
	else
		frame = _G[name..postfix]
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
	PVPSoundOptions:OptionsExecuteButtonInitalize(PVPSoundExecuteButton)
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
	PlaySound(841, PS_Channel)
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
		PVPSoundExecuteButton:Enable()
		PVPSoundExecuteButtonText:SetTextColor(1, 1, 1)
		Lib_UIDropDownMenu_EnableDropDown(PVPSoundKillSoundPackDropDown)
		Lib_UIDropDownMenu_EnableDropDown(PVPSoundKillSoundPackLanguageDropDown)
		Lib_UIDropDownMenu_EnableDropDown(PVPSoundSoundPackDropDown)
		Lib_UIDropDownMenu_EnableDropDown(PVPSoundSoundPackLanguageDropDown)
		Lib_UIDropDownMenu_EnableDropDown(PVPSoundSoundChannelDropDown)
		Lib_UIDropDownMenu_EnableDropDown(PVPSoundModeDropDown)
	else
		PS_EnableAddon = false
		PVPSound:UnregisterEvents()
		PVPSound:UnregisterDataEvents()
		PVPSoundKillSoundButton:Disable()
		PVPSoundKillSoundButtonText:SetTextColor(0.5, 0.5, 0.5)
		PVPSoundMultiKillSoundButton:Disable()
		PVPSoundMultiKillSoundButtonText:SetTextColor(0.5, 0.5, 0.5)
		PVPSoundExecuteButton:Disable()
		PVPSoundExecuteButtonText:SetTextColor(0.5, 0.5, 0.5)
		Lib_UIDropDownMenu_DisableDropDown(PVPSoundKillSoundPackDropDown)
		Lib_UIDropDownMenu_DisableDropDown(PVPSoundKillSoundPackLanguageDropDown)
		Lib_UIDropDownMenu_DisableDropDown(PVPSoundSoundPackDropDown)
		Lib_UIDropDownMenu_DisableDropDown(PVPSoundSoundPackLanguageDropDown)
		Lib_UIDropDownMenu_DisableDropDown(PVPSoundSoundChannelDropDown)
		Lib_UIDropDownMenu_DisableDropDown(PVPSoundModeDropDown)
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

function PVPSoundOptions:OptionsExecuteButtonInitalize(self)
	if PVPSoundEnableAddonButton:GetChecked() then
		self:Enable()
		PVPSoundExecuteButtonText:SetTextColor(1, 1, 1)
	else
		self:Disable()
		PVPSoundExecuteButtonText:SetTextColor(0.5, 0.5, 0.5)
	end
	if PS_Execute == true then
		self:SetChecked(true)
	else
		self:SetChecked(false)
	end
end

function PVPSoundOptions:OptionsExecuteButtonToggle(self)
	if self:GetChecked() then
		PS_Execute = true
	else
		PS_Execute = false
	end
end

function PVPSoundOptions.OptionsDropDownMenuInitialize(self)
	local info = Lib_UIDropDownMenu_CreateInfo()
	local name = self:GetName()
	if name == "PVPSoundKillSoundPackDropDown" then
		Lib_UIDropDownMenu_SetWidth(self, 164)
		PVPSoundOptions:OptionsSetKillSoundPack()
		if PVPSoundEnableAddonButton:GetChecked() then
			Lib_UIDropDownMenu_EnableDropDown(PVPSoundKillSoundPackDropDown)
		else
			Lib_UIDropDownMenu_DisableDropDown(PVPSoundKillSoundPackDropDown)
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
		Lib_UIDropDownMenu_AddButton(info)
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
		Lib_UIDropDownMenu_AddButton(info)
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
		Lib_UIDropDownMenu_AddButton(info)
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
		Lib_UIDropDownMenu_AddButton(info)
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
		Lib_UIDropDownMenu_AddButton(info)
	elseif name == "PVPSoundKillSoundPackLanguageDropDown" then
		Lib_UIDropDownMenu_SetWidth(self, 164)
		PVPSoundOptions:OptionsSetKillSoundPack()
		if PVPSoundEnableAddonButton:GetChecked() then
			Lib_UIDropDownMenu_EnableDropDown(PVPSoundKillSoundPackLanguageDropDown)
		else
			Lib_UIDropDownMenu_DisableDropDown(PVPSoundKillSoundPackLanguageDropDown)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
		end
	elseif name == "PVPSoundSoundPackDropDown" then
		Lib_UIDropDownMenu_SetWidth(self, 164)
		PVPSoundOptions:OptionsSetSoundPack()
		if PVPSoundEnableAddonButton:GetChecked() then
			Lib_UIDropDownMenu_EnableDropDown(PVPSoundSoundPackDropDown)
		else
			Lib_UIDropDownMenu_DisableDropDown(PVPSoundSoundPackDropDown)
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
		Lib_UIDropDownMenu_AddButton(info)
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
		Lib_UIDropDownMenu_AddButton(info)
	elseif name == "PVPSoundSoundPackLanguageDropDown" then
		Lib_UIDropDownMenu_SetWidth(self, 164)
		PVPSoundOptions:OptionsSetSoundPack()
		if PVPSoundEnableAddonButton:GetChecked() then
			Lib_UIDropDownMenu_EnableDropDown(PVPSoundSoundPackLanguageDropDown)
		else
			Lib_UIDropDownMenu_DisableDropDown(PVPSoundSoundPackLanguageDropDown)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
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
			Lib_UIDropDownMenu_AddButton(info)
		end
	elseif name == "PVPSoundSoundChannelDropDown" then
		Lib_UIDropDownMenu_SetWidth(self, 164)
		if PVPSoundEnableAddonButton:GetChecked() then
			Lib_UIDropDownMenu_EnableDropDown(PVPSoundSoundChannelDropDown)
		else
			Lib_UIDropDownMenu_DisableDropDown(PVPSoundSoundChannelDropDown)
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
		Lib_UIDropDownMenu_AddButton(info)
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
		Lib_UIDropDownMenu_AddButton(info)
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
		Lib_UIDropDownMenu_AddButton(info)
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
		Lib_UIDropDownMenu_AddButton(info)
	elseif name == "PVPSoundModeDropDown" then
		Lib_UIDropDownMenu_SetWidth(self, 164)
		if PVPSoundEnableAddonButton:GetChecked() then
			Lib_UIDropDownMenu_EnableDropDown(PVPSoundModeDropDown)
		else
			Lib_UIDropDownMenu_DisableDropDown(PVPSoundModeDropDown)
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
		Lib_UIDropDownMenu_AddButton(info)
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
		Lib_UIDropDownMenu_AddButton(info)
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
		Lib_UIDropDownMenu_AddButton(info)
	elseif name == "PVPSoundLanguageDropDown" then
		Lib_UIDropDownMenu_SetWidth(self, 164)
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
		Lib_UIDropDownMenu_AddButton(info)
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
		Lib_UIDropDownMenu_AddButton(info)
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
		Lib_UIDropDownMenu_AddButton(info)
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
		Lib_UIDropDownMenu_AddButton(info)
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
		Lib_UIDropDownMenu_AddButton(info)
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
		Lib_UIDropDownMenu_AddButton(info)
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
		Lib_UIDropDownMenu_AddButton(info)
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
		Lib_UIDropDownMenu_AddButton(info)
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
		Lib_UIDropDownMenu_AddButton(info)
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
		Lib_UIDropDownMenu_AddButton(info)
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
		Lib_UIDropDownMenu_AddButton(info)
	end
end

-- Sound Packs
function PVPSoundOptions:OptionsSetKillSoundPackText(self)
	if PS_KillSoundPackName == "DevilMayCry" then
		Lib_UIDropDownMenu_SetText(self, L["Devil May Cry"])
	elseif PS_KillSoundPackName == "Dota2" then
		Lib_UIDropDownMenu_SetText(self, L["Dota 2"])
	elseif PS_KillSoundPackName == "Halo4" then
		Lib_UIDropDownMenu_SetText(self, L["Halo 4"])
	elseif PS_KillSoundPackName == "UnrealTournament3" then
		Lib_UIDropDownMenu_SetText(self, L["Unreal Tournament 3"])
	elseif PS_KillSoundPackName == "Custom" then
		Lib_UIDropDownMenu_SetText(self, L["Custom"])
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
			Lib_UIDropDownMenu_SetText(PVPSoundKillSoundPackLanguageDropDown, L["English"])
		end
		PVPSoundOptions:OptionsSetKillSoundPack()
		Lib_UIDropDownMenu_SetText(frame, L["Devil May Cry"])
		local TestSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."TestDurations")
		PlaySoundFile(TestSoundLengthTable[1].dir, PS_Channel)
		Lib_CloseDropDownMenus()
	elseif soundpackname == "Dota2" then
		PS_KillSoundPackName = soundpackname
		if PS_KillSoundPackLanguage ~= "Axe" and PS_KillSoundPackLanguage ~= "Bastion" and PS_KillSoundPackLanguage ~= "ClockWerk" and PS_KillSoundPackLanguage ~= "DefenseGrid" and PS_KillSoundPackLanguage ~= "Glados" and PS_KillSoundPackLanguage ~= "Juggernaut" and PS_KillSoundPackLanguage ~= "Lina" and PS_KillSoundPackLanguage ~= "NaturesProphet" and PS_KillSoundPackLanguage ~= "Pflax" and PS_KillSoundPackLanguage ~= "Pirate" and PS_KillSoundPackLanguage ~= "StanleyParable" and PS_KillSoundPackLanguage ~= "StormSpirit" and PS_KillSoundPackLanguage ~= "Trine" then
			PS_KillSoundPackLanguage = "Axe"
			Lib_UIDropDownMenu_SetText(PVPSoundKillSoundPackLanguageDropDown, L["Axe"])
		end
		PVPSoundOptions:OptionsSetKillSoundPack()
		Lib_UIDropDownMenu_SetText(frame, L["Dota 2"])
		local TestSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."TestDurations")
		PlaySoundFile(TestSoundLengthTable[1].dir, PS_Channel)
		Lib_CloseDropDownMenus()
	elseif soundpackname == "Halo4" then
		PS_KillSoundPackName = soundpackname
		if PS_KillSoundPackLanguage ~= "Eng" then
			PS_KillSoundPackLanguage = "Eng"
			Lib_UIDropDownMenu_SetText(PVPSoundKillSoundPackLanguageDropDown, L["English"])
		end
		PVPSoundOptions:OptionsSetKillSoundPack()
		Lib_UIDropDownMenu_SetText(frame, L["Halo 4"])
		local TestSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."TestDurations")
		PlaySoundFile(TestSoundLengthTable[1].dir, PS_Channel)
		Lib_CloseDropDownMenus()
	elseif soundpackname == "UnrealTournament3" then
		PS_KillSoundPackName = soundpackname
		if PS_KillSoundPackLanguage ~= "Deu" and PS_KillSoundPackLanguage ~= "Eng" and PS_KillSoundPackLanguage ~= "Esn" and PS_KillSoundPackLanguage ~= "Fra" and PS_KillSoundPackLanguage ~= "Ita" and PS_KillSoundPackLanguage ~= "Rus" then
			PS_KillSoundPackLanguage = "Eng"
			Lib_UIDropDownMenu_SetText(PVPSoundKillSoundPackLanguageDropDown, L["English"])
		end
		PVPSoundOptions:OptionsSetKillSoundPack()
		Lib_UIDropDownMenu_SetText(frame, L["Unreal Tournament 3"])
		local TestSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."TestDurations")
		PlaySoundFile(TestSoundLengthTable[1].dir, PS_Channel)
		Lib_CloseDropDownMenus()
	elseif soundpackname == "Custom" then
		PS_KillSoundPackName = soundpackname
		if PS_KillSoundPackLanguage ~= "Default" then
			PS_KillSoundPackLanguage = "Default"
			Lib_UIDropDownMenu_SetText(PVPSoundKillSoundPackLanguageDropDown, L["Default"])
		end
		PVPSoundOptions:OptionsSetKillSoundPack()
		Lib_UIDropDownMenu_SetText(frame, L["Custom"])
		PlaySoundFile("Interface\\Addons\\PVPSound_CustomSoundPack\\Sounds\\Custom\\Default\\Test\\01Pancake.mp3", PS_Channel)
		Lib_CloseDropDownMenus()
	end
	PVPSoundOptions:OptionsSetSoundPackLocalizations()
	--print(PS_KillSoundPackName)
end

function PVPSoundOptions:OptionsSetSoundPackText(self)
	if PS_SoundPackName == "UnrealTournament3" then
		Lib_UIDropDownMenu_SetText(self, L["Unreal Tournament 3"])
	elseif PS_SoundPackName == "Custom" then
		Lib_UIDropDownMenu_SetText(self, L["Custom"])
	end
end

function PVPSoundOptions:OptionsSoundPack(name, soundpackname)
	local frame = getglobal(name)
	if soundpackname == "UnrealTournament3" then
		PS_SoundPackName = soundpackname
		if PS_SoundPackLanguage ~= "Deu" and PS_SoundPackLanguage ~= "Eng" and PS_SoundPackLanguage ~= "Esn" and PS_SoundPackLanguage ~= "Fra" and PS_SoundPackLanguage ~= "Ita" and PS_SoundPackLanguage ~= "Rus" then
			PS_SoundPackLanguage = "Eng"
			Lib_UIDropDownMenu_SetText(PVPSoundSoundPackLanguageDropDown, L["English"])
		end
		PVPSoundOptions:OptionsSetSoundPack()
		Lib_UIDropDownMenu_SetText(frame, L["Unreal Tournament 3"])
		PlaySoundFile(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\UnrealTournament3.mp3", PS_Channel)
		Lib_CloseDropDownMenus()
	elseif soundpackname == "Custom" then
		PS_SoundPackName = soundpackname
		if PS_SoundPackLanguage ~= "Default" then
			PS_SoundPackLanguage = "Default"
			Lib_UIDropDownMenu_SetText(PVPSoundSoundPackLanguageDropDown, L["Default"])
		end
		PVPSoundOptions:OptionsSetSoundPack()
		Lib_UIDropDownMenu_SetText(frame, L["Custom"])
		PlaySoundFile("Interface\\Addons\\PVPSound_CustomSoundPack\\Sounds\\Custom\\Default\\GameStatus\\UnrealTournament3.mp3", PS_Channel)
		Lib_CloseDropDownMenus()
	end
	--print(PS_SoundPackName)
end

-- Sound Pack Languages
function PVPSoundOptions:OptionsSetKillSoundPackLanguageText(self)
	if PS_KillSoundPackLanguage == "Default" then
		Lib_UIDropDownMenu_SetText(self, L["Default"])
	elseif PS_KillSoundPackLanguage == "Eng" then
		Lib_UIDropDownMenu_SetText(self, L["English"])
	elseif PS_KillSoundPackLanguage == "Deu" then
		Lib_UIDropDownMenu_SetText(self, L["German"])
	elseif PS_KillSoundPackLanguage == "Esn" then
		Lib_UIDropDownMenu_SetText(self, L["Spanish"])
	elseif PS_KillSoundPackLanguage == "Fra" then
		Lib_UIDropDownMenu_SetText(self, L["French"])
	elseif PS_KillSoundPackLanguage == "Ita" then
		Lib_UIDropDownMenu_SetText(self, L["Italian"])
	elseif PS_KillSoundPackLanguage == "Rus" then
		Lib_UIDropDownMenu_SetText(self, L["Russian"])
	elseif PS_KillSoundPackLanguage == "Axe" then
		Lib_UIDropDownMenu_SetText(self, L["Axe"])
	elseif PS_KillSoundPackLanguage == "Bastion" then
		Lib_UIDropDownMenu_SetText(self, L["Bastion"])
	elseif PS_KillSoundPackLanguage == "ClockWerk" then
		Lib_UIDropDownMenu_SetText(self, L["ClockWerk"])
	elseif PS_KillSoundPackLanguage == "DefenseGrid" then
		Lib_UIDropDownMenu_SetText(self, L["DefenseGrid"])
	elseif PS_KillSoundPackLanguage == "Glados" then
		Lib_UIDropDownMenu_SetText(self, L["Glados"])
	elseif PS_KillSoundPackLanguage == "Juggernaut" then
		Lib_UIDropDownMenu_SetText(self, L["Juggernaut"])
	elseif PS_KillSoundPackLanguage == "Lina" then
		Lib_UIDropDownMenu_SetText(self, L["Lina"])
	elseif PS_KillSoundPackLanguage == "NaturesProphet" then
		Lib_UIDropDownMenu_SetText(self, L["NaturesProphet"])
	elseif PS_KillSoundPackLanguage == "Pflax" then
		Lib_UIDropDownMenu_SetText(self, L["Pflax"])
	elseif PS_KillSoundPackLanguage == "Pirate" then
		Lib_UIDropDownMenu_SetText(self, L["Pirate"])
	elseif PS_KillSoundPackLanguage == "StanleyParable" then
		Lib_UIDropDownMenu_SetText(self, L["StanleyParable"])
	elseif PS_KillSoundPackLanguage == "StormSpirit" then
		Lib_UIDropDownMenu_SetText(self, L["StormSpirit"])
	elseif PS_KillSoundPackLanguage == "Trine" then
		Lib_UIDropDownMenu_SetText(self, L["Trine"])
	end
end

function PVPSoundOptions:OptionsKillSoundPackLanguage(name, soundpacklanguage)
	local frame = getglobal(name)
	if soundpacklanguage == "Default" then
		PS_KillSoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["Default"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "Eng" then
		PS_KillSoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["English"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "Deu" then
		PS_KillSoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["German"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "Esn" then
		PS_KillSoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["Spanish"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "Fra" then
		PS_KillSoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["French"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "Ita" then
		PS_KillSoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["Italian"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "Rus" then
		PS_KillSoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["Russian"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "Axe" then
		PS_KillSoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["Axe"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "Bastion" then
		PS_KillSoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["Bastion"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "ClockWerk" then
		PS_KillSoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["ClockWerk"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "DefenseGrid" then
		PS_KillSoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["DefenseGrid"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "Glados" then
		PS_KillSoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["Glados"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "Juggernaut" then
		PS_KillSoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["Juggernaut"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "Lina" then
		PS_KillSoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["Lina"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "NaturesProphet" then
		PS_KillSoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["NaturesProphet"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "Pflax" then
		PS_KillSoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["Pflax"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "Pirate" then
		PS_KillSoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["Pirate"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "StanleyParable" then
		PS_KillSoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["StanleyParable"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "StormSpirit" then
		PS_KillSoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["StormSpirit"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "Trine" then
		PS_KillSoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["Trine"])
		Lib_CloseDropDownMenus()
	end
	PVPSoundOptions:OptionsSetKillSoundPack()
	PVPSoundOptions:OptionsSetSoundPackLocalizations()
	local TestSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."TestDurations")
	PlaySoundFile(TestSoundLengthTable[1].dir, PS_Channel)
	--print(PS_KillSoundPackLanguage)
end

function PVPSoundOptions:OptionsSetSoundPackLanguageText(self)
	if PS_SoundPackLanguage == "Default" then
		Lib_UIDropDownMenu_SetText(self, L["Default"])
	else
		if PS_SoundPackLanguage == "Eng" then
			Lib_UIDropDownMenu_SetText(self, L["English"])
		elseif PS_SoundPackLanguage == "Deu" then
			Lib_UIDropDownMenu_SetText(self, L["German"])
		elseif PS_SoundPackLanguage == "Esn" then
			Lib_UIDropDownMenu_SetText(self, L["Spanish"])
		elseif PS_SoundPackLanguage == "Fra" then
			Lib_UIDropDownMenu_SetText(self, L["French"])
		elseif PS_SoundPackLanguage == "Ita" then
			Lib_UIDropDownMenu_SetText(self, L["Italian"])
		elseif PS_SoundPackLanguage == "Rus" then
			Lib_UIDropDownMenu_SetText(self, L["Russian"])
		end
	end
end

function PVPSoundOptions:OptionsSoundPackLanguage(name, soundpacklanguage)
	local frame = getglobal(name)
	if soundpacklanguage == "Default" then
		PS_SoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["Default"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "Eng" then
		PS_SoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["English"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "Deu" then
		PS_SoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["German"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "Esn" then
		PS_SoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["Spanish"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "Fra" then
		PS_SoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["French"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "Ita" then
		PS_SoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["Italian"])
		Lib_CloseDropDownMenus()
	elseif soundpacklanguage == "Rus" then
		PS_SoundPackLanguage = soundpacklanguage
		Lib_UIDropDownMenu_SetText(frame, L["Russian"])
		Lib_CloseDropDownMenus()
	end
	PVPSoundOptions:OptionsSetSoundPack()
	PlaySoundFile(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\UnrealTournament3.mp3", PS_Channel)
	--print(PS_SoundPackLanguage)
end

-- Channels
function PVPSoundOptions:OptionsSetSoundChannelText(self)
	if PS_Channel == "Master" then
		Lib_UIDropDownMenu_SetText(self, L["Master"])
	elseif PS_Channel == "Sound" then
		Lib_UIDropDownMenu_SetText(self, L["Sound"])
	elseif PS_Channel == "Music" then
		Lib_UIDropDownMenu_SetText(self, L["Music"])
	elseif PS_Channel == "Ambience" then
		Lib_UIDropDownMenu_SetText(self, L["Ambience"])
	end
end

function PVPSoundOptions:OptionsSoundChannel(name, soundchannel)
	local frame = getglobal(name)
	if soundchannel == "Master" then
		PS_Channel = soundchannel
		Lib_UIDropDownMenu_SetText(frame, L["Master"])
		Lib_CloseDropDownMenus()
	elseif soundchannel == "Sound" then
		PS_Channel = soundchannel
		Lib_UIDropDownMenu_SetText(frame, L["Sound"])
		Lib_CloseDropDownMenus()
	elseif soundchannel == "Music" then
		PS_Channel = soundchannel
		Lib_UIDropDownMenu_SetText(frame, L["Music"])
		Lib_CloseDropDownMenus()
	elseif soundchannel == "Ambience" then
		PS_Channel = soundchannel
		Lib_UIDropDownMenu_SetText(frame, L["Ambience"])
		Lib_CloseDropDownMenus()
	end
	local TestSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."TestDurations")
	PlaySoundFile(TestSoundLengthTable[1].dir, PS_Channel)
	--print(PS_Channel)
end

-- Modes
function PVPSoundOptions:OptionsSetModeText(self)
	if PS_Mode == "PVP" then
		Lib_UIDropDownMenu_SetText(self, L["PVP"])
	elseif PS_Mode == "PVE" then
		Lib_UIDropDownMenu_SetText(self, L["PVE"])
	elseif PS_Mode == "PVPandPVE" then
		Lib_UIDropDownMenu_SetText(self, L["PVP and PVE"])
	end
end

function PVPSoundOptions:OptionsMode(name, mode)
	local frame = getglobal(name)
	if mode == "PVP" then
		PS_Mode = mode
		Lib_UIDropDownMenu_SetText(frame, L["PVP"])
		Lib_CloseDropDownMenus()
	elseif mode == "PVE" then
		PS_Mode = mode
		Lib_UIDropDownMenu_SetText(frame, L["PVE"])
		Lib_CloseDropDownMenus()
	elseif mode == "PVPandPVE" then
		PS_Mode = mode
		Lib_UIDropDownMenu_SetText(frame, L["PVP and PVE"])
		Lib_CloseDropDownMenus()
	end
	--print(PS_Mode)
end

-- Addon Languages
function PVPSoundOptions:OptionsSetAddonLanguageText(self)
	if PS_AddonLanguage == "English" then
		Lib_UIDropDownMenu_SetText(self, "English")
	elseif PS_AddonLanguage == "German" then
		Lib_UIDropDownMenu_SetText(self, "German")
	elseif PS_AddonLanguage == "Spanish" then
		Lib_UIDropDownMenu_SetText(self, "Español")
	elseif PS_AddonLanguage == "LatinAmericanSpanish" then
		Lib_UIDropDownMenu_SetText(self, "El español de América")
	elseif PS_AddonLanguage == "French" then
		Lib_UIDropDownMenu_SetText(self, "Français")
	elseif PS_AddonLanguage == "Italian" then
		Lib_UIDropDownMenu_SetText(self, "Italiano")
	elseif PS_AddonLanguage == "Korean" then
		Lib_UIDropDownMenu_SetText(self, "한국의")
	elseif PS_AddonLanguage == "Portuguese" then
		Lib_UIDropDownMenu_SetText(self, "Português")
	elseif PS_AddonLanguage == "Russian" then
		Lib_UIDropDownMenu_SetText(self, "Русский")
	elseif PS_AddonLanguage == "SimplifiedChinese" then
		Lib_UIDropDownMenu_SetText(self, "简体中国")
	elseif PS_AddonLanguage == "TraditionalChinese" then
		Lib_UIDropDownMenu_SetText(self, "繁體中文")
	end
end

function PVPSoundOptions:OptionsAddonLanguage(name, language)
	local frame = getglobal(name)
	if language == "English" then
		PS_AddonLanguage = language
		PVPSound:English()
		Lib_UIDropDownMenu_SetText(frame, "English")
		Lib_CloseDropDownMenus()
	elseif language == "German" then
		PS_AddonLanguage = language
		PVPSound:German()
		Lib_UIDropDownMenu_SetText(frame, "German")
		Lib_CloseDropDownMenus()
	elseif language == "Spanish" then
		PS_AddonLanguage = language
		PVPSound:Spanish()
		Lib_UIDropDownMenu_SetText(frame, "Español")
		Lib_CloseDropDownMenus()
	elseif language == "LatinAmericanSpanish" then
		PS_AddonLanguage = language
		PVPSound:LatinAmericanSpanish()
		Lib_UIDropDownMenu_SetText(frame, "El español de América")
		Lib_CloseDropDownMenus()
	elseif language == "French" then
		PS_AddonLanguage = language
		PVPSound:French()
		Lib_UIDropDownMenu_SetText(frame, "Français")
		Lib_CloseDropDownMenus()
	elseif language == "Italian" then
		PS_AddonLanguage = language
		PVPSound:Italian()
		Lib_UIDropDownMenu_SetText(frame, "Italiano")
		Lib_CloseDropDownMenus()
	elseif language == "Korean" then
		PS_AddonLanguage = language
		PVPSound:Korean()
		Lib_UIDropDownMenu_SetText(frame, "한국의")
		Lib_CloseDropDownMenus()
	elseif language == "Portuguese" then
		PS_AddonLanguage = language
		PVPSound:Portuguese()
		Lib_UIDropDownMenu_SetText(frame, "Português")
		Lib_CloseDropDownMenus()
	elseif language == "Russian" then
		PS_AddonLanguage = language
		PVPSound:Russian()
		Lib_UIDropDownMenu_SetText(frame, "Русский")
		Lib_CloseDropDownMenus()
	elseif language == "SimplifiedChinese" then
		PS_AddonLanguage = language
		PVPSound:SimplifiedChinese()
		Lib_UIDropDownMenu_SetText(frame, "简体中国")
		Lib_CloseDropDownMenus()
	elseif language == "TraditionalChinese" then
		PS_AddonLanguage = language
		PVPSound:TraditionalChinese()
		Lib_UIDropDownMenu_SetText(frame, "繁體中文")
		Lib_CloseDropDownMenus()
	end
	PVPSoundOptions:OptionsUpdateLocalization()
	PVPSoundOptions:OptionsUpdateFonts()
	Lib_UIDropDownMenu_Initialize(frame, PVPSoundOptions.OptionsDropDownMenuInitialize)
	Lib_UIDropDownMenu_Initialize(PVPSoundKillSoundPackDropDown, PVPSoundOptions.OptionsDropDownMenuInitialize)
	Lib_UIDropDownMenu_Initialize(PVPSoundKillSoundPackLanguageDropDown, PVPSoundOptions.OptionsDropDownMenuInitialize)
	Lib_UIDropDownMenu_Initialize(PVPSoundSoundPackDropDown, PVPSoundOptions.OptionsDropDownMenuInitialize)
	Lib_UIDropDownMenu_Initialize(PVPSoundSoundPackLanguageDropDown, PVPSoundOptions.OptionsDropDownMenuInitialize)
	Lib_UIDropDownMenu_Initialize(PVPSoundSoundChannelDropDown, PVPSoundOptions.OptionsDropDownMenuInitialize)
	Lib_UIDropDownMenu_Initialize(PVPSoundModeDropDown, PVPSoundOptions.OptionsDropDownMenuInitialize)
end

function PVPSoundOptions:OptionsUpdateLocalization()
	PVPSoundOptions:OptionsSetText(PVPSoundTab1, nil, "General")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab2, nil, "AV")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab3, nil, "AB")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab4, nil, "DG")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab5, nil, "EOTS")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab6, nil, "IOC")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab7, nil, "SM")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab8, nil, "SOTA")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab9, nil, "TOK")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab10, nil, "TBFG")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab11, nil, "TP")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab12, nil, "WSG")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab13, nil, "TB")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab14, nil, "WG")
	PVPSoundOptions:OptionsSetText(PVPSoundTab1Frame, "Text", "General")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab2Frame, "Text", "Alterac Valley")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab3Frame, "Text", "Arathi Basin")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab4Frame, "Text", "Deepwind Gorge")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab5Frame, "Text", "Eye of the Storm")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab6Frame, "Text", "Isle of Conquest")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab7Frame, "Text", "Silvershard Mines")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab8Frame, "Text", "Strand of the Ancients")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab9Frame, "Text", "Temple of Kotmogu")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab10Frame, "Text", "The Battle for Gilneas")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab11Frame, "Text", "Twin Peaks")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab12Frame, "Text", "Warsong Gulch")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab13Frame, "Text", "Tol Barad")
	--PVPSoundOptions:OptionsSetText(PVPSoundTab14Frame, "Text", "Wintergrasp")
	--PVPSoundOptions:OptionsSetText(PVPSoundLanguageDropDown, "Label", "Addon Language")
	--PVPSoundOptions:OptionsSetText(PVPSoundEnableAddonButton, "Text", "Enable addon")
	--PVPSoundOptions:OptionsSetText(PVPSoundKillSoundPackDropDown, "Label", "Kill Sound Pack")
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
	PVPSoundOptions:OptionsSetText(PVPSoundExecuteButton, "Text", "Enable Execute Sounds")
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
			L["Streak1Male"] = "is"
			L["Streak1Female"] = "is"
			L["Streak2"] = "is"
			L["Streak3"] = "is"
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
			print("|cFF50C0FFEnable Addon: |cFFADFF2F"..L["[Enable]"].."|r")
		else
			print("|cFF50C0FFEnable Addon: |cFFFF4500"..L["[Disable]"].."|r")
		end
	elseif arg2 == "pvp" then
		PS_Mode = "PVP"
		if PS_Mode == "PVP" then
			print("|cFF50C0FF"..L["Mode"]..": |cFFADFF2F"..L["[PVP]"].."|r")
		end
	elseif arg2 == "pve" then
		PS_Mode = "PVE"
		if PS_Mode == "PVE" then
			print("|cFF50C0FF"..L["Mode"]..": |cFFFF4500"..L["[PVE]"].."|r")
		end
	elseif arg2 == "pvpandpve" then
		PS_Mode = "PVPandPVE"
		if PS_Mode == "PVPandPVE" then
			print("|cFF50C0FF"..L["Mode"]..": |cFFFF4500"..L["PVPandPVE"].."|r")
		end
	elseif arg2 == "emote" then
		PS_Emote = not PS_Emote
		if PS_Emote == true then
			print("|cFF50C0FF"..L["Emotes"]..": |cFFADFF2F"..L["[Enable]"].."|r")
		else
			print("|cFF50C0FF"..L["Emotes"]..": |cFFFF4500"..L["[Disable]"].."|r")
		end
	elseif arg2 == "emotemode" or arg2 == "emote mode" then
		PS_EmoteMode = not PS_EmoteMode
		if PS_EmoteMode == true then
			print("|cFF50C0FF"..L["Emote mode"]..": |cFFADFF2F"..L["[Emote]"].."|r")
		else
			print("|cFF50C0FF"..L["Emote mode"]..": |cFFFF4500"..L["[Chat Message]"].."|r")
		end
	elseif arg2 == "dm" or arg2 == "deathmessage" or arg2 == "death message" or arg2 == "deathmessages" or arg2 == "death messages" then
		PS_DeathMessage = not PS_DeathMessage
		if PS_DeathMessage == true then
			print("|cFF50C0FF"..L["Death messages"]..": |cFFADFF2F"..L["[Enable]"].."|r")
		else
			print("|cFF50C0FF"..L["Death messages"]..": |cFFFF4500"..L["[Disable]"].."|r")
		end
	elseif arg2 == "ks" or arg2 == "killsound" or arg2 == "kill sound" or arg2 == "killsounds" or arg2 == "kill sounds" then
		PS_KillSound = not PS_KillSound
		if PS_KillSound == true then
			print("|cFF50C0FF"..L["Killing Blow sounds"]..": |cFFADFF2F"..L["[Enable]"].."|r")
		else
			print("|cFF50C0FF"..L["Killing Blow sounds"]..": |cFFFF4500"..L["[Disable]"].."|r")
		end
	elseif arg2 == "mks" or arg2 == "multikillsound" or arg2 == "multikill sound" or arg2 == "multi kill sound" or arg2 == "multi killsound" or arg2 == "multikillsounds" or arg2 == "multikill sounds" or arg2 == "multi kill sounds" or arg2 == "multi killsounds" then
		PS_MultiKillSound = not PS_MultiKillSound
		if PS_MultiKillSound == true then
			print("|cFF50C0FF"..L["Multi Killing sounds"]..": |cFFADFF2F"..L["[Enable]"].."|r")
		else
			print("|cFF50C0FF"..L["Multi Killing sounds"]..": |cFFFF4500"..L["[Disable]"].."|r")
		end
	elseif arg2 == "pk" or arg2 == "petkill" or arg2 == "pet kill" or arg2 == "petkills" or arg2 == "pet kills" then
		PS_PetKill = not PS_PetKill
		if PS_PetKill == true then
			print("|cFF50C0FF"..L["Pet Killing Blows"]..": |cFFADFF2F"..L["[Enable]"].."|r")
		else
			print("|cFF50C0FF"..L["Pet Killing Blows"]..": |cFFFF4500"..L["[Disable]"].."|r")
		end
	elseif arg2 == "ps" or arg2 == "paysound" or arg2 == "pay sound" or arg2 == "paybacksound" or arg2 == "payback sound" or arg2 == "paysounds" or arg2 == "pay sounds" or arg2 == "paybacksounds" or arg2 == "payback sounds" then
		PS_PaybackSound = not PS_PaybackSound
		if PS_PaybackSound == true then
			print("|cFF50C0FF"..L["Payback sounds"]..": |cFFADFF2F"..L["[Enable]"].."|r")
		else
			print("|cFF50C0FF"..L["Payback sounds"]..": |cFFFF4500"..L["[Disable]"].."|r")
		end
	elseif arg2 == "bs" or arg2 == "bgsound" or arg2 == "bg sound" or arg2 == "battlegroundsound" or arg2 == "battleground sound" or arg2 == "bgsounds" or arg2 == "bg sounds" or arg2 == "battlegroundsounds" or arg2 == "battleground sounds" then
		PS_BattlegroundSound = not PS_BattlegroundSound
		if PS_BattlegroundSound == true then
			print("|cFF50C0FF"..L["Battleground sounds"]..": |cFFADFF2F"..L["[Enable]"].."|r")
		else
			print("|cFF50C0FF"..L["Battleground sounds"]..": |cFFFF4500"..L["[Disable]"].."|r")
		end
	elseif arg2 == "se" or arg2 == "soundeffect" or arg2 == "sound effect" or arg2 == "effectsound" or arg2 == "effect sound" then
		PS_SoundEffect = not PS_SoundEffect
		if PS_SoundEffect == true then
			print("|cFF50C0FF"..L["Sound Effects"]..": |cFFADFF2F"..L["[Enable]"].."|r")
		else
			print("|cFF50C0FF"..L["Sound Effects"]..": |cFFFF4500"..L["[Disable]"].."|r")
		end
	elseif arg2 == "kse" or arg2 == "killsoundengine" or arg2 == "killsound engine" or arg2 == "kill sound engine" or arg2 == "kill soundengine" then
		PS_KillSoundEngine = not PS_KillSoundEngine
		if PS_KillSoundEngine == true then
			print("|cFF50C0FF"..L["Kill Sound Engine"]..": |cFFADFF2F"..L["[Enable]"].."|r")
		else
			print("|cFF50C0FF"..L["Kill Sound Engine"]..": |cFFFF4500"..L["[Disable]"].."|r")
		end
	elseif arg2 == "bse" or arg2 == "bgsoundengine" or arg2 == "bgsound engine" or arg2 == "bg sound engine" or arg2 == "bg soundengine" or arg2 == "battleground soundengine" or arg2 == "battlegroundsoundengine" or arg2 == "battleground sound engine" or arg2 == "battlegroundsound engine" then
		PS_BattlegroundSoundEngine = not PS_BattlegroundSoundEngine
		if PS_BattlegroundSoundEngine == true then
			print("|cFF50C0FF"..L["Battleground Sound Engine"]..": |cFFADFF2F"..L["[Enable]"].."|r")
		else
			print("|cFF50C0FF"..L["Battleground Sound Engine"]..": |cFFFF4500"..L["[Disable]"].."|r")
		end
	elseif arg2 == "ds" or arg2 == "datashare" or arg2 == "data share" or arg2 == "datasharing" or arg2 == "data sharing" then
		PS_DataShare = not PS_DataShare
		if PS_DataShare == true then
			print("|cFF50C0FF"..L["Data Sharing"]..": |cFFADFF2F"..L["[Enable]"].."|r")
		else
			print("|cFF50C0FF"..L["Data Sharing"]..": |cFFFF4500"..L["[Disable]"].."|r")
		end
	elseif arg2 == "ksct" or arg2 == "killsct" or arg2 == "kill sct" then
		PS_KillSct = not PS_KillSct
		if PS_KillSct == true then
			print("|cFF50C0FF"..L["Kill Scrolling Combat Text mode"]..": |cFFADFF2F"..L["[Enable]"].."|r")
		else
			print("|cFF50C0FF"..L["Kill Scrolling Combat Text mode"]..": |cFFFF4500"..L["[Disable]"].."|r")
		end
	elseif arg2 == "mksct" or arg2 == "multikillsct" or arg2 == "multikill sct" or arg2 == "multi kill sct" or arg2 == "multi killsct" then
		PS_MultiKillSct = not PS_MultiKillSct
		if PS_MultiKillSct == true then
			print("|cFF50C0FF"..L["Multi Kill Scrolling Combat Text"]..": |cFFADFF2F"..L["[Enable]"].."|r")
		else
			print("|cFF50C0FF"..L["Multi Kill Scrolling Combat Text"]..": |cFFFF4500"..L["[Disable]"].."|r")
		end
	elseif arg2 == "psct" or arg2 == "paybacksct" or arg2 == "payback sct" then
		PS_PaybackSct = not PS_PaybackSct
		if PS_PaybackSct == true then
			print("|cFF50C0FF"..L["Payback Scrolling Combat Text"]..": |cFFADFF2F"..L["[Enable]"].."|r")
		else
			print("|cFF50C0FF"..L["Payback Scrolling Combat Text"]..": |cFFFF4500"..L["[Disable]"].."|r")
		end
	elseif arg2 == "scte" or arg2 == "sctengine" or arg2 == "sct engine" then
		PS_SctEngine = not PS_SctEngine
		if PS_SctEngine == true then
			print("|cFF50C0FF"..L["Scrolling Combat Text Engine"]..": |cFFADFF2F"..L["[Enable]"].."|r")
		else
			print("|cFF50C0FF"..L["Scrolling Combat Text Engine"]..": |cFFFF4500"..L["[Disable]"].."|r")
		end
	elseif string.find(arg1, "frame(.+)") then
		if string.find(arg1, "frame ") then
			PSSctFrame = tostring(string.match(arg1, "frame (.+)"))
		else
			PSSctFrame = tostring(string.match(arg1, "frame(.+)"))
		end
		if PSSctFrame ~= nil then
			print("|cFF50C0FF"..L["Scrolling Combat Text frame name"]..": |cFFADFF2F["..PSSctFrame.."]|r")
		end
	elseif arg2 == "hsn" or arg2 == "hideservername" or arg2 == "hideserver name" or arg2 == "hide server name" or arg2 == "hide servername" or arg2 == "hideservernames" or arg2 == "hideserver names" or arg2 == "hide server names" or arg2 == "hide servernames" or arg2 == "hs" or arg2 == "hide server" or arg2 == "hideserver" then
		PS_HideServerName = not PS_HideServerName
		if PS_HideServerName == true then
			print("|cFF50C0FF"..L["Hide server names"]..": |cFFADFF2F"..L["[Enable]"].."|r")
		else
			print("|cFF50C0FF"..L["Hide server names"]..": |cFFFF4500"..L["[Disable]"].."|r")
		end
	elseif arg2 == "cm" or arg2 == "channelmaster" or arg2 == "channel master" then
		PS_Channel = "Master"
		if PS_Channel == "Master" then
			print("|cFF50C0FF"..L["Sound channel output"]..": |cFFADFF2F"..L["[Master]"].."|r")
		end
	elseif arg2 == "cs" or arg2 == "channelsound" or arg2 == "channel sound" then
		PS_Channel = "Sound"
		if PS_Channel == "Sound" then
			print("|cFF50C0FF"..L["Sound channel output"]..": |cFFFF4500"..L["[Sound]"].."|r")
		end
	elseif arg2 == "cmu" or arg2 == "channelmusic" or arg2 == "channel music" then
		PS_Channel = "Music"
		if PS_Channel == "Music" then
			print("|cFF50C0FF"..L["Sound channel output"]..": |cFFFF4500"..L["[Music]"].."|r")
		end
	elseif arg2 == "ca" or arg2 == "channelambience" or arg2 == "channel ambience" then
		PS_Channel = "Ambience"
		if PS_Channel == "Ambience" then
			print("|cFF50C0FF"..L["Sound channel output"]..": |cFFFF4500"..L["[Ambience]"].."|r")
		end
	elseif arg2 == "ex" or arg2 == "execute" or arg2 == "exc" then
		PS_Execute = not PS_Execute
		if PS_Execute == true then
			print("|cFF50C0FF"..L["Execute sounds"]..": |cFFADFF2F"..L["[Enable]"].."|r")
		else
			print("|cFF50C0FF"..L["Execute sounds"]..": |cFFFF4500"..L["[Disable]"].."|r")
		end
	elseif arg2 == "soundpack ut3" or arg2 == "soundpack unrealtournament3" or arg2 == "sp ut3" or arg2 == "sp unrealtournament3" or arg2 == "soundpackut3" or arg2 == "soundpackunrealtournament3" or arg2 == "sput3" or arg2 == "spunrealtournament3" then
		PS_SoundPackName = "UnrealTournament3"
		PS.SoundPackDirectory = "Interface\\Addons\\PVPSound\\Sounds\\"..PS_SoundPackName
		if PS_SoundPackName == "UnrealTournament3" then
			print("|cFF50C0FF"..L["Sound Pack"]..": |cFFADFF2F"..L["[Unreal Tournament 3]"].."|r")
		end
		if PS_SoundPackLanguage == "Deu" or PS_SoundPackLanguage == "Eng" or PS_SoundPackLanguage == "Esn" or PS_SoundPackLanguage == "Fra" or PS_SoundPackLanguage == "Ita" or PS_SoundPackLanguage == "Rus" then
			return false
		else
			PS_SoundPackLanguage = "Eng"
			PS.SoundPack = PS_SoundPackName..""..PS_SoundPackLanguage
			print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[English]"].."|r")
		end
	elseif arg2 == "soundpack custom" or arg2 == "sp custom" or arg2 == "soundpackcustom" or arg2 == "spcustom" then
		PS_SoundPackName = "Custom"
		PS.SoundPackDirectory = "Interface\\Addons\\PVPSound_CustomSoundPack\\Sounds\\"..PS_SoundPackName
		if PS_SoundPackName == "Custom" then
			print("|cFF50C0FF"..L["Sound Pack"]..": |cFFFF4500"..L["[Custom]"].."|r")
		end
		if PS_SoundPackLanguage ~= "Default" then
			PS_SoundPackLanguage = "Default"
			PS.SoundPack = PS_SoundPackName..""..PS_SoundPackLanguage
			print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[Default]"].."|r")
		end
	elseif arg2 == "splanguage deu" or arg2 == "splanguage deutsch" or arg2 == "splanguagedeu" or arg2 == "splanguagedeutsch" or arg2 == "splang deu" or arg2 == "splang deutsch" or arg2 == "splangdeu" or arg2 == "splangdeutsch" then
		if PS_SoundPackName ~= "Custom" then
			PS_SoundPackLanguage = "Deu"
			PS.SoundPack = PS_SoundPackName..""..PS_SoundPackLanguage
		else
			print("|cFF50C0FF"..L["Custom Sound Pack doesn't support that language!"])
		end
		if PS_SoundPackLanguage == "Deu" then
			print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[Deutsch]"].."|r")
		end
	elseif arg2 == "splanguage eng" or arg2 == "splanguage english" or arg2 == "splanguageeng" or arg2 == "splanguageenglish" or arg2 == "splang eng" or arg2 == "splang english" or arg2 == "splangeng" or arg2 == "splangenglish" then
		if PS_SoundPackName ~= "Custom" then
			PS_SoundPackLanguage = "Eng"
			PS.SoundPack = PS_SoundPackName..""..PS_SoundPackLanguage
		else
			print("|cFF50C0FF"..L["Custom Sound Pack doesn't support that language!"])
		end
		if PS_SoundPackLanguage == "Eng" then
			print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[English]"].."|r")
		end
	elseif arg2 == "splanguage esn" or arg2 == "splanguage espanol" or arg2 == "splanguageesn" or arg2 == "splanguageespanol" or arg2 == "splang esn" or arg2 == "splang espanol" or arg2 == "splangesn" or arg2 == "splangespanol" or arg2 == "splanguage spa" or arg2 == "splanguage spanish" or arg2 == "splanguagespa" or arg2 == "splanguagespanish" or arg2 == "splang spa" or arg2 == "splang spanish" or arg2 == "splangspa" or arg2 == "splangspanish"then
		if PS_SoundPackName ~= "Custom" then
			PS_SoundPackLanguage = "Esn"
			PS.SoundPack = PS_SoundPackName..""..PS_SoundPackLanguage
		else
			print("|cFF50C0FF"..L["Custom Sound Pack doesn't support that language!"])
		end
		if PS_SoundPackLanguage == "Esn" then
			print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[Spanish]"].."|r")
		end
	elseif arg2 == "splanguage fra" or arg2 == "splanguage france" or arg2 == "splanguagefra" or arg2 == "splanguagefrance" or arg2 == "splang fra" or arg2 == "splang france" or arg2 == "splangfra" or arg2 == "splangfrance" then
		if PS_SoundPackName ~= "Custom" then
			PS_SoundPackLanguage = "Fra"
			PS.SoundPack = PS_SoundPackName..""..PS_SoundPackLanguage
		else
			print("|cFF50C0FF"..L["Custom Sound Pack doesn't support that language!"])
		end
		if PS_SoundPackLanguage == "Fra" then
			print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[France]"].."|r")
		end
	elseif arg2 == "splanguage ita" or arg2 == "splanguage italian" or arg2 == "splanguageita" or arg2 == "splanguageitalian" or arg2 == "splang ita" or arg2 == "splang italian" or arg2 == "splangita" or arg2 == "splangitalian" then
		if PS_SoundPackName ~= "Custom" then
			PS_SoundPackLanguage = "Ita"
			PS.SoundPack = PS_SoundPackName..""..PS_SoundPackLanguage
		else
			print("|cFF50C0FF"..L["Custom Sound Pack doesn't support that language!"])
		end
		if PS_SoundPackLanguage == "Ita" then
			print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[Italian]"].."|r")
		end
	elseif arg2 == "splanguage rus" or arg2 == "splanguage russian" or arg2 == "splanguagerus" or arg2 == "splanguagerussian" or arg2 == "splang rus" or arg2 == "splang russian" or arg2 == "splangrus" or arg2 == "splangrussian" then
		if PS_SoundPackName ~= "Custom" then
			PS_SoundPackLanguage = "Rus"
			PS.SoundPack = PS_SoundPackName..""..PS_SoundPackLanguage
		else
			print("|cFF50C0FF"..L["Custom Sound Pack doesn't support that language!"])
		end
		if PS_SoundPackLanguage == "Rus" then
			print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[Russian]"].."|r")
		end
	elseif arg2 == "test" or arg2 == "t" then
		print("|cFF50C0FF"..L["Scrolling Combat Text and sound test"].."...")
		local TestSoundLengthTable = getglobal("PVPSound_"..PS.KillSoundPack.."TestDurations")
		PlaySoundFile(TestSoundLengthTable[1].dir, PS_Channel)
		PVPSound:TriggerSct(TestSoundLengthTable[1].name.."!", PSSctFrame)
	elseif arg2 == "testbg" or arg2 == "bgtest" or arg2 == "tb" or arg2 == "bt" then
		PlaySoundFile(PS.SoundPackDirectory.."\\"..PS_SoundPackLanguage.."\\GameStatus\\UnrealTournament3.mp3", PS_Channel)
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
		print("|cFF50C0FF"..L["Killing Counter and Sound Queue reset"]..".|r")
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
	elseif arg2 == "poi" then
		--POIs updated for 8.0.1
		local mapId = C_Map.GetBestMapForUnit("player")
		local POIs = C_AreaPoiInfo.GetAreaPOIForMap(mapId)
		if POIs == nil then
			print("There is no POIs in this zone")
		else
			print("There is "..#POIs.." POIs in this zone")
			for i = 1, #POIs, 1 do
				local info = C_AreaPoiInfo.GetAreaPOIInfo(mapId, POIs[i])
				local id = info.areaPoiID
				local name = info.name
				local desc = info.description
				local textureIndex = info.textureIndex
				local x = info.position.x
				local y = info.position.y
				print(i, id, name, desc, textureIndex, x ,y)
			end
		end
	elseif arg2 == "ui" then
		--updated for 8.0.1
		--check only top center "DoubleStatusBar" widgets
		local setId = C_UIWidgetManager.GetTopCenterWidgetSetID()
		local wgts = C_UIWidgetManager.GetAllWidgetsBySetID(setId)
		if wgts == nil then
			print("There is no UI widgets in this zone")
		else
			print("There is "..#wgts.." top wigets in this zone")
			for i = 1, #wgts, 1 do
				print("Type: ", wgts[i].widgetType)
				print(" Id: ", wgts[i].widgetID)
			end
		end
	elseif arg2 == "map" then
		--updated for 8.0.1
		local CurrentZoneId = C_Map.GetBestMapForUnit("player")
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
	elseif arg2 == "inst" then
		local instInfo = GetInstanceInfo()
		if instInfo.name then
			print("|cFF50C0FF"..L["Instance name:"].."|r")
			print(instInfo.name)
		end
		if instInfo.instanceType then
			print("|cFF50C0FF"..L["Instance type:"].."|r")
			print(instInfo.instanceType)
		end
		if instInfo.instanceID then
			print("|cFF50C0FF"..L["Instance id:"].."|r")
			print(instInfo.instanceID)
		end
	elseif arg2 == "pos" then
		--updated for 8.0.1
		local mapId = C_Map.GetBestMapForUnit("player")
		local playerPos = C_Map.GetPlayerMapPosition(mapId,"player")
		if (playerPos) then
			print("|cFF50C0FF".."X: ".."|r")
			print(playerPos.x)
			print("|cFF50C0FF".."Y: ".."|r")
			print(playerPos.y)
		else
			print("Can't get a position")
		end
	elseif arg2 == "conflist" then
		PVPSound.ConfigDump()
	elseif arg2 == "perflist" then
		PVPSound.perfDump()
	elseif arg2 == "lang rus" then
		PS_AddonLanguage = "Russian"
		PVPSound:SetAddonLanguage()
		PVPSoundOptions:OptionsUpdateLocalization()
		PVPSoundOptions:OptionsUpdateFonts()
		print("|cFF50C0FF"..L["Addon language"]..": |cFFADFF2F"..L["[Russian]"].."|r")
	elseif arg2 == "lang eng" then
		PS_AddonLanguage = "English"
		PVPSound:SetAddonLanguage()
		PVPSoundOptions:OptionsUpdateLocalization()
		PVPSoundOptions:OptionsUpdateFonts()
		print("|cFF50C0FF"..L["Addon language"]..": |cFFADFF2F"..L["[English]"].."|r")
	elseif arg2 == "lang deu" then
		PS_AddonLanguage = "German"
		PVPSound:SetAddonLanguage()
		PVPSoundOptions:OptionsUpdateLocalization()
		PVPSoundOptions:OptionsUpdateFonts()
		print("|cFF50C0FF"..L["Addon language"]..": |cFFADFF2F"..L["[German]"].."|r")
	elseif arg2 == "lang esn" then
		PS_AddonLanguage = "Spanish"
		PVPSound:SetAddonLanguage()
		PVPSoundOptions:OptionsUpdateLocalization()
		PVPSoundOptions:OptionsUpdateFonts()
		print("|cFF50C0FF"..L["Addon language"]..": |cFFADFF2F"..L["[Spanish]"].."|r")
	elseif arg2 == "lang latesn" then
		PS_AddonLanguage = "LatinAmericanSpanish"
		PVPSound:SetAddonLanguage()
		PVPSoundOptions:OptionsUpdateLocalization()
		PVPSoundOptions:OptionsUpdateFonts()
		print("|cFF50C0FF"..L["Addon language"]..": |cFFADFF2F"..L["[LatinAmericanSpanish]"].."|r")
	elseif arg2 == "lang fra" then
		PS_AddonLanguage = "French"
		PVPSound:SetAddonLanguage()
		PVPSoundOptions:OptionsUpdateLocalization()
		PVPSoundOptions:OptionsUpdateFonts()
		print("|cFF50C0FF"..L["Addon language"]..": |cFFADFF2F"..L["[French]"].."|r")
	elseif arg2 == "lang ita" then
		PS_AddonLanguage = "Italian"
		PVPSound:SetAddonLanguage()
		PVPSoundOptions:OptionsUpdateLocalization()
		PVPSoundOptions:OptionsUpdateFonts()
		print("|cFF50C0FF"..L["Addon language"]..": |cFFADFF2F"..L["[Italian]"].."|r")
	elseif arg2 == "lang kr" then
		PS_AddonLanguage = "Korean"
		PVPSound:SetAddonLanguage()
		PVPSoundOptions:OptionsUpdateLocalization()
		PVPSoundOptions:OptionsUpdateFonts()
		print("|cFF50C0FF"..L["Addon language"]..": |cFFADFF2F"..L["[Korean]"].."|r")
	elseif arg2 == "lang pt" then
		PS_AddonLanguage = "Portuguese"
		PVPSound:SetAddonLanguage()
		PVPSoundOptions:OptionsUpdateLocalization()
		PVPSoundOptions:OptionsUpdateFonts()
		print("|cFF50C0FF"..L["Addon language"]..": |cFFADFF2F"..L["[Portuguese]"].."|r")
	elseif arg2 == "lang tradcn" then
		PS_AddonLanguage = "TraditionalChinese"
		PVPSound:SetAddonLanguage()
		PVPSoundOptions:OptionsUpdateLocalization()
		PVPSoundOptions:OptionsUpdateFonts()
		print("|cFF50C0FF"..L["Addon language"]..": |cFFADFF2F"..L["[TraditionalChinese]"].."|r")
	elseif arg2 == "lang simpcn" then
		PS_AddonLanguage = "SimplifiedChinese"
		PVPSound:SetAddonLanguage()
		PVPSoundOptions:OptionsUpdateLocalization()
		PVPSoundOptions:OptionsUpdateFonts()
		print("|cFF50C0FF"..L["Addon language"]..": |cFFADFF2F"..L["[SimplifiedChinese]"].."|r")
	elseif arg2 == "killsoundpack ut3" then
		PS_KillSoundPackName = "UnrealTournament3"
		PS.KillSoundPackDirectory = "Interface\\Addons\\PVPSound\\Sounds\\"..PS_KillSoundPackName
		if PS_KillSoundPackName == "UnrealTournament3" then
			print("|cFF50C0FF"..L["Kill Sound Pack"]..": |cFFADFF2F"..L["[Unreal Tournament 3]"].."|r")
		end
		if PS_KillSoundPackLanguage == "Deu" or PS_KillSoundPackLanguage == "Eng" or PS_KillSoundPackLanguage == "Esn" or PS_KillSoundPackLanguage == "Fra" or PS_KillSoundPackLanguage == "Ita" or PS_KillSoundPackLanguage == "Rus" then
			PS.KillSoundPack = PS_KillSoundPackName..""..PS_KillSoundPackLanguage
			return false
		else
			PS_KillSoundPackLanguage = "Eng"
			print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[English]"].."|r")
		end
		PS.KillSoundPack = PS_KillSoundPackName..""..PS_KillSoundPackLanguage
	elseif arg2 == "killsoundpack dmc" then
		PS_KillSoundPackName = "DevilMayCry"
		PS.KillSoundPackDirectory = "Interface\\Addons\\PVPSound\\Sounds\\"..PS_KillSoundPackName
		if PS_KillSoundPackName == "DevilMayCry" then
			print("|cFF50C0FF"..L["Kill Sound Pack"]..": |cFFADFF2F"..L["[Devil May Cry]"].."|r")
		end
		if PS_KillSoundPackLanguage == "Eng" then
			PS.KillSoundPack = PS_KillSoundPackName..""..PS_KillSoundPackLanguage
			return false
		else
			PS_KillSoundPackLanguage = "Eng"
			print("|cFF50C0FF"..L["Kill Sound Pack language"]..": |cFFADFF2F"..L["[English]"].."|r")
		end
		PS.KillSoundPack = PS_KillSoundPackName..""..PS_KillSoundPackLanguage
	elseif arg2 == "killsoundpack halo4" then
		PS_KillSoundPackName = "Halo4"
		PS.KillSoundPackDirectory = "Interface\\Addons\\PVPSound\\Sounds\\"..PS_KillSoundPackName
		if PS_KillSoundPackName == "Halo4" then
			print("|cFF50C0FF"..L["Kill Sound Pack"]..": |cFFADFF2F"..L["[Halo 4]"].."|r")
		end
		if PS_KillSoundPackLanguage == "Eng" then
			PS.KillSoundPack = PS_KillSoundPackName..""..PS_KillSoundPackLanguage
			return false
		else
			PS_KillSoundPackLanguage = "Eng"
			print("|cFF50C0FF"..L["Kill Sound Pack language"]..": |cFFADFF2F"..L["[English]"].."|r")
		end
		PS.KillSoundPack = PS_KillSoundPackName..""..PS_KillSoundPackLanguage
	elseif arg2 == "killsoundpack hots" then
		PS_KillSoundPackName = "HeroesOfTheStorm"
		PS.KillSoundPackDirectory = "Interface\\Addons\\PVPSound\\Sounds\\"..PS_KillSoundPackName
		if PS_KillSoundPackName == "HeroesOfTheStorm" then
			print("|cFF50C0FF"..L["Kill Sound Pack"]..": |cFFADFF2F"..L["[Heroes Of The Storm]"].."|r")
		end
		if PS_KillSoundPackLanguage == "Murky" then
			PS.KillSoundPack = PS_KillSoundPackName..""..PS_KillSoundPackLanguage
			return false
		else
			PS_KillSoundPackLanguage = "Murky"
			print("|cFF50C0FF"..L["Kill Sound Pack language"]..": |cFFADFF2F"..L["[Murky]"].."|r")
		end
		PS.KillSoundPack = PS_KillSoundPackName..""..PS_KillSoundPackLanguage
	elseif arg2 == "killsoundpack dota2" then
		PS_KillSoundPackName = "Dota2"
		PS.KillSoundPackDirectory = "Interface\\Addons\\PVPSound\\Sounds\\"..PS_KillSoundPackName
		if PS_KillSoundPackName == "Dota2" then
			print("|cFF50C0FF"..L["Kill Sound Pack"]..": |cFFADFF2F"..L["[Dota 2]"].."|r")
		end
		if PS_KillSoundPackLanguage == "Axe" or PS_KillSoundPackLanguage == "Bastion" or PS_KillSoundPackLanguage == "ClockWerk" or PS_KillSoundPackLanguage == "DefenseGrid" or PS_KillSoundPackLanguage == "Glados" or PS_KillSoundPackLanguage == "Juggernaut" or PS_KillSoundPackLanguage == "Lina" or PS_KillSoundPackLanguage == "NaturesProphet" or PS_KillSoundPackLanguage == "Pflax"  or PS_KillSoundPackLanguage == "Pirate" or PS_KillSoundPackLanguage == "StanleyParable" or PS_KillSoundPackLanguage == "StormSpirit" or PS_KillSoundPackLanguage == "Trine" then
			PS.KillSoundPack = PS_KillSoundPackName..""..PS_KillSoundPackLanguage
			return false
		else
			PS_KillSoundPackLanguage = "Axe"
			print("|cFF50C0FF"..L["Kill Sound Pack language"]..": |cFFADFF2F"..L["[Axe]"].."|r")
		end
		PS.KillSoundPack = PS_KillSoundPackName..""..PS_KillSoundPackLanguage
	elseif arg2 == "ksplang eng" then
		if PS_KillSoundPackName == "UnrealTournament3" or PS_KillSoundPackName == "DevilMayCry" or PS_KillSoundPackName == "Halo4" then
			PS_KillSoundPackLanguage = "Eng"
			PS.KillSoundPack = PS_KillSoundPackName..""..PS_KillSoundPackLanguage
		else
			print("|cFF50C0FF"..L["Kill Sound Pack doesn't support that language!"])
		end
		if PS_KillSoundPackLanguage == "Eng" then
			print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[English]"].."|r")
		end
	elseif arg2 == "ksplang deu" or arg2 == "ksplang esn" or arg2 == "ksplang fra" or arg2 == "ksplang ita" or arg2 == "ksplang rus" then
		arg2 = strsub(arg2, 9)
		print(arg2)
		if PS_KillSoundPackName == "UnrealTournament3" then
			if arg2 == "esn" then
				PS_KillSoundPackLanguage = "Esn"
				print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[Spanish]"].."|r")
			elseif arg2 == "deu" then
				PS_KillSoundPackLanguage = "Deu"
				print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[German]"].."|r")
			elseif arg2 == "fra" then
				PS_KillSoundPackLanguage = "Fra"
				print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[French]"].."|r")
			elseif arg2 == "ita" then
				PS_KillSoundPackLanguage = "Ita"
				print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[Italian]"].."|r")
			elseif arg2 == "rus" then
				PS_KillSoundPackLanguage = "Rus"
				print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[Russian]"].."|r")
			end
			PS.KillSoundPack = PS_KillSoundPackName..""..PS_KillSoundPackLanguage
		else
			print("|cFF50C0FF"..L["Kill Sound Pack doesn't support that language!"])
		end
	elseif arg2 == "ksplang axe" or arg2 == "ksplang bastion" or arg2 == "ksplang clockwerk" or arg2 == "ksplang defensegrid" or arg2 == "ksplang glados" or arg2 == "ksplang juggernaut" or arg2 == "ksplang lina" or arg2 == "ksplang naturesprophet" or arg2 == "ksplang pflax" or arg2 == "ksplang pirate" or arg2 == "ksplang stanleyparable" or arg2 == "ksplang stormspirit" or arg2 == "ksplang trine" then
		arg2 = strsub(arg2, 9)
		print(arg2)
		if PS_KillSoundPackName == "Dota2" then
			if arg2 == "axe" then
				PS_KillSoundPackLanguage = "Axe"
				print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[Axe]"].."|r")
			elseif arg2 == "bastion" then
				PS_KillSoundPackLanguage = "Bastion"
				print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[Bastion]"].."|r")
			elseif arg2 == "clockwerk" then
				PS_KillSoundPackLanguage = "ClockWerk"
				print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[ClockWerk]"].."|r")
			elseif arg2 == "defensegrid" then
				PS_KillSoundPackLanguage = "DefenseGrid"
				print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[DefenseGrid]"].."|r")
			elseif arg2 == "glados" then
				PS_KillSoundPackLanguage = "Glados"
				print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[Glados]"].."|r")
			elseif arg2 == "juggernaut" then
				PS_KillSoundPackLanguage = "Juggernaut"
				print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[Juggernaut]"].."|r")
			elseif arg2 == "lina" then
				PS_KillSoundPackLanguage = "Lina"
				print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[Lina]"].."|r")
			elseif arg2 == "naturesprophet" then
				PS_KillSoundPackLanguage = "NaturesProphet"
				print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[NaturesProphet]"].."|r")
			elseif arg2 == "pflax" then
				PS_KillSoundPackLanguage = "Pflax"
				print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[Pflax]"].."|r")
			elseif arg2 == "pirate" then
				PS_KillSoundPackLanguage = "Pirate"
				print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[Pirate]"].."|r")
			elseif arg2 == "stanleyparable" then
				PS_KillSoundPackLanguage = "StanleyParable"
				print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[StanleyParable]"].."|r")
			elseif arg2 == "stormspirit" then
				PS_KillSoundPackLanguage = "StormSpirit"
				print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[StormSpirit]"].."|r")
			elseif arg2 == "trine" then
				PS_KillSoundPackLanguage = "Trine"
				print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[Trine]"].."|r")
			end
			PS.KillSoundPack = PS_KillSoundPackName..""..PS_KillSoundPackLanguage
		else
			print("|cFF50C0FF"..L["Kill Sound Pack doesn't support that language!"])
		end
	elseif arg2 == "ksplang murky" then
		if PS_KillSoundPackName == "HeroesOfTheStorm" then
			PS_KillSoundPackLanguage = "Murky"
			PS.KillSoundPack = PS_KillSoundPackName..""..PS_KillSoundPackLanguage
		else
			print("|cFF50C0FF"..L["Kill Sound Pack doesn't support that language!"])
		end
		if PS_KillSoundPackLanguage == "Murky" then
			print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[Murky]"].."|r")
		end
	else
		PVPSound:PrintSlashHelp()
	end
end

function PVPSound:PrintSlashHelp()
	print("|cFFFFA500PVPSound "..GetAddOnMetadata("PVPSound", "Version").." "..L["Command list"].."|r")
	print("|cFF50C0FF/ps - |cFFFFFFA0"..L["Show status"].."|r")
	print("|cFF50C0FF/ps pvp, pve, pvpandpve - |cFFFFFFA0"..L["Switch between PVP and PVE mode"].."|r")
	print("|cFF50C0FF/ps emote - |cFFFFFFA0"..L["Enables or Disables Emotes completely"].."|r")
	print("|cFF50C0FF/ps emotemode - |cFFFFFFA0"..L["Switch between Emote and Chat Message mode"].."|r")
	print("|cFF50C0FF/ps deathmessage - |cFFFFFFA0"..L["Enables or Disables Death Messages"].."|r")
	print("|cFF50C0FF/ps killsound - |cFFFFFFA0"..L["Enables or Disables Killing Blow and Multi Killing sounds"].."|r")
	print("|cFF50C0FF/ps multikillsound - |cFFFFFFA0"..L["Enables or Disables Multi Killing sounds"].."|r")
	print("|cFF50C0FF/ps petkill - |cFFFFFFA0"..L["Enables or Disables Pet Killing Blow sounds"].."|r")
	print("|cFF50C0FF/ps paysound - |cFFFFFFA0"..L["Enables or Disables Payback Killing sounds"].."|r")
	print("|cFF50C0FF/ps bgsound - |cFFFFFFA0"..L["Enables or Disables Battleground sounds"].."|r")
	print("|cFF50C0FF/ps soundeffect - |cFFFFFFA0"..L["Enables or Disables Sound Effects"].."|r")
	print("|cFF50C0FF/ps killsoundengine - |cFFFFFFA0"..L["Enables or Disables Sound Queue System usage in Killing Sounds"].."|r")
	print("|cFF50C0FF/ps bgsoundengine - |cFFFFFFA0"..L["Enables or Disables Sound Queue System usage in Battleground Sounds"].."|r")
	print("|cFF50C0FF/ps datashare - |cFFFFFFA0"..L["Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members"].."|r")
	print("|cFF50C0FF/ps killsct - |cFFFFFFA0"..L["Enables or Disables Kill Scrolling Combat Text usage"].."|r")
	print("|cFF50C0FF/ps multikillsct - |cFFFFFFA0"..L["Enables or Disables Multi Kill Scrolling Combat Text usage"].."|r")
	print("|cFF50C0FF/ps paybacksct - |cFFFFFFA0"..L["Enables or Disables Payback and Retribution Scrolling Combat Text usage"].."|r")
	print("|cFF50C0FF/ps sctengine - |cFFFFFFA0"..L["Enables or Disables Scrolling Combat Text Queue System usage"].."|r")
	print("|cFF50C0FF/ps frame'framename' - |cFFFFFFA0"..L["Name of the output frame in the supported Scrolling Combat Text"].."|r")
	print("|cFF50C0FF/ps hideservername - |cFFFFFFA0"..L["Enables or Disables hiding the player's server name from Data Sharing and Death Messages"].."|r")
	print("|cFF50C0FF/ps execute - |cFFFFFFA0"..L["Enables or Disables execute sounds"].."|r")
	print("|cFF50C0FF/ps channel'channelname' - |cFFFFFFA0"..L["Switch between sound channels ('master' 'sound' 'music' 'ambience')"].."|r")
	print("|cFF50C0FF/ps soundpack'soundpackname' - |cFFFFFFA0"..L["Switch between Sound Packs ('ut3' 'custom')"].."|r")
	print("|cFF50C0FF/ps splang'soundpacklanguage' - |cFFFFFFA0"..L["Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita' 'rus')"].."|r")
	print("|cFF50C0FF/ps killsoundpack'soundpackname' - |cFFFFFFA0"..L["Switch between Kill Sound Packs ('ut3' 'halo4' 'dmc' 'hots' 'dota2')"].."|r")
	print("|cFF50C0FF/ps ksplang'soundpacklanguage' - |cFFFFFFA0"..L["Switch between Kill Sound Pack languages('deu' 'eng' 'esn' 'fra' 'ita' 'rus' 'axe' 'bastion' 'clockwerk' 'defensegrid' 'glados' 'juggernaut' 'lina' 'naturesprophet' 'pflax' 'pirate' 'stanleyporable' 'stormspirit' 'trine')"].."|r")
	print("|cFF50C0FF/ps test - |cFFFFFFA0"..L["Scrolling Combat Text and sound test"].."|r")
	print("|cFF50C0FF/ps reset - |cFFFFFFA0"..L["Reset the counter of Killing Blows and the Payback-, Retibution-, Sound-, and SCT Queue System"].."|r")
	print("|cFF50C0FF/ps lang 'language' - |cFFFFFFA0"..L["Switch between Addon languages ('deu' 'eng' 'esn' 'fra' 'ita' 'rus' 'latesn' 'kor' 'pt' 'simpcn' 'tradcn')"].."|r")
	print("|cFF50C0FF/ps help - |cFFFFFFA0"..L["Command help"].."|r")
end

function PVPSound:PrintSlashMenu()
	print("|cFFFFA500PVPSound "..GetAddOnMetadata("PVPSound", "Version").." "..L["Loaded. Type /ps help for options"].."|r")
	if PS_Mode == "PVP" then
		print("|cFF50C0FF"..L["Mode"]..": |cFFADFF2F"..L["[PVP]"].."|r")
	elseif PS_Mode == "PVE" then
		print("|cFF50C0FF"..L["Mode"]..": |cFFFF4500"..L["[PVE]"].."|r")
	else
		print("|cFF50C0FF"..L["Mode"]..": |cFFFF4500"..L["[PVP and PVE]"].."|r")
	end
	if PS_Emote == true then
		print("|cFF50C0FF"..L["Emotes"]..": |cFFADFF2F"..L["[Enable]"].."|r")
	else
		print("|cFF50C0FF"..L["Emotes"]..": |cFFFF4500"..L["[Disable]"].."|r")
	end
	if PS_EmoteMode == true then
		print("|cFF50C0FF"..L["Emote mode"]..": |cFFADFF2F"..L["[Emote]"].."|r")
	else
		print("|cFF50C0FF"..L["Emote mode"]..": |cFFFF4500"..L["[Chat Message]"].."|r")
	end
	if PS_DeathMessage == true then
		print("|cFF50C0FF"..L["Death messages"]..": |cFFADFF2F"..L["[Enable]"].."|r")
	else
		print("|cFF50C0FF"..L["Death messages"]..": |cFFFF4500"..L["[Disable]"].."|r")
	end
	if PS_KillSound == true then
		print("|cFF50C0FF"..L["Killing Blow sounds"]..": |cFFADFF2F"..L["[Enable]"].."|r")
	else
		print("|cFF50C0FF"..L["Killing Blow sounds"]..": |cFFFF4500"..L["[Disable]"].."|r")
	end
	if PS_MultiKillSound == true then
		print("|cFF50C0FF"..L["Multi Killing sounds"]..": |cFFADFF2F"..L["[Enable]"].."|r")
	else
		print("|cFF50C0FF"..L["Multi Killing sounds"]..": |cFFFF4500"..L["[Disable]"].."|r")
	end
	if PS_PetKill == true then
		print("|cFF50C0FF"..L["Pet Killing Blows"]..": |cFFADFF2F"..L["[Enable]"].."|r")
	else
		print("|cFF50C0FF"..L["Pet Killing Blows"]..": |cFFFF4500"..L["[Disable]"].."|r")
	end
	if PS_PaybackSound == true then
		print("|cFF50C0FF"..L["Payback sounds"]..": |cFFADFF2F"..L["[Enable]"].."|r")
	else
		print("|cFF50C0FF"..L["Payback sounds"]..": |cFFFF4500"..L["[Disable]"].."|r")
	end
	if PS_BattlegroundSound == true then
		print("|cFF50C0FF"..L["Battleground sounds"]..": |cFFADFF2F"..L["[Enable]"].."|r")
	else
		print("|cFF50C0FF"..L["Battleground sounds"]..": |cFFFF4500"..L["[Disable]"].."|r")
	end
	if PS_SoundEffect == true then
		print("|cFF50C0FF"..L["Sound Effects"]..": |cFFADFF2F"..L["[Enable]"].."|r")
	else
		print("|cFF50C0FF"..L["Sound Effects"]..": |cFFFF4500"..L["[Disable]"].."|r")
	end
	if PS_KillSoundEngine == true then
		print("|cFF50C0FF"..L["Kill Sound Engine"]..": |cFFADFF2F"..L["[Enable]"].."|r")
	else
		print("|cFF50C0FF"..L["Kill Sound Engine"]..": |cFFFF4500"..L["[Disable]"].."|r")
	end
	if PS_BattlegroundSoundEngine == true then
		print("|cFF50C0FF"..L["Battleground Sound Engine"]..": |cFFADFF2F"..L["[Enable]"].."|r")
	else
		print("|cFF50C0FF"..L["Battleground Sound Engine"]..": |cFFFF4500"..L["[Disable]"].."|r")
	end
	if PS_DataShare == true then
		print("|cFF50C0FF"..L["Data Sharing"]..": |cFFADFF2F"..L["[Enable]"].."|r")
	else
		print("|cFF50C0FF"..L["Data Sharing"]..": |cFFFF4500"..L["[Disable]"].."|r")
	end
	if PS_KillSct == true then
		print("|cFF50C0FF"..L["Kill Scrolling Combat Text mode"]..": |cFFADFF2F"..L["[Enable]"].."|r")
	else
		print("|cFF50C0FF"..L["Kill Scrolling Combat Text mode"]..": |cFFFF4500"..L["[Disable]"].."|r")
	end
	if PS_MultiKillSct == true then
		print("|cFF50C0FF"..L["Multi Kill Scrolling Combat Text"]..": |cFFADFF2F"..L["[Enable]"].."|r")
	else
		print("|cFF50C0FF"..L["Multi Kill Scrolling Combat Text"]..": |cFFFF4500"..L["[Disable]"].."|r")
	end
	if PS_PaybackSct == true then
		print("|cFF50C0FF"..L["Payback Scrolling Combat Text"]..": |cFFADFF2F"..L["[Enable]"].."|r")
	else
		print("|cFF50C0FF"..L["Payback Scrolling Combat Text"]..": |cFFFF4500"..L["[Disable]"].."|r")
	end
	if PS_SctEngine == true then
		print("|cFF50C0FF"..L["Scrolling Combat Text Engine"]..": |cFFADFF2F"..L["[Enable]"].."|r")
	else
		print("|cFF50C0FF"..L["Scrolling Combat Text Engine"]..": |cFFFF4500"..L["[Disable]"].."|r")
	end
	if PSSctFrame ~= nil then
		print("|cFF50C0FF"..L["Scrolling Combat Text frame name"]..": |cFFADFF2F["..PSSctFrame.."]|r")
	end
	if PS_HideServerName == true then
		print("|cFF50C0FF"..L["Hide server names"]..": |cFFADFF2F"..L["[Enable]"].."|r")
	else
		print("|cFF50C0FF"..L["Hide server names"]..": |cFFFF4500"..L["[Disable]"].."|r")
	end
	if PS_Execute == true then
		print("|cFF50C0FF"..L["Execute sounds"]..": |cFFADFF2F"..L["[Enable]"].."|r")
	else
		print("|cFF50C0FF"..L["Execute sounds"]..": |cFFFF4500"..L["[Disable]"].."|r")
	end
	if PS_Channel == "Master" then
		print("|cFF50C0FF"..L["Sound channel output"]..": |cFFADFF2F"..L["[Master]"].."|r")
	elseif PS_Channel == "Sound" then
		print("|cFF50C0FF"..L["Sound channel output"]..": |cFFFF4500"..L["[Sound]"].."|r")
	elseif PS_Channel == "Music" then
		print("|cFF50C0FF"..L["Sound channel output"]..": |cFFFF4500"..L["[Music]"].."|r")
	elseif PS_Channel == "Ambience" then
		print("|cFF50C0FF"..L["Sound channel output"]..": |cFFFF4500"..L["[Ambience]"].."|r")
	end
	if PS_SoundPackName == "UnrealTournament3" then
		print("|cFF50C0FF"..L["Sound Pack"]..": |cFFADFF2F"..L["[Unreal Tournament 3]"].."|r")
	elseif PS_SoundPackName == "Custom" then
		print("|cFF50C0FF"..L["Sound Pack"]..": |cFFFF4500"..L["[Custom]"].."|r")
	end
	if PS_SoundPackLanguage == "Default" then
		print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[Default]"].."|r")
	elseif PS_SoundPackLanguage == "Deu" then
		print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[Deutsch]"].."|r")
	elseif PS_SoundPackLanguage == "Eng" then
		print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[English]"].."|r")
	elseif PS_SoundPackLanguage == "Esn" then
		print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[Spanish]"].."|r")
	elseif PS_SoundPackLanguage == "Fra" then
		print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[France]"].."|r")
	elseif PS_SoundPackLanguage == "Ita" then
		print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[Italian]"].."|r")
	elseif PS_SoundPackLanguage == "Rus" then
		print("|cFF50C0FF"..L["Sound Pack language"]..": |cFFADFF2F"..L["[Russian]"].."|r")
	end
	if PS_KillSoundPackName == "UnrealTournament3" then
		print("|cFF50C0FF"..L["Kill Sound Pack"]..": |cFFADFF2F"..L["[Unreal Tournament 3]"].."|r")
	elseif PS_KillSoundPackName == "Custom" then
		print("|cFF50C0FF"..L["Kill Sound Pack"]..": |cFFADFF2F"..L["[Custom]"].."|r")
	elseif PS_KillSoundPackName == "Halo4" then
		print("|cFF50C0FF"..L["Kill Sound Pack"]..": |cFFADFF2F"..L["Halo 4"].."|r")
	elseif PS_KillSoundPackName == "Dota2" then
		print("|cFF50C0FF"..L["Kill Sound Pack"]..": |cFFADFF2F"..L["Dota 2"].."|r")
	elseif PS_KillSoundPackName == "DevilMayCry" then
		print("|cFF50C0FF"..L["Kill Sound Pack"]..": |cFFADFF2F"..L["Devil May Cry"].."|r")
	elseif PS_KillSoundPackName == "HeroesOfTheStorm" then
		print("|cFF50C0FF"..L["Kill Sound Pack"]..": |cFFADFF2F"..L["Heroes Of The Storm"].."|r")
	end

	if PS_KillSoundPackLanguage == "Default" then
		print("|cFF50C0FF"..L["Kill Sound Pack language"]..": |cFFADFF2F"..L["[Default]"].."|r")
	elseif PS_KillSoundPackLanguage == "Deu" then
		print("|cFF50C0FF"..L["Kill Sound Pack language"]..": |cFFADFF2F"..L["[Deutsch]"].."|r")
	elseif PS_KillSoundPackLanguage == "Eng" then
		print("|cFF50C0FF"..L["Kill Sound Pack language"]..": |cFFADFF2F"..L["[English]"].."|r")
	elseif PS_KillSoundPackLanguage == "Esn" then
		print("|cFF50C0FF"..L["Kill Sound Pack language"]..": |cFFADFF2F"..L["[Spanish]"].."|r")
	elseif PS_KillSoundPackLanguage == "Fra" then
		print("|cFF50C0FF"..L["Kill Sound Pack language"]..": |cFFADFF2F"..L["[France]"].."|r")
	elseif PS_KillSoundPackLanguage == "Ita" then
		print("|cFF50C0FF"..L["Kill Sound Pack language"]..": |cFFADFF2F"..L["[Italian]"].."|r")
	elseif PS_KillSoundPackLanguage == "Rus" then
		print("|cFF50C0FF"..L["Kill Sound Pack language"]..": |cFFADFF2F"..L["[Russian]"].."|r")
	elseif PS_KillSoundPackLanguage == "Rus" then
		print("|cFF50C0FF"..L["Kill Sound Pack language"]..": |cFFADFF2F"..L["[Russian]"].."|r")
	else
		print("|cFF50C0FF"..L["Kill Sound Pack language"]..": |cFFADFF2F"..L[PS_KillSoundPackLanguage].."|r")
	end
end
