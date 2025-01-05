.data
	Estimativa: .double 1
	dois: .double 2
	X: .double 64
	
.text
main:
	li	$v0, 5			#  Le o numero de iteracoes fornecido pelo usuario
	syscall				#
	move	$s0, $v0		#
	
	la	$t0, Estimativa		# Carrega o valor da estimativa inicial da memória
	l.d	$f0, 0($t0)		# no registrador $s1
	
	la	$t0, X			# Carrega o valor de X da memória no registrador $s2
	l.d	$f2, 0($t0)		#
	
	la	$t0, dois		# Carrega o valor de dois da memória no registrador $s2
	l.d	$f6, 0($t0)		#
	
	sqrt.d	$f8, $f2
	
loop:	
	
	jal	raiz_quadrada		# Chama o procedimento "raiz_quadrada"
	
	addi 	$s0, $s0, -1		# Contador do loop
	bne	$s0, $zero, loop	#
	
	li	$v0, 10			# Termina o programa por meio de uma 
	syscall				# chamada de sistema
	
raiz_quadrada:

	div.d	$f4, $f2, $f0		# X / Estimativa
	
	add.d	$f4, $f4, $f0		# (X / Estimativa) + Estimativa
	
	div.d	$f0, $f4, $f6 		# ((X / Estimativa) + Estimativa) / 2
	
	jr	$ra			# Retorna a main
	
	
	
	
