@echo off
REM  hvdwolf@gmail.com, May 2016
REM  This script downloads all regional roads_only maps for a certain country
REM  and converts it into a full roads_only map for that country
REM  and into a full address_map for that country

REM Requirements: awk, curl, unzip, wget and OsmAndMapCreator (newer than mid May 2016)


set URL="http://download.osmand.net/road-indexes/"
REM Specify full path to the tools
set BINDIR="C:\Users\harryvanderwolf\Downloads\OpenStreetMap-Osmadm\OsmAnd-AddressMaps\wintools"
REM Specify full path to the OsmAndMapCreator folder
set OMC="C:\Users\harryvanderwolf\Downloads\OpenStreetMap-Osmadm\OsmAndMapCreator"
set INSP="java.exe -Djava.util.logging.config.file=logging.properties -Xms64M -Xmx512M -cp "./OsmAndMapCreator.jar:./lib/OsmAnd-core.jar:./lib/*.jar" net.osmand.binary.BinaryInspector"

set CURDIR=%cd%
echo %CURDIR%

REM Specify country as option to this script
if "%1"=="" goto no_param
else goto process_country

:no_param
echo  "Syntax: %0% country"
echo "With country being one of: France Germany Italy (\"small\" countries are possible but don't make sense)"
echo You did not specify a country
goto DONE

:process_country
set country=%1
REM Note: Some countries do have a full map and  regional maps. In that case it is not usefull to use this script
REM listing=$(curl -s $URL | awk '{print $6}' | sed -e 's+href="++' -e 's+".*++' | grep ${1}.*road | grep -v ${1}_europe)
set listing=$(%BINDIR%\curl.exe -s %URL% | %BINDIR%\awk.exe '{print $6}' | %BINDIR%\sed.exe -e 's+href="++' -e 's+".*++' | %BINDIR%\grep.exe %%1%.*road)


for i in $listing;
do
REM	echo $i;
	%BINDIR%\wget.exe ${URL}${i} -O $i;
	%BINDIR%\unzip.exe -u $i;
	rm $i;
done

REM ######################################################
REM Now do the merging with utilities.sh
cd %OMC%
echo %OMC%

java.exe -Djava.util.logging.config.file=logging.properties -Xms64M -Xmx3512M -cp "%OMC%/OsmAndMapCreator.jar:%OMC%/lib/OsmAnd-core.jar:%OMC%/lib/*.jar" net.osmand.MainUtilities merge-address-index %CURDIR%/%1%.obf %CURDIR%/%1%*.obf

ADDRESS_INDEX="(%INSP% %CURDIR%/%%1%.obf 2>&1 | %BINDIR%\grep.exe "Address data" | %BINDIR%\awk.exe '{print %%1%}')"
echo %ADDRESS_INDEX%

REM ######################################################
REM Now extract the address map into a new <country>_address.obf
%INSP% -c %CURDIR%/%%1%_address.obf %CURDIR%/%%1%}.obf +%ADDRESS_INDEX%

:DONE
