ORG 000H
LJMP Innit

$INCLUDE (definitions.asm)
$INCLUDE (snake.asm)
$INCLUDE (render.asm)

Innit:
;Reset input
MOV P2, #070h
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

SJMP Main

Main:
LCALL Render
MOV A, P2
CJNE A, #070H, TryRight
LJMP MoveL
TryRight:
CJNE A, #0E0H, TryUp
;LJMP MoveR
TryUp:
CJNE A, #0B0H, TryDown
;LJMP MoveU
TryDown:
CJNE A, #0D0H, Main
;LJMP MoveD

Stop:
SJMP $
END
