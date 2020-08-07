@echo off
SET LAST_ERR_LEVEL=%errorlevel%
if "%LAST_ERR_LEVEL%"=="0" (
    chirp
) else (
    squawk
    cmd /c exit %LAST_ERR_LEVEL%
)
@echo on
echo Will this ever be called?
