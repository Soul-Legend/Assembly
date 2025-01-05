.data

.text
	# ===========================
	#  Inicializacao do programa
	# ===========================

	li	$v0, 5			# Le do terminal o numero que sera utilizado
	syscall				# para calcular o fatorial
	
	move 	$s0, $v0		# Salva o número lido no registrador $s0
	
	beq	$s0, 0, zero		# Caso o número lido seja 0 vamos para o tratamento
	
	move	$s1, $s0 		# Inicializa o registrador $s1 com o valor de $s0
					# para ser utilizado como "variavel de controle" do
					# laço

loop:
	# ===========================
	#       Loop do calculo
	# ===========================

	beq $s1, 1, exit		# Verifica se deve sair do laco
	subi $s1, $s1, 1		# Subtrai 1 da "variavel de controle"
	
	mul $s0, $s0, $s1		# Multiplica o resultado atual($s0) pela variavel
					# de controle do laco
					
	j loop				# retorna para "loop"

zero:
	# ===========================
	#     Tratamento do caso 0
	# ===========================
	
	addi 	$s0, $zero, 1		# Coloca 1 como o resultado
	
exit: 	
	# ===========================
	#      Saida do programa
	# ===========================
	li 	$v0, 1			# Imprime o resultado no terminal 
	move	$a0, $s0		#
	syscall				#
