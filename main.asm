ORG 000H
LJMP Innit
;Hardware timer interuppt
ORG 000BH
LJMP Timer0_IR

$INCLUDE (definitions.asm)
$INCLUDE (snake.asm)
$INCLUDE (render.asm)

Innit:
;Reset input
MOV P2, #0F0h;#070h
;Set initial direction
;MOV DirecFacing, #001h
;MOV DesiredDirec, #001h
;Draw initial snake
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
MOV HeadIdx, #002h
MOV TailIdx, #000h
;Set initial tick counter to 10
MOV TimersToPass, #001h;#00Ah

LCALL spawnFood
;Set initial direction to left
;MOV DirecFacing, #001h
;Set TimerMode for Timer0 and Timer1 to 1
MOV TMOD, #011h
;Set the hight and low bits (16 Bits therefore two registers) for timer0
;One tick is 1 micro second since 500 ms (intended duration does not fit into 16 bit)
;The timer will go down 10 times before a tick. Therfore one countdown is 50,000 mirco secs
;The 16 bits can hold 65,535 numbers, so for an overflow 65,536 is needed
;--> 50,000 ticks to every overflow 65,536-50,000=15,536 as initial value
MOV TH0, #0F8H;#03CH
MOV TL0, #000H;#03CH
;Enable interrupts globally and the timer interrupts
MOV IE, #82H
;Start timer0 and timer 1
SETB TR0
SETB TR1

SJMP Main

Timer0_IR:
;Save context to stack
PUSH ACC
PUSH PSW
PUSH B
PUSH 00H
PUSH 01H
;Reload timer values
MOV TH0, #0F8H
MOV TL0, #000H
;Decrease timer counter
DJNZ TimersToPass, End_IR
;If 0 timers left, reset to 10 and execute movement
MOV TimersToPass, #001h

;Valitdation logiv: Prevent 180 turns
MOV A, DesiredDirec
CJNE A, #001H, CheckR
;Check what the snake is currently doing
MOV A, DirecFacing
;If not moving Right, the turn is allowed
CJNE A, #002H, ApplyNew
;Otherwise: Ignore input, keep old direction
SJMP ExecuteMove
CheckR:
MOV A, DesiredDirec
;If not Right, check if Up
CJNE A, #002H, CheckU
MOV A, DirecFacing
CJNE A, #001H, ApplyNew ;If not moving Left, the turn is allowed
SJMP ExecuteMove

CheckU:
MOV A, DesiredDirec
;If not Up, check if Down
CJNE A, #003H, CheckD
MOV A, DirecFacing
;If not moving Down, the turn is allowed
CJNE A, #004H, ApplyNew
SJMP ExecuteMove

CheckD:
MOV A, DesiredDirec
CJNE A, #004H, ExecuteMove
MOV A, DirecFacing
CJNE A, #003H, ApplyNew
SJMP ExecuteMove

ApplyNew:
;Update the actual movement direction
MOV DirecFacing, DesiredDirec

;Actually move the snake
ExecuteMove:
MOV A, DirecFacing
CJNE A, #001H, TryRight1
LCALL MoveL
SJMP End_IR
TryRight1:
CJNE A, #002H, TryUp1
LCALL MoveR
SJMP End_IR
TryUp1:
CJNE A, #003H, TryDown1
LCALL MoveU
SJMP End_IR
TryDown1:
CJNE A, #004H, End_IR
LCALL MoveD
SJMP End_IR

End_IR:
;Retun context from stack
POP 01H
POP 00H
POP B
POP PSW
POP ACC
RETI

Main:
LCALL Render
MOV A, P2
CJNE A, #070H, TryRight
MOV DesiredDirec, #001h
SJMP Main
TryRight:
CJNE A, #0E0H, TryUp
MOV DesiredDirec, #002h
SJMP Main
TryUp:
CJNE A, #0B0H, TryDown
MOV DesiredDirec, #003h
SJMP Main
TryDown:
CJNE A, #0D0H, Main
MOV DesiredDirec, #004h
SJMP Main

Stop:
CLR TR0

MOV Ze0, #081H
MOV Ze1, #042H
MOV Ze2, #024H
MOV Ze3, #018H
MOV Ze4, #018H
MOV Ze5, #024H
MOV Ze6, #042H
MOV Ze7, #081H

StopLoop:
LCALL Render
SJMP StopLoop

END
