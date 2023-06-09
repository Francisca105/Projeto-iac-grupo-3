; ****************************************************************************
; * IST-UL, IAC, 2022/2023                                                   *
; * Projeto Beyond Mars - Versão final - 09/06/2023                          *
; *                                                                          *
; * Realizado por:                                                           *
; * ist1105901 - Francisca Almeida                                           *
; * ist1106827 - Cecília Correia                                             *
; * ist1106943 - José Frazão                                                 *
; *                                                                          *
; * Descrição: Simula o jogo dos asteroides num computador de 16 bits.       *
; ****************************************************************************

; ****************************************************************************
; * Constantes
; ****************************************************************************

; Endereços
DISPLAYS                    EQU 0A000H      ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN                     EQU 0C000H      ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL                     EQU 0E000H      ; endereço das colunas do teclado (periférico PIN)

; Comandos de escrita do Media Center
APAGA_ECRA                  EQU 6000H       ; comando que apaga todos os pixéis de um ecrã específico
APAGA_ECRAS                 EQU 6002H       ; comando que apaga todos os pixéis de todos os ecrãs
SELECIONA_ECRA              EQU 6004H       ; comando que seleciona o ecrã a ser utilizado
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
PAUSA_SOM_OU_VIDEO          EQU 605EH       ; comando que pausa a reprodução do som/vídeo
CONTINUA_SOM_OU_VIDEO       EQU 6060H       ; comando que continua a reprodução do som/vídeo

; Media
CENARIO_MENU                EQU 0           ; nº do cenário do fundo do menu
CENARIO_JOGO                EQU 1           ; nº do cenário do fundo do jogo
CENARIO_TERMINADO           EQU 2           ; nº do cenário do fundo de quando se termina o jogo
CENARIO_SEM_ENERGIA         EQU 3           ; nº do cenário do fundo de quando se fica sem energia
CENARIO_COLISAO             EQU 5           ; nº do cenário do fundo de quando um asteroide colide com a nave
CENARIO_PAUSA               EQU 4           ; nº do cenário frontal de quando se pausa o jogo

SOM_TEMA                    EQU 0           ; nº da música de fundo
SOM_START                   EQU 1           ; nº do som quando se começa o jogo
SOM_LASER                   EQU 2           ; nº do som quando se dispara a sonda
SOM_GAMEOVER                EQU 3           ; nº do som quando se perde o jogo pelo teclado
SOM_GAMEOVER_ENERGIA        EQU 4           ; nº do som quando se perde o jogo por ficar sem energia
SOM_GAMEOVER_COLISAO        EQU 10          ; nº do som quando se perde o jogo por colisão
SOM_TEMA_PAUSA              EQU 5           ; nº da música de fundo quando se pausa o jogo
SOM_TEMA_JOGO               EQU 6           ; nº da música de fundo que toca ao longo do jogo
SOM_PAUSA_EFFECT            EQU 7           ; nº do som de efeito da pausa
SOM_ASTEROIDE_BOM           EQU 8           ; nº do som do efeito de colisao do asteroide bom
SOM_ASTEROIDE_MAU           EQU 9           ; nº do som do efeito de colisao do asteroide mau

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

; Ecrãs
ECRA_NAVE                   EQU 0
ECRA_SONDA_ESQ              EQU 1
ECRA_SONDA_MEIO             EQU 2
ECRA_SONDA_DIR              EQU 3
ECRA_ASTEROIDE_1            EQU 5
ECRA_ASTEROIDE_2            EQU 6
ECRA_ASTEROIDE_3            EQU 7
ECRA_ASTEROIDE_4            EQU 8

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

; Asteróides
LARGURA_5                   EQU 5           ; largura do asteroide
AST_MAU                     EQU 0           ; simboliza um asteroide mau
AST_BOM                     EQU 1           ; simboliza um asteroide bom
NUM_ASTEROIDES              EQU 4           ; nº máximo de asteroides concurrentes
LINHA_MAX                   EQU 32          ; linha fora do ecrã
NAO_COLISAO_NAVE            EQU 0           ; simboliza uma não colisão com a nave
COLISAO_NAVE                EQU 1           ; simboliza uma colisão com a nave
LINHA_COLISAO_NAVE          EQU 22          ; linha onde o asteroide colide com a nave
LINHA_MINIMO                EQU 6           ; linha mínima onde os asteroides podem aparecer da mesma lane
DEFAULT_LANE                EQU -1          ; lane default do asteroide

; Sonda
LARGURA_1                   EQU 1           ; largura da sonda
ALTURA_1                    EQU 1           ; altura da sonda
MOVIMENTOS                  EQU 12          ; nº máximo de movimentos da sonda
OFF                         EQU 0           ; sinaliza a sonda desligada
ON                          EQU 1           ; sinaliza a sonda ligada
LINHA_SONDA                 EQU 26          ; linha onde a sonda que começa
NUM_SONDAS                  EQU 3           ; nº máximo de sondas concurrentes

COLUNA_SONDA_MEIO           EQU 32          ; coluna onde a sonda que é lançada do meio começa
HORIZONTAL_MEIO             EQU 0           ; movimento horizontal da sonda que é lançada do meio 

COLUNA_SONDA_ESQ            EQU 26          ; coluna onde a sonda que é lançada da esquerda começa
HORIZONTAL_ESQ              EQU -1          ; movimento horizontal da sonda que é lançada da esquerda

COLUNA_SONDA_DIR            EQU 37          ; coluna onde a sonda que é lançada da direita começa
HORIZONTAL_DIR              EQU 1           ; movimento horizontal da sonda que é lançada da direita

; Offsets
OFF_COLUNA                  EQU 2           ; offset para obter a coluna de um objeto a partir do seu endereço
OFF_ALTURA                  EQU 2           ; offset para obter a altura de um objeto a partir do seu endereço
OFF_PIXEL                   EQU 4           ; offset para obter o pixel de um objeto a partir do seu endereço

; Jogo
ENERGIA_INI                 EQU 64H         ; quantidade de energia inicial
ENERGIA_BONUS               EQU 25          ; quantidade de energia ganha por destruir um asteroide minerável
ENERGIA_DECREMENTADA        EQU -3          ; quantidade da energia que se perde ao longo do tempo
FATOR                       EQU 1000        ; fator para converter decimal para o mesmo hexadecimal


; ****************************************************************************
; * Stack Pointers
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

STACK       100H                            ; espaço reservado para a pilha do processo asteroides
SP_asteroides:                              ; valor inicial para o SP do processo asteroides

STACK       100H                            ; espaço reservado para a opilha do processo sondas   
SP_sondas:                                  ; valor inicial para o SP do processo sondas


; ****************************************************************************
; * Variáveis
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
    WORD    CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO, CINZA_MEDIO, CINZA_MEDIO, CINZA_MEDIO, CINZA_MEDIO, CINZA_MEDIO, CINZA_MEDIO, CINZA_MEDIO, CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO
    WORD    CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO, CINZA_MEDIO, CINZA_MEDIO, CINZA_MEDIO, CINZA_MEDIO, CINZA_MEDIO, CINZA_MEDIO, CINZA_MEDIO, CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO
    WORD    CINZA_ESCURO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_CLARO, CINZA_ESCURO

POS_PAINEL:                                 ; posição do painel de instrumentos
    WORD    LINHA_PAINEL
    WORD    COLUNA_PAINEL

POSSIVEIS_AST:                              ; coluna inicial e movimento horizontal dos possíveis asteroides
    WORD    0, 1
    WORD    30, 0
    WORD    59, -1
    WORD    30, -1
    WORD    30, 1

ASTEROIDES:                                 ; ecrã, tipo, ON/OFF e lane do asteroide
    WORD    ECRA_ASTEROIDE_1, 0, OFF, DEFAULT_LANE
    WORD    ECRA_ASTEROIDE_2, 0, OFF, DEFAULT_LANE
    WORD    ECRA_ASTEROIDE_3, 0, OFF, DEFAULT_LANE
    WORD    ECRA_ASTEROIDE_4, 0, OFF, DEFAULT_LANE

POS_AST:                                    ; linha e coluna do asteroide
    WORD    0, 0
    WORD    0, 0
    WORD    0, 0
    WORD    0, 0

