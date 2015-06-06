#!/usr/bin/python3

#Intermediary Handler
#Fetch data from Orlando's open data portal,
#format to be citygram compliant, and print

import sys , json
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
	except Exception , e:
		output({'Error':'Lookup Error: Unknown Error (0) / ' + str(e)})

#Configure Landmarks dataset
def landmarks():
	jsonIn = getJSON('https://brigades.opendatanetwork.com/resource/hzkr-id6u.json')
	return(jsonIn)

#Configure Police reports dataset
def police():
	jsonIn = getJSON('https://brigades.opendatanetwork.com/resource/ngeg-3ist.json')
	return jsonIn

#Option -> function dictionary
optDict = {'landmarks': landmarks() , 'police': police()}

#Primary Handling (MAIN)
if sys.argv[1] in optDict: output(optDict[sys.argv[1]])
else: output({'Error':'Not a valid service'})