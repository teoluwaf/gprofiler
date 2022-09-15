@echo off
WHERE cargo
IF %ERRORLEVEL% NEQ 0 (
	ECHO cargo wasn't found. Attempting to install...
	.\dep\rustup-init.exe -y
)

start /wait .\dep\vs_BuildTools.exe --passive --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.Windows10SDK.19041 --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64
Rem start /wait .\dep\vs_BuildTools.exe --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.Windows10SDK.19041 --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64

SET LINK_LOC="C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.33.31629\bin\Hostx86\x86\link.exe"

SET SDK_LOC="C:\Program Files (x86)\Windows Kits\10\Lib\10.0.19041.0\um\x86\advapi32.lib"

ECHO "Waiting for dependencies to be installed..."
:WAIT_FOR_DEPS
IF EXIST %LINK_LOC% (
        IF EXIST %SDK_LOC% (
                GOTO DEPS_INSTALLED
        )
)

TIMEOUT /T 60 >nul

GOTO WAIT_FOR_DEPS

:DEPS_INSTALLED
ECHO "Done installing dependencies."

ECHO "Current Path: %PATH%"
Rem SET PATH=%PATH%;%USERPROFILE%\.cargo\bin;%CD%\deps\winlibs-x86_64-posix-seh-gcc-12.1.0-llvm-14.0.4-mingw-w64ucrt-10.0.0-r2\mingw64\x86_64-w64-mingw32\bin;%CD%\deps\winlibs-x86_64-posix-seh-gcc-12.1.0-llvm-14.0.4-mingw-w64ucrt-10.0.0-r2\mingw64\bin
SET PATH=%PATH%;%USERPROFILE%\.cargo\bin;%CD%\deps
ECHO "Modified Path: %PATH%"
CD py-spy
rustup default stable
rustup target add x86_64-pc-windows-gnu

REM rustup toolchain install stable-x86_64-pc-windows-gnu
REM rustup default stable-x86_64-pc-windows-gnu
WHERE cargo
IF %ERRORLEVEL% NEQ 0 (
       ECHO py-spy build failed.
       EXIT /B -1
)
cargo install cross
cargo build --release
DIR target\release\py-spy.exe
IF %ERRORLEVEL% NEQ 0 (
	ECHO py-spy build failed.
	CD ..
	EXIT /B -1
)
ECHO py-spy install complete
CD ..
COPY py-spy\target\release\py-spy.exe .\py-spy
ECHO "Current Working Directory: %CD%"
ECHO Y | RMDIR /S py-spy\target
EXIT /B 0
