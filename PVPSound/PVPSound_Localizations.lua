local addon, ns = ...
local PVPSound = { }
ns.PVPSound = PVPSound
PVPSoundOptions = { }
ns.PVPSoundOptions = PVPSoundOptions
local PS = { }
ns.PS = PS

local L = setmetatable({ }, {__index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })

ns.L = L

local Locale = GetLocale()

function PVPSound:English()
-- Messages
Msg_Streak1Male								= "just drew his"
Msg_Streak1Female							= "just drew her"
Msg_Streak2									= "is on"
Msg_Streak3									= "is on"
Msg_Streak4									= "is"
Msg_Streak5									= "is"
Msg_Streak6									= "is"
Msg_Streak7									= "committed a"
Msg_Streak8									= "committed a"
Msg_Streak9									= "committed a"
Msg_Streak10								= "committed a"
Msg_S										= "'s"
Msg_WasOverBy								= "was over by"
Msg_YouGotKilledBy							= "You got killed by"
-- Options
-- Sound Packs
L["Devil May Cry"] = "Devil May Cry"
L["Dota 2"] = "Dota 2"
L["Unreal Tournament 3"] = "Unreal Tournament 3"
L["Custom"] = "Custom"
-- Languages
L["Default"] = "Default"
L["English"] = "English"
L["German"] = "German"
L["Spanish"] = "Spanish"
L["French"] = "French"
L["Italian"] = "Italian"
L["Russian"] = "Russian"
-- Sound Pack Types
L["Axe"] = "Axe"
L["Bastion"] = "Bastion"
L["Glados"] = "Glados"
-- Sound Channels
L["Master"] = "Master"
L["Sound"] = "Sound"
L["Music"] = "Music"
L["Ambience"] = "Ambience"
-- Mode
L["PVP"] = "PVP"
L["PVE"] = "PVE"
L["PVP and PVE"] = "PVP and PVE"
-- Button Labels
L["Addon Language"] = "Addon Language"
L["Enable addon"] = "Enable addon"
L["Kill Sound Pack"] = "Kill Sound Pack"
L["Kill Sound Pack Language"] = "Kill Sound Pack Language"
L["Kill Sound Pack Type"] = "Kill Sound Pack Type"
L["BG Sound Pack"] = "BG Sound Pack"
L["BG Sound Pack Language"] = "BG Sound Pack Language"
L["Sound Channel"] = "Sound Channel"
L["Mode"] = "Mode"
L["Enable Kill Sounds"] = "Enable Kill Sounds"
L["Enable Multi Kill Sounds"] = "Enable Multi Kill Sounds"
-- Button Tooltips
L["Select a Language for the addon to use."] = "Select a Language for the addon to use."
L["Enables or disables the addon completely."] = "Enables or disables the addon completely."
L["Select a Sound Pack to use for kill sounds."] = "Select a Sound Pack to use for kill sounds."
L["Select a Sound Pack to use for battleground sounds."] = "Select a Sound Pack to use for battleground sounds."
L["Select a Language/Type from the Sound Pack to use for kill sounds."] = "Select a Language/Type from the Sound Pack to use for kill sounds."
L["Select a Language/Type from the Sound Pack to use for battleground sounds."] = "Select a Language/Type from the Sound Pack to use for battleground sounds."
L["Select a Sound Channel to use."] = "Select a Sound Channel to use."
L["Select a mode to use."] = "Select a mode to use."
L["Enables or disables Kill Sounds."] = "Enables or disables Kill Sounds."
L["Enables or disables Multi Kill Sounds."] = "Enables or disables Multi Kill Sounds."
-- Tab Labels
L["General"] = "General"
L["AV"] = "AV"
L["AB"] = "AB"
L["DG"] = "DG"
L["EOTS"] = "EOTS"
L["IOC"] = "IOC"
L["SM"] = "SM"
L["SOTA"] = "SOTA"
L["TOK"] = "TOK"
L["TBFG"] = "TBFG"
L["TP"] = "TP"
L["WSG"] = "WSG"
L["TB"] = "TB"
L["WG"] = "WG"
-- Frame Labels
L["Alterac Valley"] = "Alterac Valley"
L["Arathi Basin"] = "Arathi Basin"
L["Deepwind Gorge"] = "Deepwind Gorge"
L["Eye of the Storm"] = "Eye of the Storm"
L["Isle of Conquest"] = "Isle of Conquest"
L["Silvershard Mines"] = "Silvershard Mines"
L["Strand of the Ancients"] = "Strand of the Ancients"
L["Temple of Kotmogu"] = "Temple of Kotmogu"
L["The Battle for Gilneas"] = "The Battle for Gilneas"
L["Twin Peaks"] = "Twin Peaks"
L["Warsong Gulch"] = "Warsong Gulch"
L["Tol Barad"] = "Tol Barad"
L["Wintergrasp"] = "Wintergrasp"
-- Slash Options
Opt_Enable									= "[Enable]"
Opt_Disable									= "[Disable]"
Opt_Mode									= "Mode"
Opt_PVP										= "[PVP]"
Opt_PVE										= "[PVE]"
Opt_Emote									= "[Emote]"
Opt_ChatMessage								= "[Chat Message]"
Opt_Master									= "[Master]"
Opt_Sound									= "[Sound]"
Opt_Music									= "[Music]"
Opt_Ambience								= "[Ambience]"
Opt_UnrealTournament3						= "[Unreal Tournament 3]"
Opt_Custom									= "[Custom]"
Opt_Default									= "[Default]"
Opt_Deutsch									= "[Deutsch]"
Opt_English									= "[English]"
Opt_Spanish									= "[Spanish]"
Opt_France									= "[France]"
Opt_Italian									= "[Italian]"
Opt_Russian									= "[Russian]"
Opt_Emotes									= "Emotes"
Opt_EmoteMode								= "Emote mode"
Opt_DeathMsg								= "Death messages"
Opt_KillSound								= "Killing Blow sounds"
Opt_MultiKillSound							= "Multi Killing sounds"
Opt_PetKill									= "Pet Killing Blows"
Opt_PaySound								= "Payback sounds"
Opt_BgSound									= "Battleground sounds"
Opt_SoundEffect								= "Sound Effects"
Opt_KillSoundEngine							= "Kill Sound Engine"
Opt_BgSoundEngine							= "Battleground Sound Engine"
Opt_DataShare								= "Data Sharing"
Opt_KillSct									= "Kill Scrolling Combat Text mode"
Opt_MultiKillSct							= "Multi Kill Scrolling Combat Text"
Opt_PaybackSct								= "Payback Scrolling Combat Text"
Opt_SctEngine								= "Scrolling Combat Text Engine"
Opt_Frame									= "Scrolling Combat Text frame name"
Opt_HideServerName							= "Hide server names"
Opt_SoundPack								= "Sound Pack"
Opt_SoundPackLanguage						= "Sound Pack language"
Opt_Channel									= "Sound channel output"
Opt_Test									= "Scrolling Combat Text and sound test"
Opt_Reset									= "Killing Counter and Sound Queue reset"
Opt_CmdList									= "Command list"
Opt_CustomDoesntSupport						= "Custom Sound Pack doesn't support that language!"
Opt_HelpStatus								= "Show status"
Opt_HelpMode								= "Switch between PVP and PVE mode"
Opt_HelpEmote								= "Enables or Disables Emotes completely"
Opt_HelpEmoteMode							= "Switch between Emote and Chat Message mode"
Opt_HelpDeathMessage						= "Enables or Disables Death Messages"
Opt_HelpKillSound							= "Enables or Disables Killing Blow and Multi Killing sounds"
Opt_HelpPaybackSound						= "Enables or Disables Payback Killing sounds"
Opt_HelpMultiKillSound						= "Enables or Disables Multi Killing sounds"
Opt_HelpPetKill								= "Enables or Disables Pet Killing Blow sounds"
Opt_HelpBattlegroundSound					= "Enables or Disables Battleground sounds"
Opt_HelpSoundEffect							= "Enables or Disables Sound Effects"
Opt_HelpKillSoundEngine						= "Enables or Disables Sound Queue System usage in Killing Sounds"
Opt_HelpBattlegroundSoundEngine				= "Enables or Disables Sound Queue System usage in Battleground Sounds"
Opt_HelpDataShare							= "Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members"
Opt_HelpKillSct								= "Enables or Disables Kill Scrolling Combat Text usage"
Opt_HelpFrame								= "Name of the output frame in the supported Scrolling Combat Text"
Opt_HelpSctEngine							= "Enables or Disables Scrolling Combat Text Queue System usage"
Opt_HelpMultiKillSct						= "Enables or Disables Multi Kill Scrolling Combat Text usage"
Opt_HelpPaybackSct							= "Enables or Disables Payback and Retribution Scrolling Combat Text usage"
Opt_HelpHideServerName						= "Enables or Disables hiding the player's server name from Data Sharing and Death Messages"
Opt_HelpChannel								= "Switch between sound channels ('master' 'sound' 'music' 'ambience')"
Opt_HelpSoundPack							= "Switch between Sound Packs ('ut3' 'custom')"
Opt_HelpSoundPackLanguage					= "Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')"
Opt_HelpTest								= "Scrolling Combat Text and sound test"
Opt_HelpReset								= "Reset the counter of Killing Blows and the Payback-, Retibution-, Sound-, and SCT Queue System"
Opt_HelpCmdList								= "Command help"
Opt_HelpInput								= "Enabled. Type /ps help for options"
Opt_Kills									= "Killing Count"
end

function PVPSound:EnglishClient()
-- Battleground Names
L["Eye of the Storm"] = "Eye of the Storm"
-- Battleground Zone Names
L["Silverwing Hold"] = "Silverwing Hold"
L["Warsong Flag Room"] = "Warsong Flag Room"
L["Dragonmaw Forge"] ="Dragonmaw Forge"
L["Wildhammer Stronghold"] = "Wildhammer Stronghold"
-- Battleground Events
L["taken the"] = "taken the"
L["dropped"] = "dropped"
L["picked"] = "picked"
L["returned"] = "returned"
L["stolen"] = "stolen"
L["captured"] = "captured"
L["The Alliance is victorious"] = "The Alliance is victorious"
L["The Horde is victorious"] = "The Horde is victorious"
L["The Alliance is near victory"] = "The Alliance is near victory"
L["The Horde is near victory"] = "The Horde is near victory"
BG_ALLIANCE_WINS							= "Alliance wins"
BG_ALLIANCE_WINS_TWO						= "Alliance wins"
BG_HORDE_WINS								= "Horde wins"
BG_HORDE_WINS_TWO							= "Horde wins"
BG_DROPPED									= "dropped"
BG_RETURNED									= "returned"
BG_ALLIANCE_FLAG_RETURNED					= "Alliance Flag has returned"
BG_HORDE_FLAG_RETURNED						= "Horde Flag has returned"
BG_CAPTURED									= "captured"
BG_VULNERABLE								= "vulnerable"
BG_EOTSRBG_ALLIANCE_CAPTURED				= "Alliance have captured"
BG_EOTSRBG_HORDE_CAPTURED					= "Horde have captured"
BG_SOTA_LET_THE_BATTLE						= "Let the battle for the Strand of the Ancients begin"
BG_SOTA_ROUND_ONE							= "The battle for the Strand of the Ancients begins in 1 minute"
BG_SOTA_ROUND_ONE_FINISHED					= "Round 1"
BG_SOTA_ROUND_TWO							= "Round 2 of the Battle for the Strand of the Ancients begins in 1 minute"
BG_SOTA_ROUND_TWO_TWO						= "Round 2 begins in 30 seconds"
BG_TIE_GAME									= "Tie game"
-- Battlefield Events
BF_WG_ALLIANCE_ATTACKED						= "workshop has been attacked by the Alliance"
BF_WG_ALLIANCE_CAPTURED						= "workshop has been captured by the Alliance"
BF_WG_HORDE_ATTACKED						= "workshop has been attacked by the Horde"
BF_WG_HORDE_CAPTURED						= "workshop has been captured by the Horde"
BF_WG_ALLIANCE_WIN_DEFENDED					= "Alliance has defended"
BF_WG_HORDE_WIN_DEFENDED					= "Horde has defended"
end

