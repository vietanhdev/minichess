#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <FileConstants.au3>
#include <File.au3>
#include <Constants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPI.au3>


#NoTrayIcon


Const $emptyp = @ScriptDir & "\Images\board\empty.bmp"
Const $pic_setting = @ScriptDir & "\Images\buttons\setting.bmp"
Const $pic_new = @ScriptDir & "\Images\buttons\new.bmp"
Const $pic_save = @ScriptDir & "\Images\buttons\save.bmp"
Const $pic_load = @ScriptDir & "\Images\buttons\load.bmp"
Const $pic_undo = @ScriptDir & "\Images\buttons\undo.bmp"
Const $pic_resign = @ScriptDir & "\Images\buttons\resign.bmp"
Const $pic_nw = @ScriptDir & "\Images\board\n1.bmp"
Const $pic_cw = @ScriptDir & "\Images\board\c1.bmp"
Const $pic_nb = @ScriptDir & "\Images\board\n2.bmp"
Const $pic_cb = @ScriptDir & "\Images\board\c2.bmp"
Const $pic_board = @ScriptDir & "\Images\board\board.bmp"
Const $pic_info = @ScriptDir & "\Images\info.bmp"
Const $Pic_Aboutme = @ScriptDir & "\Images\miniChess.bmp"



Global $Player_color
Const $fen_play_white = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
$fen_play_black = "RNBKQBNR/PPPPPPPP/8/8/8/8/pppppppp/rnbkqbnr w KQkq - 0 1"
Global $fenboard[65] = [0, 57, 58, 59, 60, 61, 62, 63, 64, 49, 50, 51, 52, 53, 54, 55, 56, 41, 42, 43, 44, 45, 46, 47, 48, 33, 34, 35, 36, 37, 38, 39, 40, 25, 26, 27, 28, 29, 30, 31, 32, 17, 18, 19, 20, 21, 22, 23, 24, 9, 10, 11, 12, 13, 14, 15, 16, 1, 2, 3, 4, 5, 6, 7, 8]
Global $fen, $movenext, $Castling, $En_passant, $Halfmove_clock, $Fullmove_number






Global $MainForm
Global $pic_n, $pic_c

Global $Board[65], $p[65]
Global $Board120[121] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 0, 0, 9, 10, 11, 12, 13, 14, 15, 16, 0, 0, 17, 18, 19, 20, 21, 22, 23, 24, 0, 0, 25, 26, 27, 28, 29, 30, 31, 32, 0, 0, 33, 34, 35, 36, 37, 38, 39, 40, 0, 0, 41, 42, 43, 44, 45, 46, 47, 48, 0, 0, 49, 50, 51, 52, 53, 54, 55, 56, 0, 0, 57, 58, 59, 60, 61, 62, 63, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $to120[65] = [0, 22, 23, 24, 25, 26, 27, 28, 29, 32, 33, 34, 35, 36, 37, 38, 39, 42, 43, 44, 45, 46, 47, 48, 49, 52, 53, 54, 55, 56, 57, 58, 59, 62, 63, 64, 65, 66, 67, 68, 69, 72, 73, 74, 75, 76, 77, 78, 79, 82, 83, 84, 85, 86, 87, 88, 89, 92, 93, 94, 95, 96, 97, 98, 99]
;Dùng chuyển ô từ bàn 64 sang 120
Global $old_Board[65] ;Dùng cho hàm undo()
Global $board_color[65] = [0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1]
Global $Selected, $StatusBar
Global $cBoard[65]
Global $wcBoard[65] = ["", "a1", "b1", "c1", "d1", "e1", "f1", "g1", "h1", "a2", "b2", "c2", "d2", "e2", "f2", "g2", "h2", "a3", "b3", "c3", "d3", "e3", "f3", "g3", "h3", "a4", "b4", "c4", "d4", "e4", "f4", "g4", "h4", "a5", "b5", "c5", "d5", "e5", "f5", "g5", "h5", "a6", "b6", "c6", "d6", "e6", "f6", "g6", "h6", "a7", "b7", "c7", "d7", "e7", "f7", "g7", "h7", "a8", "b8", "c8", "d8", "e8", "f8", "g8", "h8"]
Global $bcBoard[65] = ["", "h8", "g8", "f8", "e8", "d8", "c8", "b8", "a8", "h7", "g7", "f7", "e7", "d7", "c7", "b7", "a7", "h6", "g6", "f6", "e6", "d6", "c6", "b6", "a6", "h5", "g5", "f5", "e5", "d5", "c5", "b5", "a5", "h4", "g4", "f4", "e4", "d4", "c4", "b4", "a4", "h3", "g3", "f3", "e3", "d3", "c3", "b3", "a3", "h2", "g2", "f2", "e2", "d2", "c2", "b2", "a2", "h1", "g1", "f1", "e1", "d1", "c1", "b1", "a1"]
Global $moves[1]
Global $undook ;Xác định có được đi lại nữa không

Global $tmpBoard[65] ;<< Dùng lưu trữ bàn tạm thời , Hàm : tmp_makemove,tmp_unmakemove

Global $movegen_to[1]
Global $movegen_from[1]

Global $engine, $dataread, $connected = False
Global $time_to_moves = 1000
Global $next_promotion_piece


;~ Kết nối engine
If Not IsDeclared("sToolTipAnswer") Then
	Local $sToolTipAnswer
	$sToolTipAnswer = ToolTip("miniChess đang kết nối với engine ... Chờ chút nhé !! ..." & @CRLF & "Cảm ơn đã sử dụng miniChess !!" & @CRLF & @CRLF & @CRLF & @CRLF & @CRLF & @CRLF, 0, 0, "miniChess", 1, 0)
EndIf

engine_connect()
ToolTip("")
If Not $connected Then
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(262192, "miniChess", "Xin lỗi bạn, miniChess không thể kết nối với engine...  " & @CRLF & "Bạn có thể chạy lại miniChess hoặc liên hệ trợ giúp", 10)
	Select
		Case $iMsgBoxAnswer = -1 ;Timeout
			Exit
	EndSelect
EndIf
;~ Kết nối engine



;~ Giao tiếp engine
Func get_last_line()
	Local $line
	$line = ""
	$dataread &= StdoutRead($engine)
	While $dataread <> ""
		$line = StringRight($dataread, 1) & $line
		$dataread = StringTrimRight($dataread, 1)
		If StringRight($dataread, 1) = @LF Then
			ExitLoop (1)
		EndIf
	WEnd
	$line = StringTrimRight($line, 2)
	$dataread = ""
	Return $line
EndFunc   ;==>get_last_line
Func engine_connect()
	Local $i, $line, $result
	If $connected = False Or ProcessExists("engine.exe") = 0 Then
		If $engine = 0 Or ProcessExists("engine.exe") = 0 Then
			$engine = Run("engine.exe", @SystemDir, @SW_HIDE, $STDIN_CHILD + $STDOUT_CHILD)
		EndIf
		Sleep(100)
		ProcessWait("engine.exe", 5)
		If ProcessExists("engine.exe") = 0 Then
			$result = False
		Else
			StdinWrite($engine, "uci" & @CRLF)
			For $i = 1 To 30
				$line = get_last_line()
				If $line == "uciok" Then
					$result = True
					ExitLoop (1)
				EndIf
				Sleep(100)
			Next
		EndIf
	EndIf
	If $result Then
		$connected = True
	EndIf
	Return $result
EndFunc   ;==>engine_connect
Func readyok()
	Local $result, $i, $line
	$result = False
	If $connected Then
		StdinWrite($engine, "isready" & @CRLF)
		For $i = 1 To 30
			$line = get_last_line()
			If $line == "readyok" Then
				$result = True
				ExitLoop (1)
			EndIf
			Sleep(100)
		Next
		Return $result
	EndIf
EndFunc   ;==>readyok
Func engine_get_move()
	Local $i
	Local $s, $ss
	Local $startpos, $moves_to_send


;~ 	If $Player_color="w" Then
;~ 		$startpos = $fen_play_white
;~ 	Else
;~ 		$startpos = $fen_play_black
;~ 	EndIf

	$startpos = "startpos"
	$moves_to_send = ""
	If UBound($moves) > 1 Then
		$moves_to_send = "moves"
		For $i = 1 To UBound($moves) - 1
			$moves_to_send &= " " & $moves[$i]
		Next
	EndIf

	If $moves_to_send <> "" Then
		$moves_to_send = " " & $moves_to_send
	EndIf

	StdinWrite($engine, "position " & $startpos & $moves_to_send & @CRLF & "go movetime " & $time_to_moves & @CRLF)
	Sleep($time_to_moves + 100)
	For $i = 1 To 50
		$line = get_last_line()
		$ss = StringSplit($line, " ")
		If $ss[1] == "bestmove" Then
			ExitLoop (1)
		EndIf
		Sleep(100)
	Next

	Return $ss[2]
EndFunc   ;==>engine_get_move



Func win()
	MsgBox(0, "miniChess", "Bạn thắng rồi !! :D ")
EndFunc   ;==>win
Func lost()
	MsgBox(0, "miniChess", "Oh ... Bạn thua rồi . . .")
EndFunc   ;==>lost
Func drawn()
	MsgBox(0, "miniChess", "Kết quả: Hoà. Cảm ơn bạn đã chơi cùng tôi !!")
EndFunc   ;==>drawn



Func referee() ;Trọng tài : Quyết định kết quả trận đấu
	Switch CheckMate()
		Case 1
			win()
		Case 2
			lost()
		Case 3
			drawn()
		Case Else
			If $movenext = Opp_site($Player_color) Then
				mini_move()
			EndIf
	EndSwitch
	Status(" Cùng chơi vui với miniChess !! :D ")
EndFunc   ;==>referee




;~ Kiểm tra sự kiểm soát 1 ô của máy
Func CastlingCtrlCheck($checkingpos, $color) ;Trả về "false" máy k kiểm soát ô $checkingpos, "true" nếu máy đang kiểm soát ô $checkingpos
	;$color dùng xác định bên kiểm soát
	Local $i
	Local $oqueen, $orook, $oknight, $obishop, $opawn, $oking
	If $color = "w" Then
		$oqueen = "Q"
		$orook = "R"
		$oknight = "N"
		$obishop = "B"
		$opawn = "P"
		$oking = "K"
	Else
		$oqueen = "Q"
		$orook = "R"
		$oknight = "N"
		$obishop = "B"
		$opawn = "P"
		$oking = "K"
	EndIf
	$checkingpos = $to120[$checkingpos]
