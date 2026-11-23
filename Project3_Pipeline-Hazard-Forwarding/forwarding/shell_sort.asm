    .text
    .globl main

main:
      addi $2, $0, 0x2000
      addi $3, $0, 16
      add  $4, $0, $3   # Data Hazard  # 00_01
      nop 
      nop 
      nop 
L1:
      srl  $4, $4, 1    
      nop
      nop
      nop
      blez $4, done   # Control Hazard
      nop   # Control Hazard Delay Slot
      add  $5, $4, $0   # Data Hazard
      nop
      nop
      nop
L2:
      slt  $1, $5, $3    
      nop
      nop
      nop
      beq  $1, $0, L1   # Control Hazard
      nop   # Control Hazard Delay Slot
      sll  $6, $5, 2  
      nop   
      add  $6, $6, $2   # Data Hazard  # 10_00 
      lw   $7, 0($6)   # Data Hazard  # 10_00
      add  $8, $5, $0   # Data Hazard
      nop
      nop
      nop
L3:
      sub  $9, $8, $4    
      nop
      nop
      nop
      bltz $9, L4   # Control Hazard    
      nop   # Control Hazard Delay Slot
      sll  $10, $9, 2   
      nop   
      add  $10, $2, $10   # Data Hazard  # 00_10
      lw   $11, 0($10)   # Data Hazard  # 01_00
      nop
      slt  $1, $7, $11   # Data Hazard  # 00_10
      nop
      nop
      nop
      beq  $1, $0, L4   # Control Hazard
      nop   # Control Hazard Delay Slot
      sw   $11, 0($6)   # Data Hazard
      add  $6, $10, $0   # Data Hazard
      add  $8, $9, $0   # Data Hazard
      nop
      j    L3           
      nop
L4:
      sw   $7, 0($6)   # Data Hazard
      addi $5, $5, 1
      nop
      j    L2  
      nop
done:
      break              

    .data
LC0:
       .word   31028
       .word   16610
       .word   12937
       .word   7525
       .word   25005
       .word   17956
       .word   23964
       .word   13951
       .word   3084
       .word   23696
        .word   3881
       .word   11872
       .word   24903
       .word   16843
       .word   25957
       .word   25086
