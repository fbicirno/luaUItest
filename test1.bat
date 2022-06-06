@echo =========全屏测试=========

taskkill /f /im war3.exe
w2l obj "D:\wartestprj\testmap\.w3x"
ydweconfig.exe -launchwar3 -loadfile "D:\wartestprj\testmap.w3x"  -fullscreen

 