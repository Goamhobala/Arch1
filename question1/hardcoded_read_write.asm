# hardcoded_read_write.asm
.data
input_file_prompt: .asciiz "Enter:\n"
file_path: .space 4097 # max chars is 4096
input_size_prompt: .asciiz "file size: \n"
file_size: .word 0
output_heading: .asciiz "Heading:\n"
header_pointer: .word 1
hardcoded: .asciiz "/home/y/yhxjin001/CSC2002S/Arch1/question1/q1_t1_in.wav"
test_buffer: .space 44

.text # Starts code section of the program
.globl main # makes main visible to the linker

main:
    # Open hardcoded file
    li $v0, 13  # Opens file, takes 3 args.
    la $a0, hardcoded # a0 Address of file_path string
    li $a1, 0   # a1 flags (0 for read)           
    li $a2, 0   # a2 mode  (0 for permission, don't need this if not creating)
    syscall     
    move $t1, $v0

    # Test opening
    move $a0, $t1
    li $v0, 1
    syscall


    # Read HARDCODED file content into file buffer
    li $v0, 14  # 14 reads file
    move $a0, $t1 # Move file descriptor to a0
    la $a1, test_buffer # Move address of file buffer to a1
    li $a2, 256 # File Size == Number of Characters to read?
    syscall


    # Test reading
    move $a0, $v0
    li $v0, 1
    syscall

