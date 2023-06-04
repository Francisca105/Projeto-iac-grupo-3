; ****************************************************************************
; * IST-UL, IAC, 2022/2023                                                   *
; * Projeto Beyond Mars - Versão final - 09/06/2023                          *
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

; Endereços
COMANDOS				    EQU	6000H       ; endereço de base dos comandos do MediaCenter
DISPLAYS                    EQU 0A000H      ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN                     EQU 0C000H      ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL                     EQU 0E000H      ; endereço das colunas do teclado (periférico PIN)

; Comandos de escrita do Media Center
APAGA_ECRA                  EQU COMANDOS    ; comando que apaga todos os pixéis de um ecrã específico
APAGA_ECRAS                 EQU 6002H       ; comando que apaga todos os pixéis de todos os ecrãs
SELECIONA_ECRA              EQU 6004H       ; comando que seleciona o ecrã a ser utilizado
MOSTRA_ECRA                 EQU 6006H       ; comando que mostra o ecrã especificado
ESCONDE_ECRA                EQU 6008H       ; comando que esconde o ecrã especificado
DEFINE_LINHA                EQU 600AH       ; comando que define a linha
DEFINE_COLUNA               EQU 600CH       ; comando que define a coluna
ALTERA_COR_PIXEL_C          EQU 6012H       ; comando que altera a cor do pixel corrente
APAGA_AVISO                 EQU 6040H       ; comando que apaga o cenário de fundo e elimina aviso
DEFINE_CENARIO              EQU 6042H       ; comando que define o cenário
DEFINE_FRONTAL              EQU 6046H       ; comando que define o cenário
APAGA_FRONTAL               EQU 6044H       ; comando que define o cenário
DEFINE_SOM_OU_VIDEO         EQU 6048H       ; comando que define o som/vídeo
INICIA_REPRODUCAO           EQU 605AH       ; comando que inicia a reprodução do som/vídeo
REPRODUZ_EM_CICLO           EQU 605CH       ; comando que reproduz um som/vídeo em ciclo
TERMINA_SOM_OU_VIDEO        EQU 6066H       ; comando que termina a reprodução do som/vídeo
TERMINA_SONS_OU_VIDEOS      EQU 6068H       ; comando que termina a reprodução de todos os sons/vídeos
PAUSA_SOM_OU_VIDEO          EQU 605EH       ; comando que pausa a reprodução do som/vídeo
CONTINUA_SOM_OU_VIDEO       EQU 6060H       ; comando que continua a reprodução do som/vídeo

; Media
CENARIO_MENU                EQU 0           ; número do cenário do fundo do menu
CENARIO_JOGO                EQU 1           ; número do cenário do fundo do jogo
CENARIO_TERMINADO           EQU 2           ; número do cenário do fundo de quando se termina o jogo
CENARIO_SEM_ENERGIA         EQU 3           ; número do cenário do fundo de quando se fica sem energia
CENARIO_PAUSA               EQU 4           ; número do cenário frontal de quando se pausa o jogo

SOM_TEMA                    EQU 0           ; número da música de fundo
SOM_START                   EQU 1           ; número do som quando se começa o jogo
SOM_LASER                   EQU 2           ; número do som quando se dispara a sonda
SOM_GAMEOVER                EQU 3           ; número do som quando se perde o jogo
SOM_ASTEROIDE_DESCE         EQU 4           ; número do som quando o asteróide desce
SOM_TEMA_PAUSA              EQU 5           ; número da música de fundo quando se pausa o jogo
SOM_TEMA_JOGO               EQU 6           ; número da música de fundo que toca ao longo do jogo

; Cores
COR_SONDA                   EQU 0FF00H
CINZA_CLARO                 EQU 0FCCCH
CINZA_MEDIO                 EQU 0F999H
CINZA_ESCURO                EQU 0F555H
VERMELHO                    EQU 0FF22H
AZUL                        EQU 0F0CFH
VERDE                       EQU 0FBF2H
AMARELO                     EQU 0FFE0H
CASTANHO                    EQU 0FA64H

; Ecrã
N_LINHAS                    EQU 32          ; número de linhas do ecrã (altura)
N_COLUNAS                   EQU 64          ; número de colunas do ecrã (largura)

