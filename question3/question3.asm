.data
input_file_prompt: .asciiz "Enter a wave file name:\n"
input_size_prompt: .asciiz "Enter the file size (in bytes):\n"
heading_message: .asciiz "Information about the wave file:\n================================\n"
next_line: .asciiz "\n"
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
    
    # t0 contains address of 
    # li $v0, 1
    # move $a0, $a1
    # syscall


    la $s3, 0($a1)
    jal new_line

    # li $v0, 1
    # move $a0, $s3
    # syscall

    # s0 conatains address of first element
    la $s0, 0($s3)

    # jal new_line
    # li $v0, 1
    # move $a0, $s0
    # syscall

    # move $a0, $s0
    # li $v0, 4
    # syscall
    
    # s1 contains address of first data


    la $s1, 44($s3)

    # jal new_line
    # li $v0, 1
    # move $a0, $s1
    # syscall

    # s2 contains  last data
    sub $t0, $a2, 2
    add $s2, $s0, $t0 

    # jal new_line
    # li $v0, 1
    # move $a0, $s2
    # syscall



    sub $t0, $s2, $s1
    li $t1, 4
    div  $t0, $t1 #(divide by  2 for pairs)
    mfhi $t2
    
    # jal new_line
    # li $v0, 1
    # move $a0, $t2
    # syscall

    mflo $t3

    # jal new_line
    # li $v0, 1
    # move $a0, $t3
    # syscall



    #s4 stores the number of swaps/pairs   
    add $t4, $t3, $t2 # Add remainder to account for singletons
    addi $s4, $t4, -1 # Subtract 1 cuz we're starting at 0
    # jal new_line
    # li $v0, 1
    # move $a0, $s3
    # syscall

    # lw $t0, 0($s1)
    # addi $t1, $s2, -2 # $t1 is the last numb    # jal new_line
    # li $v0, 1
    # move $a0, $s3
    # syscaller 
    move $t3, $zero #t3 is the counter

    # jal new_line
    # li $v0, 1
    # move $a0, $t3
    # syscall

    jal reverse

    li $v0, 10

    syscall


reverse:
    #t0 address of smaller, t1 address of bigger
    #Calculate index
      

    # li $v0, 1
    # move $a0, $s4
    # syscall

    # li $v0, 1
    # move $a0, $t3
    # syscall


    beq $t3, $s4, return
    #t0 for head, t1 for tail
    mul $t6, $t3, 2
    add $t0, $t6, $s1
    sub $t1, $s2, $t6
    #t2 is a temp to store the value at t0
    
    #testing
    # jal new_line
    # li $v0, 1
    # move $a0, t3
    # syscall

    # # jal new_line
    # li $v0, 1
    # lh $a0, 0($t0)
    # syscall

    # # jal new_line
    # li $v0, 1
    # lh $a0, 0($t1)
    # syscall


    lh $t2, 0($t0)
    lh $t4, 0($t1)
    sh $t2, 0($t1)
    sh $t4, 0($t0) 
    
        #testing

    # jal new_line
    # li $v0, 1
    # lh $a0, 0($t0)
    # syscall

    # jal new_line
    # li $v0, 1
    # lh $a0, 0($t0)
    # syscall
    # jal new_line
    # li $v0, 1
    # lh $a0, 0($t1)
    # syscall

    # jal new_line
    # li $v0, 1
    # lh $a0, 0($t1)
    # syscall

    addi $t3, $t3, 1
    j reverse
    
    



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
