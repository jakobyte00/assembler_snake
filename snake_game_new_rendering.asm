ORG 000H
Ze0 DATA 020H
Ze1 DATA 021H
Ze2 DATA 022H
Ze3 DATA 023H
Ze4 DATA 024H
Ze5 DATA 025H
Ze6 DATA 026H
Ze7 DATA 027H
SJMP Innit
; # macht aus adresse zahl
;Ab 20 für meine daten, wenn @ nur R0 und R1
Innit:
MOV Ze0, #080h
MOV Ze1, #018h
MOV Ze2, #008h
MOV Ze3, #010h
SJMP Main

Main:
SJMP Render
SJMP Main

Render:
;Initialize row index to the first row
MOV R0, #020h ;(Ze0)
;Put voltage on the first row
MOV R1, #080h
SJMP RenderLoop

RenderLoop:
;Cut power to all previous LEDs
MOV P1, #000h
;Load next line data
MOV P0, @R0
;Load next power aligment
MOV P1, R1
;Increment row index for rendering:
INC R0
;Bit-Shift active voltage by one postion
;Save power aligment to Accu
MOV A, R1
MOV B, #002h
DIV AB
MOV R1, A
;Check whether the last row has been rendered and we need to return to zero
LCALL CheckLR
SJMP RenderLoop

CheckLR: ;Check if the last row has been reached and reset if true
MOV A, R0
CJNE A, #028h, Return
MOV R1, #080h
MOV R0, #020h
RET

Return: ;Mapping function
RET

Stop:
SJMP $
END
