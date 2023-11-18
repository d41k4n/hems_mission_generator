@echo off

set dir1=%cd%\Custom Scenery\CH_Hospitals
set dir2=%cd%\Custom Scenery\heliport_lib
set file11=St.Gallen\objects\apt_lights.dds
set file12=St.Gallen\objects\apt_lights_LIT.dds
set file21=textures\UrbanHighFac1_ALB.dds
set file22=textures\UrbanHighFac1_LIT.dds
set file23=textures\UrbanHighFac1_NML.png
set target11=..\..\..\..\Resources\default scenery\sim objects\apt_lights\apt_lights.dds
set target12=..\..\..\..\Resources\default scenery\sim objects\apt_lights\apt_lights_LIT.dds
set target21=..\..\..\Resources\default scenery\1000 autogen\US\urban_high\textures\UrbanHighFac1_ALB.dds
set target22=..\..\..\Resources\default scenery\1000 autogen\US\urban_high\textures\UrbanHighFac1_LIT.dds
set target23=..\..\..\Resources\default scenery\1000 autogen\US\urban_high\textures\UrbanHighFac1_NML.png

:: Admin check
fltmc >nul 2>nul || set _=^"set _ELEV=1^& cd /d """%cd%"""^& "%~f0" %* ^"&&((if "%_ELEV%"=="" ((powershell -nop -c start cmd -args '/d/x/s/v:off/r',$env:_ -verb runas >nul 2>nul) || (mshta vbscript:execute^("createobject(""shell.application"").shellexecute(""cmd"",""/d/x/s/v:off/r ""&createobject(""WScript.Shell"").Environment(""PROCESS"")(""_""),,""runas"",1)(window.close)"^) >nul 2>nul)))& exit /b)

echo Current dir: "%cd%"

if exist "%dir1%" (

	if exist "%dir1%\%file11%" (
	  echo File "%dir1%\%file11%" already exists - deleting
	  del "%dir1%\%file11%"
	  rem echo debug1
	)
	mklink "%dir1%\%file11%" "%target11%"
	rem echo debug2
	if %ERRORLEVEL% GEQ 1 goto abort

	if exist "%dir1%\%file12%" (
	  echo File "%dir1%\%file12%" already exists - deleting
	  del "%dir1%\%file12%"
	  rem echo debug3
	)
	mklink "%dir1%\%file12%" "%target12%"
	rem echo debug4
	if %ERRORLEVEL% GEQ 1 goto abort

) else (
	echo Directory not found: "%dir1%"
	goto abort
)


if exist "%dir2%" (

	if exist "%dir2%\%file21%" (
	  echo File "%dir2%\%file21%" already exists - deleting
	  del "%dir2%\%file21%"
	  rem echo debug5
	)
	mklink "%dir2%\%file21%" "%target21%"
	rem echo debug6
	if %ERRORLEVEL% GEQ 1 goto abort

	if exist "%dir2%\%file22%" (
	  echo File "%dir2%\%file22%" already exists - deleting
	  del "%dir2%\%file22%"
	  rem echo debug7
	)
	mklink "%dir2%\%file22%" "%target22%"
	rem echo debug8
	if %ERRORLEVEL% GEQ 1 goto abort

	if exist "%dir2%\%file23%" (
	  echo File "%dir2%\%file23%" already exists - deleting
	  del "%dir2%\%file23%"
	  rem echo debug9
	)
	mklink "%dir2%\%file23%" "%target23%"
	rem echo debug10
	if %ERRORLEVEL% GEQ 1 goto abort

) else (
	echo Directory not found: "%dir2%"
	goto abort
)

echo Done.
pause
exit

:abort
echo Script failed - aborting.
pause
EXIT /B 1