function PVPSound:German()
L["General"] = "GerGeneral"
-- Messages
Msg_Streak1Male								= "erzielte"
Msg_Streak1Female							= "erzielte"
Msg_Streak2									= "befindet sich im"
Msg_Streak3									= "läuft"
Msg_Streak4									= "ist"
Msg_Streak5									= "ist"
Msg_Streak6									= "ist"
Msg_Streak7									= "verursacht ein"
Msg_Streak8									= "verursacht ein"
Msg_Streak9									= "verursacht ein"
Msg_Streak10								= "verursacht ein"
Msg_S										= "'s" -- Requires localization
Msg_WasOverBy								= "was over by" -- Requires localization
Msg_YouGotKilledBy							= "Du wurdest getötet von"
-- Options
Opt_Ambience								= "[Umgebung]"
Opt_BgSound									= "Schlachtfeld Geräusche"
Opt_BgSoundEngine							= "Schlachtfeld Geräusche Engine"
Opt_Channel									= "Sound Kanal Ausgang"
Opt_ChatMessage								= "[Chat Nachrichten]"
Opt_CmdList									= "Befehlsliste"
Opt_Custom									= "[Individualisierung]"
Opt_DataShare								= "Dateiverteilung"
Opt_DeathMsg								= "Todesberichte"
Opt_Default									= "[Standardeinstellung]"
Opt_Deutsch									= "[Deutsch]"
Opt_Disable									= "[Deaktivieren]"
Opt_Emote									= "[Emotion]"
Opt_EmoteMode								= "Emotionen Modus"
Opt_Emotes									= "Emotionen"
Opt_Enable									= "[Aktivieren]"
Opt_English									= "[English]"
Opt_Frame									= "Scrolling Combat Text frame name" -- Requires localization
Opt_France									= "[France]"
Opt_Russian									= "[Russian]" -- Requires localization
Opt_CustomDoesntSupport						= "Custom Sound Pack doesn't support that language!" -- Requires localization
Opt_HelpBattlegroundSound					= "Schlachtfeldgeräusche aktivieren oder deaktivieren"
Opt_HelpBattlegroundSoundEngine				= "aktivieren oder deaktivieren des Sound-Abfolge-System Benutzung in Schlachtfeldern"
Opt_HelpChannel								= "wechsle zwischen Sound-Kanälen ('meister' 'sound' 'musik' 'umgebung')"
Opt_HelpCmdList								= "Befehl Hilfe"
Opt_HelpDataShare							= "aktiviere oder deaktiviere Serien- und Todesdatenteilung und Erhalt unter Schlachtzug/Gruppen/Schlachtfeld Mitgliedern"
Opt_HelpDeathMessage						= "aktiviere oder deaktiviere Todesberichte"
Opt_HelpEmote								= "aktiviere oder deaktiviere Emotionen komplett"
Opt_HelpEmoteMode							= "wechsle zwischen Emotionen und Chat-Nachrichten Modus"
Opt_HelpFrame								= "Name of the output frame in the supported Scrolling Combat Text" -- Requires localization
Opt_HelpHideServerName						= "aktiviere oder deaktiviere das Verbergen des Spieler's Servernamens von der Datenteilung und den Todesberichten"
Opt_HelpInput								= "Aktiviert. Tippe /ps für Hilfe."
Opt_HelpKillSct								= "aktiviere oder deaktiviere die Tötungs- Scrolling Combat Text -benutzung"
Opt_HelpKillSound							= "aktiviere oder deaktiviere die Todesstoß- und Mehrfachtodesstoßsounds"
Opt_HelpKillSoundEngine						= "aktiviere oder deaktiviere Sound-Reihnfolge-Systembenutzung bei Tötungssounds"
Opt_HelpMode								= "wechsle zwischen PvP und PvE Modus"
Opt_HelpMultiKillSct						= "aktiviere oder deaktiviere Mehrfachtötungs- Scrolling Combat Text -benutzung"
Opt_HelpMultiKillSound						= "aktiviere oder deaktiviere Mehrfachtötungssounds"
Opt_HelpPetKill								= "Enables or Disables Pet Killing Blow sounds" -- Requires localization
Opt_HelpPaybackSct							= "aktiviere oder deaktiviere Heimzahlen- und Vergeltungs- Scrolling Combat Text -benutzung"
Opt_HelpPaybackSound						= "aktiviere oder deaktiviere Heimzahlen Tötungssounds"
Opt_HelpReset								= "setze den Zähler für Todesstöß- Heimzahlen- Vergeltungs- Sound- und SCT -Reihnfolge-System zurück"
Opt_HelpSctEngine							= "aktiviere oder deaktiviere die Scrolling Combat Text -Reihnfolge-Systembenutzung"
Opt_HelpSoundEffect							= "aktiviere oder deaktiviere Soundeffekte"
Opt_HelpSoundPack							= "wechsle zwischen Soundpaketen ('ut3' 'custom')"
Opt_HelpSoundPackLanguage					= "wechsle zwischen Soundpaketsprachen ('deu' 'eng' 'esn' 'fra' 'ita')"
Opt_HelpStatus								= "zeige Status"
Opt_HelpTest								= "Scrolling Combat Text- und Soundtest"
Opt_HideServerName							= "Verstecke Servernamen"
Opt_Italian									= "[Italian]"
Opt_Kills									= "Tötungsanzahl"
Opt_KillSct									= "Tötungs Scrolling Combat Text Modus"
Opt_KillSound								= "Todesstoß Sound"
Opt_KillSoundEngine							= "Todesstoß Geräusche Engine"
Opt_Master									= "[Meister]"
Opt_Mode									= "Modus"
Opt_MultiKillSct							= "Multi Kill Scrolling Combat Text"
Opt_MultiKillSound							= "Mehrfachtodesstoß Sounds"
Opt_Music									= "[Musik]"
Opt_PaybackSct								= "Heimzahlen Scrolling Combat Text"
Opt_PaySound								= "Payback sounds" -- Requires localization
Opt_PetKill									= "Pet Killing Blows" -- Requires localization
Opt_PVE										= "[PVE]"
Opt_PVP										= "[PVP]"
Opt_Reset									= "Tötungszähler und Soundreihenfolge zurücksetzen"
Opt_SctEngine								= "Scrolling Combat Text Engine"
Opt_Sound									= "[Sound]"
Opt_SoundEffect								= "Soundeffekte"
Opt_SoundPack								= "Soundpaket"
Opt_SoundPackLanguage						= "Soundpaketsprache"
Opt_Spanish									= "[Spanish]"
Opt_Test									= "Scrolling Combat Text and sound test" -- Requires localization
Opt_UnrealTournament3						= "[Unreal Tournament 3]"
end

function PVPSound:GermanClient()
-- Battleground Names
L["Eye of the Storm"] = "Auge des Sturms"
-- Battleground Zone Names
L["Silverwing Hold"] = "Silverwing Hold"
L["Warsong Flag Room"] = "Warsong Flag Room"
L["Dragonmaw Forge"] ="Dragonmaw Forge"
L["Wildhammer Stronghold"] = "Wildhammer Stronghold"
-- Battleground Events
L["taken the"] = "taken the"
L["dropped"] = "dropped"
L["picked"] = "aufgenommen"
L["returned"] = "returned"
L["stolen"] = "stolen"
L["captured"] = "captured"
L["The Alliance is victorious"] = "The Alliance is victorious"
L["The Horde is victorious"] = "The Horde is victorious"
-- Battleground Events
BG_ALLIANCE_WINS							= "Die Allianz siegt"
BG_ALLIANCE_WINS_TWO						= "Die Allianz gewinnt"
BG_CAPTURED									= "erobert"
BG_DROPPED									= "fallen lassen"
BG_EOTSRBG_ALLIANCE_CAPTURED				= "Die Allianz hat die Flagge erobert"
BG_EOTSRBG_HORDE_CAPTURED					= "Die Horde hat die Flagge erobert"
BG_HORDE_WINS								= "Die Horde siegt"
BG_HORDE_WINS_TWO							= "Die Horde gewinnt"
BG_RETURNED									= "zurückgebracht"
BG_ALLIANCE_FLAG_RETURNED					= "Alliance Flag has returned" -- Requires localization
BG_HORDE_FLAG_RETURNED						= "Horde Flag has returned" -- Requires localization
BG_SOTA_LET_THE_BATTLE						= "Lasst die Schlacht um den Strand der Uralten beginnen"
BG_SOTA_ROUND_ONE							= "Die Schlacht um den Strand der Uralten beginnt in 1 Minute"
BG_SOTA_ROUND_ONE_FINISHED					= "Runde 1 - Beendet"
BG_SOTA_ROUND_TWO							= "Runde 2 der Schlacht um den Strand der Uralten beginnt in 1 Minute"
BG_SOTA_ROUND_TWO_TWO						= "Runde 2 beginnt in 30 Sekunden"
BG_VULNERABLE								= "Verletzungen"
BG_TIE_GAME									= "Tie game" -- Requires localization
-- Battlefield Events
BF_WG_ALLIANCE_ATTACKED						= "wurde von der Allianz angegriffen"
BF_WG_ALLIANCE_CAPTURED						= "wurde von der Allianz erobert"
BF_WG_ALLIANCE_WIN_DEFENDED					= "Die Allianz verteidigte"
BF_WG_HORDE_ATTACKED						= "wurde von der Horde angegriffen"
BF_WG_HORDE_CAPTURED						= "wurde von der Horde erobert"
BF_WG_HORDE_WIN_DEFENDED					= "Die Horde verteidigte"
end

function PVPSound:Spanish()
L["General"] = "SpaGeneral"
-- Messages
Msg_Streak1Male								= "ha derramando la"
Msg_Streak1Female							= "ha derramando la"
Msg_Streak2									= "está en una"
Msg_Streak3									= "está en un"
Msg_Streak4									= "está"
Msg_Streak5									= "es"
Msg_Streak6									= "es"
Msg_Streak7									= "está en una"
Msg_Streak8									= "está en una"
Msg_Streak9									= "está en una"
Msg_Streak10								= "está en una"
Msg_S										= "'s" 
Msg_WasOverBy								= "ha sido terminada por" 
Msg_YouGotKilledBy							= "Te ha matado"
-- Options
Opt_Ambience								= "[Ambiente]" 
Opt_BgSound									= "Sonidos del Campo de Batalla"
Opt_Channel									= "Salida del Canal de Sonido"
Opt_ChatMessage								= "[Mensaje de chat]"
Opt_Disable									= "[Desactivado]"
Opt_Emote									= "[Emociones]"
Opt_EmoteMode								= "[Modo de Emociones]"
Opt_Emotes									= "Emociones"
Opt_Enable									= "[Activado]"
Opt_KillSound								= "Sonidos de Asesinato"
Opt_Master									= "[Principal]"
Opt_Mode									= "Modo"
Opt_MultiKillSound							= "Sonidos de muertes multilpes"
Opt_Music									= "[Música]"
Opt_PVE										= "[PVE]"
Opt_PVP										= "[PVP]"
Opt_PaySound								= "Sonidos de Retribución"
Opt_Reset									= "Reiniciar el Contador de Muertes"
Opt_Sound									= "[Sonido]"
Opt_UnrealTournament3						= "[Unreal Tournament 3]"
Opt_Custom									= "[Personalizado]"
Opt_Default									= "[Por defecto]"
Opt_Deutsch									= "[Alemán]"
Opt_English									= "[Inglés]"
Opt_Spanish									= "[Español]"
Opt_France									= "[Francia]"
Opt_Italian									= "[Italiano]"
Opt_Russian									= "[Ruso]" 
Opt_KillSoundEngine							= "Motor de sonidos de muerte"
Opt_BgSoundEngine							= "Motor de sonido en campos de batalla" 
Opt_SoundEffect								= "Efectos de sonido"
Opt_DataShare								= "Compartición de datos"
Opt_KillSct									= "Modo de SCT de muertes"
Opt_Frame									= "Marco del texto de combate"
Opt_SctEngine								= "Motor de SCT"
Opt_MultiKillSct							= "Multimuerte de SCT"
Opt_PaybackSct								= "Retribución en SCT"
Opt_PetKill									= "Sonidos de muerte de la mascota" 
Opt_HideServerName							= "Ocultar nombres de los servidores"
Opt_SoundPack								= "Pack de sonido"
Opt_SoundPackLanguage						= "Lenguaje del pack de sonido"
Opt_Test									= "Probando Sonido"
Opt_CmdList									= "Lista de Comandos"
Opt_CustomDoesntSupport						= "El pack de sonidos personalizado no soporta ese lenguaje!"
Opt_HelpBattlegroundSound					= "Activar o Desactivar Sonidos del Campo de Batalla"
Opt_HelpSoundEffect							= "Activa o desactiva los efectos de sonido"
Opt_HelpChannel								= "Cambiar Canales de sonido entre ('Principal' 'sonido' 'música' 'ambiente'"
Opt_HelpCmdList								= "Ayuda de Comando"
Opt_HelpDeathMessage						= "Activa o desactiva los mensajes de muertes"
Opt_HelpEmote								= "Activar o Desactivar las emociones Completamente"
Opt_HelpEmoteMode							= "Cambiar entre Emoción y modo de mensaje de conversación"
Opt_HelpInput								= "Activado. Escribe /ps ayuda para opciones."
Opt_HelpKillSound							= "Activar o Desactivar sonidos de Asesinato y muerte múltiple"
Opt_HelpMode								= "Cambiar entre PVP y PVE"
Opt_HelpMultiKillSound						= "Activar o desactivar sonidos de muertes multiples"
Opt_HelpPetKill								= "Activa o desactiva sonidos de muerte de la mascota" 
Opt_HelpPaybackSound						= "Activa o desactiva los sonidos de retribución"
Opt_HelpReset								= "Reiniciar el contador de asesinatos"
Opt_HelpKillSoundEngine						= "Activa o desactiva el sistema de cola de sonidos de muerte"
Opt_HelpBattlegroundSoundEngine				= "Activa o desactiva la cola de sonidos de SCT en los campos de batalla"
Opt_HelpDataShare							= "Activa o desactiva la compartición de datos de muertes entre el grupo/banda/campo de batalla"
Opt_HelpKillSct								= "Activa o desactiva las muertes en el texto de combate"
Opt_HelpFrame								= "Nombre de la letra en el texto de combate"
Opt_HelpSctEngine							= "Activa o desactiva el uso de SCT"
Opt_HelpMultiKillSct						= "Activa o desactiva el uso de multimuertes en el texto de combate de SCT"
Opt_HelpPaybackSct							= "Activa o desactiva el uso de retribución en el texto de combate"
Opt_HelpHideServerName						= "Activa o desactiva el reino de los jugadores en la compartición de datos"
Opt_HelpSoundPack							= "Cambia entre los packs de sonido('ut3' 'custom')"
Opt_HelpSoundPackLanguage					= "Cambia entre el idioma de los packs de sonido ('deu' 'eng' 'esn' 'fra' 'ita')"
Opt_HelpStatus								= "Mostrar estado"
Opt_HelpTest								= "Prueba de sonido"
Opt_Kills									= "Conteo de muertes"
Opt_DeathMsg								= "Mensajes de muertes"
end

