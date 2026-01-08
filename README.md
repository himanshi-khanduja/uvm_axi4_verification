AXI4 Protocol Verification using UVM

Overview:

This repository contains an AXI4 protocol verification project developed using SystemVerilog and UVM.
The goal of this project is to understand and verify AXI4 write and read transactions, burst behavior, and protocol handshaking through a structured UVM testbench.
At the current stage, the repository includes the RTL design, AXI interface, and UVM testbench components. More features and test scenarios will be added incrementally.

Features Implemented:

- AXI4 write and read channel support
- Burst handling FIXED
- Address and data phase separation
- UVM-based driver, monitor, sequencer, and scoreboard
- Transaction-level modeling using sequence items

Tools Used:

- SystemVerilog
- UVM
- QuestaSim (Mentor Graphics)

How to Compile and Simulate (QuestaSim):

- Run the following commands from the project directory:
- vlog package.sv interface.sv design.sv top.sv
- vsim top -voptargs="+acc" -do "run -all"
  
Explanation:
- vlog compiles all RTL and testbench files
- vsim top launches simulation with top as the top module
- +acc enables signal access for debugging
- run -all runs the simulation until completion

Current Status:

- Files uploaded and compiling
- Basic AXI transactions working
- Debugging and corner-case testing in progress

