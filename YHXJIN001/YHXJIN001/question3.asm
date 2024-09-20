.data
input_file_prompt: .asciiz "Enter a wave file name:\n"
input_size_prompt: .asciiz "Enter the file size (in bytes):\n"
heading_message: .asciiz "Information about the wave file:\n================================\n"
next_line: .asciiz "\n"
input_path: .space 4097 # max chars is 4096
file_size: .word 0
# File path is like a pointer that points to the actual location where the item is stored
output_path: .space 4097

.align 4
input_pointer: .word 0
.align 4
output_pointer: .word 0
hardcoded: .asciiz "/home/y/yhxjin001/test2.wav"
test_space: .space 4097


.text # Starts code section of the program
.globl main # makes main visible to the linker

main:
    # # Read file name
    # la $a0, input_file_prompt
    # li $v0, 4 
    # syscall

    #Store file name
    la $a0, input_path
    li $a1, 100
    li $v0, 8
    syscall
    # move file name input to $s0
    la $t0, input_path
    # Counter
    move $t3, $zero
    #t0 stores the current char address of the string
    #t1 stores the target
    la $t1, next_line
    lb $t1, 0($t1)
    jal clean_path 

    sub $t0, $t0, $t3
    
    #Store file name
    la $a0, output_path
    li $a1, 100
    li $v0, 8
    syscall

    la $t0, output_path
    
    # Counter
    move $t3, $zero
    #t0 stores the current char address of the string
    #t1 stores the target
    la $t1, next_line
    lb $t1, 0($t1)
    jal clean_path 

    sub $t0, $t0, $t3

    # Prompt to input file size"\n"
    # la $a0, input_size_prompt
    # li $v0, 4
    # syscall

    # Read and store file size
    li $v0, 5   # If it's an integer, then the return value is stored in v0. If it's a string however, the register can't store it and thus requires an argument that contains an address to store the register
    syscall
    sw $v0, file_size # Saved the file size
    
    # Dynamically Allocate Memory for the File Buffer
    li $v0, 9
    lw $a0, file_size
    syscall
    la $t5, input_pointer
    sw $v0, 0($t5) # v0 contains address of the allocated memory
                   # Header pointer points to the memory location

    li $v0, 9
    lw $a0, file_size
    syscall
    la $t5, output_pointer
    sw $v0, 0($t5) # v0 contains address of the allocated memory
                   # Header pointer points to the memory location

    # Open the input file
    li $v0, 13  # Opens file, takes 3 args.
    la $a0, input_path # a0 Address of input_path string
    li $a1, 0   # a1 flags (0 for read)           
    li $a2, 0   # a2 mode  (0 for permission, don't need this if not creating)
    syscall     
    move $t1, $v0

    # Read file content into file buffer
    li $v0, 14  # 14 reads file
    move $a0, $t1 # Move file descriptor to a0
    lw $a1, input_pointer # Move address of file buffer to a1
    lw $a2, file_size # File Size == Number of Characters to read?
    syscall
    
    # Open outputfile 
    li $v0, 13  # Opens file, takes 3 args.
    la $a0, output_path # a0 Address of input_path string
    li $a1, 66   # a1 flags (O_create )           
    li $a2, 511 # a2 mode  (777 for permission)
    syscall     
    move $t9, $v0

    # Read output file content into file buffer
    li $v0, 14  # 14 reads file
    move $a0, $t9 # Move file descriptor to a0
    lw $a1, output_pointer # load the address of allocated file buffer to a1
    lw $a2, file_size # File Size == Number of Characters to read?
    syscall



    lw $t0, input_pointer
    la $s0, 0($t0)  
    lw $t1, output_pointer
    la $s6, 0($t1)

    # move $a0, $s3
    # li $v0, 4
    # syscall


    # move $a0, $s3
    # li $v0, 1
    # syscall

    # la $a0, 0($s3)
    # li $v0, 4
    # syscall


    # li $v0, 1
    # move $a0, $s3
    # syscall

    
    # la $s0, 0($s3) # s0 conatains address of first element of file 1

    # la $s6, 0($s5) # s6 conatains address of first element of file 2
    li $t0, 0 # Counter
    li $t1, 44 # target

    # Copying header of input to output
    jal copy_header
    # Check
    # li $v0, 1
    # lh $a0, 22($s6)
    # syscall


    la $s1, 44($s0) # address of first data of file 1
    la $s5, 44($s6) # address of first data of file 2
    # jal new_line
    # li $v0, 1
    # move $a0, $s1
    # syscall

    lw $t0, file_size
    # sub $t1, $t0, 2   #t1 is how many bytes of data after header, -2 because the last is stored at last -2
    add $s2, $s0, $t0 # s2 contains  end of file 1

    add $s7, $s6, $t0 # s7 contains end of file 2

    # jal new_line
    # li $v0, 1
    # move $a0, $s2
    # syscall



    sub $t0, $s2, $s1
    li $t1, 2
    div  $t0, $t1 #(divide by  2 for pairs)
    mfhi $t2
    mflo $t3




    #s4 stores the number of swaps/pairs   
    # add $t4, $t3, $t2 # Add remainder to account for singletons
    sub $s4, $s2, $s1  


    # jal new_line
    # li $v0, 1
    # move $a0, $t3
    # syscall

    # li $v0, 1
    # lh $a0, 44($s0)
    # syscall

    # li $v0, 1
    # lh $a0, 44($s6)
    # syscall
    move $t3, $zero #t3 is the counter
    jal reverse

    # li $v0, 1
    # lh $a0, 44($s0)
    # syscall

    # li $v0, 1
    # lh $a0, 62($s6)
    # syscall
    move $a0, $t9
    li $v0, 16
    syscall
  

    # move $a0, $v0
    # li $v0, 1
    # syscall

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
    # add $t7, $t6, $s5 #t7 for first half data of file 2
    # sub $t1, $s2, $t6
    sub $t8, $s7, $t6 #t8 for second half data of file 2
    addi $t8, $t8, -2 # to offset the fact that we pivot s7 at the end of data

    lh $t2, 0($t0)
    # lh $t4, 0($t1)
    sh $t2, 0($t8)
    # sh $t4, 0($t7) 

    addi $t3, $t3, 1
    j reverse
    


copy_header:
    beq $t0, $t1, return
    add $t2, $t0, $s0 #Address of current file 1 element
    add $t3, $t0, $s6 # Address of current file 2 element
    lh $t4, 0($t2) # Load element in 0(t2) to t4
    sh $t4, 0($t3) # Save element in t4 to 0(t3) 
    addi $t0, $t0, 2
    j copy_header


    



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