MOV_AST:                                    ; movimento vertical e horizontal do asteroide
    WORD    1, 0
    WORD    1, 0
    WORD    1, 0
    WORD    1, 0

DEF_ASTEROIDE_BOM:                          ; definição do asteroide "bom" (minerável)
    WORD    LARGURA_5
    WORD    ALTURA_5
    WORD    0, VERDE, VERDE, VERDE, 0
    WORD    VERDE, VERDE, VERDE, VERDE, VERDE
    WORD    VERDE, VERDE, VERDE, VERDE, VERDE
    WORD    VERDE, VERDE, VERDE, VERDE, VERDE
    WORD    0, VERDE, VERDE, VERDE , 0

DEF_ASTEROIDE_BOM_EXPLOSAO:                 ; definição do asteroide "bom" ao colidir (minerável)
    WORD    LARGURA_5
    WORD    ALTURA_5
    WORD    0, 0, 0, 0, 0
    WORD    0, 0, VERDE, 0, 0
    WORD    0, VERDE, VERDE, VERDE, 0
    WORD    0, 0, VERDE, 0, 0
    WORD    0, 0, 0, 0, 0

DEF_ASTEROIDE_MAU:                          ; definição do asteroide "mau" (não minerável)
    WORD    LARGURA_5
    WORD    ALTURA_5
    WORD    CASTANHO, 0, CASTANHO, 0, CASTANHO
    WORD    0, CASTANHO, CASTANHO, CASTANHO, 0
    WORD    CASTANHO, CASTANHO, 0, CASTANHO, CASTANHO
    WORD    0, CASTANHO, CASTANHO, CASTANHO, 0
    WORD    CASTANHO, 0, CASTANHO, 0, CASTANHO

DEF_ASTEROIDE_MAU_EXPLOSAO:                 ; definição do asteroide "mau" ao colidir (não minerável)
    WORD    LARGURA_5
    WORD    ALTURA_5
    WORD    0, AZUL, 0, AZUL, 0
    WORD    AZUL, 0, AZUL, 0, AZUL
    WORD    0, AZUL, 0, AZUL, 0
    WORD    AZUL, 0, AZUL, 0, AZUL
    WORD    0, AZUL, 0, AZUL, 0

SONDAS:
    WORD    OFF, MOVIMENTOS, ECRA_SONDA_ESQ ; sonda esquerda (ON/OFF), movimentos restantes, ecrã
    WORD    OFF, MOVIMENTOS,ECRA_SONDA_MEIO ; sonda do meio (ON/OFF), movimentos restantes, ecrã
    WORD    OFF, MOVIMENTOS, ECRA_SONDA_DIR ; sonda direita (ON/OFF), movimentos restantes, ecrã

POS_SONDAS:
    WORD    LINHA_SONDA, COLUNA_SONDA_ESQ   ; posição da sonda esquerda (linha, coluna) 
    WORD    LINHA_SONDA, COLUNA_SONDA_MEIO  ; posição da sonda do meio (linha, coluna)
    WORD    LINHA_SONDA, COLUNA_SONDA_DIR   ; posição da sonda direita (linha, coluna)

MOV_SONDA:
    WORD    HORIZONTAL_ESQ                  ; movimento horizontal da sonda esquerda
    WORD    HORIZONTAL_MEIO                 ; movimento horizontal da sonda do meio
    WORD    HORIZONTAL_DIR                  ; movimento horizontal da sonda direita

MOVS_SONDA:                                 ; movimento vertical e horizontal da sonda
    WORD    -1, HORIZONTAL_ESQ
    WORD    -1, HORIZONTAL_MEIO
    WORD    -1, HORIZONTAL_DIR

COLUNAS_SONDAS:                             ; colunas iniciais de cada sonda
    WORD    COLUNA_SONDA_ESQ
    WORD    COLUNA_SONDA_MEIO
    WORD    COLUNA_SONDA_DIR

DEF_SONDA:
    WORD    LARGURA_1                       ; largura da sonda
    WORD    ALTURA_1                        ; altura da sonda
    WORD    COR_SONDA                       ; cor da sonda

PAUSA:                                      ; estado atual do jogo (0 = despausado, 1 = pausado)
    WORD    0

TECLA_CARREGADA:                            ; última tecla carregada
    LOCK    0

REINICIA_JOGO:                              ; WORD para reiniciar o jogo
    WORD    0

tab_int:                                    ; tabela das rotinas de interrupção
    WORD    asteroides_int
    WORD    sondas_int
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

    MOV     BTE, tab_int			        ; inicializa BTE (registo de Base da Tabela de Excepções)

    CALL    processo_teclado                ; inicia o processo teclado

    MOV     [APAGA_AVISO], R0				; apaga o aviso de nenhum cenário selecionado
    MOV     [APAGA_ECRAS], R0				; apaga todos os pixels
    MOV     [APAGA_FRONTAL], R0				; apaga o ecrã frontal
    
	MOV	    R0, CENARIO_MENU				; cenário do menu
    MOV     [DEFINE_CENARIO], R0            ; seleciona o cenário de fundo

    MOV     R1, SOM_TEMA                    ; endereço da música de fundo
    MOV     [DEFINE_SOM_OU_VIDEO], R1       ; seleciona a música de fundo
    MOV     [REPRODUZ_EM_CICLO], R1         ; começa a música de fundo

    MOV     R1, 0
    MOV     [ENERGIA], R1                   ; inicia a energia com o valor 0
    CALL    display                         ; mostra o nível de energia na nave

    EI0                                     ; permite a interrupção 0
    EI1                                     ; permite a interrupção 1
    EI2                                     ; permite a interrupção 2
    EI3                                     ; permite a interrupção 3
    EI                                      ; permite interrupções (geral)

menu:
    MOV     R0, [TECLA_CARREGADA]           ; lê uma tecla
    MOV     R1, TECLA_START                 ; tecla de start (C)
    CMP     R0, R1                          ; a tecla lida é o "C" (?)
    JNZ     menu                            ; se não, continua à espera
    ; Inicia os processos:
    CALL    processo_energia
    CALL    processo_nave   
    CALL    processo_sondas  
    CALL    processo_asteroides
    CALL    processo_controlos 

start:
    MOV     R11, 0                          ; 0 simboliza jogo não pausado e que já foi reiniciado
    MOV     [REINICIA_JOGO], R11            ; indica que já foi reiniciado o jogo

    MOV     R8, PAUSA                       ; endereço do estado atual do jogo
    MOV     [R8], R11                       ; tira o jogo da pausa

    MOV     R0, ENERGIA                     ; endereço da variável que guarda a energia do display
    MOV     R1, ENERGIA_INI                 ; nº de energia inicial
    MOV     [R0], R1                        ; inicia a energia com o valor 100H
    CALL    display                         ; mostra o nível de energia na nave

	MOV	    R0, CENARIO_JOGO				; cenário de fundo nº
    MOV     [DEFINE_CENARIO], R0	        ; seleciona o cenário de fundo

    MOV     R1, SOM_TEMA                    ; endereço da música de fundo
    MOV     [DEFINE_SOM_OU_VIDEO], R1       ; seleciona a música de fundo
    MOV     [TERMINA_SOM_OU_VIDEO], R1      ; termina a música de fundo

    MOV     R1, SOM_START                   ; endereço da música de start
    MOV     [DEFINE_SOM_OU_VIDEO], R1       ; seleciona a música de start
    MOV     [INICIA_REPRODUCAO], R1         ; reproduz o som de start

    MOV     R1, SOM_TEMA_JOGO               ; endereço da música do tema do jogo
    MOV     [DEFINE_SOM_OU_VIDEO], R1       ; seleciona a música
    MOV     [REPRODUZ_EM_CICLO], R1         ; reproduz o som
    
    MOV     R0, ECRA_NAVE                   ; ecrã da nave
    MOV     [SELECIONA_ECRA], R0            ; seleciona o ecrã
    MOV     R0, POS_NAVE                    ; enderelço das coordenadas da nave
    MOV     R1, DEF_NAVE                    ; endereço do protótipo da nave
    CALL    desenha_objeto                  ; desenha a nave

