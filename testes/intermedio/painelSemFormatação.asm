; ****************************************************************************
; * Projeto primeira entrega
; * ist1105901 - Francisca Almeida
; * ist1106827 - Cecília Correia
; * ist1106943 - José Frazão

; * Descrição: Simula o jogo dos asteróides num computador de 16 bits.
; ****************************************************************************

; ****************************************************************************
; * Constantes

; ENDEREÇOS
COMANDOS				    EQU	6000H   ; endereço de base dos comandos do MediaCenter
MEMORIA_MC				    EQU	8000H   ; endereço de base da memória do MediaCenter
DISPLAYS                    EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN                     EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL                     EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)

; COMANDOS DE ESCRITA DO MEDIA CENTER
APAGA_ECRA                  EQU COMANDOS    ; comando que apaga todos os pixéis de um ecrã específico
APAGA_ECRAS                 EQU 6002H       ; comando que apaga todos os pixéis de todos os ecrãs
SELECIONA_ECRA              EQU 6004H       ; comando que seleciona o ecrã a ser utilizado
MOSTRA_ECRA                 EQU 6006H       ; comando que mostra o ecrã especificado
ESCONDE_ECRA                EQU 6008H       ; comando que esconde o ecrã especificado
DEFINE_LINHA                EQU 600AH       ; comando que define a linha
DEFINE_COLUNA               EQU 600CH       ; comando que define a coluna
DEFINE_PIXEL                EQU 600EH       ; comando que define o pixel
DEFINE_AUTO_INC             EQU 6010H       ; comando que define o auto-incremento
ALTERA_COR_PIXEL_C          EQU 6012H       ; comando que altera a cor do pixel corrente
DEFINE_COR_CANETA           EQU 6014H       ; comando que define a cor da caneta
ALTERA_COR_PIXEL_CAN_C      EQU 6016H       ; comando que altera a cor do pixel segundo a caneta
APAGA_PIXEL                 EQU 6018H       ; comando que apaga o pixel
ALTERA_COR_PIXEL_COR_CAN    EQU 601AH       ; comando que altera a cor do pixel corrente segundo a caneta
ALTERA_COR_8_PIXELS         EQU 601CH       ; comando que altera a cor de 8 pixels
ALTERA_COR_16_PIXELS        EQU 601EH       ; comando que altera a cor de 16 pixels
DESENHA_PADRAO              EQU 6020H       ; comando que desenha um padrão
DESENHA_PADRAO_GRADIENTE    EQU 6022H       ; comando que desenha um padrão com gradiente
APAGA_AVISO                 EQU 6040H       ; comando que apaga o cenário de fundo e elimina aviso
DEFINE_CENARIO              EQU 6042H       ; comando que define o cenário
APAGA_CENARIO_FRONTAL       EQU 6044H       ; comando que apaga o cenário frontal
DEFINE_CENARIO_FRONTAL      EQU 6046H       ; comando que define o cenário frontal
DEFINE_SOM_OU_VIDEO         EQU 6048H       ; comando que define o som/vídeo
DEFINE_VOLUME_SOM           EQU 604AH       ; comando que define o volume do som/vídeo
CORTA_SOM                   EQU 604CH       ; comando que corta o volume(mute) do som/vídeo
RETOMA_SOM                  EQU 604EH       ; comando que retoma o volume do som/vídeo
CORTA_SONS                  EQU 6050H       ; comando que corta os volumes(mute) de todos os sons/vídeos
RETOMA_SONS                 EQU 6052H       ; comando que retoma os volumes de todos os sons/vídeos
DEFINE_BRILHO               EQU 6054H       ; comando que define o brilho
DEFINE_PADRAO_TRANSICAO     EQU 6056H       ; comando que define o padrão de transição entre vídeos
DEFINE_NUM_REPETICOES       EQU 6058H       ; comando que define o número de vezes que um som/vídeo deve ser reproduzido
INICIA_REPRODUCAO           EQU 605AH       ; comando que inicia a reprodução do som/vídeo
REPRODUZ_EM_CICLO           EQU 605CH       ; comando que reproduz um som/vídeo em ciclo
PAUSA_SOM_OU_VIDEO          EQU 605EH       ; comando que pausa a reprodução do som/vídeo
CONTINUA_SOM_OU_VIDEO       EQU 6060H       ; comando que retoma a reprodução do som/vídeo
PAUSA_SONS_OU_VIDEOS        EQU 6062H       ; comando que pausa a reprodução de todos os sons/vídeos
CONTINUA_SONS_OU_VIDEOS     EQU 6064H       ; comando que retoma a reprodução de de todos os sons/vídeos
TERMINA_SOM_OU_VIDEO        EQU 6066H       ; comando que termina a reprodução do som/vídeo
TERMINA_SONS_OU_VIDEOS      EQU 6068H       ; comando que termina a reprodução de todos os sons/vídeos

