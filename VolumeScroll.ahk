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

Edge := 0  ; Top of Screen
Inc := 2
SetTimer, CheckMouse, 50
Return

CheckMouse:
	MouseGetPos, mx, my
	top := (my <= Edge) ? 1 : 0
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
		VolumeNotifyID := Notify("Volume 0%","",-2,"PG=100 PW=250 GC=555555 SI=0 SC=0 ST=0 TC=White MC=White TF=Segoe UI AC=ToggleMute", 220)
	Else
		VolumeNotifyID := Notify("Volume " . vol . "%","",-2,"PG=100 PW=250 GC=555555 SI=0 SC=0 ST=0 TC=White MC=White TF=Segoe UI AC=ToggleMute", 169)
	
	Notify("","",VA_GetMasterVolume(),"Progress",VolumeNotifyID)
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