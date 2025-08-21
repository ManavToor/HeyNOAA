import serial

"""

    This file contains code that sends azimuth and elevation commands to the FPGA over UART
    
    Azimuth is mapped from 0:360 to 0:360
    Elevation is mapped from -90:90 to 0:360
    
    Messages to FPGA will be sent as follows:
    
        aaaaaaaaaaa00eeeeeeeeeee
        
        where:
            [0:11]  a - pulse length (ns) of azimuth servo
            [12:13] 0 - bit stuffing
            [14:24] e - pulse length (ns) of elevation servo
            
"""

ser = serial.Serial('/dev/ttyS0', baudrate=115200)


def write(azimuth, elevation):
    frame = (azimuth << 13) | (elevation & 0x7FF)
    packet = frame.to_bytes(3, 'big')
    print(packet)
    ser.write(packet)

