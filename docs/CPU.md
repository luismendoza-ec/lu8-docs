# CPU Documentation

## Note
This documentation is a work in progress and may change as the project evolves. Features, syntax, and behavior are subject to revision during development.

## Frame Timing
The CPU operates at a configurable clock speed (default 3 MHz) and targets 60 FPS. The number of cycles per frame is calculated as:
```
cyclesPerFrame = clockSpeedHz / 60
```

For example:
- At 1 MHz: 16,666 cycles per frame
- At 2 MHz: 33,333 cycles per frame
- At 3 MHz: 50,000 cycles per frame

## Instructions

### Control Flow
- `NOP` (0x00): No operation
- `JMP addr` (0x04): Jump to address
- `JNZ addr` (0x06): Jump to address if last comparison was not zero

### Memory Operations
- `MOV [dest], src` (0x01): Move value from source to destination
- `ADD [dest], src` (0x02): Add source to destination
- `SUB [dest], src` (0x03): Subtract source from destination
- `CMP a, b` (0x05): Compare two values, sets flags (ZF, GF, LF)

### Graphics (Using PPU Control Registers 0xD800-0xD81F)
- `PSET` (0x80): Draw pixel using RECT_X (0xD806), RECT_Y (0xD807)
- `CLS` (0x81): Clear screen using PPU_BGCLR (0xD801)
- `SETCOLOR` (0x82): Set drawing color from PPU_COLOR (0xD800)
- `LINE` (0x83): Draw line using LINE_X1/Y1/X2/Y2 (0xD802-0xD805)
- `RECT` (0x84): Draw rectangle using RECT_X/Y/W/H (0xD806-0xD809)
- `FILLRECT` (0x85): Fill rectangle using FRECT_X/Y/W/H (0xD80A-0xD80D)
- `CIRCLE` (0x86): Draw circle using CIRC_X/Y/R (0xD80E-0xD810)
- `FILLCIRCLE` (0x87): Fill circle using FCIRC_X/Y/R (0xD811-0xD813)

### Frame Control
- `VSYNC` (0xFE): Signal end of frame

## Memory Map
- 0x0000-0x0FFF: BIOS code (4KB, read/execute only)
- 0x1000-0x7FFF: Program code (28KB)
- 0x8000-0xBFFF: Data section (16KB)
- 0xC000-0xDFFF: Graphics section (8KB)
  - 0xC000-0xC7FF: Sprite data (2KB)
  - 0xC800-0xCFFF: Tile data (2KB)
  - 0xD000-0xD7FF: Screen buffer (2KB)
  - 0xD800-0xDFFF: PPU control registers (2KB)
- 0xE000-0xFFFF: Stack section (8KB)

### System Flags
- 0xFF00: Zero Flag (ZF)
- 0xFF01: Negative Flag (NF)
- 0xFF02: Carry Flag (CF)
- 0xFF03: Overflow Flag (OF)
- 0xFF04: Greater Flag (GF)
- 0xFF05: Less Flag (LF)

### Immediate Values
Any value in the range `0xFE00`–`0xFEFF` is treated as an 8-bit **immediate constant** (0–255).
- Example: `MOV [0x8000], 0xFE05` stores the constant `5` into memory
- In contrast: `MOV [0x8000], [0x8005]` copies a value from memory

For detailed PPU control register documentation, see MEMORY.md.

### Basic Instructions

| Mnemonic | Opcode | Description                         | Format                            | Cycles |
|----------|--------|-------------------------------------|-----------------------------------|--------|
| `NOP`    | 0x00   | No operation                        | `NOP`                             | 1      |
| `MOV`    | 0x01   | Move `[src]` or `immediate` → `[dest]` | `MOV [dest], [src]` / `MOV [dest], 42` | 5 |
| `ADD`    | 0x02   | Add `[src]` to `[dest]`             | `ADD [dest], [src]`               | 5      |
| `SUB`    | 0x03   | Subtract `[src]` from `[dest]`      | `SUB [dest], [src]`               | 5      |
| `MUL`    | 0x0E   | Multiply `[dest]` by `[src]`        | `MUL [dest], [src]`               | 5      |
| `DIV`    | 0x0F   | Divide `[dest]` by `[src]`          | `DIV [dest], [src]`               | 5      |
| `MOD`    | 0x1D   | Modulo of `[dest]` by `[src]`       | `MOD [dest], [src]`               | 5      |
| `AND`    | 0x10   | Bitwise AND `[src]` with `[dest]`   | `AND [dest], [src]`               | 5      |
| `OR`     | 0x11   | Bitwise OR `[src]` with `[dest]`    | `OR [dest], [src]`                | 5      |
| `XOR`    | 0x12   | Bitwise XOR `[src]` with `[dest]`   | `XOR [dest], [src]`               | 5      |
| `NOT`    | 0x13   | Bitwise NOT of `[dest]`             | `NOT [dest]`                      | 3      |
| `SHL`    | 0x14   | Shift `[dest]` left by `[src]` bits | `SHL [dest], [src]`               | 5      |
| `SHR`    | 0x15   | Shift `[dest]` right by `[src]` bits| `SHR [dest], [src]`               | 5      |
| `RND`    | 0x1B   | Write random number to `[dest]`     | `RND [dest]`                      | 3      |
| `TICK`   | 0x1C   | Write system tick to `[dest]`       | `TICK [dest]`                     | 3      |
| `LOG`    | 0x1E   | Output value at `[addr]` to logger  | `LOG [addr]`                      | 3      |
| `INC`    | 0x07   | Increment value at `[addr]` by 1    | `INC [addr]`                      | 3      |
| `DEC`    | 0x08   | Decrement value at `[addr]` by 1    | `DEC [addr]`                      | 3      |
| `JZ`     | 0x09   | Jump if Zero Flag is set            | `JZ addr`                         | 3      |
| `JEQ`    | 0x0A   | Alias for JZ                        | `JEQ addr`                        | 3      |
| `JNEQ`   | 0x0B   | Jump if ZF is clear                 | `JNEQ addr`                       | 3      |
| `JG`     | 0x0C   | Jump if Greater Flag is set         | `JG addr`                         | 3      |
| `JL`     | 0x0D   | Jump if Less Flag is set            | `JL addr`                         | 3      |
| `JGE`    | 0x20   | Jump if Greater or Equal            | `JGE addr`                        | 3      |
| `CALL`   | 0x16   | Call subroutine (push PC, jump)       | `CALL addr`                        | 5      |
| `RET`    | 0x17   | Return from subroutine                | `RET`                              | 5      |
| `PUSH`   | 0x18   | Push value at `[src]` to stack        | `PUSH [src]`                       | 3      |
| `POP`    | 0x19   | Pop stack into `[dest]`               | `POP [dest]`                       | 3      |
| `MEMCPY` | 0x1F   | Copy N bytes from `[src]` to `[dest]` | `MEMCPY [dest], [src], len`        | 10+N   |
| `HLT`    | 0xFF   | Halt execution until reset            | `HLT`                              | 1      |

