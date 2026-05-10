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
; random Y, 20H to 27H
    MOV A, TL1       ; read timer for 8 "random" bits
    ANL A, #007H     ; AND bits with 00000111 so only the last 3 bits are kept (=numbers 0-7)
    ORL A, #020H     ; add 20H to get the correct memory row address
    MOV FoodY, A

; random X, bitmask 01H to 80H
    MOV A, TH1       ; read high timer for a different "random" value
    ANL A, #007H     ; keep only the last 3 bits (number 0-7)
    MOV R2, A        ; store this in R2 as our counter for how many shifts to do
    MOV A, #001H     ; start with the first pixel mask (00000001)

randomXLoop:         ; loop to move the bit to the correct column
    CJNE R2, #000H, doShift ; repeat until counter is 0
    SJMP saveFoodX

doShift:
    RL A             ; rotate the bit one spot to the left
    DEC R2         ; subtract 1 from the shift counter
    SJMP randomXLoop

saveFoodX:
    MOV FoodX, A

; change food location
    MOV Pby, FoodY
    MOV Pbx, FoodX
    LCALL SetPixelFBuffer
    RET