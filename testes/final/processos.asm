; ****************************************************************************
; * IST-UL, ASA, 2019/2020                                                   *
; * Projeto Beyond Mars - Versão intermédia - 26/05/2023                     *
; *                                                                          *
; * Realizado por:                                                           *
; * ist1105901 - Francisca Almeida                                           *
; * ist1106827 - Cecília Correia                                             *
; * ist1106943 - José Frazão                                                 *
; *                                                                          *
; * Descrição: Simula o jogo dos asteróides num computador de 16 bits.       *
; ****************************************************************************

; ****************************************************************************
; * Constantes
; ****************************************************************************

; ENDEREÇOS
COMANDOS				    EQU	6000H       ; endereço de base dos comandos do MediaCenter
DISPLAYS                    EQU 0A000H      ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN                     EQU 0C000H      ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL                     EQU 0E000H      ; endereço das colunas do teclado (periférico PIN)

; COMANDOS DE ESCRITA DO MEDIA CENTER
APAGA_ECRA                  EQU COMANDOS    ; comando que apaga todos os pixéis de um ecrã específico
APAGA_ECRAS                 EQU 6002H       ; comando que apaga todos os pixéis de todos os ecrãs
SELECIONA_ECRA              EQU 6004H       ; comando que seleciona o ecrã a ser utilizado
MOSTRA_ECRA                 EQU 6006H       ; comando que mostra o ecrã especificado
ESCONDE_ECRA                EQU 6008H       ; comando que esconde o ecrã especificado
DEFINE_LINHA                EQU 600AH       ; comando que define a linha
DEFINE_COLUNA               EQU 600CH       ; comando que define a coluna
ALTERA_COR_SONDA_C          EQU 6012H       ; comando que altera a cor do pixel corrente
APAGA_AVISO                 EQU 6040H       ; comando que apaga o cenário de fundo e elimina aviso
DEFINE_CENARIO              EQU 6042H       ; comando que define o cenário
DEFINE_SOM_OU_VIDEO         EQU 6048H       ; comando que define o som/vídeo
INICIA_REPRODUCAO           EQU 605AH       ; comando que inicia a reprodução do som/vídeo
REPRODUZ_EM_CICLO           EQU 605CH       ; comando que reproduz um som/vídeo em ciclo
TERMINA_SOM_OU_VIDEO        EQU 6066H       ; comando que termina a reprodução do som/vídeo
TERMINA_SONS_OU_VIDEOS      EQU 6068H       ; comando que termina a reprodução de todos os sons/vídeos

; MEDIA
CENARIO_MENU                EQU 0           ; número do cenário do fundo do menu
CENARIO_JOGO                EQU 1           ; número do cenário do fundo do jogo
CENARIO_TERMINADO           EQU 2           ; número do cenário do fundo de quando se termina o jogo
CENARIO_SEM_ENERGIA         EQU 3           ; número do cenário do fundo de quando se fica sem energia

SOM_TEMA                    EQU 0           ; número da música de fundo
SOM_START                   EQU 1           ; número do som quando se começa o jogo
SOM_LASER                   EQU 2           ; número do som quando se dispara a sonda
SOM_GAMEOVER                EQU 3           ; número do som quando se perde o jogo
SOM_ASTEROIDE_DESCE         EQU 4           ; número do som quando o asteróide desce

; CORES
COR_SONDA                   EQU 0FF00H
CINZA_CLARO                 EQU 0FCCCH
CINZA_INTERMEDIO            EQU 0F999H
CINZA_ESCURO                EQU 0F555H
VERMELHO                    EQU 0FF22H
AZUL                        EQU 0F0CFH
VERDE                       EQU 0FBF2H
AMARELO                     EQU 0FFE0H
CASTANHO                    EQU 0FA64H

; ECRA
N_LINHAS                    EQU 32          ; número de linhas do ecrã (altura)
N_COLUNAS                   EQU 64          ; número de colunas do ecrã (largura)

; ECRAS
ECRA_0                      EQU 0
ECRA_1                      EQU 1
ECRA_2                      EQU 2