;~ Kiểm tra quân tịnh + Hậu chéo
	$i = $checkingpos + 11
	While $Board120[$i] <> 0 And color($Board[$Board120[$i]]) <> $color
		If $Board[$Board120[$i]] == $oqueen Or $Board[$Board120[$i]] == $obishop Then
			Return True
		ElseIf $Board[$Board120[$i]] <> "0" Then
			ExitLoop (1)
		EndIf
		$i = $i + 11
	WEnd
	$i = $checkingpos - 11
	While $Board120[$i] <> 0 And color($Board[$Board120[$i]]) <> $color
		If $Board[$Board120[$i]] == $oqueen Or $Board[$Board120[$i]] == $obishop Then
			Return True
		ElseIf $Board[$Board120[$i]] <> "0" Then
			ExitLoop (1)
		EndIf
		$i = $i - 11
	WEnd
	$i = $checkingpos + 9
	While $Board120[$i] <> 0 And color($Board[$Board120[$i]]) <> $color
		If $Board[$Board120[$i]] == $oqueen Or $Board[$Board120[$i]] == $obishop Then
			Return True
		ElseIf $Board[$Board120[$i]] <> "0" Then
			ExitLoop (1)
		EndIf
		$i = $i + 9
	WEnd
	$i = $checkingpos - 9
	While $Board120[$i] <> 0 And color($Board[$Board120[$i]]) <> $color
		If $Board[$Board120[$i]] == $oqueen Or $Board[$Board120[$i]] == $obishop Then
			Return True
		ElseIf $Board[$Board120[$i]] <> "0" Then
			ExitLoop (1)
		EndIf
		$i = $i - 9
	WEnd
;~ Kiểm tra quân tịnh + Hậu chéo

;~ Kiểm tra quân xe + Hậu thẳng
	$i = $checkingpos + 1
	While $Board120[$i] <> 0 And color($Board[$Board120[$i]]) <> $color
		If $Board[$Board120[$i]] = $oqueen Or $Board[$Board120[$i]] == $orook Then
			Return True
		ElseIf $Board[$Board120[$i]] <> "0" Then
			ExitLoop (1)
		EndIf
		$i = $i + 1
	WEnd
	$i = $checkingpos - 1
	While $Board120[$i] <> 0 And color($Board[$Board120[$i]]) <> $color
		If $Board[$Board120[$i]] == $oqueen Or $Board[$Board120[$i]] == $orook Then
			Return True
		ElseIf $Board[$Board120[$i]] <> "0" Then
			ExitLoop (1)
		EndIf
		$i = $i - 1
	WEnd
	$i = $checkingpos + 10
	While $Board120[$i] <> 0 And color($Board[$Board120[$i]]) <> $color
		If $Board[$Board120[$i]] == $oqueen Or $Board[$Board120[$i]] == $orook Then
			Return True
		ElseIf $Board[$Board120[$i]] <> "0" Then
			ExitLoop (1)
		EndIf
		$i = $i + 10
	WEnd
	$i = $checkingpos - 10
	While $Board120[$i] <> 0 And color($Board[$Board120[$i]]) <> $color
		If $Board[$Board120[$i]] == $oqueen Or $Board[$Board120[$i]] == $orook Then
			Return True
		ElseIf $Board[$Board120[$i]] <> "0" Then
			ExitLoop (1)
		EndIf
		$i = $i - 10
	WEnd
;~ Kiểm tra quân xe + Hậu thẳng

;~ Kiểm tra tốt
	If ($Board120[$checkingpos + 9] <> 0 And $Board[$Board120[$checkingpos + 9]] == $opawn) Or ($Board120[$checkingpos + 11] <> 0 And $Board[$Board120[$checkingpos + 11]] == $opawn) Then
		Return True
	EndIf

;~ Kiểm tra mã
	$i = $checkingpos + 12
	If ($Board120[$i] <> 0 And $Board[$Board120[$i]] == $oknight) Then
		Return True
	EndIf
	$i = $checkingpos + 21
	If ($Board120[$i] <> 0 And $Board[$Board120[$i]] == $oknight) Then
		Return True
	EndIf
	$i = $checkingpos + 19
	If ($Board120[$i] <> 0 And $Board[$Board120[$i]] == $oknight) Then
		Return True
	EndIf
	$i = $checkingpos + 8
	If ($Board120[$i] <> 0 And $Board[$Board120[$i]] == $oknight) Then
		Return True
	EndIf
	$i = $checkingpos - 12
	If ($Board120[$i] <> 0 And $Board[$Board120[$i]] == $oknight) Then
		Return True
	EndIf
	$i = $checkingpos - 21
	If ($Board120[$i] <> 0 And $Board[$Board120[$i]] == $oknight) Then
		Return True
	EndIf
	$i = $checkingpos - 19
	If ($Board120[$i] <> 0 And $Board[$Board120[$i]] == $oknight) Then
		Return True
	EndIf
	$i = $checkingpos - 8
	If ($Board120[$i] <> 0 And $Board[$Board120[$i]] == $oknight) Then
		Return True
	EndIf

;~ Kiểm tra vua
	$i = $checkingpos + 1
	If $Board120[$i] <> 0 And $Board[$Board120[$i]] == $oking Then
		Return True
	EndIf
	$i = $checkingpos - 1
	If $Board120[$i] <> 0 And $Board[$Board120[$i]] == $oking Then
		Return True
	EndIf
	$i = $checkingpos + 9
	If $Board120[$i] <> 0 And $Board[$Board120[$i]] == $oking Then
		Return True
	EndIf
	$i = $checkingpos + 10
	If $Board120[$i] <> 0 And $Board[$Board120[$i]] == $oking Then
		Return True
	EndIf
	$i = $checkingpos + 11
	If $Board120[$i] <> 0 And $Board[$Board120[$i]] == $oking Then
		Return True
	EndIf
	$i = $checkingpos - 9
	If $Board120[$i] <> 0 And $Board[$Board120[$i]] == $oking Then
		Return True
	EndIf
	$i = $checkingpos - 10
	If $Board120[$i] <> 0 And $Board[$Board120[$i]] == $oking Then
		Return True
	EndIf
	$i = $checkingpos - 11
	If $Board120[$i] <> 0 And $Board[$Board120[$i]] == $oking Then
		Return True
	EndIf


	Return False
EndFunc   ;==>CastlingCtrlCheck



;~ Sinh nước đi
Func Addgen($from, $to)
	tmp_makemove($from, $to)
	If Not Check($Player_color) Then
;~ 		MsgBox(0, 0, Check($Player_color) & " " & $Board[$to] & " " & $to)
		ReDim $movegen_from[UBound($movegen_from) + 1]
		$movegen_from[UBound($movegen_from) - 1] = $from
		ReDim $movegen_to[UBound($movegen_to) + 1]
		$movegen_to[UBound($movegen_to) - 1] = $to
	Else
	EndIf
	tmp_unmakemove()
EndFunc   ;==>Addgen


Func movegenall($color)
	Local $i
	ReDim $movegen_from[1]
	ReDim $movegen_to[1]
	For $i = 1 To 64
		movegen($i, $color)
	Next
EndFunc   ;==>movegenall

Func movegen($op, $color) ;$op là vị trí trên bàn 64
	Local $i
	Local $genBoard[121]
	Local $o = $to120[$op]
	Local $opp_color
	$opp_color = Opp_site($color)
	For $i = 1 To 120
		$genBoard[$i] = "x" ;ngoài bàn
	Next
	For $i = 1 To 64
		$genBoard[$to120[$i]] = $Board[$i]
	Next
	If color($genBoard[$o]) = $color Then
		Switch $genBoard[$o]
			Case "p" ;Tốt (gồm cả ăn chốt qua đường)
				If $color = $Player_color Then ;Kiểm tra cho người chơi
					If $genBoard[$o + 20] = "0" And $op > 8 And $op < 17 Then
						Addgen($op, $op + 16)
					EndIf
					If $genBoard[$o + 10] = "0" Then
						Addgen($op, $op + 8)
					EndIf
					If $genBoard[$o + 9] <> "x" And (color($genBoard[$o + 9]) = $opp_color Or $cBoard[$op + 9] = $En_passant) Then
						Addgen($op, $op + 7)
					EndIf
					If $genBoard[$o + 11] <> "x" And (color($genBoard[$o + 11]) = $opp_color Or $cBoard[$op + 11] = $En_passant) Then
						Addgen($op, $op + 9)
					EndIf
				Else ;Kiểm tra cho mini
					If $genBoard[$o - 20] = "0" And $op > 48 And $op < 57 Then
						Addgen($op, $op - 16)
					EndIf
					If $genBoard[$o - 10] = "0" Then
						Addgen($op, $op - 8)
					EndIf
					If $genBoard[$o - 9] <> "x" And (color($genBoard[$o - 9]) = $opp_color Or $cBoard[$op - 9] = $En_passant) Then
						Addgen($op, $op - 7)
					EndIf
					If $genBoard[$o - 11] <> "x" And (color($genBoard[$o - 11]) = $opp_color Or $cBoard[$op - 11] = $En_passant) Then
						Addgen($op, $op - 9)
					EndIf
				EndIf
			Case "n" ;Mã
				If $genBoard[$o + 8] <> "x" And color($genBoard[$o + 8]) <> $color Then
					Addgen($op, $op + 6)
				EndIf
				If $genBoard[$o + 12] <> "x" And color($genBoard[$o + 12]) <> $color Then
					Addgen($op, $op + 10)
				EndIf
				If $genBoard[$o + 19] <> "x" And color($genBoard[$o + 19]) <> $color Then
					Addgen($op, $op + 15)
				EndIf
				If $genBoard[$o + 21] <> "x" And color($genBoard[$o + 21]) <> $color Then
					Addgen($op, $op + 17)
				EndIf
				If $genBoard[$o - 8] <> "x" And color($genBoard[$o - 8]) <> $color Then
					Addgen($op, $op - 6)
				EndIf
				If $genBoard[$o - 12] <> "x" And color($genBoard[$o - 12]) <> $color Then
					Addgen($op, $op - 10)
				EndIf
				If $genBoard[$o - 19] <> "x" And color($genBoard[$o - 19]) <> $color Then
					Addgen($op, $op - 15)
				EndIf
				If $genBoard[$o - 21] <> "x" And color($genBoard[$o - 21]) <> $color Then
					Addgen($op, $op - 17)
				EndIf
			Case "k" ;vua
				If color($genBoard[$o + 9]) <> $color Then
					Addgen($op, $op + 7)
				EndIf
				If color($genBoard[$o + 10]) <> $color Then
					Addgen($op, $op + 8)
				EndIf
				If color($genBoard[$o + 11]) <> $color Then
					Addgen($op, $op + 9)
				EndIf
				If color($genBoard[$o + 1]) <> $color Then
					Addgen($op, $op + 1)
				EndIf
				If color($genBoard[$o - 9]) <> $color Then
					Addgen($op, $op - 7)
				EndIf
				If color($genBoard[$o - 10]) <> $color Then
					Addgen($op, $op - 8)
				EndIf
				If color($genBoard[$o - 11]) <> $color Then
					Addgen($op, $op - 9)
				EndIf
				If color($genBoard[$o - 1]) <> $color Then
					Addgen($op, $op - 1)
				EndIf
				;Nhập thành
				If Not Check($color) Then
					If $color = "w" Then
						Local $wks, $wqs, $c
						For $i = 1 To StringLen($Castling)
							$c = StringMid($Castling, $i, 1)
							Switch $c
								Case $c == "K"
									$wks = "K"
								Case $c == "Q"
									$wqs = "Q"
							EndSwitch
						Next
