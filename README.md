# Design Write-Up for 61C Project 2: CS61Classify

This document provides a design write-up for the provided RISCV assembly code. The code consists of multiple functions designed to perform various operations, including absolute value calculation, dot product, matrix multiplication, ReLU activation, and other utility functions for matrix I/O. These are all used for a letter classification machine learing model model

## Absolute Value Function (abs)

The `abs` function takes an integer pointer as an argument and calculates the absolute value of the integer. If the integer is positive or zero, it remains unchanged. If the integer is negative, it changes its sign to positive. The function modifies the value at the memory location pointed to by the input pointer.

## Argmax Function (argmax)

The `argmax` function finds the index of the largest element in an integer array and returns the index of the first occurrence of the largest element. The function takes three arguments: a pointer to the start of the array (`a0`), the number of elements in the array (`a1`), and it returns the index of the largest element (`a0`). If the number of elements is less than 1, the function terminates the program with error code 36.

## Dot Product Function (dot)

The `dot` function calculates the dot product of two integer arrays. It takes five arguments: two pointers to the start of the arrays (`a0`, `a1`), the number of elements to use (`a2`), and the stride of each array (`a3`, `a4`). The function returns the dot product result (`a0`). If the number of elements to use is less than 1 or if the stride of either array is less than 1, the function terminates the program with the corresponding error code.

## Matrix Multiplication Function (matmul)

The `matmul` function performs matrix multiplication of two integer matrices. It takes seven arguments: two pointers to the start of the matrices (`a0`, `a3`), the number of rows and columns in the first matrix (`a1`, `a2`), the number of rows and columns in the second matrix (`a4`, `a5`), and a pointer to the destination matrix (`a6`). The function returns void and sets the result matrix in memory.

The function includes error handling to check for invalid matrix dimensions. If any of the matrix dimensions are less than 1 or if the dimensions of the two matrices don't match for matrix multiplication, the function terminates the program with error code 38.

## ReLU Function (relu)

The `relu` function performs an inplace element-wise ReLU (Rectified Linear Unit) operation on an integer array. It takes two arguments: a pointer to the start of the array (`a0`) and the number of elements in the array (`a1`). If the number of elements is less than 1, the function terminates the program with error code 36. The function replaces negative elements in the array with zero while keeping positive elements unchanged.

## Matrix I/O Functions (read_matrix, write_matrix)

These functions are used to read and write integer matrices from/to binary files. The file format used is such that the first 8 bytes of the file represent two 4-byte integers, indicating the number of rows and columns in the matrix, respectively. The remaining bytes are used to store the elements of the matrix in row-major order.

The `read_matrix` function takes three arguments: a pointer to the filename (`a0`), pointers to integers representing the number of rows (`a1`) and columns (`a2`), and it returns a pointer to the matrix in memory (`a0`). If any file operation fails or the number of bytes read does not match the expected number, the function terminates the program with error code 1.

The `write_matrix` function takes four arguments: a pointer to the filename (`a0`), a pointer to the start of the matrix in memory (`a1`), the number of rows (`a2`), and the number of columns (`a3`). It writes the matrix data to the binary file as described in the file format section. If any file operation fails or the number of bytes written does not match the expected number, the function terminates the program with error code 1.

## Main Function (classify)

The `main` function serves as the entry point for the program. It processes the command-line arguments and then performs the following steps:

1. Loads two pre-trained matrices `m0` and `m1` from binary files specified in the command-line arguments.
2. Loads an input matrix from another binary file specified in the command-line arguments.
3. Performs matrix multiplication and ReLU activation on the input matrix using the pre-trained matrices `m0` and `m1`.
4. Writes the resulting output matrix to an output file specified in the command-line arguments.
5. Calculates the index of the largest element in the resulting output matrix using the `argmax` function.
6. Prints the index of the largest element, which is interpreted as a classification or label.

If the number of command-line arguments is incorrect, the program terminates with exit code 3.

## Error Handling

Throughout the code, there are error checks to ensure that the input matrices have valid dimensions, and the number of elements being processed is valid. In case of any errors, the program exits with appropriate error codes (36 for input errors and 38 for matrix dimension errors).
