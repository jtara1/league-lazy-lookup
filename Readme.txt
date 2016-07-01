League of Legends Lazy Lookup
Purpose:
- Get text from champion select pre game lobby and use multi-search function on op.gg to check champion stats and winrates of fellow summoners in lobby.

Demo Videos:
https://youtu.be/0986uY2IaDg

Method:
1. Check if PVP.net Client is running, if not then Exit
2. Run checkGameMode.exe (every ~5 sec until boolean $inChampSelect = true)
	2a. Get screenshot of PVP.net Client via PrintWindow function (Client window can be covered, but not minimized)
	2b. Crop screenshot to region where expected game mode text will be (saved as ss.png)
	2c. Use OCR (Tesseract .Net wrapper) to convert cropped screenshot to a string
	2d. Save string to output.txt
3. Once player is in ranked or normal draft champion select, run script function lobbyLookup()
	3a. Copy text from LoL client champion select.
	3b. Parse into valid url for multi-search on na.op.gg
	3c. Go to parsed url.

Instructions:
1. Download files from release section here or compile the autoit file, cpp file, and C# VS 2015 Project yourself.
2. Run _League-Lazy-Lookup.exe after you login to LoL.

Requirements:
- Windows OS
- League of Legends
- Visual Studio 2015 x86 & x64 runtimes for OCR (Tesseract) (download here: https://www.microsoft.com/en-us/download/details.aspx?id=48145)

Notes:
- Tested on two different Windows 8 computers, it worked as expected

Flaws:
- resizing LoL client window will offset coordinates (predefined) (for cropping of screenshot & chat box coordinates)
- it will fail to grab proper text from chat if too many people start typing before the lobbyLookup() function in the main script runs
- currently only works for na.op.gg (North America region)
- minimizing PVP.net Client will mess up the part of the program that takes a screenshot of the Client (however, using alt-tab or switching windows is fine)
- loading cursor may be activated every ~5 seconds