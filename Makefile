# =============================================================================
# CS 271 Computer Architecture - ARM Labs Makefile
# Purdue University Fort Wayne
# =============================================================================
# This Makefile simplifies the complex multi-step build and simulation process
# for ARM assembly targeting the Educore processor.
# =============================================================================

# -----------------------------------------------------------------------------
# Directory Configuration - Single-Cycle Processor (Labs 00-03)
# -----------------------------------------------------------------------------
EDUCORE_DIR   := Lab01/Educore-SingleCycle
HEAD_DIR      := $(EDUCORE_DIR)/head
SRC_DIR       := $(EDUCORE_DIR)/src
TESTS_DIR     := $(EDUCORE_DIR)/tests

# Directory Configuration - Pipelined Processor (Lab 04)
PIPELINE_DIR  := Lab04/Lab4_simple_pipeline
PIPE_HEAD     := $(PIPELINE_DIR)/head
PIPE_SRC      := $(PIPELINE_DIR)/src
PIPE_TESTS    := $(PIPELINE_DIR)/tests

# -----------------------------------------------------------------------------
# Tool Configuration
# -----------------------------------------------------------------------------
AS            := aarch64-linux-gnu-gcc
OBJCOPY       := aarch64-linux-gnu-objcopy
IVERILOG      := iverilog
VVP           := vvp
ASFLAGS       := -c -march=armv8-a

# =============================================================================
# Lab 00: Getting Started (Hello ARM)
# =============================================================================
.PHONY: lab00 sim_lab00

lab00: Lab00/hello_arm.s
	@echo "[BUILD] Assembling Lab00/hello_arm.s..."
	$(AS) $(ASFLAGS) -o Lab00/hello_arm.o Lab00/hello_arm.s
	$(OBJCOPY) -O verilog Lab00/hello_arm.o Lab00/hello_arm.mem
	@echo "[BUILD] Generated Lab00/hello_arm.mem"

sim_lab00: lab00 build_educore
	@echo "[SIM] Running Lab 00 simulation..."
	$(VVP) test_Educore.vvp +TEST_CASE=Lab00/hello_arm.mem

# =============================================================================
# Lab 01: STRCPY Exercise
# =============================================================================
.PHONY: lab01 sim_lab01

lab01: Lab01/test_STRCPY.s
	@echo "[BUILD] Assembling Lab01/test_STRCPY.s..."
	$(AS) $(ASFLAGS) -o Lab01/test_STRCPY.o Lab01/test_STRCPY.s
	$(OBJCOPY) -O verilog Lab01/test_STRCPY.o Lab01/test_STRCPY.mem
	@echo "[BUILD] Generated Lab01/test_STRCPY.mem"

sim_lab01: lab01 build_educore
	@echo "[SIM] Running Lab 01 simulation..."
	$(VVP) test_Educore.vvp +TEST_CASE=Lab01/test_STRCPY.mem

# =============================================================================
# Lab 02: Post-Increment Addressing
# =============================================================================
.PHONY: lab02 sim_lab02

lab02: Lab02/test_lab02.s
	@echo "[BUILD] Assembling Lab02/test_lab02.s..."
	$(AS) $(ASFLAGS) -o Lab02/test_lab02.o Lab02/test_lab02.s
	$(OBJCOPY) -O verilog Lab02/test_lab02.o Lab02/test_lab02.mem
	@echo "[BUILD] Generated Lab02/test_lab02.mem"

sim_lab02: lab02 build_educore
	@echo "[SIM] Running Lab 02 simulation..."
	$(VVP) test_Educore.vvp +TEST_CASE=Lab02/test_lab02.mem

# ========================================================================
# Lab 03: The Pipeline Detective
# ========================================================================

.PHONY: lab03 sim_lab03

sim_lab03: build_pipeline
	@echo "[SIM] Running Lab 03 Pipeline Detective simulation..."
	$(VVP) test_Pipeline.vvp +TEST_CASE=Lab03/mystery.mem

# =============================================================================
# Lab 04: Pipeline Hazards (Uses PIPELINED processor!)
# =============================================================================
.PHONY: lab04 sim_lab04 build_pipeline

lab04: Lab04/test_lab04.s
	@echo "[BUILD] Assembling Lab04/test_lab04.s..."
	$(AS) $(ASFLAGS) -o Lab04/test_lab04.o Lab04/test_lab04.s
	$(OBJCOPY) -O verilog Lab04/test_lab04.o Lab04/test_lab04.mem
	@echo "[BUILD] Generated Lab04/test_lab04.mem"

build_pipeline:
	@echo "[HW] Compiling Pipelined Processor Verilog..."
	$(IVERILOG) -g2012 -Wall \
		-I $(PIPE_HEAD) \
		-y $(PIPE_SRC) \
		-s test_Educore \
		$(PIPE_SRC)/*.v \
		$(PIPE_TESTS)/*.v \
		-o test_Pipeline.vvp
	@echo "[HW] Pipeline compiled to test_Pipeline.vvp"

sim_lab04: lab04 build_pipeline
	@echo "[SIM] Running Lab 04 simulation (PIPELINED)..."
	$(VVP) test_Pipeline.vvp +TEST_CASE=Lab04/test_lab04.mem

# =============================================================================
# Hardware Simulation (Educore Build - Single Cycle)
# =============================================================================
.PHONY: build_educore

build_educore:
	@echo "[HW] Compiling Educore Verilog (Single-Cycle)..."
	$(IVERILOG) -g2012 -Wall \
		-I $(HEAD_DIR) \
		-y $(SRC_DIR) \
		-s test_Educore \
		$(SRC_DIR)/*.v \
		$(TESTS_DIR)/*.v \
		-o test_Educore.vvp
	@echo "[HW] Educore compiled to test_Educore.vvp"

# =============================================================================
# Utilities
# =============================================================================
.PHONY: clean help

clean:
	@echo "[CLEAN] Removing build artifacts..."
	rm -f *.o *.mem *.vvp *.vcd
	rm -f Lab00/*.o Lab00/*.mem
	rm -f Lab01/*.o Lab01/*.mem
	rm -f Lab02/*.o Lab02/*.mem
	rm -f Lab03/*.o Lab03/*.mem
	rm -f Lab04/*.o Lab04/*.mem
	@echo "[CLEAN] Done."

help:
	@echo "CS 271 ARM Labs - Available Commands:"
	@echo ""
	@echo "  Single-Cycle Processor (Labs 00-03):"
	@echo "    make sim_lab00  - Lab 00: Introduction to ARM"
	@echo "    make sim_lab01  - Lab 01: String Copy (STRCPY)"
	@echo "    make sim_lab02  - Lab 02: Post-Increment Addressing"
	@echo "    make sim_lab03  - Lab 03: Instruction Exploration"
	@echo ""
	@echo "  Pipelined Processor (Lab 04):"
	@echo "    make sim_lab04  - Lab 04: Pipeline Hazards"
	@echo ""
	@echo "  Utilities:"
	@echo "    make clean      - Remove all build artifacts"
	@echo "    make help       - Show this help message"
