.data
	PROMPT_INIT: .asciiz "\nEntre com o tamanho dos vetores A e B: "
	PROMPT_END_A: .asciiz "\nMedia de A: "
	PROMPT_END_B: .asciiz "\nMedia de B: "
	.align 2
	A: .float 0.11 0.34 1.23 5.34 0.76 0.65 0.34 0.12 0.87 0.56
	.align 2
	B: .float 7.89 6.87 9.89 7.12 6.23 8.76 8.21 7.32 7.32 8.22
	
.text
main:
	la	$s0, A			# Salva endereco de A em $s0
	la	$s1, B			# Salva endereco de B em $s1
	
	li	$v0, 4			# Escreve no console a string
	la	$a0, PROMPT_INIT	# armazenada em "PROMPT_INIT"
	syscall				#
	
	li 	$v0, 5			# Lê um valor inteiro do console
	syscall				# e armazena no registrador $s2
	move	$s2, $v0		#
	
	move	$a0, $s2		# Passa o tamanho dos vetores para $a0
					# (parametro de "Calcula_media"
	
	move	$a1, $s0		# Passa o endereco de A para $a1 
					# (parametro de "Calcula_media")
	
	jal 	Calcula_media		# Chama o procedimento "Calcula_media" para o vetor A
	
	li	$v0, 4			# Escreve no console a string
	la	$a0, PROMPT_END_A	# armazenada em "PROMPT_END_A"
	syscall				#
	
	mtc1 	$v1, $f12		# Move o retorno de "Calcula_media" para $f12
	li	$v0, 2			# para podermos imprimir float no terminal
	
	syscall				# Realiza a chamada de sistema
	
	move	$a0, $s2		# Passa o tamanho dos vetores para $a0
					# (parametro de "Calcula_media"
	
	move	$a1, $s1		# Passa o endereco de B para $a1 
					# (parametro de "Calcula_media")
	
	jal	Calcula_media		# Chama o procedimento "Calcula_media" para o vetor B
	
	li	$v0, 4			# Escreve no console a string
	la	$a0, PROMPT_END_B	# armazenada em "PROMPT_END_B"
	syscall				#
	
	mtc1	$v1, $f12		# Move o retorno de "Calcula_media" para $f12
	li	$v0, 2			# para podermos imprimir float no terminal
	
	syscall				# Realiza a chamada de sistema
	
	li	$v0, 10			# Termina o programa por meio de uma 
	syscall				# chamada de sistema
	
Calcula_media:

	#==================================
	# Calcula a media de um dado vetor
	#==================================
	
	
	# Recebe o tamanho do vetor por meio de $a0
	# Recebe endereco do vetor por meio de $a1
	# Retorna a media em $v1
	#
	# $s0 = tamanho do vetor
	# $s1 = endereco do vetor
	# $t0 = indice atual do calculo
	# $t1 = endereco atual do vetor
	
	addi	$sp, $sp, -12		# Aumentra pilha e salva $s0, $s1 e $s2
	sw	$s0, 4($sp)		#
	sw	$s1, 8($sp)		#
	sw	$s2, 12($sp)		#
	
	move 	$s0, $a0		# Recebe os argumentos do procedimento e 
	move	$s1, $a1		# salva nos devidos registradores
	
	li	$t0, 0			# Inicializa $t0 e $f1 com zero
	mtc1	$t0, $f1		#
	cvt.s.w	$f1, $f1		#
loop_media:
	
	mul	$t1, $t0, 4		# Incrementa o endereco atual em 4 para acessar
	add	$t1, $s1, $t1		# a proxima posicao do vetor
	
	lwc1	$f0, 0($t1)		# Carrega $f0 com um elemento do vetor na posicao $t1
	
	add.s	$f1, $f1, $f0		# Soma $f0 ao somatorio
	
	addi	$t0, $t0, 1		# Incrementa o indice atual do calculo
	
	bne	$t0, $s0, loop_media	# Checa se o vetor ja acabou, caso tenha acabado continua
					# caso nao, pula para "loop_media"
	
	mtc1	$s0, $f0		# Carrega o registrador $f0 com o tamanho do vetor
	cvt.s.w $f0, $f0
	
	div.s	$f2, $f1, $f0		# Calcula (somatorio_dos_elementos/tamanho_do_vetor)
	
	mfc1	$v1, $f2		# Retorna em $v1 o resultado
		
	lw	$s0, 4($sp)		# Retorna $s0, $s1 e $s2 aos seus valores originais e
	lw	$s1, 8($sp)		# retorna a pilha para sua posicao anterior
	lw	$s2, 12($sp)		#
	addi	$sp, $sp, 12		#
	
	jr	$ra
	