; Ecrãs
ECRA_0                      EQU 0
ECRA_1                      EQU 1
ECRA_2                      EQU 2
ECRA_3                      EQU 3
ECRA_4                      EQU 4
ECRA_5                      EQU 5
ECRA_6                      EQU 6
ECRA_7                      EQU 7
ECRA_8                      EQU 8
ECRA_9                      EQU 9
ECRA_10                     EQU 10
ECRA_11                     EQU 11
ECRA_12                     EQU 12
ECRA_13                     EQU 13
ECRA_14                     EQU 14
ECRA_15                     EQU 15

; Teclado
LINHA_TECLADO               EQU 8           ; última linha (4ª linha, 1000b)
MASCARA_TECLADO             EQU 0FH         ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

; Teclas
TECLA_ESQUERDA			    EQU 0H          ; tecla 0
TECLA_MEIO  		        EQU 1H	        ; tecla 1
TECLA_DIREITA 			    EQU 2H		    ; tecla 2
TECLA_START                 EQU 0CH         ; tecla C
TECLA_PAUSAR			    EQU 0DH		    ; tecla D
TECLA_TERMINAR			    EQU 0EH		    ; tecla E
TECLA_F                     EQU 0FH         ; tecla F

; Nave
LINHA_NAVE                  EQU 27          ; linha onde a nave começa
COLUNA_NAVE                 EQU 25          ; coluna onde a nave começa
LARGURA_15                  EQU 15          ; largura da nave
ALTURA_5                    EQU 5           ; altura da nave

; Painel
LINHA_PAINEL                EQU 29          ; linha onde o painel começa
COLUNA_PAINEL               EQU 29          ; coluna onde o painel começa
LARGURA_7                   EQU 7           ; largura do painel
ALTURA_2                    EQU 2           ; altura do painel

; Asteróide
LINHA_ASTEROIDE             EQU 0           ; linha onde o asteróide começa
COLUNA_ASTEROIDE            EQU 0           ; coluna onde o asteróide começa
LARGURA_5                   EQU 5           ; largura do asteróide
HORIZONTAL_1                EQU 1           ; movimento horizontal do asteróide
VERTICAL_1                  EQU 1           ; movimento vertical do asteróide

; Sonda
LARGURA_1                   EQU 1           ; largura da sonda
ALTURA_1                    EQU 1           ; altura da sonda
MOVIMENTOS                  EQU 12          ; número máximo de movimentos da sonda
OFF                         EQU 0           ; sinaliza a sonda desligada
ON                          EQU 1           ; sinaliza a sonda ligada
VERTICAL_MOV                EQU -1          ; movimento vertical da sonda

ECRA_SONDA_ESQ              EQU 1           ; ecrã onde a sonda que é lançada do lado esquerdo vai ser desenhada
ECRA_SONDA_MEIO             EQU 2           ; ecrã onde a sonda que é lançada do meio vai ser desenhada
ECRA_SONDA_DIR              EQU 3           ; ecrã onde a sonda que é lançada do lado direito vai ser desenhada

LINHA_SONDA_MEIO            EQU 26          ; linha onde a sonda que é lançada do meio começa
COLUNA_SONDA_MEIO           EQU 26          ; coluna onde a sonda que é lançada do meio começa
HORIZONTAL_MEIO             EQU 0           ; movimento horizontal da sonda que é lançada do meio 

LINHA_SONDA_ESQ             EQU 26          ; linha onde a sonda que é lançada da esquerda começa
COLUNA_SONDA_ESQ            EQU 37          ; coluna onde a sonda que é lançada da esquerda começa
HORIZONTAL_ESQ              EQU -1          ; movimento horizontal da sonda que é lançada da esquerda

LINHA_SONDA_DIR             EQU 26          ; linha onde a sonda que é lançada da direita começa
COLUNA_SONDA_DIR            EQU 32          ; coluna onde a sonda que é lançada da direita começa
HORIZONTAL_DIR              EQU -1          ; movimento horizontal da sonda que é lançada da direita

; Offsets
OFF_COLUNA                  EQU 2           ; offset para obter a coluna de um objeto a partir do seu endereço
OFF_ALTURA                  EQU 2           ; offset para obter a altura de um objeto a partir do seu endereço
OFF_PIXEL                   EQU 4           ; offset para obter o pixel de um objeto a partir do seu endereço
OFF_HORIZONTAL              EQU 2           ; offset para obter o movimento horizontal de um objeto

; Jogo
ENERGIA_INI                 EQU 64H         ; quantidade de enrgia inicial


; ****************************************************************************
; Stack Pointers
; ****************************************************************************

PLACE       1000H
; SP inicial do programa
STACK       100H                            ; espaço reservado para a pilho do programa principal
SP_inicial:                                 ; valor inicial para o SP do programa principal

