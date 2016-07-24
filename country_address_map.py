#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Version 1.0, 201607, Harry van der Wolf

import os, sys, platform, re, zipfile
if sys.version_info<(3,0,0):
	# Fall back to Python 2's urllib2
	from urllib2 import urlopen
else:
	# For Python 3.0 and later
	from urllib.request import urlopen

#### Some neccessary variables ####
URL = "http://download.osmand.net/road-indexes/"
#Full path to the OsmAndMapCreator folder
# For example Linux or Mac OS/X
#OMC = "/media/harryvanderwolf/32GB/OpenStreetMap/OsmAndMapCreator"
# For example for windows; Note the double backslashes
OMC = "C:\\Users\\harryvanderwolf\\Downloads\\OpenStreetMap-Osmadm\\OsmAndMapCreator"
OSplatform = platform.system()
if OSplatform == "Windows":
	path_sep = "\\"
	INSP = 'java -Djava.util.logging.config.file=logging.properties -Xms64M -Xmx512M -cp "./OsmAndMapCreator.jar;./lib/OsmAnd-core.jar;lib/*.jar" net.osmand.binary.BinaryInspector'
	OSMCpath = "./OsmAndMapCreator.jar;./lib/OsmAnd-core.jar;./lib/*.jar"
else:
	path_sep = "/"
	INSP = 'java -Djava.util.logging.config.file=logging.properties -Xms64M -Xmx512M -cp "./OsmAndMapCreator.jar:./lib/OsmAnd-core.jar:lib/*.jar" net.osmand.binary.BinaryInspector'
	OSMCpath = "./OsmAndMapCreator.jar:./lib/OsmAnd-core.jar:./lib/*.jar"


region = "europe"  # Change this to asia, south_america or whichever relevant region

#### one or two functions ####
def purge(dir, pattern):
    for f in os.listdir(dir):
    	if re.search(pattern, f):
    		os.remove(os.path.join(dir, f))

### Start the stuff
# Check whether we have at least on country
if len(sys.argv) < 2:
	print("\n\n== You need to specify 1 or more countries")
	print(" Where country is Germany or France\n\n")
	sys.exit()
COUNTRY = sys.argv[1]

# Initialize file paths
realfile_dir  = os.path.dirname(os.path.abspath(__file__))
#print(realfile_dir)

# Use dictionary for our variables
var_dict = {}
WINTOOLS = os.path.join(realfile_dir, "wintools")
WORKDIR = os.path.join(realfile_dir, "workfiles")
if not os.path.exists(WORKDIR):
    os.makedirs(WORKDIR)

#clean the WORKDIR
purge(WORKDIR, '_address.obf')
purge(WORKDIR, '.zip')


response = urlopen( URL)
listing = response.read()
if sys.version_info>=(3,0,0):
	listing = str(listing, encoding='utf8' )
else:
	listing = str(listing)
#print(listing)
lines = listing.splitlines()
map_list = []
for line in lines:
	if COUNTRY in line:
		subline = line.split('road.obf.zip">')
		subline = subline[1].split('</a>')
		#print(subline[0] + "\n\n")
		region = subline[0].split('_2.road.obf.zip')
		#print(region[0])
		region = region[0].rsplit("_",1)
		#print(region[1])
		REGION = region[1]
		# Sometimes we have a full country roads map. We can't use that here
		if subline[0]!= COUNTRY + "_" + REGION + "_2.road.obf.zip":
			map_url = URL + subline[0]
			mapdownload = urlopen( map_url)
			print("\n== Downloading " + map_url)
			mapfile = os.path.join(WORKDIR, subline[0])
			map_list.append( mapfile.replace(".zip", "") )
			with open(mapfile, 'wb') as output:
				output.write(mapdownload.read())
			print("\n== Unzipping " + mapfile)
			zip_ref = zipfile.ZipFile(mapfile, 'r')
			zip_ref.extractall( WORKDIR )
			zip_ref.close()
			print("\n== Remove " + mapfile)
			os.remove( mapfile )
			mapfile = mapfile.replace(".zip", "")
			print("\n== Extract address segment from " + mapfile)
			addressfile = mapfile.replace("2.road", "address")
			os.chdir(OMC)
			if OSplatform == "Windows":
				os.system(INSP + " " + os.path.join(WORKDIR, mapfile) + " 2>&1 | " +  os.path.join(WINTOOLS, "grep.exe") + " \"Address data\" | " +  os.path.join(WINTOOLS, "awk.exe") + " \"{print $1}\" > " + os.path.join(WORKDIR, "index.txt"))
			else:
				os.system(INSP + " " + os.path.join(WORKDIR, mapfile) + " 2>\&1 | grep \"Address data\" | awk '{print $1}' > " + os.path.join(WORKDIR, "index.txt"))
			with open(os.path.join(WORKDIR, "index.txt"), "r") as indexfile:
				INDEX = indexfile.read()
			#print(INSP + " -c "  + os.path.join(WORKDIR, addressfile) + " " + os.path.join(WORKDIR, mapfile) + " +" + INDEX)
			os.system( INSP + " -c "  + os.path.join(WORKDIR, addressfile) + " " + os.path.join(WORKDIR, mapfile) + " +" + INDEX)
			os.remove( mapfile )
			os.remove(os.path.join(WORKDIR, "index.txt"))
# We are done with downloading, unzipping and extracting all address segments from the road files
# Now extract all address segments from the road file
print("\n\n== Now merge the separate address maps into a new <country>.address.obf ==")
os.chdir(OMC)
os.system('java -Djava.util.logging.config.file=logging.properties -Xms64M -Xmx7144M -cp ' + OSMCpath + ' net.osmand.MainUtilities merge-index ' + os.path.join(WORKDIR, (COUNTRY + "_" +  REGION + ".address.obf") ) + ' ' + WORKDIR + path_sep + '*_address.obf')
purge(WORKDIR, '_address.obf')
