Hello file contains code I used for my small project in VHDL
Tools:- Xilinx Vivado, zboard, Spartan6.

For_moving light 
```
Using “use” keyword, the library IEEE.STD_LOGIC_1164.ALL is imported in the VHDL design code. 
This library contains std logic functions which is used in the code. It is also used for signed, unsigned types and arithmetic operations.

ENTITY
The section entity is used to declare ports in the program. For instant in above code we declared clk, btnl, btnr, btnc, btnd and zswitch as an input and zled as an output.

 ARCHITECTURE
The architecture body represents the internal description of the design entity - its behavior. 
After defining signals and constants used in code, three processes are defined. 
All the processes are executed concurrently and statements within a process are executed sequentially. 
All processes are sensitized based on clk i.e. they are executed when clk value changes.

GENERATING CLOCK WITH 6Hz FREQUENCY
The FPGA board we are using runs at 100MHz clock frequency. 
Hence, it will not be possible to observer movements of the LEDs by naked eyes. 
Hence, we must reduce the clock frequency to a lower value so in order to observe the movement of LEDs and make sure that the VHDL code configured is as per our need.
For 6 Hz frequency, in order to get the appropriate clock cycle , we do the following calculations in MATLAB:

o clk = 100e6 o shift = 6 o max_count = round(clk/shift) = 16666667.00

Thus, we need to initialize a constant named “MAX_COUNT” in the VHDL code with the value => 16666667 (no. of clock cycles).
Now, To count this clock cycle at every rising edge of clock, we need a counter of appropriate length, which is calculated as:
o counter = round(log(max_count) / log (2)) o counter = 24.00

Hence, a 24-bit counter is used to lower down the frequency to 6Hz.

OPERATIONAL LOGIC 
At the rising edge of clk, buttons for rotation, stop and load switch are checked and corresponding signal is set. “btnl” for rotate left “btnr” for rotate right “btnc” for stop rotation “btnd” for load pattern from switches.

 ROTATIONAL LOGIC
When sr_pulse is 1 at rising edge of clk, logic as defined in algorithm for each patternis implemented.
```
For SPI
```

The SPI master communicates with SPI slave devices, such as sensors, using the SPI protocol. The provided VHDL code includes a state machine to control the SPI transaction, including clock generation, data transmission, and reception.

## Features

State Machine Control: Manages SPI communication using a state machine with states for idle, sending, receiving, and completion.
Clock Generation: Generates the SPI clock (SCK) using a clock divider.
Data Transmission: Sends 8-bit data to an SPI slave device.
Data Reception: Receives 8-bit data from an SPI slave device.
Slave Select Management: Controls the SS (Slave Select) line to activate/deactivate the slave.

Usage

Inputs

`clk`: System clock input.
`reset`: Asynchronous reset input.
`start`: Start signal for initiating SPI communication.

Outputs

`MOSI`: Master Out Slave In signal to send data to the slave.
`MISO`: Master In Slave Out signal to receive data from the slave.
`SCK`: Serial Clock signal.
`SS`: Slave Select signal.
`sensor_data`: 8-bit data received from the sensor.
```