function PVPSound:SpanishClient()
-- Battleground Names
L["Eye of the Storm"] = "Ojo de la Tormenta"
-- Battleground Zone Names
L["Silverwing Hold"] = "Silverwing Hold"
L["Warsong Flag Room"] = "Warsong Flag Room"
L["Dragonmaw Forge"] ="Dragonmaw Forge"
L["Wildhammer Stronghold"] = "Wildhammer Stronghold"
-- Battleground Events
L["taken the"] = "taken the"
L["dropped"] = "dropped"
L["picked"] = "recogida"
L["returned"] = "returned"
L["stolen"] = "stolen"
L["captured"] = "captured"
L["The Alliance is victorious"] = "The Alliance is victorious"
L["The Horde is victorious"] = "The Horde is victorious"
-- Battleground Events
BG_ALLIANCE_WINS							= "La Alianza gana"
BG_ALLIANCE_WINS_TWO						= "La Alianza gana"
BG_EOTSRBG_ALLIANCE_CAPTURED				= "La Alianza ha capturado la bandera"
BG_EOTSRBG_HORDE_CAPTURED					= "La Horda ha capturado la bandera"
BG_CAPTURED									= "capturada"
BG_DROPPED									= "arrojada"
BG_HORDE_WINS								= "La Horda gana"
BG_HORDE_WINS_TWO							= "La Horda gana"
BG_RETURNED									= "regresada"
BG_ALLIANCE_FLAG_RETURNED					= "La bandera de la alianza ha sido devuelta" 
BG_HORDE_FLAG_RETURNED						= "La bandera de la horda ha sido devuelta" 
BG_SOTA_LET_THE_BATTLE						= "Que empiece la batalla por la playa de los ancestros"
BG_SOTA_ROUND_ONE							= "La batalla por la Playa de los Ancestros comienza en 1 minuto"
BG_SOTA_ROUND_ONE_FINISHED					= "La primera ronda ha acabado"
BG_SOTA_ROUND_TWO							= "Ronda 2 de la Batalla por la Playa de los Ancestros comienza en 1 minuto"
BG_SOTA_ROUND_TWO_TWO						= "La segunda ronda de la Batalla por la Playa de los Ancestros comienza en 30 segundos"
BG_VULNERABLE								= "vulnerables"
BG_TIE_GAME									= "empate" 
-- Battlefield Events
BF_WG_ALLIANCE_ATTACKED						= "El Taller ha sido atacado por la alianza"
BF_WG_ALLIANCE_CAPTURED						= "El Taller ha sido capturado por la alianza"
BF_WG_ALLIANCE_WIN_DEFENDED					= "La Allianza ha defendido"
BF_WG_HORDE_ATTACKED						= "El Taller ha sido atacado por la horda"
BF_WG_HORDE_CAPTURED						= "El Taller ha sido capturado por la horda"
BF_WG_HORDE_WIN_DEFENDED					= "La horda ha defendido"
end

function PVPSound:LatinAmericanSpanish()
L["General"] = "LaSpaGeneral"
-- Messages
Msg_Streak1Male								= "ha derramando la"
Msg_Streak1Female							= "ha derramando la"
Msg_Streak2									= "está en una"
Msg_Streak3									= "está en un"
Msg_Streak4									= "está"
Msg_Streak5									= "es"
Msg_Streak6									= "es"
Msg_Streak7									= "está en una"
Msg_Streak8									= "está en una"
Msg_Streak9									= "está en una"
Msg_Streak10								= "está en una"
Msg_S										= "'s" 
Msg_WasOverBy								= "ha sido terminada por" 
Msg_YouGotKilledBy							= "Te ha matado"
-- Options
Opt_Ambience								= "[Ambiente]" 
Opt_BgSound									= "Sonidos del Campo de Batalla"
Opt_Channel									= "Salida del Canal de Sonido"
Opt_ChatMessage								= "[Mensaje de chat]"
Opt_Disable									= "[Desactivado]"
Opt_Emote									= "[Emociones]"
Opt_EmoteMode								= "[Modo de Emociones]"
Opt_Emotes									= "Emociones"
Opt_Enable									= "[Activado]"
Opt_KillSound								= "Sonidos de Asesinato"
Opt_Master									= "[Principal]"
Opt_Mode									= "Modo"
Opt_MultiKillSound							= "Sonidos de muertes multilpes"
Opt_Music									= "[Música]"
Opt_PVE										= "[PVE]"
Opt_PVP										= "[PVP]"
Opt_PaySound								= "Sonidos de Retribución"
Opt_Reset									= "Reiniciar el Contador de Muertes"
Opt_Sound									= "[Sonido]"
Opt_UnrealTournament3						= "[Unreal Tournament 3]"
Opt_Custom									= "[Personalizado]"
Opt_Default									= "[Por defecto]"
Opt_Deutsch									= "[Alemán]"
Opt_English									= "[Inglés]"
Opt_Spanish									= "[Español]"
Opt_France									= "[Francia]"
Opt_Italian									= "[Italiano]"
Opt_Russian									= "[Ruso]" 
Opt_KillSoundEngine							= "Motor de sonidos de muerte"
Opt_BgSoundEngine							= "Motor de sonido en campos de batalla" 
Opt_SoundEffect								= "Efectos de sonido"
Opt_DataShare								= "Compartición de datos"
Opt_KillSct									= "Modo de SCT de muertes"
Opt_Frame									= "Marco del texto de combate"
Opt_SctEngine								= "Motor de SCT"
Opt_MultiKillSct							= "Multimuerte de SCT"
Opt_PaybackSct								= "Retribución en SCT"
Opt_PetKill									= "Sonidos de muerte de la mascota" 
Opt_HideServerName							= "Ocultar nombres de los servidores"
Opt_SoundPack								= "Pack de sonido"
Opt_SoundPackLanguage						= "Lenguaje del pack de sonido"
Opt_Test									= "Probando Sonido"
Opt_CmdList									= "Lista de Comandos"
Opt_CustomDoesntSupport						= "¡El pack de sonidos personalizado no soporta ese lenguaje!"
Opt_HelpBattlegroundSound					= "Activar o Desactivar Sonidos del Campo de Batalla"
Opt_HelpSoundEffect							= "Activa o desactiva los efectos de sonido"
Opt_HelpChannel								= "Cambiar Canales de sonido entre ('Principal' 'sonido' 'música' 'ambiente'"
Opt_HelpCmdList								= "Ayuda de Comando"
Opt_HelpDeathMessage						= "Activa o desactiva los mensajes de muertes"
Opt_HelpEmote								= "Activar o Desactivar las emociones Completamente"
Opt_HelpEmoteMode							= "Cambiar entre Emoción y modo de mensaje de conversación"
Opt_HelpInput								= "Activado. Escribe /ps ayuda para opciones."
Opt_HelpKillSound							= "Activar o Desactivar sonidos de Asesinato y muerte múltiple"
Opt_HelpMode								= "Cambiar entre PVP y PVE"
Opt_HelpMultiKillSound						= "Activar o desactivar sonidos de muertes multiples"
Opt_HelpPetKill								= "Activa o desactiva sonidos de muerte de la mascota" 
Opt_HelpPaybackSound						= "Activa o desactiva los sonidos de retribución"
Opt_HelpReset								= "Reiniciar el contador de asesinatos"
Opt_HelpKillSoundEngine						= "Activa o desactiva el sistema de cola de sonidos de muerte"
Opt_HelpBattlegroundSoundEngine				= "Activa o desactiva la cola de sonidos de SCT en los campos de batalla"
Opt_HelpDataShare							= "Activa o desactiva la compartición de datos de muertes entre el grupo/banda/campo de batalla"
Opt_HelpKillSct								= "Activa o desactiva las muertes en el texto de combate"
Opt_HelpFrame								= "Nombre de la letra en el texto de combate"
Opt_HelpSctEngine							= "Activa o desactiva el uso de SCT"
Opt_HelpMultiKillSct						= "Activa o desactiva el uso de multimuertes en el texto de combate de SCT"
Opt_HelpPaybackSct							= "Activa o desactiva el uso de retribución en el texto de combate"
Opt_HelpHideServerName						= "Activa o desactiva el reino de los jugadores en la compartición de datos"
Opt_HelpSoundPack							= "Cambia entre los packs de sonido('ut3' 'custom')"
Opt_HelpSoundPackLanguage					= "Cambia entre el idioma de los packs de sonido ('deu' 'eng' 'esn' 'fra' 'ita')"
Opt_HelpStatus								= "Mostrar estado"
Opt_HelpTest								= "Prueba de sonido"
Opt_Kills									= "Conteo de muertes"
Opt_DeathMsg								= "Mensajes de muertes"
end

function PVPSound:LatinAmericanSpanishClient()
-- Battleground Names
L["Eye of the Storm"] = "Ojo de la Tormenta"
-- Battleground Zone Names
L["Silverwing Hold"] = "Silverwing Hold"
L["Warsong Flag Room"] = "Warsong Flag Room"
L["Dragonmaw Forge"] ="Dragonmaw Forge"
L["Wildhammer Stronghold"] = "Wildhammer Stronghold"
-- Battleground Events
L["taken the"] = "taken the"
L["dropped"] = "dropped"
L["picked"] = "recogida"
L["returned"] = "returned"
L["stolen"] = "stolen"
L["captured"] = "captured"
L["The Alliance is victorious"] = "The Alliance is victorious"
L["The Horde is victorious"] = "The Horde is victorious"
-- Battleground Events
BG_ALLIANCE_WINS							= "La Alianza gana"
BG_ALLIANCE_WINS_TWO						= "La Alianza gana"
BG_EOTSRBG_ALLIANCE_CAPTURED				= "La Alianza ha capturado la bandera"
BG_EOTSRBG_HORDE_CAPTURED					= "La Horda ha capturado la bandera"
BG_CAPTURED									= "capturada"
BG_DROPPED									= "arrojada"
BG_HORDE_WINS								= "La Horda gana"
BG_HORDE_WINS_TWO							= "La Horda gana"
BG_RETURNED									= "regresada"
BG_ALLIANCE_FLAG_RETURNED					= "La bandera de la alianza ha sido devuelta" 
BG_HORDE_FLAG_RETURNED						= "La bandera de la horda ha sido devuelta" 
BG_SOTA_LET_THE_BATTLE						= "Que empiece la batalla por la playa de los ancestros"
BG_SOTA_ROUND_ONE							= "La batalla por la Playa de los Ancestros comienza en 1 minuto"
BG_SOTA_ROUND_ONE_FINISHED					= "La primera ronda ha acabado"
BG_SOTA_ROUND_TWO							= "Ronda 2 de la Batalla por la Playa de los Ancestros comienza en 1 minuto"
BG_SOTA_ROUND_TWO_TWO						= "La segunda ronda de la Batalla por la Playa de los Ancestros comienza en 30 segundos"
BG_VULNERABLE								= "vulnerables"
BG_TIE_GAME									= "empate" 
-- Battlefield Events
BF_WG_ALLIANCE_ATTACKED						= "El Taller ha sido atacado por la alianza"
BF_WG_ALLIANCE_CAPTURED						= "El Taller ha sido capturado por la alianza"
BF_WG_ALLIANCE_WIN_DEFENDED					= "La Allianza ha defendido"
BF_WG_HORDE_ATTACKED						= "El Taller ha sido atacado por la horda"
BF_WG_HORDE_CAPTURED						= "El Taller ha sido capturado por la horda"
BF_WG_HORDE_WIN_DEFENDED					= "La horda ha defendido"
end

