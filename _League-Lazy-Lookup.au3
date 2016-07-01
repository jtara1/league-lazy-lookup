#include <MsgBoxConstants.au3>
#include <ClickAndDragAtoB.au3>

; Global variables
Global $defaultOption = AutoItSetOption("SendKeyDelay", 150)
Global $program_title = "League Lazy Lookup"
Global $title = "PVP.net Client"

; Global variables for file names
Global $ssName = "ss.png" ; never used within this script, but kept to delete in cleanup()
Global $outputStr = "output.txt" ; contains OCR output in checkGameMode.exe
Global $lobby_file = "lobby-text.txt" ; copied text from champ select chat box
Global $url_file = "multi-search-url.txt" ; output from parse-lobby-text.exe

; initial call to main() to get things started
checkGameMode()

Func checkGameMode()
   ; checkGameMode()
   ; Description: checks if player is in normal draft or ranked champion select in LoL client
   ; Method: runs checkGameMode.exe every ~5 seconds which takes a picture (ss.png) of Lol client window, crops section where expected game mode text will be,
   ; ....... and uses optical character reading (OCR, tesseract) to convert the text in the cropped img to a string which gets saved to output.txt
   ; ....... this script reads text from output.txt and if "ranked" or "draft" (or other OCR misspellings) are in the text then boolean $inChampSelect = true
   ; ....... and lobbyLookup() function is ran.

   ; if PVP.net Client is not open, then script terminates
   If Not WinExists($title) Then
	  MsgBox($MB_OK, $program_title, $title & " not found.")
	  terminate()
   EndIf

   HotKeySet("{ESC}", "terminate") ; set hotkey to terminate program at any point
   MsgBox($MB_OK, $program_title, "Press 'Esc' to end the program.")

   Local $inChampSelect = False
   Local $outputStr = "output.txt" ; contains text from optical character reading (OCR)
   Local $gameModeStr ; will contain the text from $outputStr

   Local $sleepDelay = 4400 ; delay before getting next screenshot
   Local $programRunDelay = 500 ; delay for checkGameMode.exe to run and save .png and .txt files

   While (Not $inChampSelect)
	  Run("checkGameMode.exe") ; saves screenshot of LolClient.net as ss.png, crops the .png, and uses OCR to try to read game mode (if any), saves output.txt
	  Sleep($programRunDelay)

	  Local $fileHandle = FileOpen($outputStr)
	  $gameModeStr = FileReadLine($fileHandle, 1)

	  ; note: OCR doesn't read game mode text perfectly, it reads "DRAFT" as "URN-T" in C# .Net wrapper for tesseract
	  If (StringInStr($gameModeStr, "RANKED") or StringInStr($gameModeStr, "URN-T") or StringInStr($gameModeStr, "DRAFT") or StringInStr($gameModeStr, "BRA!-T") or StringInStr($gameModeStr, "DRAFF")) Then
		   $inChampSelect = true
	  EndIf

	  Sleep($sleepDelay)
   WEnd

   If ($inChampSelect) Then
	  Local $userReply = MsgBox($MB_YESNO, $program_title, "Run Lobby Lookup script?")
	  If ($userReply == $IDYES) Then
		 lobbyLookup()
	  EndIf
   EndIf
EndFunc ; end of checkGameMode()

Func lobbyLookup()
   ; lobbyLookup
   ; Description: get text from champion select chat box, convert that text to url for multi-search on na.op.gg
   ; Method: Moves mouse to select text, copies text, saves to .txt file, calls parse-lobby-text.exe with .txt file as parameter, copies text from url
   ; ....... that links directly to multi search, pastes copied url into Run Windows program to use system

   Local $draft_mode_text_box_coords = [[297, 700], [20, 539]]

   ; click and drag then copy lobby text
   ClickAndDragAtoB($title, $draft_mode_text_box_coords)
   Send("^c")

   ; delete $lobby_file then create it with new copied text
   ;FileDelete($lobby_file)
   Local $copied_text = ClipGet()
   Local $lobby_file_handle = FileWrite($lobby_file, $copied_text)
   FileClose($lobby_file_handle)

   ;FileDelete($url_file)
   Run("parse-lobby-text.exe " & $lobby_file) ; executes my program that outputs $url_file (parsed from $lobby_file)
   Sleep(150)
   Local $url_file_handle = FileOpen($url_file)
   ClipPut(FileReadLine($url_file_handle, 1))
   FileClose($url_file_handle)

   ; go to url given in $url_file via Run program of windows
   Send("#r")
   WinWait("Run", "", 5)
   Send("^v")
   Send("{Enter}")
   terminate()
EndFunc ; end of lobbLookup()

Func cleanup(ByRef $filesRef)
; cleanup(ByRef $filesRef)
; Description: deletes temporary .txt and .png files used to pass information throughout the .exe's used in the process

   For $i = 0 To UBound($filesRef) - 1
	  If FileExists($filesRef[$i]) Then
		 FileDelete($filesRef[$i])
	  EndIf
   Next
   Return
EndFunc ; end of cleanup(ByRef $filesRef)

Func terminate()
   Local $files[4] = [$ssName, $outputStr, $lobby_file, $url_file]
   cleanup($files) ; disable to check temporary files (can help with debugging)
   MsgBox($MB_OK, $program_title, "Program ended.")
   Exit
EndFunc ; end of terminate()