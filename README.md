# UART Transmitter (UART_TX)

## Overview
This repository contains the RTL implementation of a digital **UART (Universal Asynchronous Receiver-Transmitter) Transmission module** written in Verilog. The circuit acts as a parallel-to-serial data converter, taking an 8-bit parallel data input and transmitting it serially over a single line according to standard UART protocol timing.

## Protocol Specifications
The transmission follows a strict 11-bit packet structure for every 8 bits of data transmitted at **9600 baud**:
* **1 Start Bit:** Always a logical `0` to signal the beginning of a transmission.
* **8 Data Bits:** Transmitted Least Significant Bit (LSB) first.
* **1 Parity Bit:** Calculated as an XOR over all 8 data bits (Even Parity) to ensure data integrity.
* **1 Stop Bit:** Always a logical `1` to signal the end of the packet.

## Architecture and Key Components
To achieve reliable sequential behavior without data corruption, the design utilizes several interconnected sub-modules:

* **Data Register (`reg0`):** Latches the 8-bit input data the moment the `start` signal is received. This ensures that if the input switches change midway through a transmission, the output remains stable and uncorrupted.
* **Baud Rate Generator (`counter_baud_rate`):** A counter responsible for dividing the system clock down to the target transmission speed. For a 50MHz clock and 9600 baud rate, the division factor is approximately `5208` clock cycles per bit (50,000,000 / 9600).
* **Bit Tracker (`counter_bit_select`):** A 4-bit counter that increments each time the baud period elapses, tracking which of the 11 bits (0 to 10) is currently being sent.
* **Parity Calculator (`crc_calc`):** A combinational block that continuously calculates the XOR parity of the latched input data.
* **Output Multiplexer (`mux`):** Routes the correct bit (Start, Data[0-7], Parity, or Stop) to the output line (`out_tx`) based on the current state of the Bit Tracker.
* **Control Logic (`toggle_ff` & Logic Gates):** Coordinates the start of transmission, enables the counters, and resets the system once all 11 bits have been successfully sent.

## Hardware & Board Setup
The design is targeted for an FPGA development board with a **50MHz system clock**.
* `clk`: 50MHz Clock
* `rst`: Switch [0] (Asynchronous/Synchronous reset handling)
* `data_in[1:8]`: Switches [1:8] (8-bit data input)
* `start`: Switch [9] (Initiates transmission)
* `out_tx`: Red LED 0 (Serial output line)

## Simulation & Testbench Details
A testbench is included to verify functionality before synthesis. Key simulation parameters based on the project requirements:
* **Clock Period:** 10 ns.
* **Test Data:** `254` (`8'b11111110`).
* **Initialization Sequence:** 1. Generate a reset condition for 10 clock cycles.
  2. At `30 ns`, trigger the `start` signal for exactly one clock cycle.
  3. Observe the `out_tx` waveform to verify the 11-bit frame generation at the correct baud rate intervals.

## Getting Started

