# Haycore - RISC-V Processor Project
## Overview
Thanks for checking out this project! Welcome to Haycore—a simple, single-cycle, 32-bit processor designed to execute RISC-V instructions.

## How to use
As there is no compiler (since this is only a processor design with no external components), instructions are loaded by providing pre-compiled RISC-V. The easiest way to see a demonstration is by using the included, pre-written testbench. However, by replacing `tb_risc_v_top.v` with your own test bench and memfile.dat with your own precompiled RISC-V you can test this however you would want.

Step 1 is to clone the directory with the following commands after opening your terminal
```
cd your/directory/here
git clone https://github.com/haydenjones-ml/Haycore
```

### Included Test Bench Instructions
**Requires**: [Icarus Verilog](https://github.com/steveicarus/iverilog)<br>

Once icarus is installed, you can check code output and waveform using:
```
iverilog -o riscv_sim src/testbench/tb_risc_v_top.v src/mips/*.v src/datapath/*.v src/control_unit/*.v src/memory/*.v
vvp riscv_sim
```

### Custom Testbench Instructions
Change the code in `tb_risc_v_top.v` with whatever you desire. Make sure that the instructions used in your pre-compiled assembly (`memfile.dat` within the memory folder) reflect the behavior that you would like in your testbench.
