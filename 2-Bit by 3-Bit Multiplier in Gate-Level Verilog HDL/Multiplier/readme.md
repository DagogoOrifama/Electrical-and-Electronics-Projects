# 2-Bit by 3-Bit Multiplier in Gate-Level Verilog HDL

## Overview
This project involves the design and implementation of a 2-bit by 3-bit binary multiplier using gate-level Verilog HDL. The project is structured hierarchically, starting from basic building blocks like full adders and culminating in a complete multiplier circuit. The design is verified through comprehensive simulation using ModelSim. This work is part of the MSc Electronics and Electrical Engineering program at the University of Leeds.

## Features
- **Hierarchical Design**: The project utilizes a hierarchical approach, breaking down the multiplier design into smaller, manageable submodules.
- **Full Adder Module**: The fundamental building block, implemented using basic logic gates (AND, XOR), to perform binary addition.
- **Submodules**: Two submodules that instantiate the full adder to handle partial product generation and summation.
- **Verification and Validation**: The design undergoes rigorous testing using ModelSim, generating truth tables and output waveforms to ensure accuracy and reliability.

## Tools and Software
- **Quartus II 15.0**: Used as the Integrated Development Environment for system modeling.
- **ModelSim 10.3d**: Employed for simulating the design, generating test benches, and validating the circuit's correctness through truth tables and waveforms.

## Design Methodology
1. **Full Adder Design**: The core component of the multiplier, designed with two AND gates and an XOR gate, validated through simulation.
2. **Submodules**: Intermediate modules that combine full adders and logic gates. Each submodule is responsible for different parts of the multiplication process.
3. **Multiplier Module**: The top-level module that integrates all submodules and performs the multiplication operation. The design is visualized using RTL viewers and validated through ModelSim simulations.

## Code Structure
- **Full Adder Module**: Basic building block with its test bench.
- **Submodule 1 & 2**: Intermediate modules that combine full adders and logic gates, each with its own test bench.
- **Multiplier Module**: Top-level module that integrates all submodules and performs the multiplication operation, along with its test bench for overall verification.

## Conclusion
This project demonstrates a systematic approach to designing and verifying a digital logic circuit in Verilog HDL. The integration of test benches and simulations ensures the design's correctness and reliability. The 2-bit by 3-bit multiplier is a fundamental example of how complex digital circuits can be constructed from basic logic gates and verified for accuracy.

## Project Files
The project includes the following key files:
- `FullAdder.v`: Verilog code for the full adder module.
- `SubModule1.v`: Verilog code for submodule 1.
- `SubModule2.v`: Verilog code for submodule 2.
- `MultCal.v`: Verilog code for the top-level multiplier module.
- Test benches for each module to verify their functionality.

## Author
- **Dagogo Godwin Orifama**
- **dagoris2010@gmail.com**