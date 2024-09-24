@echo off
setlocal enabledelayedexpansion

REM Check if ImageMagick is installed
where magick >nul 2>nul
if %errorlevel% neq 0 (
    echo ImageMagick is not installed or not in PATH. Please install it first.
    exit /b 1
)

REM Check if input image is provided
if "%~1"=="" (
    echo Usage: %0 ^<input_image^>
    exit /b 1
)

set "input_image=%~1"

REM Check if input image exists
if not exist "%input_image%" (
    echo Input image does not exist: %input_image%
    exit /b 1
)

REM Function to resize image
:resize_image
set "size=%~1"
set "output_name=%~2"
magick convert "%input_image%" -resize "%size%" "%output_name%"
if %errorlevel% equ 0 (
    echo Created: %output_name%
) else (
    echo Failed to create: %output_name%
)
exit /b 0

REM Array of image configurations
set "configs=LargeTile SmallTile SplashScreen Square150x150Logo Square44x44Logo"

REM Process each configuration
for %%c in (%configs%) do (
    if "%%c"=="LargeTile" set "sizes=100x100 125x125 150x150 200x200 400x400"
    if "%%c"=="SmallTile" set "sizes=100x100 125x125 150x150 200x200 400x400"
    if "%%c"=="SplashScreen" set "sizes=100x100 125x125 150x150 200x200 400x400"
    if "%%c"=="Square150x150Logo" set "sizes=100x100 125x125 150x150 200x200 400x400"
    if "%%c"=="Square44x44Logo" set "sizes=44x44 55x55 66x66 88x88 176x176"
    
    for %%s in (!sizes!) do (
        call :resize_image "%%s" "%%c.scale-%%~ns.png"
    )
)

REM Additional sizes for Square44x44Logo
set "additional_sizes=16 20 24 30 32 36 40 48 60 64 72 80 96 256"
for %%s in (%additional_sizes%) do (
    call :resize_image "%%sx%%s" "Square44x44Logo.altform-unplated_targetsize-%%s.png"
)

echo All images have been resized successfully!