reinicia_variaveis_sonda:
    MOV     R0, SONDAS                      ; endereço da tabela das sondas
    MOV     R1, OFF                         ; estado OFF

    MOV     [R0], R1                        ; reinicia o estado da sonda 1
    ADD     R0, 6                           ; 6 porque a tabela das sondas tem 3 variáveis (6 bytes)
    MOV     [R0], R1                        ; reinicia o estado da sonda 2
    ADD     R0, 6                           ; 6 porque a tabela das sondas tem 3 variáveis (6 bytes)
    MOV     [R0], R1                        ; reinicia o estado da sonda 3

reinicia_variaveis_asteroides:
    MOV     R0, ASTEROIDES                  ; endereço da tabela dos asteroides
    MOV     R1, 0                           ; primeiro asteroide
    JMP     ciclo_reiniciar_asteroides

ciclo_reiniciar_asteroides:
    MOV     R4, R1                          ; copia o número do asteróide
    SHL     R4, 3                           ; 8 porque a tabela dos asteroides tem 4 variáveis (8 bytes)
    MOV     R3, R0                          ; cópia do endereço da tabela dos asteroides
    ADD     R3, R4                          ; endereço do asteroide a reiniciar

    MOV     R2, OFF                         ; OFF = 0
    MOV     [R3+2], R2                      ; muda o tipo para 0
    MOV     [R3+4], R2                      ; muda o estado para OFF
    MOV     R2, DEFAULT_LANE                ; DEFAULT_LANE = -1
    MOV     [R3+6], R2                      ; passa o lane para 0

    MOV     R5, POS_AST                     ; endereço da tabela das posições dos asteroides 
    MOV     R4, R1                          ; copia o número do asteróide para R4
    SHL     R4, 2                           ; multiplica por 4 porque cada word são 2 bytes (4 bytes)
    ADD     R5, R4                          ; endereço do asteroide na tabela dos asteroides
    MOV     R4, 0
    MOV     [R5], R4                        ; reseta a linha do asteroide a 0

    ADD     R1, 1                           ; acrescenta um asteróide
    CMP     R1, NUM_ASTEROIDES              ; é o último (?)
    JZ      main                            ; se sim, passa para a main
    JMP     ciclo_reiniciar_asteroides      ; repete o ciclo

main:                                       ; espera até poder reiniciar o jogo
    YIELD
    MOV     R1, [REINICIA_JOGO]             ; variável que indica se é para reiniciar o jogo
    CMP     R1, ON                          ; é para reiniciar o jogo (?)
    JZ      start                           ; se sim, reinicia o jogo
    JMP     main                            ; repete o ciclo


; ****************************************************************************
; * PROCESSOS
; ****************************************************************************

; ****************************************************************************
; Processo Controlos
; Descrição: Trata de pausar, tirar da pausa, disparar as sondas e
;            terminar o jogo.
; ****************************************************************************
PROCESS SP_controlos

processo_controlos:
    MOV     R0, [TECLA_CARREGADA]           ; lẽ uma tecla

    MOV     R11, [PAUSA]                    ; guarda o valor do estado pausa do jogo
    MOV     R10, ON                         ; simboliza que o jogo está pausado
    CMP     R11, R10                        ; o jogo está pausado (?)
    JZ      processo_controlos              ; se sim, repete o ciclo

    MOV     R1, TECLA_TERMINAR              
    CMP     R0, R1                          ; a tecla lida é o "E" (?)
    JZ      termina_jogo                    ; se sim, termina o jogo

    MOV     R1, TECLA_PAUSAR                
    CMP     R0, R1                          ; a tecla lida é o "D" (?)
    JZ      pausa                           ; se sim, pausa o jogo

    MOV     R1, TECLA_ESQUERDA              
    CMP     R0, R1                          ; a tecla lida é o "0" (?)
    JZ      sonda_esquerda_controlo         ; se sim, cria a sonda

    MOV     R1, TECLA_MEIO                  
    CMP     R0, R1                          ; a tecla lida é o "1" (?)
    JZ      sonda_meio_controlo             ; se sim, cria a sonda

    MOV     R1, TECLA_DIREITA               
    CMP     R0, R1                          ; a tecla lida é o "2" (?)
    JZ      sonda_direita_controlo          ; se sim, cria a sonda

    JMP     processo_controlos              ; se não for nenhuma das teclas anteriores, repete o ciclo

termina_jogo:
    CALL    game_over_terminado             ; termina o jogo
    JMP     processo_controlos              ; repete o ciclo

pausa:
    MOV     R8, PAUSA                       ; endereço do estado atual do jogo
    MOV     R9, [R8]                        ; estado atual do jogo
    CMP     R9, ON                          ; o jogo está em pausa (?)
    JNZ     mete_pausa                      ; se não, mete em pausa

tira_pausa:
    MOV     [APAGA_FRONTAL], R11            ; apaga a mensagem de pausa

    MOV     R11, SOM_TEMA_PAUSA             ; endereço da música da pausa
    MOV     [DEFINE_SOM_OU_VIDEO], R11      ; seleciona-a
    MOV     [TERMINA_SOM_OU_VIDEO], R11     ; termina a música de fundo

    MOV     R1, SOM_TEMA_JOGO               ; endereço do tema
    MOV     [DEFINE_SOM_OU_VIDEO], R1       ; seleciona-o
    MOV     [CONTINUA_SOM_OU_VIDEO], R1     ; continua a tocar

    MOV     R1, SOM_PAUSA_EFFECT            ; endereço do som de pausa
    MOV     [DEFINE_SOM_OU_VIDEO], R1       ; seleciona o som
    MOV     [INICIA_REPRODUCAO], R1         ; reproduz o som

    MOV     R11, OFF                        ; simboliza joga não pausado (0)
    MOV     [R8], R11                       ; tira o jogo da pausa

    EI                                      ; ativa as interrupções

    JMP     processo_controlos              ; volta ao início do ciclo principal

mete_pausa:
    MOV     R11, CENARIO_PAUSA              ; cenário da pausa
    MOV     [DEFINE_FRONTAL], R11           ; coloca o cenário à frente de tudo

    MOV     R1, SOM_TEMA_JOGO               ; endereço do tema
    MOV     [DEFINE_SOM_OU_VIDEO], R1       ; seleciona-o
    MOV     [PAUSA_SOM_OU_VIDEO], R1        ; pausa-o

    MOV     R11, SOM_TEMA_PAUSA             ; endereço da música de pausa
    MOV     [DEFINE_SOM_OU_VIDEO], R11      ; seleciona-a
    MOV     [REPRODUZ_EM_CICLO], R11        ; começa a tocar

    MOV     R1, SOM_PAUSA_EFFECT            ; endereço do som de pausa
    MOV     [DEFINE_SOM_OU_VIDEO], R1       ; seleciona o som
    MOV     [INICIA_REPRODUCAO], R1         ; reproduz o som

    MOV     R11, ON                         ; simboliza jogo pausado
    MOV     [R8], R11                       ; mete o jogo em pausa

    DI                                      ; desativa as interrupções

espera_pausa:                               ; neste ciclo, espera-se até se tirar da pausa
    MOV     R0, [TECLA_CARREGADA]           ; lẽ uma tecla

    MOV     R1, TECLA_PAUSAR                ; tecla para pausar o jogo (D)
    CMP     R0, R1                          ; a tecla lida é o "D" (?)
    JZ      tira_pausa                      ; se sim, tira o jogo da pausa

    MOV     R1, TECLA_TERMINAR              ; tecla para terminar o jogo (E)
    CMP     R0, R1                          ; a tecla lida é o "E" (?)
    JZ      game_over_terminado_pausa       ; se sim, termina o jogo

    JMP     espera_pausa                    ; se não, espera pela tecla de pausa

game_over_terminado_pausa:
    MOV     [APAGA_FRONTAL], R11            ; apaga o painel de pausa

    MOV     R11, SOM_TEMA_PAUSA             ; endereço da música de pausa
    MOV     [DEFINE_SOM_OU_VIDEO], R11      ; seleciona-a
    MOV     [TERMINA_SOM_OU_VIDEO], R11     ; termina-a

    CALL    game_over_terminado             ; termina o jogo

    JMP     processo_controlos

