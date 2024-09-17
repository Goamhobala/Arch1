# question1.asm
.data
input_file: .asciiz "Enter:\n"
file_path: .space 100
input_size: .asciiz "file size: \n"
output_heading: .asciiz "Heading:\n"

.text # Starts code section of the program
.globl main # makes main visible to the linker

main:
    # Read file name
    la $a0, input_file
    li $v0, 4 
    syscall

    #Store file name
    la $a0, file_path
    li $a1, 100
    li $v0, 8
    syscall

    # move user input to $t0
    move $t0, $a0
    
    #Test that file name is stored
    li $v0, 4
    move $a0, $t0
    syscall

    li $v0, 10
    syscall


