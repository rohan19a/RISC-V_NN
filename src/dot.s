.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    lw t0 0(a0)
    lw t1 0(a1)


    addi t2 a2 0


    addi t3 a3 0 # stride of arr0
    addi t4 a4 0 # stride of arr1

    addi t5 x0 1

    #catch errors
    blt a2 t5 error
    blt t3 t5 other_error
    blt t4 t5 other_error

    # Prologue

loop_start:

    mul t5 t0 t1
    add a0 a0 t3
    add a1 a1 t4

    addi t2 t2 -1

    blt t2 zero other_end

    lw t0 0(a0)
    lw t1 0(a1)

    j loop_start

loop_end:

    # Epilogue


    jr ra

other_end:
    add a0 x0 t5
    jr ra

error:
    li a0 36
    ecall

other_error:
    li a0 37
    ecall
