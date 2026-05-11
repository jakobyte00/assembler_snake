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
;Timers that need to pass for the next game tick
TimersToPass DATA 034H
;Direction the snake is currently facing at
;#1-left,#2-right,#3-up,#4-down
DirecFacing DATA 035H
;Direction desired by the Player
DesiredDirec DATA 036H