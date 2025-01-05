.data
    A: .word 5
    B: .word 0   # Inicialmente, B será 0
    C: .word 5
    D: .word 5
    E: .word 5

.text
    # Lendo o valor de B do usuário
    li   $v0, 5       # Código do syscall para ler inteiro
    syscall
    sw   $v0, B       # Armazenando o valor lido na variável B

    lw   $s0, A       # $s0 recebe o conteúdo de A
    lw   $t0, B       # $t0 recebe o conteúdo de B

    addi $s0, $t0, 35 # $s0 recebe o conteúdo de B + 35 (A = B + 35), $s0 deve ter o valor 40

    lw   $s1, C       # $s1 recebe o conteúdo de C
    lw   $t1, E       # $t1 recebe o conteúdo de E
    lw   $t2, D       # $t2 recebe o conteúdo de D

    sub  $t3, $t2, $s0 # $t3 recebe a subtração dos conteúdos dos registradores $t2 e $s0 (D - A), $t3 deve ter o valor -35
    add  $s1, $t1, $t3 # $s1 recebe a subtração dos conteúdos dos registradores $t1 e $t3 (D - A + E), $s1 deve ter o valor -30

    sw   $s1, C       # Gravando o resultado na variável C
    
    li $v0, 1
    lw $a0, C
    syscall
    
