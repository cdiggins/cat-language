REM This batch files allows us to compile a version of Cat with no graphics capabilities
REM This appears to be neccessary for Cat to run properly on Mac
gmcs /d:NOGRAPHICS *.cs -out:cat_mono_no_graphics.exe -r:System.Data