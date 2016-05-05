#!/bin/bash

#
# hvdwolf@gmail.com, 20160318
# Quick and dirty script to download raw country file from geofabrik,
# remove all unnecessary data and only keep address (related) data
# Convert back to format for OsmAndMapCreator to create address obf file


if [ "$#" -ne "1" ] ; then
        echo "Syntax: $0 country"
        echo "With country being one of: france germany italy (others are possible but don't make sense - see readme)"
        exit 0
fi

country="$1"

wget http://download.geofabrik.de/europe/${country}-latest.osm.pbf -O ${country}-latest.osm.pbf
if [ "$?" -ne "0" ] ; then
        echo "Sorry, map download seems to have failed."
        exit 1
fi

osmconvert -v ${country}-latest.osm.pbf --drop-version --out-o5m > ${country}-latest.o5m

osmfilter ${country}-latest.o5m -v --keep="addr:* boundary=administrative =postal_code admin_level= place= highway=" --out-o5m > ${country}-address.o5m

osmconvert -v ${country}-address.o5m --out-pbf > ${country}-address.osm.pbf

rm -- *.o5m