STACK       100H                            ; espaço reservado para a pilha do processo controlos
SP_controlos:                               ; valor inicial para o SP do processo controlos

STACK       100H	                        ; espaço reservado para a pilha do processo teclado
SP_teclado:				                    ; valor inicial para o SP do processo teclado

STACK       100H                            ; espaço reservado para a pilha do processo energia
SP_energia:                                 ; valor incial para o SP do processo energia

STACK       100H                            ; espaço reservado para a pilha do processo nave
SP_nave:                                    ; valor inicial para o SP do processo nave

STACK       100H                            ; espaço reservado para a pilha do processo sonda 
SP_sondas:                                   ; valor inicial para o SP do processo sonda

; ****************************************************************************
; Variáveis
; ****************************************************************************

PAINEL:                                     ; painel de instrumentos atual
    WORD    1H

PAINEIS:                                    ; tabela dos diferentes painéis de instrumentos
    WORD    DEF_PAINEL_1
    WORD    DEF_PAINEL_2
    WORD    DEF_PAINEL_3
    WORD    DEF_PAINEL_4
    WORD    DEF_PAINEL_5
    WORD    DEF_PAINEL_6
    WORD    DEF_PAINEL_7
    WORD    DEF_PAINEL_8

DEF_PAINEL_1:                               ; definição do painel de instrumentos nº1
    WORD    LARGURA_7
    WORD    ALTURA_2
    WORD    VERMELHO, VERDE, CINZA_MEDIO, CINZA_MEDIO, AZUL, VERDE, CINZA_MEDIO
    WORD    AMARELO, AZUL, VERDE, VERMELHO, CINZA_MEDIO, VERMELHO, AZUL

DEF_PAINEL_2:                               ; definição do painel de instrumentos nº2
    WORD    LARGURA_7
    WORD    ALTURA_2
    WORD    VERMELHO, VERDE, AMARELO, VERDE, VERMELHO, CINZA_MEDIO, VERMELHO
    WORD    CINZA_MEDIO, CINZA_MEDIO, VERDE, VERMELHO, AZUL, CINZA_MEDIO, AMARELO

DEF_PAINEL_3:                               ; definição do painel de instrumentos nº3
    WORD    LARGURA_7
    WORD    ALTURA_2
    WORD    CINZA_MEDIO, AZUL, AMARELO, CINZA_MEDIO, VERMELHO, VERDE, VERMELHO
    WORD    AMARELO, VERDE, CINZA_MEDIO, VERMELHO, CINZA_MEDIO, AMARELO, AZUL

DEF_PAINEL_4:                               ; definição do painel de instrumentos nº4
    WORD    LARGURA_7
    WORD    ALTURA_2
    WORD    VERMELHO, CINZA_MEDIO, CINZA_MEDIO, VERMELHO, AZUL, VERDE, VERMELHO
    WORD    AZUL, VERMELHO, VERDE, AMARELO, CINZA_MEDIO, AMARELO, CINZA_MEDIO

DEF_PAINEL_5:                               ; definição do painel de instrumentos nº5
    WORD    LARGURA_7
    WORD    ALTURA_2
    WORD    VERDE, AMARELO, AMARELO, VERMELHO, AZUL, CINZA_MEDIO, VERDE
    WORD    CINZA_MEDIO, AZUL, VERMELHO, VERDE, CINZA_MEDIO, AMARELO, CINZA_MEDIO

DEF_PAINEL_6:                               ; definição do painel de instrumentos nº6
    WORD    LARGURA_7
    WORD    ALTURA_2
    WORD    CINZA_MEDIO, VERMELHO, VERDE, CINZA_MEDIO, AZUL, VERDE, AMARELO
    WORD    AMARELO, AZUL, VERMELHO, CINZA_MEDIO, VERMELHO, CINZA_MEDIO, CINZA_MEDIO

DEF_PAINEL_7:                               ; definição do painel de instrumentos nº7
    WORD    LARGURA_7
    WORD    ALTURA_2
    WORD    CINZA_MEDIO, VERMELHO, VERDE, CINZA_MEDIO, VERMELHO, VERDE, AMARELO
    WORD    AMARELO, CINZA_MEDIO, VERMELHO, AMARELO, CINZA_MEDIO, CINZA_MEDIO, VERMELHO

