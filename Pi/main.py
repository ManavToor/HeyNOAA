import tracker, uart

import sys
import time

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

def azimuth_to_pwm(a):
    a = a / 2 # 180 deg servo controlling 360 deg via gear ratios
    a = (a * 0.00555555) + 1 # http://www.ee.ic.ac.uk/pcheung/teaching/DE1_EE/stores/sg90_datasheet.pdf
    return int(a * 1000) # return in ns

def elevation_to_pwm(e):
    e = e / 2 # 180 deg servo but will be restricted to 90 deg
    e = (e * 0.00555555) + 1.5 # http://www.ee.ic.ac.uk/pcheung/teaching/DE1_EE/stores/sg90_datasheet.pdf
    return int(e * 1000) # return in ns

def sat_pos_to_azimuth_and_elevation(pos):
    return pos['azimuth'], pos['elevation']

def main(sat):
    print('Current location: \n'
          f'LONG: {MY_LONG}\n'
          f'LAT: {MY_LAT}\n'
          f'ALT: {MY_ALT}')

    input('If you are happy with these coordinates, press ENTER to continue...')

    while True:
        pos = tracker.get_current_satellite_position(sat, sat_position, MY_LAT, MY_LONG, MY_ALT)
        azimuth, elevation = sat_pos_to_azimuth_and_elevation(pos)
        print(azimuth, elevation)
        uart.write(azimuth_to_pwm(azimuth), elevation_to_pwm(elevation))

        time.sleep(1)

if __name__ == '__main__':
    sat = sys.argv[1]
    selected_sat = ''
    match sat:
        case '19':
            main(NOAA_19_NORAD_ID)
        case '18':
            main(NOAA_18_NORAD_ID)
        case '15':
            main(NOAA_15_NORAD_ID)
        case _:
            print('Invalid satellite, please specify on of the following: 19, 18, 15')