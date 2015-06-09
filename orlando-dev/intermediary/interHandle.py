#!/usr/bin/python3

##-- Michael duPont
##-- interHandler.py
##-- Fetch data from Orlando's open data portal, format to be Citygram compliant, and print
##-- 2015-06-09

#Usage: python interHandler.py <service>
#Currently supports the following services:
#  - police
#  - landmarks

import sys , json , hashlib
if sys.version_info[0] == 2: import urllib2
elif sys.version_info[0] == 3: from urllib.request import urlopen
else: print("Cannot load urllib in interHandle")

#Prints a formatted JSON string of 'aDict' and exits the script
def output(aDict):
	print(json.dumps(aDict))
	sys.exit()

#Send error message if not correct number of options
if len(sys.argv) != 2: output({'Error':'Bad input'})

#Returns a dict (from JSON) from a given URL
def getJSON(url):
	try:
		if sys.version_info[0] == 2:
			response = urllib2.urlopen(url)
			html = response.read()
		elif sys.version_info[0] == 3:
			response = urlopen(url)
			html = response.read().decode('utf-8')
		return json.loads(html)
	except:
		output({'Error':'Data Fetch Error'})

#Service parent class definition
class service:
	id = ''
	geojson = {}
	
	#Class init where propList is the original object library
	def __init__(self , propList):
		self.properties = propList
	
	#Returns True if all given keys are in properties
	def checkForKeys(self , keyList):
		for item in keyList:
			if item not in self.properties: return False
			elif item in ['','NULL']: return False
		return True
	
	#The next two require child-specific implementation
	#Returns a string fully describing the alert/event
	def makeTitle(self):
		return ''
	
	#Returns a Citygram-compliant geometry dictionary
	def makeGeoJSON(self):
		return {}
	
	#Set the object id to be equal to the SHA-1 hex value of a string
	def setID(self , aString):
		hasher = hashlib.sha1()
		hasher.update(''.join(i for i in aString if ord(i)<128)) #Removes non-ascii chars
		self.id = hasher.hexdigest()
	
	#Returns True if object passes all validation tests
	def validate(self):
		try:
			assert('title' in self.properties)  #A title has been set in the properties dict
			assert(type(self.id) == str)        #The id is a string
			assert(self.id != '')               #The id has been changed
			assert(type(self.geojson) == dict)  #The geoLoc is a dict
			assert(self.geojson != {})          #The geoLoc has been changed
			return True
		except: return False
	
	#Formats and sets required data fields and runs verification test. Returns True if successful, else False
	def update(self):
		title = self.makeTitle()
		self.properties['title'] = title
		self.setID(title)
		self.geojson = self.makeGeoJSON()
		return self.validate()
	
	#Returns a Citygram-compliant version of the original object
	def export(self):
		return {'id': self.id , 'type': 'Feature' , 'geometry': self.geojson , 'properties': self.properties}

##--Child class definitions must implement makeTitle() and makeGeoJSON()
#OPD report feed
class policereport(service):
	def makeTitle(self):
		return 'A ' + self.properties['description'] + ' has occured at ' + self.properties['location'] + ' on ' + self.properties['calltime']
	def makeGeoJSON(self):
		return {'type': 'point' , 'coordinates': {'latitude': self.properties['location_1']['latitude'] , 'longitude': self.properties['location_1']['longitude']}}

#Landmarks/POI
class landmark(service):
	def makeTitle(self):
		return self.properties['name'] + ' at ' + self.properties['address']
	def makeGeoJSON(self):
		return {'type': 'point' , 'coordinates': {'latitude': self.properties['location']['latitude'] , 'longitude': self.properties['location']['longitude']}}

#Associates each service with its object, required keys, and fetch URL
optionDict = {
	'police': {'obj': policereport , 'reqKeys': ['description' , 'location' , 'calltime' , 'location_1'] , 'url': 'https://brigades.opendatanetwork.com/resource/ngeg-3ist.json'},
	'landmarks': {'obj': landmark , 'reqKeys': ['name' , 'address' , 'location'] , 'url': 'https://brigades.opendatanetwork.com/resource/hzkr-id6u.json'}
}

#MAIN SCRIPT
request = sys.argv[1]
#If the requested service is supported
if request in optionDict:
	featureList = []
	#Create a list of service objects from JSON data source
	objects = getJSON(optionDict[request]['url'])
	for item in objects:
		#Create new service object init'd with original object
		serv = optionDict[request]['obj'](item)
		#If original object contains all the required keys and their values are not null
		if serv.checkForKeys(optionDict[request]['reqKeys']):
			#If the new object updates and passes validation, append new object to featureList
			if serv.update(): featureList.append(serv.export())
	#Output/print the entire collection
	output({'type': 'FeatureCollection' , 'features': featureList})
#Else output/print error
else: output({'Error':'Not a valid service'})
