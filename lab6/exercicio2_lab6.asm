.data

.text

main:
	# ======================================
	#  	    Funcao principal
	# ======================================
	# Recebe numero a ser calculado fatorial,
	# chama procedimento que realiza o cal-
	# culo e então imprime no terminal.
	#
	
	li	$v0, 5			# Receba via teclado o valor do número a 
	syscall				# ser calculado o fatorial
	move 	$a0, $v0		#

	jal 	fatorial		# Chama fatorial

	move	$s0, $v0		# Salva valor retornado pelo fatorial

	li 	$v0, 1			# Imprime resultado no terminal
	move	$a0, $s0		#
	syscall				#
	
	li	$v0, 10			# Encerra programa
	syscall				#

fatorial:

	# ======================================
	#         Procedimento fatorial
	# ======================================
	# Calcula o fatorial de um numero forne-
	# cido em $a0.
	#
	# argumentos:
	#   $a0 = Valor para calcular o fatorial
	# 
	# retorno: 
	#   $v0 = Valor do fatorial calculado
	
	addi 	$sp, $sp, -8		# Salva $s0 e $ra na pilha
	sw	$s0, 4($sp)		#
	sw	$ra, 8($sp)		#
	
	move	$s0, $a0
	
	beq	$s0, 0, igualZero	# Se é igual a zero retorna 1

	bne	$s0, 1, diferenteDeUm	# Se é igual a 1, fatorial retorna 1
					# e volta executando as mults
igualZero:
	li	$v0, 1			# Carrega o registrador de retorno($v0) com 1
	
	lw	$s0, 4($sp)		# Retorna $s0 e $ra da pilha
	lw	$ra, 8($sp)		#
	addi	$sp, $sp, 8		#
	
	jr	$ra			# Retorna ao procedimento chamador
	
diferenteDeUm:

	subi	$a0, $s0, 1
	
	jal 	fatorial		# Chama fatorial
	
	mul	$v0, $s0, $v0		# Multiplica X * fatorial(X-1)

	lw	$s0, 4($sp)		# Retorna $s0 e $ra da pilha
	lw	$ra, 8($sp)		#
	addi	$sp, $sp, 8		#
	
	jr	$ra			# Retorna ao procedimento chamador