; TECLADO
LIN_INI                     EQU 1           ; primeira linha a testar (1ª linha, 0001b)
LINHA_TECLADO                     EQU 8           ; última linha (4ª linha, 1000b)
MASC_TEC                    EQU 0FH         ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

; TECLAS
TECLA_ESQUERDA			    EQU 0H          ; tecla 0
TECLA_MEIO  		        EQU 1H	        ; tecla 1
TECLA_DIREITA 			    EQU 2H		    ; tecla 2
TECLA_START                 EQU 0CH         ; tecla C
TECLA_PAUSAR			    EQU 0DH		    ; tecla D
TECLA_TERMINAR			    EQU 0EH		    ; tecla E
TECLA_F                     EQU 0FH         ; tecla F

; NAVE
LINHA_NAVE                  EQU 27          ; linha onde a nave começa
COLUNA_NAVE                 EQU 25          ; coluna onde a nave começa
LARGURA_15                  EQU 15          ; largura da nave
ALTURA_5                    EQU 5           ; altura da nave

; PAINEL
LINHA_PAINEL                EQU 29          ; linha onde o painel começa
COLUNA_PAINEL               EQU 29          ; coluna onde o painel começa
LARGURA_7                   EQU 7           ; largura do painel
ALTURA_2                    EQU 2           ; altura do painel

; ASTEROIDE
LINHA_ASTEROIDE             EQU 0           ; linha onde o asteróide começa
COLUNA_ASTEROIDE            EQU 0           ; coluna onde o asteróide começa
LARGURA_5                   EQU 5           ; largura do asteróide
HORIZONTAL_1                EQU 1           ; movimento horizontal do asteróide
VERTICAL_1                  EQU 1           ; movimento vertical do asteróide

; SONDA
LINHA_SONDA                 EQU 26          ; linha onde a sonda começa
COLUNA_SONDA                EQU 32          ; coluna onde a sonda começa
LARGURA_1                   EQU 1           ; largura da sonda
ALTURA_1                    EQU 1           ; altura da sonda
MOVIMENTOS                  EQU 12          ; número máximo de movimentos da sonda
OFF                         EQU 0           ; sinaliza a sonda desligada
ON                          EQU 1           ; sinaliza a sonda ligada
HORIZONTAL_0                EQU 0           ; movimento horizontal da sonda
VERTICAL_M1                 EQU -1          ; movimento vertical da sonda

ENERGIA_INI                 EQU 64H         ; quantidade da energia inicial

NAO_PREM                    EQU -1          ; sinaliza que nenhuma tecla foi premida

COLUNA                      EQU 2           ; offset para obter a coluna de um objeto a partir do seu endereço

ALTURA                      EQU 2           ; offset para obter a altura de um objeto a partir do seu endereço
PIXEL                       EQU 4           ; offset para obter o pixel de um objeto a partir do seu endereço

HORIZONTAL                  EQU 2           ; offset para obter o movimento horizontal de um objeto


; ****************************************************************************

; ****************************************************************************
; STACK POINTER
; ****************************************************************************

PLACE       1000H
; SP inicial do programa
STACK       100H
SP_inicial:

; ****************************************************************************
PAINEL:
    WORD    1H

PAINEIS:
    WORD    DEF_PNL_1
    WORD    DEF_PNL_2
    WORD    DEF_PNL_3
    WORD    DEF_PNL_4
    WORD    DEF_PNL_5
    WORD    DEF_PNL_6
    WORD    DEF_PNL_7
    WORD    DEF_PNL_8



DEF_PNL_1:
    WORD    LARGURA_7
    WORD    ALTURA_2
    WORD    VERMELHO, VERDE, CINZA_INTERMEDIO, CINZA_INTERMEDIO, AZUL, VERDE, CINZA_INTERMEDIO
    WORD    AMARELO, AZUL, VERDE, VERMELHO, CINZA_INTERMEDIO, VERMELHO, AZUL

