.data 

	A: .word 5
	B: .word 5
	C: .word 5
	D: .word 5
	E: .word 5

.text 

	lw  $s0, A 		# registrador $s0 recebe o conteúdo de A
	lw  $t0, B 		# registrador temporário $t0 recebe o conteúdo de B
	
	addi  $s0, $t0, 35 	# registrador $s0 recebe o conteúdo de B + 35 ( A = B + 35), logo $s0 deve ter o valor 40
	
	
	lw  $s1, C 		# registrador $s1 recebe o conteúdo de C
	lw $t1, E 		# registrador temporário $t1  recebe o conteúdo de E
	lw $t2, D 		# registrador temporário $t2 recebe o conteúdo de D
	
	sub  $t3, $t2, $s0  # registrador temporário $t3 recebe a sobtração dos conteúdos dos registradores $t2 e $s0  (D - A), logo $t3 deve ter o valor -35
	add $s1, $t1, $t3   # o registrador $s1 recebe a subtração dos conteúdos dos registradores $t2 e $t3   (D - A + E), logo $s1 deve ter o valor -30
	sw  $s1, C  	    # gravando o resultado na variável C
	
	li $v0, 1
    	lw $a0, C
    	syscall