### Control Flow

| Mnemonic | Opcode | Description                     | Format       | Cycles |
|----------|--------|---------------------------------|--------------|--------|
| `JMP`    | 0x04   | Jump unconditionally            | `JMP label`  | 3      |
| `CMP`    | 0x05   | Compare `[a]` and `[b]`, set ZF | `CMP [a], [b]` | 5    |
| `JNZ`    | 0x06   | Jump if Zero Flag is not set    | `JNZ label`  | 3      |
| `JGE`    | 0x20   | Jump if Greater or Equal (GF or ZF) | `JGE label` | 3    |
| `CALL`   | 0x16   | Call subroutine, push PC              | `CALL addr`   | 5 |
| `RET`    | 0x17   | Return from subroutine (pop PC)       | `RET`         | 5 |
| `HLT`    | 0xFF   | Halt CPU execution                    | `HLT`         | 1 |

### Graphics Operations (PPU mapped)

| Mnemonic   | Opcode | Description                    | Format  | Cycles |
|------------|--------|--------------------------------|---------|--------|
| `PSET`     | 0x80   | Plot pixel at `[0x8000],[0x8001]` | `PSET` | 1      |
| `CLS`      | 0x81   | Clear screen (black or `[0x8004]`) | `CLS` | 1      |
| `COLOR`    | 0x82   | Set draw color from `[0xFF04]`   | `COLOR`| 1      |
| `LINE`     | 0x83   | Line from `[0xFF05]-[0xFF08]`    | `LINE` | 1      |
| `RECT`     | 0x84   | Outline rectangle               | `RECT` | 1      |
| `RECTFILL` | 0x85   | Filled rectangle                | `RECTFILL` | 1  |
| `CIRC`     | 0x86   | Outline circle                  | `CIRC` | 1      |
| `CIRCFILL` | 0x87   | Filled circle                   | `CIRCFILL` | 1  |

## Execution Model

- **Fixed time step**: 60 frames per second
- **Clock speed**: 2 MHz
- **Cycles per frame**: 33,333
- **Instruction pipeline**: Single-cycle dispatch (no pipelining)
- **Synchronizer**: Linked to system clock via `performance.now()` or SDL ticks
- **No registers**: all logic operates on RAM
- **Subroutines**: `CALL` pushes the return address to stack; `RET` restores it
- **System halt**: `HLT` stops execution; requires manual `reset()` to resume
- **BIOS execution**: System starts at BIOS entry point (0x0000)
- **Memory protection**: BIOS region is write-protected

## Memory Protection & Validation

- BIOS region (0x0000-0x0FFF) is read/execute only
- Program code must reside in 0x1000–0x7FFF
- Stack grows only within 0xE000–0xFFFF
- Invalid memory access triggers runtime error
- I/O ports (0xFF00+) are mapped with read/write guards

## Addressing Modes

- `[addr]`: Memory reference
- `0xFE00–0xFEFF`: Immediate constant
- `0xFF00–0xFF05`: System flags (read/write memory-mapped)

## Performance Characteristics

| Attribute             | Value      |
|-----------------------|------------|
| Clock Speed           | 2 MHz      |
| Cycles per Frame      | 33,333     |
| Frame Rate            | 60 FPS     |
| Instruction Latency   | 1–5 cycles |
| Stack Access          | Safe       |
| Memory Access         | Uncached   |

## Debug Features

- **Tick counter**: tracks total CPU cycles
- **PC monitor**: shows current program counter
- **SP monitor**: shows stack pointer
- **Flags view**: read flags from `0xFF00–0xFF03`
- **Breakpoint support** (optional, in debugger)
- **Instruction logging** (in debug builds)

