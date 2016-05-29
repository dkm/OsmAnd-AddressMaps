@echo off
REM  hvdwolf@gmail.com, May 2016
REM  This script downloads all regional roads_only maps for a certain country
REM  and converts it into a full roads_only map for that country
REM  and into a full address_map for that country

REM Requirements: awk, curl, unzip, wget and OsmAndMapCreator (newer than mid May 2016)


set URL="http://download.osmand.net/road-indexes/"
REM Change region to asia, south_america or whichever relevant region
set region="europe"

REM Specify full path to the tools
set BINDIR="C:\Users\harryvanderwolf\Downloads\OpenStreetMap-Osmadm\OsmAnd-AddressMaps\wintools"
REM Specify full path to the OsmAndMapCreator folder
set OMC="C:\Users\harryvanderwolf\Downloads\OpenStreetMap-Osmadm\OsmAndMapCreator"
set INSP=java.exe -Djava.util.logging.config.file=logging.properties -Xms64M -Xmx512M -cp "./OsmAndMapCreator.jar;./lib/OsmAnd-core.jar;./lib/*.jar" net.osmand.binary.BinaryInspector

set CURDIR=%cd%
echo %CURDIR%

REM Specify country as option to this script
if "%1"=="" goto no_param
goto process_country

:no_param
echo.
echo.
echo   Syntax: %0% country
echo   With country being one of: France Germany Italy
echo   You did not specify a country
goto DONE

:process_country
set country=%1
REM Note: Some countries do have a full map and  regional maps. In that case it is not usefull to use this script

REM First remove earlier files
del %country%_%region%.road.obf
del %country%_%region%.address.obf

%BINDIR%\curl.exe -s %URL% | %BINDIR%\awk.exe "{print $6}" | %BINDIR%\sed.exe -e "s+href=\"++" -e "s+\".*++" | %BINDIR%\grep.exe %country%.*%region%.*road > tmp_weblisting.txt

setlocal enabledelayedexpansion
FOR /F "tokens=*" %%i in (tmp_weblisting.txt) DO (
	%BINDIR%\wget.exe %URL%%%i -O %%i
	%BINDIR%\unzip.exe -u %%i
	del /F/Q %%i
)
del /F /Q tmp_weblisting.txt
REM Only for the Netherlands
del Netherlands_europe_2.road.obf 

REM ######################################################
REM Now do the merging with utilities.sh
cd %OMC%
echo %OMC%

java.exe -Djava.util.logging.config.file=logging.properties -Xms64M -Xmx6144M -cp "./OsmAndMapCreator.jar;./lib/OsmAnd-core.jar;./lib/*.jar" net.osmand.MainUtilities merge-address-index %CURDIR%\%country%_%region%.road.obf %CURDIR%\%country%*.obf

%INSP% %CURDIR%\%country%_%region%.road.obf | %BINDIR%\grep.exe "Address data %country%" | %BINDIR%\awk.exe "{print $1}" > address_index.txt
set /p ADDR_INDEX= < address_index.txt

REM ######################################################
REM Now extract the address map into a new <country>_address.obf
%INSP% -c %CURDIR%\%country%_%region%.address.obf %CURDIR%\%country%_%region%.road.obf +%ADDR_INDEX%
del /F /Q address_index.txt

cd %CURDIR%

:DONE
