@ECHO OFF
call %ADPROOT%\sdk\cli\Launch_cli.bat %ADPROOT%\examples_perseus6010\perseus6010_mo1000_mi125_bsdk\host\cli\mo1000_mi125_clki.txt 0
if errorlevel 1 goto error
call %ADPROOT%\sdk\cli\Launch_cli.bat %ADPROOT%\examples_perseus6010\perseus6010_mo1000_mi125_bsdk\host\cli\mo1000_mi125_mode_passthrough.txt 0
if errorlevel 1 goto error
goto end
:error
ECHO ADP runtime error!
:end
PAUSE
