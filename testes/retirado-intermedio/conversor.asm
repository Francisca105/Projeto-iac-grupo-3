;*************************************************
; CONVERSOR 
; Descrição: Conversor de hexdecimal para decimal.
; Entradas:  -------------------
; Saídas:    -------------------
;*************************************************

converte_hex:
	PUSH    R0
	PUSH    R1
	PUSH    R2
	PUSH    R4
	PUSH    R5
	PUSH    R6
	PUSH    R7

	MOV     R6, 0					        ; Inicializa a 0 o valor em decimal
	MOV     R5, 10H					        ; Valor da divisão - 16
	MOV     R4, 0AH					        ; valor da divisão - 10
								
	MOV     R7, 16H					        ; Define a base para a conversão, 16
	JMP     converte_loop                   ; Inicia o ciclo de conversão

letra_detetada:
	MOV     R7, 1						    ; Sinaliza que uma letra foi encontrada
	JMP     retirar_letras2

converte_loop:
	MOV     R0, R3						    ; Move o valor a ser convertido para R0
									
	MOD     R0, R5						    ; Calcula o resto da divisão por 16
	DIV     R3, R5						    ; Divide o valor por 16

	MOV     R1, R0						    ; Move o resto da divisão para R1
	MOD     R1, R4						    ; Calcula o resto da divisão por 10
	DIV     R0, R4						    ; Divide o valor por 10
	
	MUL     R0, R5                          ; Multiplica o valor por 16

	ADD     R6, R1			                ; Adiciona o resto da divisão por 10 ao valor em decimal			
	ADD     R6, R0

	CMP     R3, 0                           ; Verifica se o valor a ser convertido é 0
	JZ      retirar_letras_inicio           ; Se for, passa para a próxima fase da conversão

converte_segunda_passagem:
	MOV     R1, 2
	MOV     R2, 5

	MOV     R0, R3                          ; Move o valor a ser convertido para R0
	DIV     R0, R1                          ; Divide o valor por 2
	ADD     R0, R3                          ; Adiciona o valor original ao resultado da divisão por 2
	MUL     R0, R5                          ; Multiplica o valor por 16
	ADD     R0, R3                          ; Adiciona o valor original ao resultado da multiplicação por 16
	MOD     R3, R1                          ; Calcula o resto da divisão por 2
	MUL     R3, R2                          ; Multiplica o resto da divisão por 5
	ADD     R0, R3                          ; Adiciona o valor original ao resultado da multiplicação por 5

	ADD     R6, R0						

retirar_letras_inicio:						
	MOV     R3, R6					    	
	MOV     R6, 0						    ; O novo output começa a 0
	MOV     R2, 1						    ; Inicializa o multiplicador a 1
	MOV     R7, 0						    ; Inicializa o sinalizador de letras a 0

retirar_letras:
	MOV     R0, R3					        ; Move o valor a ser convertido para R0	
									
	MOD     R0, R5						    ; O último digito do input
	DIV     R3, R5						    ; Os restantes dígitos do input

	MOV     R1, R0						    ; Adicionar mais um registo com o valor do último dígito do input
	MOD     R1, R4						    ; Ultimo digito em decimal
	DIV     R0, R4						    ; Primeiro dígito em decimal

	MUL     R0, R5

	CMP     R0, 0	                        ; Verifica se o valor é 0					
	JNZ     letra_detetada				    ; Se não for, passa para a próxima fase da conversão

retirar_letras2:
	MUL     R0, R2						    ; Multiplica o valor por 1
	MUL     R1, R2                          ; Multiplica o resto por 1   

	ADD     R6, R1						    ; Adicionar os dois ao valor acumulado
	ADD     R6, R0
	
	MUL     R2, R5
	CMP     R3, 0						    ; Verifica se o valor a ser convertido é 0
	JNZ     retirar_letras   			    ; Se não, continuar loop
	

converte_fim:
	MOV     R3, R6						    ; Coloca o valor do output no registo pretendido
	CMP     R7, 0						    ; Verifica se alguma letra foi detetada
    JNZ     retirar_letras_inicio		    ; se sim, voltar a retirar letras

	POP     R7
	POP     R6
	POP     R5
	POP     R4
	POP     R2
	POP     R1
    POP     R0
	RET
