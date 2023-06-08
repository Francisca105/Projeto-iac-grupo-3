FRONTAL EQU 6046H

COMANDOS				    EQU	6000H       ; endereço de base dos comandos do MediaCenter

APAGA_ECRA                  EQU COMANDOS    ; comando que apaga todos os pixéis de um ecrã específico
APAGA_ECRAS                 EQU 6002H       ; comando que apaga todos os pixéis de todos os ecrãs
SELECIONA_ECRA              EQU 6004H       ; comando que seleciona o ecrã a ser utilizado
MOSTRA_ECRA                 EQU 6006H       ; comando que mostra o ecrã especificado
APAGA_CENARIO_FRONTAL       EQU 6044H       ; comando que apaga o cenário frontal
SELECIONA_CENARIO_FRONTAL   EQU 0046H       ; comando que seleciona o cenário frontal
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

MEMORIA EQU 8000H

inicio:
    MOV     [APAGA_AVISO], R0				; apaga o aviso de nenhum cenário selecionado
    MOV     [APAGA_ECRAS], R0				; apaga todos os pixels
	MOV	    R0, 0				; cenário do menu
    MOV     [DEFINE_CENARIO], R0            ; seleciona o cenário de fundo


    MOV     R0, 4				; cenário frontal
    MOV     [FRONTAL], R0

    MOV     [APAGA_CENARIO_FRONTAL], R0

end: JMP end