;~ 								MsgBox(0,"Castling",$Castling)
;~ 								MsgBox(0,0,"kiểm tra nhập thành"&" "&$Board[char_to_o("f1")]&" "&(not CastlingCtrlCheck(char_to_o("f1")))&" "&(not CastlingCtrlCheck(char_to_o("g1"))))
						If $wks = "K" And $Board[char_to_o("f1")] = "0" And $Board[char_to_o("g1")] = "0" And (Not CastlingCtrlCheck(char_to_o("f1"), $opp_color)) And (Not CastlingCtrlCheck(char_to_o("g1"), $opp_color)) Then
							Addgen(char_to_o("e1"), char_to_o("g1"))
						EndIf
						If $wqs = "Q" And $Board[char_to_o("b1")] = "0" And $Board[char_to_o("c1")] = "0" And $Board[char_to_o("d1")] = "0" And (Not CastlingCtrlCheck(char_to_o("b1"), $opp_color)) And (Not CastlingCtrlCheck(char_to_o("c1"), $opp_color)) And (Not CastlingCtrlCheck(char_to_o("d1"), $opp_color)) Then
							Addgen(char_to_o("e1"), char_to_o("c1"))
						EndIf

					Else ;người chơi cầm quân đen
						Local $bks, $bqs, $c
						For $i = 1 To StringLen($Castling)
							$c = StringMid($Castling, $i, 1)
							Switch $c
								Case $c == "k"
									$bks = "k"
								Case $c == "q"
									$bqs = "q"
							EndSwitch
						Next
						If $bks = "k" And $Board[char_to_o("f8")] = "0" And $Board[char_to_o("g8")] = "0" And (Not CastlingCtrlCheck(char_to_o("f8"), $opp_color)) And (Not CastlingCtrlCheck(char_to_o("g8"), $opp_color)) Then
							Addgen(char_to_o("e8"), char_to_o("g8"))
						EndIf
						If $bqs = "q" And $Board[char_to_o("b8")] = "0" And $Board[char_to_o("c8")] = "0" And $Board[char_to_o("d8")] = "0" And (Not CastlingCtrlCheck(char_to_o("b8"), $opp_color)) And (Not CastlingCtrlCheck(char_to_o("c8"), $opp_color)) And (Not CastlingCtrlCheck(char_to_o("d8"), $opp_color)) Then
							Addgen(char_to_o("e8"), char_to_o("c8"))
						EndIf
					EndIf
				EndIf
				;Nhập thành

			Case "b" ;Tịnh
;~ 				Sử dụng $genBoard kiểm tra nước đi của tịnh. Chú ý: Ngoài bàn = "x"
;~ 				$o là biến ô trong $genBoard
				Local $Next ; là biến đếm tiến ô - Kiểm tra
				$Next = $o + 11
				While $genBoard[$Next] <> "x" And color($genBoard[$Next]) <> $color
					If $genBoard[$Next] = "0" Then
						Addgen($op, $Board120[$Next])
					ElseIf color($genBoard[$Next]) = $opp_color Then
						Addgen($op, $Board120[$Next])
						ExitLoop (1)
					EndIf
					$Next += 11
				WEnd
				$Next = $o + 9
				While $genBoard[$Next] <> "x" And color($genBoard[$Next]) <> $color
					If $genBoard[$Next] = "0" Then
						Addgen($op, $Board120[$Next])
					ElseIf color($genBoard[$Next]) = $opp_color Then
						Addgen($op, $Board120[$Next])
						ExitLoop (1)
					EndIf
					$Next += 9
				WEnd
				$Next = $o - 11
				While $genBoard[$Next] <> "x" And color($genBoard[$Next]) <> $color
					If $genBoard[$Next] = "0" Then
						Addgen($op, $Board120[$Next])
					ElseIf color($genBoard[$Next]) = $opp_color Then
						Addgen($op, $Board120[$Next])
						ExitLoop (1)
					EndIf
					$Next += -11
				WEnd
				$Next = $o - 9
				While $genBoard[$Next] <> "x" And color($genBoard[$Next]) <> $color
					If $genBoard[$Next] = "0" Then
						Addgen($op, $Board120[$Next])
					ElseIf color($genBoard[$Next]) = $opp_color Then
						Addgen($op, $Board120[$Next])
						ExitLoop (1)
					EndIf
					$Next += -9
				WEnd
			Case "r" ;Xe
				Local $Next ; là biến đếm tiến ô - Kiểm tra
				$Next = $o + 1
				While $genBoard[$Next] <> "x" And color($genBoard[$Next]) <> $color
					If $genBoard[$Next] = "0" Then
						Addgen($op, $Board120[$Next])
					ElseIf color($genBoard[$Next]) = $opp_color Then
						Addgen($op, $Board120[$Next])
						ExitLoop (1)
					EndIf
					$Next += 1
				WEnd
				$Next = $o - 1
				While $genBoard[$Next] <> "x" And color($genBoard[$Next]) <> $color
					If $genBoard[$Next] = "0" Then
						Addgen($op, $Board120[$Next])
					ElseIf color($genBoard[$Next]) = $opp_color Then
						Addgen($op, $Board120[$Next])
						ExitLoop (1)
					EndIf
					$Next += -1
				WEnd
				$Next = $o + 10
				While $genBoard[$Next] <> "x" And color($genBoard[$Next]) <> $color
					If $genBoard[$Next] = "0" Then
						Addgen($op, $Board120[$Next])
					ElseIf color($genBoard[$Next]) = $opp_color Then
						Addgen($op, $Board120[$Next])
						ExitLoop (1)
					EndIf
					$Next += 10
				WEnd
				$Next = $o - 10
				While $genBoard[$Next] <> "x" And color($genBoard[$Next]) <> $color
					If $genBoard[$Next] = "0" Then
						Addgen($op, $Board120[$Next])
					ElseIf color($genBoard[$Next]) = $opp_color Then
						Addgen($op, $Board120[$Next])
						ExitLoop (1)
					EndIf
					$Next += -10
				WEnd
			Case "q" ;Hậu
				Local $Next ; là biến đếm tiến ô - Kiểm tra
				$Next = $o + 11
				While $genBoard[$Next] <> "x" And color($genBoard[$Next]) <> $color
					If $genBoard[$Next] = "0" Then
						Addgen($op, $Board120[$Next])
					ElseIf color($genBoard[$Next]) = $opp_color Then
						Addgen($op, $Board120[$Next])
						ExitLoop (1)
					EndIf
					$Next += 11
				WEnd
				$Next = $o + 9
				While $genBoard[$Next] <> "x" And color($genBoard[$Next]) <> $color
					If $genBoard[$Next] = "0" Then
						Addgen($op, $Board120[$Next])
					ElseIf color($genBoard[$Next]) = $opp_color Then
						Addgen($op, $Board120[$Next])
						ExitLoop (1)
					EndIf
					$Next += 9
				WEnd
				$Next = $o - 11
				While $genBoard[$Next] <> "x" And color($genBoard[$Next]) <> $color
					If $genBoard[$Next] = "0" Then
						Addgen($op, $Board120[$Next])
					ElseIf color($genBoard[$Next]) = $opp_color Then
						Addgen($op, $Board120[$Next])
						ExitLoop (1)
					EndIf
					$Next += -11
				WEnd
				$Next = $o - 9
				While $genBoard[$Next] <> "x" And color($genBoard[$Next]) <> $color
					If $genBoard[$Next] = "0" Then
						Addgen($op, $Board120[$Next])
					ElseIf color($genBoard[$Next]) = $opp_color Then
						Addgen($op, $Board120[$Next])
						ExitLoop (1)
					EndIf
					$Next += -9
				WEnd
				Local $Next ; là biến đếm tiến ô - Kiểm tra
				$Next = $o + 1
				While $genBoard[$Next] <> "x" And color($genBoard[$Next]) <> $color
					If $genBoard[$Next] = "0" Then
						Addgen($op, $Board120[$Next])
					ElseIf color($genBoard[$Next]) = $opp_color Then
						Addgen($op, $Board120[$Next])
						ExitLoop (1)
					EndIf
					$Next += 1
				WEnd
				$Next = $o - 1
				While $genBoard[$Next] <> "x" And color($genBoard[$Next]) <> $color
					If $genBoard[$Next] = "0" Then
						Addgen($op, $Board120[$Next])
					ElseIf color($genBoard[$Next]) = $opp_color Then
						Addgen($op, $Board120[$Next])
						ExitLoop (1)
					EndIf
					$Next += -1
				WEnd
				$Next = $o + 10
				While $genBoard[$Next] <> "x" And color($genBoard[$Next]) <> $color
					If $genBoard[$Next] = "0" Then
						Addgen($op, $Board120[$Next])
					ElseIf color($genBoard[$Next]) = $opp_color Then
						Addgen($op, $Board120[$Next])
						ExitLoop (1)
					EndIf
					$Next += 10
				WEnd
				$Next = $o - 10
				While $genBoard[$Next] <> "x" And color($genBoard[$Next]) <> $color
					If $genBoard[$Next] = "0" Then
						Addgen($op, $Board120[$Next])
					ElseIf color($genBoard[$Next]) = $opp_color Then
						Addgen($op, $Board120[$Next])
						ExitLoop (1)
					EndIf
					$Next += -10
				WEnd
		EndSwitch
	EndIf
EndFunc   ;==>movegen




Func minip($p) ; Trả về giá trị là quân tương ứng của mini
	If $Player_color = "w" Then
		Return StringLower($p)
	Else
		Return StringUpper($p)
	EndIf
EndFunc   ;==>minip
Func playerp($p) ; Trả về giá trị là quân tương ứng của người chơi
	If $Player_color = "b" Then
		Return StringLower($p)
	Else
		Return StringUpper($p)
	EndIf
EndFunc   ;==>playerp





Func tmp_unmakemove()
	Local $i
	For $i = 1 To 64
		$Board[$i] = $tmpBoard[$i]
	Next
