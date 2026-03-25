// =============================================================================
// CS 271 Computer Architecture - Lab 02: Instruction Encoding
// Purdue University Fort Wayne
// =============================================================================
// OBJECTIVE:
//   Observe how logical instructions with complex immediate values are encoded
//   in ARMv8. Run this program, then answer the analysis questions in CA_lab_2.md.
//
// CONCEPTS:
//   - Immediate value encoding limits
//   - Using MOVZ and MOVK to build 32/64-bit values
//   - AND / ORR instructions with repeating bit patterns
//
// EXPECTED OUTCOME:
//   - X5 = 0x0000_0000_00ff_ffff
//   - X6 = result of AND with bitmask 0x00003ffc00003ffc
//   - X7 = result of ORR with bitmask 0x00003ffc00003ffc
//   - Simulation output: "[EDUCORE LOG]: Apollo has landed"
//
// =============================================================================

    .text
    .global _start

_start:
    // =========================================================================
    // STEP 1: Building a constant using MOVZ and MOVK
    // =========================================================================
    // We want to load X5 with the value 0x00FF_FFFF.
    // MOVZ only takes a 16-bit immediate, so we need two instructions.
    // MOVZ zeros out the rest of the register; MOVK keeps existing bits
    // and overwrites only the specified 16-bit chunk.

    MOVZ    X5, #0xffff                 // X5 = 0x0000_0000_0000_ffff
    MOVK    X5, #0x00ff, LSL #16        // X5 = 0x0000_0000_00ff_ffff

    // =========================================================================
    // STEP 2: Applying Logical Operations with Bitmasks
    // =========================================================================
    // ARM logical instructions only accept repeating bit-pattern immediates,
    // encoded via N, imms, and immr fields (13 bits total).
    // 0x00003ffc00003ffc is a valid repeating pattern.

    AND     X6, X5, #0x00003ffc00003ffc // X6 = X5 AND bitmask
    ORR     X7, X5, #0x00003ffc00003ffc // X7 = X5 OR  bitmask

    // =========================================================================
    // STEP 3: Signal Completion
    // =========================================================================
    YIELD
