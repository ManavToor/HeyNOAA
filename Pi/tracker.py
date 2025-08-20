import requests
import time

"""

    This file contains code that gets the satellites location from the n2yo.com

"""

##################################################
# Define constants
##################################################

# N2YO API Key
API_KEY = '8YERHU-S2D9VX-HRMEX2-5JAP' # TODO: hide


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

def get_current_satellite_position(sat_id, sat_position, lat, long, alt):
    if not sat_position:
        # update because sat_position is passed by reference
        sat_position.update(get_satellite_position(sat_id, lat, long, alt))
    print(sat_position)

    # check if current timestamp in sat_position
    for i in sat_position['positions']:
        if i['timestamp'] == int(time.time()):
            return i

    # if not get latest data and try again
    sat_position.clear()
    sat_position.update(get_satellite_position(sat_id, lat, long, alt))
    for i in sat_position['positions']:
        if i['timestamp'] == int(time.time()):
            return i

    # code should not reach here
    raise Exception('Unable to locate satellite')
