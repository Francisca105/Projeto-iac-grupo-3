; *********************************************************************
; * IST-UL
; * Modulo:    lab3.asm
; * Descrição: Exemplifica o acesso a um teclado.
; *            Lê uma linha do teclado, verificando se há alguma tecla
; *            premida nessa linha.
; *
; * Nota: Observe a forma como se acede aos periféricos de 8 bits
; *       através da instrução MOVB
; *********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************
; ATENÇÃO: constantes hexadecimais que comecem por uma letra devem ter 0 antes.
;          Isto não altera o valor de 16 bits e permite distinguir números de identificadores
DISPLAYS   EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN    EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL    EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)
LINHA      EQU 1       ; linha a testar (1ª linha, 0001b)
MASCARA    EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
LIN_FIN    EQU 8       ; linha final

; **********************************************************************
; * Código
; **********************************************************************
PLACE      0
inicio:		
; inicializações
    MOV  R2, TEC_LIN   ; endereço do periférico das linhas
    MOV  R3, TEC_COL   ; endereço do periférico das colunas
    MOV  R4, DISPLAYS  ; endereço do periférico dos displays
    MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
    MOV  R6, LINHA     ; linha a ser testada
    MOV  R7, LIN_FIN   ; linha final

; corpo principal do programa
ciclo:
    MOV  R1, 0 
    MOVB [R4], R1      ; escreve linha e coluna a zero nos displays

espera_tecla:          ; neste ciclo espera-se até uma tecla ser premida
    MOV  R6, LINHA     ; começa pela linha 1
varre_linhas:	       ; varre cada linha, uma a uma
    MOV  R1, R6        ; testa cada linha
    MOVB [R2], R1      ; escreve no periférico de saída (linhas)
    MOVB R0, [R3]      ; lê do periférico de entrada (colunas)
    AND  R0, R5        ; elimina bits para além dos bits 0-3
    CMP  R0, 0         ; há tecla premida?
    JNZ  mostra        ; se sim, mosta a linha e a coluna
verifica_ultima:       ; verifica se é a última 
    CMP  R6, R7        ; é a última linha?
    JZ   ALT           ; se sim, repete o processo
    SHL  R6, 1         ; testa a linha seguinte na próxima iteração
    JMP  varre_linhas  ; se não é a última linha, passa para a seguinte
ALT:
    JMP  espera_tecla  ; se nenhuma tecla premida, repete
mostra:                ; vai mostrar a linha e a coluna da tecla
    MOV  R8, R1        ; copia a linha para R8
    MOV  R9, 0         ; começa na primeira linha (=0)
    JMP  loop1         ; converte a linha para um número entre 0 e 3
exit_loop1:
    MOV  R10, 4        ; prepara a multiplicação
    MUL  R9, R10       ; multiplica a linha por 4
    MOV  R10, R9       ; copia o valor da linha convertida * 4 para R10
    MOV  R9, 0         ; começa na primeira coluna (=0)
    MOV  R8, R0        ; copia a coluna para R8
    JMP  loop2         ; converte a coluna para um número entre 0 e 3
exit_loop2:
    ADD  R10, R9       ; valor = 4*linha + coluna
    SHL  R1, 4         ; coloca linha no nibble high
    OR   R1, R0        ; junta coluna (nibble low)
    MOVB [R4], R1      ; escreve linha e coluna nos displays 
ha_tecla:              ; neste ciclo espera-se até NENHUMA tecla estar premida
    MOV  R1, R6        ; testa a linha anteriormente premida
    MOVB [R2], R1      ; escreve no periférico de saída (linhas)
    MOVB R0, [R3]      ; lê do periférico de entrada (colunas)
    AND  R0, R5        ; elimina bits para além dos bits 0-3
    CMP  R0, 0         ; há tecla premida?
    JNZ  ha_tecla      ; se ainda houver uma tecla premida, espera até não haver
    JMP  ciclo         ; repete ciclo

loop1:                 ; loop para converter a linha
    SHR  R8, 1         ; desloca os bits da linha uma poisção para a direita
    CMP  R8, 0         ; se é 0, já converteu a linha
    JNZ  OUT1          ; se ainda não converteu
    JMP  exit_loop1    ; se já converteu
OUT1:
    ADD  R9, 1         ; incrementa a linha em 1
    JMP  loop1         ; repete o processo

loop2:                 ; loop para converter a coluna
    SHR  R8, 1         ; desloca os bits da coluna uma posição para a direita
    CMP  R8, 0         ; se é 0, já converteu a coluna
    JNZ  OUT2          ; se ainda não converteu
    JMP  exit_loop2    ; se já converteu
OUT2:
    ADD  R9, 1         ; incrementa a coluna em 1
    JMP  loop2         ; repete o processo