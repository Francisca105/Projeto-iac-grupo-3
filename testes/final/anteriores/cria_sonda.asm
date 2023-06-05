
cria_sonda:
    MOV     R11, SOM_LASER                  ; endereço do som do laser
    MOV     [DEFINE_SOM_OU_VIDEO], R11      ; seleciona o som
    MOV     [INICIA_REPRODUCAO], R11        ; reproduz o som

    MOV     R11, ECRA_SONDA_DIR
    MOV     [SELECIONA_ECRA], R11
    
    PUSH    R0
    PUSH    R2
    PUSH    R3
    PUSH    R6
    PUSH    R11

    MOV     R0, POS_SONDAS
    ADD     R0, 4
    ADD     R0, 4
    MOV     R2, R0
    MOV     R2, [R2]
    MOV     R3, R0
    ADD     R3, 2
    MOV     R3, [R3]
    MOV     R6, COR_SONDA

    CALL    desenha_pixel

    MOV     R11, ON
    MOV     R0, SONDAS
    MOV     R1, 12
    ADD     R0, R1
    MOV     [R0], R11
    
    POP    R11
    POP     R6
    POP     R3
    POP     R2
    POP     R0


    RET