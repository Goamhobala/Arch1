# question1.asm
.data
input_file_prompt: .asciiz "Enter:\n"
file_path: .space 4097 # max chars is 4096
input_size_prompt: .asciiz "file size: \n"
file_size: .word 0
output_heading: .asciiz "Heading:\n"
header_buffer: .space 44

.text # Starts code section of the program
.globl main # makes main visible to the linker

main:
    # Read file name
    la $a0, input_file_prompt
    li $v0, 4 
    syscall

    #Store file name
    la $a0, file_path
    li $a1, 100
    li $v0, 8
    syscall

    # move user input to $s0
    move $s0, $a0

    # Prompt to input file size
    la $a0, input_size_prompt
    li $v0, 4
    syscall

    # Read and store file size
    li $v0, 5   # If it's an integer, then the return value is stored in v0. If it's a string however, the register can't store it and thus requires an argument that contains an address to store the register
    syscall
    sw $v0, file_size # Saved the file size
    


    # Dynamically Allocate Memory for the File Buffer
    li $v0, 9
    lw $a0, file_size
    syscall

    move $s2, $v0 # v0 contains address of the allocated memory

    # Open the file
    li $v0, 13  # Opens file, takes 2 args.
    move $a0, $s0 # a0 Address of file_path string
    li $a1, 0   # a1 flags (0 for read)           
    li $a2, 0   # a2 mode  (0 for permission, don't need this if not creating)
    syscall     
    move $s3, $v0

    # Read file content into file buffer
    li $v0, 14  # 14 reads file
    move $a0, $s3 # Move file descriptor to a0
    move $a1, $s2 # Move address of file buffer to a1
    lw $a2, file_size # File Size == Number of Characters to read?
    syscall

    # Test Printing Chunk ID
    addi $a0, $s2, 22
    li $v0, 1
    syscall




    # Store file size
    
# Reference:
    # 22 Num Channels
    # 24 Sample Rate
    # 28 Byte Rate
    # 34 Bits per Sample