EndFunc   ;==>tmp_unmakemove

Func tmp_makemove($from, $to) ;Hàm nay bỏ qua sự phong cấp !!!!!!!!!!!!!!!!!! - Dùng kiểm tra chiếu
	Local $promotion_piece
	For $i = 1 To 64
		$tmpBoard[$i] = $Board[$i]
	Next
	$Board[$to] = $Board[$from]
	$Board[$from] = "0"

;~ 	Xử lí nước nhập thành
;~ Vua đen -
	If $Board[$to] = "k" Then
		If $Board[$to] == "k" And $to = $from - 2 Then
			$Board[$from - 1] = "r"
			If $Board[$from - 3] = "r" Then
				$Board[$from - 3] = "0"
			Else
				If $Board[$from - 4] = "r" Then
					$Board[$from - 4] = "0"
				EndIf
			EndIf
		EndIf
;~ Vua đen +
		If $Board[$to] == "k" And $to = $from + 2 Then
			$Board[$from + 1] = "r"
			If $Board[$from + 3] = "r" Then
				$Board[$from + 3] = "0"
			Else
				If $Board[$from + 4] = "r" Then
					$Board[$from + 4] = "0"
				EndIf
			EndIf
		EndIf
;~ 	Vua trắng -
		If $Board[$to] == "K" And $to = $from - 2 Then
			$Board[$from - 1] = "R"
			If $Board[$from - 3] = "R" Then
				$Board[$from - 3] = "0"
			Else
				If $Board[$from - 4] = "R" Then
					$Board[$from - 4] = "0"
				EndIf
			EndIf
		EndIf
;~ 	Vua trắng -
		If $Board[$to] == "K" And $to = $from + 2 Then
			$Board[$from + 1] = "R"
			If $Board[$from + 3] = "R" Then
				$Board[$from + 3] = "0"
			Else
				If $Board[$from + 4] = "R" Then
					$Board[$from + 4] = "0"
				EndIf
			EndIf
		EndIf
	EndIf
;~ 	Xử lí nước nhập thành
;~ Xử lí nước ăn chốt qua đường
	If $Board[$to] = "p" And ((Mod($from - 1, 8) + 1 = 4 And Mod($to - 1, 8) + 1 = 3) Or (Mod($from - 1, 8) + 1 = 5 And Mod($to - 1, 8) + 1 = 6)) Then
		If $to = $from + 7 Or $to = $from - 7 Then
			$Board[$from - 1] = "0"
		ElseIf $to = $from + 9 Or $to = $from - 9 Then
			$Board[$from + 1] = "0"
		EndIf
	EndIf
;~ Xử lí nước ăn chốt qua đường
EndFunc   ;==>tmp_makemove


Func moveok($from, $to)
	Local $i
	movegenall(color($Board[$from]))
	For $i = 1 To UBound($movegen_from) - 1
		If $movegen_from[$i] = $from And $movegen_to[$i] = $to Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>moveok




Func CheckMate() ;Trả về 1 nếu người chơi thắng, 2 nếu người chơi thua, 0 nếu không chiếu hết, 3 nếu hoà

	If Check($Player_color) Then
		movegenall($Player_color)
		If UBound($movegen_from) = 1 Then ;Không nước đi nào hợp lệ
			Return 2 ;Người chơi thua
		EndIf
	Else
		movegenall($Player_color)
		If UBound($movegen_from) = 1 Then ;Không nước đi nào hợp lệ
			Return 3 ;Hoà
		EndIf
	EndIf

	If Check(Opp_site($Player_color)) Then
		movegenall(Opp_site($Player_color))
		If UBound($movegen_from) = 1 Then ;Không nước đi nào hợp lệ
			Return 1 ;Người chơi thắng
		EndIf
	Else
		movegenall(Opp_site($Player_color))
		If UBound($movegen_from) = 1 Then ;Không nước đi nào hợp lệ
			Return 3 ;Hoà
		EndIf
	EndIf

	Return 0 ;Ván cờ chưa kết thúc

EndFunc   ;==>CheckMate


Func Check($color) ;Trả về "false" nều không chiếu, "true" nếu đang chiếu
	Local $i
	Local $pking ;vua cần kiểm tra
	Local $kingpos
	Local $oqueen, $orook, $oknight, $obishop, $opawn, $oking

;~ Lấy giá trị các quân + ;~ Xác định vị trí vua người chơi
	If $color = "b" Then
		$oqueen = "Q"
		$orook = "R"
		$oknight = "N"
		$obishop = "B"
		$opawn = "P"
		$oking = "K"

		$pking = "k"
	Else
		$oqueen = "q"
		$orook = "r"
		$oknight = "n"
		$obishop = "b"
		$opawn = "p"
		$oking = "k"

		$pking = "K"
	EndIf
	For $i = 1 To 64
		If $Board[$i] = $pking Then
			$kingpos = $to120[$i]
			ExitLoop (1)
		EndIf
	Next
;~ Xác định vị trí vua

;~ Kiểm tra quân tịnh + Hậu chéo
	$i = $kingpos + 11
	While $Board120[$i] <> 0 And color($Board[$Board120[$i]]) <> $color
		If $Board[$Board120[$i]] == $oqueen Or $Board[$Board120[$i]] == $obishop Then
			Return True
		ElseIf $Board[$Board120[$i]] <> "0" Then
			ExitLoop (1)
		EndIf
		$i = $i + 11
	WEnd
	$i = $kingpos - 11
	While $Board120[$i] <> 0 And color($Board[$Board120[$i]]) <> $color
		If $Board[$Board120[$i]] == $oqueen Or $Board[$Board120[$i]] == $obishop Then
			Return True
		ElseIf $Board[$Board120[$i]] <> "0" Then
			ExitLoop (1)
		EndIf
		$i = $i - 11
	WEnd
	$i = $kingpos + 9
	While $Board120[$i] <> 0 And color($Board[$Board120[$i]]) <> $color
		If $Board[$Board120[$i]] == $oqueen Or $Board[$Board120[$i]] == $obishop Then
			Return True
		ElseIf $Board[$Board120[$i]] <> "0" Then
			ExitLoop (1)
		EndIf
		$i = $i + 9
	WEnd
	$i = $kingpos - 9
	While $Board120[$i] <> 0 And color($Board[$Board120[$i]]) <> $color
		If $Board[$Board120[$i]] == $oqueen Or $Board[$Board120[$i]] == $obishop Then
			Return True
		ElseIf $Board[$Board120[$i]] <> "0" Then
			ExitLoop (1)
		EndIf
		$i = $i - 9
	WEnd
;~ Kiểm tra quân tịnh + Hậu chéo

;~ Kiểm tra quân xe + Hậu thẳng
	$i = $kingpos + 1
	While $Board120[$i] <> 0 And color($Board[$Board120[$i]]) <> $color
		If $Board[$Board120[$i]] = $oqueen Or $Board[$Board120[$i]] == $orook Then
			Return True
		ElseIf $Board[$Board120[$i]] <> "0" Then
			ExitLoop (1)
		EndIf
		$i = $i + 1
	WEnd
	$i = $kingpos - 1
	While $Board120[$i] <> 0 And color($Board[$Board120[$i]]) <> $color
		If $Board[$Board120[$i]] == $oqueen Or $Board[$Board120[$i]] == $orook Then
			Return True
		ElseIf $Board[$Board120[$i]] <> "0" Then
			ExitLoop (1)
		EndIf
		$i = $i - 1
	WEnd
	$i = $kingpos + 10
	While $Board120[$i] <> 0 And color($Board[$Board120[$i]]) <> $color
		If $Board[$Board120[$i]] == $oqueen Or $Board[$Board120[$i]] == $orook Then
			Return True
		ElseIf $Board[$Board120[$i]] <> "0" Then
			ExitLoop (1)
		EndIf
		$i = $i + 10
	WEnd
	$i = $kingpos - 10
	While $Board120[$i] <> 0 And color($Board[$Board120[$i]]) <> $color
		If $Board[$Board120[$i]] == $oqueen Or $Board[$Board120[$i]] == $orook Then
			Return True
		ElseIf $Board[$Board120[$i]] <> "0" Then
			ExitLoop (1)
		EndIf
		$i = $i - 10
	WEnd
;~ Kiểm tra quân xe + Hậu thẳng

;~ Kiểm tra tốt
	If ($Board120[$kingpos + 9] <> 0 And $Board[$Board120[$kingpos + 9]] == $opawn) Or ($Board120[$kingpos + 11] <> 0 And $Board[$Board120[$kingpos + 11]] == $opawn) Then
		Return True
	EndIf

;~ Kiểm tra mã
	$i = $kingpos + 12
	If ($Board120[$i] <> 0 And $Board[$Board120[$i]] == $oknight) Then
		Return True
	EndIf
	$i = $kingpos + 21
	If ($Board120[$i] <> 0 And $Board[$Board120[$i]] == $oknight) Then
		Return True
	EndIf
	$i = $kingpos + 19
	If ($Board120[$i] <> 0 And $Board[$Board120[$i]] == $oknight) Then
		Return True
	EndIf
	$i = $kingpos + 8
	If ($Board120[$i] <> 0 And $Board[$Board120[$i]] == $oknight) Then
		Return True
	EndIf
	$i = $kingpos - 12
	If ($Board120[$i] <> 0 And $Board[$Board120[$i]] == $oknight) Then
		Return True
	EndIf
	$i = $kingpos - 21
	If ($Board120[$i] <> 0 And $Board[$Board120[$i]] == $oknight) Then
		Return True
	EndIf
	$i = $kingpos - 19
	If ($Board120[$i] <> 0 And $Board[$Board120[$i]] == $oknight) Then
		Return True
	EndIf
	$i = $kingpos - 8
	If ($Board120[$i] <> 0 And $Board[$Board120[$i]] == $oknight) Then
		Return True
	EndIf

;~ Kiểm tra vua
	$i = $kingpos + 1
	If $Board120[$i] <> 0 And $Board[$Board120[$i]] == $oking Then
		Return True
	EndIf
	$i = $kingpos - 1
	If $Board120[$i] <> 0 And $Board[$Board120[$i]] == $oking Then
		Return True
	EndIf
	$i = $kingpos + 9
	If $Board120[$i] <> 0 And $Board[$Board120[$i]] == $oking Then
		Return True
	EndIf
	$i = $kingpos + 10
	If $Board120[$i] <> 0 And $Board[$Board120[$i]] == $oking Then
		Return True
	EndIf
	$i = $kingpos + 11
	If $Board120[$i] <> 0 And $Board[$Board120[$i]] == $oking Then
		Return True
	EndIf
	$i = $kingpos - 9
	If $Board120[$i] <> 0 And $Board[$Board120[$i]] == $oking Then
		Return True
	EndIf
	$i = $kingpos - 10
	If $Board120[$i] <> 0 And $Board[$Board120[$i]] == $oking Then
		Return True
	EndIf
	$i = $kingpos - 11
	If $Board120[$i] <> 0 And $Board[$Board120[$i]] == $oking Then
		Return True
	EndIf


	Return False
