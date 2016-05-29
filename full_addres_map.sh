#!/bin/bash
#  hvdwolf@gmail.com, May 2016
#  This script downloads all regional roads_only maps for a certain country
#  and converts it into a full roads_only map for that country
#  and into a full address_map for that country

# Requirements: awk, curl, grep, sed, unzip, wget and OsmAndMapCreator (newer than mid May 2016)


URL="http://download.osmand.net/road-indexes/"
#Full path to the OsmAndMapCreator folder
OMC="/media/harryvanderwolf/32GB/OpenStreetMap/OsmAndMapCreator"
INSP="java -Djava.util.logging.config.file=logging.properties -Xms64M -Xmx512M -cp "./OsmAndMapCreator.jar:./lib/OsmAnd-core.jar:./lib/*.jar" net.osmand.binary.BinaryInspector"
region="europe"  # Change this to asia, south_america or whichever relevant region


CURDIR="$(pwd)"
echo $CURDIR


# Specify country as option to this script
if [ "$#" -ne "1" ] ; then
        echo "Syntax: $0 country"
        echo "With country being one of: France Germany Italy"
        exit 0
fi

# First remove earlier created maps
rm ${1}_${region}.road.obf ${1}_${region}.address.obf

# Note: Some countries do have a full map and  regional maps. In that case it is not usefull to use this script
listing=$(curl -s $URL | awk '{print $6}' | sed -e 's+href="++' -e 's+".*++' | grep ${1}.*${region}.*road)


for i in $listing;
do
#	echo $i;
	wget ${URL}${i} -O $i;
	unzip -u $i;
	rm $i;
done

# Only for the Netherlands
rm Netherlands_europe*
#######################################################
# Now do the merging with utilities.sh
cd ${OMC}
echo ${OMC}

java -Djava.util.logging.config.file=logging.properties -Xms64M -Xmx6144M -cp "$OMC/OsmAndMapCreator.jar:$OMC/lib/OsmAnd-core.jar:$OMC/lib/*.jar" net.osmand.MainUtilities merge-address-index ${CURDIR}/${1}_${region}.road.obf ${CURDIR}/${1}*.obf

ADDRESS_INDEX="$($INSP ${CURDIR}/${1}_${region}.road.obf 2>&1 | grep "Address data" | awk '{print $1}')"
echo $ADDRESS_INDEX

#######################################################
# Now extract the address map into a new <country>_address.obf
$INSP -c ${CURDIR}/${1}_${region}.address.obf ${CURDIR}/${1}_${region}.road.obf +${ADDRESS_INDEX}

