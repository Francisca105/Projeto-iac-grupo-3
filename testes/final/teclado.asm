STACK       100H	                        ; espaço reservado para a pilha do processo teclado
SP_teclado:				                    ; valor inicial para o SP do processo teclado

PROCESS SP_teclado
teclado:
	MOV     R2, TEC_LIN                     ; endereço do periférico das linhas
    MOV     R3, TEC_COL                     ; endereço do periférico das colunas
    MOV     R5, MASC_TEC                    ; isola os 4 bits de menor peso ao ler as colunas do teclado
    MOV     R6, LINHA_TECLADO               ; primeira linha a ser testada (4ª linha, 1000b)

espera_tecla:	                            ; neste ciclo espera-se até uma tecla ser premida
	WAIT
	MOV		R6, LINHA_TECLADO				; primeira linha a testar (4ª linha)
varre_linhas:
    MOV     R1, R6                          ; testa uma linha
    MOVB    [R2], R1                        ; escreve no periférico de saída (linhas)
    MOVB    R0, [R3]                        ; lê do periférico de entrada (colunas)
	MOV		R4, R0							; cópia do valor do periférico de entrada
	SHR		R4, 4							; os bits 4-7 são gerados "aleatoriamente"
	MOV		[ALEATORIO], R4					; guarda o valor "aleatoriamente" gerado
    AND     R0, R5                          ; elimina bits para além dos bits 0-3
    CMP     R0, 0                           ; há tecla premida?
    JNZ     converte                        ; se sim, converte a linha e a coluna para uma tecla

verifica_ultima:                            ; verifica se já percorreu todas as linhas 
    CMP     R6, 0                           ; é a última linha?
    JZ      espera_tecla                    ; se nenhuma tecla premida, repete
    SHR     R6, 1                           ; se não, testa a linha seguinte na próxima iteração
    JMP     varre_linhas                    ; passa para a linha seguinte

converte:                                   ; converte a linha e a coluna para uma tecla
    MOV     R7, R1                          ; copia a linha
    MOV     R8, 0                           ; começa na primeira linha (= 0)

linha:                                      ; loop para converter a linha
    SHR     R7, 1                           ; desloca os bits da linha uma poisção para a direita
    CMP     R7, 0                           ; já converteu a linha?
    JZ      exit_linha                      ; se já converteu, sai do loop
	ADD		R8, 1							; incrementa a linha em 1 unidade
	JMP		linha							; repete o processo

exit_linha:
    SHL		R8, 2							; multiplica a linha por 4
    MOV     R4, 0                           ; começa na primeira coluna (= 0)
    MOV     R7, R0                          ; copia a coluna

coluna:                                     ; loop para converter a coluna
    SHR     R7, 1                           ; desloca os bits da coluna uma posição para a direita
    CMP     R7, 0                           ; já converteu a coluna?
    JZ      exit_coluna                     ; se já converteu, sai do loop
	ADD		R4, 1							; incrementa a coluna em 1 unidade
	JMP		coluna							; repete o processo

exit_coluna:
    ADD     R4, R8                          ; tecla = 4*linha + coluna
    MOV		[TECLA_CARREGADA], R4			; notifica outros processos do valor da coluna detetada

ha_tecla:									; neste ciclo espera-se até NENHUMA tecla estar premida
	YIELD
    MOVB    [R2], R1                        ; escreve no periférico de saída (linhas)
    MOVB    R0, [R3]                        ; lê do periférico de entrada (colunas)
	MOV		R4, R0							; cópia do valor do periférico de entrada
	SHR		R4, 4							; os bits 4-7 são gerados "aleatoriamente"
	MOV		[aleatorio], R4					; guarda o valor "aleatoriamente" gerado
    AND     R0, R5                          ; elimina bits para além dos bits 0-3
    CMP     R0, 0                           ; há tecla premida?
    JNZ     ha_tecla                        ; se ainda houver uma tecla premida, espera até não haver
	JMP		espera_tecla					; repete o ciclo