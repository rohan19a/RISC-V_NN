.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    lw t0 0(a0) #load the pointer to the first element
    blt a1 x0 loop_end     #if the length of the array is less than 1, terminate the program
    addi t1 a1 0
    li t2 1

loop_start:
    blt t1 t2 loop_end     #if the length of the array is less than 1, terminate the program 
    
    bge t0 x0 loop_continue

    sw x0 0(a0) #store the current element if it is negative

loop_continue:
    addi a0 a0 4 #add 4 to the index
    addi t1, t1, -1     # Decrement the counter 
    lw t0 0(a0) #load the current element
   
    j loop_start

loop_end:
    # Epilogue
    jr ra
