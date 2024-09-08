@ECHO OFF
SET MAKEALL=%~1
if not "%MAKEALL%"=="1" (
  SET MAKEALL=0
)
ECHO _____________________________
call MakeVERBase.bat 1 TFT %MAKEALL%
ECHO =============================
if "%RESULTMAKEVER%"=="1" (
  pause
)