DEF_PAINEL_8:                               ; definição do painel de instrumentos nº8
    WORD    LARGURA_7
    WORD    ALTURA_2
    WORD    AZUL, VERMELHO, VERDE, CINZA_MEDIO, VERMELHO, VERDE, CINZA_MEDIO
    WORD    CINZA_MEDIO, CINZA_MEDIO, AZUL, AZUL, VERDE, CINZA_MEDIO, VERMELHO

ENERGIA:                                    ; energia atual da nave
    WORD    ENERGIA_INI

POS_NAVE:                                   ; posição da nave
    WORD    LINHA_NAVE
    WORD    COLUNA_NAVE

DEF_NAVE:                                   ; definição da nave
    WORD    LARGURA_15
    WORD    ALTURA_5
    WORD    0, 0, CINZA_ESCURO, CINZA_ESCURO, CINZA_ESCURO, CINZA_ESCURO, CINZA_ESCURO, CINZA_ESCURO, CINZA_ESCURO, CINZA_ESCURO, CINZA_ESCURO, CINZA_ESCURO, CINZA_ESCURO, 0, 0
    WORD    0, CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO, 0
    WORD    CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO
    WORD    CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO
    WORD    CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO

POS_PAINEL:                                 ; posição do painel de instrumentos
    WORD    LINHA_PAINEL
    WORD    COLUNA_PAINEL

DEF_PAINEL:                                 ; definição do painel de instrumentos
    WORD    LARGURA_7
    WORD    ALTURA_2
    WORD    VERMELHO, VERDE, CINZA_MEDIO, CINZA_MEDIO, AZUL, VERDE, CINZA_MEDIO
    WORD    AMARELO, AZUL, VERDE, VERMELHO, CINZA_MEDIO, VERMELHO, AZUL

POS_ASTEROIDE:                              ; posição do asteróide
    WORD    LINHA_ASTEROIDE
    WORD    COLUNA_ASTEROIDE

DEF_ASTEROIDE:                              ; definição do asteróide
    WORD    LARGURA_5
    WORD    ALTURA_5
    WORD    0, 0, CASTANHO, 0, 0
    WORD    0, CASTANHO, CASTANHO, CASTANHO, 0
    WORD    CASTANHO, CASTANHO, CASTANHO, CASTANHO, CASTANHO
    WORD    0, CASTANHO, CASTANHO, CASTANHO, 0
    WORD    0, 0, CASTANHO, 0 ,0

MOV_ASTEROIDE:                              ; movimentos do asteróide
    WORD    HORIZONTAL_1
    WORD    VERTICAL_1

SONDAS:
    WORD    OFF, MOVIMENTOS                 ; sonda esquerda (ON/OFF), movimentos restantes
    WORD    OFF, MOVIMENTOS                 ; sonda do meio (ON/OFF), movimentos restantes
    WORD    OFF, MOVIMENTOS                 ; sonda direita (ON/OFF), movimentos restantes

POS_SONDAS:
    WORD    0, 0                            ; posição da sonda esquerda (linha, coluna) 
    WORD    0, 0                            ; posição da sonda do meio (linha, coluna)
    WORD    0, 0                            ; posição da sonda direita (linha, coluna)

MOV_SONDA:
    WORD    HORIZONTAL_ESQ, VERTICAL_MOV    ; movimento horizontal da sonda esquerda
    WORD    HORIZONTAL_MEIO, VERTICAL_MOV   ; movimento horizontal da sonda do meio
    WORD    HORIZONTAL_DIR, VERTICAL_MOV    ; movimento horizontal da sonda direita

DEF_SONDA:
    WORD    LARGURA_1                       ; largura da sonda
    WORD    ALTURA_1                        ; altura da sonda
    WORD    COR_SONDA                       ; cor da sonda

PAUSA:                                      ; estado atual do jogo (0 = despausado, 1 = pausado)
    WORD    0

ALEATORIO:                                  ; valor aleatório gerado pelos bits 4-7 do periférico PIN
    WORD    0

TECLA_CARREGADA:                            ; última tecla carregada
    LOCK    0

REINICIA_JOGO:                              ; LOCK para reiniciar o jogo
    LOCK    0

tab_int:                                    ; tabela das rotinas de interrupção
    WORD    0
    WORD    sonda_int
    WORD    energia_int
    WORD    nave_int

evento_int:                                 ; tabela das ocorrências de interrupções
    LOCK    0
    LOCK    0
    LOCK    0
    LOCK    0


; ****************************************************************************
; * CODIGO 
; ****************************************************************************
PLACE       0