EndFunc   ;==>Check




;~ Xử lí nước đi dạng chữ
;~ Chuyển nước đi tọa độ sang kí hiệu
Func char_to_o($c)
	Local $i
	For $i = 1 To 64
		If $cBoard[$i] = $c Then
			Return $i
		EndIf
	Next
EndFunc   ;==>char_to_o

Func o_to_move($from, $to)
	Return $cBoard[$from] & $cBoard[$to]
EndFunc   ;==>o_to_move

Func move_get_from($move)
	Local $from_char, $i
	$from_char = StringLeft($move, 2)
	For $i = 1 To 64
		If $from_char = $cBoard[$i] Then
			Return $i
			ExitLoop (1)
		EndIf
	Next
EndFunc   ;==>move_get_from

Func move_get_to($move)
	Local $from_char, $i
	$from_char = StringMid($move, 3, 2)
	For $i = 1 To 64
		If $from_char = $cBoard[$i] Then
			Return $i
			ExitLoop (1)
		EndIf
	Next
EndFunc   ;==>move_get_to
;~ Xử lí nước đi dạng chữ


;~ Tìm màu bên đối phương
Func Opp_site($site)
	If $site = "w" Then
		Return "b"
	Else
		Return "w"
	EndIf
EndFunc   ;==>Opp_site
;~ Tìm màu bên đối phương





Func mini_move()
	Local $ready, $i, $move
	Do
		$ready = readyok()
		If $ready Then
			$move = engine_get_move()
			makemove($move)
		Else
			Status("engine chưa sẵn sàng, đang khởi tạo lại kết nối ...   " & $i)
			$connected = False
			ProcessClose($engine)
			engine_connect()
		EndIf
	Until $ready
	$movenext = $Player_color
	referee()
EndFunc   ;==>mini_move



Func makemove($move)
	Local $from, $to, $promotion_piece
	ReDim $moves[UBound($moves) + 1]
	$moves[0] += 1
	$moves[UBound($moves) - 1] = $move & $next_promotion_piece
	$next_promotion_piece = ""
	$from = move_get_from($move)
	$to = move_get_to($move)


;~ sửa các thông số fen
	;~ nhập thành
;~ đọc thông số
	Local $wks, $wqs, $bks, $bqs, $c
	For $i = 1 To StringLen($Castling)
		$c = StringMid($Castling, $i, 1)
		Switch $c
			Case $c == "K"
				$wks = "K"
			Case $c == "Q"
				$wqs = "Q"
			Case $c == "k"
				$bks = "k"
			Case $c == "q"
				$bqs = "q"
		EndSwitch
	Next
	Local $movefrom, $moveto
	$movefrom = StringLeft($move, 2)
	$moveto = StringMid($move, 3, 2)
;~ 	nếu vua di chuyển không thể nhập thành
	If $movefrom = "e1" Then
		$wks = ""
		$wqs = ""
	EndIf
	If $movefrom = "e8" Then
		$bks = ""
		$bqs = ""
	EndIf
;~ 	xe bên nào di chuyển, bên đó không thể nhập thành
	If $movefrom = "h1" Or $moveto = "h1" Then
		$wks = ""
	EndIf
	If $movefrom = "a1" Or $moveto = "a1" Then
		$wqs = ""
	EndIf
	$Castling = $wks & $wqs & $bks & $bqs
	If $Castling = "" Then
		$Castling = "-"
	EndIf

;~ ăn chốt qua đường
	If $board[$from] <> "p" Then ;Quân di chuyển không phải chốt
		$En_passant="-"
	Else ;Di chuyển chốt
		If $to = $from + 16 Then
			$En_passant = $cBoard[$from + 8]
		ElseIf $to = $from - 16 Then
			$En_passant = $cBoard[$from - 8]
		EndIf
	EndIf


;~ số nước đi từ khi di chuyển chốt cuối hoặc ăn quân cuối, dùng cho xử hòa
	If $Board[$from] = "p" Or ($Board[$from] <> "0" And $Board[$to] <> "0") Then
		$Halfmove_clock = 0
	Else
		$Halfmove_clock += 1
	EndIf
;~ đếm số nước đi
	$Fullmove_number = Int(UBound($moves)/2)


;Di chuyển quân đi
	$Board[$to] = $Board[$from]
	$Board[$from] = "0"


;~ Xử lí phong cấp
	$promotion_piece = StringMid($move, 5, 1)
	If $promotion_piece <> 0 Then
		If $Board[$to] == "p" Then
			$Board[$to] = StringLower($promotion_piece)
		ElseIf $Board[$to] == "P" Then
			$Board[$to] = StringUpper($promotion_piece)
		EndIf
	EndIf


;~ 	Xử lí nước nhập thành
;~ Vua đen -
	If $Board[$to] = "k" Then
		If $Board[$to] == "k" And $to = $from - 2 Then
			$Board[$from - 1] = "r"
			If $Board[$from - 3] = "r" Then
				$Board[$from - 3] = "0"
			Else
				If $Board[$from - 4] = "r" Then
					$Board[$from - 4] = "0"
					drawn_o($from - 4)
				EndIf
			EndIf
			drawn_o($from - 1)
			drawn_o($from - 2)
			drawn_o($from - 3)
		EndIf
;~ Vua đen +
		If $Board[$to] == "k" And $to = $from + 2 Then
			$Board[$from + 1] = "r"
			If $Board[$from + 3] = "r" Then
				$Board[$from + 3] = "0"
			Else
				If $Board[$from + 4] = "r" Then
					$Board[$from + 4] = "0"
					drawn_o($from + 4)
				EndIf
			EndIf
			drawn_o($from + 1)
			drawn_o($from + 2)
			drawn_o($from + 3)
		EndIf
;~ 	Vua trắng -
		If $Board[$to] == "K" And $to = $from - 2 Then
			$Board[$from - 1] = "R"
			If $Board[$from - 3] = "R" Then
				$Board[$from - 3] = "0"
			Else
				If $Board[$from - 4] = "R" Then
					$Board[$from - 4] = "0"
					drawn_o($from - 4)
				EndIf
			EndIf
			drawn_o($from - 1)
			drawn_o($from - 2)
			drawn_o($from - 3)
		EndIf
;~ 	Vua trắng -
		If $Board[$to] == "K" And $to = $from + 2 Then
			$Board[$from + 1] = "R"
			If $Board[$from + 3] = "R" Then
				$Board[$from + 3] = "0"
			Else
				If $Board[$from + 4] = "R" Then
					$Board[$from + 4] = "0"
					drawn_o($from + 4)
				EndIf
			EndIf
			drawn_o($from + 1)
			drawn_o($from + 2)
			drawn_o($from + 3)
		EndIf
	EndIf
;~ 	Xử lí nước nhập thành


;~ Xử lí nước ăn chốt qua đường
	If $Board[$to] = "p" And ((Mod($from - 1, 8) + 1 = 4 And Mod($to - 1, 8) + 1 = 3) Or (Mod($from - 1, 8) + 1 = 5 And Mod($to - 1, 8) + 1 = 6)) Then
		If $to = $from + 7 Or $to = $from - 7 Then
			$Board[$from - 1] = "0"
			drawn_o($from - 1)
		ElseIf $to = $from + 9 Or $to = $from - 9 Then
			$Board[$from + 1] = "0"
			drawn_o($from + 1)
		EndIf
	EndIf
;~ Xử lí nước ăn chốt qua đường



	drawn_o($from)
	drawn_o($to)
	$undook = True ;Có thể đi lại

EndFunc   ;==>makemove




Func come_new_move($from, $to)
	Local $i
	If moveok($from, $to) Then
		If $Board[$from] = "p" And Mod($from - 1, 8) + 1 = 7 And Mod($to - 1, 8) + 1 = 8 Then
			$next_promotion_piece = promotion()
		EndIf
		For $i = 1 To 64
			$old_Board[$i] = $Board[$i]
		Next
		makemove($cBoard[$from] & $cBoard[$to])
		unselect()
		$movenext = Opp_site($Player_color)
		referee()
	Else
		Status("Nước đi của bạn phạm luật ! . . . ")
		unselect()
		drawn_board()
	EndIf
EndFunc   ;==>come_new_move


Func pick($pnumber)
	If $Selected = 0 Then
		$Selected = $pnumber
		drawn_o($Selected)
	Else

		If color($board[$Selected]) = $Player_color And color($board[$pnumber]) <> $Player_color Then
			come_new_move($Selected, $pnumber)
		Else
			unselect()
			$Selected = $pnumber
			drawn_o($Selected)
		EndIf
	EndIf

EndFunc   ;==>pick



Func color($pc)
	Switch $pc
		Case $pc == "r" Or $pc == "n" Or $pc == "b" Or $pc == "k" Or $pc == "q" Or $pc == "p"
			Return "b"
		Case $pc == "R" Or $pc == "N" Or $pc == "B" Or $pc == "K" Or $pc == "Q" Or $pc == "P"
			Return "w"
		Case $pc == "0"
			Return "0"
	EndSwitch
EndFunc   ;==>color

Func samecolor($p1, $p2)
	If color($p1) = color($p2) Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>samecolor







Func board2fen()
	Local $i, $char, $empty
	$empty = 0
	$board2fen = ""
	For $i = 1 To 64
		$char = $board[$fenboard[$i]]

		If $char == "0" Then
			$empty = $empty + 1

			If Mod($i, 8) = 0 Then
				$board2fen &= $empty
				$empty = 0
				$board2fen &= "/"
			EndIf
		Else

			If $empty <> 0 Then
				$board2fen &= $empty
				$empty = 0
			EndIf
			$board2fen &= $char
			If Mod($i, 8) = 0 Then
				$board2fen &= "/"
			EndIf
		EndIf
	Next

	$board2fen = StringTrimRight($board2fen, 1)
	$board2fen &= " " & $movenext & " " & $Castling & " " & $En_passant & " " & $Halfmove_clock & " " & $Fullmove_number
	Return $board2fen
EndFunc   ;==>board2fen

