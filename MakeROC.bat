@ECHO OFF
SET MAKEALL=%~1
if not "%MAKEALL%"=="1" (
  SET MAKEALL=0
)
ECHO _____________________________
call MakeVERBase.bat 0 ROC %MAKEALL%
ECHO =============================
if "%RESULTMAKEVER%"=="1" (
  pause
)