# Snake - 8051 Assembly

Classic Snake on an 8×8 LED matrix, written entirely in 8051 assembly. The snake moves on a hardware timer interrupt, food spawns pseudo-randomly using the free-running Timer1, and the game ends with an X on the display when you hit a wall.

## How it works

Movement is driven by Timer0 in 16-bit mode, overflowing roughly every 2 ms. A countdown (`TimersToPass`) sits in front of the actual move so the effective game tick is slower than the interrupt rate — changing that value changes the speed. The snake body is a 16-slot circular ring buffer; head and tail indices chase each other around it. Eating food skips the tail-delete step for that tick, growing the snake by one segment. 180-degree reversals are filtered in the ISR: if the desired direction is exactly opposite the current one, the input is ignored.

The display is multiplexed row-by-row out of an 8-byte frame buffer (Ze0–Ze7 at 0x20–0x27). Each byte is a column bitmask - bit 7 is the leftmost LED. The render loop runs continuously in the main loop between input polls, so there's no tearing from the ISR firing mid-frame in practice.

Food position comes from reading TH1 and TL1 at spawn time. If the position lands on the snake body, it loops and tries again.

## Files

| File              | Content                                                             |
| ----------------- | ------------------------------------------------------------------- |
| `main.asm`        | Entry point, init, Timer0 ISR, input polling loop, game-over screen |
| `snake.asm`       | MoveL/R/U/D, food spawning, eat detection, tail removal             |
| `render.asm`      | Frame buffer → LED matrix output                                    |
| `definitions.asm` | All named memory addresses                                          |

## Memory map

| Symbol        | Address   | Purpose                                                  |
| ------------- | --------- | -------------------------------------------------------- |
| Ze0–Ze7       | 0x20–0x27 | Frame buffer (one byte per row)                          |
| Powy / Powx   | 0x28–0x29 | Row-select bitmask / row pointer used during rendering   |
| Pby / Pbx     | 0x30–0x31 | Scratch row address / column bitmask for pixel ops       |
| HeadIdx       | 0x32      | Ring buffer head index (0–15)                            |
| TailIdx       | 0x33      | Ring buffer tail index (0–15)                            |
| TimersToPass  | 0x34      | ISR countdown before next game tick                      |
| DirecFacing   | 0x35      | Direction the snake is actually moving (1=L 2=R 3=U 4=D) |
| DesiredDirec  | 0x36      | Last direction pressed by the player                     |
| Snake Y ring  | 0x40–0x4F | Row addresses for each of the 16 ring buffer slots       |
| Snake X ring  | 0x50–0x5F | Column bitmasks for each of the 16 ring buffer slots     |
| FoodY / FoodX | 0x70–0x71 | Current food position                                    |

## Controls (P2, active-low encoded)

| P2 value | Direction |
| -------- | --------- |
| 0x70     | Left      |
| 0xE0     | Right     |
| 0xB0     | Up        |
| 0xD0     | Down      |

## Setup (mcu8051ide)

### 1. Load the project

Open mcu8051ide and use _Project → Open_ to load `Group Project.mcu8051ide`. The assembler source files are already referenced inside it.

### 2. Add virtual hardware and load configs

Open the Virtual Hardware panel (_Virtual HW_). Add an **LED Matrix** component and load `display.vhc` as its configuration. Then add a **Simple Keypad** component and load `input_linear.vhc` as its configuration. Both configs set up the correct port mappings for P0/P1 (display) and P2 (keypad). After that, compile and run at max speed.
