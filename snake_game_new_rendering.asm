ORG 000H
;Image row adresses
Ze0 DATA 020H
Ze1 DATA 021H
Ze2 DATA 022H
Ze3 DATA 023H
Ze4 DATA 024H
Ze5 DATA 025H
Ze6 DATA 026H
Ze7 DATA 027H
;Rendering
Powy DATA 028H
Powx DATA 029H
;Pixel buffer (x|y)
Pby DATA 030H
Pbx DATA 031H

SJMP Innit
Innit:
MOV Pby, #026h
MOV Pbx, #002h
MOV Ze0, #080h
MOV Ze1, #018h
MOV Ze2, #008h
MOV Ze3, #010h
SJMP Main

SetPixelFBuffer:
MOV R1, Pby
MOV A, @R1
MOV B, Pbx
ORL A, B
MOV @R1, A
RET

DelPixelFBuffer:
MOV R1, Pby
MOV A, @R1
MOV B, Pbx
SUBB A, B
MOV @R1, A
RET

Main:
LCALL SetPixelFBuffer
LCALL DelPixelFBuffer
SJMP Render
SJMP Main

Render:
;Initialize row index to the first row
MOV Powx, #020h ;(Ze0)
;Put voltage on the first row
MOV Powy, #080h
SJMP RenderLoop

RenderLoop:
MOV R0, Powx
;Cut power to all previous LEDs
MOV P1, #000h
;Load next line data
MOV P0, @R0
;Load next power aligment
MOV P1, Powy
;Increment row index for rendering:
INC R0
Mov Powx, R0
;Bit-Shift active voltage by one postion
;Save power aligment to Accu
MOV A, Powy
MOV B, #002h
DIV AB
MOV Powy, A
;Check whether the last row has been rendered and we need to return to zero
LCALL CheckLR
SJMP RenderLoop

CheckLR: ;Check if the last row has been reached and reset if true
MOV A, Powx
CJNE A, #028h, Return
MOV Powy, #080h
MOV Powx, #020h
RET

Return: ;Mapping function
RET

Stop:
SJMP $
END