function PVPSound:French()
L["General"] = "FraGeneral"
-- Messages
Msg_Streak1Male								= "a versé le"
Msg_Streak1Female							= "a versé le"
Msg_Streak2									= "fait une"
Msg_Streak3									= "se"
Msg_Streak4									= "est"
Msg_Streak5									= "est"
Msg_Streak6									= "est"
Msg_Streak7									= "fait un"
Msg_Streak8									= "fait un"
Msg_Streak9									= "fait un"
Msg_Streak10								= "fait un"
Msg_S										= "'s" -- Requires localization
Msg_WasOverBy								= "was over by" -- Requires localization
Msg_YouGotKilledBy							= "Vous avez été tué par"
-- Options
Opt_Ambience								= "[Ambiance]"
Opt_BgSound									= "Son du champ de bataille"
Opt_Channel									= "Canal de sortie son"
Opt_ChatMessage								= "[Chat Message]"
Opt_Disable									= "[désactivé]"
Opt_Emote									= "[Emote]"
Opt_EmoteMode								= "Mode emote"
Opt_Emotes									= "Emotes"
Opt_Enable									= "[Activé]"
Opt_KillSound								= "Sons du Killing Blow"
Opt_Master									= "[Maitre]"
Opt_Mode									= "Mode"
Opt_MultiKillSound							= "Son des morts multiples"
Opt_Music									= "[Musique]"
Opt_PVE										= "[PVE]"
Opt_PVP										= "[PVP]"
Opt_PaySound								= "Sons Payback "
Opt_Reset									= "Décompte mort et queue sons reset"
Opt_Sound									= "[Son]"
Opt_UnrealTournament3						= "[Unreal Tournament 3]" -- Requires localization
Opt_Custom									= "[Custom]" -- Requires localization
Opt_Default									= "[Default]" -- Requires localization
Opt_Deutsch									= "[Deutsch]" -- Requires localization
Opt_English									= "[English]" -- Requires localization
Opt_Spanish									= "[Spanish]" -- Requires localization
Opt_France									= "[France]" -- Requires localization
Opt_Italian									= "[Italian]" -- Requires localization
Opt_Russian									= "[Russian]" -- Requires localization
Opt_KillSoundEngine							= "Kill Sound Engine" -- Requires localization
Opt_BgSoundEngine							= "Battleground Sound Engine" -- Requires localization
Opt_SoundEffect								= "Sound Effects" -- Requires localization
Opt_DataShare								= "Data Sharing" -- Requires localization
Opt_KillSct									= "Kill Scrolling Combat Text mode" -- Requires localization
Opt_Frame									= "Scrolling Combat Text frame name" -- Requires localization
Opt_SctEngine								= "Scrolling Combat Text Engine" -- Requires localization
Opt_MultiKillSct							= "Multi Kill Scrolling Combat Text" -- Requires localization
Opt_PaybackSct								= "Payback Scrolling Combat Text" -- Requires localization
Opt_PetKill									= "Pet Killing Blows" -- Requires localization
Opt_HideServerName							= "Hide server names" -- Requires localization
Opt_SoundPack								= "Sound Pack" -- Requires localization
Opt_SoundPackLanguage						= "Sound Pack language" -- Requires localization
Opt_Test									= "Tester les sons"
Opt_CmdList									= "Liste de commandes"
Opt_CustomDoesntSupport						= "Custom Sound Pack doesn't support that language!" -- Requires localization
Opt_HelpBattlegroundSound					= "Activer ou désactiver les sons de champ de bataille"
Opt_HelpSoundEffect							= "Enables or Disables Sound Effects" -- Requires localization
Opt_HelpChannel								= "Switch entre le canaux de sons ('master' 'son' 'musique' 'ambiance')"
Opt_HelpCmdList								= "Commande d'aide"
Opt_HelpDeathMessage						= "Activer ou désactiver les messages de morts dans les champs de batailles"
Opt_HelpEmote								= "Activer ou désactiver les emotes completement"
Opt_HelpEmoteMode							= "Switch entre le mode emote ou Chat messages"
Opt_HelpInput								= "Activer. Taper /ps help pour les options"
Opt_HelpKillSound							= "Activer ou désactiver les sons Killing Blow et Multi Killing"
Opt_HelpMode								= "Switch entre le mode PVP et PVE"
Opt_HelpMultiKillSound						= "Activer ou désactiver les son des morts multiples"
Opt_HelpPetKill								= "Enables or Disables Pet Killing Blow sounds" -- Requires localization
Opt_HelpPaybackSound						= "Activer ou désactiver les sons des morts Payback"
Opt_HelpReset								= "Mise a zéro du décompte des Killing Blows et les son dans la liste d'attente"
Opt_HelpKillSoundEngine						= "Enables or Disables Sound Queue System usage in Killing Sounds" -- Requires localization
Opt_HelpBattlegroundSoundEngine				= "Enables or Disables Sound Queue System usage in Battleground Sounds" -- Requires localization
Opt_HelpDataShare							= "Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members" -- Requires localization
Opt_HelpKillSct								= "Enables or Disables Kill Scrolling Combat Text usage" -- Requires localization
Opt_HelpFrame								= "Name of the output frame in the supported Scrolling Combat Text" -- Requires localization
Opt_HelpSctEngine							= "Enables or Disables Scrolling Combat Text Queue System usage" -- Requires localization
Opt_HelpMultiKillSct						= "Enables or Disables Multi Kill Scrolling Combat Text usage" -- Requires localization
Opt_HelpPaybackSct							= "Enables or Disables Payback and Retribution Scrolling Combat Text usage" -- Requires localization
Opt_HelpHideServerName						= "Enables or Disables hiding the player's server name from Data Sharing and Death Messages" -- Requires localization
Opt_HelpSoundPack							= "Switch between Sound Packs ('ut3' 'custom')" -- Requires localization
Opt_HelpSoundPackLanguage					= "Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')" -- Requires localization
Opt_HelpStatus								= "Montrer les status"
Opt_HelpTest								= "Tester le son"
Opt_Kills									= "Décompte des morts"
Opt_DeathMsg								= "Messages de morts"
end

function PVPSound:FrenchClient()
-- Battleground Names
L["Eye of the Storm"] = "L'Œil du cyclone"
-- Battleground Zone Names
L["Silverwing Hold"] = "Silverwing Hold"
L["Warsong Flag Room"] = "Warsong Flag Room"
L["Dragonmaw Forge"] ="Dragonmaw Forge"
L["Wildhammer Stronghold"] = "Wildhammer Stronghold"
-- Battleground Events
L["taken the"] = "taken the"
L["dropped"] = "dropped"
L["picked"] = "pris"
L["returned"] = "returned"
L["stolen"] = "stolen"
L["captured"] = "captured"
L["The Alliance is victorious"] = "The Alliance is victorious"
L["The Horde is victorious"] = "The Horde is victorious"
-- Battleground Events
BG_ALLIANCE_WINS							= "L' Alliance gagne"
BG_ALLIANCE_WINS_TWO						= "L' Alliance gagne"
BG_CAPTURED									= "capturé"
BG_DROPPED									= "chuté"
BG_EOTSRBG_ALLIANCE_CAPTURED				= "L'Alliance a capturé"
BG_EOTSRBG_HORDE_CAPTURED					= "La Horde a capturé"
BG_HORDE_WINS								= "La Horde gagne"
BG_HORDE_WINS_TWO							= "La Horde gagne"
BG_RETURNED									= "retourné"
BG_ALLIANCE_FLAG_RETURNED					= "Alliance Flag has returned" -- Requires localization
BG_HORDE_FLAG_RETURNED						= "Horde Flag has returned" -- Requires localization
BG_SOTA_LET_THE_BATTLE						= "Que la bataille pour le Rivage des Anciens commence"
BG_SOTA_ROUND_ONE							= "La bataille pour le Rivage des Anciens commence dans 1 minute"
BG_SOTA_ROUND_ONE_FINISHED					= "Round 1"
BG_SOTA_ROUND_TWO							= "Le round 2 de la bataille pour le Rivage des Anciens commence dans 1 minute"
BG_SOTA_ROUND_TWO_TWO						= "Round 2 commence dans 30 secondes"
BG_VULNERABLE								= "vulnérable"
BG_TIE_GAME									= "Tie game" -- Requires localization
-- Battlefield Events
BF_WG_ALLIANCE_ATTACKED						= "L'atelier a été attaqué par l'Alliance"
BF_WG_ALLIANCE_CAPTURED						= "L'atelier a été capturé par l'Alliance"
BF_WG_ALLIANCE_WIN_DEFENDED					= "L’Alliance a défendu"
BF_WG_HORDE_ATTACKED						= "L'atelier a été attaqué par la Horde"
BF_WG_HORDE_CAPTURED						= "L'atelier a été capturé par la Horde"
BF_WG_HORDE_WIN_DEFENDED					= "La Horde a défendu"
end

function PVPSound:Italian()
L["General"] = "ItaGeneral"
-- Messages
Msg_Streak1Male								= "ha"
Msg_Streak1Female							= "ha"
Msg_Streak2									= "ha un"
Msg_Streak3									= "č"
Msg_Streak4									= "sta"
Msg_Streak5									= "č"
Msg_Streak6									= "č"
Msg_Streak7									= "ta facendo un"
Msg_Streak8									= "ta facendo un"
Msg_Streak9									= "ta facendo un"
Msg_Streak10								= "ta facendo un"
Msg_S										= "'s" -- Requires localization
Msg_WasOverBy								= "was over by" -- Requires localization
Msg_YouGotKilledBy							= "Sei stato ucciso da"
-- Options
Opt_Ambience								= "[Ambience]" -- Requires localization
Opt_BgSound									= "Battleground sounds" -- Requires localization
Opt_Channel									= "Sound channel output" -- Requires localization
Opt_ChatMessage								= "[Chat Message]" -- Requires localization
Opt_Disable									= "[Disable]" -- Requires localization
Opt_Emote									= "[Emote]" -- Requires localization
Opt_EmoteMode								= "Emote mode" -- Requires localization
Opt_Emotes									= "Emotes" -- Requires localization
Opt_Enable									= "[Enable]" -- Requires localization
Opt_KillSound								= "Killing Blow sounds" -- Requires localization
Opt_Master									= "[Master]" -- Requires localization
Opt_Mode									= "Mode" -- Requires localization
Opt_MultiKillSound							= "Multi Killing sounds" -- Requires localization
Opt_Music									= "[Music]" -- Requires localization
Opt_PVE										= "[PVE]" -- Requires localization
Opt_PVP										= "[PVP]" -- Requires localization
Opt_PaySound								= "Payback sounds" -- Requires localization
Opt_Reset									= "Killing Counter and Sound Queue reset" -- Requires localization
Opt_Sound									= "[Sound]" -- Requires localization
Opt_UnrealTournament3						= "[Unreal Tournament 3]" -- Requires localization
Opt_Custom									= "[Custom]" -- Requires localization
Opt_Default									= "[Default]" -- Requires localization
Opt_Deutsch									= "[Deutsch]" -- Requires localization
Opt_English									= "[English]" -- Requires localization
Opt_Spanish									= "[Spanish]" -- Requires localization
Opt_France									= "[France]" -- Requires localization
Opt_Italian									= "[Italian]" -- Requires localization
Opt_Russian									= "[Russian]" -- Requires localization
Opt_KillSoundEngine							= "Kill Sound Engine" -- Requires localization
Opt_BgSoundEngine							= "Battleground Sound Engine" -- Requires localization
Opt_SoundEffect								= "Sound Effects" -- Requires localization
Opt_DataShare								= "Data Sharing" -- Requires localization
Opt_KillSct									= "Kill Scrolling Combat Text mode" -- Requires localization
Opt_Frame									= "Scrolling Combat Text frame name" -- Requires localization
Opt_SctEngine								= "Scrolling Combat Text Engine" -- Requires localization
Opt_MultiKillSct							= "Multi Kill Scrolling Combat Text" -- Requires localization
Opt_PaybackSct								= "Payback Scrolling Combat Text" -- Requires localization
Opt_PetKill									= "Pet Killing Blows" -- Requires localization
Opt_HideServerName							= "Hide server names" -- Requires localization
Opt_SoundPack								= "Sound Pack" -- Requires localization
Opt_SoundPackLanguage						= "Sound Pack language" -- Requires localization
Opt_Test									= "Testing sound" -- Requires localization
Opt_CmdList									= "Command list" -- Requires localization
Opt_CustomDoesntSupport						= "Custom Sound Pack doesn't support that language!" -- Requires localization
Opt_HelpBattlegroundSound					= "Enables or Disables Battleground sounds" -- Requires localization
Opt_HelpSoundEffect							= "Enables or Disables Sound Effects" -- Requires localization
Opt_HelpChannel								= "Switch between sound channels ('master' 'sound' 'music' 'ambience')" -- Requires localization
Opt_HelpCmdList								= "Command help" -- Requires localization
Opt_HelpDeathMessage						= "Enables or Disables Death Messages in Battlegrounds" -- Requires localization
Opt_HelpEmote								= "Enables or Disables Emotes completely" -- Requires localization
Opt_HelpEmoteMode							= "Switch between Emote and Chat Message mode" -- Requires localization
Opt_HelpInput								= "Enabled. Type /ps help for options" -- Requires localization
Opt_HelpKillSound							= "Enables or Disables Killing Blow and Multi Killing sounds" -- Requires localization
Opt_HelpMode								= "Switch between PVP and PVE mode" -- Requires localization
Opt_HelpMultiKillSound						= "Enables or Disables Multi Killing sounds" -- Requires localization
Opt_HelpPetKill								= "Enables or Disables Pet Killing Blow sounds" -- Requires localization
Opt_HelpPaybackSound						= "Enables or Disables Payback Killing sounds" -- Requires localization
Opt_HelpReset								= "Reset the counter of Killing Blows and the Payback- and Sound Queue System" -- Requires localization
Opt_HelpKillSoundEngine						= "Enables or Disables Sound Queue System usage in Killing Sounds" -- Requires localization
Opt_HelpBattlegroundSoundEngine				= "Enables or Disables Sound Queue System usage in Battleground Sounds" -- Requires localization
Opt_HelpDataShare							= "Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members" -- Requires localization
Opt_HelpKillSct								= "Enables or Disables Kill Scrolling Combat Text usage" -- Requires localization
Opt_HelpFrame								= "Name of the output frame in the supported Scrolling Combat Text" -- Requires localization
Opt_HelpSctEngine							= "Enables or Disables Scrolling Combat Text Queue System usage" -- Requires localization
Opt_HelpMultiKillSct						= "Enables or Disables Multi Kill Scrolling Combat Text usage" -- Requires localization
Opt_HelpPaybackSct							= "Enables or Disables Payback and Retribution Scrolling Combat Text usage" -- Requires localization
Opt_HelpHideServerName						= "Enables or Disables hiding the player's server name from Data Sharing and Death Messages" -- Requires localization
Opt_HelpSoundPack							= "Switch between Sound Packs ('ut3' 'custom')" -- Requires localization
Opt_HelpSoundPackLanguage					= "Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')" -- Requires localization
Opt_HelpStatus								= "Show status" -- Requires localization
Opt_HelpTest								= "Sound test" -- Requires localization
Opt_Kills									= "Killing Count" -- Requires localization
Opt_DeathMsg								= "Death messages" -- Requires localization
end

