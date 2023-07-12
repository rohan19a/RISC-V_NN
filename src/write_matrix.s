.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -32       # Allocate stack space
    sw ra, 28(sp)          # Save return address
    sw a0, 0(sp)           # Save filename pointer
    sw a1, 4(sp)           # Save matrix pointer
    sw a2, 8(sp)           # Save number of rows
    sw a3, 12(sp)          # Save number of columns

    # Open the file in binary mode for writing
    la a0, open_mode       # Load the address of the open mode string
    li a1, 0               # Zero for read/write/execute permissions
    jal ra, fopen          # Call fopen
    beqz a0, error_exit    # If fopen returns NULL, jump to error_exit
    sw a0, 16(sp)          # Save file pointer

    # Write the number of rows and columns to the file
    lw a0, 8(sp)           # Load number of rows
    lw a1, 12(sp)          # Load number of columns
    la a2, file_header     # Load the address of the file header
    li a3, 8               # Number of bytes to write
    jal ra, fwrite         # Call fwrite
    bnez a0, error_exit    # If fwrite returns a non-zero value, jump to error_exit

    # Write the matrix to the file
    lw a0, 4(sp)           # Load matrix pointer
    lw a1, 8(sp)           # Load number of rows
    lw a2, 12(sp)          # Load number of columns
    la a3, file_header_len # Load the address of the file header length
    addi a3, a3, 8         # Add 8 bytes to skip the header
    mul a2, a2, 4          # Multiply number of columns by 4 to get element size
    mul a1, a1, a2         # Multiply number of rows by element size
    jal ra, fwrite         # Call fwrite
    bnez a0, error_exit    # If fwrite returns a non-zero value, jump to error_exit

    # Close the file
    lw a0, 16(sp)          # Load file pointer
    jal ra, fclose         # Call fclose
    bnez a0, error_exit    # If fclose returns a non-zero value, jump to error_exit

    # Epilogue
    lw ra, 28(sp)          # Restore return address
    addi sp, sp, 32        # Deallocate stack space
    jr ra                 # Return

error_exit:
    li a7, 27              # Error code 27 for fopen/fclose/fwrite error
    li a0, 1               # Print error message to stdout
    ecall                  # System call to terminate the program

.data
open_mode: .asciiz "wb"            # File open mode: write in binary mode
file_header: .space 8              # File header for number of rows and columns
file_header_len: .word 8           # Length of the file header
