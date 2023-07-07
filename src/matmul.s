.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks

    # Check if the dimensions of m0 make sense
    beqz a1, invalid_dimensions_m0  # If # of rows of m0 is zero, terminate
    beqz a2, invalid_dimensions_m0  # If # of columns of m0 is zero, terminate

    # Check if the dimensions of m1 make sense
    beqz a4, invalid_dimensions_m1  # If # of rows of m1 is zero, terminate
    beqz a5, invalid_dimensions_m1  # If # of columns of m1 is zero, terminate

    # Check if the dimensions of m0 and m1 match
    bne a1, a2, dimensions_mismatch   # If # of columns of m0 != # of rows of m1, terminate

    # Prologue
    addi sp, sp, -4    # Allocate space on the stack
    sw ra, 0(sp)       # Save the return address

    # Outer loop
    li t4, 0           # Initialize the outer loop counter
    outer_loop_start:
        blt t4, t0, inner_loop_start    # If outer loop counter < # of rows of m0, enter inner loop
        j outer_loop_end                  # Otherwise, exit the outer loop

    # Inner loop
    inner_loop_start:
        li t5, 0           # Initialize the inner loop counter
        li t6, 0           # Initialize the result accumulator

        inner_loop:
            blt t5, t3, inner_loop_end     # If inner loop counter < # of columns of m1, continue inner loop

            # Perform multiplication and accumulation
            mul t0, t5, t1                 # Calculate the offset for m0
            add t0, a0, t0                 # Calculate the address of the element in m0
            lw t1, 0(t0)                   # Load the element from m0

            mul t0, t4, t3                 # Calculate the offset for m1
            add t0, a3, t0                 # Calculate the address of the element in m1
            mul t0, t0, t1                 # Calculate the offset for the column in m1
            add t0, t0, t5                 # Add the offset for the element in the column
            lw t3, 0(t0)                   # Load the element from m1

            mul t1, t1, t3                 # Multiply the elements
            add t6, t6, t1                 # Accumulate the result

            addi t5, t5, 1                 # Increment inner loop counter
            j inner_loop_start             # Repeat the inner loop

        inner_loop_end:
            # Store the result in the destination matrix
            mul t0, t4, t2                   # Calculate the offset for d
            add t0, a6, t0                   # Calculate the address of the element in d
            sw t6, 0(t0)                     # Store the result in d

            addi t4, t4, 1                   # Increment outer loop counter
            j outer_loop_start               # Repeat the outer loop

    outer_loop_end:

    # Epilogue
    lw ra, 0(sp)       # Restore the return address
    addi sp, sp, 4     # Deallocate space on the stack
    jr ra             # Return from the function

    # Error handling: Invalid dimensions for m0
    invalid_dimensions_m0:
        li a0, 38         # Set the exit code to 38
        ecall              # Terminate the program

    # Error handling: Invalid dimensions for m1
    invalid_dimensions_m1:
        li a0, 38         # Set the exit code to 38
        ecall              # Terminate the program

    # Error handling: Dimensions of m0 and m1 don't match
    dimensions_mismatch:
        li a0, 38         # Set the exit code to 38
        ecall              # Terminate the program
