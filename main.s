verificar_matriz_preenchida:
    cmpl $0, rows
    je matriz_nao_preenchida
    cmpl $0, cols
    je matriz_nao_preenchida
    ret

matriz_nao_preenchida:
    pushl $sem_matriz
    call printf
    addl $4, %esp
    jmp menu_loop

imprimir_matriz:
    pushl $format_output
    call printf
    addl $4, %esp

    movl rows, %ebx
    movl cols, %ecx
    xorl %edi, %edi  # Índice da linha
    xorl %esi, %esi  # Índice da coluna

imprimir_matriz_loop:
    pushl %edi
    pushl %esi

    movl matriz, %eax
    movl cols, %ebx
    imull %edi, %ebx  # linha * cols
    addl %esi, %ebx   # linha * cols + coluna
    imull $4, %ebx    # (linha * cols + coluna) * 4 bytes
    addl %ebx, %eax
    pushl (%eax)
    pushl $format_int_space
    call printf
    addl $8, %esp

    popl %esi
    popl %edi
    incl %esi
    cmpl cols, %esi
    jl imprimir_matriz_loop

    xorl %esi, %esi
    pushl $new_line
    call printf
    addl $4, %esp

    incl %edi
    cmpl rows, %edi
    jl imprimir_matriz_loop

    ret

.section .data
    boas_vindas: .asciz  "%s*               Trabalho 1 - Matriz NxM               *\n"
    universidade: .asciz   "*        Universidade Estadual de Maringá(UEM)        *\n"
    autor: .asciz          "*        Aluno: Davi Yoshio Toyokawa RA:125066        *\n"
    autor2: .asciz         "*       Aluno: Eduardo Andrade Manfre RA:116409       *%s"
    separador: .asciz "\n-------------------------------------------------------\n"
    menu: .asciz "\n--- MENU ---\n1 - Preencher matriz NxM\n2 - Buscar elemento na matriz\n3 - Mostrar diagonal principal\n4 - Mostrar lucky numbers\n5 - Sair\n"
    escolher_opcao: .asciz "Escolha uma opção: "
    op_invalida: .asciz "\nOpção inválida. Tente novamente.\n"
    sem_matriz: .asciz "\nMatriz não foi preenchida. Por favor, escolha a opção 1.\n"
    prompt_rows: .asciz "Digite o número de linhas (N): "
    prompt_cols: .asciz "Digite o número de colunas (M): "
    prompt_value: .asciz "Digite o valor para a posição [%d][%d]: "
    prompt_search: .asciz "\nDigite o valor a ser buscado na matriz: "
    format_int: .asciz "%d"
    format_int_space: .asciz "%d "
    format_output: .asciz "\nMatriz:\n"
    diagonal_output: .asciz "\nDiagonal Principal: "
    no_diagonal_output: .asciz "Matriz não possui diagonal principal\n"
    found_output: .asciz "\nValor %d encontrado na posição [%d][%d]\n"
    not_found_output: .asciz "\nValor %d não encontrado na matriz\n"
    lucky_numbers_output: .asciz "\nLucky numbers: "
    sem_lucky_numbers: .asciz "A matriz não possui lucky numbers\n"
    mensagem_fim: .asciz "%s*                 Fim do programa! :D                 *%s"
    new_line: .asciz "\n"
    rows: .int 0
    cols: .int 0
    search_value: .int 0

.section .bss
    .lcomm matriz, 4  # Ponteiro para a matriz

.section .text
    .globl _start

_start:
    pushl $separador
    pushl $boas_vindas
    call printf
    pushl $universidade
    call printf
    pushl $autor
    call printf
    pushl $separador
    pushl $autor2
    call printf
    addl $24, %esp

