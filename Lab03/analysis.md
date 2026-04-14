**Name:** Gabe Burns

# **Lab 03 Surfer Walkthrough**

Use this guide only after you have run:

make sim\_lab03

Your goal is to recover the 5 real instructions in mystery.mem using only the waveform in Surfer.

## Big Idea

You are not trying to guess randomly.

You are using the processor’s own evidence:

* what register gets written

* what value gets written

* what values entered the ALU

* what result came out of the ALU

* what cycle each event happened on

The NOPs create spacing between the real instructions, which makes the waveform easier to read.

There are two parts to the detective process:

1. Use the **Writeback stage** to identify that a real instruction finished, which register it wrote, and what final value it produced.

2. Then trace that same instruction **backward in time** to the **Execute stage** to determine how the result was created.

This is the key habit for the whole lab:

* WB\_\* tells you **what completed**

* EX\_\* and alu\_out tell you **how it was computed**

## Signals To Add In Surfer

Open dump.vcd and add these signals:

### Top-level testbench signals

* test\_Educore.core\_clk

* test\_Educore.cycle\_count

### Processor signals inside test\_Educore.educore

* WB\_write\_en

* WB\_rd\_addr

* WB\_ex\_out

* EX\_exec\_a

* EX\_exec\_n

* EX\_exec\_m

* alu\_out

### Optional but helpful

* register\_file.R\[9\]

* register\_file.R\[10\]

* register\_file.R\[11\]

* register\_file.R\[12\]

* register\_file.R\[13\]

If you do not know which registers to watch yet, start with only the writeback and execute-stage signals. Add specific registers later after you identify them from WB\_rd\_addr.

## What Each Signal Means

* core\_clk: the processor clock

* cycle\_count: the current processor cycle

* WB\_write\_en: high when an instruction writes back to the register file

* WB\_rd\_addr: which register is being written

* WB\_ex\_out: the value being written

* EX\_exec\_a, EX\_exec\_n, EX\_exec\_m: input values flowing into the Execute stage

* alu\_out: the ALU result for the current instruction in Execute

The most important pattern is this:

* when WB\_write\_en \= 1, a real instruction has completed

* when WB\_write\_en \= 0, it is usually a NOP or a non-writing instruction

For this lab, the 5 mystery instructions all write a register, so there should be exactly 5 meaningful writeback events.

## Important Note About Number Format

In this walkthrough, assume Surfer is set to Unsigned Decimal. When attempting to change to Unsigned Decimal the Format will just say unsigned. 

That means the important values should appear as:

* 7

* 12

* 19

* 15

If your display is not in decimal, change the signal format before continuing so your readings match the examples below.

## Step 1: Find The Five Real Instructions

Zoom out until you can see the entire short simulation.

Now focus on WB\_write\_en.

Every time WB\_write\_en goes high:

1. place the cursor on that event

2. read cycle\_count

3. read WB\_rd\_addr

4. read WB\_ex\_out

Fill in a table like this:

| Instruction \# | Cycle | Destination Register | Value Written |
| :---: | ----- | ----- | ----- |
| 1 | 5 | 9 | 7 |
| 2 | 9 | 10 | 12 |
| 3 | 13 | 11 | 19 |
| 4 | 17 | 12 | 15 |
| 5 | 21 | 13 | 15 |

This table is your primary evidence.

## Step 2: Decode The First Two Instructions

The first two real instructions are usually the easiest.

At the first WB\_write\_en \= 1 event:

* look at WB\_rd\_addr

* look at WB\_ex\_out

Ask:

* which register got written?

* what exact value was written?

If a register is written with a simple constant like 7 or 12, the most likely instruction is:

MOVZ Xd, \#imm

**MOVZ x9, \#7**

Why?

Because MOVZ is a very common way to place a small immediate constant directly into a register.

Do the same for the second writeback event.

After Step 2, you should have a very strong guess for Instructions 1 and 2\.

**MOVZ x10, \#12**

## Why Step 3 Changes

