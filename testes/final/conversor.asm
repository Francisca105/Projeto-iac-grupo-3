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
DEFINE_CENARIO_FRONTAL      EQU 6046H       ; comando que define o cenário frontal
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
LIN_FIN                     EQU 8           ; última linha (4ª linha, 1000b)
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
tab:                        ; Tabela de interrupções
	WORD rot_int_0			; rotina de atendimento da interrupção 0

; ****************************************************************************


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
    WORD    CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO, 0, 0, 0, 0, 0, 0, 0, CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO
    WORD    CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO, 0, 0, 0, 0, 0, 0, 0, CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO
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

DEF_PAINEL:
    WORD    LARGURA_7
    WORD    ALTURA_2
    WORD    VERMELHO, VERDE, CINZA_INTERMEDIO, CINZA_INTERMEDIO, AZUL, VERDE, CINZA_INTERMEDIO
    WORD    AMARELO, AZUL, VERDE, VERMELHO, CINZA_INTERMEDIO, VERMELHO, AZUL

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

; ****************************************************************************
; * CODIGO 
; ****************************************************************************
PLACE       0

inicio:
    MOV     SP, SP_inicial

    MOV     BTE, tab			            ; inicializa BTE (registo de Base da Tabela de Exceopções)

    MOV     [APAGA_AVISO], R0				; apaga o aviso de nenhum cenário selecionado
    MOV     [APAGA_ECRAS], R0				; apaga todos os pixels
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

    MOV     R0, ECRA_1                      ; ecrã nº1
    MOV     [APAGA_ECRA], R0                ; reseta o ecrã
    MOV     [SELECIONA_ECRA], R0            ; seleciona o ecrã nº1
    CALL    sonda                           ; desenha a sonda

    MOV     R0, ECRA_2                      ; ecrã nº2
    MOV     [APAGA_ECRA], R0                ; reseta o ecrã
    MOV     [SELECIONA_ECRA], R0            ; seleciona o ecrã nº2
    MOV     R0, POS_ASTEROIDE               ; coordenadas do asteróide
    MOV     R1, DEF_ASTEROIDE               ; prótotipo do asteróide
    CALL    desenha_objeto                  ; desenha o painel

    MOV     R0, NAO_PREM                    ; tecla não premida

    EI0                                     ; ativa a interrupção do timer 0
    EI                                      ; ativa as interrupções

espera_tecla:
    CALL    teclado                         ; lê o tecla
    CMP     R3, R0                          ; nenhuma tecla premida?
    JZ      espera_tecla                    ; então, continua a esperar

aumenta_display:
    MOV     R1, TECLA_ESQUERDA              ; tecla para incrementar em uma unidade o display
    CMP     R3, R1                          ; a tecla lida é o "0"?
    JNZ     diminui_energia                 ; se não, verifica a próxima
    CALL    aumenta_energia_r               ; incrementa a energia em uma unidade
    CALL    premida                         ; espera que a tecla deixe de ser premida
    JMP     espera_tecla                    ; lê o teclado

diminui_energia:
    MOV     R1, TECLA_DIREITA               ; tecla para decrementar em uma unidade o display
    CMP     R3, R1                          ; a tecla lida é o "2"?
    JNZ     dispara_sonda                   ; se não, verifica a próxima
    CALL    diminui_energia_r               ; decrementa a energia em uma unidade
    CALL    premida                         ; espera que a tecla deixe de ser premida
    CALL    energia                         ; verifica a energia atual da nave
    CMP     R1, 0                           ; a energia está a 0 ou abaixo disso?
    JGT     espera_tecla                    ; se não, lê o teclado
    CALL    game_over_energia               ; termina o jogo
    JMP     start

dispara_sonda:
    MOV     R1, TECLA_F                     ; tecla para mover a sonda
    CMP     R3, R1                          ; a tecla lida é o "F"?
    JNZ     desloca_asteroide               ; se não, verifica a próxima
    CALL    sonda                           ; move a sonda
    CALL    premida                         ; espera que a tecla deixe de ser premida
    JMP     espera_tecla                    ; lê o teclado

desloca_asteroide:
    MOV     R1, TECLA_PAUSAR                ; tecla para mover o asteróide
    CMP     R3, R1                          ; a tecla lida é o "D"?
    JNZ     termina_jogo                    ; se não, verifica a próxima 
    CALL    asteroide                       ; move o asteróide
    CALL    premida                         ; espera que a tecla deixe de ser premida
    JMP     espera_tecla                    ; lê o teclado

