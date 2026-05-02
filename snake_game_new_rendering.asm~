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
Headidx DATA 032H
Tailidx DATA 033H
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
    ; --- 1. NEUEN KOPF BERECHNEN ---
    ; Aktuellen Kopf aus dem Puffer auslesen
    MOV A, #50H     ; Basis-Adresse X-Array
    ADD A, HeadIdx  ; Aktuellen Kopf-Index addieren
    MOV R0, A       ; R0 zeigt jetzt auf X-Wert des Kopfes
    MOV A, @R0      ; A = Aktuelle X-Maske
    MOV B, #002h
    MUL AB          ; Multiplizieren = Verschiebung nach links
    MOV Pbx, A      ; Neuen X-Wert in Pbx merken

    MOV A, #40H     ; Basis-Adresse Y-Array
    ADD A, HeadIdx
    MOV R0, A       ; R0 zeigt jetzt auf Y-Wert des Kopfes
    MOV A, @R0      ; A = Aktuelle Y-Adresse 
    MOV Pby, A      ; Neuen Y-Wert in Pby merken (bleibt gleich bei MoveL)

    ; --- 2. NEUEN KOPF IM PUFFER SPEICHERN ---
    ; HeadIdx erhöhen (mit automatischem Überlauf bei 16)
    MOV A, HeadIdx
    INC A
    ANL A, #0FH     ; Hält den Index streng zwischen 0 und 15 (Modulo 16)
    MOV HeadIdx, A

    ; Neue Werte in den Ringpuffer schreiben
    MOV A, #50H
    ADD A, HeadIdx
    MOV R0, A
    MOV A, Pbx
    MOV @R0, A      ; X-Maske in neuen Head-Slot geschrieben

    MOV A, #40H
    ADD A, HeadIdx
    MOV R0, A
    MOV A, Pby
    MOV @R0, A      ; Y-Adresse in neuen Head-Slot geschrieben

    ; --- 3. NEUEN KOPF ZEICHNEN ---
    LCALL SetPixelFBuffer

    ; --- 4. ALTEN SCHWANZ LÖSCHEN ---
    ; Alte Schwanz-Koordinaten aus dem Puffer lesen
    MOV A, #50H
    ADD A, TailIdx
    MOV R0, A
    MOV A, @R0
    MOV Pbx, A      ; Maske des Schwanzes

    MOV A, #40H
    ADD A, TailIdx
    MOV R0, A
    MOV A, @R0
    MOV Pby, A      ; Y-Adresse des Schwanzes

    ; Schwanz vom Bildschirm löschen
    LCALL DelPixelFBuffer

    ; --- 5. SCHWANZ-POINTER WEITERSCHIEBEN ---
    ; Der alte Schwanz ist gelöscht, das nächste Glied ist jetzt der Schwanz
    MOV A, TailIdx
    INC A
    ANL A, #0FH     ; Wrap-around 0-15
    MOV TailIdx, A

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
LJMP RenderLoop

CheckLR: ;Check if the last row has been reached and reset if true
MOV A, Powx
CJNE A, #028h, Return
MOV Powy, #080h
MOV Powx, #020h
LCALL MoveL
RET

Return: ;Mapping function
RET

Stop:
SJMP $
END