; COMANDOS DE LEITURA DO MEDIA CENTER
NUM_COLUNAS_ECRA            EQU COMANDOS    ; comando que obtém o número de colunas do ecrã
NUM_LINHAS_ECRA             EQU 6002H       ; comando que obtém o número de linhas do ecrã
OBTEM_ECRA                  EQU 6004H       ; comando que obtém o ecrã
OBTEM_VISIBILIDADE          EQU 6006H       ; comando que obtém a visibilidade do ecrã
OBTEM_LINHA_POS_C           EQU 6008H       ; comando que obtém a linha da posição corrente
OBTEM_COLUNA_POS_C          EQU 600AH       ; comando que obtém a coluna da posição corrente
OBTEM_PIXEL_POS_C           EQU 600CH       ; comando que obtém o pixel da posição corrente
OBTEM_ESTADO_AUTO_INC       EQU 600EH       ; comando que obtém o estado do auto-incremento
OBTEM_COR_PIXEL_POS_C       EQU 6010H       ; comando que obtém a cor do pixel na posição corrente
OBTEM_COR_CANETA            EQU 6012H       ; comando que obtém a cor da caneta
OBTEM_ESTADO_COR_PIXEL_C    EQU 6014H       ; comando que obtém o estado da cor do pixel corrente
OBTEM_ESTADO_COR_8PIXELS_C  EQU 6016H       ; comando que obtém o estado da cor de 8 pixels
OBTEM_ESTADO_COR_16PIXELS_C EQU 6018H       ; comando que obtém o estado da cor de 16 pixels
OBTEM_NUM_IMAGENS           EQU 6040H       ; comando que obtém o número de imagens definidas
OBTEM_CENARIO_FUNDO         EQU 6042H       ; comando que obtém o cenário de fundo
OBTEM_CENARIO_FRONTAL       EQU 6044H       ; comando que obtém o cenário frontal
OBTEM_NUM_SONS_OU_VIDEOS    EQU 6046H       ; comando que obtém o número de sons/vídeos definidos
OBTEM_NUM_SOM_OU_VIDEO      EQU 6048H       ; comando que obtém o som/vídeo
OBTEM_VOLUME_SOM_OU_VIDEO   EQU 604AH       ; comando que obtém o volume do som/vídeo
OBTEM_MUTE_SOM_OU_VIDEO     EQU 604CH       ; comando que obtém o estado de mute do som/vídeo
OBTEM_BRILHO                EQU 604EH       ; comando que obtém o brilho
OBTEM_NUM_PADRAO_TRANSICAO  EQU 6050H       ; comando que obtém o padrão de transição
OBTEM_ESTADO_SOM_OU_VIDEO   EQU 6052H       ; comando que obtém o estado do som/vídeo
OBTEM_NUM_A_REPRODUZIR      EQU 6054H       ; comando que obtém o número de sons/vídeos a reproduzir
OBTEM_NUM_VEZES_A_REP       EQU 6056H       ; comando que obtém o número de vezes que o som/vídeo será reproduzido

; MEDIA
CENARIO_JOGO        EQU 1   ; número do cenário do fundo do jogo
CENARIO_PERDEU      EQU 2   ; número do cenário do fundo de quando se perde
CENARIO_MENU        EQU 0   ; número do cenário do fundo do menu

SOM_TEMA            EQU 0   ; número da música de fundo
SOM_START           EQU 1   ; número do som quando se começa o jogo

; CORES
COR_PIXEL           EQU 0FF00H  ; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)
CINZA_ESCURO        EQU 0F555H
CINZA_CLARO         EQU 0FCCCH
CINZA_INTERMEDIO    EQU 0F999H
VERMELHO            EQU 0FF22H
AZUL                EQU 0F0CFH
VERDE               EQU 0FBF2H
AMARELO             EQU 0FFE0H

; ECRA
N_LINHAS        EQU  32     ; número de linhas do ecrã (altura)
N_COLUNAS       EQU  64     ; número de colunas do ecrã (largura)

; TECLADO
LIN_INI         EQU 1       ; primeira linha a testar (1ª linha, 0001b)
LIN_FIN         EQU 8       ; última linha (4ª linha, 1000b)
MASC_TEC        EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

