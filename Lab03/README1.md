# Lab 03: The Pipeline Detective

## Overview

In this lab, you will act as a hardware detective. You are given a mystery program (`mystery.mem`) running on our **Pipelined Processor**. You don't have the assembly source code! Instead, you must reverse-engineer what the program is doing by carefully analyzing the pipeline execution in the waveform viewer.

**Prerequisites:** You must have a solid understanding of the 5-stage pipeline (Fetch, Decode, Execute, Memory, Writeback).
**Estimated Time:** 45-60 minutes

---

## The Mystery

The `mystery.mem` file contains a sequence of **5 actual instructions**, separated by multiple `NOP` (No Operation) instructions to ensure they safely travel through the pipeline without data hazards.

Your job is to trace the execution and deduce:
1. What registers are being used?
2. What are the values being loaded or calculated?
3. What operation is occurring at each step?

### Step 1: Run the Mystery

We have already compiled `mystery.mem` for you. Run the simulation:

```bash
make sim_lab03
```

*(Note: This uses the `test_Pipeline.vvp` processor, not the single-cycle processor!)*

### Step 2: Open Surfer

Open `dump.vcd` in Surfer (or your preferred waveform viewer). Here are the most important signals to track inside `test_Educore > educore`:

*   `clk`: the processor clock
*   `EX_exec_a`, `EX_exec_n`, `EX_exec_m`: The datapath values entering the Execute stage.
*   `alu_out`: The result coming out of the ALU.
*   `WB_write_en`: High (1) if an instruction writing to a register has reached the Writeback stage.
*   `WB_rd_addr`: The destination register being written to in the Writeback stage (e.g., `0xa` = X10).
*   `WB_ex_out`: The final computed value being written into the register file.
*   `register_file > R[...]`: Watch specific registers once you figure out which ones are being targeted.

### Step 3: Analyze and Document

Use the clues left in the Writeback (`WB`) stage and Execute (`EX`) stage to answer the questions in **`analysis.md`**.

*Hint: An instruction fetched in Cycle 1 will reach the Writeback stage in Cycle 5. Look for spikes in `WB_write_en`!*

---

## Submission

Fill out your findings in **`analysis.md`** and commit your work:

```bash
git add .
git commit -m "Solved the Mystery Pipeline"
git push
```