Up to this point, Writeback was enough because the first two instructions simply loaded small constants.

Instruction 3 is different.

If you only look at Writeback, you can tell:

* which register was written

* what final value was written

But you cannot reliably tell:

* which two source values were used

* whether the operation was ADD, SUB, ORR, or something else

For example, if you only know that a register ended with 19, that does not tell you how the processor produced 19.

So starting with Instruction 3, you must use a two-step process:

1. Find the instruction in Writeback.

2. Move backward in time to find that same instruction in Execute.

That is how reverse-engineering works in this lab.

## Step 3: Recover Instruction 3

Instruction 3 is the first instruction where the Writeback stage gives you the outcome, but the Execute stage reveals the operation.

Find the third time WB\_write\_en goes high.

At that moment, record:

* cycle\_count

* WB\_rd\_addr

* WB\_ex\_out

At this point, you should know:

* the destination register for Instruction 3

* the final value produced by Instruction 3

For this lab, the third writeback event should show:

* cycle 13

* WB\_rd\_addr \= 11

* WB\_ex\_out \= 19

That means Instruction 3 writes 19 into X11.

But that still does not tell you the exact operation.

Then move slightly earlier in time to when that same instruction is in the Execute stage.

Do not move to a random earlier point. Start at the third WB\_write\_en \= 1 event, then move left only a small amount until the same instruction is in Execute.

Important: once you move left into the Execute-stage view of that instruction, the WB\_\* signals may no longer belong to the same instruction. That is normal in a pipeline. Different instructions occupy different stages at the same time.

So use this rule:

* use WB\_write\_en, WB\_rd\_addr, and WB\_ex\_out to identify the instruction and its final result

* then move left in time

* once you are reading the Execute-stage version of that instruction, focus on EX\_exec\_n, EX\_exec\_m, and alu\_out

* do not expect WB\_rd\_addr and WB\_ex\_out to still match the same instruction after you move left

Now read:

* EX\_exec\_n

* EX\_exec\_m

* EX\_exec\_a

* alu\_out

For this instruction, ask:

1. Which two values are being combined?

2. Which of those values came from earlier instructions?

3. What simple arithmetic or logic operation turns the inputs into the output?

Examples of how to reason:

* if the inputs are 7 and 12, and the result is 19, the operation is probably ADD

* if the inputs are 19 and 4, and the result is 15, the operation is probably SUB

* if the inputs are 15 and 7, and the result is still 15, the operation is probably ORR

For Instruction 3, your job is to match the Execute-stage inputs to the Writeback-stage output.

If you are seeing values like 40 or 25600, you are probably not lined up with the correct moment for Instruction 3\. The third real instruction should match the two earlier constants and produce the same value later seen in WB\_ex\_out.

For example, a good Execute-stage snapshot for Instruction 3 would look like:

* EX\_exec\_n \= 7

* EX\_exec\_m \= 12

* alu\_out \= 19

At that same cursor position, the WB\_\* signals may be showing a different instruction entirely. That does not mean you are wrong. It means the pipeline has multiple instructions active at once.

So the reasoning is:

* Step 2 showed that earlier instructions created the constants 7 and 12

* Step 3 Writeback showed that Instruction 3 finished with result 19

* Step 3 Execute now shows the ALU combining 7 and 12 to make 19

That strongly supports:

ADD X11, X9, X10

Once you know:

* destination register

* two input values

* final output

you can write a strong guess for the exact assembly instruction.

## Step 4: Recover Instruction 4

Find the fourth writeback event.

Again, record:

* cycle\_count

* WB\_rd\_addr

* WB\_ex\_out

This tells you the completed result of Instruction 4\.

For this lab, the fourth writeback event should show:

* cycle 17

* WB\_rd\_addr \= 12

* WB\_ex\_out \= 15

So Instruction 4 writes 15 into X12.

Then move earlier to its Execute-stage activity.

Read:

* EX\_exec\_n

* EX\_exec\_m

* alu\_out

Now compare this instruction to what you already know about Instruction 3\.