; TECLAS
TECLA_ESQUERDA			 EQU 0H             ; tecla 0
TECLA_MEIO  		     EQU 1H	            ; tecla 1
TECLA_DIREITA 			 EQU 2H		        ; tecla 2
TECLA_START              EQU 0CH            ; tecla C
TECLA_PAUSAR			 EQU 0DH		    ; tecla D
TECLA_TERMINAR			 EQU 0EH		    ; tecla E

; NAVE
LINHA_NAVE       EQU 27      ; número da linha onde o nave começa
COLUNA_NAVE    EQU 25        ; número da coluna onde o nave começa
LARGURA_15      EQU 15
ALTURA_5        EQU 5

; PAINEL
LINHA_PAINEL    EQU 29
COLUNA_PAINEL   EQU 29
LARGURA_7       EQU 7
ALTURA_2        EQU 2

; JOGO
ENERGIA_INI         EQU 100H    ; número de energia inicial

; ****************************************************************************

; ****************************************************************************
; STACK POINTER
PLACE       1000H
; SP inicial do programa
STACK       100H
SP_inicial:
; ****************************************************************************
ENERGIA:
    WORD    100H

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

POS_PAINEL:
    WORD    LINHA_PAINEL
    WORD    COLUNA_PAINEL

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

; **********
; * CODIGO *
; **********
PLACE       0

inicio:
    MOV     SP, SP_inicial

    MOV     [APAGA_AVISO], R0				; apaga o aviso de nenhum cenário selecionado
    MOV     [APAGA_ECRA], R0				; apaga todos os pixels
	MOV	    R0, CENARIO_MENU				; cenário do menu
    MOV     [DEFINE_CENARIO], R0            ; seleciona o cenário de fundo

    MOV     R1, SOM_TEMA                    ; endereço da música de fundo
    MOV     [DEFINE_SOM_OU_VIDEO], R1       ; seleciona a música de fundo
    MOV     [REPRODUZ_EM_CICLO], R1         ; começa a música de fundo

    MOV     R0, 0                           ; coloca o nível de energia a 0
    CALL    display                         ; mostra o nível de energia no nave


menu:
    MOV     R0, TECLA_START                 ; tecla que inicia o jogo
    CALL    teclado                         ; lê uma tecla
	CMP     R3, R0					        ; verifica se a tecla de start foi pressionada
	JNZ     menu				            ; se não, volta ao ciclo do menu
	JMP     start						    ; se foi, começa o jogo

start:
	MOV	    R0, CENARIO_JOGO				; cenário de fundo número
    MOV     [DEFINE_CENARIO], R0	        ; seleciona o cenário de fundo

    MOV     R1, SOM_TEMA                    ; endereço da música de fundo
    MOV     [DEFINE_SOM_OU_VIDEO], R1       ; seleciona a música de fundo
    MOV     [TERMINA_SOM_OU_VIDEO], R1      ; termina a música de fundo

    MOV     R1, SOM_START                   ; endereço da música de start
    MOV     [DEFINE_SOM_OU_VIDEO], R1       ; seleciona a música de start
    MOV     [INICIA_REPRODUCAO], R1         ; reproduz o som de start



main:
    MOV     R0, ENERGIA                     ; endereço da variável que guarda a energia do display
    MOV     R1, ENERGIA_INI                 ; número de energia inicial
    MOV     [R0], R1                        ; inicia a energia com o valor 100H
    CALL    display                         ; mostra o nível de energia no nave

    MOV     R0, POS_NAVE                    ; coordenadas da nave
    MOV     R1, DEF_NAVE                    ; protótipo da nave
    CALL    desenha_objeto                  ; desenha a nave

    MOV     R0, POS_PAINEL                  ; coordenadas do painel
    MOV     R1, DEF_PNL_1                   ; 1º painel
    CALL    desenha_objeto                  ; desenha o 1º painel


ciclo:
    CALL    teclado                         ; lê uma tecla
    MOV     R2, TECLA_TERMINAR              ; tecla para terminar o jogo
    CMP     R3, R2                          ; a tecla lida é o "E"?
    JZ      fim                             ; se sim, termina o programa
    MOV     R2, TECLA_ESQUERDA              ; tecla para incrementar em uma unidade(hexadecimal) o display
    CMP     R3, R2                          ; a tecla lida é o "0"?
    JZ      aumenta_energia                 ; se sim, incrementa o display
    MOV     R2, TECLA_DIREITA               ; tecla para decrementar em uma unidade(hexadecimal) o display
    CMP     R3, R2                          ; a tecla lida é o "2"?
    JZ      diminui_energia                 ; se sim, decrementa o display
    MOV     R2, TECLA_MEIO                  ; tecla para mudar o painel
    CMP     R3, R2                          ; a tecla lida é o "1"?
    JZ      muda_painel                     ; se sim, muda o painel
    JMP     ciclo                           ; repete o ciclo

