COMANDOS				EQU	6000H			; endereço de base dos comandos do MediaCenter
MEMORIA_ECRA	 EQU	8000H	; endereço de base da memória do ecrã
APAGA_ECRA	 			EQU COMANDOS + 02H		; endereço do comando para apagar todos os pixels já desenhados
APAGA_AVISO     		EQU COMANDOS + 40H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
SELECIONA_MUSICA         EQU 6048H		  ; comando que seleciona a música específicada
REPRODUZ_SOM             EQU 605AH        ; comando que inicia a reprodução do audio específicado

DEFINE_LINHA    		EQU COMANDOS + 0AH		; endereço do comando para definir a linha
DEFINE_COLUNA   		EQU COMANDOS + 0CH		; endereço do comando para definir a coluna
DEFINE_PIXEL    		EQU COMANDOS + 12H		; endereço do comando para escrever um pixel

N_LINHAS        EQU  32        ; número de linhas do ecrã (altura)
N_COLUNAS       EQU  64        ; número de colunas do ecrã (largura)

SOM_LASER EQU 2

COR_VERMELHO       EQU 0FF00H	; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)
COR_APAGADO     EQU 0000H	; cor para apagar um pixel: todas as componentes a 0

ATRASO_SONDA    EQU 1	; atraso entre cada pixel desenhado (em ciclos de relógio)

PLACE       1000H

; SP inicial do MediaCenter
STACK 100H
SP_inicial_sonda:

PLACE 0 
MOV SP, SP_inicial_sonda

inicio:
    MOV  [APAGA_AVISO], R1	; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRA], R1	; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
    CALL sonda


PROCESS SP_inicial_sonda

sonda:
    MOV R0, SOM_LASER                    ; endereço do som do laser
    MOV  [SELECIONA_MUSICA], R0            ; seleciona o som
    MOV [REPRODUZ_SOM], R0                 ; reproduz o som

    MOV R1, 26 ; linha inicial
    MOV R2, 32 ; coluna inicial
    MOV R3, COR_VERMELHO ; cor do pixel inicial (vermelho)
    CALL desenha_sonda

desenha_sonda:
    MOV R6, R1 ; copia a linha atual
    MOV [DEFINE_LINHA], R1 ; define a linha atual
    MOV [DEFINE_COLUNA], R2 ; define a coluna atual
    MOV [DEFINE_PIXEL], R3 ; desenha o pixel atual
    MOV R11, ATRASO_SONDA ; espera um pouco

apaga_sonda:
    MOV R3, COR_APAGADO ; apaga o pixel atual
    MOV R6, R2 ; copia a coluna atual
    MOV [DEFINE_LINHA], R1 ; define a linha atual
    MOV [DEFINE_COLUNA], R2 ; define a coluna atual
    MOV [DEFINE_PIXEL], R3 ; apaga o pixel atual

ciclo_atraso_sonda:
    SUB R11, 1
    JNZ ciclo_atraso_sonda

linha_sonda_seguinte:
    MOV R3, COR_VERMELHO ; cor do pixel inicial (vermelho)
    SUB R1, 1 ; linha anterior
    CMP R1, 0
    JNZ desenha_sonda

fim:
    JMP fim ; termina o programa