menu_loop:
    pushl $menu
    call printf
    pushl $escolher_opcao
    call printf
    addl $8, %esp

    # Lê a opção escolhida
    subl $4, %esp
    movl %esp, %ebx
    pushl %ebx
    pushl $format_int
    call scanf
    addl $8, %esp
    movl (%ebx), %eax
    addl $4, %esp

    cmpl $1, %eax
    je preencher_matriz

    cmpl $2, %eax
    je buscar_elemento

    cmpl $3, %eax
    je mostrar_diagonal

    cmpl $4, %eax
    je mostrar_lucky_numbers

    cmpl $5, %eax
    je sair

    pushl $op_invalida
    call printf
    addl $4, %esp
    jmp menu_loop

preencher_matriz:
    # número de linhas
    pushl $prompt_rows
    call printf
    addl $4, %esp

    pushl $rows
    pushl $format_int
    call scanf
    addl $8, %esp

    # número de colunas
    pushl $prompt_cols
    call printf
    addl $4, %esp

    pushl $cols
    pushl $format_int
    call scanf
    addl $8, %esp

    # Aloca memória para a matriz
    movl rows, %ebx
    movl cols, %ecx
    imull %ebx, %ecx  # rows * cols
    imull $4, %ecx    # rows * cols * 4 bytes
    pushl %ecx
    call malloc
    addl $4, %esp
    movl %eax, matriz

    # Preencher a matriz com valores do usuário
    movl rows, %ebx
    movl cols, %ecx
    xorl %edi, %edi  # Índice da linha
    xorl %esi, %esi  # Índice da coluna

preencher_loop:
    pushl %edi
    pushl %esi

    # Imprimir prompt 
    pushl %esi
    pushl %edi
    pushl $prompt_value
    call printf
    addl $12, %esp

    # Ler valor 
    movl matriz, %eax
    movl cols, %ebx
    imull %edi, %ebx  # linha * cols
    addl %esi, %ebx   # linha * cols + coluna
    imull $4, %ebx    # (linha * cols + coluna) * 4 bytes
    addl %ebx, %eax
    pushl %eax
    pushl $format_int
    call scanf
    addl $8, %esp

    popl %esi
    popl %edi
    incl %esi
    cmpl cols, %esi
    jl preencher_loop

    xorl %esi, %esi
    incl %edi
    cmpl rows, %edi
    jl preencher_loop

    call imprimir_matriz
    jmp menu_loop

buscar_elemento:
    call verificar_matriz_preenchida
    # Solicita valor a ser buscado na matriz
    pushl $prompt_search
    call printf
    addl $4, %esp

    pushl $search_value
    pushl $format_int
    call scanf
    addl $8, %esp

    # Procura o valor na matriz
    movl rows, %ebx
    movl cols, %ecx
    xorl %edi, %edi  # índice da linha
    xorl %esi, %esi  # índice da coluna

buscar_loop:
    pushl %edi
    pushl %esi

    movl matriz, %eax
    movl cols, %ebx
    imull %edi, %ebx  # linha * cols
    addl %esi, %ebx   # linha * cols + coluna
    imull $4, %ebx    # (linha * cols + coluna) * 4 bytes
    addl %ebx, %eax
    movl (%eax), %ecx
    cmpl search_value, %ecx
    je valor_encontrado

    popl %esi
    popl %edi
    incl %esi
    cmpl cols, %esi
    jl buscar_loop

    xorl %esi, %esi
    incl %edi
    cmpl rows, %edi
    jl buscar_loop

    # Valor não encontrado
    pushl search_value
    pushl $not_found_output
    call printf
    addl $8, %esp

    jmp menu_loop

valor_encontrado:
    popl %esi
    popl %edi
    pushl %esi
    pushl %edi
    pushl search_value
    pushl $found_output
    call printf
    addl $16, %esp

    jmp menu_loop

mostrar_diagonal:
    call verificar_matriz_preenchida
    call imprimir_matriz
    pushl $diagonal_output
    call printf
    addl $4, %esp
    movl rows, %ebx
    xorl %edi, %edi  # índice da linha e coluna da diagonal