Func fen2board($fen2board)
	Local $ifen, $ifenboard, $p, $i, $j, $char

	$ifen = 1
	$ifenboard = 1
	Do
		Switch StringMid($fen2board, $ifen, 1)
			Case "/"

			Case 1 To 8
				For $i = 1 To StringMid($fen2board, $ifen, 1)
					$board[$fenboard[$ifenboard]] = "0"
					$ifenboard = $ifenboard + 1
				Next
			Case "R", "N", "B", "K", "Q", "P", "r", "n", "b", "k", "q", "p"
				$board[$fenboard[$ifenboard]] = StringMid($fen2board, $ifen, 1)
				$ifenboard = $ifenboard + 1
		EndSwitch
		$ifen += 1
	Until StringMid($fen2board, $ifen, 1) == " "


	$ifen += 1
	$movenext = StringMid($fen2board, $ifen, 1)
	$ifen += 1
	$Castling = ""
	Do
		$Castling = $Castling & StringMid($fen2board, $ifen, 1)
		$ifen += 1
	Until StringMid($fen2board, $ifen, 1) == " "
	$ifen += 1
	$En_passant = ""
	Do
		$En_passant = $En_passant & StringMid($fen2board, $ifen, 1)
		$ifen += 1
	Until StringMid($fen2board, $ifen, 1) == " "
	$ifen += 2
	$Halfmove_clock = StringMid($fen2board, $ifen, 1)
	$ifen += 2
	$Fullmove_number = StringMid($fen2board, $ifen, 1)
EndFunc   ;==>fen2board




Func drawn_o($i)
	Local $PicURL
	If $Selected = $i Then
		GUICtrlCreatePic(@ScriptDir & "\Images\board\selected.bmp", (Mod($Selected - 1, 8)) * 48 + 25, (7 - Int(($Selected - 1) / 8)) * 48, 48, 48)
		GUICtrlCreatePic(@ScriptDir & "\Images\board\selected.bmp", (Mod($Selected - 1, 8)) * 48 + 25, (7 - Int(($Selected - 1) / 8)) * 48, 48, 48)
	Else

		If $board_color[$i] = 1 Then
			GUICtrlCreatePic(@ScriptDir & "\Images\board\dark.bmp", (Mod($i - 1, 8)) * 48 + 25, (7 - Int(($i - 1) / 8)) * 48, 48, 48)
			GUICtrlCreatePic(@ScriptDir & "\Images\board\dark.bmp", (Mod($i - 1, 8)) * 48 + 25, (7 - Int(($i - 1) / 8)) * 48, 48, 48)
		Else
			GUICtrlCreatePic(@ScriptDir & "\Images\board\light.bmp", (Mod($i - 1, 8)) * 48 + 25, (7 - Int(($i - 1) / 8)) * 48, 48, 48)
			GUICtrlCreatePic(@ScriptDir & "\Images\board\light.bmp", (Mod($i - 1, 8)) * 48 + 25, (7 - Int(($i - 1) / 8)) * 48, 48, 48)
		EndIf
	EndIf

	Switch $board[$i]
		Case $board[$i] == 'p'
			$PicURL = @ScriptDir & "\Images\board\bp.bmp"
		Case $board[$i] == 'P'
			$PicURL = @ScriptDir & "\Images\board\wp.bmp"
		Case $board[$i] == 'r'
			$PicURL = @ScriptDir & "\Images\board\br.bmp"
		Case $board[$i] == 'R'
			$PicURL = @ScriptDir & "\Images\board\wr.bmp"
		Case $board[$i] == 'n'
			$PicURL = @ScriptDir & "\Images\board\bn.bmp"
		Case $board[$i] == 'N'
			$PicURL = @ScriptDir & "\Images\board\wn.bmp"
		Case $board[$i] == 'b'
			$PicURL = @ScriptDir & "\Images\board\bb.bmp"
		Case $board[$i] == 'B'
			$PicURL = @ScriptDir & "\Images\board\wb.bmp"
		Case $board[$i] == 'k'
			$PicURL = @ScriptDir & "\Images\board\bk.bmp"
		Case $board[$i] == 'K'
			$PicURL = @ScriptDir & "\Images\board\wk.bmp"
		Case $board[$i] == 'q'
			$PicURL = @ScriptDir & "\Images\board\bq.bmp"
		Case $board[$i] == 'Q'
			$PicURL = @ScriptDir & "\Images\board\wq.bmp"
		Case 0
			$PicURL = @ScriptDir & "\Images\board\empty.bmp"
	EndSwitch
	GUICtrlCreatePic($PicURL, (Mod($i - 1, 8)) * 48 + 33, (7 - Int(($i - 1) / 8)) * 48 + 8, 32, 32)
	GUICtrlCreatePic($PicURL, (Mod($i - 1, 8)) * 48 + 33, (7 - Int(($i - 1) / 8)) * 48 + 8, 32, 32)



EndFunc   ;==>drawn_o

Func drawn_board()
	GUICtrlCreatePic($pic_n, 0, 384, 408, 24)
	GUICtrlCreatePic($pic_n, 0, 384, 408, 24)
	GUICtrlCreatePic($pic_c, 0, 0, 24, 384)
	GUICtrlCreatePic($pic_c, 0, 0, 24, 384)
	For $i = 1 To 64
		drawn_o($i)
	Next
EndFunc   ;==>drawn_board

Func unselect()
	Local $unseclect
	$unseclect = $Selected
	$Selected = 0
	drawn_o($unseclect)
EndFunc   ;==>unselect




Func save()
	Local $saveURL, $savefile
	Local $i
;~ 	Lưu file
	$saveURL = ""
	$saveURL = FileSaveDialog("Chọn chỗ lưu ván đấu", @ScriptDir, "Tập tin lưu trữ miniChess (*.miniChess)", BitOR($FD_PATHMUSTEXIST, $FD_PROMPTOVERWRITE))
	If $saveURL <> "" Then
		If StringRight($saveURL, 10) <> ".miniChess" Then $saveURL = $saveURL & ".miniChess"
		_FileCreate($saveURL)
		$savefile = FileOpen($saveURL, $FO_OVERWRITE)
		$fen = board2fen()
;~ 		Viết fen
		FileWriteLine($savefile, $fen)
;~ 		Viết nước đi
		For $i = 1 To UBound($moves) - 1
			FileWriteLine($savefile, $moves[$i])
		Next
		FileClose($savefile)
;~ Kiểm tra
		If FileGetSize($saveURL) > 1 Then
			MsgBox(0, "miniChess", "Đã lưu ván đấu" & @CRLF & $saveURL, 2)
		Else
			MsgBox(0, "miniChess", "Lỗi: Không thể lưu!" & @CRLF & $saveURL, 2)
		EndIf
	EndIf
EndFunc   ;==>save

Func load()
	Local $loadURL, $loadfile
	Local $i
;~ Nạp file
	$loadURL = FileOpenDialog("Chọn chỗ đã lưu ván đấu", @ScriptDir, "Tập tin lưu trữ miniChess (*.miniChess)", BitOR($FD_PATHMUSTEXIST, $FD_PROMPTOVERWRITE))
	If $loadURL <> "" And FileGetSize($loadURL) > 1 Then
		$loadfile = FileOpen($loadURL, 0)
		fen2board(FileReadLine($loadfile))
		ReDim $moves[1]
		For $i = 1 To _FileCountLines($loadfile) - 1
			ReDim $moves[UBound($moves) + 1]
			$moves[$i] = FileReadLine($loadfile)
		Next
		drawn_board()
	EndIf
EndFunc   ;==>load


;~ Ván mới
Func newgameblack()
	Local $i
	ReDim $moves[1]
	$moves[0] = 0
	$pic_n = $pic_nb
	$pic_c = $pic_cb
	For $i = 1 To 64
		$cBoard[$i] = $bcBoard[$i]
	Next
	$Selected = 0
	$fen = $fen_play_black
	$Player_color = "b"
	fen2board($fen)
	drawn_board()
	$movenext = Opp_site($Player_color)
	mini_move()

EndFunc   ;==>newgameblack

Func newgamewhite()
	Local $i
	ReDim $moves[1]
	$moves[0] = 0
	$pic_n = $pic_nw
	$pic_c = $pic_cw
	For $i = 1 To 64
		$cBoard[$i] = $wcBoard[$i]
	Next
	$Selected = 0
	$fen = $fen_play_white
	$Player_color = "w"
	fen2board($fen)
	drawn_board()
	Status("Ván mới . Bạn đi trước ...")
	$movenext = $Player_color
EndFunc   ;==>newgamewhite


Func new()
	Local $Msg
	reset()
	$newgame = GUICreate("Chơi mới", 300, 200, -1, -1, -1, -1, $MainForm)
	GUISwitch($newgame)

	GUICtrlCreatePic(@ScriptDir & "\Images\newgame.bmp", 0, 0, 300, 200)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$pickwhite = GUICtrlCreatePic(@ScriptDir & "\Images\whiteking.bmp", 6, 48, 144, 144)
	$pickblack = GUICtrlCreatePic(@ScriptDir & "\Images\blackking.bmp", 152, 48, 144, 144)
	GUISetState(@SW_DISABLE, $MainForm)
	GUISetState(@SW_SHOW, $newgame)


	While $Msg <> $GUI_EVENT_CLOSE And $Msg <> $pickwhite And $Msg <> $pickblack
		$Msg = GUIGetMsg()
	WEnd
	GUISetState(@SW_ENABLE, $MainForm)
	GUIDelete($newgame)

	If $Msg = $pickblack Then
		newgameblack()
	ElseIf $Msg = $pickwhite Then
		newgamewhite()
	EndIf
EndFunc   ;==>new
;~ Ván mới