game_over_terminado:
    PUSH    R0

    MOV     R0, CENARIO_TERMINADO           ; cenário de fundo com a mensagem de fim de jogo
    MOV     [DEFINE_CENARIO], R0            ; seleciona o cenário

    MOV     R11, SOM_GAMEOVER               ; endereço do som de game over

    CALL    game_over                       ; termina o jogo

    POP     R0
    RET

game_over_colisao:
    PUSH    R0

    MOV     R0, CENARIO_COLISAO             ; cenário de fundo com a mensagem de fim de jogo
    MOV     [DEFINE_CENARIO], R0            ; seleciona o cenário

    MOV     R11, SOM_GAMEOVER_COLISAO       ; endereço do som de game over

    CALL    game_over                       ; termina o jogo

    POP     R0
    RET

game_over_energia:
    PUSH    R0

    MOV     R0, CENARIO_SEM_ENERGIA         ; cenário de fundo com a mensagem de sem energia
    MOV     [DEFINE_CENARIO], R0            ; seleciona-o

    MOV     R11, SOM_GAMEOVER_ENERGIA       ; endereço do som de game over

    CALL    game_over                       ; game over

    POP     R0
    RET

sonda_esquerda_controlo:
    CALL    sonda_controlo_inicializacoes   ; mete os valores nos registos certos
    MOV     R8, COLUNA_SONDA_ESQ
    CALL    cria_sonda                      ; cria a sonda da esquerda
    JMP     processo_controlos              ; volta ao ciclo principal

sonda_meio_controlo:
    CALL    sonda_controlo_inicializacoes   ; mete as tabelas nos registos certos
    ADD     R1, 6                           ; 6 porque cada word são 2 bytes
    ADD     R2, 2                           ; 2 porque cada word são 2 bytes
    ADD     R3, 4                           ; 4 porque cada word são 2 bytes
    MOV     R8, COLUNA_SONDA_MEIO
    CALL    cria_sonda                      ; cria a sonda do meio
    JMP     processo_controlos              ; volta ao ciclo principal

sonda_direita_controlo:
    CALL    sonda_controlo_inicializacoes
    MOV     R4, 12
    ADD     R1, R4                          ; 12 porque cada word são 2 bytes
    ADD     R2, 4                           ; 4 porque cada word são 2 bytes
    MOV     R4, 8
    ADD     R3, R4                          ; 8 porque cada word são 2 bytes
    MOV     R8, COLUNA_SONDA_DIR
    CALL    cria_sonda                      ; cria a sonda da direita
    JMP     processo_controlos              ; volta ao ciclo principal

; ****************************************************************************
; SONDA_CONTROLO_INICIALIZACOES
; Descrição: Mete os valores nos registos certos para criar uma sonda.
; Entradas:  -------------------------------------
; Saídas:    R1 - tabela das sondas
;            R2 - tabela dos movimentos das sondas
;            R3 - tabela das posições das sondas
; ****************************************************************************
sonda_controlo_inicializacoes:
    MOV     R1, SONDAS                      ; tabela das sondas
    MOV     R2, MOV_SONDA                   ; tabela dos movimentos das sondas
    MOV     R3, POS_SONDAS                  ; tabela das posições das sondas
    RET

; ****************************************************************************
; CRIA_SONDA
; Descrição: Cria uma sonda.
; Entradas:  R1 - tabela das sondas
;            R2 - tabela dos movimentos das sondas
;            R3 - tabela das posições das sondas
;            R8 - coluna inicial da sonda
; Saídas:    -------------------------------------
; ****************************************************************************
cria_sonda:
    PUSH    R2
    PUSH    R3
    PUSH    R4
    PUSH    R5
    PUSH    R6

    MOV     R4, [R1]                        ; estado da sonda
    CMP     R4, ON                          ; a sonda já existe (?)
    JZ      exit_cria_sonda                 ; se sim, sai da rotina

    MOV     R5, LINHA_SONDA
    MOV     [R3], R5                        ; reinicia a linha
    MOV     [R3+2], R8                      ; reinicia a coluna

    MOV     R4, ON                          ; simboliza sonda ligada
    MOV     [R1], R4                        ; atualiza o estado da sonda

    MOV     R4, MOVIMENTOS                  ; nº máximo de movimentos de uma sonda
    MOV     [R1+2], R4                      ; atualiza o nº de movimentos restantes da sonda

    MOV     R4, SOM_LASER                   ; endereço do som do laser
    MOV     [DEFINE_SOM_OU_VIDEO], R4       ; seleciona o som
    MOV     [INICIA_REPRODUCAO], R4         ; reproduz o som

    MOV     R4, [R1+4]                      ; ecrã da sonda
    MOV     [SELECIONA_ECRA], R4            ; seleciona o ecrã

    MOV     R6, COR_SONDA                   ; cor da sonda
    MOV     R2, [R3]                        ; copia a linha da sonda
    MOV     R3, [R3+2]                      ; copia a coluna da sonda

    CALL    desenha_pixel                   ; desenha a sonda

    MOV     R2, -5                          ; energia a perder com a sonda
    CALL    altera_energia                  ; diminui a energia

exit_cria_sonda:
    POP     R6
    POP     R5
    POP     R4
    POP     R3
    POP     R2
    RET

; ****************************************************************************
; GAME_OVER
; Descrição: Termina o jogo.
; Entradas:  R11 - Som de game over a colocar
; Saídas:    ---------------
; ****************************************************************************
game_over:
    PUSH    R0
    PUSH    R1

    MOV     R0, PAUSA                       ; endereço do estado atual do jogo
    MOV     R1, 1                           ; 1 simboliza jogo pausado
    MOV     [R0], R1                        ; pausa o jogo

    MOV     R0, SOM_TEMA_JOGO               ; endereço da música de fundo
    MOV     [DEFINE_SOM_OU_VIDEO], R0       ; seleciona a música de fundo
    MOV     [TERMINA_SOM_OU_VIDEO], R0      ; termina a música de fundo

    MOV     [APAGA_ECRAS], R0	            ; apaga todos os pixels já desenhados (o valor de R0 não é relevante)

    MOV     [DEFINE_SOM_OU_VIDEO], R11      ; seleciona o som de fim de jogo
    MOV     [INICIA_REPRODUCAO], R11        ; reproduz o som

game_over_ciclo:
    MOV     R0, [TECLA_CARREGADA]           ; lê uma tecla
    MOV     R1, TECLA_START                 ; tecla para iniciar o jogo (C)
    CMP     R0, R1                          ; a tecla lida é o "C" ( (?))
    JNZ     game_over_ciclo                 ; se não, continua à espera

    MOV     [DEFINE_SOM_OU_VIDEO], R11      ; seleciona o som de fim de jogo
    MOV     [TERMINA_SOM_OU_VIDEO], R11     ; termina o som de pausa

    MOV     R0, 1
    MOV     [REINICIA_JOGO], R0             ; indica que o main deve reiniciar o jogo
    POP     R1
    POP     R0
    RET


; ****************************************************************************
; Processo Sondas
; Descrição: Dispara uma sonda consoante a tecla pressionada.
; ****************************************************************************
PROCESS SP_sondas

processo_sondas:
    MOV     R10, evento_int                 ; endereço da tabela das ocorrências das interrupções
    MOV     R10, [R10+2]                    ; ocorrência da interrupção 1

    MOV     R11, [PAUSA]                    ; estado atual do jogo
    CMP     R11, 1                          ; o jogo está pausado (?)
    JZ      processo_sondas                 ; se sim, repete o ciclo

    MOV     R9, 0                           ; primeira sonda (esquerda)

ciclo_sonda:
    CMP     R9, NUM_SONDAS                  ; chegou à última sonda (?)
    JZ      processo_sondas                 ; se sim, repete o ciclo principal

    CALL    move_sonda                      ; move a sonda

    ADD     R9, 1                           ; sonda seguinte
    JMP     ciclo_sonda                     ; repete o ciclo

