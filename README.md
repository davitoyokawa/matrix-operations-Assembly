# NxM Matrix Operations in Assembly (x86)

## Features
- **Matrix Input**: Allows users to define the number of rows (N) and columns (M) and fill the matrix with values
- **Matrix Display**: Prints the matrix in a formatted output
- **Element Search**: Searches for a specific value in the matrix and displays its position
- **Main Diagonal Extraction**: Displays the main diagonal if the matrix is square.
- **Lucky Numbers**: Identifies "lucky numbers" in the matrix (smallest element in its row and largest in its column)
- **Memory Allocation**: Dynamically allocates memory for the matrix using `malloc`
- **Menu**: A simple menu-driven interface to interact with the program.

## Technologies Used
- **Assembly (x86, AT&T syntax)**
- **Linux system calls**
- **GCC (GNU Compiler Collection)**
- **`printf`, `scanf`, and `malloc` (linked from C standard library)**

## How to Compile and Run
1. Assemble and link the program:
   ```sh
   as --32 matrix.s -o matrix.o
   ld -m elf_i386 matrix.o -o matrix -lc -dynamic-linker /lib/ld-linux.so.2
   ```
2. Run the program:
   ```sh
   ./matrix
   ```
   
## Notes
- This program is designed for **Linux** and requires **32-bit compatibility**
- The implementation relies on **AT&T syntax** for assembly language
- The project is part of an academic assignment for the **State University of Maringá (UEM)**.
