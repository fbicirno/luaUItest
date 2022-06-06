@echo =========窗口测试=========

taskkill /f /im war3.exe
w2l obj "D:\War3\Project\Lua学习\Lua动态界面ui简易教程\wartestprj\testmap\.w3x"
ydweconfig.exe -launchwar3 -loadfile "D:\War3\Project\Lua学习\Lua动态界面ui简易教程\wartestprj\testmap.w3x"  -windows
