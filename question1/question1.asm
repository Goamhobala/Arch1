# question1.asm
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
    # Read file name
    la $a0, input_file_prompt
    li $v0, 4 
    syscall

    #Store file name
    la $a0, file_path
    li $a1, 100
    li $v0, 8
    syscall

    # move file name input to $s0
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
    la $t0, header_pointer
    sw $v0, 0($t0) # v0 contains address of the allocated memory
                   # Header pointer points to the memory location
   
    # Open the file
    li $v0, 13  # Opens file, takes 3 args.
    la $a0, hardcoded # a0 Address of file_path string
    li $a1, 0   # a1 flags (0 for read)           
    li $a2, 0   # a2 mode  (0 for permission, don't need this if not creating)
    syscall     
    move $t1, $v0

    # Test opening
#    move $a0, $t1
 #   li $v0, 1
  #  syscall

    # Read file content into file buffer
    li $v0, 14  # 14 reads file
    move $a0, $t1 # Move file descriptor to a0
    la $a1, test_buffer # Move address of file buffer to a1
    li $a2, 132344 # File Size == Number of Characters to read?
    syscall


    # Test reading
 #   move $a0, $v0
   # li $v0, 1
    #syscall


    # Test Printing Chunk ID
 #   lw $t2, 0($t0) #load the first item in the location (pointer)
    la $t0, test_buffer
    la $a0, 22($t0) # Load address of first item of the file (item stored in that location)
    li $v0, 1
    syscall

    li $v0, 10
    syscall



    # Store file size
    
# Reference:
    # 22 Num Channels
    # 24 Sample Rate
    # 28 Byte Rate
    # 34 Bits per Sample


