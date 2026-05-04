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
;Read current head x and y
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

;Move head pointer
MOV A, HeadIdx
INC A
ANL A, #0FH
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

;Move tail pointer
MOV A, TailIdx
INC A
ANL A, #0FH;Wrap around 0-15
MOV TailIdx, A

RET

MoveR:
;Read current head x and y
MOV A, #50H
ADD A, HeadIdx
MOV R0, A
MOV A, @R0
MOV B, #002h
DIV AB;Divide by 2 to shift bit right
MOV Pbx, A

MOV A, #40H
ADD A, HeadIdx
MOV R0, A
MOV A, @R0
MOV Pby, A

;Move head pointer
MOV A, HeadIdx
INC A
ANL A, #0FH
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

;Move tail pointer
MOV A, TailIdx
INC A
ANL A, #0FH;Wrap around 0-15
MOV TailIdx, A

RET

MoveU:
;Read current head x and y
MOV A, #50H
ADD A, HeadIdx
MOV R0, A
MOV A, @R0
MOV Pbx, A

MOV A, #40H
ADD A, HeadIdx
MOV R0, A
MOV A, @R0
INC A;Increase Y variable
MOV Pby, A

;Move head pointer
MOV A, HeadIdx
INC A
ANL A, #0FH
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

;Move tail pointer
MOV A, TailIdx
INC A
ANL A, #0FH;Wrap around 0-15
MOV TailIdx, A

RET

MoveD:
;Read current head x and y
MOV A, #50H
ADD A, HeadIdx
MOV R0, A
MOV A, @R0
MOV Pbx, A;Keep X mask exactly the same

MOV A, #40H
ADD A, HeadIdx
MOV R0, A
MOV A, @R0
DEC A;Decrease Y variable
MOV Pby, A

;Move head pointer
MOV A, HeadIdx
INC A
ANL A, #0FH
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

;Move tail pointer
MOV A, TailIdx
INC A
ANL A, #0FH;Wrap around 0-15
MOV TailIdx, A

RET
