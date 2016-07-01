League of Legends Lazy Lookup
Purpose:
- Get text from champion select pre game lobby and use multi-search function on op.gg to check champion stats and winrates of fellow summoners in lobby.

Demo Video:
https://youtu.be/0986uY2IaDg

Method:
1. Copy text from LoL client pre game lobby.
2. Parse into valid url for multi-search on na.op.gg
3. Go to parsed url.

Instructions:
1. Download .exe files from release section here or compile the autoit file and cpp file yourself.
2. Run league-lazy-lookup.exe right after you enter the pre game lobby (do not move mouse or press keys until script ends ~5 seconds).

Flaws:
- resizing LoL client window will offset coordinates (predefined)
- it will fail to grab proper text from chat if too many people start typing before you run it
- currently only works for na.op.gg (North America region)
