COMANDOS				EQU	6000H			; endereço de base dos comandos do MediaCenter

DEFINE_LINHA    		EQU COMANDOS + 0AH		; endereço do comando para definir a linha
DEFINE_COLUNA   		EQU COMANDOS + 0CH		; endereço do comando para definir a coluna
DEFINE_PIXEL    		EQU COMANDOS + 12H		; endereço do comando para escrever um pixel
APAGA_AVISO     		EQU COMANDOS + 40H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRA	 		EQU COMANDOS + 02H		; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO  EQU COMANDOS + 42H		; endereço do comando para selecionar uma imagem de fundo
REPRODUZ_SOM             EQU 605AH        ; comando que inicia a reprodução do audio específicado
MOSTRAR_ECRA			 EQU 6006H		  ; comando que mostra o ecrã específicado
ESCONDER_ECRA			 EQU 6008H		  ; comando que esconde o ecrã específicado
SELECIONA_ECRA			 EQU 6004H		  ; comando que seleciona o ecrã específicado
SELECIONA_MUSICA         EQU 6048H		  ; comando que seleciona a música específicada
COMECAR_MUSICA			 EQU 605CH		  ; comando que faz a música selecionada começar
TERMINA_MUSICA			 EQU 6066H		  ; comando que faz a música selecionada terminar
PAUSA_MUSICA			 EQU 605EH		  ; comando que faz a música selecionada pausar
CONTINUA_MUSICA          EQU 6060H		  ; comando que faz a música selecionda continuar

CENARIO_JOGO EQU 1 ; número do cenário de fundo do jogo
CENARIO_PERDEU EQU 2 ; número do cenário de fundo de quando se perde
CENARIO_MENU EQU 0 ; número do cenário de fundo do menu

SOM_TEMA EQU 0 ; número da música de fundo
SOM_START EQU 1 ; número do som de quando se começa o jogo


N_LINHAS        EQU  32        ; número de linhas do ecrã (altura)
N_COLUNAS       EQU  64        ; número de colunas do ecrã (largura)

LINHA_PNL       EQU 27 ; número da linha onde o painel começa
COLUNA_PNL_I      EQU 25 ; número da linha onde o painel começa
COLUNA_PNL_F      EQU 39 ; número da linha onde o painel termina

COR_PIXEL       EQU 0FF00H     ; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)

DISPLAYS   EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN    EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL    EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)
LINHA      EQU 1       ; linha a testar (1ª linha, 0001b)
MASCARA    EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
LIN_FIN    EQU 8       ; linha final

TECLA_START			     EQU 81H          ; tecla C

; DADOS

PLACE       1000H

; SP inicial do programa
STACK 100H
SP_inicial:

; CODIGO
PLACE 0

inicio:
    MOV  SP, SP_inicial

	MOV  [APAGA_AVISO], R1				; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRA], R1				; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	 R1, CENARIO_MENU							; cenário do menu
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo

    MOV R0, SOM_TEMA                     ; endereço da música de fundo
    MOV  [SELECIONA_MUSICA], R0            ; seleciona a música de fundo
    MOV  [COMECAR_MUSICA], R0              ; começa a música de fundo


menu:
	;CMP  R0, R1							; verifica se a tecla de start foi pressionada
	;JNZ  menu							; se não volta ao ciclo do menu
	;JMP  start							; se foi começa o jogo
    YIELD
    CALL start

start:
	MOV	 R1, CENARIO_JOGO							; cenário de fundo número
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo

    MOV  R0, SOM_TEMA                     ; endereço da música de fundo
    MOV  [SELECIONA_MUSICA], R0            ; seleciona a música de fundo
    MOV  [TERMINA_MUSICA], R0              ; termina a música de fundo

    MOV R0, SOM_START                    ; endereço da música de start
    MOV  [SELECIONA_MUSICA], R0            ; seleciona a música de start
    MOV [REPRODUZ_SOM], R0                 ; reproduz o som de start

fim:
    JMP  fim                 ; termina programa