DEF_PNL_2:
    WORD    LARGURA_7
    WORD    ALTURA_2
    WORD    VERMELHO, VERDE, AMARELO, VERDE, VERMELHO, CINZA_INTERMEDIO, VERMELHO
    WORD    CINZA_INTERMEDIO, CINZA_INTERMEDIO, VERDE, VERMELHO, AZUL, CINZA_INTERMEDIO, AMARELO

DEF_PNL_3:
    WORD    LARGURA_7
    WORD    ALTURA_2
    WORD    CINZA_INTERMEDIO, AZUL, AMARELO, CINZA_INTERMEDIO, VERMELHO, VERDE, VERMELHO
    WORD    AMARELO, VERDE, CINZA_INTERMEDIO, VERMELHO, CINZA_INTERMEDIO, AMARELO, AZUL

DEF_PNL_4:
    WORD    LARGURA_7
    WORD    ALTURA_2
    WORD    VERMELHO, CINZA_INTERMEDIO, CINZA_INTERMEDIO, VERMELHO, AZUL, VERDE, VERMELHO
    WORD    AZUL, VERMELHO, VERDE, AMARELO, CINZA_INTERMEDIO, AMARELO, CINZA_INTERMEDIO

DEF_PNL_5:
    WORD    LARGURA_7
    WORD    ALTURA_2
    WORD    VERDE, AMARELO, AMARELO, VERMELHO, AZUL, CINZA_INTERMEDIO, VERDE
    WORD    CINZA_INTERMEDIO, AZUL, VERMELHO, VERDE, CINZA_INTERMEDIO, AMARELO, CINZA_INTERMEDIO

DEF_PNL_6:
    WORD    LARGURA_7
    WORD    ALTURA_2
    WORD    CINZA_INTERMEDIO, VERMELHO, VERDE, CINZA_INTERMEDIO, AZUL, VERDE, AMARELO
    WORD    AMARELO, AZUL, VERMELHO, CINZA_INTERMEDIO, VERMELHO, CINZA_INTERMEDIO, CINZA_INTERMEDIO

DEF_PNL_7:
    WORD    LARGURA_7
    WORD    ALTURA_2
    WORD    CINZA_INTERMEDIO, VERMELHO, VERDE, CINZA_INTERMEDIO, VERMELHO, VERDE, AMARELO
    WORD    AMARELO, CINZA_INTERMEDIO, VERMELHO, AMARELO, CINZA_INTERMEDIO, CINZA_INTERMEDIO, VERMELHO

DEF_PNL_8:
    WORD    LARGURA_7
    WORD    ALTURA_2
    WORD    AZUL, VERMELHO, VERDE, CINZA_INTERMEDIO, VERMELHO, VERDE, CINZA_INTERMEDIO
    WORD    CINZA_INTERMEDIO, CINZA_INTERMEDIO, AZUL, AZUL, VERDE, CINZA_INTERMEDIO, VERMELHO

ENERGIA:
    WORD    ENERGIA_INI

POS_NAVE:
    WORD    LINHA_NAVE
    WORD    COLUNA_NAVE

DEF_NAVE:
    WORD    LARGURA_15
    WORD    ALTURA_5
    WORD    0, 0, CINZA_ESCURO, CINZA_ESCURO, CINZA_ESCURO, CINZA_ESCURO, CINZA_ESCURO, CINZA_ESCURO, CINZA_ESCURO, CINZA_ESCURO, CINZA_ESCURO, CINZA_ESCURO, CINZA_ESCURO, 0, 0
    WORD    0, CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO, 0
    WORD    CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO
    WORD    CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO
    WORD    CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO

POS_PAINEL:
    WORD    LINHA_PAINEL
    WORD    COLUNA_PAINEL

DEF_PAINEL:
    WORD    LARGURA_7
    WORD    ALTURA_2
    WORD    VERMELHO, VERDE, CINZA_INTERMEDIO, CINZA_INTERMEDIO, AZUL, VERDE, CINZA_INTERMEDIO
    WORD    AMARELO, AZUL, VERDE, VERMELHO, CINZA_INTERMEDIO, VERMELHO, AZUL

