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
L["Streak1Male"] = "just drew his"
L["Streak1Female"] = "just drew her"
L["Streak2"] = "is on"
L["Streak3"] = "is on"
L["Streak4"] = "is"
L["Streak5"] = "is"
L["Streak6"] = "is"
L["Streak7"] = "committed a"
L["Streak8"] = "committed a"
L["Streak9"] = "committed a"
L["Streak10"] = "committed a"
L["'s"] = "'s"
L["was over by"] = "was over by"
L["You got killed by"] = "You got killed by"
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
L["Ashamane's Fall"] = "Ashamane's Fall"
L["Blade's Edge Arena"] = "Blade's Edge Arena"
L["Dalaran Arena"] = "Dalaran Arena"
L["Nagrand Arena"] = "Nagrand Arena"
L["Ruins of Lordaeron"] = "Ruins of Lordaeron"
L["The Tiger's Peak"] = "The Tiger's Peak"
L["Tol'viron Arena"] = "Tol'viron Arena"
-- Slash Options
L["[Enable]"] = "[Enable]"
L["[Disable]"] = "[Disable]"
L["Mode"] = "Mode"
L["[PVP]"] = "[PVP]"
L["[PVE]"] = "[PVE]"
L["[PVP and PVE]"] = "[PVP and PVE]"
L["[Emote]"] = "[Emote]"
L["[Chat Message]"] = "[Chat Message]"
L["[Master]"] = "[Master]"
L["[Sound]"] = "[Sound]"
L["[Music]"] = "[Music]"
L["[Ambience]"] = "[Ambience]"
L["[Unreal Tournament 3]"] = "[Unreal Tournament 3]"
L["[Custom]"] = "[Custom]"
L["[Default]"] = "[Default]"
L["[Deutsch]"] = "[Deutsch]"
L["[English]"] = "[English]"
L["[Spanish]"] = "[Spanish]"
L["[France]"] = "[France]"
L["[Italian]"] = "[Italian]"
L["[Russian]"] = "[Russian]"
L["Emotes"] = "Emotes"
L["Emote mode"] = "Emote mode"
L["Death messages"] = "Death messages"
L["Killing Blow sounds"] = "Killing Blow sounds"
L["Multi Killing sounds"] = "Multi Killing sounds"
L["Pet Killing Blows"] = "Pet Killing Blows"
L["Payback sounds"] = "Payback sounds"
L["Battleground sounds"] = "Battleground sounds"
L["Sound Effects"] = "Sound Effects"
L["Kill Sound Engine"] = "Kill Sound Engine"
L["Battleground Sound Engine"] = "Battleground Sound Engine"
L["Data Sharing"] = "Data Sharing"
L["Kill Scrolling Combat Text mode"] = "Kill Scrolling Combat Text mode"
L["Multi Kill Scrolling Combat Text"] = "Multi Kill Scrolling Combat Text"
L["Payback Scrolling Combat Text"] = "Payback Scrolling Combat Text"
L["Scrolling Combat Text Engine"] = "Scrolling Combat Text Engine"
L["Scrolling Combat Text frame name"] = "Scrolling Combat Text frame name"
L["Hide server names"] = "Hide server names"
L["Sound Pack"] = "Sound Pack"
L["Sound Pack language"] = "Sound Pack language"
L["Sound channel output"] = "Sound channel output"
L["Scrolling Combat Text and sound test"] = "Scrolling Combat Text and sound test"
L["Killing Counter and Sound Queue reset"] = "Killing Counter and Sound Queue reset"
L["Execute sounds"] = "Execute sounds"
L["Command list"] = "Command list"
L["Custom Sound Pack doesn't support that language!"] = "Custom Sound Pack doesn't support that language!"
L["Show status"] = "Show status"
L["Switch between PVP and PVE mode"] = "Switch between PVP and PVE mode"
L["Enables or Disables Emotes completely"] = "Enables or Disables Emotes completely"
L["Switch between Emote and Chat Message mode"] = "Switch between Emote and Chat Message mode"
L["Enables or Disables Death Messages"] = "Enables or Disables Death Messages"
L["Enables or Disables Killing Blow and Multi Killing sounds"] = "Enables or Disables Killing Blow and Multi Killing sounds"
L["Enables or Disables Payback Killing sounds"] = "Enables or Disables Payback Killing sounds"
L["Enables or Disables Multi Killing sounds"] = "Enables or Disables Multi Killing sounds"
L["Enables or Disables Pet Killing Blow sounds"] = "Enables or Disables Pet Killing Blow sounds"
L["Enables or Disables Battleground sounds"] = "Enables or Disables Battleground sounds"
L["Enables or Disables Sound Effects"] = "Enables or Disables Sound Effects"
L["Enables or Disables Sound Queue System usage in Killing Sounds"] = "Enables or Disables Sound Queue System usage in Killing Sounds"
L["Enables or Disables Sound Queue System usage in Battleground Sounds"] = "Enables or Disables Sound Queue System usage in Battleground Sounds"
L["Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members"] = "Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members"
L["Enables or Disables Kill Scrolling Combat Text usage"] = "Enables or Disables Kill Scrolling Combat Text usage"
L["Name of the output frame in the supported Scrolling Combat Text"] = "Name of the output frame in the supported Scrolling Combat Text"
L["Enables or Disables Scrolling Combat Text Queue System usage"] = "Enables or Disables Scrolling Combat Text Queue System usage"
L["Enables or Disables Multi Kill Scrolling Combat Text usage"] = "Enables or Disables Multi Kill Scrolling Combat Text usage"
L["Enables or Disables Payback and Retribution Scrolling Combat Text usage"] = "Enables or Disables Payback and Retribution Scrolling Combat Text usage"
L["Enables or Disables hiding the player's server name from Data Sharing and Death Messages"] = "Enables or Disables hiding the player's server name from Data Sharing and Death Messages"
L["Enables or Disables execute sounds"] = "Enables or Disables execute sounds"
L["Switch between sound channels ('master' 'sound' 'music' 'ambience')"] = "Switch between sound channels ('master' 'sound' 'music' 'ambience')"
L["Switch between Sound Packs ('ut3' 'custom')"] = "Switch between Sound Packs ('ut3' 'custom')"
L["Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')"] = "Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')"
L["Scrolling Combat Text and sound test"] = "Scrolling Combat Text and sound test"
L["Reset the counter of Killing Blows and the Payback-, Retibution-, Sound-, and SCT Queue System"] = "Reset the counter of Killing Blows and the Payback-, Retibution-, Sound-, and SCT Queue System"
L["Command help"] = "Command help"
L["Loaded. Type /ps help for options"] = "Loaded. Type /ps help for options"
L["Killing Count"] = "Killing Count"
end

function PVPSound:EnglishClient()
-- Battleground Names
L["Eye of the Storm"] = "Eye of the Storm"
-- Battleground Zone Names
L["Silverwing Hold"] = "Silverwing Hold"
L["Warsong Flag Room"] = "Warsong Flag Room" --in new WSG there is no subzones and Hord Flagroom is "Warsong lumber mill"
L["Dragonmaw Forge"] ="Dragonmaw Forge"
L["Wildhammer Stronghold"] = "Wildhammer Stronghold"
-- Battleground Events
L["taken the"] = "taken the"
L["dropped"] = "dropped"
L["picked"] = "picked"
L["pickedA"] = "picked"--fix for Ru client
L["returned"] = "returned"
L["stolen"] = "stolen"
L["captured"] = "captured"
L["The Alliance is victorious"] = "The Alliance is victorious"
L["The Horde is victorious"] = "The Horde is victorious"
L["The Alliance is near victory"] = "The Alliance is near victory"
L["The Horde is near victory"] = "The Horde is near victory"
L["Alliance wins"] = "Alliance wins"
L["Alliance wins secondary"] = "Alliance wins"
L["Horde wins"] = "Horde wins"
L["Horde wins secondary"] = "Horde wins"
L["Alliance Flag has returned"] = "Alliance Flag has returned"
L["Horde Flag has returned"] = "Horde Flag has returned"
L["vulnerable"] = "vulnerable"
L["Alliance have captured"] = "has captured the flag"
L["Horde have captured"] = "has captured the flag"
L["Let the battle for the Strand of the Ancients begin"] = "Let the battle for the Strand of the Ancients begin"
L["The battle for the Strand of the Ancients begins in 1 minute"] = "The battle for the Strand of the Ancients begins in 1 minute"
L["Round 1"] = "Round 1"
L["Round 2 of the Battle for the Strand of the Ancients begins in 1 minute"] = "Round 2 of the Battle for the Strand of the Ancients begins in 1 minute"
L["Round 2 begins in 30 seconds"] = "Round 2 begins in 30 seconds"
L["Tie game"] = "Tie game"
-- Battlefield Events
L["workshop has been attacked by the Alliance"] = "workshop has been attacked by the Alliance"
L["workshop has been captured by the Alliance"] = "workshop has been captured by the Alliance"
L["workshop has been attacked by the Horde"] = "workshop has been attacked by the Horde"
L["workshop has been captured by the Horde"] = "workshop has been captured by the Horde"
L["Alliance has defended"] = "Alliance has defended"
L["Horde has defended"] = "Horde has defended"
end

function PVPSound:German()
L["General"] = "GerGeneral"
-- Messages
L["Streak1Male"] = "erzielte"
L["Streak1Female"] = "erzielte"
L["Streak2"] = "befindet sich im"
L["Streak3"] = "läuft"
L["Streak4"] = "ist"
L["Streak5"] = "ist"
L["Streak6"] = "ist"
L["Streak7"] = "verursacht ein"
L["Streak8"] = "verursacht ein"
L["Streak9"] = "verursacht ein"
L["Streak10"] = "verursacht ein"
L["'s"] = "'s" -- Requires localization
L["was over by"] = "was over by" -- Requires localization
L["You got killed by"] = "Du wurdest getötet von"
-- Options
L["[Ambience]"] = "[Umgebung]"
L["Battleground sounds"] = "Schlachtfeld Geräusche"
L["Battleground Sound Engine"] = "Schlachtfeld Geräusche Engine"
L["Sound channel output"] = "Sound Kanal Ausgang"
L["[Chat Message]"] = "[Chat Nachrichten]"
L["Command list"] = "Befehlsliste"
L["[Custom]"] = "[Individualisierung]"
L["Data Sharing"] = "Dateiverteilung"
L["Death messages"] = "Todesberichte"
L["[Default]"] = "[Standardeinstellung]"
L["[Deutsch]"] = "[Deutsch]"
L["[Disable]"] = "[Deaktivieren]"
L["[Emote]"] = "[Emotion]"
L["Emote mode"] = "Emotionen Modus"
L["Emotes"] = "Emotionen"
L["[Enable]"] = "[Aktivieren]"
L["[English]"] = "[English]"
L["Scrolling Combat Text frame name"] = "Scrolling Combat Text frame name" -- Requires localization
L["[France]"] = "[France]"
L["[Russian]"] = "[Russian]" -- Requires localization
L["Custom Sound Pack doesn't support that language!"] = "Custom Sound Pack doesn't support that language!" -- Requires localization
L["Enables or Disables Battleground sounds"] = "Schlachtfeldgeräusche aktivieren oder deaktivieren"
L["Enables or Disables Sound Queue System usage in Battleground Sounds"] = "aktivieren oder deaktivieren des Sound-Abfolge-System Benutzung in Schlachtfeldern"
L["Switch between sound channels ('master' 'sound' 'music' 'ambience')"] = "wechsle zwischen Sound-Kanälen ('meister' 'sound' 'musik' 'umgebung')"
L["Command help"] = "Befehl Hilfe"
L["Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members"] = "aktiviere oder deaktiviere Serien- und Todesdatenteilung und Erhalt unter Schlachtzug/Gruppen/Schlachtfeld Mitgliedern"
L["Enables or Disables Death Messages"] = "aktiviere oder deaktiviere Todesberichte"
L["Enables or Disables Emotes completely"] = "aktiviere oder deaktiviere Emotionen komplett"
L["Switch between Emote and Chat Message mode"] = "wechsle zwischen Emotionen und Chat-Nachrichten Modus"
L["Name of the output frame in the supported Scrolling Combat Text"] = "Name of the output frame in the supported Scrolling Combat Text" -- Requires localization
L["Enables or Disables hiding the player's server name from Data Sharing and Death Messages"] = "aktiviere oder deaktiviere das Verbergen des Spieler's Servernamens von der Datenteilung und den Todesberichten"
L["Loaded. Type /ps help for options"] = "Aktiviert. Tippe /ps für Hilfe."
L["Enables or Disables Kill Scrolling Combat Text usage"] = "aktiviere oder deaktiviere die Tötungs- Scrolling Combat Text -benutzung"
L["Enables or Disables Killing Blow and Multi Killing sounds"] = "aktiviere oder deaktiviere die Todesstoß- und Mehrfachtodesstoßsounds"
L["Enables or Disables Sound Queue System usage in Killing Sounds"] = "aktiviere oder deaktiviere Sound-Reihnfolge-Systembenutzung bei Tötungssounds"
L["Switch between PVP and PVE mode"] = "wechsle zwischen PvP und PvE Modus"
L["Enables or Disables Multi Kill Scrolling Combat Text usage"] = "aktiviere oder deaktiviere Mehrfachtötungs- Scrolling Combat Text -benutzung"
L["Enables or Disables Multi Killing sounds"] = "aktiviere oder deaktiviere Mehrfachtötungssounds"
L["Enables or Disables Pet Killing Blow sounds"] = "Enables or Disables Pet Killing Blow sounds" -- Requires localization
L["Enables or Disables Payback and Retribution Scrolling Combat Text usage"] = "aktiviere oder deaktiviere Heimzahlen- und Vergeltungs- Scrolling Combat Text -benutzung"
L["Enables or Disables Payback Killing sounds"] = "aktiviere oder deaktiviere Heimzahlen Tötungssounds"
L["Reset the counter of Killing Blows and the Payback-, Retibution-, Sound-, and SCT Queue System"] = "setze den Zähler für Todesstöß- Heimzahlen- Vergeltungs- Sound- und SCT -Reihnfolge-System zurück"
L["Enables or Disables Scrolling Combat Text Queue System usage"] = "aktiviere oder deaktiviere die Scrolling Combat Text -Reihnfolge-Systembenutzung"
L["Enables or Disables Sound Effects"] = "aktiviere oder deaktiviere Soundeffekte"
L["Switch between Sound Packs ('ut3' 'custom')"] = "wechsle zwischen Soundpaketen ('ut3' 'custom')"
L["Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')"] = "wechsle zwischen Soundpaketsprachen ('deu' 'eng' 'esn' 'fra' 'ita')"
L["Show status"] = "zeige Status"
L["Scrolling Combat Text and sound test"] = "Scrolling Combat Text- und Soundtest"
L["Hide server names"] = "Verstecke Servernamen"
L["[Italian]"] = "[Italian]"
L["Killing Count"] = "Tötungsanzahl"
L["Kill Scrolling Combat Text mode"] = "Tötungs Scrolling Combat Text Modus"
L["Killing Blow sounds"] = "Todesstoß Sound"
L["Kill Sound Engine"] = "Todesstoß Geräusche Engine"
L["[Master]"] = "[Meister]"
L["Mode"] = "Modus"
L["Multi Kill Scrolling Combat Text"] = "Multi Kill Scrolling Combat Text"
L["Multi Killing sounds"] = "Mehrfachtodesstoß Sounds"
L["[Music]"] = "[Musik]"
L["Payback Scrolling Combat Text"] = "Heimzahlen Scrolling Combat Text"
L["Payback sounds"] = "Payback sounds" -- Requires localization
L["Pet Killing Blows"] = "Pet Killing Blows" -- Requires localization
L["[PVE]"] = "[PVE]"
L["[PVP]"] = "[PVP]"
L["Killing Counter and Sound Queue reset"] = "Tötungszähler und Soundreihenfolge zurücksetzen"
L["Scrolling Combat Text Engine"] = "Scrolling Combat Text Engine"
L["[Sound]"] = "[Sound]"
L["Sound Effects"] = "Soundeffekte"
L["Sound Pack"] = "Soundpaket"
L["Sound Pack language"] = "Soundpaketsprache"
L["[Spanish]"] = "[Spanish]"
L["Scrolling Combat Text and sound test"] = "Scrolling Combat Text and sound test" -- Requires localization
L["[Unreal Tournament 3]"] = "[Unreal Tournament 3]"
 --need localization
