@echo off
cd /d %~dp0
::填写路径设置
set ydwePath=/d D:\War3\YDWE1319MZ
set lniPath=/d D:\w3xlni
set mapName=%~n1

set vscodePath=%~1
set mapPath=%~dpn1
set extCmd=%~2
cd %ydwePath%
if "%extCmd%"=="run" (
bin\ydweconfig.exe -launchwar3 -loadfile "%mapName%.w3x"
) else if "%extCmd%"=="build" (
cd %lniPath%
w2l.exe obj "%mapPath%"
move "%mapPath%.w3x" "%ydwePath%\%mapName%.w3x"
) else if "%extCmd%"=="local" (
bin\ydweconfig.exe -launchwar3
bin\ydweconfig.exe -launchwar3
)

::-auto是自动进房。 