; ****************************************************************************
; MOVE_SONDA
; Descrição: Move uma sonda.
; Entradas:  R9 - Número da sonda
; Saídas:    --------------------
; ****************************************************************************
move_sonda:
    PUSH    R0
    PUSH    R1
    PUSH    R2
    PUSH    R3
    PUSH    R4
    PUSH    R6
    PUSH    R7
    PUSH    R8
    PUSH    R9

    MOV     R5, R9                          ; cópia do nº da sonda
    MOV     R7, R9                          ; cópia do nº da sonda
    MOV     R8, 6                           ; 6 porque a tabela das sondas tem 3 variáveis (6 bytes)
    MUL     R7, R8                          ; valor a adicionar à tabela das sondas
    MOV     R8, R9                          ; cópia do nº da sonda
    SHL     R8, 1                           ; valor a adicionar à tabela das colunas iniciais
    SHL     R9, 2                           ; valor a adicionar às tabelas de 2 variáveis

    MOV     R0, POS_SONDAS                  ; endereço da tabela da posição das sondas
    ADD     R0, R9                          ; endereço da posição da sonda
    MOV     R1, DEF_SONDA                   ; endereço da definição da sonda
    
    MOV     R2, MOVS_SONDA                  ; endereço da tabela dos movimentos das sondas
    ADD     R2, R9                          ; endereço dos movimentos da sonda
    MOV     R6, SONDAS                      ; endereço da tabela das sondas
    ADD     R6, R7                          ; endereço da sonda a tratar

    MOV     R4, [R6]                        ; estado da sonda
    CMP     R4, ON                          ; a sonda já existe (?)
    JNZ     exit_move                       ; se não, passa para a sonda seguinte

    MOV     R4, [R6+2]                      ; movimentos restantes da sonda
    CMP     R4, 0                           ; já realizou todos os movimentos (?)
    JZ      reinicia_move_sonda             ; se sim, reinicia a sonda

    SUB     R4, 1                           ; menos 1 movimento restante
    MOV     [R6+2], R4                      ; atualiza os movimentos da sonda

    MOV     R3, [R6+4]                      ; ecrã da sonda
    CALL    move_objeto                     ; move a sonda

    MOV     R9, R5                          ; nº da sonda
    CALL    testa_colisao_sonda             ; testa se houve uma colisão com um asteroide

exit_move:
    POP     R9
    POP     R8
    POP     R7
    POP     R6
    POP     R4
    POP     R3
    POP     R2
    POP     R1
    POP     R0
    RET

reinicia_move_sonda:
    CALL    reinicia_sonda                  ; reinicia a sonda
    JMP     exit_move

; ****************************************************************************
; REINICIA_SONDA
; Descrição: Reinicia a sonda.
; Entradas:  R0 - Endereço da tabela da posição da sonda
;            R6 - Endereço da tabela da sonda
;            R8 - Valor a adicionar na tabela das colunas das sondas
; Saídas:    -------------------------------------------------------
; ****************************************************************************
reinicia_sonda:
    PUSH    R1
    PUSH    R4

    MOV     R4, [R6+4]                      ; ecrã da sonda
    MOV     [SELECIONA_ECRA], R4            ; seleciona o ecrã
    MOV     [APAGA_ECRA], R4                ; apaga o ecrã

    MOV     R4, OFF                         ; simboliza sonda desligada (0)
    MOV     [R6], R4                        ; desliga a sonda

    MOV     R4, R0                          ; endereço da posição da sonda
    MOV     R1, LINHA_SONDA                 ; linha inicial das sondas
    MOV     [R4], R1                        ; reinicia a linha

    MOV     R1, COLUNAS_SONDAS              ; endereço da tabela das colunas iniciais das sondas
    ADD     R1, R8                          ; endereço da coluna inicial da sonda
    MOV     R1, [R1]                        ; coluna inicial da sonda
    MOV     [R4+2], R1                      ; reinicia a coluna

    POP     R4
    POP     R1
    RET

; ****************************************************************************
; TESTA_COLISAO_SONDA
; Descrição: Verifica se a sonda colidiu com um asteroide.
; Entradas:  R0 - Endereço da posição atual da sonda
;            R9 - Número da sonda
; Saídas:    -------------------------------
; ****************************************************************************
testa_colisao_sonda:
    PUSH    R1
    PUSH    R2
    PUSH    R3
    PUSH    R4
    PUSH    R5
    PUSH    R6
    
    MOV     R1, 0                           ; primeiro asteroide
    MOV     R2, POS_AST                     ; endereço da tabela da posição dos asteroides
    MOV     R3, ASTEROIDES                  ; endereço da tabela dos asteroides

ciclo_testa_asteroide:
    CMP     R1, NUM_ASTEROIDES              ; já testou todos os asteroides (?)
    JZ      exit_testa_colisao_sonda        ; se sim, salta para o fim desto ciclo

    MOV     R4, R1                          ; cópia do nº do asteroide
    MOV     R5, 8                           ; 8 porque a tabela dos asteroides tem 4 variáveis (8 bytes)
    MUL     R4, R5                          ; valor a adicionar à tabela dos asteroides

    ADD     R4, R3                          ; endereço do asteroide a testar
    MOV     R5, R4                          ; cópia do endereço do asteroide a testar
    MOV     R4, [R5+4]                      ; indica se o asteroide existe
    CMP     R4, ON                          ; o asteroide existe (?)
    JNZ     proximo_asteroide               ; se não existe, passa ao próximo

    MOV     R5, R1                          ; nº do asteroide
    SHL     R5, 2                           ; multiplica por 4 porque a tabela dos asteroides tem 2 variáveis (4 bytes)
    ADD     R5, R2                          ; endreço da tabela da posição do asteroide atual

    MOV     R4, [R0]                        ; linha da sonda
    MOV     R6, [R5]                        ; linha do asteroide

    CMP     R6, R4                          ; a linha superior do asteroide está abaixo da sonda (?)
    JGT     proximo_asteroide               ; se sim, passa para o próximo asteroide

    ADD     R6, ALTURA_5                    ; adiciona a altura do asteroide
    CMP     R6, R4                          ; a linha inferior do asteroide está acima da sonda (?)
    JLT     proximo_asteroide               ; se sim, passa para o próximo asteroide
    
    MOV     R4, [R0+2]                      ; coluna da sonda
    MOV     R6, [R5+2]                      ; coluna do asteroide

    CMP     R6, R4                          ; a coluna esquerda do asteroide está à direita da sonda (?)
    JGT     proximo_asteroide               ; se sim, passa para o próximo asteroide

    ADD     R6, LARGURA_5                   ; adiciona a largura do asteroide
    CMP     R6, R4                          ; a coluna direita do asteroide está à esquerda da sonda (?)
    JLT     proximo_asteroide               ; se sim, passa para o próximo asteroide
    ; se chegou aqui então há uma colisão
    CALL    colisao_geral                   ; trata da colisão da sonda com o asteroide
    
exit_testa_colisao_sonda:
    POP     R6
    POP     R5
    POP     R4
    POP     R3
    POP     R2
    POP     R1
    RET

proximo_asteroide:
    ADD     R1, 1                           ; asteroide seguinte
    JMP     ciclo_testa_asteroide           ; repete o ciclo

; ****************************************************************************
; COLISAO_GERAL
; Descrição: Trata da colisão de uma sonda com um asteroide.
; Entradas:  R1 - Número do asteroide
;            R9 - Número da sonda
; Saídas:    ------------------------
; ****************************************************************************
colisao_geral:
    PUSH    R0
    PUSH    R2
    PUSH    R3
    PUSH    R4
    PUSH    R5
    PUSH    R6
    PUSH    R7
    PUSH    R8
    PUSH    R9
    PUSH    R10
    PUSH    R11    

colisao_sondas:
    MOV     R2, SONDAS                      ; endereço da tabela das sondas

    MOV     R5, R9                          ; cópia do nº da sonda
    MOV     R4, 6
    MUL     R5, R4                          ; 6 porque a tabela das sondas tem 3 variáveis (6 bytes)
    ADD     R2, R5                          ; sonda a tratar

    MOV     R6, [R2+4]                      ; vai buscar o valor do ecrã da sonda
    MOV     [SELECIONA_ECRA], R6            ; seleciona o ecrã da sonda

    MOV     [APAGA_ECRA], R6                ; apaga a sonda

    MOV     R6, OFF                         ; simboliza que a sonda vai ser desligada
    MOV     [R2], R6                        ; desativa a sonda

