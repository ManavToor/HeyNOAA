# HeyNOAA
NOAA weather satelite tracker robot

## Goals
Learn more about control theory and VHDL programming. Also get cool satelite pictures in the process.

# Overview
Allows for decoding NOAA satelite images autonomosly. 

<img width="1169" height="543" alt="image" src="https://github.com/user-attachments/assets/09c1ae0c-c6c1-460a-bafb-2ab83f69f388" />

## RTL V4
Will handle demodulation of RF signals. COTS component, used before, easy setup, strong track record.

## Raspberry Pi
Acts as computer proccessing incoming signal from RTL. RTL drivers are available on Raspberry Pi. There are many SDR signal processing libraries available through PIP, that provide a vary broad range of control and ease of use. To make the project more complicated we can try implementing our own FFT.

Will track satelite using N2YO API in python and send commands to FPGA to point in general direction. Will then command FPGA to scan sky until a signal is received.
Once signal is received, will lock onto satelite ,following it during pass (likely simple PID), using signal strength as input. In future, this task should be handed off to FPGA (because the point of this project is to learn VHDL but also an FPGA would be faster than a Pi. Secondly, this would reduce the bpower consumption of the Pi, which is important since this project will be powered by battery).


## FPGA
Has not been chosen, will likely be a basic development board (Terasic DE10 or Arty A7). At first will simply command servo to location desired by Pi, but once a working model is made, Pi control logic will be handed off to FPGA.

## Servo
Simple azimuth tower that will point at sky. One open loop servo for controlling direction (will move antenna around in a circle) and another closed loop for controlling pitch (will move antenna up and down). Might switch open loop servo to a stepper with an encoder, will make FPGA programming more fun. All components will be mounted to the antenna to make it as portable as possible. Prototype will not be weatherproof. A portable battery is required for the Pi as well as FPGA and motors.
