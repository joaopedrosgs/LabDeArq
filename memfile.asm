  addi $s1, $zero, 0xfc # final da memoria de video 
loop1:
  addi $s0, $zero, 0xa4 # inicio da memoria de video +1 
loop2:
  lw   $t0, 0($s0)
  addi $t0, $t0, 1
  sw   $t0, 0($s0)
  addi $s0, $s0, 4
  beq  $s0, $s1, loop1
  j loop2