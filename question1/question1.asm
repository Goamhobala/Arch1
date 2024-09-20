# question1.asm
.data
input_file_prompt: .asciiz "Enter a wave file name:\n"
input_size_prompt: .asciiz "Enter the file size (in bytes):\n"
heading_message: .asciiz "Information about the wave file:\n================================\n"
channel_message: .asciiz "Number of channels: "
sample_rate_message: .asciiz "Sample rate: "
byte_rate_message: .asciiz "Byte rate: "
bits_message: .asciiz "Bits per sample: "
next_line: .asciiz "\n"


file_path: .space 4097 # max chars is 4096
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

    # Test opening
#    move $a0, $t1
 #   li $v0, 1
  #  syscall

    # Read file content into file buffer
    li $v0, 14  # 14 reads file
    move $a0, $t1 # Move file descriptor to a0
    la $a1, header_pointer # Move address of file buffer to a1
    lw $a2, file_size # File Size == Number of Characters to read?
    syscall

  la $t0, header_pointer

  # Print heading message
  la $a0, heading_message
  li $v0, 4
  syscall

# Print data
  la $t0, 22($t0) # address to the number of channels
  la $t1, channel_message

  li $v0, 4
  move $a0, $t1
  syscall

  li $v0, 1
  lh $a0, 0($t0)
  syscall

  jal new_line

  la $t0, 2($t0) # address to the number of channels
  la $t1, sample_rate_message

  li $v0, 4
  move $a0, $t1
  syscall

  li $v0, 1
  lw $a0, 0($t0)
  syscall

  jal new_line

  la $t0, 4($t0) # address to the number of channels
  la $t1, byte_rate_message
  jal print_msg
  li $v0, 1
  lw $a0, 0($t0)
  syscall

  jal new_line

  la $t0, 6($t0) # address to the number of channels
  la $t1, bits_message
  jal print_msg
  li $v0, 1
  lh $a0, 0($t0)
  syscall



  li $v0, 10
  syscall

  # la $s1, 24($t0) # Address to the smaple rate
  # la $s2. 28($t0) # Address to byte rate

print_msg:
  # Take t0 as the integer
  # Take t1 as the message
  li $v0, 4
  move $a0, $t1
  syscall
  jr		$ra					# jump to $ra

new_line:
  la $a0, next_line
  li $v0, 4
  syscall
  
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
  # # Test before
  # lb $t1, 0($t0)
  # move $a0, $t1

  # li $v0, 1
  # syscall
  sb $zero, 0($t0)
  lb $t1, 0($t0)
  # move $a0, $t1
  # li $v0, 1
  # syscall
  jr $ra



    # Store file size
    
# Reference:
    # 22 Num Channels
    # 24 Sample Rate
    # 28 Byte Rate
    # 34 Bits per Sample



