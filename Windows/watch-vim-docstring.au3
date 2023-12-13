#include <Misc.au3>
#include <WinAPISys.au3>

While True
	While True
		$hwnd_vim= WinActive("[REGEXPCLASS:KiTTY.*]")
		If $hwnd_vim <> 0 Then ExitLoop
		$hwnd_vim= WinActive("[REGEXPCLASS:ConsoleWindowClass.*]")
		If $hwnd_vim <> 0 Then ExitLoop
		$hwnd_vim= WinActive("[REGEXPCLASS:Vim.*]")
		If $hwnd_vim <> 0 Then ExitLoop

		Sleep(100)
	WEnd

;~ 	$keyboard_layout=_WinAPI_GetKeyboardLayout($hwnd_vim)
;~ 	if ( Hex($keyboard_layout, 4) <> "0409") Then
;~ 	;	;if _IsPressed (11) Then
;~ 	;	;	MsgBox(0, "hurray", "Keyboard: " & Hex($keyboard_layout, 4))
;~ 	;	;EndIf
;~ 		_WinAPI_SetKeyboardLayout($hwnd_vim, "0x0409")
;~ 	EndIf
	$title= WinGetTitle("[LAST]")
	;MsgBox(0, "hurray", "Vim gefunden: " & $title)
	If (StringInStr($title, "vimhelp")) Then
		$pos= StringInStr($title, "vimhelp")
		$end= StringInStr($title, "]")
		$title_part=StringMid($title, $pos, $end-$pos)
		;MsgBox(0, "title", $title)
		$ar= StringSplit($title_part, " ")
		$keyword=$ar[2]
		;MsgBox(0, "hurray", "Vim gefunden: " & $keyword & "Keyboard: " & $keyboard_layout)
		;ShellExecute("Firefox", "http://jjaeger.fastmail.fm/" & $keyword & ".html")
		ShellExecute("Firefox", $keyword)
		;MsgBox(0, "search string", $keyword)
		Sleep(20)
		WinActivate($hwnd_vim)
	EndIf
	Sleep(1000)

WEnd


; =====================================================================