POS_ASTEROIDE:
    WORD    LINHA_ASTEROIDE
    WORD    COLUNA_ASTEROIDE

DEF_ASTEROIDE:
    WORD    LARGURA_5
    WORD    ALTURA_5
    WORD    0, 0, CASTANHO, 0, 0
    WORD    0, CASTANHO, CASTANHO, CASTANHO, 0
    WORD    CASTANHO, CASTANHO, CASTANHO, CASTANHO, CASTANHO
    WORD    0, CASTANHO, CASTANHO, CASTANHO, 0
    WORD    0, 0, CASTANHO, 0 ,0

MOV_ASTEROIDE:
    WORD    HORIZONTAL_1
    WORD    VERTICAL_1

SONDA:
    WORD    OFF
    WORD    MOVIMENTOS

DEF_SONDA:
    WORD    LARGURA_1
    WORD    ALTURA_1
    WORD    COR_SONDA

POS_SONDA:
    WORD    LINHA_SONDA
    WORD    COLUNA_SONDA

MOV_SONDA:
    WORD    VERTICAL_M1
    WORD    HORIZONTAL_0

PAUSA:
    WORD    0




ALEATORIO:
    WORD    0

TECLA_CARREGADA:
    LOCK    0


tab_int:
    WORD    0
    WORD    0
    WORD    energia_int
    WORD    nave_int

evento_int:
    WORD    0
    WORD    0
        LOCK    0
                    LOCK    0
STACK       100H
SP_energia:


STACK       100H	                        ; espaço reservado para a pilha do processo teclado
SP_teclado:				                    ; valor inicial para o SP do processo teclado

STACK       100H
SP_nave:




; ****************************************************************************
; * CODIGO 
; ****************************************************************************
PLACE       0

inicio:
    MOV     SP, SP_inicial

    MOV     BTE, tab_int			            ; inicializa BTE (registo de Base da Tabela de Exceopções)

    CALL    teclado

    MOV     [APAGA_AVISO], R0				; apaga o aviso de nenhum cenário selecionado
    MOV     [APAGA_ECRAS], R0				; apaga todos os pixels
	MOV	    R0, CENARIO_MENU				; cenário do menu
    MOV     [DEFINE_CENARIO], R0            ; seleciona o cenário de fundo

    MOV     R1, SOM_TEMA                    ; endereço da música de fundo
    MOV     [DEFINE_SOM_OU_VIDEO], R1       ; seleciona a música de fundo
    MOV     [REPRODUZ_EM_CICLO], R1         ; começa a música de fundo

;    EI0
;    EI1
    EI2
    EI3
    EI

    MOV     R0, ENERGIA
    MOV     R1, DISPLAYS
    MOV     [R1], R0

menu:
    MOV     R0, [TECLA_CARREGADA]
    MOV     R1, TECLA_START
    CMP     R0, R1
    JNZ     menu

start:
	MOV	    R0, CENARIO_JOGO				; cenário de fundo número
    MOV     [DEFINE_CENARIO], R0	        ; seleciona o cenário de fundo

    MOV     R1, SOM_TEMA                    ; endereço da música de fundo
    MOV     [DEFINE_SOM_OU_VIDEO], R1       ; seleciona a música de fundo
    MOV     [TERMINA_SOM_OU_VIDEO], R1      ; termina a música de fundo

    MOV     R1, SOM_GAMEOVER                ; endereço do som de game over
    MOV     [DEFINE_SOM_OU_VIDEO], R1       ; seleciona o som de fim de jogo
    MOV     [TERMINA_SOM_OU_VIDEO], R1      ; termina o som

    MOV     R1, SOM_START                   ; endereço da música de start
    MOV     [DEFINE_SOM_OU_VIDEO], R1       ; seleciona a música de start
    MOV     [INICIA_REPRODUCAO], R1         ; reproduz o som de start

    CALL    energia
    CALL    muda_painel

main:
    YIELD
    MOV     R0, PAUSA
    MOV     R0, [R0]
    CMP     R0, 1
    JZ      smth
    JMP     main
