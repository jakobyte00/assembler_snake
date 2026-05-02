Render:
    MOV Powx, #020H
    MOV Powy, #080H
RenderLoop:
    MOV R0, Powx
    MOV P1, #000H
    MOV P0, @R0
    MOV P1, Powy
    INC R0
    MOV Powx, R0
    MOV A, Powy
    MOV B, #002H
    DIV AB
    MOV Powy, A
    MOV A, Powx
    CJNE A, #028H, RenderLoop
    RET