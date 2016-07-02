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
* Set the region in case you are making mapsfor another region than europe
* Create an empty directory like OBF (or whatever name)
* cd into that directory OBF
* start the script from the OBF folder with:

   * Linux:`<path_to>/full_address_map.sh <country>` where `country` like Italy, Netherlands, France, Germany
   * Windows: `<disk>:\<path_to>\full_address_map.cmd <country>` where `country` like Italy, Netherlands, France, Germany

After some time, depending on the beast you are running your script on, you will have in that OBF map a `<country>_<region>.road.obf` and a `<country>_<region>.address.obf`.<br>
The `<country>_<region>.road.obf` is a full roads_only map of that country with routing, transport, POIs, reduced map and (!) addresses.<br>
The `<country>_<region>.address.obf` only contains the full country addresses (obviously).

Copy the `<country>_<region>.road.obf` inside the `roads` folder inside your `android/data/net.osmand.plus/files` folder (net.osmand if you have the free version).<br>
Copy the `<country>_<region>.address.obf` inside the `android/data/net.osmand.plus/files` folder (net.osmand if you have the free version).


Notes: 
- based on roads_only maps as you will never be able to run a full Germany or France map from your Fat32 SD-card as it is too big.
- also based on roads_only maps as the address data is the same but the maps are much smaller, thereby downloading much faster, taking up less space and processed much faster.
- Italy for example can easily be run within 3.5GB memory but runs 3x as fast when given 5GB memory (2.2 GHz quad-core i7 with 3.5GB -> Italy 40-45 minutes; 6GB: Italy < 12 minutes, Germany < 45 minutes).


# Create full Dutch map
As mentioned above: most countries that are split up in regional maps are simply too big for a single map file.<BR>
The script "full_Dutch_map.cmd" creates a full Dutch map including the full address data. The script also works for example for Italy and Japan but not for France and Germany as the created submaps already exceed 2Gb which java does not allow and which will not function anyawy on a FAT formatted SDcard as the filesize limit is 2GB.<br>
Simply starting the script without parameters will create the Dutch map.<br>
Starting the script like `full_Dutch_map Italy` will create the full Italy map.