colisao_asteroides:
    MOV     R10, R1                         ; cópia do nº do asteroide
    MOV     R3, ASTEROIDES                  ; endereço da tabela dos asteroides
    SHL     R10, 3                          ; 8 porque a tabela dos asteroides tem 4 variáveis (8 bytes)
    ADD     R3, R10                         ; endereço do asteroide a tratar

    MOV     R10, R1                         ; copia o nº do asteroide
    MOV     R0, POS_AST                     ; endereço da tabela da posição dos asteroides
    
    SHL     R10, 2                          ; multiplica o nº do asteroide por 4 (2 words)
    ADD     R0, R10                         ; endereço da posição do asteroide

    MOV     R8, [R3]                        ; nº do ecrã do asteroide
    MOV     [SELECIONA_ECRA], R8            ; seleciona o ecrã do asteroide
    MOV     [APAGA_ECRA], R8                ; apaga o asteroide

    MOV     R4, OFF                         ; simboliza que o asteroide vai ser desligado
    MOV     [R3+4], R4                      ; desativa o asteroide
    MOV     R4, DEFAULT_LANE
    MOV     [R3+6], R4

    MOV     R4, [R3+2]                      ; tipo do asteroide
    CMP     R4, AST_BOM                     ; o asteroide é do tipo bom (?)
    JZ      colisao_asteroide_bom           ; se sim, trata do asteroide desse tipo
    JMP     colisao_asteroide_mau           ; se não, trata do asteroide do tipo mau

colisao_asteroide_bom:
    MOV     R1, DEF_ASTEROIDE_BOM_EXPLOSAO  ; endereço da tabela do asteroide bom explosão
    MOV     R11, SOM_ASTEROIDE_BOM          ; som do asteroide bom

    MOV     R2, ENERGIA_BONUS               ; energia a adicionar com o asteroide minerável
    CALL    altera_energia                  ; altera a energia da sonda
    JMP     efeito_colisao_asteroides

colisao_asteroide_mau:
    MOV     R1, DEF_ASTEROIDE_MAU_EXPLOSAO  ; endereço da tabela do asteroide mau explosão
    MOV     R11, SOM_ASTEROIDE_MAU          ; som do asteroide mau
    JMP     efeito_colisao_asteroides

efeito_colisao_asteroides:
    MOV     [DEFINE_SOM_OU_VIDEO], R11      ; define o som a reproduzir
    MOV     [INICIA_REPRODUCAO], R11        ; reproduz o som do efeito de colisão
    CALL    desenha_objeto                  ; desenha a explosão do asteroide

exit_colisao:
    POP     R11
    POP     R10
    POP     R9
    POP     R8
    POP     R7
    POP     R6
    POP     R5
    POP     R4
    POP     R3
    POP     R2 
    POP     R0
    RET

; ****************************************************************************
; Processo Asteroides
; Descrição: Move os asteroides periodicamente.
; ****************************************************************************
PROCESS SP_asteroides

processo_asteroides:   
    MOV     R10, [evento_int]               ; endereço da tabela das ocorrências das interrupções

    MOV     R11, [PAUSA]                    ; estado atual do jogo
    CMP     R11, 1                          ; o jogo está pausado (?)
    JZ      processo_asteroides             ; se sim, volta ao começo do ciclo

    MOV     R0, 0                           ; primeiro asteroide

ciclo_asteroide:
    MOV     R7, NAO_COLISAO_NAVE            ; inicialmente não ocorreu nenhuma colisão
    CMP     R0, NUM_ASTEROIDES              ; chegou ao ultimo asteroide (?)
    JZ      processo_asteroides             ; se sim, repete o ciclo principal

    CALL    testa_limites                   ; testa se o asteroide chegou aos limites
    CMP     R7, COLISAO_NAVE                ; o asteroide colidiu com a nave (?)
    JZ      processo_asteroides             ; se sim, volta ao início do ciclo principal

    MOV     R4, R0                          ; copia o valor atual do asteroide a ser avaliado
    SHL     R4, 3                           ; 8 porque cada word ocupa 2 bytes (4 words)

    MOV     R1, ASTEROIDES                  ; endereço da tabela dos asteroides
    ADD     R1, R4                          ; asteroide a tratar
    MOV     R4, [R1+4]                      ; indica se o asteroide existe
    CMP     R4, ON                          ; o asteroide existe (?)
    JNZ     coloca_asteroide                ; se não existe, coloca um novo

    CALL    move_asteroide                  ; move o asteroide
    
exit_coloca_asteroide: 
    ADD     R0, 1                           ; asteroide seguinte
    JMP     ciclo_asteroide                 ; volta ao ciclo
         
coloca_asteroide:
    CALL    coloca_topo                     ; coloca no topo um novo asteroide
    JMP     exit_coloca_asteroide

; ****************************************************************************
; COLOCA_TOPO
; Descrição: Coloca um asteroide "aleatoriamente" numa das 5 posições do topo.
; Entradas:  R0 - Número do asteroide
; Saídas:    ------------------------
; ****************************************************************************
coloca_topo:
    PUSH    R0
    PUSH    R1
    PUSH    R2
    PUSH    R3
    PUSH    R4
    PUSH    R5
    PUSH    R6
    PUSH    R11

    MOV     R6, R0                          ; copiamos o valor do asteroide atual 
    MOV     R5, R0                          ; copiamos o valor do asteroide atual 
    SHL     R5, 3                           ; valor a adicionar à tabela dos asteroides (4 variáveis)

    SHL     R0, 2                           ; valor a adicionar às tabelas de 2 variáveis (4 bytes)

    MOV     R1, ASTEROIDES                  ; endereço da tabela dos asteroides
    ADD     R1, R5                          ; endereço do asteroide a tratar

    MOV     R2, [R1]                        ; ecrã do asteroide
    MOV     [SELECIONA_ECRA], R2            ; seleciona o ecrã  

    MOV     R2, TEC_COL                     ; periférico das colunas
    MOVB    R3, [R2]                        ; lê do periférico
    SHR     R3, 4                           ; isola os bits 4-7 (gerados aleatoriamente)
    MOV     R2, R3                          ; copia o valor
    SHR     R2, 2                           ; isola os 2 bits de menor peso

    ADD     R1, 4                           ; estado do asteroide
    MOV     R4, ON                          ; indica um asteroide existente
    MOV     [R1], R4                        ; atualiza o estado do asteroide para ON

    SUB     R1, 2                           ; tipo do asteroide
    CMP     R2, AST_BOM                     ; o asteroide será bom (?)
    JZ      coloca_bom                      ; se sim, procede como tal
    MOV     R4, AST_MAU                     ; simboliza um asteroide mau
    MOV     [R1], R4                        ; atualiza o tipo do asteroide
    MOV     R1, DEF_ASTEROIDE_MAU           ; definição do asteroide mau

exit_coloca_bom:  
    MOV     R4, 5                           ; nº de possíveis asteroides
    MOD     R3, R4                          ; obtém um nº entre 0 e 4

    CALL    atribui_lane                    ; atribui uma lane ao asteroide

    MOV     R6, ASTEROIDES                  ; endereço da tabela dos asteroides
    ADD     R6, R5                          ; asteroide a tratar
    ADD     R6, 6                           ; lane do asteroide
    MOV     [R6], R3                        ; atualiza a lane do asteroide

    SHL     R3, 2                           ; multiplica por 4 (para adicionar a uma tabela de 2 variáveis)
    MOV     R4, POSSIVEIS_AST               ; endereço da tabela com os possíveis asteroides
    ADD     R4, R3                          ; possível asteroide escolhido

    MOV     R2, [R4]                        ; coluna inicial
    MOV     R3, POS_AST                     ; endereço da tabela das posições dos asteroides
    ADD     R3, R0                          ; posição do asteroide a tratar
    MOV     R11, 0                          ; linha do asteroide
    MOV     [R3], R11                       ; atualiza a linha do asteroide
    ADD     R3, 2                           ; coluna incial
    MOV     [R3], R2                        ; atualiza a coluna inicial

    ADD     R4, 2                           ; endereço do movimento horizontal
    MOV     R4, [R4]                        ; movimento horizontal
    MOV     R3, MOV_AST                     ; endereço da tabela com os movimentos dos asteroides
    ADD     R3, R0                          ; endereço dos movimentos do asteroide a colocar
    ADD     R3, 2
    MOV     [R3], R4                        ; atualiza os movimentos
    MOV     R2, POS_AST                     ; endereço da tabela da posição dos asteroides
    ADD     R0, R2                          ; posição do asteroide a tratar
    CALL    desenha_objeto                  ; desenha o asteroide

    POP     R11
    POP     R6
    POP     R5
    POP     R4
    POP     R3
    POP     R2
    POP     R1
    POP     R0
    RET

