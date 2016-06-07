#include <ClickAndDragAtoB.au3>
#include <MsgBoxConstants.au3>

AutoItSetOption("SendKeyDelay", 150)

Local $lobby_file = "lobby-text.txt"
Local $title = "PVP.net Client"
Local $draft_mode_text_box_coords = [[297, 700], [20, 539]]
Local $url_file = "multi-search-query.txt"

; click and drag then copy lobby text
ClickAndDragAtoB($title, $draft_mode_text_box_coords)
Send("^c")

; delete $lobby_file then create it with new copied text
FileDelete($lobby_file)
Local $copied_text = ClipGet()
Local $lobby_file_handle = FileWrite($lobby_file, $copied_text)
FileClose($lobby_file_handle)

FileDelete($url_file)
Run("parse-lobby-text.exe " & $lobby_file) ; executes my program that outputs $url_file (parsed from $lobby_file)
Sleep(500)
Local $url_file_handle = FileOpen($url_file)
Local $url = FileReadLine($url_file_handle, 1)
FileClose($url_file_handle)

; go to url given in $url_file via Run program of windows
Send("#r")
Sleep(1250)
Send($url)
Send("{Enter}")

MsgBox($MB_OK, "", $url)