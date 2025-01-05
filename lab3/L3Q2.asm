.data
	qtd_termos: .word 20
	x: .double 0.1

.text
main:
	la	$t0, x			# Coloca o registrador $f0 com o valor de X
	ldc1	$f0, 0($t0)		#
	
	la	$t0, qtd_termos		# Coloca o registrador $s1 com o valor de qtd_termos
	lw	$s1, 0($t0)		#
	
	move	$a0, $s1		# Passa a quantidade de termos da aproximacao como
					# parametro para o procedimento seno
	
	jal 	seno			# Chama o procedimento seno
	
	li	$v0, 10			# Termina o programa por meio de uma 
	syscall				# chamada de sistema
	
#===========================================================================================
seno:
	#===============================================
	# Calcula aproximacao de seno de x com n termos
	#===============================================
	
	# Recebe em $f0 o numero base(X) e em $a0 a 
	# quantidade de termos da aproximacao
	
	# $s0 = indice de controle do laco
	# $f0 = base da aproximacao
	# $f26 = registrador de retorno
	
	addi 	$sp, $sp, -12			# Aumenta a pilha e coloca registradores
	sw	$s0, 4($sp)			# utilizados nessa funcao para a memoria
	sw	$t0, 8($sp)			#
	sw	$t1, 12($sp)			#
	
	li	$s0, 0				# Inicia indice de controle do laco
	
loop_seno:
	# Calcula (-1)^n e armazena em $f6 --------------------------------------------------
	addi	$sp, $sp, -20			# Aumenta a pilha para salvar $f0, $a0 e $ra
	sdc1	$f0, 4($sp)			#
	sw	$a0, 12($sp)			#
	sw	$ra, 16($sp)			#
	
	addi 	$t0, $zero, -1			# Carrega os registradores $f30 e $f31 com -1
	add	$t1, $zero, $zero		#
	mtc1.d  $t0, $f0			#
	cvt.d.w $f0, $f0			#
	
	move 	$a0, $s0			# Atualiza $a0 com o indice do laco atual
	
	jal	potencia			# Chama o procedimento para calcular a potencia
	
	ldc1	$f0, 4($sp)			# Retorna pilha e valor de $f0, $a0 e $ra
	lw	$a0, 12($sp)			#
	lw	$ra, 16($sp)			#
	addi	$sp, $sp, 20			#
	
	mov.d 	$f6, $f30			# Move o resultado para $f6
	# ------------------------------------------------------------------------------------
	
	# Calcula x^(2.n+1) e armazena em $f8 ------------------------------------------------
	addi	$sp, $sp, -12			# Aumenta a pilha para salvar $a0 e $ra
	sw	$a0, 4($sp)			#
	sw	$ra, 8($sp)			#
	
	li	$t0, 2				# Calcula (2.n + 1) e armazena em $a0
	mul 	$t0, $t0, $s0			# 
	addi 	$t0, $t0, 1			#
	move	$a0, $t0 			#
	
	jal	potencia			# Chama o procedimento para calcular a potencia
	
	lw	$a0, 4($sp)			# Retorna pilha e valor de $a0 e $ra
	lw	$ra, 8($sp)			#
	addi	$sp, $sp, 12			#
	
	mov.d	$f8, $f30			# Move o resultado para $f8
	# ------------------------------------------------------------------------------------
	
	# Calcula (2.n + 1)! e armazena em $f10 ----------------------------------------------
	addi	$sp, $sp, -20			# Aumenta a pilha para salvar $a0
	sdc1	$f0, 4($sp)			#
	sw	$ra, 12($sp)			#
	
	li	$t0, 2				# Calcula (2.n + 1) e armazena em $a0
	mul 	$t0, $t0, $s0			# 
	addi 	$t0, $t0, 1			#
	
	li	$t1, 0				# Carrega o registrador $t1 com zero

	mtc1.d 	$t0, $f0			# Move (2.n + 1) para $f0
	cvt.d.w $f0, $f0			#
	
	jal	fatorial			# Chama o procedimento para calcular o fatorial
	
	ldc1 	$f0, 4($sp)			# Retorna pilha e valor de $a0
	lw	$ra, 12($sp)			#
	addi	$sp, $sp, 20			#
	
	mov.d	$f10, $f28			# Move o resultado para $f10
	# ------------------------------------------------------------------------------------
	
	mul.d	$f6, $f6, $f8			# $f6 = (-1)^n * x^(2.n+1)
	div.d	$f6, $f6, $f10			# $f6 = $f6 / (2.n+1)!
	add.d	$f26, $f26, $f6			# Adiciona o resultado de uma iteracao completa
						# ao somatorio
	
	addi	$s0, $s0, 1
	bne	$s0, $a0, loop_seno
	
	lw	$s0, 4($sp)			# Retorna antigos valores dos registradores
	lw	$t0, 8($sp)			# para seu correto local e diminui a pilha
	lw	$t1, 12($sp)			#
	addi 	$sp, $sp, 12			#

	jr	$ra				# Retorna ao procedimento em que foi chamado
	
	
