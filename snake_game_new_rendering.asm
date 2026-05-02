ORG 000H

;Image row adresses (y):
Ze0 DATA 020H
Ze1 DATA 021H
Ze2 DATA 022H
Ze3 DATA 023H
Ze4 DATA 024H
Ze5 DATA 025H
Ze6 DATA 026H
Ze7 DATA 027H
;Rendering buffer:
Powy DATA 028H
Powx DATA 029H
;Pixel buffer (x|y):
Pby DATA 030H
Pbx DATA 031H
;Snake haed and tail indices
HeadIdx DATA 032H
TailIdx DATA 033H
;Snake pixels ring buffer
;y-coordinates from 40H to 4FH
;x-coordinates from 50H to 5FH

SJMP Innit

Innit:
;Draw initial snake
MOV Ze3, #00Ch
MOV Ze4, #004h
;Save initial snake to ring buffer
MOV 42H, #023h
MOV 52H, #008h
MOV 41H, #023h
MOV 51H, #004h
MOV 40H, #024h
MOV 50H, #004h
;Save initial indices
MOV Headidx, #002h
MOV Tailidx, #000h

SJMP Main

SetPixelFBuffer:
MOV R1, Pby
MOV A, @R1
MOV B, Pbx
ORL A, B
MOV @R1, A
RET

DelPixelFBuffer:
MOV A, Pbx
CPL A
MOV R1, Pby
ANL A, @R1
MOV @R1, A
RET

MoveL:
;Read current head y and x
MOV A, #50H
ADD A, HeadIdx
MOV R0, A
MOV A, @R0
MOV B, #002h
MUL AB
MOV Pbx, A

MOV A, #40H
ADD A, HeadIdx
MOV R0, A
MOV A, @R0
MOV Pby, A

;Increment head index
MOV A, HeadIdx
INC A
ANL A, #0FH     ; Hält den Index streng zwischen 0 und 15 (Modulo 16)
MOV HeadIdx, A

;Add new head to screen
MOV A, #50H
ADD A, HeadIdx
MOV R0, A
MOV A, Pbx
MOV @R0, A

MOV A, #40H
ADD A, HeadIdx
MOV R0, A
MOV A, Pby
MOV @R0, A

LCALL SetPixelFBuffer

;Delete old tail from screen
MOV A, #50H
ADD A, TailIdx
MOV R0, A
MOV A, @R0
MOV Pbx, A

MOV A, #40H
ADD A, TailIdx
MOV R0, A
MOV A, @R0
MOV Pby, A

LCALL DelPixelFBuffer

;Move head
MOV A, TailIdx
INC A
ANL A, #0FH     ; Wrap around 0-15
MOV TailIdx, A

RET


Main:
LCALL MoveL
LCALL Render
SJMP Main

Render:
;Initialize row index to the first row
MOV Powx, #020h ;(Ze0)
;Put voltage on the first row
MOV Powy, #080h

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

;Check if the last row has been reached and reset if true
MOV A, Powx
CJNE A, #028h, RenderLoop
RET

Return: ;Mapping function
RET

Stop:
SJMP $
END