inicio:
    MOV     SP, SP_inicial                  ; inicializa a stack principal

    MOV     BTE, tab_int			        ; inicializa BTE (registo de Base da Tabela de Exceopções)

    CALL    processo_teclado                ; inicia o processo teclado

    MOV     [APAGA_AVISO], R0				; apaga o aviso de nenhum cenário selecionado
    MOV     [APAGA_ECRAS], R0				; apaga todos os pixels
    MOV     [APAGA_FRONTAL], R0				; apaga o ecrã frontal
	MOV	    R0, CENARIO_MENU				; cenário do menu
    MOV     [DEFINE_CENARIO], R0            ; seleciona o cenário de fundo

    MOV     R1, SOM_TEMA                    ; endereço da música de fundo
    MOV     [DEFINE_SOM_OU_VIDEO], R1       ; seleciona a música de fundo
    MOV     [REPRODUZ_EM_CICLO], R1         ; começa a música de fundo

    MOV     R0, ENERGIA                     ; endereço da variável que guarda a energia do display
    MOV     R1, 0                           
    MOV     [R0], R1                        ; inicia a energia com o valor 0
    CALL    display                         ; mostra o nível de energia na nave

;    EI0                                     ; permite a interrupção 0
    EI1                                     ; permite a interrupção 1
    EI2                                     ; permite a interrupção 2
    EI3                                     ; permite a interrupção 3
    EI                                      ; permite interrupções (geral)

menu:
    MOV     R0, [TECLA_CARREGADA]           ; lê uma tecla
    MOV     R1, TECLA_START                 ; tecla de start (C)
    CMP     R0, R1                          ; a tecla lida é o "C"?
    JNZ     menu                            ; se não, continua à espera

    CALL    processo_energia                ; inicia o processo energia
    CALL    processo_nave                   ; inicia o processo nave
    CALL    processo_controlos              ; incia o processo controlos

start:
    MOV     R8, PAUSA                       ; endereço do estado atual do jogo
    MOV     R11, 0                          ; 0 simboliza jogo não pausado
    MOV     [R8], R11                       ; tira o jogo da pausa

    MOV     R0, ENERGIA                     ; endereço da variável que guarda a energia do display
    MOV     R1, ENERGIA_INI                 ; número de energia inicial
    MOV     [R0], R1                        ; inicia a energia com o valor 100H
    CALL    display                         ; mostra o nível de energia na nave

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

    MOV     R1, SOM_TEMA_JOGO               ; endereço da música de start
    MOV     [DEFINE_SOM_OU_VIDEO], R1       ; seleciona a música de start
    MOV     [REPRODUZ_EM_CICLO], R1         ; reproduz o som de start

    MOV     R0, POS_NAVE                    ; coordenadas da nave
    MOV     R1, DEF_NAVE                    ; protótipo da nave
    CALL    desenha_objeto                  ; desenha a nave

main:
    YIELD
    MOV     R1, [REINICIA_JOGO]             ; espera até poder reiniciar o jogo (o valor do registo é irrelevante)
    JMP     start                           ; reinicia o jogo


    JMP     main



; **********
; PROCESSOS
; **********

; ****************************************************************************
; Processo Controlos
; Descrição: Trata de pausar, tirar da pausa e terminar o jogo.
; ****************************************************************************

PROCESS SP_controlos

processo_controlos:
    MOV     R0, [TECLA_CARREGADA]           ; lẽ uma tecla

    MOV     R1, TECLA_TERMINAR              ; tecla para terminar o jogo (E)
    CMP     R0, R1                          ; a tecla lida é o "E"?
    JZ      termina_jogo                    ; se sim, termina o jogo

    MOV     R1, TECLA_PAUSAR                ; tecla para pausar o jogo (D)
    CMP     R0, R1                          ; a tecla lida é o "D"?
    JZ      pausa                           ; se sim, pausa o jogo

    MOV     R1, TECLA_ESQUERDA              ; tecla para lançar sonda esquerda (0)
    CMP     R0, R1                          ; a tecla lida é o "0"?
    JZ      sonda_esquerda                  ; se sim, continua.

    JMP     processo_controlos              ; se não for nenhuma das teclas anteriores, repete o ciclo

termina_jogo:
    CALL    game_over_terminado             ; termina o jogo
    JMP     processo_controlos              ; repete o ciclo

pausa:
    MOV     R8, PAUSA                       ; endereço do estado atual do jogo
    MOV     R9, [R8]                        ; estado atual do jogo

    CMP     R9, 1                           ; o jogo está em pausa? (=1)
    JNZ     mete_pausa                      ; se não, mete em pausa
    JMP     tira_pausa                      ; se sim, tira da pausa

