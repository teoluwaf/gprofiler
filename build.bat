@echo off
MKDIR app src py-spy 2>NUL
REM Download Build Tools for Visual Studio
REM https://aka.ms/vs/17/release/vs_BuildTools.exe
WHERE python
IF %ERRORLEVEL% NEQ 0 (
	ECHO python wasn't found. Attempting to install...
	ECHO Shell will close once complete. Re-run build.bat to proceed
	CALL .\dep\python-3.9.13-amd64.exe /passive PrependPath=1 Include_test=0
)
REM Get Python version
FOR /f "tokens=1-2" %%i in ('python --version') do (
	set PYTHON_VERSION=%%j
	IF /i "%PYTHON_VERSION:~0,1%" == "3" (
		ECHO Python version is valid
	) ELSE (
		ECHO Python 3 is required. Attempying to install...
		ECHO Shell will close once complete. Re-run build.bat to proceed
		.\deb\python-3.9.13-amd64.exe /passive PrependPath=1 Include_test=0
	)
)
@echo Installed python version: %PYTHON_VERSION%
IF EXIST .\py-spy\py-spy.exe (
	ECHO Found py-spy.exe
) ELSE (
	ECHO Building py-spy executable...
	CALL build-pyspy.bat
)
CD app

WHERE pip
IF %ERRORLEVEL% NEQ 0 (
	ECHO pip wasn't found.
	ECHO Install pip for current and re-run build.bat
	EXIT /B -1
)
Rem pip install --no-cache-dir --user --upgrade pip
MKDIR granulate-utils 2> NUL
COPY ..\requirements.txt requirements.txt
FOR %%i in ("..\granulate-utils\setup.py" "..\granulate-utils\requirements.txt" "..\granulate-utils\README.md") do COPY "%%i" granulate-utils
ECHO D | XCOPY ..\granulate-utils\granulate_utils .\granulate-utils\granulate_utils /E
python -m pip install --no-cache-dir -r requirements.txt

COPY ..\exe-requirements.txt exe-requirements.txt
python -m pip install --no-cache-dir -r exe-requirements.txt
MKDIR gprofiler\resources\python
COPY ..\py-spy\py-spy.exe gprofiler\resources\python

ECHO D | XCOPY ..\gprofiler .\gprofiler /E
FOR %%i in ("..\pyi_build.py" "..\pyinstaller.spec") do COPY "%%i" .
pyinstaller pyinstaller.spec
