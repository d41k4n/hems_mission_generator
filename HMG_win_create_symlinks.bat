@echo off

:: Admin check
fltmc >nul 2>nul || set _=^"set _ELEV=1^& cd /d """%cd%"""^& "%~f0" %* ^"&&((if "%_ELEV%"=="" ((powershell -nop -c start cmd -args '/d/x/s/v:off/r',$env:_ -verb runas >nul 2>nul) || (mshta vbscript:execute^("createobject(""shell.application"").shellexecute(""cmd"",""/d/x/s/v:off/r ""&createobject(""WScript.Shell"").Environment(""PROCESS"")(""_""),,""runas"",1)(window.close)"^) >nul 2>nul)))& exit /b)

echo %cd%
cd %~dp0\Custom Scenery\CH_Hospitals
if %ERRORLEVEL% GEQ 1 goto exit1

if not exist .\St.Gallen\objects\apt_lights.dds (
  mklink ".\St.Gallen\objects\apt_lights.dds" "..\..\..\..\Resources\default scenery\sim objects\apt_lights\apt_lights.dds"
  if %ERRORLEVEL% GEQ 1 EXIT /B 1
) else echo File %~dp0\Custom Scenery\CH_Hospitals\St.Gallen\objects\apt_lights.dds already exits - skipping

if not exist .\St.Gallen\objects\apt_lights_LIT.dds (
  mklink ".\St.Gallen\objects\apt_lights_LIT.dds" "..\..\..\..\Resources\default scenery\sim objects\apt_lights\apt_lights_LIT.dds"
  if %ERRORLEVEL% GEQ 1 EXIT /B 1
) else echo File %~dp0\Custom Scenery\CH_Hospitals\St.Gallen\objects\apt_lights_LIT.dds already exits - skipping

cd %~dp0\Custom Scenery\heliport_lib
if %ERRORLEVEL% GEQ 1 goto exit2

if not exist .\textures\UrbanHighFac1_ALB.dds (
  mklink ".\textures\UrbanHighFac1_ALB.dds" "..\..\..\Resources\default scenery\1000 autogen\US\urban_high\textures\UrbanHighFac1_ALB.dds"
  if %ERRORLEVEL% GEQ 1 EXIT /B 1
) else echo File %~dp0\Custom Scenery\heliport_lib\textures\UrbanHighFac1_ALB.png already exits - skipping

if not exist .\textures\UrbanHighFac1_LIT.dds (
  mklink ".\textures\UrbanHighFac1_LIT.dds" "..\..\..\Resources\default scenery\1000 autogen\US\urban_high\textures\UrbanHighFac1_LIT.dds"
  if %ERRORLEVEL% GEQ 1 EXIT /B 1
) else echo File %~dp0\Custom Scenery\heliport_lib\textures\UrbanHighFac1_LIT.png already exits - skipping

if not exist .\textures\UrbanHighFac1_NML.png (
  mklink ".\textures\UrbanHighFac1_NML.png" "..\..\..\Resources\default scenery\1000 autogen\US\urban_high\textures\UrbanHighFac1_NML.png"
  if %ERRORLEVEL% GEQ 1 EXIT /B 1
) else echo File %~dp0\Custom Scenery\heliport_lib\textures\UrbanHighFac1_NML.png already exits - skipping

echo Done.
pause
exit

:exit1
echo Directory not found: %~dp0\Custom Scenery\CH_Hospitals
pause
EXIT /B 1

:exit2
echo Directory not found: %~dp0\Custom Scenery\heliport_lib
pause
EXIT /B 1