tira_pausa:
    MOV     [APAGA_FRONTAL], R11            ; apaga o painel de pausa

    MOV     R11, SOM_TEMA_PAUSA             ; endereço da música de fundo
    MOV     [DEFINE_SOM_OU_VIDEO], R11      ; seleciona a música de fundo
    MOV     [TERMINA_SOM_OU_VIDEO], R11     ; começa a música de fundo

    MOV     R1, SOM_TEMA_JOGO               ; endereço da música de fundo
    MOV     [DEFINE_SOM_OU_VIDEO], R1       ; seleciona a música de fundo
    MOV     [CONTINUA_SOM_OU_VIDEO], R1     ; continua a música de fundo

    MOV     R11, 0                          ; 0 simboliza joga não pausado
    MOV     [R8], R11                       ; tira o jogo da pausa

    JMP     processo_controlos              ; volta ao início do ciclo

mete_pausa:
    MOV     R11, CENARIO_PAUSA              ; cenário da pausa
    MOV     [DEFINE_FRONTAL], R11           ; coloca o cenário à frente de tudo

    MOV     R1, SOM_TEMA_JOGO               ; endereço da música de fundo
    MOV     [DEFINE_SOM_OU_VIDEO], R1       ; seleciona a música de fundo
    MOV     [PAUSA_SOM_OU_VIDEO], R1        ; pausa a música de fundo

    MOV     R11, SOM_TEMA_PAUSA             ; endereço da música de fundo
    MOV     [DEFINE_SOM_OU_VIDEO], R11      ; seleciona a música de fundo
    MOV     [REPRODUZ_EM_CICLO], R11        ; começa a música de fundo

    MOV     R11, 1                          ; 1 simboliza jogo pausado
    MOV     [R8], R11                       ; mete o jogo em pausa

espera_pausa:                               ; neste ciclo, espera-se até se tirar da pausa
    MOV     R0, [TECLA_CARREGADA]           ; lẽ uma tecla

    MOV     R1, TECLA_PAUSAR                ; tecla para pausar o jogo (D)
    CMP     R0, R1                          ; a tecla lida é o "D"?
    JZ      pausa                           ; se sim, tira o jogo da pausa

    JMP     espera_pausa                    ; se não, espera pela tecla de pausa


; ****************************************************************************
; GAME_OVER
; Descrição: Termina o jogo.
; Entradas:  ---------------
; Saídas:    ---------------
; ****************************************************************************

game_over_terminado:
    PUSH    R1

    MOV     R1, CENARIO_TERMINADO           ; cenário de fundo com a mensagem de fim de jogo
    MOV     [DEFINE_CENARIO], R1            ; seleciona o cenário

    CALL    game_over                       ; termina o jogo

    POP     R1
    RET

game_over_energia:
    PUSH    R0

    MOV     R0, CENARIO_SEM_ENERGIA         ; cenário de fundo com a mensagem de sem energia
    MOV     [DEFINE_CENARIO], R0            ; seleciona o cenário

    CALL    game_over                       ; game over

    POP     R0
    RET

game_over:                                  ; termina o jogo
    PUSH    R0
    PUSH    R3
    PUSH    R8
    PUSH    R11

    MOV     R8, PAUSA                       ; endereço do estado atual do jogo
    MOV     R11, 1                          ; 1 simboliza jogo pausado
    MOV     [R8], R11                       ; pausa o jogo

    MOV     R1, SOM_TEMA_JOGO               ; endereço da música de fundo
    MOV     [DEFINE_SOM_OU_VIDEO], R1       ; seleciona a música de fundo
    MOV     [TERMINA_SOM_OU_VIDEO], R1      ; termina a música de fundo

    ;MOV     R0, SONDA                       ; endereço da tabela relativa à sonda
    ;ADD     R0, 2                           ; endereço da variável que guarda o nº de movimentos realizados
    ;CALL    reinicia_sonda                  ; reinicia a sonda
    ;CALL    reinicia_asteroide              ; reinicia o asteróide
    MOV     [APAGA_ECRAS], R0	            ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)

    MOV     R0, SOM_GAMEOVER                ; endereço do som de game over
    MOV     [DEFINE_SOM_OU_VIDEO], R0       ; seleciona o som de fim de jogo
    MOV     [INICIA_REPRODUCAO], R0         ; reproduz o som