coloca_bom:
    MOV     R4, AST_BOM                     ; simboliza um asteroide bom
    MOV     [R1], R4                        ; atualiza o tipo do asteroide
    MOV     R1, DEF_ASTEROIDE_BOM           ; definição do asteroide bom
    JMP     exit_coloca_bom                 ; volta ao ciclo

; ****************************************************************************
; ATRIBUI_LANE
; Descrição: Atribui uma lane ao asteroide.
; Entradas:  R6 - Número do asteroide
; Saídas:    R3 - Lane do asteroide
; ****************************************************************************
atribui_lane:
    PUSH    R0
    PUSH    R1
    PUSH    R2
    PUSH    R4
    PUSH    R6

start_atribui_lane:
    MOV     R0, 0                           ; primeiro asteroide
    MOV     R1, ASTEROIDES                  ; endereço da tabela dos asteroides
    MOV     R2, POS_AST                     ; endereço da tabela da posição dos asteroides

    MOV     R4, TEC_COL                     ; periférico das colunas
    MOVB    R3, [R4]                        ; lê do periférico
    SHR     R3, 4                           ; isola os bits 4-7 (gerados aleatoriamente)
    MOV     R4, 5                           ; nº de possíveis asteroides
    MOD     R3, R4                          ; obtém um nº entre 0 e 4

ciclo_atribui_lane:
    CMP     R0, NUM_ASTEROIDES              ; já percorreu todos os asteroides (?)
    JZ      exit_atribui_lane               ; se sim, sai da rotina

    CMP     R0, R6                          ; está a tratar do asteroide atual (?)
    JZ      proximo_asteroide_verifica      ; se sim, salta para o próximo

    MOV     R4, R0                          ; copia o nº do asteroide do ciclo
    SHL     R4, 3                           ; valor a adicionar à tabela dos asteroides (4 variáveis)
    ADD     R4, R1                          ; endereço do asteroide a comparar
    MOV     R4, [R4+6]                      ; lane do asteroide
    CMP     R4, R3                          ; as lanes são iguais (?)
    JZ      verifica_threshold              ; se sim, verifica se o asteroide já passou um certo threshold

proximo_asteroide_verifica:
    ADD     R0, 1                           ; próximo asteroide
    JMP     ciclo_atribui_lane

verifica_threshold:
    MOV     R4, R0                          ; copia o nº do asteroide
    SHL     R4, 2                           ; valor a adicionar à tabela das posições (2 variáveis)
    ADD     R4, R2                          ; endereço da posição do asteroide a comparar
    MOV     R4, [R4]                        ; linha do asteroide a comparar
    CMP     R4, 6                           ; o asteroide já passou do threshold (?)
    JLT     start_atribui_lane              ; se não, repete o ciclo
    JMP     proximo_asteroide_verifica      ; passa ao próximo asteroide

exit_atribui_lane:
    POP     R6
    POP     R4
    POP     R2
    POP     R1
    POP     R0
    RET

; ****************************************************************************
; MOVE_ASTEROIDE
; Descrição: Move um asteroide.
; Entradas:  R0 - Número do asteroide
; Saídas:    ------------------------
; ****************************************************************************
move_asteroide:
    PUSH    R0
    PUSH    R1
    PUSH    R2
    PUSH    R3
    PUSH    R4
    PUSH    R5

    MOV     R5, R0                          ; copiamos o valor do nº do asteroide atual
    SHL     R5, 3                           ; 8 porque a tabela dos asteroides tem 4 variáveis (8 bytes)

    SHL     R0, 2                           ; valor a adicionar às tabelas de 2 variáveis (4 bytes)

    MOV     R1, ASTEROIDES                  ; endereço da tabela dos asteroides
    ADD     R1, R5                          ; asteroide a mover
    MOV     R3, [R1]                        ; ecrã do asteroide

    MOV     R2, [R1+2]                      ; tipo do asteroide
    MOV     R4, AST_BOM                     ; simboliza um asteroide bom
    CMP     R2, R4                          ; o asteroide é bom (?)
    JZ      move_bom                        ; se sim, procede como tal
    MOV     R1, DEF_ASTEROIDE_MAU           ; definição do asteroide mau

exit_move_bom:
    MOV     R2, MOV_AST                     ; endereço da tabela dos movimentos dos asteroides
    ADD     R2, R0                          ; endereço dos movimentos do asteroide a mover
    MOV     R4, POS_AST                     ; endereço da tabela da posição dos asteroides
    ADD     R0, R4                          ; endereço da posição do asteroide a mover
    CALL    move_objeto                     ; move o asteroide

    POP     R5
    POP     R4
    POP     R3
    POP     R2
    POP     R1
    POP     R0
    RET

move_bom:
    MOV     R1, DEF_ASTEROIDE_BOM           ; definição do asteroide bom
    JMP     exit_move_bom

; ****************************************************************************
; TESTA_LIMITES
; Descrição: Testa se um asteroide chegou ao fim do ecrã / colide com a nave.
; Entradas:  R0 - Número do asteroide
; Saídas:    R7 - Indica se houve uma colisão com a nave
; ****************************************************************************
testa_limites:
    PUSH    R0
    PUSH    R1
    PUSH    R2
    PUSH    R3
    PUSH    R4
    PUSH    R5

    MOV     R1, R0                          ; copia o nº do asteroide
    SHL     R1, 2                           ; valor a adicionar às tabelas de 2 variáveis (4 bytes)
    SHL     R0, 3                           ; 8 porque a tabela dos asteroides tem 4 variáveis (8 bytes)

    MOV     R3, POS_AST                     ; endereço da tabela da posição dos asteroides
    ADD     R3, R1                          ; endereço da posição do asteroide a testar
    MOV     R2, [R3]                        ; linha do asteroide
    
    MOV     R1, ASTEROIDES                  ; endereço da tabela dos asteroides
    ADD     R1, R0                          ; endereço do asteroide a testar
    MOV     R4, [R1+6]                      ; lane do asteroide

    MOV     R5, LINHA_MAX                   ; linha máxima do ecrã + 1
    
    CMP     R4, 2                           ; o asteroide pode colidir com a nave (?)
    JLE     muda_linha_limite               ; se sim, a linha limite passa a 26

testa_limites_continuacao:
    CMP     R2, R5                          ; o asteroide colide com a nave/sai do ecrã (?)
    JZ      reinicia_asteroide              ; se sim, reinicia o asteroide

exit_testa_limites:
    POP     R5
    POP     R4
    POP     R3
    POP     R2
    POP     R1
    POP     R0
    RET

muda_linha_limite:
    MOV     R5, LINHA_COLISAO_NAVE          ; linha onde o asteroide colide com a nave
    JMP     testa_limites_continuacao

reinicia_asteroide:
    MOV     R5, [R1]                        ; ecrã do asteroide
    MOV     [SELECIONA_ECRA], R5            ; seleciona o ecrã
    MOV     [APAGA_ECRA], R5                ; apaga o ecrã

    MOV     R2, OFF                         ; estado OFF
    ADD     R1, 4                           ; endereço do estado do asteroide
    MOV     [R1], R2                        ; Ao passar dos limites o asteroide é "desligado" para ser recriado no próximo ciclo

    MOV     R2, DEFAULT_LANE                ; valor default da lane
    MOV     [R1+2], R2                      ; reinicia a lane do asteroide

    CMP     R4, 2                           ; o asteroide colidiu com a nave (?)
    JLE     termina_jogo_asteroide          ; se sim, termina o jogo
    JMP     exit_testa_limites