L["[PVP and PVE]"] = "[PVP and PVE]"
L["Execute sounds"] = "Execute sounds"
L["Enables or Disables execute sounds"] = "Enables or Disables execute sounds"

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
L["pickedA"] = "aufgenommen"--fix for Ru client
L["returned"] = "returned"
L["stolen"] = "stolen"
L["captured"] = "captured"
L["The Alliance is victorious"] = "The Alliance is victorious"
L["The Horde is victorious"] = "The Horde is victorious"
-- Battleground Events
L["Alliance wins"] = "Die Allianz siegt"
L["Alliance wins secondary"] = "Die Allianz gewinnt"
L["captured"] = "erobert"
L["dropped"] = "fallen lassen"
L["Alliance have captured"] = "Die Allianz hat die Flagge erobert"
L["Horde have captured"] = "Die Horde hat die Flagge erobert"
L["Horde wins"] = "Die Horde siegt"
L["Horde wins secondary"] = "Die Horde gewinnt"
L["returned"] = "zurückgebracht"
L["Alliance Flag has returned"] = "Alliance Flag has returned" -- Requires localization
L["Horde Flag has returned"] = "Horde Flag has returned" -- Requires localization
L["Let the battle for the Strand of the Ancients begin"] = "Lasst die Schlacht um den Strand der Uralten beginnen"
L["The battle for the Strand of the Ancients begins in 1 minute"] = "Die Schlacht um den Strand der Uralten beginnt in 1 Minute"
L["Round 1"] = "Runde 1 - Beendet"
L["Round 2 of the Battle for the Strand of the Ancients begins in 1 minute"] = "Runde 2 der Schlacht um den Strand der Uralten beginnt in 1 Minute"
L["Round 2 begins in 30 seconds"] = "Runde 2 beginnt in 30 Sekunden"
L["vulnerable"] = "Verletzungen"
L["Tie game"] = "Tie game" -- Requires localization
-- Battlefield Events
L["workshop has been attacked by the Alliance"] = "wurde von der Allianz angegriffen"
L["workshop has been captured by the Alliance"] = "wurde von der Allianz erobert"
L["Alliance has defended"] = "Die Allianz verteidigte"
L["workshop has been attacked by the Horde"] = "wurde von der Horde angegriffen"
L["workshop has been captured by the Horde"] = "wurde von der Horde erobert"
L["Horde has defended"] = "Die Horde verteidigte"
end

function PVPSound:Spanish()
L["General"] = "SpaGeneral"
-- Messages
L["Streak1Male"] = "ha derramando la"
L["Streak1Female"] = "ha derramando la"
L["Streak2"] = "está en una"
L["Streak3"] = "está en un"
L["Streak4"] = "está"
L["Streak5"] = "es"
L["Streak6"] = "es"
L["Streak7"] = "está en una"
L["Streak8"] = "está en una"
L["Streak9"] = "está en una"
L["Streak10"] = "está en una"
L["'s"] = "'s"
L["was over by"] = "ha sido terminada por"
L["You got killed by"] = "Te ha matado"
-- Options
L["[Ambience]"] = "[Ambiente]"
L["Battleground sounds"] = "Sonidos del Campo de Batalla"
L["Sound channel output"] = "Salida del Canal de Sonido"
L["[Chat Message]"] = "[Mensaje de chat]"
L["[Disable]"] = "[Desactivado]"
L["[Emote]"] = "[Emociones]"
L["Emote mode"] = "[Modo de Emociones]"
L["Emotes"] = "Emociones"
L["[Enable]"] = "[Activado]"
L["Killing Blow sounds"] = "Sonidos de Asesinato"
L["[Master]"] = "[Principal]"
L["Mode"] = "Modo"
L["Multi Killing sounds"] = "Sonidos de muertes multilpes"
L["[Music]"] = "[Música]"
L["[PVE]"] = "[PVE]"
L["[PVP]"] = "[PVP]"
L["Payback sounds"] = "Sonidos de Retribución"
L["Killing Counter and Sound Queue reset"] = "Reiniciar el Contador de Muertes"
L["[Sound]"] = "[Sonido]"
L["[Unreal Tournament 3]"] = "[Unreal Tournament 3]"
L["[Custom]"] = "[Personalizado]"
L["[Default]"] = "[Por defecto]"
L["[Deutsch]"] = "[Alemán]"
L["[English]"] = "[Inglés]"
L["[Spanish]"] = "[Español]"
L["[France]"] = "[Francia]"
L["[Italian]"] = "[Italiano]"
L["[Russian]"] = "[Ruso]"
L["Kill Sound Engine"] = "Motor de sonidos de muerte"
L["Battleground Sound Engine"] = "Motor de sonido en campos de batalla"
L["Sound Effects"] = "Efectos de sonido"
L["Data Sharing"] = "Compartición de datos"
L["Kill Scrolling Combat Text mode"] = "Modo de SCT de muertes"
L["Scrolling Combat Text frame name"] = "Marco del texto de combate"
L["Scrolling Combat Text Engine"] = "Motor de SCT"
L["Multi Kill Scrolling Combat Text"] = "Multimuerte de SCT"
L["Payback Scrolling Combat Text"] = "Retribución en SCT"
L["Pet Killing Blows"] = "Sonidos de muerte de la mascota"
L["Hide server names"] = "Ocultar nombres de los servidores"
L["Sound Pack"] = "Pack de sonido"
L["Sound Pack language"] = "Lenguaje del pack de sonido"
L["Scrolling Combat Text and sound test"] = "Probando Sonido"
L["Command list"] = "Lista de Comandos"
L["Custom Sound Pack doesn't support that language!"] = "El pack de sonidos personalizado no soporta ese lenguaje!"
L["Enables or Disables Battleground sounds"] = "Activar o Desactivar Sonidos del Campo de Batalla"
L["Enables or Disables Sound Effects"] = "Activa o desactiva los efectos de sonido"
L["Switch between sound channels ('master' 'sound' 'music' 'ambience')"] = "Cambiar Canales de sonido entre ('Principal' 'sonido' 'música' 'ambiente'"
L["Command help"] = "Ayuda de Comando"
L["Enables or Disables Death Messages"] = "Activa o desactiva los mensajes de muertes"
L["Enables or Disables Emotes completely"] = "Activar o Desactivar las emociones Completamente"
L["Switch between Emote and Chat Message mode"] = "Cambiar entre Emoción y modo de mensaje de conversación"
L["Loaded. Type /ps help for options"] = "Activado. Escribe /ps ayuda para opciones."
L["Enables or Disables Killing Blow and Multi Killing sounds"] = "Activar o Desactivar sonidos de Asesinato y muerte múltiple"
L["Switch between PVP and PVE mode"] = "Cambiar entre PVP y PVE"
L["Enables or Disables Multi Killing sounds"] = "Activar o desactivar sonidos de muertes multiples"
L["Enables or Disables Pet Killing Blow sounds"] = "Activa o desactiva sonidos de muerte de la mascota"
L["Enables or Disables Payback Killing sounds"] = "Activa o desactiva los sonidos de retribución"
L["Reset the counter of Killing Blows and the Payback-, Retibution-, Sound-, and SCT Queue System"] = "Reiniciar el contador de asesinatos"
L["Enables or Disables Sound Queue System usage in Killing Sounds"] = "Activa o desactiva el sistema de cola de sonidos de muerte"
L["Enables or Disables Sound Queue System usage in Battleground Sounds"] = "Activa o desactiva la cola de sonidos de SCT en los campos de batalla"
L["Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members"] = "Activa o desactiva la compartición de datos de muertes entre el grupo/banda/campo de batalla"
L["Enables or Disables Kill Scrolling Combat Text usage"] = "Activa o desactiva las muertes en el texto de combate"
L["Name of the output frame in the supported Scrolling Combat Text"] = "Nombre de la letra en el texto de combate"
L["Enables or Disables Scrolling Combat Text Queue System usage"] = "Activa o desactiva el uso de SCT"
L["Enables or Disables Multi Kill Scrolling Combat Text usage"] = "Activa o desactiva el uso de multimuertes en el texto de combate de SCT"
L["Enables or Disables Payback and Retribution Scrolling Combat Text usage"] = "Activa o desactiva el uso de retribución en el texto de combate"
L["Enables or Disables hiding the player's server name from Data Sharing and Death Messages"] = "Activa o desactiva el reino de los jugadores en la compartición de datos"
L["Switch between Sound Packs ('ut3' 'custom')"] = "Cambia entre los packs de sonido('ut3' 'custom')"
L["Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')"] = "Cambia entre el idioma de los packs de sonido ('deu' 'eng' 'esn' 'fra' 'ita')"
L["Show status"] = "Mostrar estado"
L["Scrolling Combat Text and sound test"] = "Prueba de sonido"
L["Killing Count"] = "Conteo de muertes"
L["Death messages"] = "Mensajes de muertes"

 --need localization