game_over_ciclo:
    MOV     R3, [TECLA_CARREGADA]           ; lê uma tecla
    MOV     R0, TECLA_START                 ; tecla para iniciar o jogo (C)
    CMP     R3, R0                          ; a tecla lida é o "C"?
    JNZ     game_over_ciclo                 ; se não, continua à espera

    MOV     [REINICIA_JOGO], R0             ; desbloqueia o processo principal para poder reiniciar o jogo
                                            ; o valor do registo é irrelevante
    POP     R11
    POP     R8
    POP     R3
    POP     R0
    RET



PROCESS     SP_sondas

; R10 - SONDAS (respetiva sonda)
; R0 - POS SONDA
; R1 - OBJETO
; R2 - MOV
; R3 - ECRÃ

sonda_esquerda:
    MOV     R3, ECRA_SONDA_ESQ

    MOV     R4, SONDAS
    MOV     R1, DEF_SONDA
    MOV     R2, MOV_SONDA
    MOV     R0, POS_SONDAS

    MOV     R6, LINHA_SONDA_ESQ
    MOV     R7, COLUNA_SONDA_ESQ

    MOV     R11, [R4]

    CMP     R11, 0
    JZ      cria_sonda                      ; cria uma sonda caso já não exista
    JMP     fim_sonda

cria_sonda:
    MOV     R11, SOM_LASER                  ; endereço do som do laser
    MOV     [DEFINE_SOM_OU_VIDEO], R11      ; seleciona o som
    MOV     [INICIA_REPRODUCAO], R11        ; reproduz o som

    PUSH    R2
    PUSH    R3
    PUSH    R6

    MOV     R2, [R0]
    MOV     R3, [R0+2]
    MOV     R6, COR_SONDA

    CALL    desenha_pixel

    POP     R6
    POP     R3
    POP     R2

    MOV     R11, ON
    MOV     [R4], R11

move_sonda:
    MOV     R11, evento_int                  ; tabela das ocorrências das interrupções
    MOV     R11, [R11+2]                      ; ocorrência da interrupção 1

    MOV     [APAGA_ECRA], R0
    MOV     R11, R0
    ADD     R11, 2
    MOV     R11, [R11]
    CMP     R11, 0                          ; já fez os 12 movimentos?
    JNZ     setup_move_sonda                ; se não, move a sonda
    JMP     reinicia_sonda


setup_move_sonda:
    MOV     R11, R4
    ADD     R11, 2
    MOV     R11, [R11]

    SUB     R11, 1                          ; tira um movimento

    MOV     R8, evento_int                  ; tabela das ocorrências das interrupções
    MOV     R9, [R8+2]                      ; ocorrência da interrupção 1

    CALL    move_objeto
    JMP     move_sonda

reinicia_sonda:
    MOV     R5, OFF                         ; passa o valor da sonda a off
    MOV     [R4], R5                        ; atualiza esse valor

    MOV     R11, MOVIMENTOS

    MOV     [R4+2], R11                     ; reinicia o numero de movimentos
    MOV     [R0],  R6                       ; linha da sonda inicial
    MOV     [R0+2],  R7                     ; coluna da sonda inicial

fim_sonda:
    JMP     fim_sonda



; ****************************************************************************
; Processo Teclado
; Descrição: Lê a tecla premida, se houver, e espera que ela deixe
;            de ser premida, guardando-a em memória.
; ****************************************************************************

PROCESS SP_teclado

processo_teclado:
	MOV     R2, TEC_LIN                     ; endereço do periférico das linhas
    MOV     R3, TEC_COL                     ; endereço do periférico das colunas
    MOV     R5, MASCARA_TECLADO             ; isola os 4 bits de menor peso ao ler as colunas do teclado
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
	MOV		[ALEATORIO], R4					; guarda o valor "aleatoriamente" gerado
    AND     R0, R5                          ; elimina bits para além dos bits 0-3
    CMP     R0, 0                           ; há tecla premida?
    JNZ     ha_tecla                        ; se ainda houver uma tecla premida, espera até não haver
	JMP		espera_tecla					; repete o ciclo



; ****************************************************************************
; Processo Energia
; Descrição: Decrementa a energia da nave em 3% a cada 3 segundos.
; ****************************************************************************

PROCESS SP_energia

processo_energia:
    MOV     R1, evento_int                  ; tabela das ocorrências das interrupções
    MOV     R2, [R1+4]                      ; ocorrência da interrupção 2
    MOV     R5, PAUSA                       ; endereço do estado atual do jogo
    MOV     R5, [R5]                        ; estado atual do jogo
    CMP     R5, 1                           ; o jogo está pausado?
    JZ      processo_energia                ; se sim, repete o ciclo
    MOV     R2, -3                          ; o decremento é de 3%
    CALL    altera_energia                  ; altera a energia da nave
    JMP     processo_energia                ; repete o ciclo


