# OsmAnd-Address Maps V2
Scripts to create address maps for OsmAnd<br>
This is based on the new functionality in OsmAndMapCreator for versions after mid May 2016.<br>
(for previous github V1 version see [here](https://github.com/hvdwolf/OsmAnd-AddressMaps/tree/V1) or simply toggle the  "branch" button).<br>

# Requirements:
### General:
* A 64-bit Operating System with up to 6GB free memory (for Germany).
* OsmAndMapCreator version after mid May 2016
* a recent java version. 
* awk, curl, grep, sed, unzip and wget

Note that you need to be on a 64bit OS and that you need a 64bit java. The memory demands are always above 1.5GB which means a 64bit java environment.

### Linux users:
Download the necessary tools via your package manager and download OsmAndMapCreator from http://download.osmand.net/latest-night-build/.

### Windows users:
Download OsmAndMapCreator from http://download.osmand.net/latest-night-build/.<br>
The other tools are in the wintools folder.<br>
*(awk, grep, sed, unzip and wget come from [GnuWin packages](http://gnuwin32.sourceforge.net/packages.html). curl comes from [curl.haxx.se](https://curl.haxx.se/download.html))*


# Create full country roads_only map and an address map for OsmAnd
* Set the full path to your osmandmapcreator folder inside the script (OMC variable)
* (Windows) Set the full path to the wintools folder (comes with this repository)
* Create an empty directory like OBF (or whatever name)
* cd into that directory OBF
* start the script from the OBF folder with:

   * Linux:`<path_to>/full_address_map.sh <country>` where `country` like Italy, Netherlands, France, Germany
   * Windows: `<disk>:\<path_to>\full_address_map.cmd <country>` where `country` like Italy, Netherlands, France, Germany

After some time, depending on the beast you are running your script on, you will have in that OBF map a `<country>_road.obf` and a `<country>_address.obf`.<br>
The `<country>_road.obf` is a full roads_only map of that country with routing, transport, POIs, reduced map and (!) addresses.<br>
The `<country>_address.obf` only contains the full country addresses (obviously).

Notes: 
- based on roads_only maps as you will never be able to run a full Germany or France map from your Fat32 SD-card as it is too big.
- also based on roads_only maps as the address data is the same but the maps are much smaller, thereby downloading much faster, taking up less space and processed much faster.
- Italy for example can easily be run within 3.5GB memory but runs 3x as fast when given 5GB memory (2.2 GHz quad-core i7 with 3.5GB -> Italy 40-45 minutes; 6GB: Italy < 12 minutes, Germany < 45 minutes).


