# Author and License

**Author**: Luis A. Mendoza - Creator of Lu8

This documentation is part of the Lu8 Fantasy Console project. While this documentation serves as a reference for the current implementation and capabilities, please note that the project is under active and continuous development, and the documentation may change accordingly.

## License and Copyright

© 2024 Luis A. Mendoza. All rights reserved.

This documentation and the Lu8 Fantasy Console are original works created by Luis A. Mendoza. The Lu8 system is a fictional console design and implementation that does not correspond to any existing hardware or other projects. This is a closed-source project, and all rights to the design, implementation, and documentation are reserved.

---

# CPU Documentation

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
- `JZ addr` (0x09): Jump to address if Zero Flag is set
- `JEQ addr` (0x0A): Alias for JZ
- `JNEQ addr` (0x0B): Jump if Zero Flag is clear
- `JG addr` (0x0C): Jump if Greater Flag is set
- `JL addr` (0x0D): Jump if Less Flag is set
- `JGE addr` (0x20): Jump if Greater or Equal (GF or ZF)
- `JLE addr` (0x23): Jump if Less or Equal (LF or ZF)

### Memory Operations
- `MOV [dest], src` (0x01): Move value from source to destination
- `ADD [dest], src` (0x02): Add source to destination
- `SUB [dest], src` (0x03): Subtract source from destination
- `CMP a, b` (0x05): Compare two values, sets flags (ZF, GF, LF)
- `INC [addr]` (0x07): Increment value at address
- `DEC [addr]` (0x08): Decrement value at address
- `MUL [dest], src` (0x0E): Multiply destination by source
- `DIV [dest], src` (0x0F): Divide destination by source
- `MOD [dest], src` (0x1D): Modulo of destination by source
- `AND [dest], src` (0x10): Bitwise AND
- `OR [dest], src` (0x11): Bitwise OR
- `XOR [dest], src` (0x12): Bitwise XOR
- `NOT [dest]` (0x13): Bitwise NOT
- `SHL [dest], src` (0x14): Shift left (0-7 bits)
- `SHR [dest], src` (0x15): Shift right (0-7 bits)
- `MEMCPY [dest], [src], len` (0x1F): Copy memory block
- `MEMSET [dest], value, len` (0x22): Set memory block

### Stack Operations
- `CALL addr` (0x16): Call subroutine
- `RET` (0x17): Return from subroutine
- `PUSH [addr]` (0x18): Push value to stack
- `POP [addr]` (0x19): Pop value from stack

### System Operations
- `RND [dest]` (0x21): Write random number (0-255)
- `TICK [dest]` (0x1C): Write system tick count
- `LOG [addr|value]` (0x1E): Log memory value or immediate for debugging

### Graphics (Using PPU Control Registers 0xD800-0xD81F)
- `PSET` (0x80): Draw pixel using RECT_X (0xD806), RECT_Y (0xD807)
- `CLS` (0x81): Clear screen using PPU_BGCLR (0xD801)
- `SETCOLOR` (0x82): Set drawing color to PPU_COLOR (0xD800)
- `LINE` (0x83): Draw line using LINE_X1/Y1/X2/Y2 (0xD802-0xD805)
- `RECT` (0x84): Draw rectangle using RECT_X/Y/W/H (0xD806-0xD809)
- `FILLRECT` (0x85): Fill rectangle using FRECT_X/Y/W/H (0xD80A-0xD80D)
- `CIRCLE` (0x86): Draw circle using CIRC_X/Y/R (0xD80E-0xD810)
- `FILLCIRCLE` (0x87): Fill circle using FCIRC_X/Y/R (0xD811-0xD813)
- `RSTPAL` (0x88): Restore the Lu8 default palette (PICO-8 inspired)
- `DRAWCHAR` (0x89): Draw character from font data

### Frame Control
- `VSYNC` (0xFE): Signal end of frame
- `HALT` (0xFF): Stop CPU execution

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

## Execution Model

- **Fixed time step**: 60 frames per second
- **Clock speed**: Configurable (default 3 MHz)
- **Cycles per frame**: Calculated as clockSpeedHz / 60
- **Instruction pipeline**: Single-cycle dispatch (no pipelining)
- **Synchronizer**: Linked to system clock via `performance.now()`
- **No registers**: all logic operates on RAM
- **Subroutines**: `CALL` pushes the return address to stack; `RET` restores it
- **System halt**: `HALT` stops execution; requires manual `reset()` to resume
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
| Clock Speed           | Configurable (default 3 MHz) |
| Cycles per Frame      | clockSpeedHz / 60 |
| Frame Rate            | 60 FPS     |
| Instruction Latency   | 1–5 cycles |
| Stack Access          | Safe       |
| Memory Access         | Uncached   |

## Debug Features

- **Tick counter**: tracks total CPU cycles
- **PC monitor**: shows current program counter
- **SP monitor**: shows stack pointer
- **Flags view**: read flags from `0xFF00–0xFF05`
- **Breakpoint support** (optional, in debugger)
- **Instruction logging** (in debug builds)

