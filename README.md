# Snake Game — 8051 Assembly

A Snake game implemented in 8051 assembly language. The game runs on an 8051-compatible microcontroller, renders on an 8×8 LED matrix display, and is controlled by four directional buttons. Movement is driven by a hardware timer interrupt, and the snake state is maintained in a circular ring buffer in internal RAM.

## Hardware

| Component | Connection        | Notes                          |
| --------- | ----------------- | ------------------------------ |
| MCU       | 8051-compatible   | e.g. AT89S52                   |
| Display   | 8×8 LED matrix    | Multiplexed row-by-row         |
| P0        | Row pixel data    | One bit per column (bitmask)   |
| P1        | Row select        | One bit set, shifted 0x80→0x01 |
| P2        | Directional input | Active-low encoded             |
| Timer0    | Game tick         | 16-bit mode, ~2 ms period      |

### Button encoding (P2)

| Value | Direction |
| ----- | --------- |
| 0x70  | Left      |
| 0xE0  | Right     |
| 0xB0  | Up        |
| 0xD0  | Down      |

## Project Structure

```text
main.asm        — Entry point, hardware init, Timer0 ISR, main input loop
snake.asm       — Movement routines (MoveL/R/U/D), SetPixelFBuffer, DelPixelFBuffer
render.asm      — Frame buffer → LED matrix output loop
definitions.asm — Named constants for all memory-mapped variables
```

## Memory Layout

| Symbol       | Address   | Purpose                                             |
| ------------ | --------- | --------------------------------------------------- |
| Ze0–Ze7      | 0x20–0x27 | Frame buffer (one byte per row, one bit per column) |
| Powy         | 0x28      | Current row-select bitmask during rendering         |
| Powx         | 0x29      | Current frame buffer row pointer during rendering   |
| Pby          | 0x30      | Pixel-op target row address                         |
| Pbx          | 0x31      | Pixel-op column bitmask                             |
| HeadIdx      | 0x32      | Ring buffer head index (0–15)                       |
| TailIdx      | 0x33      | Ring buffer tail index (0–15)                       |
| TimersToPass | 0x34      | ISR countdown ticks before next game tick           |
| DirecFacing  | 0x35      | Current direction (1=L, 2=R, 3=U, 4=D)              |
| Snake Y ring | 0x40–0x4F | Row address for each of the 16 snake segments       |
| Snake X ring | 0x50–0x5F | Column bitmask for each of the 16 snake segments    |

## Architecture

### Frame Buffer

Eight bytes at `Ze0`–`Ze7` (0x20–0x27) represent the display. Each byte is a column bitmask for that row: bit 7 = leftmost column, bit 0 = rightmost. Setting or clearing a bit lights or extinguishes the corresponding LED.

### Snake Ring Buffer

Snake segment positions are stored in a 16-slot circular buffer. Y-coordinates (row addresses pointing into the Ze0–Ze7 frame buffer) live at 0x40–0x4F; X-coordinates (column bitmasks) live at 0x50–0x5F. `HeadIdx` and `TailIdx` are indices into this buffer, wrapped with `ANL A, #0Fh` to keep them in range. Maximum snake length is 16 segments.

### Timer0 ISR

Timer0 runs in 16-bit mode (TMOD = 0x01) with an initial value of 0xF800, producing an overflow every 2048 µs. On each interrupt the counter `TimersToPass` is decremented; when it reaches zero it is reset and the movement routine for the current direction is called. Adjusting the initial `TimersToPass` value controls game speed.

### Render Loop

`Render` (render.asm) scans Ze0–Ze7 sequentially. For each row it writes the row pixel data to P0 and the row-select bitmask to P1 (starting at 0x80, halved each step via `DIV AB, #2`). This is called on every iteration of the main loop, producing a continuously refreshed display.

### Input

The main loop polls P2 on every iteration and updates `DirecFacing` accordingly. The ISR reads `DirecFacing` at the start of each game tick to determine which movement routine to call. The snake does not move at all until a button is pressed (default `DirecFacing = 0` matches no direction).

## Movement Logic

All four `MoveX` routines in `snake.asm` follow the same steps:

1. Read the current head position (row address + column bitmask) from the ring buffer at `HeadIdx`.
2. Compute the new head position:
   - **MoveL**: multiply X bitmask by 2 (`MUL AB`) — shifts the set bit left
   - **MoveR**: divide X bitmask by 2 (`DIV AB`) — shifts the set bit right
   - **MoveU**: increment the row address (higher address = higher row)
   - **MoveD**: decrement the row address
3. Increment `HeadIdx` (wrapped), write the new position into the ring buffer.
4. Call `SetPixelFBuffer` to OR the new column bit into the target frame buffer row.
5. Read the tail position at `TailIdx`, call `DelPixelFBuffer` to AND-NOT the column bit out of the frame buffer.
6. Increment `TailIdx` (wrapped).

## Initial State

On startup (`Innit`) the snake is placed as three segments spanning rows Ze3–Ze4 at column bit 0x04, pre-loaded into ring buffer slots 0–2. `HeadIdx` starts at 2 and `TailIdx` at 0. The timer is started immediately; movement begins once the user presses a direction button.
