PLACE 1000H

STACK 100H
SP_p:

STACK 100H
SP_p1:

LOCKZINHO:
    LOCK 0

tab:
    WORD 0
    WORD interrupcao

PLACE 0

inicio:
    MOV SP, SP_p
    MOV BTE, tab
    EI1
    EI
    JMP processo1

interrupcao:
    MOV [LOCKZINHO], R3
    RFE

PROCESS SP_p1
processo1:
    MOV R1, [LOCKZINHO]
    JMP fim


fim:
    JMP fim