At this point, you already know:

* Instruction 3 produced 19

* Instruction 4 produced 15

So your job is to see whether the Execute-stage inputs and output explain how the processor got from 19 to 15.

Ask:

* does one ALU input match the result written by Instruction 3?

* is the output slightly smaller than that earlier value?

* does this look like subtracting a small immediate?

If so, the instruction is likely something like:

SUB Xd, Xn, \#imm

Your evidence should support all three parts:

* the destination register

* the source register value

* the immediate amount

For this lab, the reasoning should be:

* one source value matches the earlier result 19

* the output becomes 15

* 19 \- 4 \= 15

That strongly supports:

SUB X12, X11, \#4

## Step 5: Recover Instruction 5

Find the fifth writeback event.

Record:

* cycle\_count

* WB\_rd\_addr

* WB\_ex\_out

For this lab, the fifth writeback event should show:

* cycle 21

* WB\_rd\_addr \= 13

* WB\_ex\_out \= 15

So Instruction 5 writes 15 into X13.

Then inspect its Execute-stage values.

For the last instruction, pay attention to whether:

* one input comes from Instruction 4

* the other input comes from one of the earlier constant registers

* the output equals one of the inputs exactly

That can happen in logical operations.

For example:

* 15 OR 7 \= 15

* 15 AND 7 \= 7

* 15 EOR 7 \= 8

So if the output stays the same as the larger input, ORR becomes a strong candidate.

For this lab, the reasoning should be:

* one input is 15, which matches the result of Instruction 4

* another input is 7, which matches the result of Instruction 1

* the final output is still 15

That strongly supports:

ORR X13, X12, X9

## Step 6: Cross-Check With The Register File

Once you think you know the five instructions, add the affected registers in the register file view.

For each register:

* confirm when it changes

* confirm the new value

* confirm the value matches what WB\_ex\_out showed

For this lab, you should eventually see:

* X9 \= 7

* X10 \= 12

* X11 \= 19

* X12 \= 15

* X13 \= 15

This is a great way to verify that your interpretation of WB\_rd\_addr was correct.

## Step 7: Write Your Best-Guess Assembly

At this point, you should be able to write the 5-instruction sequence in the order the instructions completed.

For each instruction, make sure your guess includes:

* the destination register

* the source register or immediate

* the operation

For this mystery program, the best-guess sequence should be:

Write your 5 instructions here:

**MOVZ x9, \#7**

**MOVZ x10, \#12**

**ADD x11, x9, x10**

**SUB x12, x11, \#4**

**ORR x13, x12, x9**

Do not worry about being perfect on the first pass.

The goal is to make the best evidence-based reconstruction possible from the waveform.

## A Good Student Workflow

Use this routine for every mystery instruction:

1. Find where WB\_write\_en is high.

2. Read cycle\_count, WB\_rd\_addr, and WB\_ex\_out.

3. Use that Writeback event to identify what instruction finished.

4. If the instruction is a simple constant load, you may already be able to identify it.

5. If the instruction is arithmetic or logic, move left to the Execute-stage portion for that same instruction.

6. Read EX\_exec\_n, EX\_exec\_m, and alu\_out.

7. Ask what operation transforms the inputs into the output.

8. Write your best-guess assembly instruction.

If you repeat that process five times, you can solve the whole lab without ever seeing the source file.

## Common Mistakes

* Counting NOPs as real instructions. Only count events where WB\_write\_en is high.

* Looking only at alu\_out and ignoring WB\_rd\_addr. You need both the operation and the destination register.

* Forgetting that the instruction is in different pipeline stages at different times.

* Reading the wrong moment in time. Use the cursor carefully.

* Ignoring cycle\_count. It makes the trace much easier to organize.

## Final Advice

This lab is not really about memorizing opcodes.

It is about learning how to use a waveform viewer like a computer architect:

* observe the signal

* form a hypothesis

* test it against another signal

* refine your conclusion

If your guessed instruction explains the register written, the ALU inputs, and the final output, then you have probably found the correct answer.