function PVPSound:ItalianClient()
-- Battleground Names
L["Eye of the Storm"] = "Eye of the Storm" -- Requires localization
-- Battleground Zone Names
L["Silverwing Hold"] = "Silverwing Hold" -- Requires localization
L["Warsong Flag Room"] = "Warsong Flag Room" -- Requires localization
L["Dragonmaw Forge"] ="Dragonmaw Forge" -- Requires localization
L["Wildhammer Stronghold"] = "Wildhammer Stronghold" -- Requires localization
-- Battleground Events
L["taken the"] = "taken the" -- Requires localization
L["dropped"] = "dropped" -- Requires localization
L["picked"] = "picked" -- Requires localization
L["returned"] = "returned" -- Requires localization
L["stolen"] = "stolen" -- Requires localization
L["captured"] = "captured"
L["The Alliance is victorious"] = "The Alliance is victorious" -- Requires localization
L["The Horde is victorious"] = "The Horde is victorious" -- Requires localization
-- Battleground Events
BG_ALLIANCE_WINS							= "Alliance wins" -- Requires localization
BG_ALLIANCE_WINS_TWO						= "Alliance wins" -- Requires localization
BG_EOTSRBG_ALLIANCE_CAPTURED				= "Alliance have captured" -- Requires localization
BG_EOTSRBG_HORDE_CAPTURED					= "Horde have captured" -- Requires localization
BG_CAPTURED									= "captured" -- Requires localization
BG_DROPPED									= "dropped" -- Requires localization
BG_HORDE_WINS								= "Horde wins" -- Requires localization
BG_HORDE_WINS_TWO							= "Horde wins" -- Requires localization
BG_RETURNED									= "returned" -- Requires localization
BG_ALLIANCE_FLAG_RETURNED					= "Alliance Flag has returned" -- Requires localization
BG_HORDE_FLAG_RETURNED						= "Horde Flag has returned" -- Requires localization
BG_SOTA_LET_THE_BATTLE						= "Let the battle for the Strand of the Ancients begin" -- Requires localization
BG_SOTA_ROUND_ONE							= "The battle for the Strand of the Ancients begins in 1 minute" -- Requires localization
BG_SOTA_ROUND_ONE_FINISHED					= "Round 1" -- Requires localization
BG_SOTA_ROUND_TWO							= "Round 2 of the Battle for the Strand of the Ancients begins in 1 minute" -- Requires localization
BG_SOTA_ROUND_TWO_TWO						= "Round 2 begins in 30 seconds" -- Requires localization
BG_VULNERABLE								= "vulnerable" -- Requires localization
BG_TIE_GAME									= "Tie game" -- Requires localization
-- Battlefield Events
BF_WG_ALLIANCE_ATTACKED						= "workshop has been attacked by the Alliance" -- Requires localization
BF_WG_ALLIANCE_CAPTURED						= "workshop has been captured by the Alliance" -- Requires localization
BF_WG_ALLIANCE_WIN_DEFENDED					= "Alliance has defended" -- Requires localization
BF_WG_HORDE_ATTACKED						= "workshop has been attacked by the Horde" -- Requires localization
BF_WG_HORDE_CAPTURED						= "workshop has been captured by the Horde" -- Requires localization
BF_WG_HORDE_WIN_DEFENDED					= "Horde has defended" -- Requires localization
end

function PVPSound:Korean()
L["General"] = "KorGeneral"
-- Messages
Msg_Streak1Male								= "just drew his" -- Requires localization
Msg_Streak1Female							= "just drew her" -- Requires localization
Msg_Streak2									= "is on" -- Requires localization
Msg_Streak3									= "is on" -- Requires localization
Msg_Streak4									= "is" -- Requires localization
Msg_Streak5									= "is" -- Requires localization
Msg_Streak6									= "is" -- Requires localization
Msg_Streak7									= "committed a" -- Requires localization
Msg_Streak8									= "committed a" -- Requires localization
Msg_Streak9									= "committed a" -- Requires localization
Msg_Streak10								= "committed a" -- Requires localization
Msg_S										= "'s" -- Requires localization
Msg_WasOverBy								= "was over by" -- Requires localization
Msg_YouGotKilledBy							= "You got killed by" -- Requires localization
-- Options
Opt_Ambience								= "[Ambience]" -- Requires localization
Opt_BgSound									= "Battleground sounds" -- Requires localization
Opt_Channel									= "Sound channel output" -- Requires localization
Opt_ChatMessage								= "[Chat Message]" -- Requires localization
Opt_Disable									= "[Disable]" -- Requires localization
Opt_Emote									= "[Emote]" -- Requires localization
Opt_EmoteMode								= "Emote mode" -- Requires localization
Opt_Emotes									= "Emotes" -- Requires localization
Opt_Enable									= "[Enable]" -- Requires localization
Opt_KillSound								= "Killing Blow sounds" -- Requires localization
Opt_Master									= "[Master]" -- Requires localization
Opt_Mode									= "Mode" -- Requires localization
Opt_MultiKillSound							= "Multi Killing sounds" -- Requires localization
Opt_Music									= "[Music]" -- Requires localization
Opt_PVE										= "[PVE]" -- Requires localization
Opt_PVP										= "[PVP]" -- Requires localization
Opt_PaySound								= "Payback sounds" -- Requires localization
Opt_Reset									= "Killing Counter and Sound Queue reset" -- Requires localization
Opt_Sound									= "[Sound]" -- Requires localization
Opt_UnrealTournament3						= "[Unreal Tournament 3]" -- Requires localization
Opt_Custom									= "[Custom]" -- Requires localization
Opt_Default									= "[Default]" -- Requires localization
Opt_Deutsch									= "[Deutsch]" -- Requires localization
Opt_English									= "[English]" -- Requires localization
Opt_Spanish									= "[Spanish]" -- Requires localization
Opt_France									= "[France]" -- Requires localization
Opt_Italian									= "[Italian]" -- Requires localization
Opt_Russian									= "[Russian]" -- Requires localization
Opt_KillSoundEngine							= "Kill Sound Engine" -- Requires localization
Opt_BgSoundEngine							= "Battleground Sound Engine" -- Requires localization
Opt_SoundEffect								= "Sound Effects" -- Requires localization
Opt_DataShare								= "Data Sharing" -- Requires localization
Opt_KillSct									= "Kill Scrolling Combat Text mode" -- Requires localization
Opt_Frame									= "Scrolling Combat Text frame name" -- Requires localization
Opt_SctEngine								= "Scrolling Combat Text Engine" -- Requires localization
Opt_MultiKillSct							= "Multi Kill Scrolling Combat Text" -- Requires localization
Opt_PaybackSct								= "Payback Scrolling Combat Text" -- Requires localization
Opt_PetKill									= "Pet Killing Blows" -- Requires localization
Opt_HideServerName							= "Hide server names" -- Requires localization
Opt_SoundPack								= "Sound Pack" -- Requires localization
Opt_SoundPackLanguage						= "Sound Pack language" -- Requires localization
Opt_Test									= "Testing sound" -- Requires localization
Opt_CmdList									= "Command list" -- Requires localization
Opt_CustomDoesntSupport						= "Custom Sound Pack doesn't support that language!" -- Requires localization
Opt_HelpBattlegroundSound					= "Enables or Disables Battleground sounds" -- Requires localization
Opt_HelpSoundEffect							= "Enables or Disables Sound Effects" -- Requires localization
Opt_HelpChannel								= "Switch between sound channels ('master' 'sound' 'music' 'ambience')" -- Requires localization
Opt_HelpCmdList								= "Command help" -- Requires localization
Opt_HelpDeathMessage						= "Enables or Disables Death Messages in Battlegrounds" -- Requires localization
Opt_HelpEmote								= "Enables or Disables Emotes completely" -- Requires localization
Opt_HelpEmoteMode							= "Switch between Emote and Chat Message mode" -- Requires localization
Opt_HelpInput								= "Enabled. Type /ps help for options" -- Requires localization
Opt_HelpKillSound							= "Enables or Disables Killing Blow and Multi Killing sounds" -- Requires localization
Opt_HelpMode								= "Switch between PVP and PVE mode" -- Requires localization
Opt_HelpMultiKillSound						= "Enables or Disables Multi Killing sounds" -- Requires localization
Opt_HelpPetKill								= "Enables or Disables Pet Killing Blow sounds" -- Requires localization
Opt_HelpPaybackSound						= "Enables or Disables Payback Killing sounds" -- Requires localization
Opt_HelpReset								= "Reset the counter of Killing Blows and the Payback- and Sound Queue System" -- Requires localization
Opt_HelpKillSoundEngine						= "Enables or Disables Sound Queue System usage in Killing Sounds" -- Requires localization
Opt_HelpBattlegroundSoundEngine				= "Enables or Disables Sound Queue System usage in Battleground Sounds" -- Requires localization
Opt_HelpDataShare							= "Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members" -- Requires localization
Opt_HelpKillSct								= "Enables or Disables Kill Scrolling Combat Text usage" -- Requires localization
Opt_HelpFrame								= "Name of the output frame in the supported Scrolling Combat Text" -- Requires localization
Opt_HelpSctEngine							= "Enables or Disables Scrolling Combat Text Queue System usage" -- Requires localization
Opt_HelpMultiKillSct						= "Enables or Disables Multi Kill Scrolling Combat Text usage" -- Requires localization
Opt_HelpPaybackSct							= "Enables or Disables Payback and Retribution Scrolling Combat Text usage" -- Requires localization
Opt_HelpHideServerName						= "Enables or Disables hiding the player's server name from Data Sharing and Death Messages" -- Requires localization
Opt_HelpSoundPack							= "Switch between Sound Packs ('ut3' 'custom')" -- Requires localization
Opt_HelpSoundPackLanguage					= "Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')" -- Requires localization
Opt_HelpStatus								= "Show status" -- Requires localization
Opt_HelpTest								= "Sound test" -- Requires localization
Opt_Kills									= "Killing Count" -- Requires localization
Opt_DeathMsg								= "Death messages" -- Requires localization
end

function PVPSound:KoreanClient()
-- Battleground Names
L["Eye of the Storm"] = "폭풍의 눈"
-- Battleground Zone Names
L["Silverwing Hold"] = "Silverwing Hold" -- Requires localization
L["Warsong Flag Room"] = "Warsong Flag Room" -- Requires localization
L["Dragonmaw Forge"] ="Dragonmaw Forge" -- Requires localization
L["Wildhammer Stronghold"] = "Wildhammer Stronghold" -- Requires localization
-- Battleground Events
L["taken the"] = "taken the" -- Requires localization
L["dropped"] = "dropped" -- Requires localization
L["picked"] = "깃발을 손에 넣었습니다"
L["returned"] = "returned" -- Requires localization
L["stolen"] = "stolen" -- Requires localization
L["captured"] = "captured"
L["The Alliance is victorious"] = "The Alliance is victorious" -- Requires localization
L["The Horde is victorious"] = "The Horde is victorious" -- Requires localization
-- Battleground Events
BG_ALLIANCE_WINS							= "얼라이언스 승리"
BG_ALLIANCE_WINS_TWO						= "얼라이언스 승리"
BG_EOTSRBG_ALLIANCE_CAPTURED				= "얼라이언스 |1이;가; 깃발을 차지했습니다"
BG_EOTSRBG_HORDE_CAPTURED					= "호드 |1이;가; 깃발을 차지했습니다"
BG_CAPTURED									= "깃발 쟁탈에 성공했습니다"
BG_DROPPED									= "떨어뜨렸습니다"
BG_HORDE_WINS								= "호드 승리"
BG_HORDE_WINS_TWO							= "호드 승리"
BG_RETURNED									= "깃발을 되찾았습니다"
BG_ALLIANCE_FLAG_RETURNED					= "Alliance Flag has returned" -- Requires localization
BG_HORDE_FLAG_RETURNED						= "Horde Flag has returned" -- Requires localization
BG_SOTA_LET_THE_BATTLE						= "Let the battle for the Strand of the Ancients begin" -- Requires localization
BG_SOTA_ROUND_ONE							= "The battle for the Strand of the Ancients begins in 1 minute" -- Requires localization
BG_SOTA_ROUND_ONE_FINISHED					= "Round 1" -- Requires localization
BG_SOTA_ROUND_TWO							= "Round 2 of the Battle for the Strand of the Ancients begins in 1 minute" -- Requires localization
BG_SOTA_ROUND_TWO_TWO						= "Round 2 begins in 30 seconds" -- Requires localization
BG_VULNERABLE								= "약해져서"
BG_TIE_GAME									= "Tie game" -- Requires localization
-- Battlefield Events
BF_WG_ALLIANCE_ATTACKED						= "workshop has been attacked by the Alliance" -- Requires localization
BF_WG_ALLIANCE_CAPTURED						= "workshop has been captured by the Alliance" -- Requires localization
BF_WG_ALLIANCE_WIN_DEFENDED					= "Alliance has defended" -- Requires localization
BF_WG_HORDE_ATTACKED						= "workshop has been attacked by the Horde" -- Requires localization
BF_WG_HORDE_CAPTURED						= "workshop has been captured by the Horde" -- Requires localization
BF_WG_HORDE_WIN_DEFENDED					= "Horde has defended" -- Requires localization
end