termina_jogo:
    MOV     R1, TECLA_TERMINAR              ; tecla para terminar o jogo
    CMP     R3, R1                          ; a tecla lida é o "E"?
    JNZ     espera_tecla                    ; se não, lê o teclado
    MOV     R1, CENARIO_TERMINADO           ; cenário de fundo com a mensagem de fim de jogo
    MOV     [DEFINE_CENARIO], R1            ; seleciona o cenário
    CALL    game_over                       ; termina o jogo
    JMP     start


; ****************************************************************************
; ROTINAS
; ****************************************************************************

; ****************************************************************************
; TECLADO
; Descrição: Lê o teclado.
; Entradas:  -------------------
; Saídas:    R3 - Valor da tecla
; ****************************************************************************

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
    MOV     R2, TEC_LIN                     ; endereço do periférico das linhas
    MOV     R3, TEC_COL                     ; endereço do periférico das colunas
    MOV     R4, DISPLAYS                    ; endereço do periférico dos displays
    MOV     R5, MASC_TEC                    ; isola os 4 bits de menor peso ao ler as colunas do teclado
    MOV     R6, LIN_INI                     ; primeira linha a ser testada (1ª linha, 0001b)
    MOV     R7, LIN_FIN                     ; linha final

varre_linhas:	                            ; varre cada linha, uma a uma
    MOV     R1, R6                          ; testa uma linha
    MOVB    [R2], R1                        ; escreve no periférico de saída (linhas)
    MOVB    R0, [R3]                        ; lê do periférico de entrada (colunas)
    AND     R0, R5                          ; elimina bits para além dos bits 0-3
    CMP     R0, 0                           ; há tecla premida?
    JNZ     converte                        ; se sim, converte a linha e a coluna para uma tecla

verifica_ultima:                            ; verifica se já percorreu todas as linhas 
    CMP     R6, R7                          ; é a última linha?
    JZ      nenhuma                         ; se sim, indica que nehuma tecla foi premida
    SHL     R6, 1                           ; se não, testa a linha seguinte na próxima iteração
    JMP     varre_linhas                    ; passa para a linha seguinte

nenhuma: 
    MOV     R3, NAO_PREM                    ; valor de que nenhuma tecla foi premida
    JMP     exit_teclado

converte:                                   ; converte a linha e a coluna para uma tecla
    MOV     R2, R1                          ; copia a linha
    MOV     R3, 0                           ; começa na primeira linha (= 0)
    JMP     linha                           ; converte a linha para um número entre 0 e 3

exit_linha:
    MOV     R4, 4
    MUL     R3, R4                          ; multiplica a linha por 4
    MOV     R4, R3                          ; copia o valor da linha convertida * 4
    MOV     R4, 0                           ; começa na primeira coluna (= 0)
    MOV     R2, R0                          ; copia a coluna
    JMP     coluna                          ; converte a coluna para um número entre 0 e 3

exit_coluna:
    ADD     R3, R4                          ; tecla = 4*linha + coluna
    JMP     exit_teclado                    ; sai da rotina

linha:                                      ; loop para converter a linha
    SHR     R2, 1                           ; desloca os bits da linha uma poisção para a direita
    CMP     R2, 0                           ; já converteu a linha?
    JNZ     out_linha                       ; se não, passa para a linha seguinte
    JMP     exit_linha                      ; se já converteu, sai do loop

out_linha:
    ADD     R3, 1                           ; incrementa a linha em 1
    JMP     linha                           ; repete o processo

coluna:                                     ; loop para converter a coluna
    SHR     R2, 1                           ; desloca os bits da coluna uma posição para a direita
    CMP     R2, 0                           ; já converteu a coluna
    JNZ     out_coluna                      ; se não, passa para a coluna seguinte
    JMP     exit_coluna                     ; se já converteu, sai do loop

out_coluna:
    ADD     R4, 1                           ; incrementa a coluna em 1
    JMP     coluna                          ; repete o processo

exit_teclado:
    POP     R8
    POP     R7
    POP     R6
    POP     R5
    POP     R4
    POP     R2
    POP     R1
    POP     R0
    RET

; ****************************************************************************
; PREMIDA
; Descrição: Espera que a tecla deixe de ser premida.
; Entradas:  -------------------
; Saídas:    -------------------
; ****************************************************************************

premida:
    PUSH    R0
    PUSH    R3

    MOV     R0, NAO_PREM                    ; nenhuma tecla premida