L["[PVP and PVE]"] = "[PVP and PVE]"
L["Execute sounds"] = "Execute sounds"
L["Enables or Disables execute sounds"] = "Enables or Disables execute sounds"
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
L["pickedA"] = "recogida" --fix for Ru client
L["returned"] = "returned"
L["stolen"] = "stolen"
L["captured"] = "captured"
L["The Alliance is victorious"] = "The Alliance is victorious"
L["The Horde is victorious"] = "The Horde is victorious"
-- Battleground Events
L["Alliance wins"] = "La Alianza gana"
L["Alliance wins secondary"] = "La Alianza gana"
L["Alliance have captured"] = "La Alianza ha capturado la bandera"
L["Horde have captured"] = "La Horda ha capturado la bandera"
L["captured"] = "capturada"
L["dropped"] = "arrojada"
L["Horde wins"] = "La Horda gana"
L["Horde wins secondary"] = "La Horda gana"
L["returned"] = "regresada"
L["Alliance Flag has returned"] = "La bandera de la alianza ha sido devuelta"
L["Horde Flag has returned"] = "La bandera de la horda ha sido devuelta"
L["Let the battle for the Strand of the Ancients begin"] = "Que empiece la batalla por la playa de los ancestros"
L["The battle for the Strand of the Ancients begins in 1 minute"] = "La batalla por la Playa de los Ancestros comienza en 1 minuto"
L["Round 1"] = "La primera ronda ha acabado"
L["Round 2 of the Battle for the Strand of the Ancients begins in 1 minute"] = "Ronda 2 de la Batalla por la Playa de los Ancestros comienza en 1 minuto"
L["Round 2 begins in 30 seconds"] = "La segunda ronda de la Batalla por la Playa de los Ancestros comienza en 30 segundos"
L["vulnerable"] = "vulnerables"
L["Tie game"] = "empate"
-- Battlefield Events
L["workshop has been attacked by the Alliance"] = "El Taller ha sido atacado por la alianza"
L["workshop has been captured by the Alliance"] = "El Taller ha sido capturado por la alianza"
L["Alliance has defended"] = "La Allianza ha defendido"
L["workshop has been attacked by the Horde"] = "El Taller ha sido atacado por la horda"
L["workshop has been captured by the Horde"] = "El Taller ha sido capturado por la horda"
L["Horde has defended"] = "La horda ha defendido"
end

function PVPSound:LatinAmericanSpanish()
L["General"] = "LaSpaGeneral"
-- Messages
L["Streak1Male"] = "ha derramando la"
L["Streak1Female"] = "ha derramando la"
L["Streak2"] = "está en una"
L["Streak3"] = "está en un"
L["Streak4"] = "está"
L["Streak5"] = "es"
L["Streak6"] = "es"
L["Streak7"] = "está en una"
L["Streak8"] = "está en una"
L["Streak9"] = "está en una"
L["Streak10"] = "está en una"
L["'s"] = "'s"
L["was over by"] = "ha sido terminada por"
L["You got killed by"] = "Te ha matado"
-- Options
L["[Ambience]"] = "[Ambiente]"
L["Battleground sounds"] = "Sonidos del Campo de Batalla"
L["Sound channel output"] = "Salida del Canal de Sonido"
L["[Chat Message]"] = "[Mensaje de chat]"
L["[Disable]"] = "[Desactivado]"
L["[Emote]"] = "[Emociones]"
L["Emote mode"] = "[Modo de Emociones]"
L["Emotes"] = "Emociones"
L["[Enable]"] = "[Activado]"
L["Killing Blow sounds"] = "Sonidos de Asesinato"
L["[Master]"] = "[Principal]"
L["Mode"] = "Modo"
L["Multi Killing sounds"] = "Sonidos de muertes multilpes"
L["[Music]"] = "[Música]"
L["[PVE]"] = "[PVE]"
L["[PVP]"] = "[PVP]"
L["Payback sounds"] = "Sonidos de Retribución"
L["Killing Counter and Sound Queue reset"] = "Reiniciar el Contador de Muertes"
L["[Sound]"] = "[Sonido]"
L["[Unreal Tournament 3]"] = "[Unreal Tournament 3]"
L["[Custom]"] = "[Personalizado]"
L["[Default]"] = "[Por defecto]"
L["[Deutsch]"] = "[Alemán]"
L["[English]"] = "[Inglés]"
L["[Spanish]"] = "[Español]"
L["[France]"] = "[Francia]"
L["[Italian]"] = "[Italiano]"
L["[Russian]"] = "[Ruso]"
L["Kill Sound Engine"] = "Motor de sonidos de muerte"
L["Battleground Sound Engine"] = "Motor de sonido en campos de batalla"
L["Sound Effects"] = "Efectos de sonido"
L["Data Sharing"] = "Compartición de datos"
L["Kill Scrolling Combat Text mode"] = "Modo de SCT de muertes"
L["Scrolling Combat Text frame name"] = "Marco del texto de combate"
L["Scrolling Combat Text Engine"] = "Motor de SCT"
L["Multi Kill Scrolling Combat Text"] = "Multimuerte de SCT"
L["Payback Scrolling Combat Text"] = "Retribución en SCT"
L["Pet Killing Blows"] = "Sonidos de muerte de la mascota"
L["Hide server names"] = "Ocultar nombres de los servidores"
L["Sound Pack"] = "Pack de sonido"
L["Sound Pack language"] = "Lenguaje del pack de sonido"
L["Scrolling Combat Text and sound test"] = "Probando Sonido"
L["Command list"] = "Lista de Comandos"
L["Custom Sound Pack doesn't support that language!"] = "¡El pack de sonidos personalizado no soporta ese lenguaje!"
L["Enables or Disables Battleground sounds"] = "Activar o Desactivar Sonidos del Campo de Batalla"
L["Enables or Disables Sound Effects"] = "Activa o desactiva los efectos de sonido"
L["Switch between sound channels ('master' 'sound' 'music' 'ambience')"] = "Cambiar Canales de sonido entre ('Principal' 'sonido' 'música' 'ambiente'"
L["Command help"] = "Ayuda de Comando"
L["Enables or Disables Death Messages"] = "Activa o desactiva los mensajes de muertes"
L["Enables or Disables Emotes completely"] = "Activar o Desactivar las emociones Completamente"
L["Switch between Emote and Chat Message mode"] = "Cambiar entre Emoción y modo de mensaje de conversación"
L["Loaded. Type /ps help for options"] = "Activado. Escribe /ps ayuda para opciones."
L["Enables or Disables Killing Blow and Multi Killing sounds"] = "Activar o Desactivar sonidos de Asesinato y muerte múltiple"
L["Switch between PVP and PVE mode"] = "Cambiar entre PVP y PVE"
L["Enables or Disables Multi Killing sounds"] = "Activar o desactivar sonidos de muertes multiples"
L["Enables or Disables Pet Killing Blow sounds"] = "Activa o desactiva sonidos de muerte de la mascota"
L["Enables or Disables Payback Killing sounds"] = "Activa o desactiva los sonidos de retribución"
L["Reset the counter of Killing Blows and the Payback-, Retibution-, Sound-, and SCT Queue System"] = "Reiniciar el contador de asesinatos"
L["Enables or Disables Sound Queue System usage in Killing Sounds"] = "Activa o desactiva el sistema de cola de sonidos de muerte"
L["Enables or Disables Sound Queue System usage in Battleground Sounds"] = "Activa o desactiva la cola de sonidos de SCT en los campos de batalla"
L["Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members"] = "Activa o desactiva la compartición de datos de muertes entre el grupo/banda/campo de batalla"
L["Enables or Disables Kill Scrolling Combat Text usage"] = "Activa o desactiva las muertes en el texto de combate"
L["Name of the output frame in the supported Scrolling Combat Text"] = "Nombre de la letra en el texto de combate"
L["Enables or Disables Scrolling Combat Text Queue System usage"] = "Activa o desactiva el uso de SCT"
L["Enables or Disables Multi Kill Scrolling Combat Text usage"] = "Activa o desactiva el uso de multimuertes en el texto de combate de SCT"
L["Enables or Disables Payback and Retribution Scrolling Combat Text usage"] = "Activa o desactiva el uso de retribución en el texto de combate"
L["Enables or Disables hiding the player's server name from Data Sharing and Death Messages"] = "Activa o desactiva el reino de los jugadores en la compartición de datos"
L["Switch between Sound Packs ('ut3' 'custom')"] = "Cambia entre los packs de sonido('ut3' 'custom')"
L["Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')"] = "Cambia entre el idioma de los packs de sonido ('deu' 'eng' 'esn' 'fra' 'ita')"
L["Show status"] = "Mostrar estado"
L["Scrolling Combat Text and sound test"] = "Prueba de sonido"
L["Killing Count"] = "Conteo de muertes"
L["Death messages"] = "Mensajes de muertes"

 --need localization
L["[PVP and PVE]"] = "[PVP and PVE]"
L["Execute sounds"] = "Execute sounds"
L["Enables or Disables execute sounds"] = "Enables or Disables execute sounds"
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
L["pickedA"] = "recogida" --fix for Ru client
L["returned"] = "returned"
L["stolen"] = "stolen"
L["captured"] = "captured"
L["The Alliance is victorious"] = "The Alliance is victorious"
L["The Horde is victorious"] = "The Horde is victorious"
-- Battleground Events
L["Alliance wins"] = "La Alianza gana"
L["Alliance wins secondary"] = "La Alianza gana"
L["Alliance have captured"] = "La Alianza ha capturado la bandera"
L["Horde have captured"] = "La Horda ha capturado la bandera"
L["captured"] = "capturada"
L["dropped"] = "arrojada"
L["Horde wins"] = "La Horda gana"
L["Horde wins secondary"] = "La Horda gana"
L["returned"] = "regresada"
L["Alliance Flag has returned"] = "La bandera de la alianza ha sido devuelta"
L["Horde Flag has returned"] = "La bandera de la horda ha sido devuelta"
L["Let the battle for the Strand of the Ancients begin"] = "Que empiece la batalla por la playa de los ancestros"
L["The battle for the Strand of the Ancients begins in 1 minute"] = "La batalla por la Playa de los Ancestros comienza en 1 minuto"
L["Round 1"] = "La primera ronda ha acabado"
L["Round 2 of the Battle for the Strand of the Ancients begins in 1 minute"] = "Ronda 2 de la Batalla por la Playa de los Ancestros comienza en 1 minuto"
L["Round 2 begins in 30 seconds"] = "La segunda ronda de la Batalla por la Playa de los Ancestros comienza en 30 segundos"
L["vulnerable"] = "vulnerables"
L["Tie game"] = "empate"
-- Battlefield Events
L["workshop has been attacked by the Alliance"] = "El Taller ha sido atacado por la alianza"
L["workshop has been captured by the Alliance"] = "El Taller ha sido capturado por la alianza"
L["Alliance has defended"] = "La Allianza ha defendido"
L["workshop has been attacked by the Horde"] = "El Taller ha sido atacado por la horda"
L["workshop has been captured by the Horde"] = "El Taller ha sido capturado por la horda"
L["Horde has defended"] = "La horda ha defendido"
end

