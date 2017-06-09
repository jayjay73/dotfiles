#include <Misc.au3>
#include <WinAPISys.au3>


While True

	$hwnd_vim= WinWaitActive("[REGEXPCLASS:KiTTY.*|WindowsForms10.*app.0.2bf8098_r13_ad1]")
	$keyboard_layout=_WinAPI_GetKeyboardLayout($hwnd_vim)
	if ( Hex($keyboard_layout, 4) <> "0409") Then
		;if _IsPressed (11) Then
		;	MsgBox(0, "hurray", "Keyboard: " & Hex($keyboard_layout, 4))
		;EndIf
		_WinAPI_SetKeyboardLayout($hwnd_vim, "0x0409")
	EndIf
	$title= WinGetTitle("[ACTIVE]")
	;MsgBox(0, "hurray", "Vim gefunden: " & $title)
	If (StringInStr($title, "vimhelp")) Then
		$pos= StringInStr($title, "vimhelp")
		$title_part=StringMid($title, $pos)
		$ar= StringSplit($title_part, " ")
		$keyword=$ar[2]
		;MsgBox(0, "hurray", "Vim gefunden: " & $keyword & "Keyboard: " & $keyboard_layout)
		;ShellExecute("Firefox", "http://jjaeger.fastmail.fm/" & $keyword & ".html")
		ShellExecute("Firefox", $keyword)
		Sleep(20)
		WinActivate($hwnd_vim)
	EndIf
	Sleep(100)

WEnd


; =====================================================================
