// =============================================================================
// CS 271 Computer Architecture - Lab 01: Counted Loop (Compatibility Version)
// Purdue University Fort Wayne
// =============================================================================
// NOTE:
//   This file name remains "test_STRCPY.s" because the existing Makefile and
//   autograder target expect it. The exercise below is a supported replacement.
// =============================================================================
// STUDENT NAME: Gabe Burns
// DATE:         2/25/2026
// =============================================================================
// OBJECTIVE:
//   Implement a counted loop using register arithmetic and conditional
//   branching. You will sum the values 5 + 4 + 3 + 2 + 1 into X4.
//
// EXPECTED OUTCOME:
//   - X0 = 0   (counter reaches zero)
//   - X4 = 15  (running sum)
//   - X5 = 5   (number of loop iterations)
//   - Simulation output: "[EDUCORE LOG]: Apollo has landed"
// =============================================================================

    .text
    .global _start

_start:
    // =========================================================================
    // STEP 1: Initialize Registers (Already done for you)
    // =========================================================================
    MOVZ    X0, #5          // Counter: starts at 5
    MOVZ    X1, #1          // Constant decrement/increment value
    MOVZ    X4, #0          // Running sum
    MOVZ    X5, #0          // Iteration counter

    // =========================================================================
    // STEP 2: Implement the Counted Loop (YOUR CODE GOES HERE)
    // =========================================================================
    // Loop behavior:
    //   1. Add X0 into X4
    //   2. Increment X5 by 1
    //   3. Decrement X0 by 1 while setting condition flags
    //   4. If X0 is not zero, branch back to the loop
    //
    // Supported instruction forms for this Educore build:
    //   - ADD  Xd, Xn, Xm
    //   - SUBS Xd, Xn, Xm
    //   - B.NE label

sum_loop:
    // TODO #1: Add X0 to the running sum in X4
    // Syntax: ADD Xd, Xn, Xm

    // YOUR CODE HERE
    ADD X4, X4, X0 // Add counter into running sum


    

    // TODO #2: Increment the iteration count in X5 using X1
    // Syntax: ADD Xd, Xn, Xm

    // YOUR CODE HERE
    ADD X5, X5, X1 // Increment iteration count
    
   

    // TODO #3: Decrement X0 by subtracting X1, and set flags
    // Syntax: SUBS Xd, Xn, Xm

    // YOUR CODE HERE
    SUBS X0, X0, X1 // Decrement counter and set flags
   
    

    // TODO #4: Branch back to sum_loop if X0 is NOT zero
    // Syntax: B.NE label

    // YOUR CODE HERE
    B.NE sum_loop // Loop again while X0 != 0
    
    // =========================================================================
    // STEP 3: Signal Completion (Already done for you)
    // =========================================================================
done:
    
    YIELD
