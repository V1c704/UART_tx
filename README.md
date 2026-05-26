# UART Transmitter (UART_TX)

## Overview
This repository contains the RTL implementation of a digital **UART (Universal Asynchronous Receiver-Transmitter) Transmission module** written in SystemVerilog. The circuit acts as a parallel-to-serial data converter, taking an 8-bit parallel data input and transmitting it serially over a single line according to standard UART protocol timing.

## Key Features
* **Baud Rate:** 9600 baud (derived from a 50MHz system clock).
* **Packet Structure:** 11-bit frame (1 Start Bit, 8 Data Bits, 1 Parity Bit, 1 Stop Bit).
* **Parity:** Even Parity (XOR calculated over all 8 data bits) for data integrity.
* **Stable Transmission:** Utilizes input data latching to prevent corruption if inputs switch mid-transmission.

## Concept & Architecture
The transmission process relies on a baud rate generator dividing the 50MHz clock down to 9600Hz. A bit tracker ensures the correct sequence of the 11-bit frame is routed through the output multiplexer, while a data register holds the initial 8-bit value steady throughout the entire cycle.

<img width="2136" height="590" alt="image" src="https://github.com/user-attachments/assets/68705537-d36a-49eb-8654-49e957d6fb6d" />


*(RTL schematic detailing the interconnects between the counters, registers, and control logic)*

## Module Descriptions

| Sub-Module | Purpose |
| :--- | :--- |
| **`reg0`** (Data Register) | Latches the 8-bit input data the moment the `start` signal is received. Ensures output remains stable even if input switches change midway through a transmission. |
| **`counter_baud_rate`** | Divides the 50MHz system clock down to the 9600 transmission speed. Division factor: ~`5208` clock cycles per bit. |
| **`counter_bit_select`** | A 4-bit counter that increments each time the baud period elapses, tracking which of the 11 bits is currently being sent. |
| **`crc_calc`** (Parity) | A combinational block that continuously calculates the XOR even parity of the latched input data. |
| **`mux`** (Output Mux) | Routes the correct bit (Start, Data[0-7], Parity, or Stop) to the output line (`out_tx`) based on the current state of the Bit Tracker. |
| **`toggle_ff`** & Logic | Control logic that coordinates the start of transmission, enables counters, and resets the system once all 11 bits are sent. |


## Verification Strategy
A testbench is included to verify sequential functionality and timing strictness before synthesis. 
* **Clock Period:** 20 ns (50MHz).
* **Test Data:** `Hex 55` (`8'b01010101`).
* **Initialization Sequence:** 1. Assert the reset (`rst = 1`) for 100 ns.
    2. Deassert reset and wait 35 ns.
    3. Trigger the `start` signal for exactly one clock cycle (20 ns).
    4. Run the simulation for 1.2 ms to observe the full 11-bit `out_tx` frame generation at the 9600 baud rate.

## Simulation Results

<img width="1710" height="189" alt="image" src="https://github.com/user-attachments/assets/f191a910-0859-4a22-9773-3fc1a0cafa5d" />

*Waveform demonstrating the successful transmission of `Hex 55` (`8'b01010101`). Notice the start bit dropping low, followed by the alternating data bits (1, 0, 1, 0, 1, 0, 1, 0), the calculated parity bit, and the stop bit returning high.*

## Future Improvements
* **Develop a `UART_RX` (Receiver) module to pair with this transmitter, completing a full bidirectional UART transceiver system.**
* Add a parameterized clock frequency and baud rate to make the module easily adaptable to different FPGA boards.

