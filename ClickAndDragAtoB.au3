Func ClickAndDragAtoB($iTitle, $iCoords, $iButton = "left", $iSpeed = "0", $iXoffset = 0, $iYoffset = 0)
; use $iYoffset = -29 if window border is altering relative window coords
WinActivate($iTitle)
Local $iOriginal = Opt("MouseCoordMode", 0)             ;Get the current MouseCoordMode, set MouseCoordMode to relative to window
MouseClickDrag($iButton, $iCoords[0][0] + $iXoffset, $iCoords[0][1] + $iYoffset, $iCoords[1][0] + $iXoffset, $iCoords[1][1] + $iYoffset, $iSpeed) ;Move the mouse and click on the given control
Opt("MouseCoordMode",$iOriginal)               ;Change the MouseCoordMode back to the original
EndFunc   ;==>ClickAtCoords