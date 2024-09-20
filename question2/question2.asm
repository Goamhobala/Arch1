# question2.asm

.data
input_file_prompt: .asciiz "Enter a wave file name:\n"
input_size_prompt: .asciiz "Enter the file size (in bytes):\n"
heading_message: .asciiz "Information about the wave file:\n================================\n"
next_line: .asciiz "\n"
max_message: .asciiz "Maximum amplitude: "
min_message: .asciiz "Minimum amplitude: "
file_path: .space 4098 # max chars is 4096
file_size: .word 0

.align 2
header_pointer: .word 0
hardcoded: .asciiz "/home/y/yhxjin001/CSC2002S/Arch1/question1/q1_t1_in.wav"


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
    la $t0, file_path
    # Counter
    move $t3, $zero
    #t0 stores the current char address of the string
    #t1 stores the target
    la $t1, next_line
    lb $t1, 0($t1)
    jal clean_path 

    sub $t0, $t0, $t3


    # Prompt to input file size"\n"
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
    la $t5, header_pointer
    sw $v0, 0($t5) # v0 contains address of the allocated memory
                   # Header pointer points to the memory location
   
    # Open the file
    li $v0, 13  # Opens file, takes 3 args.
    move $a0, $t0 # a0 Address of file_path string
    li $a1, 0   # a1 flags (0 for read)           
    li $a2, 0   # a2 mode  (0 for permission, don't need this if not creating)
    syscall     
    move $t1, $v0

    # Read file content into file buffer
    li $v0, 14  # 14 reads file
    move $a0, $t1 # Move file descriptor to a0
    la $a1, header_pointer # Move address of file buffer to a1
    lw $a2, file_size # File Size == Number of Characters to read?
    syscall

    # Access sample bit depth (34)
    la $t0, header_pointer
    lh $t1, 34($t0) # Sample bit depth is 16
    la $s1, 44($t0) # data head


    # # Calculate bytes per measurement
    # li $t2, 8
    # div $s0, $t1, $t2

    # Test (16 for file 1)
    # move $a0, $s0
    # li $v0, 1
    # syscall
    
    # #bit depth == 16 => 2bytes per measurement
    # lh $t0, 0($s1) #t0 is min
    # lh $t1, 0($s1)  #t1 is max


    # Calculating number of iterations
    lw $t3, file_size 
    sub $t3, $t3, 44
    move $t2, $zero
    
    add $t6, $t2, $s1
    lh $t4, 0($t6)
    # Initialise t0 and t1
    move $t0, $t4
    move $t1, $t4

    # #test accessing info
    # move $a0, $t5
    # li $v0, 1
    # syscall

    jal find_max_min

    # #test accessing info
    # lh $t3, 12($s1)
    # move $a0, $t3
    # li $v0, 1
    # syscall

    # Print heading message
    la $a0, heading_message
    li $v0, 4
    syscall

    la $a0, max_message
    li $v0, 4
    syscall

    move $a0, $t1
    li $v0, 1
    syscall

    jal new_line

    la $a0, min_message
    li $v0, 4
    syscall

    move $a0, $t0
    li $v0, 1
    syscall

    li $v0, 10
    syscall


    
find_max_min:
    # t4 stores current value

    add $t6, $t2, $s1
    lh $t4, 0($t6)
    #nothing at $t3 ($t3 - 2 contains the last bit of data, we're starting at 0!)
    beq $t2, $t3, return
    li $v0, 1
    move $a0, $t4
    syscall

    bgt $t0, $t4, replace_min
    blt $t1, $t4, replace_max


    # return if reached end
    addi $t2, $t2, 2
    j find_max_min

replace_min:
  move $t0, $t4
  # addi $t2, $t2, 2
  j find_max_min

replace_max:
  move $t1, $t4
  # addi $t2, $t2, 2 # Problem with this is that the first one is both the max and min
  j find_max_min


return:
  jr $ra


clean_path:
  #Loop for removing \n


  lb $t2, 0($t0)
  beq $t2, $t1, remove_char
  # Add counter for reverse later
  addi $t3, $t3, 1
  addi $t0, $t0, 1
  j clean_path
  
remove_char:
  sb $zero, 0($t0)
  lb $t1, 0($t0)
  jr $ra

new_line:
  la $a0, next_line
  li $v0, 4
  syscall
  
  jr $ra

# /home/y/yhxjin001/test2-2.wav
# /Users/youyasushi/test2-2.wav