; ****************************************************************************
; ALTERA_ENERGIA
; Descrição: Incrementa/decrementa o nível de energia do display.
; Entradas:  R2 - Nível de energia a incrementar/decrementar (negativo para decrementar)
; Saídas:    -------------------
; ****************************************************************************

altera_energia:
    PUSH    R0
    PUSH    R1
    PUSH    R2

    MOV     R0, ENERGIA                     ; endereço da energia atual do display 
    MOV     R1, [R0]                        ; energia atual do display
    ADD     R1, R2                          ; acrescenta o valor pretendido à energia atual

    CMP     R1, 0                           ; a energia atual é menor que zero?
    JLE     energia_zero                    ; se sim, atualiza a energia para zero

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

    CALL    game_over_energia               ; termina o jogo

    POP     R2
    POP     R1
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
    CMP     R1, R3                          ; se o fator já é menor que 10, já está concluído
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
; Processo nave
; Descrição: Muda o painel de instrumentos a cada 0.3 segundos.
; ****************************************************************************

PROCESS SP_nave

processo_nave:
    MOV     R1, evento_int                  ; tabela das ocorrências de interrupções
    MOV     R2, [R1+6]                      ; ocorrência da interrupção 3
    MOV     R5, PAUSA                       ; endereço estado atual do jogo
    MOV     R5, [R5]                        ; estado atual do jogo
    CMP     R5, 1                           ; o jogo está pausado?
    JZ      processo_nave                   ; se sim, repete o ciclo
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
    JMP     processo_nave                   ; repete o ciclo



; ****************************************************************************
; INTERRUPÇÕES
; ****************************************************************************

; ****************************************************************************
; energia_int
; Descrição: Trata a interrupção do temporizador 2.
;            Num ciclo de 3 em 3 segundos baixa a energia em 3%.
; ****************************************************************************

energia_int:
	PUSH R0
	MOV  R0, evento_int			            ; tabela das ocorrências de interrupções
                                            ; desbloqueia processo energia (qualquer registo serve)
	MOV  [R0+4], R1		                    ; na componente 2 da variável evento_int
						                    ; Usa-se 4 porque cada word tem 2 bytes
	POP  R0
	RFE

; ****************************************************************************
; nave_int
; Descrição: Trata a interrupção do temporizador 3.
;            Muda as cores do painel.
; ****************************************************************************

nave_int:
	PUSH R0
	MOV  R0, evento_int                     ; tabela das ocorrências de interrupções
                                            ; desbloqueia processo nave (qualquer registo serve)
	MOV  [R0+6], R1		                    ; na componente 3 da variável evento_int
						                    ; Usa-se 6 porque cada word tem 2 bytes
	POP  R0
	RFE

; ****************************************************************************
; sonda_int
; Descrição: Trata a interrupção do temporizador 1.
;            Muda as cores do painel.
; ****************************************************************************

sonda_int:
	PUSH R0
	MOV  R0, evento_int                     ; tabela das ocorrências de interrupções
                                            ; desbloqueia processo (qualquer registo serve)
	MOV  [R0+2], R1		                    ; na componente 3 da variável evento_int
						                    ; Usa-se 2 porque cada word tem 2 bytes
	POP  R0
	RFE

; ****************************************************************************
; ROTINAS AUXILIARES
; ****************************************************************************

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
    MOV     R3, [R0+OFF_COLUNA]             ; coluna do objeto
    MOV     R4, [R2+OFF_HORIZONTAL]         ; movimento horizontal do objeto
    ADD     R3, R4                          ; nova coluna do objeto
    MOV     [R0+OFF_HORIZONTAL], R3         ; atualiza a coluna do objeto
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
    MOV     [ALTERA_COR_PIXEL_C], R6        ; altera a cor do pixel na linha e coluna selecionadas
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
    MOV     R3, [R0+OFF_COLUNA]             ; coluna do objeto
    MOV     R4, [R1]                        ; largura do objeto
    MOV     R5, [R1+OFF_ALTURA]             ; altura do objeto
    ADD     R1, OFF_PIXEL                   ; endereço do 1º pixel do objeto
    MOV     R6, R1                          ; guarda esse endereço

    POP     R1
    RET

