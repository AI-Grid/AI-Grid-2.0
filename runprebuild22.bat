@echo OFF

bin\Prebuild.exe /target vs2019 /file prebuild48.xml

setlocal ENABLEEXTENSIONS
set VALUE_NAME=MSBuildToolsPath

if "%PROCESSOR_ARCHITECTURE%"=="x86" set PROGRAMS=%ProgramFiles%
if defined ProgramFiles(x86) set PROGRAMS=%ProgramFiles(x86)%

rem Try to find VS2022
for %%e in (Enterprise Professional Community) do (
    if exist "%PROGRAMS%\Microsoft Visual Studio\2022\%%e\MSBuild\Current\Bin\MSBuild.exe" (

        set ValueValue="%PROGRAMS%\Microsoft Visual Studio\2022\%%e\MSBuild\Current\Bin\MSBuild"
		@echo found the path: %PROGRAMS%
		goto :found
    )
)


@echo msbuild for at least VS2022 not found, please install a (Community) edition of VS2019
@echo Not creating compile.bat
@echo missing: %PROGRAMS%
if exist "compile.bat" (
	del compile.bat
	)
goto :done

:found
    @echo Found msbuild at %ValueValue%
    @echo Creating compile.bat
rem To compile in debug mode
    @echo %ValueValue% consortium.sln > compile.bat
rem To compile in release mode comment line (add rem to start) above and uncomment next (remove rem)
rem    @echo %ValueValue% /p:Configuration=Release opensim.sln > compile.bat
:done
if exist "bin\addin-db-002" (
	del /F/Q/S bin\addin-db-002 > NUL
	rmdir /Q/S bin\addin-db-002
	)