termina_jogo_asteroide:
    CALL    game_over_colisao               ; termina o jogo
    MOV     R7, COLISAO_NAVE                ; indica que houve uma colisão com a nave
    JMP     exit_testa_limites


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
    AND     R0, R5                          ; elimina bits para além dos bits 0-3
    CMP     R0, 0                           ; há tecla premida (?)
    JNZ     converte                        ; se sim, converte a linha e a coluna para uma tecla

verifica_ultima:                            ; verifica se já percorreu todas as linhas 
    CMP     R6, 0                           ; é a última linha (?)
    JZ      espera_tecla                    ; se nenhuma tecla premida, repete
    SHR     R6, 1                           ; se não, testa a linha seguinte na próxima iteração
    JMP     varre_linhas                    ; passa para a linha seguinte

converte:                                   ; converte a linha e a coluna para uma tecla
    MOV     R7, R1                          ; copia a linha
    MOV     R8, 0                           ; começa na primeira linha (= 0)

linha:                                      ; loop para converter a linha
    SHR     R7, 1                           ; desloca os bits da linha uma poisção para a direita
    CMP     R7, 0                           ; já converteu a linha (?)
    JZ      exit_linha                      ; se já converteu, sai do loop
	ADD		R8, 1							; incrementa a linha em 1 unidade
	JMP		linha							; repete o processo

exit_linha:
    SHL		R8, 2							; multiplica a linha por 4
    MOV     R4, 0                           ; começa na primeira coluna (= 0)
    MOV     R7, R0                          ; copia a coluna

coluna:                                     ; loop para converter a coluna
    SHR     R7, 1                           ; desloca os bits da coluna uma posição para a direita
    CMP     R7, 0                           ; já converteu a coluna (?)
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
    AND     R0, R5                          ; elimina bits para além dos bits 0-3
    CMP     R0, 0                           ; há tecla premida (?)
    JNZ     ha_tecla                        ; se ainda houver uma tecla premida, espera até não haver
	JMP		espera_tecla					; repete o ciclo


; ****************************************************************************
; Processo Energia
; Descrição: Decrementa a energia da nave em 3% a cada 3 segundos.
; ****************************************************************************
PROCESS SP_energia

processo_energia:
    MOV     R10, [evento_int+4]             ; ocorrência da interrupção 2

    MOV     R11, [PAUSA]                    ; estado atual do jogo
    CMP     R11, 1                          ; o jogo está pausado (?)
    JZ      processo_energia                ; se sim, repete o ciclo

    MOV     R2, ENERGIA_DECREMENTADA        ; valor a ser decrementado
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

    MOV     R1, [ENERGIA]                   ; energia atual do display
    ADD     R1, R2                          ; acrescenta o valor pretendido à energia atual

    CMP     R1, 0                           ; a energia atual é menor que zero (?)
    JLE     energia_zero                    ; se sim, atualiza a energia para zero

    MOV     [ENERGIA], R1                   ; atualiza a variável que guarda a energia
    CALL    display                         ; atualiza o display

exit_altera_energia:
    POP     R2
    POP     R1
    POP     R0
    RET

energia_zero:
    MOV     R1, 0                           ; a energia passa a 0
    MOV     [ENERGIA], R1                   ; atualiza a variável que guarda a energia
    CALL    display                         ; atualiza o display

    CALL    game_over_energia               ; termina o jogo
    JMP     exit_altera_energia

; ****************************************************************************
; DISPLAY
; Descrição: Coloca o nível de energia no display.
; Entradas:  -------------------
; Saídas:    -------------------
; ****************************************************************************
display:
	PUSH    R0
    PUSH    R2 

    MOV     R0, [ENERGIA]   		        ; energia atual do display

	CALL    converte_hex			        ; converte o valor da energia de Hexadecimal para Decimal 
	MOV     [DISPLAYS], R2      	        ; escreve a energia atual nos displays

    POP     R2
	POP     R0
	RET

; ***********************************************************************
; CONVERTE_HEX
; Descrição: Converte um nº decimal para o mesmo nº hexadecimal.
; Entradas:  R0 - Número a converter
; Saídas:    R2 - Número convertido em hexadecimal
; ***********************************************************************
converte_hex:    
    PUSH    R0
    PUSH    R1
    PUSH    R3

    MOV     R1, FATOR                       ; fator
    MOV     R2, 0                           ; resultado (inicialmente a 0)
ciclo_converte_hex:
    MOD     R0, R1                          ; resto da divisão inteira do nº pelo fator
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
    MOV     R10, [evento_int+6]             ; ocorrência da interrupção 3

    MOV     R11, [PAUSA]                    ; estado atual do jogo
    CMP     R11, 1                          ; o jogo está pausado (?)
    JZ      processo_nave                   ; se sim, repete o ciclo

    MOV     R1, ECRA_NAVE                   ; nº do ecrã da nave
    MOV     [SELECIONA_ECRA], R1            ; seleciona esse ecrã

    MOV     R4, [PAINEL]                    ; nº do painel atual
    ROL     R4, 2                           ; passa ao painel seguinte
    MOV     [PAINEL], R4                    ; atualiza a variável que guarda o nº do painel
    MOV     R2, 0                           ; o 1º painel está na posição 0 da tabela

loop:                                       ; calcula em que painel está
    CMP     R4, 1H                          ; chegou ao fim (?)
    JZ      desenha_painel                  ; se sim, desenha o novo painel
    ROR     R4, 2                           ; roda os bits do painel em 2 posições
    ADD     R2, 2                           ; endereço do próximo painel (2 porque cada painel é uma word)
    JMP     loop                            ; repete o ciclo

desenha_painel:
    MOV     R0, ECRA_NAVE                   ; endereço do início do ecrã da nave
    MOV     [SELECIONA_ECRA], R0            ; seleciona o ecrã da nave

    MOV     R0, POS_PAINEL                  ; coordenadas do painel
    MOV     R5, PAINEIS                     ; endereço do início da tabela de painéis
    MOV     R1, [R5+R2]                     ; adiciona o offset dado pelo nº do painel atual
    CALL    desenha_objeto                  ; desenha o painel
    JMP     processo_nave                   ; repete o ciclo


; ****************************************************************************
; INTERRUPÇÕES
; ****************************************************************************

; ****************************************************************************
; asteroides_int
; Descrição: Trata a interrupção do temporizador 0.
;            Move os asteroides em jogo.
; ****************************************************************************
asteroides_int:
    PUSH R0
    MOV  [evento_int], R1		            ; na tabela das interrupções, na componente 0, desbloqueia o processo dos asteroides
	POP  R0
	RFE

; ****************************************************************************
; sondas_int
; Descrição: Trata a interrupção do temporizador 1.
;            Move as sondas em jogo.
; ****************************************************************************
sondas_int:
    PUSH R0
    MOV  [evento_int+2], R1		            ; na tabela das interrupções, na componente 1, desbloqueia o processo das sondas
	POP  R0
	RFE

; ****************************************************************************
; energia_int
; Descrição: Trata a interrupção do temporizador 2.
;            Num ciclo de 3 em 3 segundos baixa a energia em 3%.
; ****************************************************************************
energia_int:
    PUSH R0
    MOV  [evento_int+4], R1		            ; na tabela das interrupções, na componente 2, desbloqueia o processo energia
	POP  R0
	RFE

; ****************************************************************************
; nave_int
; Descrição: Trata a interrupção do temporizador 3.
;            Muda as cores do painel.
; ****************************************************************************
nave_int:
	PUSH R0
    MOV  [evento_int+6], R1		            ; na tabela das interrupções, na componente 3, desbloqueia o processo nave
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
    PUSH    R3
    PUSH    R4

    MOV     [SELECIONA_ECRA], R3            ; seleciona o ecrã
    MOV     [APAGA_ECRA], R3                ; apaga o ecrã
    MOV     R3, [R0]                        ; linha do objeto
    MOV     R4, [R2]                        ; movimento vertical do objeto
    ADD     R3, R4                          ; nova linha do objeto
    MOV     [R0], R3                        ; atualiza a linha do objeto
    MOV     R3, [R0+2]                      ; coluna do objeto
    MOV     R4, [R2+2]                      ; movimento horizontal do objeto
    ADD     R3, R4                          ; nova coluna do objeto
    MOV     [R0+2], R3                      ; atualiza a coluna do objeto
    CALL    desenha_objeto

    POP     R4
    POP     R3
    RET