function PVPSound:Portuguese()
L["General"] = "PorGeneral"
-- Messages
Msg_Streak1Male								= "just drew his" -- Requires localization
Msg_Streak1Female							= "just drew her" -- Requires localization
Msg_Streak2									= "is on" -- Requires localization
Msg_Streak3									= "is on" -- Requires localization
Msg_Streak4									= "is" -- Requires localization
Msg_Streak5									= "is" -- Requires localization
Msg_Streak6									= "is" -- Requires localization
Msg_Streak7									= "committed a" -- Requires localization
Msg_Streak8									= "committed a" -- Requires localization
Msg_Streak9									= "committed a" -- Requires localization
Msg_Streak10								= "committed a" -- Requires localization
Msg_S										= "'s" -- Requires localization
Msg_WasOverBy								= "was over by" -- Requires localization
Msg_YouGotKilledBy							= "You got killed by" -- Requires localization
-- Options
Opt_Ambience								= "[Ambience]" -- Requires localization
Opt_BgSound									= "Battleground sounds" -- Requires localization
Opt_Channel									= "Sound channel output" -- Requires localization
Opt_ChatMessage								= "[Chat Message]" -- Requires localization
Opt_Disable									= "[Disable]" -- Requires localization
Opt_Emote									= "[Emote]" -- Requires localization
Opt_EmoteMode								= "Emote mode" -- Requires localization
Opt_Emotes									= "Emotes" -- Requires localization
Opt_Enable									= "[Enable]" -- Requires localization
Opt_KillSound								= "Killing Blow sounds" -- Requires localization
Opt_Master									= "[Master]" -- Requires localization
Opt_Mode									= "Mode" -- Requires localization
Opt_MultiKillSound							= "Multi Killing sounds" -- Requires localization
Opt_Music									= "[Music]" -- Requires localization
Opt_PVE										= "[PVE]" -- Requires localization
Opt_PVP										= "[PVP]" -- Requires localization
Opt_PaySound								= "Payback sounds" -- Requires localization
Opt_Reset									= "Killing Counter and Sound Queue reset" -- Requires localization
Opt_Sound									= "[Sound]" -- Requires localization
Opt_UnrealTournament3						= "[Unreal Tournament 3]" -- Requires localization
Opt_Custom									= "[Custom]" -- Requires localization
Opt_Default									= "[Default]" -- Requires localization
Opt_Deutsch									= "[Deutsch]" -- Requires localization
Opt_English									= "[English]" -- Requires localization
Opt_Spanish									= "[Spanish]" -- Requires localization
Opt_France									= "[France]" -- Requires localization
Opt_Italian									= "[Italian]" -- Requires localization
Opt_Russian									= "[Russian]" -- Requires localization
Opt_KillSoundEngine							= "Kill Sound Engine" -- Requires localization
Opt_BgSoundEngine							= "Battleground Sound Engine" -- Requires localization
Opt_SoundEffect								= "Sound Effects" -- Requires localization
Opt_DataShare								= "Data Sharing" -- Requires localization
Opt_KillSct									= "Kill Scrolling Combat Text mode" -- Requires localization
Opt_Frame									= "Scrolling Combat Text frame name" -- Requires localization
Opt_SctEngine								= "Scrolling Combat Text Engine" -- Requires localization
Opt_MultiKillSct							= "Multi Kill Scrolling Combat Text" -- Requires localization
Opt_PaybackSct								= "Payback Scrolling Combat Text" -- Requires localization
Opt_PetKill									= "Pet Killing Blows" -- Requires localization
Opt_HideServerName							= "Hide server names" -- Requires localization
Opt_SoundPack								= "Sound Pack" -- Requires localization
Opt_SoundPackLanguage						= "Sound Pack language" -- Requires localization
Opt_Test									= "Testing sound" -- Requires localization
Opt_CmdList									= "Command list" -- Requires localization
Opt_CustomDoesntSupport						= "Custom Sound Pack doesn't support that language!" -- Requires localization
Opt_HelpBattlegroundSound					= "Enables or Disables Battleground sounds" -- Requires localization
Opt_HelpSoundEffect							= "Enables or Disables Sound Effects" -- Requires localization
Opt_HelpChannel								= "Switch between sound channels ('master' 'sound' 'music' 'ambience')" -- Requires localization
Opt_HelpCmdList								= "Command help" -- Requires localization
Opt_HelpDeathMessage						= "Enables or Disables Death Messages in Battlegrounds" -- Requires localization
Opt_HelpEmote								= "Enables or Disables Emotes completely" -- Requires localization
Opt_HelpEmoteMode							= "Switch between Emote and Chat Message mode" -- Requires localization
Opt_HelpInput								= "Enabled. Type /ps help for options" -- Requires localization
Opt_HelpKillSound							= "Enables or Disables Killing Blow and Multi Killing sounds" -- Requires localization
Opt_HelpMode								= "Switch between PVP and PVE mode" -- Requires localization
Opt_HelpMultiKillSound						= "Enables or Disables Multi Killing sounds" -- Requires localization
Opt_HelpPetKill								= "Enables or Disables Pet Killing Blow sounds" -- Requires localization
Opt_HelpPaybackSound						= "Enables or Disables Payback Killing sounds" -- Requires localization
Opt_HelpReset								= "Reset the counter of Killing Blows and the Payback- and Sound Queue System" -- Requires localization
Opt_HelpKillSoundEngine						= "Enables or Disables Sound Queue System usage in Killing Sounds" -- Requires localization
Opt_HelpBattlegroundSoundEngine				= "Enables or Disables Sound Queue System usage in Battleground Sounds" -- Requires localization
Opt_HelpDataShare							= "Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members" -- Requires localization
Opt_HelpKillSct								= "Enables or Disables Kill Scrolling Combat Text usage" -- Requires localization
Opt_HelpFrame								= "Name of the output frame in the supported Scrolling Combat Text" -- Requires localization
Opt_HelpSctEngine							= "Enables or Disables Scrolling Combat Text Queue System usage" -- Requires localization
Opt_HelpMultiKillSct						= "Enables or Disables Multi Kill Scrolling Combat Text usage" -- Requires localization
Opt_HelpPaybackSct							= "Enables or Disables Payback and Retribution Scrolling Combat Text usage" -- Requires localization
Opt_HelpHideServerName						= "Enables or Disables hiding the player's server name from Data Sharing and Death Messages" -- Requires localization
Opt_HelpSoundPack							= "Switch between Sound Packs ('ut3' 'custom')" -- Requires localization
Opt_HelpSoundPackLanguage					= "Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')" -- Requires localization
Opt_HelpStatus								= "Show status" -- Requires localization
Opt_HelpTest								= "Sound test" -- Requires localization
Opt_Kills									= "Killing Count" -- Requires localization
Opt_DeathMsg								= "Death messages" -- Requires localization
end

function PVPSound:PortugueseClient()
-- Battleground Names
L["Eye of the Storm"] = "Olho da Tormenta"
-- Battleground Zone Names
L["Silverwing Hold"] = "Silverwing Hold" -- Requires localization
L["Warsong Flag Room"] = "Warsong Flag Room" -- Requires localization
L["Dragonmaw Forge"] ="Dragonmaw Forge" -- Requires localization
L["Wildhammer Stronghold"] = "Wildhammer Stronghold" -- Requires localization
-- Battleground Events
L["taken the"] = "taken the" -- Requires localization
L["dropped"] = "dropped" -- Requires localization
L["picked"] = "picked" -- Requires localization
L["returned"] = "returned" -- Requires localization
L["stolen"] = "stolen" -- Requires localization
L["captured"] = "captured"
L["The Alliance is victorious"] = "The Alliance is victorious" -- Requires localization
L["The Horde is victorious"] = "The Horde is victorious" -- Requires localization
-- Battleground Events
BG_ALLIANCE_WINS							= "Aliança vence"
BG_ALLIANCE_WINS_TWO						= "Aliança vence"
BG_EOTSRBG_ALLIANCE_CAPTURED				= "Alliance have captured" -- Requires localization
BG_EOTSRBG_HORDE_CAPTURED					= "Horde have captured" -- Requires localization
BG_CAPTURED									= "captured" -- Requires localization
BG_DROPPED									= "derrubada"
BG_HORDE_WINS								= "Horda vence"
BG_HORDE_WINS_TWO							= "Horda vence"
BG_RETURNED									= "returned" -- Requires localization
BG_ALLIANCE_FLAG_RETURNED					= "Alliance Flag has returned" -- Requires localization
BG_HORDE_FLAG_RETURNED						= "Horde Flag has returned" -- Requires localization
BG_SOTA_LET_THE_BATTLE						= "Let the battle for the Strand of the Ancients begin" -- Requires localization
BG_SOTA_ROUND_ONE							= "The battle for the Strand of the Ancients begins in 1 minute" -- Requires localization
BG_SOTA_ROUND_ONE_FINISHED					= "Round 1" -- Requires localization
BG_SOTA_ROUND_TWO							= "Round 2 of the Battle for the Strand of the Ancients begins in 1 minute" -- Requires localization
BG_SOTA_ROUND_TWO_TWO						= "Round 2 begins in 30 seconds" -- Requires localization
BG_VULNERABLE								= "vulnerable" -- Requires localization
BG_TIE_GAME									= "Tie game" -- Requires localization
-- Battlefield Events
BF_WG_ALLIANCE_ATTACKED						= "workshop has been attacked by the Alliance" -- Requires localization
BF_WG_ALLIANCE_CAPTURED						= "workshop has been captured by the Alliance" -- Requires localization
BF_WG_ALLIANCE_WIN_DEFENDED					= "Alliance has defended" -- Requires localization
BF_WG_HORDE_ATTACKED						= "workshop has been attacked by the Horde" -- Requires localization
BF_WG_HORDE_CAPTURED						= "workshop has been captured by the Horde" -- Requires localization
BF_WG_HORDE_WIN_DEFENDED					= "Horde has defended" -- Requires localization
end

function PVPSound:Russian()
-- Options
-- Sound Packs
L["Devil May Cry"] = "Devil May Cry"
L["Dota 2"] = "Dota 2"
L["Unreal Tournament 3"] = "Unreal Tournament 3"
L["Custom"] = "Пользовательский"
-- Languages
L["Default"] = "По умолчанию"
L["English"] = "Английский"
L["German"] = "Немецкий"
L["Spanish"] = "Испанский"
L["French"] = "Французский"
L["Italian"] = "Итальянский"
L["Russian"] = "Русский"
-- Sound Pack Types
L["Axe"] = "Axe" -- Requires localization
L["Bastion"] = "Bastion" -- Requires localization
L["Glados"] = "Glados" -- Requires localization
-- Sound Channels
L["Master"] = "Мастер"
L["Sound"] = "Звук"
L["Music"] = "Музыка"
L["Ambience"] = "Фон"
-- Mode
L["PVP"] = "ПвП"
L["PVE"] = "ПвЕ"
L["PVP and PVE"] = "ПвП и ПвЕ"
-- Button Labels
L["Addon Language"] = "Язык аддона"
L["Enable addon"] = "Вкл аддон"
L["Kill Sound Pack"] = "Kill Sound Pack" -- Requires localization
L["Kill Sound Pack Language"] = "Kill Sound Pack Language" -- Requires localization
L["Kill Sound Pack Type"] = "Kill Sound Pack Type" -- Requires localization
L["BG Sound Pack"] = "BG Sound Pack" -- Requires localization
L["BG Sound Pack Language"] = "BG Sound Pack Language" -- Requires localization
L["Sound Channel"] = "Звуковой канал"
L["Mode"] = "Режим"
L["Enable Kill Sounds"] = "Вкл озвучку убийств"
L["Enable Multi Kill Sounds"] = "Вкл звуки при Multi Kill"
-- Button Tooltips
L["Select a Language for the addon to use."] = "Выбрать язык аддона."
L["Enables or disables the addon completely."] = "Вкл / Выкл аддон полностью."
L["Select a Sound Pack to use for kill sounds."] = "Select a Sound Pack to use for kill sounds."
L["Select a Sound Pack to use for battleground sounds."] = "Select a Sound Pack to use for battleground sounds."
L["Select a Language/Type from the Sound Pack to use for kill sounds."] = "Select a Language/Type from the Sound Pack to use for kill sounds."
L["Select a Language/Type from the Sound Pack to use for battleground sounds."] = "Select a Language/Type from the Sound Pack to use for battleground sounds."
L["Select a Sound Channel to use."] = "Выбрать звуковой канал."
L["Select a mode to use."] = "Выберите режим."
L["Enables or disables Kill Sounds."] = "Вкл / Выкл озвучку убийств."
L["Enables or disables Multi Kill Sounds."] = "Вкл / Выкл звуки при Multi Kill."
-- Tab Labels
L["General"] = "Основное"
L["AV"] = "AV"
L["AB"] = "AB"
L["DG"] = "DG"
L["EOTS"] = "EOTS"
L["IOC"] = "IOC"
L["SM"] = "SM"
L["SOTA"] = "SOTA"
L["TOK"] = "TOK"
L["TBFG"] = "TBFG"
L["TP"] = "TP"
L["WSG"] = "WSG"
L["TB"] = "TB"
L["WG"] = "WG"
-- Frame Labels
L["Alterac Valley"] = "Альтеракская Долина"
L["Arathi Basin"] = "Низина Арати"
L["Deepwind Gorge"] = "Каньон Суровых Ветров"
L["Eye of the Storm"] = "Око Бури"
L["Isle of Conquest"] = "Остров Завоеваний"
L["Silvershard Mines"] = "Сверкающие Копи"
L["Strand of the Ancients"] = "Берег Древних"
L["Temple of Kotmogu"] = "Храм Котмогу"
L["The Battle for Gilneas"] = "Битва за Гилнеас"
L["Twin Peaks"] = "Два Пика"
L["Warsong Gulch"] = "Ущелье Песни Войны"
L["Tol Barad"] = "Тол Барад"
L["Wintergrasp"] = "Озеро Ледяных Оков"
-- Messages
Msg_Streak1Male								= "-"
Msg_Streak1Female							= "-"
Msg_Streak2									= "-"
Msg_Streak3									= "-"
Msg_Streak4									= "-"
Msg_Streak5									= "-"
Msg_Streak6									= "-"
Msg_Streak7									= "-"
Msg_Streak8									= "-"
Msg_Streak9									= "-"
Msg_Streak10								= "-"
Msg_S										= "-"
Msg_WasOverBy								= " - прервано игроком"
Msg_YouGotKilledBy							= "Вы были убиты игроком"
-- Options
Opt_Ambience								= "[Фон]"
Opt_BgSound									= "Звуки ПБ"
Opt_Channel									= "Звуковой канал"
Opt_ChatMessage								= "[Сообщения чата]"
Opt_Disable									= "[Выкл]"
Opt_Emote									= "[Эмоции]"
Opt_EmoteMode								= "Режим эмоций"
Opt_Emotes									= "Эмоции"
Opt_Enable									= "[Вкл]"
Opt_KillSound								= "Звуки убийств"
Opt_Master									= "[Мастер]"
Opt_Mode									= "Режим"
Opt_MultiKillSound							= "Звуки при Multi Kill"
Opt_Music									= "[Музыка]"
Opt_PVE										= "[ПвЕ]"
Opt_PVP										= "[ПвП]"
Opt_PaySound								= "Звуки при Расплате"
Opt_Reset									= "Сбросить счетчик убийств"
Opt_Sound									= "[Звук]"
Opt_UnrealTournament3						= "[Unreal Tournament 3]"
Opt_Custom									= "[пользовательский]"
Opt_Default									= "[По умолчанию]"
Opt_Deutsch									= "[Немецкий]"
Opt_English									= "[Английский]"
Opt_Spanish									= "[Испанский]"
Opt_France									= "[Французский]"
Opt_Italian									= "[Итальянский]"
Opt_Russian									= "[Русский]"
Opt_KillSoundEngine							= "Звуковой движок (убийства)"
Opt_BgSoundEngine							= "Звуковой движок (ПБ)"
Opt_SoundEffect								= "Звуковые эффекты"
Opt_DataShare								= "Обмен данными"
Opt_KillSct									= "Режим SCT при убийствах"
Opt_Frame									= "Название окошка SCT"
Opt_SctEngine								= "Движок SCT"
Opt_MultiKillSct							= "SCT при Multi Kill"
Opt_PaybackSct								= "SCT при Расплате"
Opt_PetKill									= "Смертельные Удары питомца"
Opt_HideServerName							= "Скрывать название сервера"
Opt_SoundPack								= "Саундпак"
Opt_SoundPackLanguage						= "Язык саундпака"
Opt_Test									= "Проверка звука"
Opt_CmdList									= "Список команд"
Opt_CustomDoesntSupport						= "Пользовательский саундпак не поддерживает этот язык!"
Opt_HelpBattlegroundSound					= "Вкл / Выкл звуки Поля Боя"
Opt_HelpSoundEffect							= "Вкл / Выкл звуковые эффекты"
Opt_HelpChannel								= "Переключение между звуковыми каналами ('master' 'sound' 'music' 'ambience')"
Opt_HelpCmdList								= "Помощь"
Opt_HelpDeathMessage						= "Вкл / Выкл сообщения о смерти на ПБ"
Opt_HelpEmote								= "Вкл / Выкл эмоций"
Opt_HelpEmoteMode							= "Переключение между режимами Эмоций / Сообщений чата"
Opt_HelpInput								= "Включено. Напишите /ps help"
Opt_HelpKillSound							= "Вкл / Выкл озвучку убийств"
Opt_HelpMode								= "Переключение ПвП / ПвЕ режимов"
Opt_HelpMultiKillSound						= "Вкл / Выкл звуки Серии убийств"
Opt_HelpPetKill								= "Вкл / Выкл озвучку Смертельных Ударов питомца"
Opt_HelpPaybackSound						= "Вкл / Выкл звуки при Расплате"
Opt_HelpReset								= "Сбросить счетчик убийств"
Opt_HelpKillSoundEngine						= "Вкл / Выкл использование системы звуковой очередности при убийствах"
Opt_HelpBattlegroundSoundEngine				= "Вкл / Выкл использование системы звуковой очередности для звуков ПБ"
Opt_HelpDataShare							= "Вкл / Выкл обмен данными о сериях и смертях между участниками в группе/рейде/ПБ"
Opt_HelpKillSct								= "Вкл / Выкл использование SCT при убийствах"
Opt_HelpFrame								= "Название окошка поддерживаемого движка SCT"
Opt_HelpSctEngine							= "Вкл / Выкл использование системы очередности для SCT"
Opt_HelpMultiKillSct						= "Вкл / Выкл использование SCT при Multi Kill"
Opt_HelpPaybackSct							= "Вкл / Выкл использование SCT при Расплате и Возмездии"
Opt_HelpHideServerName						= "Вкл / Выкл скрытие названия сервера игрока при обмене данными и в сообщениях о смерти"
Opt_HelpSoundPack							= "Переключиться между саундпаками ('ut3' 'custom')"
Opt_HelpSoundPackLanguage					= "Переключиться между языками саундпаков ('deu' 'eng' 'esn' 'fra' 'ita')"
Opt_HelpStatus								= "Пoказать статус"
Opt_HelpTest								= "Проверка звука"
Opt_Kills									= "Счетчик убийств"
Opt_DeathMsg								= "Сообщения о смерти"
end

