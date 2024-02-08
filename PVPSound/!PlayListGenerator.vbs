offSet = 0.0000

soundPackName = "Custom"
soundPackLang = "Default"

outputFile = "..\PVPSound_CustomSoundPack\PVPSound_SoundLengthsCustom.lua"

soundPackTable = "PVPSound_" & soundPackName & soundPackLang & "Durations"
killSoundPackTable = "PVPSound_" & soundPackName & soundPackLang & "KillDurations"
multiKillSoundPackTable = "PVPSound_" & soundPackName & soundPackLang & "MultiKillDurations"
paybackKillSoundPackTable = "PVPSound_" & soundPackName & soundPackLang & "PaybackKillDurations"
testSoundPackTable = "PVPSound_" & soundPackName & soundPackLang & "TestDurations"

scriptFolder = replace(WScript.ScriptFullName, WScript.ScriptName, "")
spitScriptFolder = split(scriptFolder, "PVPSound\")
upperScriptFolder = spitScriptFolder(0)
scriptFolderReplace = replace(scriptFolder, "PVPSound", "PVPSound_CustomSoundPack")
soundFolder = scriptFolderReplace & "Sounds\" & soundPackName & "\" & soundPackLang & ""
realtiveSoundFolder = "Interface\\Addons\\PVPSound_CustomSoundPack\\Sounds\\" & soundPackName & "\\" & soundPackLang & "\\"

checkStartMode

sub checkStartMode()
	strStartExe = UCase(mid(wscript.fullname, instrRev(wscript.fullname, "\") + 1))
	if not strStartExe = "CSCRIPT.EXE" then
		set oSh = CreateObject("wscript.shell")
		oSh.Run "cmd /k cscript.exe """ & wscript.scriptfullname
		WScript.Quit
	end if
end sub

function getWindowsVersion()
	dim objWMI, objItem, colItems
	dim strComputer, VerOS, VerBig, Ver9x, Version9x, OS, OSystem
	on error resume next
	strComputer = "."
	set objWMI = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
	set colItems = objWMI.ExecQuery("Select * from Win32_OperatingSystem", , 48)
	for each objItem in colItems
		VerBig = Left(objItem.Version, 3)
	next
	getWindowsVersion = VerBig
	set objWMI = nothing
	set colItems = nothing
end function

'Check Windows Version
dim indexSize, indexTitle, indexArtist, indexAlbum, indexTime, indexBitRate
if getWindowsVersion() = "10." then
	'Windows 10
	indexSize = 1
	indexTitle = 21
	indexArtist = 20
	indexAlbum = 14
	indexTime = 27
	indexBitRate = 28
elseif getWindowsVersion() = "6.2" then
	'Windows 8
	indexSize = 1
	indexTitle = 21
	indexArtist = 20
	indexAlbum = 14
	indexTime = 27
	indexBitRate = 28
elseif getWindowsVersion() = "6.1" then
	'Windows 7
	indexSize = 1
	indexTitle = 21
	indexArtist = 20
	indexAlbum = 14
	indexTime = 27
	indexBitRate = 28
elseif getWindowsVersion() = "6.0" then
	'Windows Vista
	indexSize = 1
	indexTitle = 21
	indexArtist = 20
	indexAlbum = 14
	indexTime = 27
	indexBitRate = 28
elseif getWindowsVersion() = "5.1" then
	'Windows XP
	indexSize = 1
	indexTitle = 10
	indexArtist = 16
	indexAlbum = 17
	indexTime = 21
	indexBitRate = 22
else
	WScript.Echo "This playlist generator does not work with your windows version (" & getWindowsVersion() & ")"
	WScript.Quit
end if

playlistIndex = 0
listCount = 0
totalNumberOfSongs = 0
number = 1

set objShell = CreateObject("Shell.Application")
set objFSO = createobject("Scripting.FileSystemObject")

'Creating Folders
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName) then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName)
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang) then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang)
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\CountDown") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\CountDown"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\CountDown")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Effects") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Effects"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Effects")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\GameStatus") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\GameStatus"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\GameStatus")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Kill") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Kill"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Kill")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\MultiKill") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\MultiKill"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\MultiKill")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Payback") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Payback"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Payback")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Test") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Test"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Test")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_AlteracValley") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_AlteracValley"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_AlteracValley")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_ArathiBasin") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_ArathiBasin"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_ArathiBasin")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_CookingImpossible") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_CookingImpossible"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_CookingImpossible")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_DeepwindGorge") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_DeepwindGorge"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_DeepwindGorge")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_EyeoftheStorm") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_EyeoftheStorm"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_EyeoftheStorm")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_IsleofConquest") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_IsleofConquest"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_IsleofConquest")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_SeethingShore") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_SeethingShore"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_SeethingShore")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_SilvershardMines") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_SilvershardMines"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_SilvershardMines")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_TarrenShore") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_TarrenShore"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_TarrenShore")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_TempleofKotmogu") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_TempleofKotmogu"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_TempleofKotmogu")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_TheBattleforGilneas") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_TheBattleforGilneas"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_TheBattleforGilneas")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_TolBarad") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_TolBarad"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_TolBarad")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_TwinPeaks") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_TwinPeaks"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_TwinPeaks")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_WarsongGulch") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_WarsongGulch"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_WarsongGulch")
end if
if not objFSO.FolderExists(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_Wintergrasp") then
	WScript.Echo "Creating folder: AddOns\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_Wintergrasp"
	objFSO.CreateFolder(upperScriptFolder & "PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang & "\Zone_Wintergrasp")
end if

if not objFSO.FolderExists(soundFolder) then
	if soundFolder = "..\..\Addons\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang then
		WScript.Echo "Sound Folder not found: " & objFSO.GetFolder("..\..\").Path & "\Addons\PVPSound_CustomSoundPack\Sounds\" & soundPackName & "\" & soundPackLang
		WScript.Echo "Make sure the Folder exists."
	else
		WScript.Echo "Sound Folder not found: " & soundFolder
		WScript.Echo "Make sure the Folder exists."
	end if
	WScript.Quit
end if

soundFolder = objFSO.GetFolder(soundFolder).Path

const adTypeText = 2
const adSaveCreateOverWrite = 2
dim BinaryStream
set BinaryStream = CreateObject("ADODB.Stream")

BinaryStream.Type = adTypeText
BinaryStream.CharSet = "utf-8"
BinaryStream.Open
BinaryStream.WriteText "-- " & soundPackName & " SoundPack" & Vbcrlf
BinaryStream.WriteText "-- " & soundPackLang & Vbcrlf
BinaryStream.WriteText soundPackTable & " = { }" & Vbcrlf
BinaryStream.WriteText killSoundPackTable & " = { }" & Vbcrlf
BinaryStream.WriteText multiKillSoundPackTable & " = { }" & Vbcrlf
BinaryStream.WriteText paybackKillSoundPackTable & " = { }" & Vbcrlf
BinaryStream.WriteText testSoundPackTable & " = { }" & Vbcrlf
BinaryStream.WriteText "" & Vbcrlf

set objFolder = objFSO.GetFolder(soundFolder)
set folder = objShell.NameSpace(soundFolder)

WScript.Echo "Generating playlist for folders in: " & objFSO.GetFolder(soundFolder).Name

for each file in folder.items
	x = getSongInfo(file, folder)
next
playlistIndex = playlistIndex + 1

for each objFolder in objFolder.SubFolders
	if objFolder.Files.Count > 0 or objFolder.Subfolders.count > 0 then
		WScript.Echo objFolder
		CreatePlaylist objFolder.Path
		playlistIndex = playlistIndex + 1
	end if
next

BinaryStream.SaveToFile "" & outputFile & "", adSaveCreateOverWrite

if totalNumberOfSongs > 0 then
	WScript.Echo "Done!" & Vbcrlf & totalNumberOfSongs & " sound files written to: " & outputFile
	CreateObject("SAPI.SpVoice").Speak totalNumberOfSongs & "Files Generated"
else
	WScript.Echo "No files found!"
	CreateObject("SAPI.SpVoice").Speak "No Files Found"
end if

sub GetFiles(byval strDirectory)
	set objFolder = objFSO.GetFolder(strDirectory)
	set folder = objShell.NameSpace(strDirectory)
	for each file in folder.items
		x = getSongInfo(file, folder)
	next
	for each objFolder in objFolder.SubFolders
		GetFiles objFolder.Path
	next
end sub

sub CreatePlaylist(byval strDirectory)
	WScript.Echo "Generating playlist for files in: " & objFSO.GetFolder(strDirectory).Name
	listCount = 0
	GetFiles strDirectory
end sub

function getSongInfo(file, folder)
	dim album, title, timeSec, timeMilliSec, artist, ext, path, folderName, pathCut
	ext = Ucase(Right(file.Path, 3))
	if ext = "MP3" then
		title = Replace(folder.GetDetailsOf(file, indexTitle), """", "")
		artist = Replace(folder.GetDetailsOf(file, indexArtist), """", "")
		album = Replace(folder.GetDetailsOf(file, indexAlbum), """", "")
		timeSec = getTimeSec(file, folder)
		timeMilliSec = getTimeMilliSec(file, folder)
		path = Right(file.Path, len(file.Path) - len(soundFolder) - 1)
		if title = "" and len(file) > 4 then
			title = Left(file, len(file) - 4)
		end if
		if timeSec + timeMilliSec > 0 then
			listCount = listCount + 1
			totalNumberOfSongs = totalNumberOfSongs + 1
			x = writeSound(outfile, path, album, timeSec, timeMilliSec, title, artist)
			pathCut = split(path, "\\")
			folderName = pathCut(0)
			if folderName = "Kill" or folderName = "MultiKill" or folderName = "Payback" or folderName = "Test" then
				if listCount < 10 then
					WScript.Echo listCount & "   Writing: " & timeSec & "." & timeMilliSec & " " & path
				elseif listCount < 100 then
					WScript.Echo listCount & "  Writing: " & timeSec & "." & timeMilliSec & " " & path
				else
					WScript.Echo listCount & " Writing: " & timeSec & "." & timeMilliSec & " " & path
				end if
			else
				if number < 10 then
					WScript.Echo number & "   Writing: " & timeSec & "." & timeMilliSec & " " & path
				elseif number < 100 then
					WScript.Echo number & "  Writing: " & timeSec & "." & timeMilliSec & " " & path
				else
					WScript.Echo number & " Writing: " & timeSec & "." & timeMilliSec & " " & path
				end if
				number = number + 1
			end if
		end if
	end if
end function

function getBitRate(folder, file)
	set objFolderName = objShell.Namespace(folder)
	dim strBitRate, bitRateNumber
	strBitRate = objFolderName.GetDetailsOf(objFolderName.Parsename(file), indexBitRate)
	'Removing starter space charater
	strBitRate = Right(strBitRate, len(strBitRate) - 1)
	bitRateNumber = getBitRateNumber(strBitRate)
	getBitRate = bitRateNumber
end function

function getBitRateNumber(strBitRate)
	if IsNull(strBitRate) = false and strBitRate <> "" then
		if isNumberInString(strBitRate) = true then
			do while IsNumeric(strBitRate) = false
				strBitRate = Left(strBitRate, len(strBitRate) - 1)
				getBitRateNumber(strBitRate)
			loop
		end if
	end if
	getBitRateNumber = strBitRate
end function

function isNumberInString(checkString)
	dim isNumberInIt, stri
	isNumberInIt = false
	if IsNull(checkString) = false and checkString <> "" then
		for i = 0 to 9
			stri = cstr(i)
			if InStr(1, checkString, stri, 1) > 0 then
				isNumberInIt = true
			end if
		next
	end if
	isNumberInString = isNumberInIt
end function

function getTimeSec(file, folder)
	dim time, timeOffset, splitTimeOffset, timeSec, mp3, path, intBitRate
	mp3 = Right(file.Path, len(file.Path) - len(soundFolder) - len(folder) - 2)
	path = Left(file.Path, len(file.Path) - len(mp3))
	intBitRate = CInt(getBitRate(path, mp3))
	time = (file.Size * 8) / (intBitRate * 1000)
	timeOffset = time + offSet
	if InStr(timeOffset, ".") then
		splitTimeOffset = split(timeOffset, ".")
	elseif InStr(timeOffset, ",") then
		splitTimeOffset = split(timeOffset, ",")
	end if
	timeSec = splitTimeOffset(0)
	getTimeSec = timeSec
end function

function getTimeMilliSec(file, folder)
	dim time, timeOffset, timeOffsetFormat, splitTimeOffset, timeMilliSec, mp3, path, intBitRate
	mp3 = Right(file.Path, len(file.Path) - len(soundFolder) - len(folder) - 2)
	path = Left(file.Path, len(file.Path) - len(mp3))
	intBitRate = CInt(getBitRate(path, mp3))
	time = (file.Size * 8) / (intBitRate * 1000)
	timeOffset = time + offSet
	timeOffsetFormat = FormatNumber(timeOffset, 4)
	'Converting to string so the splitting wont remove the zeros from the end, like from numbers
	strTimeOffset = CStr(timeOffsetFormat)
	if InStr(strTimeOffset, ".") then
		splitStrTimeOffset = split(strTimeOffset, ".")
	elseif InStr(strTimeOffset, ",") then
		splitStrTimeOffset = split(strTimeOffset, ",")
	end if
	timeMilliSec = splitStrTimeOffset(1)
	getTimeMilliSec = timeMilliSec
end function

function writeSound(outfile, path, album, timesec, timemillisec, title, artist)
	path = Replace(path, "\", "\\")
	dim pathCut, folder, file, index, indexlength
	pathCut = split(path, "\\")
	folder = pathCut(0)
	file = pathCut(1)
	file = Left(file, len(file) - 4)
	for i = len(file) to 1 step -1
		if IsNumeric(Left(file, i)) then
			indexlength = i
			exit for
		end if
	next
	if IsNull(indexlength) = false and indexlength <> "" then
		index = CInt(Left(file, indexlength))
		file = Right(file, len(file) - indexlength)
	end if
	if folder = "Kill" then
		if len(path) + len(file) + 1 >= 0 and len(path) + len(file) + 1 <= 4 then
			BinaryStream.WriteText killSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,																		duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 5 and len(path) + len(file) + 1 <= 8 then
			BinaryStream.WriteText killSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,																	duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 9 and len(path) + len(file) + 1 <= 12 then
			BinaryStream.WriteText killSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,																duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 13 and len(path) + len(file) + 1 <= 16 then
			BinaryStream.WriteText killSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,															duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 17 and len(path) + len(file) + 1 <= 20 then
			BinaryStream.WriteText killSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,														duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 21 and len(path) + len(file) + 1 <= 24 then
			BinaryStream.WriteText killSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,													duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 25 and len(path) + len(file) + 1 <= 28 then
			BinaryStream.WriteText killSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,												duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 29 and len(path) + len(file) + 1 <= 32 then
			BinaryStream.WriteText killSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,											duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 33 and len(path) + len(file) + 1 <= 36 then
			BinaryStream.WriteText killSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,										duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 37 and len(path) + len(file) + 1 <= 40 then
			BinaryStream.WriteText killSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,									duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 41 and len(path) + len(file) + 1 <= 44 then
			BinaryStream.WriteText killSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,								duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 45 and len(path) + len(file) + 1 <= 48 then
			BinaryStream.WriteText killSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,							duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 49 and len(path) + len(file) + 1 <= 52 then
			BinaryStream.WriteText killSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,						duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 53 and len(path) + len(file) + 1 <= 56 then
			BinaryStream.WriteText killSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,					duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 57 and len(path) + len(file) + 1 <= 60 then
			BinaryStream.WriteText killSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,				duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 61 and len(path) + len(file) + 1 <= 64 then
			BinaryStream.WriteText killSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,			duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 65 and len(path) + len(file) + 3 <= 68 then
			BinaryStream.WriteText killSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,		duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		else
			BinaryStream.WriteText killSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,	duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		end if
	elseif folder = "MultiKill" then
		if len(path) + len(file) + 1 >= 0 and len(path) + len(file) + 1 <= 4 then
			BinaryStream.WriteText multiKillSoundPackTable & "[" & index & "]		=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,																		duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 5 and len(path) + len(file) + 1 <= 8 then
			BinaryStream.WriteText multiKillSoundPackTable & "[" & index & "]		=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,																	duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 9 and len(path) + len(file) + 1 <= 12 then
			BinaryStream.WriteText multiKillSoundPackTable & "[" & index & "]		=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,																duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 13 and len(path) + len(file) + 1 <= 16 then
			BinaryStream.WriteText multiKillSoundPackTable & "[" & index & "]		=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,															duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 17 and len(path) + len(file) + 1 <= 20 then
			BinaryStream.WriteText multiKillSoundPackTable & "[" & index & "]		=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,														duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 21 and len(path) + len(file) + 1 <= 24 then
			BinaryStream.WriteText multiKillSoundPackTable & "[" & index & "]		=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,													duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 25 and len(path) + len(file) + 1 <= 28 then
			BinaryStream.WriteText multiKillSoundPackTable & "[" & index & "]		=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,												duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 29 and len(path) + len(file) + 1 <= 32 then
			BinaryStream.WriteText multiKillSoundPackTable & "[" & index & "]		=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,											duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 33 and len(path) + len(file) + 1 <= 36 then
			BinaryStream.WriteText multiKillSoundPackTable & "[" & index & "]		=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,										duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 37 and len(path) + len(file) + 1 <= 40 then
			BinaryStream.WriteText multiKillSoundPackTable & "[" & index & "]		=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,									duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 41 and len(path) + len(file) + 1 <= 44 then
			BinaryStream.WriteText multiKillSoundPackTable & "[" & index & "]		=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,								duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 45 and len(path) + len(file) + 1 <= 48 then
			BinaryStream.WriteText multiKillSoundPackTable & "[" & index & "]		=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,							duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 49 and len(path) + len(file) + 1 <= 52 then
			BinaryStream.WriteText multiKillSoundPackTable & "[" & index & "]		=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,						duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 53 and len(path) + len(file) + 1 <= 56 then
			BinaryStream.WriteText multiKillSoundPackTable & "[" & index & "]		=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,					duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 57 and len(path) + len(file) + 1 <= 60 then
			BinaryStream.WriteText multiKillSoundPackTable & "[" & index & "]		=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,				duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 61 and len(path) + len(file) + 1 <= 64 then
			BinaryStream.WriteText multiKillSoundPackTable & "[" & index & "]		=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,			duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 1 >= 65 and len(path) + len(file) + 1 <= 68 then
			BinaryStream.WriteText multiKillSoundPackTable & "[" & index & "]		=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,		duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		else
			BinaryStream.WriteText multiKillSoundPackTable & "[" & index & "]		=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,	duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		end if
	elseif folder = "Payback" then
		if len(path) + len(file) + 3 >= 0 and len(path) + len(file) + 3 <= 4 then
			BinaryStream.WriteText paybackKillSoundPackTable & "[" & index & "]	=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,																		duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 5 and len(path) + len(file) + 3 <= 8 then
			BinaryStream.WriteText paybackKillSoundPackTable & "[" & index & "]	=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,																	duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 9 and len(path) + len(file) + 3 <= 12 then
			BinaryStream.WriteText paybackKillSoundPackTable & "[" & index & "]	=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,																duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 13 and len(path) + len(file) + 3 <= 16 then
			BinaryStream.WriteText paybackKillSoundPackTable & "[" & index & "]	=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,															duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 17 and len(path) + len(file) + 3 <= 20 then
			BinaryStream.WriteText paybackKillSoundPackTable & "[" & index & "]	=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,														duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 21 and len(path) + len(file) + 3 <= 24 then
			BinaryStream.WriteText paybackKillSoundPackTable & "[" & index & "]	=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,													duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 25 and len(path) + len(file) + 3 <= 28 then
			BinaryStream.WriteText paybackKillSoundPackTable & "[" & index & "]	=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,												duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 29 and len(path) + len(file) + 3 <= 32 then
			BinaryStream.WriteText paybackKillSoundPackTable & "[" & index & "]	=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,											duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 33 and len(path) + len(file) + 3 <= 36 then
			BinaryStream.WriteText paybackKillSoundPackTable & "[" & index & "]	=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,										duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 37 and len(path) + len(file) + 3 <= 40 then
			BinaryStream.WriteText paybackKillSoundPackTable & "[" & index & "]	=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,									duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 41 and len(path) + len(file) + 3 <= 44 then
			BinaryStream.WriteText paybackKillSoundPackTable & "[" & index & "]	=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,								duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 45 and len(path) + len(file) + 3 <= 48 then
			BinaryStream.WriteText paybackKillSoundPackTable & "[" & index & "]	=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,							duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 49 and len(path) + len(file) + 3 <= 52 then
			BinaryStream.WriteText paybackKillSoundPackTable & "[" & index & "]	=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,						duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 53 and len(path) + len(file) + 3 <= 56 then
			BinaryStream.WriteText paybackKillSoundPackTable & "[" & index & "]	=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,					duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 57 and len(path) + len(file) + 3 <= 60 then
			BinaryStream.WriteText paybackKillSoundPackTable & "[" & index & "]	=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,				duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 61 and len(path) + len(file) + 3 <= 64 then
			BinaryStream.WriteText paybackKillSoundPackTable & "[" & index & "]	=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,			duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 65 and len(path) + len(file) + 3 <= 68 then
			BinaryStream.WriteText paybackKillSoundPackTable & "[" & index & "]	=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,		duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		else
			BinaryStream.WriteText paybackKillSoundPackTable & "[" & index & "]	=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,	duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		end if
	elseif folder = "Test" then
		if len(path) + len(file) + 3 >= 0 and len(path) + len(file) + 3 <= 4 then
			BinaryStream.WriteText testSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,																			duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 5 and len(path) + len(file) + 3 <= 8 then
			BinaryStream.WriteText testSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,																		duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 9 and len(path) + len(file) + 3 <= 12 then
			BinaryStream.WriteText testSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,																	duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 13 and len(path) + len(file) + 3 <= 16 then
			BinaryStream.WriteText testSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,																duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 17 and len(path) + len(file) + 3 <= 20 then
			BinaryStream.WriteText testSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,															duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 21 and len(path) + len(file) + 3 <= 24 then
			BinaryStream.WriteText testSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,														duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 25 and len(path) + len(file) + 3 <= 28 then
			BinaryStream.WriteText testSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,													duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 29 and len(path) + len(file) + 3 <= 32 then
			BinaryStream.WriteText testSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,												duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 33 and len(path) + len(file) + 3 <= 36 then
			BinaryStream.WriteText testSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,											duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 37 and len(path) + len(file) + 3 <= 40 then
			BinaryStream.WriteText testSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,										duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 41 and len(path) + len(file) + 3 <= 44 then
			BinaryStream.WriteText testSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,									duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 45 and len(path) + len(file) + 3 <= 48 then
			BinaryStream.WriteText testSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,								duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 49 and len(path) + len(file) + 3 <= 52 then
			BinaryStream.WriteText testSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,							duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 53 and len(path) + len(file) + 3 <= 56 then
			BinaryStream.WriteText testSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,						duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 57 and len(path) + len(file) + 3 <= 60 then
			BinaryStream.WriteText testSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,					duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 61 and len(path) + len(file) + 3 <= 64 then
			BinaryStream.WriteText testSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,				duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 65 and len(path) + len(file) + 3 <= 68 then
			BinaryStream.WriteText testSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,			duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		elseif len(path) + len(file) + 3 >= 69 and len(path) + len(file) + 3 <= 72 then
			BinaryStream.WriteText testSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,		duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		else
			BinaryStream.WriteText testSoundPackTable & "[" & index & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """, name = """ & file & """,	duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
		end if
	else
		if number < 100 then
			if len(path) + 2 >= 0 and len(path) + 2 <= 4 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]				=	{ dir = """ & realtiveSoundFolder & "" & path & """,																					duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 5 and len(path) + 2 <= 8 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]				=	{ dir = """ & realtiveSoundFolder & "" & path & """,																				duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 9 and len(path) + 2 <= 12 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]				=	{ dir = """ & realtiveSoundFolder & "" & path & """,																			duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 13 and len(path) + 2 <= 16 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]				=	{ dir = """ & realtiveSoundFolder & "" & path & """,																		duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 17 and len(path) + 2 <= 20 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]				=	{ dir = """ & realtiveSoundFolder & "" & path & """,																	duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 21 and len(path) + 2 <= 24 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]				=	{ dir = """ & realtiveSoundFolder & "" & path & """,																duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 25 and len(path) + 2 <= 28 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]				=	{ dir = """ & realtiveSoundFolder & "" & path & """,															duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 29 and len(path) + 2 <= 32 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]				=	{ dir = """ & realtiveSoundFolder & "" & path & """,														duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 33 and len(path) + 2 <= 36 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]				=	{ dir = """ & realtiveSoundFolder & "" & path & """,													duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 37 and len(path) + 2 <= 40 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]				=	{ dir = """ & realtiveSoundFolder & "" & path & """,												duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 41 and len(path) + 2 <= 44 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]				=	{ dir = """ & realtiveSoundFolder & "" & path & """,											duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 45 and len(path) + 2 <= 48 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]				=	{ dir = """ & realtiveSoundFolder & "" & path & """,										duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 49 and len(path) + 2 <= 52 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]				=	{ dir = """ & realtiveSoundFolder & "" & path & """,									duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 53 and len(path) + 2 <= 56 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]				=	{ dir = """ & realtiveSoundFolder & "" & path & """,								duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 57 and len(path) + 2 <= 60 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]				=	{ dir = """ & realtiveSoundFolder & "" & path & """,							duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 61 and len(path) + 2 <= 64 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]				=	{ dir = """ & realtiveSoundFolder & "" & path & """,						duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 65 and len(path) + 2 <= 68 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]				=	{ dir = """ & realtiveSoundFolder & "" & path & """,					duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 69 and len(path) + 2 <= 72 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]				=	{ dir = """ & realtiveSoundFolder & "" & path & """,				duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 73 and len(path) + 2 <= 76 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]				=	{ dir = """ & realtiveSoundFolder & "" & path & """,			duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 77 and len(path) + 2 <= 80 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]				=	{ dir = """ & realtiveSoundFolder & "" & path & """,		duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			else
				BinaryStream.WriteText soundPackTable & "[" & number & "]				=	{ dir = """ & realtiveSoundFolder & "" & path & """,	duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			end if
		elseif number >= 100 then
			if len(path) + 2 >= 0 and len(path) + 2 <= 4 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """,																					duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 5 and len(path) + 2 <= 8 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """,																				duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 9 and len(path) + 2 <= 12 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """,																			duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 13 and len(path) + 2 <= 16 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """,																		duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 17 and len(path) + 2 <= 20 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """,																	duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 21 and len(path) + 2 <= 24 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """,																duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 25 and len(path) + 2 <= 28 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """,															duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 29 and len(path) + 2 <= 32 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """,														duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 33 and len(path) + 2 <= 36 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """,													duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 37 and len(path) + 2 <= 40 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """,												duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 41 and len(path) + 2 <= 44 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """,											duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 45 and len(path) + 2 <= 48 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """,										duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 49 and len(path) + 2 <= 52 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """,									duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 53 and len(path) + 2 <= 56 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """,								duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 57 and len(path) + 2 <= 60 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """,							duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 61 and len(path) + 2 <= 64 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """,						duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 65 and len(path) + 2 <= 68 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """,					duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 69 and len(path) + 2 <= 72 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """,				duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 73 and len(path) + 2 <= 76 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """,			duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			elseif len(path) + 2 >= 77 and len(path) + 2 <= 80 then
				BinaryStream.WriteText soundPackTable & "[" & number & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """,		duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			else
				BinaryStream.WriteText soundPackTable & "[" & number & "]			=	{ dir = """ & realtiveSoundFolder & "" & path & """,	duration = " & timesec & "." & timemillisec & " }" & Vbcrlf
			end if
		end if
	end if
end function

set BinaryStream = nothing
set objFolder = nothing
set folder = nothing
set objShell = nothing
set objFSO = nothing