function PVPSound:French()
L["General"] = "FraGeneral"
-- Messages
L["Streak1Male"] = "a versé le"
L["Streak1Female"] = "a versé le"
L["Streak2"] = "fait une"
L["Streak3"] = "se"
L["Streak4"] = "est"
L["Streak5"] = "est"
L["Streak6"] = "est"
L["Streak7"] = "fait un"
L["Streak8"] = "fait un"
L["Streak9"] = "fait un"
L["Streak10"] = "fait un"
L["'s"] = "'s" -- Requires localization
L["was over by"] = "was over by" -- Requires localization
L["You got killed by"] = "Vous avez été tué par"
-- Options
L["[Ambience]"] = "[Ambiance]"
L["Battleground sounds"] = "Son du champ de bataille"
L["Sound channel output"] = "Canal de sortie son"
L["[Chat Message]"] = "[Chat Message]"
L["[Disable]"] = "[désactivé]"
L["[Emote]"] = "[Emote]"
L["Emote mode"] = "Mode emote"
L["Emotes"] = "Emotes"
L["[Enable]"] = "[Activé]"
L["Killing Blow sounds"] = "Sons du Killing Blow"
L["[Master]"] = "[Maitre]"
L["Mode"] = "Mode"
L["Multi Killing sounds"] = "Son des morts multiples"
L["[Music]"] = "[Musique]"
L["[PVE]"] = "[PVE]"
L["[PVP]"] = "[PVP]"
L["Payback sounds"] = "Sons Payback "
L["Killing Counter and Sound Queue reset"] = "Décompte mort et queue sons reset"
L["[Sound]"] = "[Son]"
L["[Unreal Tournament 3]"] = "[Unreal Tournament 3]" -- Requires localization
L["[Custom]"] = "[Custom]" -- Requires localization
L["[Default]"] = "[Default]" -- Requires localization
L["[Deutsch]"] = "[Deutsch]" -- Requires localization
L["[English]"] = "[English]" -- Requires localization
L["[Spanish]"] = "[Spanish]" -- Requires localization
L["[France]"] = "[France]" -- Requires localization
L["[Italian]"] = "[Italian]" -- Requires localization
L["[Russian]"] = "[Russian]" -- Requires localization
L["Kill Sound Engine"] = "Kill Sound Engine" -- Requires localization
L["Battleground Sound Engine"] = "Battleground Sound Engine" -- Requires localization
L["Sound Effects"] = "Sound Effects" -- Requires localization
L["Data Sharing"] = "Data Sharing" -- Requires localization
L["Kill Scrolling Combat Text mode"] = "Kill Scrolling Combat Text mode" -- Requires localization
L["Scrolling Combat Text frame name"] = "Scrolling Combat Text frame name" -- Requires localization
L["Scrolling Combat Text Engine"] = "Scrolling Combat Text Engine" -- Requires localization
L["Multi Kill Scrolling Combat Text"] = "Multi Kill Scrolling Combat Text" -- Requires localization
L["Payback Scrolling Combat Text"] = "Payback Scrolling Combat Text" -- Requires localization
L["Pet Killing Blows"] = "Pet Killing Blows" -- Requires localization
L["Hide server names"] = "Hide server names" -- Requires localization
L["Sound Pack"] = "Sound Pack" -- Requires localization
L["Sound Pack language"] = "Sound Pack language" -- Requires localization
L["Scrolling Combat Text and sound test"] = "Tester les sons"
L["Command list"] = "Liste de commandes"
L["Custom Sound Pack doesn't support that language!"] = "Custom Sound Pack doesn't support that language!" -- Requires localization
L["Enables or Disables Battleground sounds"] = "Activer ou désactiver les sons de champ de bataille"
L["Enables or Disables Sound Effects"] = "Enables or Disables Sound Effects" -- Requires localization
L["Switch between sound channels ('master' 'sound' 'music' 'ambience')"] = "Switch entre le canaux de sons ('master' 'son' 'musique' 'ambiance')"
L["Command help"] = "Commande d'aide"
L["Enables or Disables Death Messages"] = "Activer ou désactiver les messages de morts dans les champs de batailles"
L["Enables or Disables Emotes completely"] = "Activer ou désactiver les emotes completement"
L["Switch between Emote and Chat Message mode"] = "Switch entre le mode emote ou Chat messages"
L["Loaded. Type /ps help for options"] = "Activer. Taper /ps help pour les options"
L["Enables or Disables Killing Blow and Multi Killing sounds"] = "Activer ou désactiver les sons Killing Blow et Multi Killing"
L["Switch between PVP and PVE mode"] = "Switch entre le mode PVP et PVE"
L["Enables or Disables Multi Killing sounds"] = "Activer ou désactiver les son des morts multiples"
L["Enables or Disables Pet Killing Blow sounds"] = "Enables or Disables Pet Killing Blow sounds" -- Requires localization
L["Enables or Disables Payback Killing sounds"] = "Activer ou désactiver les sons des morts Payback"
L["Reset the counter of Killing Blows and the Payback-, Retibution-, Sound-, and SCT Queue System"] = "Mise a zéro du décompte des Killing Blows et les son dans la liste d'attente"
L["Enables or Disables Sound Queue System usage in Killing Sounds"] = "Enables or Disables Sound Queue System usage in Killing Sounds" -- Requires localization
L["Enables or Disables Sound Queue System usage in Battleground Sounds"] = "Enables or Disables Sound Queue System usage in Battleground Sounds" -- Requires localization
L["Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members"] = "Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members" -- Requires localization
L["Enables or Disables Kill Scrolling Combat Text usage"] = "Enables or Disables Kill Scrolling Combat Text usage" -- Requires localization
L["Name of the output frame in the supported Scrolling Combat Text"] = "Name of the output frame in the supported Scrolling Combat Text" -- Requires localization
L["Enables or Disables Scrolling Combat Text Queue System usage"] = "Enables or Disables Scrolling Combat Text Queue System usage" -- Requires localization
L["Enables or Disables Multi Kill Scrolling Combat Text usage"] = "Enables or Disables Multi Kill Scrolling Combat Text usage" -- Requires localization
L["Enables or Disables Payback and Retribution Scrolling Combat Text usage"] = "Enables or Disables Payback and Retribution Scrolling Combat Text usage" -- Requires localization
L["Enables or Disables hiding the player's server name from Data Sharing and Death Messages"] = "Enables or Disables hiding the player's server name from Data Sharing and Death Messages" -- Requires localization
L["Switch between Sound Packs ('ut3' 'custom')"] = "Switch between Sound Packs ('ut3' 'custom')" -- Requires localization
L["Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')"] = "Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')" -- Requires localization
L["Show status"] = "Montrer les status"
L["Scrolling Combat Text and sound test"] = "Tester le son"
L["Killing Count"] = "Décompte des morts"
L["Death messages"] = "Messages de morts"

 --need localization
L["[PVP and PVE]"] = "[PVP and PVE]"
L["Execute sounds"] = "Execute sounds"
L["Enables or Disables execute sounds"] = "Enables or Disables execute sounds"
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
L["pickedA"] = "pris" --fix for Ru client
L["returned"] = "returned"
L["stolen"] = "stolen"
L["captured"] = "captured"
L["The Alliance is victorious"] = "The Alliance is victorious"
L["The Horde is victorious"] = "The Horde is victorious"
-- Battleground Events
L["Alliance wins"] = "L' Alliance gagne"
L["Alliance wins secondary"] = "L' Alliance gagne"
L["captured"] = "capturé"
L["dropped"] = "chuté"
L["Alliance have captured"] = "L'Alliance a capturé"
L["Horde have captured"] = "La Horde a capturé"
L["Horde wins"] = "La Horde gagne"
L["Horde wins secondary"] = "La Horde gagne"
L["returned"] = "retourné"
L["Alliance Flag has returned"] = "Alliance Flag has returned" -- Requires localization
L["Horde Flag has returned"] = "Horde Flag has returned" -- Requires localization
L["Let the battle for the Strand of the Ancients begin"] = "Que la bataille pour le Rivage des Anciens commence"
L["The battle for the Strand of the Ancients begins in 1 minute"] = "La bataille pour le Rivage des Anciens commence dans 1 minute"
L["Round 1"] = "Round 1"
L["Round 2 of the Battle for the Strand of the Ancients begins in 1 minute"] = "Le round 2 de la bataille pour le Rivage des Anciens commence dans 1 minute"
L["Round 2 begins in 30 seconds"] = "Round 2 commence dans 30 secondes"
L["vulnerable"] = "vulnérable"
L["Tie game"] = "Tie game" -- Requires localization
-- Battlefield Events
L["workshop has been attacked by the Alliance"] = "L'atelier a été attaqué par l'Alliance"
L["workshop has been captured by the Alliance"] = "L'atelier a été capturé par l'Alliance"
L["Alliance has defended"] = "L’Alliance a défendu"
L["workshop has been attacked by the Horde"] = "L'atelier a été attaqué par la Horde"
L["workshop has been captured by the Horde"] = "L'atelier a été capturé par la Horde"
L["Horde has defended"] = "La Horde a défendu"
end

function PVPSound:Italian()
L["General"] = "ItaGeneral"
-- Messages
L["Streak1Male"] = "ha"
L["Streak1Female"] = "ha"
L["Streak2"] = "ha un"
L["Streak3"] = "č"
L["Streak4"] = "sta"
L["Streak5"] = "č"
L["Streak6"] = "č"
L["Streak7"] = "ta facendo un"
L["Streak8"] = "ta facendo un"
L["Streak9"] = "ta facendo un"
L["Streak10"] = "ta facendo un"
L["'s"] = "'s" -- Requires localization
L["was over by"] = "was over by" -- Requires localization
L["You got killed by"] = "Sei stato ucciso da"
-- Options
L["[Ambience]"] = "[Ambience]" -- Requires localization
L["Battleground sounds"] = "Battleground sounds" -- Requires localization
L["Sound channel output"] = "Sound channel output" -- Requires localization
L["[Chat Message]"] = "[Chat Message]" -- Requires localization
L["[Disable]"] = "[Disable]" -- Requires localization
L["[Emote]"] = "[Emote]" -- Requires localization
L["Emote mode"] = "Emote mode" -- Requires localization
L["Emotes"] = "Emotes" -- Requires localization
L["[Enable]"] = "[Enable]" -- Requires localization
L["Killing Blow sounds"] = "Killing Blow sounds" -- Requires localization
L["[Master]"] = "[Master]" -- Requires localization
L["Mode"] = "Mode" -- Requires localization
L["Multi Killing sounds"] = "Multi Killing sounds" -- Requires localization
L["[Music]"] = "[Music]" -- Requires localization
L["[PVE]"] = "[PVE]" -- Requires localization
L["[PVP]"] = "[PVP]" -- Requires localization
L["Payback sounds"] = "Payback sounds" -- Requires localization
L["Killing Counter and Sound Queue reset"] = "Killing Counter and Sound Queue reset" -- Requires localization
L["[Sound]"] = "[Sound]" -- Requires localization
L["[Unreal Tournament 3]"] = "[Unreal Tournament 3]" -- Requires localization
L["[Custom]"] = "[Custom]" -- Requires localization
L["[Default]"] = "[Default]" -- Requires localization
L["[Deutsch]"] = "[Deutsch]" -- Requires localization
L["[English]"] = "[English]" -- Requires localization
L["[Spanish]"] = "[Spanish]" -- Requires localization
L["[France]"] = "[France]" -- Requires localization
L["[Italian]"] = "[Italian]" -- Requires localization
L["[Russian]"] = "[Russian]" -- Requires localization
L["Kill Sound Engine"] = "Kill Sound Engine" -- Requires localization
L["Battleground Sound Engine"] = "Battleground Sound Engine" -- Requires localization
L["Sound Effects"] = "Sound Effects" -- Requires localization
L["Data Sharing"] = "Data Sharing" -- Requires localization
L["Kill Scrolling Combat Text mode"] = "Kill Scrolling Combat Text mode" -- Requires localization
L["Scrolling Combat Text frame name"] = "Scrolling Combat Text frame name" -- Requires localization
L["Scrolling Combat Text Engine"] = "Scrolling Combat Text Engine" -- Requires localization
L["Multi Kill Scrolling Combat Text"] = "Multi Kill Scrolling Combat Text" -- Requires localization
L["Payback Scrolling Combat Text"] = "Payback Scrolling Combat Text" -- Requires localization
L["Pet Killing Blows"] = "Pet Killing Blows" -- Requires localization
L["Hide server names"] = "Hide server names" -- Requires localization
L["Sound Pack"] = "Sound Pack" -- Requires localization
L["Sound Pack language"] = "Sound Pack language" -- Requires localization
L["Scrolling Combat Text and sound test"] = "Testing sound" -- Requires localization
L["Command list"] = "Command list" -- Requires localization
L["Custom Sound Pack doesn't support that language!"] = "Custom Sound Pack doesn't support that language!" -- Requires localization
L["Enables or Disables Battleground sounds"] = "Enables or Disables Battleground sounds" -- Requires localization
L["Enables or Disables Sound Effects"] = "Enables or Disables Sound Effects" -- Requires localization
L["Switch between sound channels ('master' 'sound' 'music' 'ambience')"] = "Switch between sound channels ('master' 'sound' 'music' 'ambience')" -- Requires localization
L["Command help"] = "Command help" -- Requires localization
L["Enables or Disables Death Messages"] = "Enables or Disables Death Messages in Battlegrounds" -- Requires localization
L["Enables or Disables Emotes completely"] = "Enables or Disables Emotes completely" -- Requires localization
L["Switch between Emote and Chat Message mode"] = "Switch between Emote and Chat Message mode" -- Requires localization
L["Loaded. Type /ps help for options"] = "Enabled. Type /ps help for options" -- Requires localization
L["Enables or Disables Killing Blow and Multi Killing sounds"] = "Enables or Disables Killing Blow and Multi Killing sounds" -- Requires localization
L["Switch between PVP and PVE mode"] = "Switch between PVP and PVE mode" -- Requires localization
L["Enables or Disables Multi Killing sounds"] = "Enables or Disables Multi Killing sounds" -- Requires localization
L["Enables or Disables Pet Killing Blow sounds"] = "Enables or Disables Pet Killing Blow sounds" -- Requires localization
L["Enables or Disables Payback Killing sounds"] = "Enables or Disables Payback Killing sounds" -- Requires localization
L["Reset the counter of Killing Blows and the Payback-, Retibution-, Sound-, and SCT Queue System"] = "Reset the counter of Killing Blows and the Payback- and Sound Queue System" -- Requires localization
L["Enables or Disables Sound Queue System usage in Killing Sounds"] = "Enables or Disables Sound Queue System usage in Killing Sounds" -- Requires localization
L["Enables or Disables Sound Queue System usage in Battleground Sounds"] = "Enables or Disables Sound Queue System usage in Battleground Sounds" -- Requires localization
L["Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members"] = "Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members" -- Requires localization
L["Enables or Disables Kill Scrolling Combat Text usage"] = "Enables or Disables Kill Scrolling Combat Text usage" -- Requires localization
L["Name of the output frame in the supported Scrolling Combat Text"] = "Name of the output frame in the supported Scrolling Combat Text" -- Requires localization
L["Enables or Disables Scrolling Combat Text Queue System usage"] = "Enables or Disables Scrolling Combat Text Queue System usage" -- Requires localization
L["Enables or Disables Multi Kill Scrolling Combat Text usage"] = "Enables or Disables Multi Kill Scrolling Combat Text usage" -- Requires localization
L["Enables or Disables Payback and Retribution Scrolling Combat Text usage"] = "Enables or Disables Payback and Retribution Scrolling Combat Text usage" -- Requires localization
L["Enables or Disables hiding the player's server name from Data Sharing and Death Messages"] = "Enables or Disables hiding the player's server name from Data Sharing and Death Messages" -- Requires localization
L["Switch between Sound Packs ('ut3' 'custom')"] = "Switch between Sound Packs ('ut3' 'custom')" -- Requires localization
L["Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')"] = "Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')" -- Requires localization
L["Show status"] = "Show status" -- Requires localization
L["Scrolling Combat Text and sound test"] = "Sound test" -- Requires localization
L["Killing Count"] = "Killing Count" -- Requires localization
L["Death messages"] = "Death messages" -- Requires localization
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
L["pickedA"] = "picked" --fix for Ru client
L["returned"] = "returned" -- Requires localization
L["stolen"] = "stolen" -- Requires localization
L["captured"] = "captured"
L["The Alliance is victorious"] = "The Alliance is victorious" -- Requires localization
L["The Horde is victorious"] = "The Horde is victorious" -- Requires localization
-- Battleground Events
L["Alliance wins"] = "Alliance wins" -- Requires localization
L["Alliance wins secondary"] = "Alliance wins" -- Requires localization
L["Alliance have captured"] = "Alliance have captured" -- Requires localization
L["Horde have captured"] = "Horde have captured" -- Requires localization
L["captured"] = "captured" -- Requires localization
L["dropped"] = "dropped" -- Requires localization
L["Horde wins"] = "Horde wins" -- Requires localization
L["Horde wins secondary"] = "Horde wins" -- Requires localization
L["returned"] = "returned" -- Requires localization
L["Alliance Flag has returned"] = "Alliance Flag has returned" -- Requires localization
L["Horde Flag has returned"] = "Horde Flag has returned" -- Requires localization
L["Let the battle for the Strand of the Ancients begin"] = "Let the battle for the Strand of the Ancients begin" -- Requires localization
L["The battle for the Strand of the Ancients begins in 1 minute"] = "The battle for the Strand of the Ancients begins in 1 minute" -- Requires localization
L["Round 1"] = "Round 1" -- Requires localization
L["Round 2 of the Battle for the Strand of the Ancients begins in 1 minute"] = "Round 2 of the Battle for the Strand of the Ancients begins in 1 minute" -- Requires localization
L["Round 2 begins in 30 seconds"] = "Round 2 begins in 30 seconds" -- Requires localization
L["vulnerable"] = "vulnerable" -- Requires localization
L["Tie game"] = "Tie game" -- Requires localization
-- Battlefield Events
L["workshop has been attacked by the Alliance"] = "workshop has been attacked by the Alliance" -- Requires localization
L["workshop has been captured by the Alliance"] = "workshop has been captured by the Alliance" -- Requires localization
L["Alliance has defended"] = "Alliance has defended" -- Requires localization
L["workshop has been attacked by the Horde"] = "workshop has been attacked by the Horde" -- Requires localization
L["workshop has been captured by the Horde"] = "workshop has been captured by the Horde" -- Requires localization
L["Horde has defended"] = "Horde has defended" -- Requires localization

 --need localization
