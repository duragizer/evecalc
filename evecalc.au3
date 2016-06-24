#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=C:\Users\Marcus\Dropbox\au3\frmEve.kxf
$Form1 = GUICreate("Eve Calculator", 321, 177, 674, 378)
GUISetBkColor(0x101010)
$lblTime = GUICtrlCreateLabel("0", 8, 24, 100, 33)
GUICtrlSetFont(-1, 20, 800, 0, "Eve Sans")
GUICtrlSetColor(-1, 0xFFFFFF)
$lblCMined = GUICtrlCreateLabel("0", 8, 80, 100, 33)
GUICtrlSetFont(-1, 20, 800, 0, "Eve Sans")
GUICtrlSetColor(-1, 0xFFFFFF)
$inpOre = GUICtrlCreateInput("1278", 128, 24, 57, 25)
GUICtrlSetBkColor(-1, 0x101010)
GUICtrlSetFont(-1, 10, 800, 0, "Eve Sans")
GUICtrlSetColor(-1, 0xFFFFFF)
$inpTime = GUICtrlCreateInput("131", 128, 72, 57, 25)
GUICtrlSetBkColor(-1, 0x101010)
GUICtrlSetFont(-1, 10, 800, 0, "Eve Sans")
GUICtrlSetColor(-1, 0xFFFFFF)
$inpSize = GUICtrlCreateInput("0.35", 128, 120, 57, 25)
GUICtrlSetBkColor(-1, 0x101010)
GUICtrlSetFont(-1, 10, 800, 0, "Eve Sans")
GUICtrlSetColor(-1, 0xFFFFFF)
$Label1 = GUICtrlCreateLabel("Timer:", 8, 8, 38, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Eve Sans")
GUICtrlSetColor(-1, 0xFFFFFF)
$Label2 = GUICtrlCreateLabel("Total m3 mined:", 8, 64, 101, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Eve Sans")
GUICtrlSetColor(-1, 0xFFFFFF)
$lblOMined = GUICtrlCreateLabel("0", 8, 136, 100, 33)
GUICtrlSetFont(-1, 20, 800, 0, "Eve Sans")
GUICtrlSetColor(-1, 0xFFFFFF)
$Label4 = GUICtrlCreateLabel("Total Ore Mined:", 8, 120, 102, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Eve Sans")
GUICtrlSetColor(-1, 0xFFFFFF)
$Label3 = GUICtrlCreateLabel("m3 per cycle:", 128, 8, 87, 16)
GUICtrlSetFont(-1, 10, 400, 0, "Eve Sans")
GUICtrlSetColor(-1, 0xFFFFFF)
$Label5 = GUICtrlCreateLabel("Cycle time:", 128, 56, 70, 16)
GUICtrlSetFont(-1, 10, 400, 0, "Eve Sans")
GUICtrlSetColor(-1, 0xFFFFFF)
$Label6 = GUICtrlCreateLabel("Ore size m3:", 128, 104, 83, 16)
GUICtrlSetFont(-1, 10, 400, 0, "Eve Sans")
GUICtrlSetColor(-1, 0xFFFFFF)
$Label7 = GUICtrlCreateLabel("Hotkey:", 231, 44, 47, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Eve Sans")
GUICtrlSetColor(-1, 0xFFFFFF)
$inpHotkey = GUICtrlCreateInput("§", 280, 40, 33, 25, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
GUICtrlSetBkColor(-1, 0x101010)
GUICtrlSetFont(-1, 10, 800, 0, "Eve Sans")
GUICtrlSetColor(-1, 0xFFFFFF)
$Label8 = GUICtrlCreateLabel("# Lasers:", 223, 12, 64, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Eve Sans")
GUICtrlSetColor(-1, 0xFFFFFF)
$inpLasers = GUICtrlCreateInput("3", 288, 8, 25, 25, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
GUICtrlSetBkColor(-1, 0x101010)
GUICtrlSetFont(-1, 10, 800, 0, "Eve Sans")
GUICtrlSetColor(-1, 0xFFFFFF)
GUISetState(@SW_SHOW)
WinSetOnTop($Form1, "", True)
#EndRegion ### END Koda GUI section ###

Global $guitimer = TimerInit(), $ctimer = 0, $active = False, $persec = 0, $totalore = 0, $totalcubic = 0

_setting("read")

HotKeySet(GUICtrlRead($inpHotkey), "_active")

$persec = GUICtrlRead($inpOre) / GUICtrlRead($inpTime)
$ctimer = TimerInit()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			_setting("write")
			Exit
	EndSwitch
	If TimerDiff($guitimer) > 250 Then
		If $active Then _counter()
		$guitimer = TimerInit()
	EndIf
WEnd

Func _active()
	If $active Then
		$active = False
	Else
		$persec = GUICtrlRead($inpOre) / GUICtrlRead($inpTime)
		$ctimer = TimerInit()
		$active = True
	EndIf
EndFunc   ;==>_active

Func _counter()
	$totalcubic = ($persec * (TimerDiff($ctimer) / 1000))*3
	$totalore = $totalcubic / GUICtrlRead($inpSize)
	GUICtrlSetData($lblTime, Floor(TimerDiff($ctimer) / 1000))
	GUICtrlSetData($lblCMined, Floor($totalcubic))
	GUICtrlSetData($lblOMined, Floor($totalore))
EndFunc   ;==>_counter

Func _setting($val)
	$fIni = @ScriptDir & "\evecalc.ini"
;~ 	IniRead
	If $val = "read" Then
		GUICtrlSetData($inpHotkey, IniRead($fIni, "Settings", "hotkey", ""))
		GUICtrlSetData($inpSize, IniRead($fIni, "Settings", "oresize", ""))
		GUICtrlSetData($inpTime, IniRead($fIni, "Settings", "cycletime", ""))
		GUICtrlSetData($inpOre, IniRead($fIni, "Settings", "cyclem3", ""))
		GUICtrlSetData($inpLasers, IniRead($fIni, "Settings", "lasers", ""))
	EndIf

	If $val = "write" Then
		IniWrite($fIni, "Settings", "hotkey", GUICtrlRead($inpHotkey))
		IniWrite($fIni, "Settings", "oresize", GUICtrlRead($inpSize))
		IniWrite($fIni, "Settings", "cycletime", GUICtrlRead($inpTime))
		IniWrite($fIni, "Settings", "cyclem3", GUICtrlRead($inpOre))
		IniWrite($fIni, "Settings", "lasers", GUICtrlRead($inpLasers))
	EndIf
EndFunc