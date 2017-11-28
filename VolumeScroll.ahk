#NoEnv
#Persistent, On
#SingleInstance, Force
#WinActivateForce
#NoTrayIcon

DetectHiddenWindows, On
SetTitleMatchMode, 2

MouseIsOver(WinTitle)
{
	MouseGetPos,,, Win
	return WinExist(WinTitle . " ahk_id " . Win)
}

#If MouseIsOver("ahk_class Shell_TrayWnd")
	WheelUp::Send, {Volume_Up}
	WheelDown::Send, {Volume_Down}
#If
