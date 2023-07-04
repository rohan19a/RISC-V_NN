.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    lw t0, 0(a0)      # Load the first element of the array
    addi t1, a1 0       # Load the number of elements
    
    li t3, 0         # Initialize the index of the largest element to 0
    li t4, 0         # Initialize the value of the largest element to 0
    
    beq t1, x0, loop_end  # If array length < 1, terminate the program
    
    li t4, -2147483648   # Initialize t4 with the smallest possible value
    
loop_start:
    beq t1, x0, loop_end   # If t1 == 0, exit the loop
    
    lw t5, 0(a0)      # Load the current element of the array
    
    ble t5, t4, loop_continue  # If current element <= largest element, continue
    
    mv t4, t5         # Update the largest element value
    mv t3, a0         # Update the index of the largest element
    
loop_continue:
    addi a0, a0, 4    # Increment the array pointer
    addi t1, t1, -1   # Decrement the counter
    
    j loop_start      # Jump to loop_start to process the next element

loop_end:
    # Epilogue
    mv a0, t3         # Move the index of the largest element to a0
    
    jr ra             # Return to the calling function