;~ Phong cấp
Func promotion()
	Local $Msg, $result
	$promotion = GUICreate("Phong cấp", 290, 150, -1, -1, 0)
	GUICtrlCreateLabel("Chọn quân phong cấp", 8, 8, 276, 40)
	GUICtrlSetFont(-1, 12, 400, 0)
	$queen = GUICtrlCreateButton("Hậu", 16, 48, 48, 48, $BS_BITMAP)
	GUICtrlSetImage($queen, @ScriptDir & "\Images\board\" & $Player_color & "q.bmp", -1)
	$rook = GUICtrlCreateButton("Xe", 72, 48, 48, 48, $BS_BITMAP)
	GUICtrlSetImage($rook, @ScriptDir & "\Images\board\" & $Player_color & "r.bmp", -1)
	$knight = GUICtrlCreateButton("Mã", 128, 48, 48, 48, $BS_BITMAP)
	GUICtrlSetImage($knight, @ScriptDir & "\Images\board\" & $Player_color & "n.bmp", -1)
	$bishop = GUICtrlCreateButton("Tượng", 184, 48, 48, 48, $BS_BITMAP)
	GUICtrlSetImage($bishop, @ScriptDir & "\Images\board\" & $Player_color & "b.bmp", -1)
	GUISetState(@SW_DISABLE, $MainForm)
	GUISetState(@SW_SHOW, $promotion)
	While $Msg <> $queen And $Msg <> $rook And $Msg <> $knight And $Msg <> $bishop
		$Msg = GUIGetMsg()
	WEnd
	If $Msg = $queen Then
		If $Player_color = "w" Then
			$result = "Q"
		Else
			$result = "q"
		EndIf
	ElseIf $Msg = $rook Then
		If $Player_color = "w" Then
			$result = "R"
		Else
			$result = "r"
		EndIf
	ElseIf $Msg = $knight Then
		If $Player_color = "w" Then
			$result = "N"
		Else
			$result = "n"
		EndIf
	ElseIf $Msg = $bishop Then
		If $Player_color = "w" Then
			$result = "B"
		Else
			$result = "b"
		EndIf
	EndIf
	GUISetState(@SW_ENABLE, $MainForm)
	GUIDelete($promotion)
	Return ($result)
EndFunc   ;==>promotion


Func undo()
	Local $i
	If UBound($moves) > 2 Then
		ReDim $moves[UBound($moves) - 2]
		For $i = 1 To 64
			$Board[$i] = $old_Board[$i]
		Next
		drawn_board()
	EndIf
	$undook = False ;Không thể đi lại nữa
EndFunc   ;==>undo


Func setting()
$input=InputBox ("miniChess" , "Thiết lập thời gian suy nghĩ cho miniChess (thời gian suy nghĩ càng lâu, nước đi đưa ra sẽ thông minh hơn):"&@CRLF&"(đơn vị : giây)" ,$time_to_moves/1000)
If @Error = 0 and $input>0 Then
	$time_to_moves=$input*1000
EndIf
EndFunc   ;==>setting


Func info()
	Local $Msg, $OK
	$info = GUICreate("Thông tin về miniChess", 324, 274, -1, -1, 0, 0)
	GUICtrlCreateGroup("", 8, 8, 305, 185)
	GUICtrlCreatePic($Pic_Aboutme, 16, 24, 105, 97)
	GUICtrlCreateLabel("miniChess" & @CRLF & "Cùng chơi cờ vua !!", 132, 24, 175, 48)
	GUICtrlSetFont(-1, 14, 800, 0, "Times New Roman")
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlCreateLabel("Phiên bản thử nghiệm : 1.0 - alpha", 132, 70, 162, 25)
	GUICtrlSetColor(-1, 0x0000FF)
	GUICtrlCreateLabel("Phát triển bởi: Nguyễn Việt Anh" & @CRLF & "Email: tolavietanh@gmail.com", 16, 136, 295, 48)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$OK = GUICtrlCreateButton("&OK", 108, 200, 91, 33, 0)
	GUISetState(@SW_DISABLE, $MainForm)
	GUISetState(@SW_SHOW, $info)
	While $Msg <> $OK
		$Msg = GUIGetMsg()
	WEnd
	GUISetState(@SW_ENABLE, $MainForm)
	GUISetState(@SW_SHOW, $MainForm)
	GUIDelete($info)
EndFunc   ;==>info






Func reset()
	GUIDelete($MainForm)
	$MainForm = GUICreate("miniChess v1.0", 409, 481, -1, -1)
	GUISetIcon(@ScriptDir & "\miniChess.ico", -1)
	GUISetBkColor(0xA0A0A4)
;~ Nền

	$hPic_background = GUICtrlCreatePic($pic_board, 0, 0, 0, 0)
	GUICtrlSetState($hPic_background, $GUI_DISABLE)
;~ Nền
;~ Nút
	$setting = GUICtrlCreatePic($pic_setting, 216, 408, 73, 48)
	$save = GUICtrlCreatePic($pic_save, 288, 408, 73, 24)
	$load = GUICtrlCreatePic($pic_load, 288, 432, 73, 24)
	$new = GUICtrlCreatePic($pic_new, 0, 408, 73, 48)
	$undo = GUICtrlCreatePic($pic_undo, 72, 408, 73, 48)
	$resign = GUICtrlCreatePic($pic_resign, 144, 408, 73, 48)
	$info = GUICtrlCreatePic($pic_info, 368, 416, 32, 32)
;~ Nút
;~ Thanh trạng thái
	$StatusBar = GUICtrlCreateLabel("Chào ! Hãy chơi thật thoải mái với miniChess .. :D", 0, 456, 408, 24, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetColor($StatusBar, 0xFFFFFF)
	GUICtrlSetBkColor($StatusBar, -2)
;~ Thanh trạng thái
;~ Quân
	$Pic1 = GUICtrlCreatePic($emptyp, 33, 344, 32, 32)
	$Pic2 = GUICtrlCreatePic($emptyp, 81, 344, 32, 32)
	$Pic3 = GUICtrlCreatePic($emptyp, 129, 344, 32, 32)
	$Pic4 = GUICtrlCreatePic($emptyp, 177, 344, 32, 32)
	$Pic5 = GUICtrlCreatePic($emptyp, 225, 344, 32, 32)
	$Pic6 = GUICtrlCreatePic($emptyp, 273, 344, 32, 32)
	$Pic7 = GUICtrlCreatePic($emptyp, 321, 344, 32, 32)
	$Pic8 = GUICtrlCreatePic($emptyp, 369, 344, 32, 32)
	$Pic9 = GUICtrlCreatePic($emptyp, 33, 296, 32, 32)
	$Pic10 = GUICtrlCreatePic($emptyp, 81, 296, 32, 32)
	$Pic11 = GUICtrlCreatePic($emptyp, 129, 296, 32, 32)
	$Pic12 = GUICtrlCreatePic($emptyp, 177, 296, 32, 32)
	$Pic13 = GUICtrlCreatePic($emptyp, 225, 296, 32, 32)
	$Pic14 = GUICtrlCreatePic($emptyp, 273, 296, 32, 32)
	$Pic15 = GUICtrlCreatePic($emptyp, 321, 296, 32, 32)
	$Pic16 = GUICtrlCreatePic($emptyp, 369, 296, 32, 32)
	$Pic17 = GUICtrlCreatePic($emptyp, 33, 248, 32, 32)
	$Pic18 = GUICtrlCreatePic($emptyp, 81, 248, 32, 32)
	$Pic19 = GUICtrlCreatePic($emptyp, 129, 248, 32, 32)
	$Pic20 = GUICtrlCreatePic($emptyp, 177, 248, 32, 32)
	$Pic21 = GUICtrlCreatePic($emptyp, 225, 248, 32, 32)
	$Pic22 = GUICtrlCreatePic($emptyp, 273, 248, 32, 32)
	$Pic23 = GUICtrlCreatePic($emptyp, 321, 248, 32, 32)
	$Pic24 = GUICtrlCreatePic($emptyp, 369, 248, 32, 32)
	$Pic25 = GUICtrlCreatePic($emptyp, 33, 200, 32, 32)
	$Pic26 = GUICtrlCreatePic($emptyp, 81, 200, 32, 32)
	$Pic27 = GUICtrlCreatePic($emptyp, 129, 200, 32, 32)
	$Pic28 = GUICtrlCreatePic($emptyp, 177, 200, 32, 32)
	$Pic29 = GUICtrlCreatePic($emptyp, 225, 200, 32, 32)
	$Pic30 = GUICtrlCreatePic($emptyp, 273, 200, 32, 32)
	$Pic31 = GUICtrlCreatePic($emptyp, 321, 200, 32, 32)
	$Pic32 = GUICtrlCreatePic($emptyp, 369, 200, 32, 32)
	$Pic33 = GUICtrlCreatePic($emptyp, 33, 152, 32, 32)
	$Pic34 = GUICtrlCreatePic($emptyp, 81, 152, 32, 32)
	$Pic35 = GUICtrlCreatePic($emptyp, 129, 152, 32, 32)
	$Pic36 = GUICtrlCreatePic($emptyp, 177, 152, 32, 32)
	$Pic37 = GUICtrlCreatePic($emptyp, 225, 152, 32, 32)
	$Pic38 = GUICtrlCreatePic($emptyp, 273, 152, 32, 32)
	$Pic39 = GUICtrlCreatePic($emptyp, 321, 152, 32, 32)
	$Pic40 = GUICtrlCreatePic($emptyp, 369, 152, 32, 32)
	$Pic41 = GUICtrlCreatePic($emptyp, 33, 104, 32, 32)
	$Pic42 = GUICtrlCreatePic($emptyp, 81, 104, 32, 32)
	$Pic43 = GUICtrlCreatePic($emptyp, 129, 104, 32, 32)
	$Pic44 = GUICtrlCreatePic($emptyp, 177, 104, 32, 32)
	$Pic45 = GUICtrlCreatePic($emptyp, 225, 104, 32, 32)
	$Pic46 = GUICtrlCreatePic($emptyp, 273, 104, 32, 32)
	$Pic47 = GUICtrlCreatePic($emptyp, 321, 104, 32, 32)
	$Pic48 = GUICtrlCreatePic($emptyp, 369, 104, 32, 32)
	$Pic49 = GUICtrlCreatePic($emptyp, 33, 56, 32, 32)
	$Pic50 = GUICtrlCreatePic($emptyp, 81, 56, 32, 32)
	$Pic51 = GUICtrlCreatePic($emptyp, 129, 56, 32, 32)
	$Pic52 = GUICtrlCreatePic($emptyp, 177, 56, 32, 32)
	$Pic53 = GUICtrlCreatePic($emptyp, 225, 56, 32, 32)
	$Pic54 = GUICtrlCreatePic($emptyp, 273, 56, 32, 32)
	$Pic55 = GUICtrlCreatePic($emptyp, 321, 56, 32, 32)
	$Pic56 = GUICtrlCreatePic($emptyp, 369, 56, 32, 32)
	$Pic57 = GUICtrlCreatePic($emptyp, 33, 8, 32, 32)
	$Pic58 = GUICtrlCreatePic($emptyp, 81, 8, 32, 32)
	$Pic59 = GUICtrlCreatePic($emptyp, 129, 8, 32, 32)
	$Pic60 = GUICtrlCreatePic($emptyp, 177, 8, 32, 32)
	$Pic61 = GUICtrlCreatePic($emptyp, 225, 8, 32, 32)
	$Pic62 = GUICtrlCreatePic($emptyp, 273, 8, 32, 32)
	$Pic63 = GUICtrlCreatePic($emptyp, 321, 8, 32, 32)
	$Pic64 = GUICtrlCreatePic($emptyp, 369, 8, 32, 32)
;~ Quân

	GUISetState(@SW_SHOW, $MainForm)
EndFunc   ;==>reset



Func Status($text)
	GUICtrlSetData($StatusBar, $text)

EndFunc   ;==>Status



$MainForm = GUICreate("miniChess v1.0", 409, 481, -1, -1)
GUISetIcon(@ScriptDir & "\miniChess.ico", -1)
GUISetBkColor(0xA0A0A4)
;~ Nền

$hPic_background = GUICtrlCreatePic($pic_board, 0, 0, 0, 0)
GUICtrlSetState($hPic_background, $GUI_DISABLE)
;~ Nền
;~ Nút
$setting = GUICtrlCreatePic($pic_setting, 216, 408, 73, 48)
$save = GUICtrlCreatePic($pic_save, 288, 408, 73, 24)
$load = GUICtrlCreatePic($pic_load, 288, 432, 73, 24)
$new = GUICtrlCreatePic($pic_new, 0, 408, 73, 48)
$undo = GUICtrlCreatePic($pic_undo, 72, 408, 73, 48)
$resign = GUICtrlCreatePic($pic_resign, 144, 408, 73, 48)
$info = GUICtrlCreatePic($pic_info, 368, 416, 32, 32)
;~ Nút
;~ Thanh trạng thái
$StatusBar = GUICtrlCreateLabel("Chào ! Hãy chơi thật thoải mái với miniChess .. :D", 0, 456, 408, 24, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetColor($StatusBar, 0xFFFFFF)
GUICtrlSetBkColor($StatusBar, -2)
;~ Thanh trạng thái
;~ Quân
$Pic1 = GUICtrlCreatePic($emptyp, 33, 344, 32, 32)
$Pic2 = GUICtrlCreatePic($emptyp, 81, 344, 32, 32)
$Pic3 = GUICtrlCreatePic($emptyp, 129, 344, 32, 32)
$Pic4 = GUICtrlCreatePic($emptyp, 177, 344, 32, 32)
$Pic5 = GUICtrlCreatePic($emptyp, 225, 344, 32, 32)
$Pic6 = GUICtrlCreatePic($emptyp, 273, 344, 32, 32)
$Pic7 = GUICtrlCreatePic($emptyp, 321, 344, 32, 32)
$Pic8 = GUICtrlCreatePic($emptyp, 369, 344, 32, 32)
$Pic9 = GUICtrlCreatePic($emptyp, 33, 296, 32, 32)
$Pic10 = GUICtrlCreatePic($emptyp, 81, 296, 32, 32)
$Pic11 = GUICtrlCreatePic($emptyp, 129, 296, 32, 32)
$Pic12 = GUICtrlCreatePic($emptyp, 177, 296, 32, 32)
$Pic13 = GUICtrlCreatePic($emptyp, 225, 296, 32, 32)
$Pic14 = GUICtrlCreatePic($emptyp, 273, 296, 32, 32)
$Pic15 = GUICtrlCreatePic($emptyp, 321, 296, 32, 32)
$Pic16 = GUICtrlCreatePic($emptyp, 369, 296, 32, 32)
$Pic17 = GUICtrlCreatePic($emptyp, 33, 248, 32, 32)
$Pic18 = GUICtrlCreatePic($emptyp, 81, 248, 32, 32)
$Pic19 = GUICtrlCreatePic($emptyp, 129, 248, 32, 32)
$Pic20 = GUICtrlCreatePic($emptyp, 177, 248, 32, 32)
$Pic21 = GUICtrlCreatePic($emptyp, 225, 248, 32, 32)
$Pic22 = GUICtrlCreatePic($emptyp, 273, 248, 32, 32)
$Pic23 = GUICtrlCreatePic($emptyp, 321, 248, 32, 32)
$Pic24 = GUICtrlCreatePic($emptyp, 369, 248, 32, 32)
$Pic25 = GUICtrlCreatePic($emptyp, 33, 200, 32, 32)
$Pic26 = GUICtrlCreatePic($emptyp, 81, 200, 32, 32)
$Pic27 = GUICtrlCreatePic($emptyp, 129, 200, 32, 32)
$Pic28 = GUICtrlCreatePic($emptyp, 177, 200, 32, 32)
$Pic29 = GUICtrlCreatePic($emptyp, 225, 200, 32, 32)
$Pic30 = GUICtrlCreatePic($emptyp, 273, 200, 32, 32)
$Pic31 = GUICtrlCreatePic($emptyp, 321, 200, 32, 32)
$Pic32 = GUICtrlCreatePic($emptyp, 369, 200, 32, 32)
$Pic33 = GUICtrlCreatePic($emptyp, 33, 152, 32, 32)
$Pic34 = GUICtrlCreatePic($emptyp, 81, 152, 32, 32)
$Pic35 = GUICtrlCreatePic($emptyp, 129, 152, 32, 32)
$Pic36 = GUICtrlCreatePic($emptyp, 177, 152, 32, 32)
$Pic37 = GUICtrlCreatePic($emptyp, 225, 152, 32, 32)
$Pic38 = GUICtrlCreatePic($emptyp, 273, 152, 32, 32)
$Pic39 = GUICtrlCreatePic($emptyp, 321, 152, 32, 32)
$Pic40 = GUICtrlCreatePic($emptyp, 369, 152, 32, 32)
$Pic41 = GUICtrlCreatePic($emptyp, 33, 104, 32, 32)
$Pic42 = GUICtrlCreatePic($emptyp, 81, 104, 32, 32)
$Pic43 = GUICtrlCreatePic($emptyp, 129, 104, 32, 32)
$Pic44 = GUICtrlCreatePic($emptyp, 177, 104, 32, 32)
$Pic45 = GUICtrlCreatePic($emptyp, 225, 104, 32, 32)
$Pic46 = GUICtrlCreatePic($emptyp, 273, 104, 32, 32)
$Pic47 = GUICtrlCreatePic($emptyp, 321, 104, 32, 32)
$Pic48 = GUICtrlCreatePic($emptyp, 369, 104, 32, 32)
$Pic49 = GUICtrlCreatePic($emptyp, 33, 56, 32, 32)
$Pic50 = GUICtrlCreatePic($emptyp, 81, 56, 32, 32)
$Pic51 = GUICtrlCreatePic($emptyp, 129, 56, 32, 32)
$Pic52 = GUICtrlCreatePic($emptyp, 177, 56, 32, 32)
$Pic53 = GUICtrlCreatePic($emptyp, 225, 56, 32, 32)
$Pic54 = GUICtrlCreatePic($emptyp, 273, 56, 32, 32)
$Pic55 = GUICtrlCreatePic($emptyp, 321, 56, 32, 32)
$Pic56 = GUICtrlCreatePic($emptyp, 369, 56, 32, 32)
$Pic57 = GUICtrlCreatePic($emptyp, 33, 8, 32, 32)
$Pic58 = GUICtrlCreatePic($emptyp, 81, 8, 32, 32)
$Pic59 = GUICtrlCreatePic($emptyp, 129, 8, 32, 32)
$Pic60 = GUICtrlCreatePic($emptyp, 177, 8, 32, 32)
$Pic61 = GUICtrlCreatePic($emptyp, 225, 8, 32, 32)
$Pic62 = GUICtrlCreatePic($emptyp, 273, 8, 32, 32)
$Pic63 = GUICtrlCreatePic($emptyp, 321, 8, 32, 32)
$Pic64 = GUICtrlCreatePic($emptyp, 369, 8, 32, 32)
;~ Quân
newgamewhite()
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			MsgBox(0, "miniChess", " Tạm biệt ! See uu again!! :D ", 2)
			Exit
		Case $setting
			setting()
		Case $new
			new()
		Case $save
			save()
		Case $load
			load()
		Case $info
			info()
		Case $undo
			If UBound($moves) > 2 Then ;Nếu ván cờ đã bắt đầu
				If $undook = True Then
					undo()
				Else
					MsgBox(0, "miniChess", "Bạn chỉ được đi lại 1 lần !", 2)
				EndIf
			EndIf
		Case $resign
			If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
			$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_DEFBUTTON2 + $MB_ICONQUESTION + 262144 + 524288, "miniChess", "Bạn muốn bỏ cuộc ?")
			If $iMsgBoxAnswer = $IDYES Then
				newgamewhite()
				Status("Mình có thể chơi một ván mới")
			EndIf
		Case $Pic1
			pick(1)
		Case $Pic2
			pick(2)
		Case $Pic3
			pick(3)
		Case $Pic4
			pick(4)
		Case $Pic5
			pick(5)
		Case $Pic6
			pick(6)
		Case $Pic7
			pick(7)
		Case $Pic8
			pick(8)
		Case $Pic9
			pick(9)
		Case $Pic10
			pick(10)
		Case $Pic11
			pick(11)
		Case $Pic12
			pick(12)
		Case $Pic13
			pick(13)
		Case $Pic14
			pick(14)
		Case $Pic15
			pick(15)
		Case $Pic16
			pick(16)
		Case $Pic17
			pick(17)
		Case $Pic18
			pick(18)
		Case $Pic19
			pick(19)
		Case $Pic20
			pick(20)
		Case $Pic21
			pick(21)
		Case $Pic22
			pick(22)
		Case $Pic23
			pick(23)
		Case $Pic24
			pick(24)
		Case $Pic25
			pick(25)
		Case $Pic26
			pick(26)
		Case $Pic27
			pick(27)
		Case $Pic28
			pick(28)
		Case $Pic29
			pick(29)
		Case $Pic30
			pick(30)
		Case $Pic31
			pick(31)
		Case $Pic32
			pick(32)
		Case $Pic33
			pick(33)
		Case $Pic34
			pick(34)
		Case $Pic35
			pick(35)
		Case $Pic36
			pick(36)
		Case $Pic37
			pick(37)
		Case $Pic38
			pick(38)
		Case $Pic39
			pick(39)
		Case $Pic40
			pick(40)
		Case $Pic41
			pick(41)
		Case $Pic42
			pick(42)
		Case $Pic43
			pick(43)
		Case $Pic44
			pick(44)
		Case $Pic45
			pick(45)
		Case $Pic46
			pick(46)
		Case $Pic47
			pick(47)
		Case $Pic48
			pick(48)
		Case $Pic49
			pick(49)
		Case $Pic50
			pick(50)
		Case $Pic51
			pick(51)
		Case $Pic52
			pick(52)
		Case $Pic53
			pick(53)
		Case $Pic54
			pick(54)
		Case $Pic55
			pick(55)
		Case $Pic56
			pick(56)
		Case $Pic57
			pick(57)
		Case $Pic58
			pick(58)
		Case $Pic59
			pick(59)
		Case $Pic60
			pick(60)
		Case $Pic61
			pick(61)
		Case $Pic62
			pick(62)
		Case $Pic63
			pick(63)
		Case $Pic64
			pick(64)
	EndSwitch
	Sleep(10)
WEnd
