# OsmAnd-Address Maps
Script to create address maps for OsmAnd<br>
This is based on the new functionality in OsmAndMapCreator for versions after mid May 2016.<br>
(for previous github V1 version see [here](https://github.com/hvdwolf/OsmAnd-AddressMaps/tree/V1), for the previous github V2 version see [here](https://github.com/hvdwolf/OsmAnd-AddressMaps/tree/V2) or simply toggle the  "branch" button).<br>

# Requirements:
### General:
* A 64-bit Operating System with up to 6GB free memory (for Germany).
* OsmAndMapCreator version after mid May 2016
* a recent java version. 
* awk, grep (windows tools in the repo)

Note that you need to be on a 64bit OS and that you need a 64bit java. The memory demands are always above 1.5GB which means a 64bit java environment.

### Linux users:
Download the necessary tools via your package manager and download OsmAndMapCreator from http://download.osmand.net/latest-night-build/.

### Windows users:
Download OsmAndMapCreator from http://download.osmand.net/latest-night-build/.<br>
Install python (for example from [python.org](https://www.python.org/downloads/windows/))<br>
The other tools are in the wintools folder.<br>
*(awk and grep come from [GnuWin packages](http://gnuwin32.sourceforge.net/packages.html).)*


# Create full country address map for OsmAnd
* Set the full path to your osmandmapcreator folder inside the script (OMC variable)

   * Linux:`<path_to>/country_address_map.py <country>`
   * Windows: `python <disk>:\<path_to>\country_address_map.py <country>`<br>
   where `country` like Italy, Netherlands, France, Germany, Canada, Brazil, Australia, Russia or .....

After some time, depending on the beast you are running your script on, you will have in the `workfiles` folder a  `<country>_<region>.address.obf`.<br>
The `<country>_<region>.address.obf` only contains the full country addresses (obviously).

Copy the `<country>_<region>.address.obf` into the `android/data/net.osmand.plus/files` folder (`net.osmand` if you have the free version).
