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

;check if snake eats
LCALL checkEat
JC skipDelTailL ; Jump to the L-specific exit door

LCALL RemoveTail

skipDelTailL:
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

;check if snake eats
LCALL checkEat
JC skipDelTailR ; Jump to the R-specific exit door

LCALL RemoveTail

skipDelTailR:
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

;check if snake eats
LCALL checkEat
JC skipDelTailU ; Jump to the U-specific exit door

LCALL RemoveTail

skipDelTailU:
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

;check if snake eats
LCALL checkEat
JC skipDelTailD ; Jump to the D-specific exit door

LCALL RemoveTail

skipDelTailD:
RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RemoveTail:
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

checkEat:
;Check if head at food location
MOV A, Pbx;
CJNE A, FoodX, skipEating
;if X coords don't match skip to tail deletion

MOV A, Pby;
CJNE A, FoodY, skipEating
;if Y coords don't match skip to tail deletion

LCALL spawnFood

SETB C ;carry bit to skip tail deletion
RET

skipEating:
CLR C
RET

spawnFood:
;eat food logic
;generate new random coordinate

;change food location