imprimir_diagonal:
    # Imprime diagonal principal (apenas se for uma matriz NxN)
    movl rows, %ebx
    movl cols, %ecx
    cmpl %ebx, %ecx
    jne fim_diagonal  # Se N != M, não há diagonal principal

    movl matriz, %eax
    imull %edi, %ebx  # linha * cols
    addl %edi, %ebx   # linha * cols + coluna (mesma linha e coluna para diagonal)
    imull $4, %ebx    # (linha * cols + coluna) * 4 bytes
    addl %ebx, %eax
    pushl (%eax)
    pushl $format_int_space
    call printf
    addl $8, %esp

    incl %edi
    cmpl rows, %edi
    jl imprimir_diagonal

    pushl $new_line
    call printf
    addl $4, %esp
    jmp menu_loop

fim_diagonal:
    pushl $no_diagonal_output
    call printf
    addl $4, %esp

    jmp menu_loop

mostrar_lucky_numbers:
    call verificar_matriz_preenchida
    call imprimir_matriz
    # Encontra e mostra os lucky numbers
    pushl $lucky_numbers_output
    call printf
    addl $4, %esp

    movl rows, %ebx   # número de linhas
    xorl %edi, %edi   # índice da linha

check_lucky_number:
    pushl %edi

    # Encontra o menor valor da linha e o índice da coluna
    movl matriz, %eax
    movl cols, %ebx   
    imull %edi, %ebx  # linha * cols
    imull $4, %ebx    # (linha * cols) * 4 bytes
    addl %ebx, %eax
    movl (%eax), %edx # menor valor
    movl $0, %ecx     # índice da coluna do menor valor

    xorl %esi, %esi   # índice da coluna

check_each_element_in_line_lucky:
    movl matriz, %eax
    movl cols, %ebx
    imull %edi, %ebx  # linha * cols
    addl %esi, %ebx   # linha * cols + coluna
    imull $4, %ebx    # (linha * cols + coluna) * 4 bytes
    addl %ebx, %eax
    movl (%eax), %eax

    # Verifica se o elemento atual é menor
    cmpl %edx, %eax
    jge not_smaller_lucky

    # Atualiza o menor valor e o índice da coluna
    movl %eax, %edx
    movl %esi, %ecx

not_smaller_lucky:
    incl %esi
    cmpl cols, %esi
    jl check_each_element_in_line_lucky

    # Verifica se o menor valor é o maior na coluna
    movl matriz, %eax
    movl rows, %ebx
    imull %ecx, %ebx  # coluna * linhas
    imull $4, %ebx    # (coluna * linhas) * 4 bytes
    addl %ebx, %eax
    movl (%eax), %eax # maior valor na coluna

    xorl %esi, %esi   # índice da linha 

check_each_element_in_column_lucky:
    movl matriz, %eax
    movl cols, %ebx
    imull %esi, %ebx  # linha * cols
    addl %ecx, %ebx   # linha * cols + column
    imull $4, %ebx    # (linha * cols + column) * 4 bytes
    addl %ebx, %eax
    movl (%eax), %eax

    # Verifica se o elemento atual é maior
    cmpl %eax, %edx
    jge not_larger_lucky

    # O menor valor não é o maior na coluna
    jmp no_lucky_number

not_larger_lucky:
    incl %esi
    cmpl rows, %esi
    jl check_each_element_in_column_lucky

    # O menor valor é o maior na coluna, entao é um lucky number
    pushl %edx
    pushl $format_int_space
    call printf
    addl $8, %esp
    pushl $new_line
    call printf
    addl $4, %esp

    jmp menu_loop

no_lucky_number:
    popl %edi
    incl %edi
    cmpl rows, %edi
    jl check_lucky_number

    pushl $sem_lucky_numbers
    call printf
    addl $4, %esp
    jmp menu_loop

sair:
    pushl $separador
    pushl $separador
    pushl $mensagem_fim
    call printf
    addl $12, %esp

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

.extern printf
.extern scanf
.extern malloc