loop_premida:
    CALL    teclado                         ; lê uma tecla
    CMP     R3, R0                          ; a tecla continua a ser premida?
    JNZ     loop_premida                    ; se sim, continua o ciclo

    POP     R3
    POP     R0
    RET


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

	;CALL    converte_hex			        ; converte o valor da energia de Hexadecimal para decimal 
	MOV     [R4], R3       			        ; escreve a energia atual nos displays
	MOV     R3, R0						    ; R3 volta a receber o valor da energia em Hexadecimal

	POP	    R4
	POP     R0
	RET

; ****************************************************************************
; AUMENTA_ENERGIA
; Descrição: Incrementa o nível de energia do display em 1 unidade.
; Entradas:  -------------------
; Saídas:    -------------------
; ****************************************************************************

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

; ****************************************************************************
; DIMINUI_ENERGIA
; Descrição: Decrementa o nível de energia do display em 1 unidade.
; Entradas:  -------------------
; Saídas:    -------------------
; ****************************************************************************

diminui_energia_r:
    PUSH    R0
    PUSH    R1

    MOV     R0, ENERGIA                     ; endereço da energia atual do display 
    MOV     R1, [R0]                        ; energia atual do display
    SUB     R1, 1                           ; decrementa o nível de energia em uma unidade
    MOV     [R0], R1                        ; atualiza a variável que guarda a energia
    CALL    display                         ; atualiza o display

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
; MUDA_PAINEL
; Descrição: Muda o painel de jogo.
; Entradas:  ---------------------
; Saídas:    ---------------------
; ****************************************************************************

muda_painel:
    PUSH    R0
    PUSH    R1
    PUSH    R2
    PUSH    R4
    PUSH    R5

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

    POP     R5
    POP     R4
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

; ****************************************************************************
; SONDA
; Descrição: Cria ou move uma sonda.
; Entradas:  -----------------------
; Saídas:    -----------------------
; ****************************************************************************

sonda:
    PUSH    R0
    PUSH    R1
    PUSH    R2
    PUSH    R3
    PUSH    R6

    MOV     R6, ECRA_1                      ; ecrã nº1
    MOV     [SELECIONA_ECRA], R6            ; seleciona o ecrã
    MOV     R0, SONDA                       ; endereço da tabela relativa à sonda
    MOV     R1, [R0]                        ; informação se já existe uma sonda no ecrã
    CMP     R1, 0                           ; está ativa?
    JZ      cria_sonda                      ; se não, cria uma nova

move_sonda:
    MOV     R1, SOM_LASER                   ; endereço da música de fundo
    MOV     [DEFINE_SOM_OU_VIDEO], R1       ; seleciona a música de start
    MOV     [INICIA_REPRODUCAO], R1         ; reproduz o som de start

    MOV     [APAGA_ECRA], R6                ; apaga a sonda atual
    ADD     R0, 2                           ; endereço dos movimentos da sonda
    MOV     R1, [R0]                        ; movimentos da sonda
    CMP     R1, 0                           ; já fez os 12?
    JNZ     setup_move_sonda                ; se não, move a sonda
    CALL    reinicia_sonda
    JMP     exit_sonda

setup_move_sonda:
    SUB     R1, 1                           ; faz um movimento
    MOV     [R0], R1                        ; atualiza os movimentos da sonda
    MOV     R0, POS_SONDA                   ; endereço da posição da sonda
    MOV     R1, DEF_SONDA                   ; endereço do protótipo da sonda
    MOV     R2, MOV_SONDA                   ; endereço dos movimentos da sonda
    MOV     R3, ECRA_1                      ; ecrã da sonda (nº1)
    CALL    move_objeto                     ; move a sonda
    JMP     exit_sonda

cria_sonda:
    MOV     R2, LINHA_SONDA                 ; linha inicial da sonda
    MOV     R3, COLUNA_SONDA                ; coluna da sonda
    MOV     R6, COR_SONDA                   ; cor da sonda
    CALL    desenha_pixel                   ; desenha a sonda
    MOV     R3, ON                          ; sinal ON (1)
    MOV     [R0], R3                        ; atualiza a variável relativa à existẽncia da sonda

exit_sonda:
    POP     R6
    POP     R3
    POP     R2
    POP     R1
    POP     R0
    RET

; ****************************************************************************
; REINICIA_SONDA
; Descrição: Reinicia a sonda.
; Entradas:  -----------------
; Saídas:    -----------------
; ****************************************************************************

