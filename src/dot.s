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

    blt t2 zero loop_end

    # Prologue


loop_start:












loop_end:


    # Epilogue


    jr ra