function PVPSound:RussianClient()
-- Battleground Names
L["Eye of the Storm"] = "Око Бури"
-- Battleground Zone Names
L["Silverwing Hold"] = "Крепость Среброкрылых"
L["Warsong Flag Room"] = "Флаговая комната Песни Войны"
L["Dragonmaw Forge"] ="Кузня Драконьей Пасти"
L["Wildhammer Stronghold"] = "Цитадель Громового Молота"
-- Battleground Events
L["taken the"] = "захватывает вагонетку"
L["dropped"] = "бросил"
L["picked"] = "поднял"
L["returned"] = "вернул"
L["stolen"] = "получает золото"
L["The Alliance is victorious"] = "Альянс побеждает"
L["The Horde is victorious"] = "Орда побеждает"
-- Battleground Events
BG_ALLIANCE_WINS							= "Альянс побеждает"
BG_ALLIANCE_WINS_TWO						= "Альянс победил"
BG_EOTSRBG_ALLIANCE_CAPTURED				= "Альянс захватил флаг"
BG_EOTSRBG_HORDE_CAPTURED					= "Орда захватила флаг"
BG_CAPTURED									= "захвачено"
BG_DROPPED									= "уронили"
BG_HORDE_WINS								= "Орда побеждает"
BG_HORDE_WINS_TWO							= "Орда победила"
BG_RETURNED									= "вернули"
BG_ALLIANCE_FLAG_RETURNED					= "Флаг Альянса возвращен"
BG_HORDE_FLAG_RETURNED						= "Флаг Орды возвращен"
BG_SOTA_LET_THE_BATTLE						= "Да начнется битва за Берег Древних"
BG_SOTA_ROUND_ONE							= "Битва за Берег Древних начнется через 1 минуту"
BG_SOTA_ROUND_ONE_FINISHED					= "Раунд 1 - Завершен"
BG_SOTA_ROUND_TWO							= "Раунд 2 Битвы за Берег Древних начнется через 1 минуту"
BG_SOTA_ROUND_TWO_TWO						= "Раунд 2 начинается через 30 секунд"
BG_VULNERABLE								= "уязвимо"
BG_TIE_GAME									= "Ничья"
-- Battlefield Events
BF_WG_ALLIANCE_ATTACKED						= "мастерская атакована Альянсом"
BF_WG_ALLIANCE_CAPTURED						= "мастерская захвачена Альянсом"
BF_WG_ALLIANCE_WIN_DEFENDED					= "Альянс защитил"
BF_WG_HORDE_ATTACKED						= "мастерская атакована Ордой"
BF_WG_HORDE_CAPTURED						= "мастерская захвачена Ордой"
BF_WG_HORDE_WIN_DEFENDED					= "Орда защитила"
end

function PVPSound:SimplifiedChinese()
L["General"] = "SiChiGeneral"
-- Messages
Msg_Streak1Male								= "just drew his" -- Requires localization
Msg_Streak1Female							= "just drew her" -- Requires localization
Msg_Streak2									= "is on" -- Requires localization
Msg_Streak3									= "is on" -- Requires localization
Msg_Streak4									= "is" -- Requires localization
Msg_Streak5									= "is" -- Requires localization
Msg_Streak6									= "is" -- Requires localization
Msg_Streak7									= "committed a" -- Requires localization
Msg_Streak8									= "committed a" -- Requires localization
Msg_Streak9									= "committed a" -- Requires localization
Msg_Streak10								= "committed a" -- Requires localization
Msg_S										= "'s" -- Requires localization
Msg_WasOverBy								= "was over by" -- Requires localization
Msg_YouGotKilledBy							= "You got killed by" -- Requires localization
-- Options
Opt_Ambience								= "[Ambience]" -- Requires localization
Opt_BgSound									= "Battleground sounds" -- Requires localization
Opt_Channel									= "Sound channel output" -- Requires localization
Opt_ChatMessage								= "[Chat Message]" -- Requires localization
Opt_Disable									= "[Disable]" -- Requires localization
Opt_Emote									= "[Emote]" -- Requires localization
Opt_EmoteMode								= "Emote mode" -- Requires localization
Opt_Emotes									= "Emotes" -- Requires localization
Opt_Enable									= "[Enable]" -- Requires localization
Opt_KillSound								= "Killing Blow sounds" -- Requires localization
Opt_Master									= "[Master]" -- Requires localization
Opt_Mode									= "Mode" -- Requires localization
Opt_MultiKillSound							= "Multi Killing sounds" -- Requires localization
Opt_Music									= "[Music]" -- Requires localization
Opt_PVE										= "[PVE]" -- Requires localization
Opt_PVP										= "[PVP]" -- Requires localization
Opt_PaySound								= "Payback sounds" -- Requires localization
Opt_Reset									= "Killing Counter and Sound Queue reset" -- Requires localization
Opt_Sound									= "[Sound]" -- Requires localization
Opt_UnrealTournament3						= "[Unreal Tournament 3]" -- Requires localization
Opt_Custom									= "[Custom]" -- Requires localization
Opt_Default									= "[Default]" -- Requires localization
Opt_Deutsch									= "[Deutsch]" -- Requires localization
Opt_English									= "[English]" -- Requires localization
Opt_Spanish									= "[Spanish]" -- Requires localization
Opt_French									= "[France]" -- Requires localization
Opt_Italian									= "[Italian]" -- Requires localization
Opt_Russian									= "[Russian]" -- Requires localization
Opt_KillSoundEngine							= "Kill Sound Engine" -- Requires localization
Opt_BgSoundEngine							= "Battleground Sound Engine" -- Requires localization
Opt_SoundEffect								= "Sound Effects" -- Requires localization
Opt_DataShare								= "Data Sharing" -- Requires localization
Opt_KillSct									= "Kill Scrolling Combat Text mode" -- Requires localization
Opt_Frame									= "Scrolling Combat Text frame name" -- Requires localization
Opt_SctEngine								= "Scrolling Combat Text Engine" -- Requires localization
Opt_MultiKillSct							= "Multi Kill Scrolling Combat Text" -- Requires localization
Opt_PaybackSct								= "Payback Scrolling Combat Text" -- Requires localization
Opt_PetKill									= "Pet Killing Blows" -- Requires localization
Opt_HideServerName							= "Hide server names" -- Requires localization
Opt_SoundPack								= "Sound Pack" -- Requires localization
Opt_SoundPackLanguage						= "Sound Pack language" -- Requires localization
Opt_Test									= "Testing sound" -- Requires localization
Opt_CmdList									= "Command list" -- Requires localization
Opt_CustomDoesntSupport						= "Custom Sound Pack doesn't support that language!" -- Requires localization
Opt_HelpBattlegroundSound					= "Enables or Disables Battleground sounds" -- Requires localization
Opt_HelpSoundEffect							= "Enables or Disables Sound Effects" -- Requires localization
Opt_HelpChannel								= "Switch between sound channels ('master' 'sound' 'music' 'ambience')" -- Requires localization
Opt_HelpCmdList								= "Command help" -- Requires localization
Opt_HelpDeathMessage						= "Enables or Disables Death Messages in Battlegrounds" -- Requires localization
Opt_HelpEmote								= "Enables or Disables Emotes completely" -- Requires localization
Opt_HelpEmoteMode							= "Switch between Emote and Chat Message mode" -- Requires localization
Opt_HelpInput								= "Enabled. Type /ps help for options" -- Requires localization
Opt_HelpKillSound							= "Enables or Disables Killing Blow and Multi Killing sounds" -- Requires localization
Opt_HelpMode								= "Switch between PVP and PVE mode" -- Requires localization
Opt_HelpMultiKillSound						= "Enables or Disables Multi Killing sounds" -- Requires localization
Opt_HelpPetKill								= "Enables or Disables Pet Killing Blow sounds" -- Requires localization
Opt_HelpPaybackSound						= "Enables or Disables Payback Killing sounds" -- Requires localization
Opt_HelpReset								= "Reset the counter of Killing Blows and the Payback- and Sound Queue System" -- Requires localization
Opt_HelpKillSoundEngine						= "Enables or Disables Sound Queue System usage in Killing Sounds" -- Requires localization
Opt_HelpBattlegroundSoundEngine				= "Enables or Disables Sound Queue System usage in Battleground Sounds" -- Requires localization
Opt_HelpDataShare							= "Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members" -- Requires localization
Opt_HelpKillSct								= "Enables or Disables Kill Scrolling Combat Text usage" -- Requires localization
Opt_HelpFrame								= "Name of the output frame in the supported Scrolling Combat Text" -- Requires localization
Opt_HelpSctEngine							= "Enables or Disables Scrolling Combat Text Queue System usage" -- Requires localization
Opt_HelpMultiKillSct						= "Enables or Disables Multi Kill Scrolling Combat Text usage" -- Requires localization
Opt_HelpPaybackSct							= "Enables or Disables Payback and Retribution Scrolling Combat Text usage" -- Requires localization
Opt_HelpHideServerName						= "Enables or Disables hiding the player's server name from Data Sharing and Death Messages" -- Requires localization
Opt_HelpSoundPack							= "Switch between Sound Packs ('ut3' 'custom')" -- Requires localization
Opt_HelpSoundPackLanguage					= "Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')" -- Requires localization
Opt_HelpStatus								= "Show status" -- Requires localization
Opt_HelpTest								= "Sound test" -- Requires localization
Opt_Kills									= "Killing Count" -- Requires localization
Opt_DeathMsg								= "Death messages" -- Requires localization
end