fim:
    JMP     fim                             ; termina o programa

aumenta_energia:
    CALL    aumenta_energia_r               ; incrementa o display
    JMP     ciclo                           ; repete o ciclo

diminui_energia:
    CALL diminui_energia_r                  ; decrementa o display
    JMP     ciclo                           ; repete o ciclo

muda_painel:
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
    JMP     ciclo                           ; repete o ciclo


;**********
; ROTINAS *
;**********

;******************************************
; TECLADO
; Descrição: Lê a tecla do teclado premida.
; Entradas:  -------------------
; Saídas:    R3 - Valor da tecla
;******************************************
teclado:
    PUSH    R0
    PUSH    R1
    PUSH    R2
    PUSH    R4
    PUSH    R5
    PUSH    R6
    PUSH    R7
    PUSH    R8

inicializações:		
    MOV     R2, TEC_LIN   ; endereço do periférico das linhas
    MOV     R3, TEC_COL   ; endereço do periférico das colunas
    MOV     R4, DISPLAYS  ; endereço do periférico dos displays
    MOV     R5, MASC_TEC  ; isola os 4 bits de menor peso, ao ler as colunas do teclado
    MOV     R6, LIN_INI   ; primeira linha a ser testada (1ª linha, 0001b)
    MOV     R7, LIN_FIN   ; linha final

varre_linhas:	          ; varre cada linha, uma a uma
    MOV     R1, R6        ; testa cada linha
    MOVB    [R2], R1      ; escreve no periférico de saída (linhas)
    MOVB    R0, [R3]      ; lê do periférico de entrada (colunas)
    AND     R0, R5        ; elimina bits para além dos bits 0-3
    CMP     R0, 0         ; há tecla premida?
    JNZ     converte      ; se sim, converte a linha e a coluna para uma tecla

verifica_ultima:          ; verifica se já percorreu todas as linhas 
    CMP     R6, R7        ; é a última linha?
    JZ      sai_tecl      ; se sim, repete o processo desde o início
    SHL     R6, 1         ; se não, testa a linha seguinte na próxima iteração
    JMP     varre_linhas  ; passa para a linha seguinte

converte:                 ; converte a linha e a coluna para uma tecla
    MOV     R2, R1        ; copia a linha
    MOV     R3, 0         ; começa na primeira linha (= 0)
    JMP     linha         ; converte a linha para um número entre 0 e 3

exit_linha:
    MOV     R4, 4         ; prepara a multiplicação
    MUL     R3, R4        ; multiplica a linha por 4
    MOV     R4, R3        ; copia o valor da linha convertida * 4
    MOV     R4, 0         ; começa na primeira coluna (= 0)
    MOV     R2, R0        ; copia a coluna
    JMP     coluna        ; converte a coluna para um número entre 0 e 3

exit_coluna:
    ADD     R3, R4        ; valor = 4*linha + coluna
    JMP     sai_tecl      ; sai da rotina

linha:                    ; loop para converter a linha
    SHR     R2, 1         ; desloca os bits da linha uma poisção para a direita
    CMP     R2, 0         ; já converteu a linha?
    JNZ     out_linha     ; se não, passa para a linha seguinte
    JMP     exit_linha    ; se já converteu, sai do loop

out_linha:
    ADD     R3, 1         ; incrementa a linha em 1
    JMP     linha         ; repete o processo

coluna:                   ; loop para converter a coluna
    SHR     R2, 1         ; desloca os bits da coluna uma posição para a direita
    CMP     R2, 0         ; já converteu a coluna
    JNZ     out_coluna    ; se não, passa para a coluna seguinte
    JMP     exit_coluna   ; se já converteu, sai do loop

out_coluna:
    ADD     R4, 1         ; incrementa a coluna em 1
    JMP     coluna        ; repete o processo

sai_tecl:
    POP     R8
    POP     R7
    POP     R6
    POP     R5
    POP     R4
    POP     R2
    POP     R1
    POP     R0
    RET


;*************************************************
; DISPLAY
; Descrição: Coloca o nível de energia no display.
; Entradas:  -------------------
; Saídas:    -------------------
;*************************************************

