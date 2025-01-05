.data
	.align 2
	A: .word 1 2 3 0 1 4 0 0 1 
	.align 2
	B: .word 1 -2 5 0 1 -4 0 0 1
	.align 2
	C: .word 0 0 0 0 0 0 0 0 0

.text
	.main:
		jal PROC_TRANS
		jal PROC_MUL
		li $v0, 10 # informa que o programa main acabou
		syscall
	
	
	
	
	
	PROC_TRANS:
		la $s0, A  # carregado o endereço base da matriz A
		la $s1, B  # carregado o endereço base da matriz B
		la $s2, C  # carregando o endereço base da matriz resultante
	
	
		# $t2 = linha
		# $t3 = coluna
		# $t4 = k
		move $t2, $zero # inicializando com zero o registrador que será usado para controle do laço da linha
		move $t3, $zero # inicializando com zero o registrador que será usado para controle do laço da coluna
		move $t4, $zero # inicializando com zero o registrador que será usado para controle do laço das operações
	
	
		# troca de 1,2 para 2,1
		lw $t0, 4($s1) #  carregado no registrador t2 o valor 1,2 da matriz B
		lw $t1, 12($s1)
		sw $t1, 4($s1)
		sw $t0, 12($s1)

		# troca de 1,3 para 3,1
		lw $t0, 8($s1)
		lw $t1, 24($s1)
		sw $t1, 8($s1)
		sw $t0, 24($s1)

		# troca de 2,3 para 3,2
		lw $t0, 20($s1)
		lw $t1, 28($s1)
		sw $t1, 20($s1)
		sw $t0, 28($s1)
		
		jr $ra   # volta para onde a função foi chamada



	
	PROC_MUL:
		loop_linha:
		beq $t2, 3, fim_loop_linha # permacene no loop linha enquanto $t2 for menor do que 3
			move $t3, $zero    # reinicia o contador de colunas

			loop_coluna:
			beq $t3, 3, fim_loop_coluna  # permacene no loop coluna enquanto $t3 for menor do que 3	
				move $t5, $zero      # $t5 será usado para a soma das multiplicações
				move $t4, $zero      # reinicia o contador de k para zero
			
				loop_k:
				beq $t4, 3, fim_loop_k	# permacene no loop k enquanto $t4 for menor do que 3
				move $s4, $zero         # $s4 será usado para armazenar a multiplicação da vez
				
					# Calculo do endereço A[linha][k]
					mul $t7, $t2, 12   # $t7 = linha * 12 (calculando o deslocando das linhas)
					mul $t8, $t4, 4    # $t8 = coluna * 4 (calculando o deslocamento de colunas) 
					add $t7, $t7, $t8  # $t7 = $t7 + k * 4
					add $t7, $t7, $s0  # $t7 = $t7 + endereço base da matriz A
					lw $t6, 0($t7)     # $t6 = A[linha][k]
				
				
					# Calculo do endereço B[k][coluna]
					mul $t7, $t4, 12   # $t7 = k * 12 (percorrendo a coluna)
					mul $t8, $t3, 4   # $t8 = coluna * 4 (calculando o deslocamento de colunas)
					add $t7, $t7, $t8  # $t7 = $t7 + coluna * 4
					add $t7, $t7, $s1  # $t7 = $t7 + endereço base da matriz B
					lw $t9, 0($t7)     # $t9 = B[k][coluna]
				
				
					mul $s4, $t6, $t9  # A[linha][k] * B[k][coluna]
				
					add $t5, $t5, $s4  # $t5 contém o somatório das multiplicações
				
				addi $t4, $t4, 1 # $t4 += 1
				j loop_k			
				fim_loop_k:	
				
				# Calculo do endereço C[linha][coluna]
				mul $t7, $t2, 12   # $t7 = $t2 * 12 (calculando o deslocamento de linhas)
				mul $t8, $t3, 4    # $t8 = coluna * 4 (calculando o deslocamento de colunas)
				add $t7, $t7, $t8  # # $t7 = $t7 + coluna * 4
				add $t7, $t7, $s2  # $t7 = $t7 + endereço base da matriz C
				sw  $t5, 0($t7)    # escrevendo o resultado C[i][j] na matriz C
			
			
			addi $t3, $t3, 1 # $t3 += 1
			j loop_coluna	
			fim_loop_coluna:
		
		addi $t2, $t2, 1 # $t2 += 1
		j loop_linha
		fim_loop_linha: 

		jr $ra # volta pra onde a função foi chamada