smth:
    MOV     R2, 482
    CALL altera_energia_r
    JMP main





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
    MOV     R7, TECLA_PAUSAR
    MOV     R8, PAUSA
    MOV     R9, [R8]
    CMP     R4, R7
    JZ      pausa

ha_tecla:									; neste ciclo espera-se até NENHUMA tecla estar premida
	YIELD
    MOVB    [R2], R1                        ; escreve no periférico de saída (linhas)
    MOVB    R0, [R3]                        ; lê do periférico de entrada (colunas)
	MOV		R4, R0							; cópia do valor do periférico de entrada
	SHR		R4, 4							; os bits 4-7 são gerados "aleatoriamente"
	MOV		[ALEATORIO], R4					; guarda o valor "aleatoriamente" gerado
    AND     R0, R5                          ; elimina bits para além dos bits 0-3
    CMP     R0, 0                           ; há tecla premida?
    JNZ     ha_tecla                        ; se ainda houver uma tecla premida, espera até não haver
	JMP		espera_tecla					; repete o ciclo

pausa:
    CMP     R9, 1
    JNZ      mete_pausa
    MOV     R11, 0
    MOV     [R8], R11
    JMP     ha_tecla

mete_pausa:
    MOV     R11, 1
    MOV     [R8], R11
    JMP     ha_tecla


PROCESS SP_energia
energia:
    MOV     R1, evento_int
    MOV     R2, [R1+4]
    MOV     R5, PAUSA
    MOV     R5, [R5]
    CMP     R5, 1
    JZ      energia
    MOV     R2, -3
    CALL    altera_energia_r
    JMP     energia


PROCESS SP_nave
; ****************************************************************************
; MUDA_PAINEL
; Descrição: Muda o painel de jogo.
; Entradas:  ---------------------
; Saídas:    ---------------------
; ****************************************************************************

muda_painel:
    MOV     R1, evento_int
    MOV     R2, [R1+6]
    MOV     R5, PAUSA
    MOV     R5, [R5]
    CMP     R5, 1
    JZ      muda_painel
    MOV     R2, PAINEL                      ; endereço da variável que guarda o nº do painel atual
    MOV     R4, [R2]                        ; número do painel atual
    ROL     R4, 2                           ; passa ao painel seguinte
    MOV     [R2], R4                        ; atualiza a variável que guarda o nº do painel
    MOV     R2, 0                           ; o 1º painel está na posição 0 da tabela

loop:                                       ; calcula em que painel está
    CMP     R4, 1H                          ; chegou ao fim?
    JZ      desenha_painel                  ; se sim, desenha o novo painel
    ROR     R4, 2                           ; roda os bits do painel em 2 posições
    ADD     R2, 2                           ; endereço do próximo painel (2 porque cada painel é uma word)
    JMP     loop                            ; repete o ciclo

desenha_painel:
    MOV     R0, POS_PAINEL                  ; coordenadas do painel
    MOV     R5, PAINEIS                     ; endereço do início da tabela de painéis
    MOV     R1, [R5+R2]                     ; adiciona o offset dado pelo nº do painel atual
    CALL    desenha_objeto                  ; desenha o painel
    JMP     muda_painel


; **************************
; INTERRUPÇÕES
; **************************

; **************************
; energia_int
; Descrição: Trata a interrupção do temporizador 2.
;            Num ciclo de 3 em 3 segundos baixa a energia em 3%.
; Entradas:  ---------------
; Saídas:    ---------------
; **************************

energia_int:
	PUSH R0

	MOV  R0, evento_int			                    ; assinala que houve uma interrupção 0
	MOV  [R0+4], R1		                    ; na componente 2 da variável evento_int
						                    ; Usa-se 4 porque cada word tem 2 bytes
	POP  R0
	RFE

; **************************
; nave_int
; Descrição: Trata a interrupção do temporizador 3.
;            Muda as cores do painel.
; Entradas:  ---------------
; Saídas:    ---------------
; **************************