reinicia_sonda:
    PUSH    R0
    PUSH    R1

    MOV     R0, SONDA                       ; endereço da tabela relativa à sonda
    MOV     R1, OFF                         ; sinal OFF (0)                   
    MOV     [R0], R1                        ; atualiza a variável relativa à existẽncia da sonda
    ADD     R0, 2                           ; endereço da variável que guarda o nº de movimentos realizados
    MOV     R1, MOVIMENTOS                  ; reinicia os movimentos
    MOV     [R0], R1                        ; atualiza a variável relativa aos movimentos da sonda
    MOV     R0, POS_SONDA                   ; endereço das coordenadas da sonda
    MOV     R1, LINHA_SONDA                 ; linha da sonda inicial
    MOV     [R0], R1                        ; reseta a linha da sonda

    POP     R1
    POP     R0
    RET

; ****************************************************************************
; ASTEROIDE
; Descrição: Move o asteróide.
; Entradas:  -----------------
; Saídas:    -----------------
; ****************************************************************************

asteroide:
    PUSH    R0
    PUSH    R1
    PUSH    R2
    PUSH    R3

move_asteroide:
    MOV     R1, SOM_ASTEROIDE_DESCE         ; endereço da música de fundo
    MOV     [DEFINE_SOM_OU_VIDEO], R1       ; seleciona a música de start
    MOV     [INICIA_REPRODUCAO], R1         ; reproduz o som de start

    MOV     R0, POS_ASTEROIDE               ; endereço das coordenadas do asteróide
    MOV     R1, DEF_ASTEROIDE               ; endereço do protótipo do asteróide
    MOV     R2, MOV_ASTEROIDE               ; endereço dos movimentos do asteróide
    MOV     R3, ECRA_2                      ; ecrã do asteróide (nº2)
    CALL    move_objeto                     ; move o asteróide
    JMP     exit_asteroide

exit_asteroide:
    POP     R3
    POP     R2
    POP     R1
    POP     R0
    RET

; ****************************************************************************
; REINICIA_ASTEROIDE
; Descrição: Reinicia o asteróide.
; Entradas:  ---------------------
; Saídas:    ---------------------
; ****************************************************************************

reinicia_asteroide:
    PUSH    R0
    PUSH    R1

    MOV     R0, POS_ASTEROIDE               ; coordenadas do asteróide
    MOV     R1, LINHA_ASTEROIDE             ; linha inicial do asteróide
    MOV     [R0], R1                        ; reinicia a linha
    MOV     R1, COLUNA_ASTEROIDE            ; coluna inicial do asteróide
    MOV     [R0+COLUNA], R1                 ; reinicia a coluna

    POP     R1
    POP     R0
    RET

; ****************************************************************************
; ENERGIA
; Descrição: Devolve a energia atual da nave.
; Entradas:  --------------------------------
; Saídas:    R1 - Energia da nave
; ****************************************************************************

energia:
    MOV     R1, ENERGIA                     ; endereço da variável que guarda a energia do display
    MOV     R1, [R1]                        ; guarda o valor da energia
    RET

; ****************************************************************************
; GAME_OVER
; Descrição: Termina o jogo.
; Entradas:  ---------------
; Saídas:    ---------------
; ****************************************************************************

game_over_energia:
    MOV    R0, CENARIO_SEM_ENERGIA          ; cenário de fundo com a mensagem de sem energia
    MOV    [DEFINE_CENARIO], R0             ; seleciona o cenário

    CALL   game_over                        ; termina o jogo

game_over:
    PUSH    R0
    PUSH    R3

    MOV     R0, SONDA                       ; endereço da tabela relativa à sonda
    ADD     R0, 2                           ; endereço da variável que guarda o nº de movimentos realizados
    CALL    reinicia_sonda                  ; reinicia a sonda
    CALL    reinicia_asteroide              ; reinicia o asteróide
    MOV     [APAGA_ECRAS], R0	            ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)

    MOV     R0, SOM_GAMEOVER                ; endereço do som de game over
    MOV     [DEFINE_SOM_OU_VIDEO], R0       ; seleciona o som de fim de jogo
    MOV     [INICIA_REPRODUCAO], R0         ; reproduz o som

game_over_ciclo:
    MOV     R0, TECLA_START                 ; tecla para reiniciar o jogo
    CALL    teclado                         ; lê o teclado
    CMP     R3, R0                          ; a tecla lida é o "C"?
    JNZ     game_over_ciclo                 ; se não, continua à espera
    
    POP     R3
    POP     R0
    RET



; ****************************************************************************
; INTERRUPÇÕES
; ****************************************************************************

; ****************************************************************************
; INT_0
; Descrição: Trata a interrupção do temporizador 0.
; Entradas:  ---------------
; Saídas:    ---------------
; ****************************************************************************

rot_int_0:
    CALL     muda_painel                    ; muda o painel
    RFE                                     ; retorna da interrupção


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