L["[PVP and PVE]"] = "[PVP and PVE]"
L["Execute sounds"] = "Execute sounds"
L["Enables or Disables execute sounds"] = "Enables or Disables execute sounds"
end

function PVPSound:Korean()
L["General"] = "KorGeneral"
-- Messages
L["Streak1Male"] = "just drew his" -- Requires localization
L["Streak1Female"] = "just drew her" -- Requires localization
L["Streak2"] = "is on" -- Requires localization
L["Streak3"] = "is on" -- Requires localization
L["Streak4"] = "is" -- Requires localization
L["Streak5"] = "is" -- Requires localization
L["Streak6"] = "is" -- Requires localization
L["Streak7"] = "committed a" -- Requires localization
L["Streak8"] = "committed a" -- Requires localization
L["Streak9"] = "committed a" -- Requires localization
L["Streak10"] = "committed a" -- Requires localization
L["'s"] = "'s" -- Requires localization
L["was over by"] = "was over by" -- Requires localization
L["You got killed by"] = "You got killed by" -- Requires localization
-- Options
L["[Ambience]"] = "[Ambience]" -- Requires localization
L["Battleground sounds"] = "Battleground sounds" -- Requires localization
L["Sound channel output"] = "Sound channel output" -- Requires localization
L["[Chat Message]"] = "[Chat Message]" -- Requires localization
L["[Disable]"] = "[Disable]" -- Requires localization
L["[Emote]"] = "[Emote]" -- Requires localization
L["Emote mode"] = "Emote mode" -- Requires localization
L["Emotes"] = "Emotes" -- Requires localization
L["[Enable]"] = "[Enable]" -- Requires localization
L["Killing Blow sounds"] = "Killing Blow sounds" -- Requires localization
L["[Master]"] = "[Master]" -- Requires localization
L["Mode"] = "Mode" -- Requires localization
L["Multi Killing sounds"] = "Multi Killing sounds" -- Requires localization
L["[Music]"] = "[Music]" -- Requires localization
L["[PVE]"] = "[PVE]" -- Requires localization
L["[PVP]"] = "[PVP]" -- Requires localization
L["Payback sounds"] = "Payback sounds" -- Requires localization
L["Killing Counter and Sound Queue reset"] = "Killing Counter and Sound Queue reset" -- Requires localization
L["[Sound]"] = "[Sound]" -- Requires localization
L["[Unreal Tournament 3]"] = "[Unreal Tournament 3]" -- Requires localization
L["[Custom]"] = "[Custom]" -- Requires localization
L["[Default]"] = "[Default]" -- Requires localization
L["[Deutsch]"] = "[Deutsch]" -- Requires localization
L["[English]"] = "[English]" -- Requires localization
L["[Spanish]"] = "[Spanish]" -- Requires localization
L["[France]"] = "[France]" -- Requires localization
L["[Italian]"] = "[Italian]" -- Requires localization
L["[Russian]"] = "[Russian]" -- Requires localization
L["Kill Sound Engine"] = "Kill Sound Engine" -- Requires localization
L["Battleground Sound Engine"] = "Battleground Sound Engine" -- Requires localization
L["Sound Effects"] = "Sound Effects" -- Requires localization
L["Data Sharing"] = "Data Sharing" -- Requires localization
L["Kill Scrolling Combat Text mode"] = "Kill Scrolling Combat Text mode" -- Requires localization
L["Scrolling Combat Text frame name"] = "Scrolling Combat Text frame name" -- Requires localization
L["Scrolling Combat Text Engine"] = "Scrolling Combat Text Engine" -- Requires localization
L["Multi Kill Scrolling Combat Text"] = "Multi Kill Scrolling Combat Text" -- Requires localization
L["Payback Scrolling Combat Text"] = "Payback Scrolling Combat Text" -- Requires localization
L["Pet Killing Blows"] = "Pet Killing Blows" -- Requires localization
L["Hide server names"] = "Hide server names" -- Requires localization
L["Sound Pack"] = "Sound Pack" -- Requires localization
L["Sound Pack language"] = "Sound Pack language" -- Requires localization
L["Scrolling Combat Text and sound test"] = "Testing sound" -- Requires localization
L["Command list"] = "Command list" -- Requires localization
L["Custom Sound Pack doesn't support that language!"] = "Custom Sound Pack doesn't support that language!" -- Requires localization
L["Enables or Disables Battleground sounds"] = "Enables or Disables Battleground sounds" -- Requires localization
L["Enables or Disables Sound Effects"] = "Enables or Disables Sound Effects" -- Requires localization
L["Switch between sound channels ('master' 'sound' 'music' 'ambience')"] = "Switch between sound channels ('master' 'sound' 'music' 'ambience')" -- Requires localization
L["Command help"] = "Command help" -- Requires localization
L["Enables or Disables Death Messages"] = "Enables or Disables Death Messages in Battlegrounds" -- Requires localization
L["Enables or Disables Emotes completely"] = "Enables or Disables Emotes completely" -- Requires localization
L["Switch between Emote and Chat Message mode"] = "Switch between Emote and Chat Message mode" -- Requires localization
L["Loaded. Type /ps help for options"] = "Enabled. Type /ps help for options" -- Requires localization
L["Enables or Disables Killing Blow and Multi Killing sounds"] = "Enables or Disables Killing Blow and Multi Killing sounds" -- Requires localization
L["Switch between PVP and PVE mode"] = "Switch between PVP and PVE mode" -- Requires localization
L["Enables or Disables Multi Killing sounds"] = "Enables or Disables Multi Killing sounds" -- Requires localization
L["Enables or Disables Pet Killing Blow sounds"] = "Enables or Disables Pet Killing Blow sounds" -- Requires localization
L["Enables or Disables Payback Killing sounds"] = "Enables or Disables Payback Killing sounds" -- Requires localization
L["Reset the counter of Killing Blows and the Payback-, Retibution-, Sound-, and SCT Queue System"] = "Reset the counter of Killing Blows and the Payback- and Sound Queue System" -- Requires localization
L["Enables or Disables Sound Queue System usage in Killing Sounds"] = "Enables or Disables Sound Queue System usage in Killing Sounds" -- Requires localization
L["Enables or Disables Sound Queue System usage in Battleground Sounds"] = "Enables or Disables Sound Queue System usage in Battleground Sounds" -- Requires localization
L["Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members"] = "Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members" -- Requires localization
L["Enables or Disables Kill Scrolling Combat Text usage"] = "Enables or Disables Kill Scrolling Combat Text usage" -- Requires localization
L["Name of the output frame in the supported Scrolling Combat Text"] = "Name of the output frame in the supported Scrolling Combat Text" -- Requires localization
L["Enables or Disables Scrolling Combat Text Queue System usage"] = "Enables or Disables Scrolling Combat Text Queue System usage" -- Requires localization
L["Enables or Disables Multi Kill Scrolling Combat Text usage"] = "Enables or Disables Multi Kill Scrolling Combat Text usage" -- Requires localization
L["Enables or Disables Payback and Retribution Scrolling Combat Text usage"] = "Enables or Disables Payback and Retribution Scrolling Combat Text usage" -- Requires localization
L["Enables or Disables hiding the player's server name from Data Sharing and Death Messages"] = "Enables or Disables hiding the player's server name from Data Sharing and Death Messages" -- Requires localization
L["Switch between Sound Packs ('ut3' 'custom')"] = "Switch between Sound Packs ('ut3' 'custom')" -- Requires localization
L["Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')"] = "Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')" -- Requires localization
L["Show status"] = "Show status" -- Requires localization
L["Scrolling Combat Text and sound test"] = "Sound test" -- Requires localization
L["Killing Count"] = "Killing Count" -- Requires localization
L["Death messages"] = "Death messages" -- Requires localization

 --need localization
L["[PVP and PVE]"] = "[PVP and PVE]"
L["Execute sounds"] = "Execute sounds"
L["Enables or Disables execute sounds"] = "Enables or Disables execute sounds"
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
L["pickedA"] = "깃발을 손에 넣었습니다" --fix for Ru client
L["returned"] = "returned" -- Requires localization
L["stolen"] = "stolen" -- Requires localization
L["captured"] = "captured"
L["The Alliance is victorious"] = "The Alliance is victorious" -- Requires localization
L["The Horde is victorious"] = "The Horde is victorious" -- Requires localization
-- Battleground Events
L["Alliance wins"] = "얼라이언스 승리"
L["Alliance wins secondary"] = "얼라이언스 승리"
L["Alliance have captured"] = "얼라이언스 |1이;가; 깃발을 차지했습니다"
L["Horde have captured"] = "호드 |1이;가; 깃발을 차지했습니다"
L["captured"] = "깃발 쟁탈에 성공했습니다"
L["dropped"] = "떨어뜨렸습니다"
L["Horde wins"] = "호드 승리"
L["Horde wins secondary"] = "호드 승리"
L["returned"] = "깃발을 되찾았습니다"
L["Alliance Flag has returned"] = "Alliance Flag has returned" -- Requires localization
L["Horde Flag has returned"] = "Horde Flag has returned" -- Requires localization
L["Let the battle for the Strand of the Ancients begin"] = "Let the battle for the Strand of the Ancients begin" -- Requires localization
L["The battle for the Strand of the Ancients begins in 1 minute"] = "The battle for the Strand of the Ancients begins in 1 minute" -- Requires localization
L["Round 1"] = "Round 1" -- Requires localization
L["Round 2 of the Battle for the Strand of the Ancients begins in 1 minute"] = "Round 2 of the Battle for the Strand of the Ancients begins in 1 minute" -- Requires localization
L["Round 2 begins in 30 seconds"] = "Round 2 begins in 30 seconds" -- Requires localization
L["vulnerable"] = "약해져서"
L["Tie game"] = "Tie game" -- Requires localization
-- Battlefield Events
L["workshop has been attacked by the Alliance"] = "workshop has been attacked by the Alliance" -- Requires localization
L["workshop has been captured by the Alliance"] = "workshop has been captured by the Alliance" -- Requires localization
L["Alliance has defended"] = "Alliance has defended" -- Requires localization
L["workshop has been attacked by the Horde"] = "workshop has been attacked by the Horde" -- Requires localization
L["workshop has been captured by the Horde"] = "workshop has been captured by the Horde" -- Requires localization
L["Horde has defended"] = "Horde has defended" -- Requires localization
end

