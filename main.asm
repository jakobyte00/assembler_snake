ORG 000H
SJMP Innit

$INCLUDE (definitions.asm)
$INCLUDE (snake.asm)
$INCLUDE (render.asm)

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
MOV HeadIdx, #002h
MOV TailIdx, #000h

SJMP Main


Main:
LCALL MoveL
LCALL Render
SJMP Main

Stop:
SJMP $
END
