import requests
import time

##################################################
# Define constants
##################################################

# N2YO API Key
API_KEY = '8YERHU-S2D9VX-HRMEX2-5JAP' # TODO: hide

# Satellite NORAD ID's
NOAA_19_NORAD_ID = '33591'
NOAA_18_NORAD_ID = '28654'
NOAA_15_NORAD_ID = '25338'


# Current location (will need to make this a variable eventually)
# Ottawa general longitude, latitude, altitude
MY_LONG = '45.41117'
MY_LAT = '-75.69812'
MY_ALT = '44' # metres above sea level

# Output of get_satellite_position()
# caches next 300s of satellite data to save space
sat_position = dict()

##################################################
# API Calls
##################################################
""" Hourly transcation limit:
    tle	            1000
    positions	    1000
    visualpasses	100
    radiopasses	    100
    above	        100 
    
    Refer to https://www.n2yo.com/api/ for parameter information """

def get_satellite_position(sat_id, lat, long, alt):
    # returns next 300s of satellite position
    return requests.get(f'https://api.n2yo.com/rest/v1/satellite/positions/{sat_id}/{lat}/{long}/{alt}/10&apiKey=' + API_KEY).json()

##################################################
# Functionality
##################################################

def get_current_satellite_position(sat_id):
    global sat_position
    if not sat_position:
        sat_position = get_satellite_position(sat_id, MY_LAT, MY_LONG, MY_ALT)
    print(sat_position)

    # check if current timestamp in sat_position
    for i in sat_position['positions']:
        if i['timestamp'] == int(time.time()):
            return i

    # if not get latest data and try again
    sat_position = get_satellite_position(sat_id, MY_LAT, MY_LONG, MY_ALT)
    for i in sat_position['positions']:
        if i['timestamp'] == int(time.time()):
            return i

    # code should not reach here
    raise Exception('Unable to locate satellite')