function PVPSound:Portuguese()
L["General"] = "PorGeneral"
-- Messages
L["Streak1Male"] = "just drew his" -- Requires localization
L["Streak1Female"] = "just drew her" -- Requires localization
L["Streak2"] = "is on" -- Requires localization
L["Streak3"] = "is on" -- Requires localization
L["Streak4"] = "is" -- Requires localization
L["Streak5"] = "is" -- Requires localization
L["Streak6"] = "is" -- Requires localization
L["Streak7"] = "committed a" -- Requires localization
L["Streak8"] = "committed a" -- Requires localization
L["Streak9"] = "committed a" -- Requires localization
L["Streak10"] = "committed a" -- Requires localization
L["'s"] = "'s" -- Requires localization
L["was over by"] = "was over by" -- Requires localization
L["You got killed by"] = "You got killed by" -- Requires localization
-- Options
L["[Ambience]"] = "[Ambience]" -- Requires localization
L["Battleground sounds"] = "Battleground sounds" -- Requires localization
L["Sound channel output"] = "Sound channel output" -- Requires localization
L["[Chat Message]"] = "[Chat Message]" -- Requires localization
L["[Disable]"] = "[Disable]" -- Requires localization
L["[Emote]"] = "[Emote]" -- Requires localization
L["Emote mode"] = "Emote mode" -- Requires localization
L["Emotes"] = "Emotes" -- Requires localization
L["[Enable]"] = "[Enable]" -- Requires localization
L["Killing Blow sounds"] = "Killing Blow sounds" -- Requires localization
L["[Master]"] = "[Master]" -- Requires localization
L["Mode"] = "Mode" -- Requires localization
L["Multi Killing sounds"] = "Multi Killing sounds" -- Requires localization
L["[Music]"] = "[Music]" -- Requires localization
L["[PVE]"] = "[PVE]" -- Requires localization
L["[PVP]"] = "[PVP]" -- Requires localization
L["Payback sounds"] = "Payback sounds" -- Requires localization
L["Killing Counter and Sound Queue reset"] = "Killing Counter and Sound Queue reset" -- Requires localization
L["[Sound]"] = "[Sound]" -- Requires localization
L["[Unreal Tournament 3]"] = "[Unreal Tournament 3]" -- Requires localization
L["[Custom]"] = "[Custom]" -- Requires localization
L["[Default]"] = "[Default]" -- Requires localization
L["[Deutsch]"] = "[Deutsch]" -- Requires localization
L["[English]"] = "[English]" -- Requires localization
L["[Spanish]"] = "[Spanish]" -- Requires localization
L["[France]"] = "[France]" -- Requires localization
L["[Italian]"] = "[Italian]" -- Requires localization
L["[Russian]"] = "[Russian]" -- Requires localization
L["Kill Sound Engine"] = "Kill Sound Engine" -- Requires localization
L["Battleground Sound Engine"] = "Battleground Sound Engine" -- Requires localization
L["Sound Effects"] = "Sound Effects" -- Requires localization
L["Data Sharing"] = "Data Sharing" -- Requires localization
L["Kill Scrolling Combat Text mode"] = "Kill Scrolling Combat Text mode" -- Requires localization
L["Scrolling Combat Text frame name"] = "Scrolling Combat Text frame name" -- Requires localization
L["Scrolling Combat Text Engine"] = "Scrolling Combat Text Engine" -- Requires localization
L["Multi Kill Scrolling Combat Text"] = "Multi Kill Scrolling Combat Text" -- Requires localization
L["Payback Scrolling Combat Text"] = "Payback Scrolling Combat Text" -- Requires localization
L["Pet Killing Blows"] = "Pet Killing Blows" -- Requires localization
L["Hide server names"] = "Hide server names" -- Requires localization
L["Sound Pack"] = "Sound Pack" -- Requires localization
L["Sound Pack language"] = "Sound Pack language" -- Requires localization
L["Scrolling Combat Text and sound test"] = "Testing sound" -- Requires localization
L["Command list"] = "Command list" -- Requires localization
L["Custom Sound Pack doesn't support that language!"] = "Custom Sound Pack doesn't support that language!" -- Requires localization
L["Enables or Disables Battleground sounds"] = "Enables or Disables Battleground sounds" -- Requires localization
L["Enables or Disables Sound Effects"] = "Enables or Disables Sound Effects" -- Requires localization
L["Switch between sound channels ('master' 'sound' 'music' 'ambience')"] = "Switch between sound channels ('master' 'sound' 'music' 'ambience')" -- Requires localization
L["Command help"] = "Command help" -- Requires localization
L["Enables or Disables Death Messages"] = "Enables or Disables Death Messages in Battlegrounds" -- Requires localization
L["Enables or Disables Emotes completely"] = "Enables or Disables Emotes completely" -- Requires localization
L["Switch between Emote and Chat Message mode"] = "Switch between Emote and Chat Message mode" -- Requires localization
L["Loaded. Type /ps help for options"] = "Enabled. Type /ps help for options" -- Requires localization
L["Enables or Disables Killing Blow and Multi Killing sounds"] = "Enables or Disables Killing Blow and Multi Killing sounds" -- Requires localization
L["Switch between PVP and PVE mode"] = "Switch between PVP and PVE mode" -- Requires localization
L["Enables or Disables Multi Killing sounds"] = "Enables or Disables Multi Killing sounds" -- Requires localization
L["Enables or Disables Pet Killing Blow sounds"] = "Enables or Disables Pet Killing Blow sounds" -- Requires localization
L["Enables or Disables Payback Killing sounds"] = "Enables or Disables Payback Killing sounds" -- Requires localization
L["Reset the counter of Killing Blows and the Payback-, Retibution-, Sound-, and SCT Queue System"] = "Reset the counter of Killing Blows and the Payback- and Sound Queue System" -- Requires localization
L["Enables or Disables Sound Queue System usage in Killing Sounds"] = "Enables or Disables Sound Queue System usage in Killing Sounds" -- Requires localization
L["Enables or Disables Sound Queue System usage in Battleground Sounds"] = "Enables or Disables Sound Queue System usage in Battleground Sounds" -- Requires localization
L["Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members"] = "Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members" -- Requires localization
L["Enables or Disables Kill Scrolling Combat Text usage"] = "Enables or Disables Kill Scrolling Combat Text usage" -- Requires localization
L["Name of the output frame in the supported Scrolling Combat Text"] = "Name of the output frame in the supported Scrolling Combat Text" -- Requires localization
L["Enables or Disables Scrolling Combat Text Queue System usage"] = "Enables or Disables Scrolling Combat Text Queue System usage" -- Requires localization
L["Enables or Disables Multi Kill Scrolling Combat Text usage"] = "Enables or Disables Multi Kill Scrolling Combat Text usage" -- Requires localization
L["Enables or Disables Payback and Retribution Scrolling Combat Text usage"] = "Enables or Disables Payback and Retribution Scrolling Combat Text usage" -- Requires localization
L["Enables or Disables hiding the player's server name from Data Sharing and Death Messages"] = "Enables or Disables hiding the player's server name from Data Sharing and Death Messages" -- Requires localization
L["Switch between Sound Packs ('ut3' 'custom')"] = "Switch between Sound Packs ('ut3' 'custom')" -- Requires localization
L["Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')"] = "Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')" -- Requires localization
L["Show status"] = "Show status" -- Requires localization
L["Scrolling Combat Text and sound test"] = "Sound test" -- Requires localization
L["Killing Count"] = "Killing Count" -- Requires localization
L["Death messages"] = "Death messages" -- Requires localization

 --need localization
L["[PVP and PVE]"] = "[PVP and PVE]"
L["Execute sounds"] = "Execute sounds"
L["Enables or Disables execute sounds"] = "Enables or Disables execute sounds"
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
L["pickedA"] = "picked" --fix for Ru client
L["returned"] = "returned" -- Requires localization
L["stolen"] = "stolen" -- Requires localization
L["captured"] = "captured"
L["The Alliance is victorious"] = "The Alliance is victorious" -- Requires localization
L["The Horde is victorious"] = "The Horde is victorious" -- Requires localization
-- Battleground Events
L["Alliance wins"] = "Aliança vence"
L["Alliance wins secondary"] = "Aliança vence"
L["Alliance have captured"] = "Alliance have captured" -- Requires localization
L["Horde have captured"] = "Horde have captured" -- Requires localization
L["captured"] = "captured" -- Requires localization
L["dropped"] = "derrubada"
L["Horde wins"] = "Horda vence"
L["Horde wins secondary"] = "Horda vence"
L["returned"] = "returned" -- Requires localization
L["Alliance Flag has returned"] = "Alliance Flag has returned" -- Requires localization
L["Horde Flag has returned"] = "Horde Flag has returned" -- Requires localization
L["Let the battle for the Strand of the Ancients begin"] = "Let the battle for the Strand of the Ancients begin" -- Requires localization
L["The battle for the Strand of the Ancients begins in 1 minute"] = "The battle for the Strand of the Ancients begins in 1 minute" -- Requires localization
L["Round 1"] = "Round 1" -- Requires localization
L["Round 2 of the Battle for the Strand of the Ancients begins in 1 minute"] = "Round 2 of the Battle for the Strand of the Ancients begins in 1 minute" -- Requires localization
L["Round 2 begins in 30 seconds"] = "Round 2 begins in 30 seconds" -- Requires localization
L["vulnerable"] = "vulnerable" -- Requires localization
L["Tie game"] = "Tie game" -- Requires localization
-- Battlefield Events
L["workshop has been attacked by the Alliance"] = "workshop has been attacked by the Alliance" -- Requires localization
L["workshop has been captured by the Alliance"] = "workshop has been captured by the Alliance" -- Requires localization
L["Alliance has defended"] = "Alliance has defended" -- Requires localization
L["workshop has been attacked by the Horde"] = "workshop has been attacked by the Horde" -- Requires localization
L["workshop has been captured by the Horde"] = "workshop has been captured by the Horde" -- Requires localization
L["Horde has defended"] = "Horde has defended" -- Requires localization
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
L["Streak1Male"] = "-"
L["Streak1Female"] = "-"
L["Streak2"] = "-"
L["Streak3"] = "-"
L["Streak4"] = "-"
L["Streak5"] = "-"
L["Streak6"] = "-"
L["Streak7"] = "-"
L["Streak8"] = "-"
L["Streak9"] = "-"
L["Streak10"] = "-"
L["'s"] = "-"
L["was over by"] = " - прервано игроком"
L["You got killed by"] = "Вы были убиты игроком"
-- Options
L["[Ambience]"] = "[Фон]"
L["Battleground sounds"] = "Звуки ПБ"
L["Sound channel output"] = "Звуковой канал"
L["[Chat Message]"] = "[Сообщения чата]"
L["[Disable]"] = "[Выкл]"
L["[Emote]"] = "[Эмоции]"
L["Emote mode"] = "Режим эмоций"
L["Emotes"] = "Эмоции"
L["[Enable]"] = "[Вкл]"
L["Killing Blow sounds"] = "Звуки убийств"
L["[Master]"] = "[Мастер]"
L["Mode"] = "Режим"
L["Multi Killing sounds"] = "Звуки при Multi Kill"
L["[Music]"] = "[Музыка]"
L["[PVE]"] = "[ПвЕ]"
L["[PVP]"] = "[ПвП]"
L["[PVP and PVE]"] = "[ПвП и ПвЕ]"
L["Payback sounds"] = "Звуки при Расплате"
L["Killing Counter and Sound Queue reset"] = "Сбросить счетчик убийств"
L["[Sound]"] = "[Звук]"
L["[Unreal Tournament 3]"] = "[Unreal Tournament 3]"
L["[Custom]"] = "[пользовательский]"
L["[Default]"] = "[По умолчанию]"
L["[Deutsch]"] = "[Немецкий]"
L["[English]"] = "[Английский]"
L["[Spanish]"] = "[Испанский]"
L["[France]"] = "[Французский]"
L["[Italian]"] = "[Итальянский]"
L["[Russian]"] = "[Русский]"
L["Kill Sound Engine"] = "Звуковой движок (убийства)"
L["Battleground Sound Engine"] = "Звуковой движок (ПБ)"
L["Sound Effects"] = "Звуковые эффекты"
L["Data Sharing"] = "Обмен данными"
L["Kill Scrolling Combat Text mode"] = "Режим SCT при убийствах"
L["Scrolling Combat Text frame name"] = "Название окошка SCT"
L["Scrolling Combat Text Engine"] = "Движок SCT"
L["Multi Kill Scrolling Combat Text"] = "SCT при Multi Kill"
L["Payback Scrolling Combat Text"] = "SCT при Расплате"
L["Pet Killing Blows"] = "Смертельные Удары питомца"
L["Hide server names"] = "Скрывать название сервера"
L["Sound Pack"] = "Саундпак"
L["Sound Pack language"] = "Язык саундпака"
L["Scrolling Combat Text and sound test"] = "Проверка звука"
L["Command list"] = "Список команд"
L["Custom Sound Pack doesn't support that language!"] = "Пользовательский саундпак не поддерживает этот язык!"
L["Enables or Disables Battleground sounds"] = "Вкл / Выкл звуки Поля Боя"
L["Enables or Disables Sound Effects"] = "Вкл / Выкл звуковые эффекты"
L["Switch between sound channels ('master' 'sound' 'music' 'ambience')"] = "Переключение между звуковыми каналами ('master' 'sound' 'music' 'ambience')"
L["Command help"] = "Помощь"
L["Enables or Disables Death Messages"] = "Вкл / Выкл сообщения о смерти на ПБ"
L["Enables or Disables Emotes completely"] = "Вкл / Выкл эмоций"
L["Switch between Emote and Chat Message mode"] = "Переключение между режимами Эмоций / Сообщений чата"
L["Loaded. Type /ps help for options"] = "Включено. Напишите /ps help"
L["Enables or Disables Killing Blow and Multi Killing sounds"] = "Вкл / Выкл озвучку убийств"
L["Switch between PVP and PVE mode"] = "Переключение ПвП / ПвЕ режимов"
L["Enables or Disables Multi Killing sounds"] = "Вкл / Выкл звуки Серии убийств"
L["Enables or Disables Pet Killing Blow sounds"] = "Вкл / Выкл озвучку Смертельных Ударов питомца"
L["Enables or Disables Payback Killing sounds"] = "Вкл / Выкл звуки при Расплате"
L["Reset the counter of Killing Blows and the Payback-, Retibution-, Sound-, and SCT Queue System"] = "Сбросить счетчик убийств"
L["Enables or Disables Sound Queue System usage in Killing Sounds"] = "Вкл / Выкл использование системы звуковой очередности при убийствах"
L["Enables or Disables Sound Queue System usage in Battleground Sounds"] = "Вкл / Выкл использование системы звуковой очередности для звуков ПБ"
L["Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members"] = "Вкл / Выкл обмен данными о сериях и смертях между участниками в группе/рейде/ПБ"
L["Enables or Disables Kill Scrolling Combat Text usage"] = "Вкл / Выкл использование SCT при убийствах"
L["Name of the output frame in the supported Scrolling Combat Text"] = "Название окошка поддерживаемого движка SCT"
L["Enables or Disables Scrolling Combat Text Queue System usage"] = "Вкл / Выкл использование системы очередности для SCT"
L["Enables or Disables Multi Kill Scrolling Combat Text usage"] = "Вкл / Выкл использование SCT при Multi Kill"
L["Enables or Disables Payback and Retribution Scrolling Combat Text usage"] = "Вкл / Выкл использование SCT при Расплате и Возмездии"
L["Enables or Disables hiding the player's server name from Data Sharing and Death Messages"] = "Вкл / Выкл скрытие названия сервера игрока при обмене данными и в сообщениях о смерти"
L["Switch between Sound Packs ('ut3' 'custom')"] = "Переключиться между саундпаками ('ut3' 'custom')"
L["Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')"] = "Переключиться между языками саундпаков ('deu' 'eng' 'esn' 'fra' 'ita')"
L["Show status"] = "Пoказать статус"
L["Scrolling Combat Text and sound test"] = "Проверка звука"
L["Killing Count"] = "Счетчик убийств"
L["Death messages"] = "Сообщения о смерти"
L["Execute sounds"] = "Звуки добивания"
L["Enables or Disables execute sounds"] = "Вкл / Выкл звуки добивания"


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
L["picked"] = "несет" --updated
L["pickedA"] = "Флаг Альянса у"--updated for 8.0 --for some reason in ru client there is different messages for Alliance and Horde flag picked
L["returned"] = "вернул"
L["stolen"] = "получает золото"
L["The Alliance is victorious"] = "Альянс одержал победу!"
L["The Horde is victorious"] = "Победа за Ордой!"
-- Battleground Events
L["Alliance wins"] = "Альянс побеждает"
L["Alliance wins secondary"] = "Альянс победил"
--for RU clien I use Alliance for male characters and Horde for female...it is about grammatics.  
L["Alliance have captured"] = "захватил флаг"
L["Horde have captured"] = "захватила флаг"