function PVPSound:SimplifiedChineseClient()
-- Battleground Names
L["Eye of the Storm"] = "风暴之眼"
-- Battleground Zone Names
L["Silverwing Hold"] = "Silverwing Hold" -- Requires localization
L["Warsong Flag Room"] = "Warsong Flag Room" -- Requires localization
L["Dragonmaw Forge"] ="Dragonmaw Forge" -- Requires localization
L["Wildhammer Stronghold"] = "Wildhammer Stronghold" -- Requires localization
-- Battleground Events
L["taken the"] = "taken the" -- Requires localization
L["dropped"] = "dropped" -- Requires localization
L["picked"] = "拔起了"
L["returned"] = "returned" -- Requires localization
L["stolen"] = "stolen" -- Requires localization
L["captured"] = "captured"
L["The Alliance is victorious"] = "The Alliance is victorious" -- Requires localization
L["The Horde is victorious"] = "The Horde is victorious" -- Requires localization
-- Battleground Events
BG_ALLIANCE_WINS							= "联盟 获胜"
BG_ALLIANCE_WINS_TWO						= "联盟 获胜"
BG_EOTSRBG_ALLIANCE_CAPTURED				= "联盟 夺得了旗帜"
BG_EOTSRBG_HORDE_CAPTURED					= "部落 夺得了旗帜"
BG_CAPTURED									= "的旗帜"
BG_DROPPED									= "旗帜被扔掉了"
BG_HORDE_WINS								= "部落 获胜"
BG_HORDE_WINS_TWO							= "部落 获胜"
BG_RETURNED									= "还到了它的基地中"
BG_ALLIANCE_FLAG_RETURNED					= "Alliance Flag has returned" -- Requires localization
BG_HORDE_FLAG_RETURNED						= "Horde Flag has returned" -- Requires localization
BG_SOTA_LET_THE_BATTLE						= "Let the battle for the Strand of the Ancients begin" -- Requires localization
BG_SOTA_ROUND_ONE							= "The battle for the Strand of the Ancients begins in 1 minute" -- Requires localization
BG_SOTA_ROUND_ONE_FINISHED					= "Round 1" -- Requires localization
BG_SOTA_ROUND_TWO							= "Round 2 of the Battle for the Strand of the Ancients begins in 1 minute" -- Requires localization
BG_SOTA_ROUND_TWO_TWO						= "Round 2 begins in 30 seconds" -- Requires localization
BG_VULNERABLE								= "vulnerable" -- Requires localization
BG_TIE_GAME									= "Tie game" -- Requires localization
-- Battlefield Events
BF_WG_ALLIANCE_ATTACKED						= "workshop has been attacked by the Alliance" -- Requires localization
BF_WG_ALLIANCE_CAPTURED						= "workshop has been captured by the Alliance" -- Requires localization
BF_WG_ALLIANCE_WIN_DEFENDED					= "Alliance has defended" -- Requires localization
BF_WG_HORDE_ATTACKED						= "workshop has been attacked by the Horde" -- Requires localization
BF_WG_HORDE_CAPTURED						= "workshop has been captured by the Horde" -- Requires localization
BF_WG_HORDE_WIN_DEFENDED					= "Horde has defended" -- Requires localization
end

function PVPSound:TraditionalChinese()
L["General"] = "TraChiGeneral"
-- Messages
Msg_Streak1Male								= "just drew his" -- Requires localization
Msg_Streak1Female							= "just drew her" -- Requires localization
Msg_Streak2									= "is on" -- Requires localization
Msg_Streak3									= "is on" -- Requires localization
Msg_Streak4									= "is" -- Requires localization
Msg_Streak5									= "is" -- Requires localization
Msg_Streak6									= "is" -- Requires localization
Msg_Streak7									= "committed a" -- Requires localization
Msg_Streak8									= "committed a" -- Requires localization
Msg_Streak9									= "committed a" -- Requires localization
Msg_Streak10								= "committed a" -- Requires localization
Msg_S										= "'s" -- Requires localization
Msg_WasOverBy								= "was over by" -- Requires localization
Msg_YouGotKilledBy							= "You got killed by" -- Requires localization
-- Options
Opt_Ambience								= "[Ambience]" -- Requires localization
Opt_BgSound									= "Battleground sounds" -- Requires localization
Opt_Channel									= "Sound channel output" -- Requires localization
Opt_ChatMessage								= "[Chat Message]" -- Requires localization
Opt_Disable									= "[Disable]" -- Requires localization
Opt_Emote									= "[Emote]" -- Requires localization
Opt_EmoteMode								= "Emote mode" -- Requires localization
Opt_Emotes									= "Emotes" -- Requires localization
Opt_Enable									= "[Enable]" -- Requires localization
Opt_KillSound								= "Killing Blow sounds" -- Requires localization
Opt_Master									= "[Master]" -- Requires localization
Opt_Mode									= "Mode" -- Requires localization
Opt_MultiKillSound							= "Multi Killing sounds" -- Requires localization
Opt_Music									= "[Music]" -- Requires localization
Opt_PVE										= "[PVE]" -- Requires localization
Opt_PVP										= "[PVP]" -- Requires localization
Opt_PaySound								= "Payback sounds" -- Requires localization
Opt_Reset									= "Killing Counter and Sound Queue reset" -- Requires localization
Opt_Sound									= "[Sound]" -- Requires localization
Opt_UnrealTournament3						= "[Unreal Tournament 3]" -- Requires localization
Opt_Custom									= "[Custom]" -- Requires localization
Opt_Default									= "[Default]" -- Requires localization
Opt_Deutsch									= "[Deutsch]" -- Requires localization
Opt_English									= "[English]" -- Requires localization
Opt_Spanish									= "[Spanish]" -- Requires localization
Opt_France									= "[France]" -- Requires localization
Opt_Italian									= "[Italian]" -- Requires localization
Opt_Russian									= "[Russian]" -- Requires localization
Opt_KillSoundEngine							= "Kill Sound Engine" -- Requires localization
Opt_BgSoundEngine							= "Battleground Sound Engine" -- Requires localization
Opt_SoundEffect								= "Sound Effects" -- Requires localization
Opt_DataShare								= "Data Sharing" -- Requires localization
Opt_KillSct									= "Kill Scrolling Combat Text mode" -- Requires localization
Opt_Frame									= "Scrolling Combat Text frame name" -- Requires localization
Opt_SctEngine								= "Scrolling Combat Text Engine" -- Requires localization
Opt_MultiKillSct							= "Multi Kill Scrolling Combat Text" -- Requires localization
Opt_PaybackSct								= "Payback Scrolling Combat Text" -- Requires localization
Opt_PetKill									= "Pet Killing Blows" -- Requires localization
Opt_HideServerName							= "Hide server names" -- Requires localization
Opt_SoundPack								= "Sound Pack" -- Requires localization
Opt_SoundPackLanguage						= "Sound Pack language" -- Requires localization
Opt_Test									= "Testing sound" -- Requires localization
Opt_CmdList									= "Command list" -- Requires localization
Opt_CustomDoesntSupport						= "Custom Sound Pack doesn't support that language!" -- Requires localization
Opt_HelpBattlegroundSound					= "Enables or Disables Battleground sounds" -- Requires localization
Opt_HelpSoundEffect							= "Enables or Disables Sound Effects" -- Requires localization
Opt_HelpChannel								= "Switch between sound channels ('master' 'sound' 'music' 'ambience')" -- Requires localization
Opt_HelpCmdList								= "Command help" -- Requires localization
Opt_HelpDeathMessage						= "Enables or Disables Death Messages in Battlegrounds" -- Requires localization
Opt_HelpEmote								= "Enables or Disables Emotes completely" -- Requires localization
Opt_HelpEmoteMode							= "Switch between Emote and Chat Message mode" -- Requires localization
Opt_HelpInput								= "Enabled. Type /ps help for options" -- Requires localization
Opt_HelpKillSound							= "Enables or Disables Killing Blow and Multi Killing sounds" -- Requires localization
Opt_HelpMode								= "Switch between PVP and PVE mode" -- Requires localization
Opt_HelpMultiKillSound						= "Enables or Disables Multi Killing sounds" -- Requires localization
Opt_HelpPetKill								= "Enables or Disables Pet Killing Blow sounds" -- Requires localization
Opt_HelpPaybackSound						= "Enables or Disables Payback Killing sounds" -- Requires localization
Opt_HelpReset								= "Reset the counter of Killing Blows and the Payback- and Sound Queue System" -- Requires localization
Opt_HelpKillSoundEngine						= "Enables or Disables Sound Queue System usage in Killing Sounds" -- Requires localization
Opt_HelpBattlegroundSoundEngine				= "Enables or Disables Sound Queue System usage in Battleground Sounds" -- Requires localization
Opt_HelpDataShare							= "Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members" -- Requires localization
Opt_HelpKillSct								= "Enables or Disables Kill Scrolling Combat Text usage" -- Requires localization
Opt_HelpFrame								= "Name of the output frame in the supported Scrolling Combat Text" -- Requires localization
Opt_HelpSctEngine							= "Enables or Disables Scrolling Combat Text Queue System usage" -- Requires localization
Opt_HelpMultiKillSct						= "Enables or Disables Multi Kill Scrolling Combat Text usage" -- Requires localization
Opt_HelpPaybackSct							= "Enables or Disables Payback and Retribution Scrolling Combat Text usage" -- Requires localization
Opt_HelpHideServerName						= "Enables or Disables hiding the player's server name from Data Sharing and Death Messages" -- Requires localization
Opt_HelpSoundPack							= "Switch between Sound Packs ('ut3' 'custom')" -- Requires localization
Opt_HelpSoundPackLanguage					= "Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')" -- Requires localization
Opt_HelpStatus								= "Show status" -- Requires localization
Opt_HelpTest								= "Sound test" -- Requires localization
Opt_Kills									= "Killing Count" -- Requires localization
Opt_DeathMsg								= "Death messages" -- Requires localization
end

function PVPSound:TraditionalChineseClient()
-- Battleground Names
L["Eye of the Storm"] = "暴風之眼"
-- Battleground Zone Names
L["Silverwing Hold"] = "Silverwing Hold"
L["Warsong Flag Room"] = "Warsong Flag Room"
L["Dragonmaw Forge"] ="Dragonmaw Forge"
L["Wildhammer Stronghold"] = "Wildhammer Stronghold"
-- Battleground Events
L["taken the"] = "taken the"
L["dropped"] = "dropped"
L["picked"] = "拔掉了"
L["returned"] = "returned"
L["stolen"] = "stolen"
L["captured"] = "captured"
L["The Alliance is victorious"] = "The Alliance is victorious"
L["The Horde is victorious"] = "The Horde is victorious"
-- Battleground Events
BG_ALLIANCE_WINS							= "聯盟 勝利"
BG_ALLIANCE_WINS_TWO						= "聯盟 勝利"
BG_EOTSRBG_ALLIANCE_CAPTURED				= "聯盟 已奪得旗幟"
BG_EOTSRBG_HORDE_CAPTURED					= "部落 已奪得旗幟"
BG_CAPTURED									= "的旗幟"
BG_DROPPED									= "旗幟已經掉落"
BG_HORDE_WINS								= "部落 勝利"
BG_HORDE_WINS_TWO							= "部落 勝利"
BG_RETURNED									= "還到了它的基地"
BG_ALLIANCE_FLAG_RETURNED					= "Alliance Flag has returned" -- Requires localization
BG_HORDE_FLAG_RETURNED						= "Horde Flag has returned" -- Requires localization
BG_SOTA_LET_THE_BATTLE						= "Let the battle for the Strand of the Ancients begin" -- Requires localization
BG_SOTA_ROUND_ONE							= "The battle for the Strand of the Ancients begins in 1 minute" -- Requires localization
BG_SOTA_ROUND_ONE_FINISHED					= "Round 1" -- Requires localization
BG_SOTA_ROUND_TWO							= "Round 2 of the Battle for the Strand of the Ancients begins in 1 minute" -- Requires localization
BG_SOTA_ROUND_TWO_TWO						= "Round 2 begins in 30 seconds" -- Requires localization
BG_VULNERABLE								= "vulnerable" -- Requires localization
BG_TIE_GAME									= "Tie game" -- Requires localization
-- Battlefield Events
BF_WG_ALLIANCE_ATTACKED						= "workshop has been attacked by the Alliance" -- Requires localization
BF_WG_ALLIANCE_CAPTURED						= "workshop has been captured by the Alliance" -- Requires localization
BF_WG_ALLIANCE_WIN_DEFENDED					= "Alliance has defended" -- Requires localization
BF_WG_HORDE_ATTACKED						= "workshop has been attacked by the Horde" -- Requires localization
BF_WG_HORDE_CAPTURED						= "workshop has been captured by the Horde" -- Requires localization
BF_WG_HORDE_WIN_DEFENDED					= "Horde has defended" -- Requires localization
end

if Locale == "enUS" or Locale == "enGB" then
	PVPSound:EnglishClient()
elseif Locale == "deDE" then
	PVPSound:GermanClient()
elseif Locale == "esES" then
	PVPSound:SpanishClient()
elseif Locale == "esMX" then
	PVPSound:LatinAmericanSpanishClient()
elseif Locale == "frFR" then
	PVPSound:FrenchClient()
elseif Locale == "itIT" then
	PVPSound:ItalianClient()
elseif Locale == "koKR" then
	PVPSound:KoreanClient()
elseif Locale == "ptBR" then
	PVPSound:PortugueseClient()
elseif Locale == "ruRU" then
	PVPSound:RussianClient()
elseif Locale == "zhCN" then
	PVPSound:SimplifiedChineseClient()
elseif Locale == "zhTW" then
	PVPSound:TraditionalChineseClient()
else
	PVPSound:EnglishClient()
end