#===========================================================================================
potencia:

	#==========================================
	#	   Calcula potencia X^N 
	#==========================================
	
	# Recebe em $f0 o numero base(X) e em $a0 o expoente (N)
	# e retorna o valor em $f30
	
	# $s0 = indice de controle do laco
	# $f0 = base da potencia
	# $f30 = registrador de retorno
	
	addi 	$sp, $sp, -12			# Aumenta a pilha e coloca registradores
	sw	$s0, 4($sp)			# utilizados nessa funcao para a memoria
	sw	$t0, 8($sp)			#
	sw	$t1, 12($sp)			#
	
	addi 	$t0, $zero, 1			# Carrega os registradores $f30 e $f31 com 1
	add	$t1, $zero, $zero		#
	mtc1.d  $t0, $f30			#
	cvt.d.w $f30, $f30			#
	
	beq	$a0, $zero, return_pot		# Caso o expoente seja zero retorna 1 como resultado
	
	move	$s0, $a0			# Inicializa $s0 como indice de controle para loop_pot
	
loop_pot:

	# for (int i = N; i > 0; i--) {resultado = resultado * x}

	mul.d	$f30, $f30, $f0			# Faz a multiplicacao:	   resultado * X
						#
	addi	$s0, $s0, -1			# Controle do loop vezes que   necessario
	bne	$s0, $zero, loop_pot		# fazer a multiplicacao
						
return_pot:
	lw	$s0, 4($sp)			# Retorna antigos valores dos registradores
	lw	$t0, 8($sp)			# para seu correto local e diminui a pilha
	lw	$t1, 12($sp)			#
	addi 	$sp, $sp, 12			#

	jr	$ra				# Retorna ao procedimento em que foi chamado
	
#===========================================================================================

fatorial:

	#==========================================
	#	     Calcula fatorial X!
	#==========================================
	
	# Recebe em $f0 o numero base(X)
	
	# s0 = indice de controle do laco
	# f0 = base do fatorial
	# f28 = registrador de retorno
	
	addi 	$sp, $sp, -12			# Aumenta a pilha e coloca registradores
	sw	$s0, 4($sp)			# utilizados nessa funcao para a memoria
	sw	$t0, 8($sp)			#
	sw	$t1, 12($sp)			#
	
	cvt.w.d $f2, $f0			# Move o valor da base do fatorial para
	mfc1.d  $t0, $f2			# checar se   1 ou 0
	
	beqz	$t0, return_one			# Caso seja 1 ou 0 pular para return_one
	beq	$t0, 1, return_one		#
	
	move	$s0, $t0			# Inicial o indice de controle do laco
	
loop_fat:

	addi	$s0, $s0, -1
	
	add 	$t0, $zero, $s0			# Carrega os registradores $f2 e $f3 com $s0
	add	$t1, $zero, $zero		#
	mtc1.d  $t0, $f2			#
	cvt.d.w $f2, $f2			#
	
	mul.d	$f0, $f0, $f2			# Faz a multiplicacao:	   resultado * X

	bne	$s0, 1 , loop_fat		# Controle do loop vezes que   necessario
						# fazer a multiplicacao
	
return_fat:

	mov.d	$f28, $f0			# Move o resultado para o registrador de retorno

	lw	$s0, 4($sp)			# Retorna antigos valores dos registradores
	lw	$t0, 8($sp)			# para seu correto local e diminui a pilha
	lw	$t1, 12($sp)			#
	addi 	$sp, $sp, 12			# 

	jr	$ra				# Retorna ao procedimento em que foi chamado

return_one:
	addi 	$t0, $zero, 1			# Carrega os registradores $f28 e $f29 com 1
	add	$t1, $zero, $zero		#
	mtc1.d  $t0, $f28			#
	cvt.d.w $f28, $f28			#

	lw	$s0, 4($sp)			# Retorna antigos valores dos registradores
	lw	$t0, 8($sp)			# para seu correto local e diminui a pilha
	lw	$t1, 12($sp)			#
	addi 	$sp, $sp, 12			# 

	jr	$ra				# Retorna ao procedimento em que foi chamado
	
#===========================================================================================