L["captured"] = "захват" --SM and DWG --in BFA full message for horde is "орда захватывает вагонетку" and for alliance is "альянс захватил вагонетку" so i decided to look for cutted "захват" 

L["dropped"] = "роняет"--updated
L["Horde wins"] = "Орда побеждает"
L["Horde wins secondary"] = "Орда победила"
L["returned"] = "возвращает"--updated
L["Alliance Flag has returned"] = "Флаг Альянса возвращен"
L["Horde Flag has returned"] = "Флаг Орды возвращен"
L["Let the battle for the Strand of the Ancients begin"] = "Да начнется битва за Берег Древних"
L["The battle for the Strand of the Ancients begins in 1 minute"] = "Битва за Берег Древних начнется через 1 минуту"
L["Round 1"] = "Раунд 1 - Завершен"
L["Round 2 of the Battle for the Strand of the Ancients begins in 1 minute"] = "Раунд 2 Битвы за Берег Древних начнется через 1 минуту"
L["Round 2 begins in 30 seconds"] = "Раунд 2 начинается через 30 секунд"
L["vulnerable"] = "уязвимо"
L["Tie game"] = "Ничья"
-- Battlefield Events
L["workshop has been attacked by the Alliance"] = "мастерская атакована Альянсом"
L["workshop has been captured by the Alliance"] = "мастерская захвачена Альянсом"
L["Alliance has defended"] = "Альянс защитил"
L["workshop has been attacked by the Horde"] = "мастерская атакована Ордой"
L["workshop has been captured by the Horde"] = "мастерская захвачена Ордой"
L["Horde has defended"] = "Орда защитила"
end

function PVPSound:SimplifiedChinese()
L["General"] = "SiChiGeneral"
-- Messages
L["Streak1Male"] = "just drew his" -- Requires localization
L["Streak1Female"] = "just drew her" -- Requires localization
L["Streak2"] = "is on" -- Requires localization
L["Streak3"] = "is on" -- Requires localization
L["Streak4"] = "is" -- Requires localization
L["Streak5"] = "is" -- Requires localization
L["Streak6"] = "is" -- Requires localization
L["Streak7"] = "committed a" -- Requires localization
L["Streak8"] = "committed a" -- Requires localization
L["Streak9"] = "committed a" -- Requires localization
L["Streak10"] = "committed a" -- Requires localization
L["'s"] = "'s" -- Requires localization
L["was over by"] = "was over by" -- Requires localization
L["You got killed by"] = "You got killed by" -- Requires localization
-- Options
L["[Ambience]"] = "[Ambience]" -- Requires localization
L["Battleground sounds"] = "Battleground sounds" -- Requires localization
L["Sound channel output"] = "Sound channel output" -- Requires localization
L["[Chat Message]"] = "[Chat Message]" -- Requires localization
L["[Disable]"] = "[Disable]" -- Requires localization
L["[Emote]"] = "[Emote]" -- Requires localization
L["Emote mode"] = "Emote mode" -- Requires localization
L["Emotes"] = "Emotes" -- Requires localization
L["[Enable]"] = "[Enable]" -- Requires localization
L["Killing Blow sounds"] = "Killing Blow sounds" -- Requires localization
L["[Master]"] = "[Master]" -- Requires localization
L["Mode"] = "Mode" -- Requires localization
L["Multi Killing sounds"] = "Multi Killing sounds" -- Requires localization
L["[Music]"] = "[Music]" -- Requires localization
L["[PVE]"] = "[PVE]" -- Requires localization
L["[PVP]"] = "[PVP]" -- Requires localization
L["Payback sounds"] = "Payback sounds" -- Requires localization
L["Killing Counter and Sound Queue reset"] = "Killing Counter and Sound Queue reset" -- Requires localization
L["[Sound]"] = "[Sound]" -- Requires localization
L["[Unreal Tournament 3]"] = "[Unreal Tournament 3]" -- Requires localization
L["[Custom]"] = "[Custom]" -- Requires localization
L["[Default]"] = "[Default]" -- Requires localization
L["[Deutsch]"] = "[Deutsch]" -- Requires localization
L["[English]"] = "[English]" -- Requires localization
L["[Spanish]"] = "[Spanish]" -- Requires localization
L["[France]"] = "[France]" -- Requires localization
L["[Italian]"] = "[Italian]" -- Requires localization
L["[Russian]"] = "[Russian]" -- Requires localization
L["Kill Sound Engine"] = "Kill Sound Engine" -- Requires localization
L["Battleground Sound Engine"] = "Battleground Sound Engine" -- Requires localization
L["Sound Effects"] = "Sound Effects" -- Requires localization
L["Data Sharing"] = "Data Sharing" -- Requires localization
L["Kill Scrolling Combat Text mode"] = "Kill Scrolling Combat Text mode" -- Requires localization
L["Scrolling Combat Text frame name"] = "Scrolling Combat Text frame name" -- Requires localization
L["Scrolling Combat Text Engine"] = "Scrolling Combat Text Engine" -- Requires localization
L["Multi Kill Scrolling Combat Text"] = "Multi Kill Scrolling Combat Text" -- Requires localization
L["Payback Scrolling Combat Text"] = "Payback Scrolling Combat Text" -- Requires localization
L["Pet Killing Blows"] = "Pet Killing Blows" -- Requires localization
L["Hide server names"] = "Hide server names" -- Requires localization
L["Sound Pack"] = "Sound Pack" -- Requires localization
L["Sound Pack language"] = "Sound Pack language" -- Requires localization
L["Scrolling Combat Text and sound test"] = "Testing sound" -- Requires localization
L["Command list"] = "Command list" -- Requires localization
L["Custom Sound Pack doesn't support that language!"] = "Custom Sound Pack doesn't support that language!" -- Requires localization
L["Enables or Disables Battleground sounds"] = "Enables or Disables Battleground sounds" -- Requires localization
L["Enables or Disables Sound Effects"] = "Enables or Disables Sound Effects" -- Requires localization
L["Switch between sound channels ('master' 'sound' 'music' 'ambience')"] = "Switch between sound channels ('master' 'sound' 'music' 'ambience')" -- Requires localization
L["Command help"] = "Command help" -- Requires localization
L["Enables or Disables Death Messages"] = "Enables or Disables Death Messages in Battlegrounds" -- Requires localization
L["Enables or Disables Emotes completely"] = "Enables or Disables Emotes completely" -- Requires localization
L["Switch between Emote and Chat Message mode"] = "Switch between Emote and Chat Message mode" -- Requires localization
L["Loaded. Type /ps help for options"] = "Enabled. Type /ps help for options" -- Requires localization
L["Enables or Disables Killing Blow and Multi Killing sounds"] = "Enables or Disables Killing Blow and Multi Killing sounds" -- Requires localization
L["Switch between PVP and PVE mode"] = "Switch between PVP and PVE mode" -- Requires localization
L["Enables or Disables Multi Killing sounds"] = "Enables or Disables Multi Killing sounds" -- Requires localization
L["Enables or Disables Pet Killing Blow sounds"] = "Enables or Disables Pet Killing Blow sounds" -- Requires localization
L["Enables or Disables Payback Killing sounds"] = "Enables or Disables Payback Killing sounds" -- Requires localization
L["Reset the counter of Killing Blows and the Payback-, Retibution-, Sound-, and SCT Queue System"] = "Reset the counter of Killing Blows and the Payback- and Sound Queue System" -- Requires localization
L["Enables or Disables Sound Queue System usage in Killing Sounds"] = "Enables or Disables Sound Queue System usage in Killing Sounds" -- Requires localization
L["Enables or Disables Sound Queue System usage in Battleground Sounds"] = "Enables or Disables Sound Queue System usage in Battleground Sounds" -- Requires localization
L["Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members"] = "Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members" -- Requires localization
L["Enables or Disables Kill Scrolling Combat Text usage"] = "Enables or Disables Kill Scrolling Combat Text usage" -- Requires localization
L["Name of the output frame in the supported Scrolling Combat Text"] = "Name of the output frame in the supported Scrolling Combat Text" -- Requires localization
L["Enables or Disables Scrolling Combat Text Queue System usage"] = "Enables or Disables Scrolling Combat Text Queue System usage" -- Requires localization
L["Enables or Disables Multi Kill Scrolling Combat Text usage"] = "Enables or Disables Multi Kill Scrolling Combat Text usage" -- Requires localization
L["Enables or Disables Payback and Retribution Scrolling Combat Text usage"] = "Enables or Disables Payback and Retribution Scrolling Combat Text usage" -- Requires localization
L["Enables or Disables hiding the player's server name from Data Sharing and Death Messages"] = "Enables or Disables hiding the player's server name from Data Sharing and Death Messages" -- Requires localization
L["Switch between Sound Packs ('ut3' 'custom')"] = "Switch between Sound Packs ('ut3' 'custom')" -- Requires localization
L["Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')"] = "Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')" -- Requires localization
L["Show status"] = "Show status" -- Requires localization
L["Scrolling Combat Text and sound test"] = "Sound test" -- Requires localization
L["Killing Count"] = "Killing Count" -- Requires localization
L["Death messages"] = "Death messages" -- Requires localization
 --need localization
