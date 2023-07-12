.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -12         # Adjust stack pointer to make room for 3 words
    sw ra, 0(sp)             # Save return address
    sw a1, 4(sp)             # Save a1 (number of rows)
    sw a2, 8(sp)             # Save a2 (number of columns)

    # Open the file for reading
    la t0, fopen             # Load address of fopen function
    mv a0, a0                # Pass the filename pointer
    li a1, 0                 # Mode: read-only
    jalr t1, t0              # Call fopen
    beqz t1, handle_error_27 # If fopen returns 0, handle error (code 27)
    sw t1, 12(sp)            # Save file pointer for later use

    # Read the dimensions (number of rows and columns)
    lw t0, 4(sp)             # Load a1 (number of rows) from stack
    lw t1, 8(sp)             # Load a2 (number of columns) from stack
    li t2, 8                 # Number of bytes for dimensions (2 ints)
    la t3, 0(t1)             # Load address of the dimensions variable
    mv a0, t3                # Pass the dimensions variable address
    li a1, 1                 # Size of each element (1 byte)
    mv a2, t2                # Number of elements to read
    la t4, fread             # Load address of fread function
    lw a3, 12(sp)            # Load file pointer
    jalr t0, t4              # Call fread
    beqz t0, handle_error_29 # If fread returns 0, handle error (code 29)

    # Allocate memory for the matrix
    lw t0, 4(sp)             # Load a1 (number of rows) from stack
    lw t1, 8(sp)             # Load a2 (number of columns) from stack
    mul t0, t0, t1           # Calculate total number of elements (rows * columns)
    li t1, 4                 # Number of bytes per element
    mul t0, t0, t1           # Calculate total number of bytes
    la t1, malloc            # Load address of malloc function
    mv a0, t0                # Pass the number of bytes
    jalr t2, t1              # Call malloc
    beqz t2, handle_error_26 # If malloc returns 0, handle error (code 26)
    sw t2, 16(sp)            # Save matrix pointer for later use

    # Read the matrix elements
    lw t0, 16(sp)            # Load matrix pointer
    la t1, 0(t0)             # Load address of the matrix
    mv a0, t1                # Pass the matrix address
    li a1, 1                 # Size of each element (1 byte)
    lw a2, 4(sp)             # Load a1 (number of rows)
    lw a3, 8(sp)             # Load a2 (number of columns)
    la t2, fread             # Load address of fread function
    lw a3, 12(sp)            # Load file pointer
    jalr t0, t2              # Call fread
    beqz t0, handle_error_29 # If fread returns 0, handle error (code 29)

    # Epilogue
    lw a0, 16(sp)            # Load matrix pointer as return value
    lw ra, 0(sp)             # Restore return address
    addi sp, sp, 12          # Adjust stack pointer
    jr ra                    # Return

handle_error_26:
    li a0, 26                # Error code 26 (malloc error)
    j exit_program           # Jump to exit program

handle_error_27:
    li a0, 27                # Error code 27 (fopen error or eof)
    j exit_program           # Jump to exit program

handle_error_29:
    li a0, 29                # Error code 29 (fread error or eof)

exit_program:
    j exit                   # Terminate program
              # Return to the caller