display:
    PUSH    R0
	PUSH    R1
    MOV     R0, ENERGIA             ; endereço da energia atual do display
    MOV     R1, [R0]                ; energia atual do display
    MOV     R0, DISPLAYS  			; endereço do periférico dos displays    
	MOV     [R0], R1       			; escreve a vida atual nos displays
	POP	    R1
    POP     R0
    RET

;******************************************************************
; AUMENTA_ENERGIA
; Descrição: Incrementa o nível de energia do display em 1 unidade.
; Entradas:  -------------------
; Saídas:    -------------------
;******************************************************************
aumenta_energia_r:
    PUSH    R0
    PUSH    R1
    MOV     R0, ENERGIA                     ; endereço da energia atual do display 
    MOV     R1, [R0]                        ; energia atual do display
    ADD     R1, 1                           ; incrementa o nível de energia em uma unidade
    MOV     [R0], R1                        ; atualiza a variável que guarda a energia
    CALL    display                         ; atualiza o display
    POP     R1
    POP     R0
    RET

;******************************************************************
; DIMINUI_ENERGIA
; Descrição: Decrementa o nível de energia do display em 1 unidade.
; Entradas:  -------------------
; Saídas:    -------------------
;******************************************************************
diminui_energia_r:
    PUSH    R0
    PUSH    R1
    MOV     R0, ENERGIA                     ; endereço da energia atual do display 
    MOV     R1, [R0]                        ; energia atual do display
    SUB     R1, 1                           ; decrementa o nível de energia em uma unidade
    MOV     [R0], R1                        ; atualiza a variável que guarda a energia
    CaLL    display                         ; atualiza o display
    POP     R1
    POP     R0
    RET


;******************************************************************
; DESENHA_OBJETO
; Descrição: Desenha um objeto.
; Entradas:  R0 - Endereço da tabela que define a posição do objeto
;            R1 - Endereço da tabela que define o objeto
; Saídas:    ---------------------
;******************************************************************
desenha_objeto:
    PUSH    R0
    PUSH    R1
    PUSH    R2
    PUSH    R3
    PUSH    R4
    PUSH    R5
    PUSH    R6
    PUSH    R7
    PUSH    R8

    CALL    informacoes_boneco
    MOV     R7, R3                          ; cópia da coluna do objeto
    MOV     R8, R5                          ; cópia da altura do objeto
    MOV     R5, R4                          ; cópia da linha do objeto

desenha_pixels:                             ; desenha os pixels do objeto a partir da tabela
    MOV     R0, [R6]                        ; obtém a cor do próximo pixel do objeto
    MOV     [DEFINE_LINHA], R2              ; seleciona a linha
    MOV     [DEFINE_COLUNA], R7             ; seleciona a coluna
    MOV     [ALTERA_COR_PIXEL_C], R0        ; altera a cor do pixel na linha e coluna selecionadas
    ADD     R6, 2                           ; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD     R7, 1                           ; próxima coluna
    SUB     R5, 1                           ; menos uma coluna para tratar
    JNZ     desenha_pixels                  ; continua até percorrer toda a largura do objeto
    ADD     R2, 1                           ; próxima linha
    MOV     R7, R3                          ; recomeça na primeira coluna
    MOV     R5, R4                          ; largura do objeto
    SUB     R8, 1                           ; menos uma linha para tratar
    JNZ     desenha_pixels                  ; continua até percorrer toda a altura do objeto

    POP     R8
    POP     R7
    POP     R6
    POP     R5
    POP     R4
    POP     R3
    POP     R2
    POP     R1
    POP     R0
    RET

;**************************************************************************
; INFORMACOES_BONECO
; Descrição: Obtém e guarda as coordenadas, dimensões e 1º pixel do objeto.
; Entradas:  R0 - Endereço da tabela que define a posição do objeto
;            R1 - Endereço da tabela que define o objeto
; Saídas:    R2 - Linha do objeto
;            R3 - Coluna do objeto
;            R4 - Largura do objeto
;            R5 - Altura do objeto
;            R6 - Endereço do 1º pixel do objeto
;***************************************************************************
informacoes_boneco:
    MOV     R2, [R0]                        ; linha do objeto
    MOV     R3, [R0+2]                      ; coluna do objeto
    MOV     R4, [R1]                        ; largura do objeto
    ADD     R1, 2                           ; endereço da altura do próximo pixel (2 porque a largura do objeto é uma word)
    MOV     R5, [R1]                        ; altura do objeto
    ADD     R1, 2                           ; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    MOV     R6, R1                          ; endereço do 1º pixel do objeto
    RET