nave_int:
	PUSH R0
	MOV  R0, evento_int
	MOV  [R0+6], R1		                    ; na componente 3 da variável evento_int
						                    ; Usa-se 6 porque cada word tem 2 bytes
	POP  R0
	RFE



; **************************
; ALTERA_ENERGIA
; Descrição: Incrementa/decrementa o nível de energia do display.
; Entradas:  R2 - Nível de energia a incrementar/decrementar (negativo para decrementar)
; Saídas:    -------------------
; **************************

altera_energia_r:
    PUSH    R0
    PUSH    R1
    PUSH    R2

    MOV     R0, ENERGIA                     ; endereço da energia atual do display 
    MOV     R1, [R0]                        ; energia atual do display
    ADD     R1, R2                          ; acrescenta o valor pretendido à energia atual

    CMP     R1, 0                           ; a energia atual é menor que zero?
    JLE      energia_zero                    ; se sim, atualiza a energia para zero

    MOV     [R0], R1                        ; atualiza a variável que guarda a energia
    CALL    display                         ; atualiza o display

    POP     R2
    POP     R1
    POP     R0
    RET

energia_zero:
    MOV     R1, 0                           ; energia atual é zero
    MOV     [R0], R1                        ; atualiza a variável que guarda a energia
    CALL    display                         ; atualiza o display

    POP     R2
    POP     R1
    POP     R0



; ****************************************************************************
; DISPLAY
; Descrição: Coloca o nível de energia no display.
; Entradas:  -------------------
; Saídas:    -------------------
; ****************************************************************************

display:
	PUSH    R0 
	PUSH    R4

    MOV     R4, DISPLAYS  				    ; endereço do periférico dos displays
    MOV     R0, ENERGIA				        ; endereço da energia atual do display
    MOV     R0, [R0]				        ; energia atual do display
	MOV     R3, R0						    ; guarda temporariamente o valor da energia 

	CALL    converte_hex			        ; converte o valor da energia de Hexadecimal para decimal 
	MOV     [R4], R2       			        ; escreve a energia atual nos displays
	MOV     R3, R0						    ; R3 volta a receber o valor da energia em Hexadecimal

	POP	    R4
	POP     R0
	RET


; ***********************************************************************
; CONVERTE_HEX
; Descrição: Converte um número decimal para o mesmo número hexadecimal.
; Entradas:  R0 - Número a converter
; Saídas:    R2 - Número convertido em hexadecimal
; ***********************************************************************
converte_hex:    
    PUSH    R0
    PUSH    R1
    PUSH    R3

    MOV     R1, 1000                        ; fator
    MOV     R2, 0                           ; resultado (inicialmente a 0)
ciclo_converte_hex:
    MOD     R0, R1                          ; resto da divisão inteira do número pelo fator
    MOV     R3, 10
    DIV     R1, R3                          ; prepara o próximo fator de divisão
    CMP     R1, R3                          ; cse o fator já é menor que 10, já está concluído
    JLT     exit_converte_hex               ; termina a rotina
    MOV     R3, R0
    DIV     R3, R1                          ; dígito de valor decimal
    SHL     R2, 4                           ; desloca, para dar espaço ao novo dígito
    OR      R2, R3                          ; vai compondo o resultado
    JMP     ciclo_converte_hex              ; repete o processo

exit_converte_hex:
    SHL     R2, 4                           ; desloca, para dar espaço ao último dígito
    OR      R2, R0                          ; resultado final

    POP     R3
    POP     R1
    POP     R0
    RET


; ****************************************************************************
; DESENHA_OBJETO
; Descrição: Desenha um objeto.
; Entradas:  R0 - Endereço da tabela que define a posição do objeto
;            R1 - Endereço da tabela que define o objeto
; Saídas:    ---------------------
; ****************************************************************************

desenha_objeto:
    PUSH    R0
    PUSH    R1
    PUSH    R2
    PUSH    R3
    PUSH    R4
    PUSH    R5
    PUSH    R6
    PUSH    R7

    CALL    informacoes_objeto              ; obtém as informações do objeto
    MOV     R1, R3                          ; cópia da coluna do objeto
    MOV     R7, R5                          ; cópia da altura do objeto
    MOV     R5, R4                          ; cópia da linha do objeto
    MOV     R0, R6                          ; endereço da cor do pixel a tratar