L["[PVP and PVE]"] = "[PVP and PVE]"
L["Execute sounds"] = "Execute sounds"
L["Enables or Disables execute sounds"] = "Enables or Disables execute sounds"
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
L["pickedA"] = "拔起了" --fix for Ru client
L["returned"] = "returned" -- Requires localization
L["stolen"] = "stolen" -- Requires localization
L["captured"] = "captured"
L["The Alliance is victorious"] = "The Alliance is victorious" -- Requires localization
L["The Horde is victorious"] = "The Horde is victorious" -- Requires localization
-- Battleground Events
L["Alliance wins"] = "联盟 获胜"
L["Alliance wins secondary"] = "联盟 获胜"
L["Alliance have captured"] = "联盟 夺得了旗帜"
L["Horde have captured"] = "部落 夺得了旗帜"
L["captured"] = "的旗帜"
L["dropped"] = "旗帜被扔掉了"
L["Horde wins"] = "部落 获胜"
L["Horde wins secondary"] = "部落 获胜"
L["returned"] = "还到了它的基地中"
L["Alliance Flag has returned"] = "Alliance Flag has returned" -- Requires localization
L["Horde Flag has returned"] = "Horde Flag has returned" -- Requires localization
L["Let the battle for the Strand of the Ancients begin"] = "Let the battle for the Strand of the Ancients begin" -- Requires localization
L["The battle for the Strand of the Ancients begins in 1 minute"] = "The battle for the Strand of the Ancients begins in 1 minute" -- Requires localization
L["Round 1"] = "Round 1" -- Requires localization
L["Round 2 of the Battle for the Strand of the Ancients begins in 1 minute"] = "Round 2 of the Battle for the Strand of the Ancients begins in 1 minute" -- Requires localization
L["Round 2 begins in 30 seconds"] = "Round 2 begins in 30 seconds" -- Requires localization
L["vulnerable"] = "vulnerable" -- Requires localization
L["Tie game"] = "Tie game" -- Requires localization
-- Battlefield Events
L["workshop has been attacked by the Alliance"] = "workshop has been attacked by the Alliance" -- Requires localization
L["workshop has been captured by the Alliance"] = "workshop has been captured by the Alliance" -- Requires localization
L["Alliance has defended"] = "Alliance has defended" -- Requires localization
L["workshop has been attacked by the Horde"] = "workshop has been attacked by the Horde" -- Requires localization
L["workshop has been captured by the Horde"] = "workshop has been captured by the Horde" -- Requires localization
L["Horde has defended"] = "Horde has defended" -- Requires localization

end

function PVPSound:TraditionalChinese()
L["General"] = "TraChiGeneral"
-- Messages
L["Streak1Male"] = "just drew his" -- Requires localization
L["Streak1Female"] = "just drew her" -- Requires localization
L["Streak2"] = "is on" -- Requires localization
L["Streak3"] = "is on" -- Requires localization
L["Streak4"] = "is" -- Requires localization
L["Streak5"] = "is" -- Requires localization
L["Streak6"] = "is" -- Requires localization
L["Streak7"] = "committed a" -- Requires localization
L["Streak8"] = "committed a" -- Requires localization
L["Streak9"] = "committed a" -- Requires localization
L["Streak10"] = "committed a" -- Requires localization
L["'s"] = "'s" -- Requires localization
L["was over by"] = "was over by" -- Requires localization
L["You got killed by"] = "You got killed by" -- Requires localization
-- Options
L["[Ambience]"] = "[Ambience]" -- Requires localization
L["Battleground sounds"] = "Battleground sounds" -- Requires localization
L["Sound channel output"] = "Sound channel output" -- Requires localization
L["[Chat Message]"] = "[Chat Message]" -- Requires localization
L["[Disable]"] = "[Disable]" -- Requires localization
L["[Emote]"] = "[Emote]" -- Requires localization
L["Emote mode"] = "Emote mode" -- Requires localization
L["Emotes"] = "Emotes" -- Requires localization
L["[Enable]"] = "[Enable]" -- Requires localization
L["Killing Blow sounds"] = "Killing Blow sounds" -- Requires localization
L["[Master]"] = "[Master]" -- Requires localization
L["Mode"] = "Mode" -- Requires localization
L["Multi Killing sounds"] = "Multi Killing sounds" -- Requires localization
L["[Music]"] = "[Music]" -- Requires localization
L["[PVE]"] = "[PVE]" -- Requires localization
L["[PVP]"] = "[PVP]" -- Requires localization
L["Payback sounds"] = "Payback sounds" -- Requires localization
L["Killing Counter and Sound Queue reset"] = "Killing Counter and Sound Queue reset" -- Requires localization
L["[Sound]"] = "[Sound]" -- Requires localization
L["[Unreal Tournament 3]"] = "[Unreal Tournament 3]" -- Requires localization
L["[Custom]"] = "[Custom]" -- Requires localization
L["[Default]"] = "[Default]" -- Requires localization
L["[Deutsch]"] = "[Deutsch]" -- Requires localization
L["[English]"] = "[English]" -- Requires localization
L["[Spanish]"] = "[Spanish]" -- Requires localization
L["[France]"] = "[France]" -- Requires localization
L["[Italian]"] = "[Italian]" -- Requires localization
L["[Russian]"] = "[Russian]" -- Requires localization
L["Kill Sound Engine"] = "Kill Sound Engine" -- Requires localization
L["Battleground Sound Engine"] = "Battleground Sound Engine" -- Requires localization
L["Sound Effects"] = "Sound Effects" -- Requires localization
L["Data Sharing"] = "Data Sharing" -- Requires localization
L["Kill Scrolling Combat Text mode"] = "Kill Scrolling Combat Text mode" -- Requires localization
L["Scrolling Combat Text frame name"] = "Scrolling Combat Text frame name" -- Requires localization
L["Scrolling Combat Text Engine"] = "Scrolling Combat Text Engine" -- Requires localization
L["Multi Kill Scrolling Combat Text"] = "Multi Kill Scrolling Combat Text" -- Requires localization
L["Payback Scrolling Combat Text"] = "Payback Scrolling Combat Text" -- Requires localization
L["Pet Killing Blows"] = "Pet Killing Blows" -- Requires localization
L["Hide server names"] = "Hide server names" -- Requires localization
L["Sound Pack"] = "Sound Pack" -- Requires localization
L["Sound Pack language"] = "Sound Pack language" -- Requires localization
L["Scrolling Combat Text and sound test"] = "Testing sound" -- Requires localization
L["Command list"] = "Command list" -- Requires localization
L["Custom Sound Pack doesn't support that language!"] = "Custom Sound Pack doesn't support that language!" -- Requires localization
L["Enables or Disables Battleground sounds"] = "Enables or Disables Battleground sounds" -- Requires localization
L["Enables or Disables Sound Effects"] = "Enables or Disables Sound Effects" -- Requires localization
L["Switch between sound channels ('master' 'sound' 'music' 'ambience')"] = "Switch between sound channels ('master' 'sound' 'music' 'ambience')" -- Requires localization
L["Command help"] = "Command help" -- Requires localization
L["Enables or Disables Death Messages"] = "Enables or Disables Death Messages in Battlegrounds" -- Requires localization
L["Enables or Disables Emotes completely"] = "Enables or Disables Emotes completely" -- Requires localization
L["Switch between Emote and Chat Message mode"] = "Switch between Emote and Chat Message mode" -- Requires localization
L["Loaded. Type /ps help for options"] = "Enabled. Type /ps help for options" -- Requires localization
L["Enables or Disables Killing Blow and Multi Killing sounds"] = "Enables or Disables Killing Blow and Multi Killing sounds" -- Requires localization
L["Switch between PVP and PVE mode"] = "Switch between PVP and PVE mode" -- Requires localization
L["Enables or Disables Multi Killing sounds"] = "Enables or Disables Multi Killing sounds" -- Requires localization
L["Enables or Disables Pet Killing Blow sounds"] = "Enables or Disables Pet Killing Blow sounds" -- Requires localization
L["Enables or Disables Payback Killing sounds"] = "Enables or Disables Payback Killing sounds" -- Requires localization
L["Reset the counter of Killing Blows and the Payback-, Retibution-, Sound-, and SCT Queue System"] = "Reset the counter of Killing Blows and the Payback- and Sound Queue System" -- Requires localization
L["Enables or Disables Sound Queue System usage in Killing Sounds"] = "Enables or Disables Sound Queue System usage in Killing Sounds" -- Requires localization
L["Enables or Disables Sound Queue System usage in Battleground Sounds"] = "Enables or Disables Sound Queue System usage in Battleground Sounds" -- Requires localization
L["Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members"] = "Enables or Disables Spree and Death Data Sharing and Receiving with raid/party/battleground members" -- Requires localization
L["Enables or Disables Kill Scrolling Combat Text usage"] = "Enables or Disables Kill Scrolling Combat Text usage" -- Requires localization
L["Name of the output frame in the supported Scrolling Combat Text"] = "Name of the output frame in the supported Scrolling Combat Text" -- Requires localization
L["Enables or Disables Scrolling Combat Text Queue System usage"] = "Enables or Disables Scrolling Combat Text Queue System usage" -- Requires localization
L["Enables or Disables Multi Kill Scrolling Combat Text usage"] = "Enables or Disables Multi Kill Scrolling Combat Text usage" -- Requires localization
L["Enables or Disables Payback and Retribution Scrolling Combat Text usage"] = "Enables or Disables Payback and Retribution Scrolling Combat Text usage" -- Requires localization
L["Enables or Disables hiding the player's server name from Data Sharing and Death Messages"] = "Enables or Disables hiding the player's server name from Data Sharing and Death Messages" -- Requires localization
L["Switch between Sound Packs ('ut3' 'custom')"] = "Switch between Sound Packs ('ut3' 'custom')" -- Requires localization
L["Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')"] = "Switch between Sound Pack languages ('deu' 'eng' 'esn' 'fra' 'ita')" -- Requires localization
L["Show status"] = "Show status" -- Requires localization
L["Scrolling Combat Text and sound test"] = "Sound test" -- Requires localization
L["Killing Count"] = "Killing Count" -- Requires localization
L["Death messages"] = "Death messages" -- Requires localization
 --need localization
L["[PVP and PVE]"] = "[PVP and PVE]"
L["Execute sounds"] = "Execute sounds"
L["Enables or Disables execute sounds"] = "Enables or Disables execute sounds"
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
L["pickedA"] = "拔起了" --fix for Ru client
L["returned"] = "returned"
L["stolen"] = "stolen"
L["captured"] = "captured"
L["The Alliance is victorious"] = "The Alliance is victorious"
L["The Horde is victorious"] = "The Horde is victorious"
-- Battleground Events
L["Alliance wins"] = "聯盟 勝利"
L["Alliance wins secondary"] = "聯盟 勝利"
L["Alliance have captured"] = "聯盟 已奪得旗幟"
L["Horde have captured"] = "部落 已奪得旗幟"
L["captured"] = "的旗幟"
L["dropped"] = "旗幟已經掉落"
L["Horde wins"] = "部落 勝利"
L["Horde wins secondary"] = "部落 勝利"
L["returned"] = "還到了它的基地"
L["Alliance Flag has returned"] = "Alliance Flag has returned" -- Requires localization
L["Horde Flag has returned"] = "Horde Flag has returned" -- Requires localization
L["Let the battle for the Strand of the Ancients begin"] = "Let the battle for the Strand of the Ancients begin" -- Requires localization
L["The battle for the Strand of the Ancients begins in 1 minute"] = "The battle for the Strand of the Ancients begins in 1 minute" -- Requires localization
L["Round 1"] = "Round 1" -- Requires localization
L["Round 2 of the Battle for the Strand of the Ancients begins in 1 minute"] = "Round 2 of the Battle for the Strand of the Ancients begins in 1 minute" -- Requires localization
L["Round 2 begins in 30 seconds"] = "Round 2 begins in 30 seconds" -- Requires localization
L["vulnerable"] = "vulnerable" -- Requires localization
L["Tie game"] = "Tie game" -- Requires localization
-- Battlefield Events
L["workshop has been attacked by the Alliance"] = "workshop has been attacked by the Alliance" -- Requires localization
L["workshop has been captured by the Alliance"] = "workshop has been captured by the Alliance" -- Requires localization
L["Alliance has defended"] = "Alliance has defended" -- Requires localization
L["workshop has been attacked by the Horde"] = "workshop has been attacked by the Horde" -- Requires localization
L["workshop has been captured by the Horde"] = "workshop has been captured by the Horde" -- Requires localization
L["Horde has defended"] = "Horde has defended" -- Requires localization
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