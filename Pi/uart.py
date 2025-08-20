import serial

"""

    This file contains code that sends azimuth and elevation commands to the FPGA over UART
    
    Azimuth is mapped from 0:360 to 0:360
    Elevation is mapped from -90:90 to 0:360
    
    Messages to FPGA will be sent as follows:
    
        AAAAAAAAAaaaaaaa000BBBBBBBBBbbbbbbb
        
        where:
            [0:8]   A - float 1 whole numbers 
            [9:15] a - float 1 fraction
            [16:24] B - float 2 whole numbers
            [25:31] b - float 2 fractions
            
"""

ser = serial.Serial('/dev/ttyS0', baudrate=115200)

def encode_number(f):
    """
    encodes float to unsigned 16-bit

    :param f: 0.00 to 365.00
    :return:
    """

    # split into integer and two decimals
    integer = int(f)
    fraction = int(round((f - integer) * 100))

    # pack into 16 bits
    return integer, fraction

def write(azimuth, elevation):
    a_int, a_frac = encode_number(azimuth)
    e_int, e_frac = encode_number((elevation + 90) * 2)

    frame = (a_int << 23) | (a_frac << 16) | (e_int << 7) | e_frac
    packet = frame.to_bytes(4, 'big')
    print(packet)
    ser.write(packet)

