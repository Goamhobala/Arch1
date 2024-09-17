# question1.asm
.data
input_file_prompt: .asciiz "Enter:\n"
file_path: .space 4097 # max chars is 4096
input_size_prompt: .asciiz "file size: \n"
file_size: .word 0
output_heading: .asciiz "Heading:\n"


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
    move $t0, $v0 # Saved the file size
    
    # Testing:
    move $a0, $t0
    li $v0, 1
    syscall


    # Store the valu