desenha_pixels:                             ; desenha os pixels do objeto a partir da tabela
    MOV     R6, [R0]                        ; obtém a cor do próximo pixel do objeto
    CALL    desenha_pixel
    ADD     R0, 2                           ; endereço do próximo pixel (2 porque cada pixel é uma word)
    ADD     R3, 1                           ; próxima coluna
    SUB     R5, 1                           ; menos uma coluna para tratar
    JNZ     desenha_pixels                  ; continua até percorrer toda a largura do objeto
    ADD     R2, 1                           ; próxima linha
    MOV     R3, R1                          ; recomeça na primeira coluna
    MOV     R5, R4                          ; largura do objeto
    SUB     R7, 1                           ; menos uma linha para tratar
    JNZ     desenha_pixels                  ; continua até percorrer toda a altura do objeto

    POP     R7
    POP     R6
    POP     R5
    POP     R4
    POP     R3
    POP     R2
    POP     R1
    POP     R0
    RET


; ****************************************************************************
; MOVE_OBJETO
; Descrição: Move o objeto.
; Entradas:  R0 - Endereço da tabela que define a posição do objeto
;            R1 - Endereço da tabela que define o objeto
;            R2 - Endereço da tabela de movimentos do objeto
;            R3 - Ecrã do objeto
; Saídas:    ------------------------------------------------------
; ****************************************************************************

move_objeto:
    PUSH    R0
    PUSH    R1
    PUSH    R2
    PUSH    R3
    PUSH    R4

    MOV     [APAGA_ECRA], R3
    MOV     R3, [R0]                        ; linha do objeto
    MOV     R4, [R2]                        ; movimento vertical do objeto
    ADD     R3, R4                          ; nova linha do objeto
    MOV     [R0], R3                        ; atualiza a linha do objeto
    MOV     R3, [R0+COLUNA]                 ; coluna do objeto
    MOV     R4, [R2+HORIZONTAL]             ; movimento horizontal do objeto
    ADD     R3, R4                          ; nova coluna do objeto
    MOV     [R0+HORIZONTAL], R3             ; atualiza a coluna do objeto
    CALL    desenha_objeto                  ; movimenta o objeto

    POP     R4
    POP     R3
    POP     R2
    POP     R1
    POP     R0
    RET

; ****************************************************************************
; DESENHA_PIXEL
; Descrição: Desenha um pixel.
; Entradas:  R2 - Linha do objeto
;            R3 - Coluna do objeto
;            R6 - Cor do objeto
; Saídas:    ---------------------
; ****************************************************************************

desenha_pixel:
    MOV     [DEFINE_LINHA], R2              ; seleciona a linha
    MOV     [DEFINE_COLUNA], R3             ; seleciona a coluna
    MOV     [ALTERA_COR_SONDA_C], R6        ; altera a cor do pixel na linha e coluna selecionadas
    RET

;***************************************************************************
; INFORMACOES_OBJETO
; Descrição: Obtém e guarda as coordenadas, dimensões e 1º pixel do objeto.
; Entradas:  R0 - Endereço da tabela que define a posição do objeto
;            R1 - Endereço da tabela que define o objeto
; Saídas:    R2 - Linha do objeto
;            R3 - Coluna do objeto
;            R4 - Largura do objeto
;            R5 - Altura do objeto
;            R6 - Endereço do 1º pixel do objeto
;***************************************************************************

informacoes_objeto:
    PUSH    R1

    MOV     R2, [R0]                        ; linha do objeto
    MOV     R3, [R0+COLUNA]                 ; coluna do objeto
    MOV     R4, [R1]                        ; largura do objeto
    MOV     R5, [R1+ALTURA]                 ; altura do objeto
    ADD     R1, PIXEL                       ; endereço do 1º pixel do objeto
    MOV     R6, R1                          ; guarda esse endereço

    POP     R1
    RET