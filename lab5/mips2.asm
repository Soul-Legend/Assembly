.data
	row: .word 0 
	col: .word 0
	value: .word 0
	mat: .word

.text 

	la 	$s0, row
	la 	$s1, col
	la	$s2, mat
	
	lw	$s3, 0($s0)
	lw	$s4, 0($s1)
	
	addi	$s2, $s2,  20
	
	la	$s6, value
	lw	$s7, 0($s6)
	

linha:
	beq	$s3, 16, exit

	add	$s4, $zero, $zero
	sw	$s4, 0($s1)
	
	jal 	coluna
	
	addi	$s3, $s3, 1
	sw	$s3, 0($s0)
	
	j 	linha
exit:
	li	$v0, 10
	syscall
	
	
coluna:
	bne	$s4, 16, continua
	jr	$ra
	
continua:	
	mul	$t0, $s3, 4
	mul	$t1, $s4, 64
	add	$t0, $t0, $t1
	add	$t0, $t0, $s2
	
	sw	$s7, 0($s6)
	
	sw	$s7, 0($t0)
	addi	$s7, $s7, 1
	
	addi	$s4, $s4, 1
	sw	$s4, 0($s1)
	
	j 	coluna
