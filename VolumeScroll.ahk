#NoEnv
#Persistent, On
#SingleInstance, Force
#WinActivateForce
#NoTrayIcon
SetWinDelay,0
SetKeyDelay,0

CoordMode,Mouse,Screen
DetectHiddenWindows, On
SetTitleMatchMode, 2

; Modeled after Volume Control from 7plus: https://code.google.com/p/7plus/ and http://www.autohotkey.com/forum/topic56419-15.html
; Customized to use top of screen and taskbar instead of hotkey

Inc := 2
SetTimer, CheckMouse, 50
Return

CheckMouse:
	MouseGetPos, mx, my
	top := (my <= GetTopOfCurrentMon()) ? 1 : 0
Return

MouseIsOver(WinTitle)
{
	MouseGetPos,,, Win
	return WinExist(WinTitle . " ahk_id " . Win)
}

ShowVol(vol)
{
	VA_SetMasterVolume(vol)

	If (vol < 1)
		VolumeNotifyID := Notify("Volume 0%","",-2,"PG=100 PW=250 GC=555555 SI=0 SC=0 ST=0 TC=White MC=White TF=Segoe UI AC=ToggleMute PB=767676 GR=0", 220)
	Else
		VolumeNotifyID := Notify("Volume " . vol . "%","",-2,"PG=100 PW=250 GC=555555 SI=0 SC=0 ST=0 TC=White MC=White TF=Segoe UI AC=ToggleMute PB=767676 GR=0", A_ScriptDir "\lib\speaker.ico")

	Notify("","",VA_GetMasterVolume(),"Progress",VolumeNotifyID)
}

GetTopOfCurrentMon()
{
	SysGet, MonitorCount, MonitorCount
	Monitors := {}
	Loop %MonitorCount%
	{
		SysGet, Mon%A_Index%, Monitor, %A_Index%
		RightVal := Mon%A_Index%Right
		TopVal := Mon%A_index%Top
		Monitors[A_Index] := new MonitorCoords(A_Index, TopVal, RightVal)
	}

	MouseGetPos, x, y
	SortedMons := SortMons(Monitors)
	for key, value in SortedMons
	{
		if (x <= value.Right)
			return value.Top
	}

}

SortMons(Arr) 
{
	t := Object()
	for k, v in Arr
		t[RegExReplace(v.Right,"\s")]:=v
	for k, v in t
		Arr[A_Index]:=v
	return Arr
}

class MonitorCoords
{
	__New(num, coordTop, coordRight)
	{
		this.Index := num
		this.Top := coordTop
		this.Right := coordRight
	}
}

#If top or MouseIsOver("ahk_class Shell_TrayWnd")
	WheelUp::
		Volume := Round(VA_GetMasterVolume() + Inc)
		ShowVol(Volume)
	Return

	~WheelDown::
		Volume := Round(VA_GetMasterVolume() - Inc)
		ShowVol(Volume)
	Return
#If
