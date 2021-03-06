ORG 100H

;MICE.COM
;PRINT THE ROW COLUMN OF PRIMARY MOUSE BUTTON CLICK
;THE INDEX BEGIN IN 1
;TESTED OK ON FREEDOS, WINDOWS XP X86, WINDOWS 7 X86
;THE OUTPUT CAN BE REDIRECTED TO FILE, THEN RUN IT
;AND HAVE THE INFO IN THE ENVIRONMENT VARIABLE CLICK
;ONLY ALLOW PRIMARY MOUSE BUTTON CLICK
;PROGRAMMED BY CARLOS MONTIERS AGUILERA

MOV AX,0001H
INT 33H ;SHOW MOUSE CURSOR

MOV AX,0005H
XOR BX,BX ;LEFT BUTTON
INT 33H ;RESET COUNT OF BUTTON PRESSED

GET_CLICK:
MOV AX,0005H
XOR BX,BX ;LEFT BUTTON
INT 33H ;RETURN MOUSE BUTTON PRESS INFO
CMP AX,0001H ;PRESSED DOWN
JNE GET_CLICK ;IF NO TRY AGAIN
CMP BX,0H ;IF BUTTON PRESSED 0 TIMES SINCE LAST CALL THE INFO IS NOT REALIABLE
JE GET_CLICK ;TRY AGAIN

;ADJUST THE DATA
SHR DX,0003H ;DX=DX>>3 ROW
SHR CX,0003H ;CX=CX>>3 COLUMN
INC DX ;1 INDEX BASE
INC CX ;1 INDEX BASE

;PRINT TEXT SET CLICK=
PUSH DX
MOV AH,9H
MOV DX,SET_CLICK
INT 21H
POP DX

MOV AX,DX ;DX ROW
CALL PRINTAX

;PRINT SPACE
MOV AH,06H ;DIRECT CONSOLE OUTPUT
MOV DL,20H
INT 21H

MOV AX,CX ;CX COLUMN
CALL PRINTAX

;PRINT NL
MOV AH,06H ;DIRECT CONSOLE OUTPUT
MOV DL,0DH
INT 21H
MOV DL,0AH
INT 21H

MOV AX,4C00H
INT 21H ;TERMINATE PROCESS RETURNING 0

;;PRINT THE CONTENT OF AX IN DECIMAL NOTATION
;PROGRAMMED BY CARLOS MONTIERS AGUILERA
PRINTAX:
PUSH AX
PUSH BX
PUSH CX
PUSH DX
MOV BX,0AH ;WILL DIVIDE BY 10
XOR CL,CL ;CL = 0 COUNTER OF CHARACTERS
STORE_CHARACTER:
XOR DX,DX ;DX = 0
DIV BX ;DIVIDE DX:AX BY BX
;AX = QUOTIENT
;DX = REMAINDER
ADD DL,30H ;SUM '0'
PUSH DX ;STORE THE DL CHARACTER IN THE STACK
INC CL ;INC COUNTER OF CHARACTERS
CMP AX,0H
JNZ STORE_CHARACTER
MOV AH,06H ;DIRECT CONSOLE OUTPUT
PRINT_CHARACTER:
POP DX ;GET CHARACTER
INT 21H
DEC CL
CMP CL,0H
JNZ PRINT_CHARACTER
POP DX
POP CX
POP BX
POP AX
RET

SET_CLICK DB 'SET CLICK= ' , 24H
