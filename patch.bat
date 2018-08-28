@ECHO OFF
ECHO Patching rom...
cp "gtroop.sfc" "patched\gtroop.sfc"
asar -verbose main.asm "patched\gtroop.sfc"
ECHO Disassembling patched rom...
dispel "patched\gtroop.sfc" > "patched\gtroop.log"
ECHO Done!