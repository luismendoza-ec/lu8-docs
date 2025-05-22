# Author and License

**Author**: Luis A. Mendoza - Creator of Lu8

This documentation is part of the Lu8 Fantasy Console project. While this documentation serves as a reference for the current implementation and capabilities, please note that the project is under active and continuous development, and the documentation may change accordingly.

## License and Copyright

© 2024 Luis A. Mendoza. All rights reserved.

This documentation and the Lu8 Fantasy Console are original works created by Luis A. Mendoza. The Lu8 system is a fictional console design and implementation that does not correspond to any existing hardware or other projects. This is a closed-source project, and all rights to the design, implementation, and documentation are reserved.

---

# LU8 Assembly Language Technical Documentation

## Overview

The LU8 assembly language is a custom low-level language designed for the LU8 Virtual Machine. It offers a human-readable interface to the VM's bytecode instruction set, suitable for writing game logic, graphics commands, and control flow.

---

## Instruction Set

### Basic Operations

#### `NOP` (0x00)

* No operation.
* **Usage**: `NOP`
* **Cycles**: 1

#### `MOV` (0x01)

* Move data from a memory address or an immediate value into a memory address.
* **Usage**:
  * `MOV [dest], [src]`
  * `MOV [dest], immediate`
* **Example**:
  * `MOV [0x8000], [0x8001]`
  * `MOV [0x8000], 64`
* **Cycles**: 5

### Arithmetic Operations

#### `ADD` (0x02)

* Adds the value at `[src]` to `[dest]` and stores the result in `[dest]`.
* **Usage**: `ADD [dest], [src]` or `ADD [dest], immediate`
* **Example**: `ADD [0x8000], [0x8001]`
* **Cycles**: 5

#### `SUB` (0x03)

* Subtracts the value at `[src]` from `[dest]` and stores the result in `[dest]`.
* **Usage**: `SUB [dest], [src]` or `SUB [dest], immediate`
* **Example**: `SUB [0x8000], [0x8001]`
* **Cycles**: 5

#### `INC` (0x07)

* Increments the value at `[addr]` by 1.
* Sets ZF if result is zero.
* **Usage**: `INC [addr]`
* **Example**: `INC [0x8000]`
* **Cycles**: 3

#### `DEC` (0x08)

* Decrements the value at `[addr]` by 1.
* Sets ZF if result is zero.
* **Usage**: `DEC [addr]`
* **Example**: `DEC [0x8000]`
* **Cycles**: 3

#### `NEG` (0x1A)

* Negates the value at `[addr]` using **two's complement** (`-x & 0xFF`).
* Stores the result back in `[addr]`.
* Sets:

  * `ZF` (Zero Flag) if result is `0`
  * `NF` (Negative Flag) if result has the high bit set (bit 7)
* **Usage**: `NEG [addr]`
* **Example**:

  ```asm
  MOV [0x8000], 5
  NEG [0x8000] ; becomes 251 (0xFB)
  LOG [0x8000] ; logs 251
  ```
* **Cycles**: 3
* **Note**: All values in LU8 are treated as **unsigned 8-bit**, but `NEG` performs two's complement math to support arithmetic logic (e.g., for `SUB`).

#### `MUL` (0x0E)

* Multiplies the value at `[dest]` by `[src]` and stores the result in `[dest]`.
* Sets ZF if result is zero.
* **Usage**: `MUL [dest], [src]` or `MUL [dest], immediate`
* **Example**: `MUL [0x8000], 2`
* **Cycles**: 5

#### `DIV` (0x0F)

* Divides the value at `[dest]` by `[src]` and stores the result in `[dest]`.
* Sets ZF if result is zero.
* Halts execution if division by zero is attempted.
* **Usage**: `DIV [dest], [src]` or `DIV [dest], immediate`
* **Example**: `DIV [0x8000], 2`
* **Cycles**: 5

#### `MOD` (0x1D)

* Calculates the modulo (remainder) of `[dest]` divided by `[src]` and stores the result in `[dest]`.
* Sets ZF if result is zero.
* Halts execution if division by zero is attempted.
* **Usage**: `MOD [dest], [src]` or `MOD [dest], immediate`
* **Example**:
  ```asm
  MOV [0x8000], 10
  MOV [0x8001], 3
  MOD [0x8000], [0x8001] ; 10 % 3 = 1, stores 1 in 0x8000
  ```
* **Cycles**: 5

### Bitwise Operations

#### `AND` (0x10)

* Performs a bitwise AND between the values at `[dest]` and `[src]`, storing the result in `[dest]`.
* Sets ZF if result is zero.
* **Usage**: `AND [dest], [src]` or `AND [dest], immediate`
* **Example**: `AND [0x8000], 0xFF`
* **Cycles**: 5

#### `OR` (0x11)

* Performs a bitwise OR between the values at `[dest]` and `[src]`, storing the result in `[dest]`.
* Sets ZF if result is zero.
* **Usage**: `OR [dest], [src]` or `OR [dest], immediate`
* **Example**: `OR [0x8000], 0x0F`
* **Cycles**: 5

#### `XOR` (0x12)

* Performs a bitwise XOR between the values at `[dest]` and `[src]`, storing the result in `[dest]`.
* Sets ZF if result is zero.
* **Usage**: `XOR [dest], [src]` or `XOR [dest], immediate`
* **Example**: `XOR [0x8000], 0xFF`
* **Cycles**: 5

#### `NOT` (0x13)

* Performs a bitwise NOT on the value at `[dest]`, storing the result in `[dest]`.
* Sets ZF if result is zero.
* **Usage**: `NOT [dest]`
* **Example**: `NOT [0x8000]`
* **Cycles**: 3

#### `SHL` (0x14)

* Shifts the bits in `[dest]` left by the number of positions specified in `[src]`.
* Shift amount is limited to 0-7 bits.
* Sets ZF if result is zero.
* **Usage**: `SHL [dest], [src]` or `SHL [dest], immediate`
* **Example**: `SHL [0x8000], 1`
* **Cycles**: 5

#### `SHR` (0x15)

* Shifts the bits in `[dest]` right by the number of positions specified in `[src]`.
* Shift amount is limited to 0-7 bits.
* Sets ZF if result is zero.
* **Usage**: `SHR [dest], [src]` or `SHR [dest], immediate`
* **Example**: `SHR [0x8000], 1`
* **Cycles**: 5

### Control Flow

#### `JMP` (0x04)

* Jump unconditionally to an address.
* **Usage**: `JMP label` or `JMP 0x1234`
* **Cycles**: 3

#### `CMP` (0x05)

* Compare values at two memory addresses.
* Sets ZF, GF, LF.
* **Usage**: `CMP [addr1], [addr2]` or `CMP [addr1], immediate`
* **Cycles**: 5

#### `JNZ` (0x06)

* Jump if Zero Flag is NOT set.
* **Usage**: `JNZ label`
* **Cycles**: 3

#### `JZ` (0x09)

* Jump if Zero Flag is set.
* **Usage**: `JZ label`
* **Cycles**: 3

#### `JEQ` (0x0A)

* Alias for JZ - Jump if Equal.
* **Usage**: `JEQ label`
* **Cycles**: 3

#### `JNEQ` (0x0B)

* Jump if Not Equal (Zero Flag is clear).
* **Usage**: `JNEQ label`
* **Cycles**: 3

#### `JG` (0x0C)

* Jump if Greater Flag is set.
* **Usage**: `JG label`
* **Cycles**: 3

#### `JL` (0x0D)

* Jump if Less Flag is set.
* **Usage**: `JL label`
* **Cycles**: 3

#### `JGE` (0x20)

* Jump if Greater or Equal (GF is set OR ZF is set).
* **Usage**: `JGE label`
* **Example**:
  ```asm
  CMP [0x8000], [0x8001] ; Compare values
  JGE greater_or_equal   ; Jump if first value >= second value
  ```
* **Cycles**: 3

#### `JLE` (0x23)

* Jump if Less or Equal (`LF` is set **OR** `ZF` is set).
* **Usage**: `JLE label`
* **Example**:
  ```asm
  CMP [0x8000], [0x8001] ; Compare values
  JLE less_or_equal      ; Jump if first value <= second value
```
* **Cycles**: 3

### Stack and Subroutine Instructions

#### `CALL` (0x16)

* Calls a subroutine at the specified address.
* Pushes return address to the stack.
* **Usage**: `CALL label` or `CALL 0x1234`
* **Cycles**: 5

#### `RET` (0x17)

* Returns from a subroutine.
* Pops the return address and jumps to it.
* **Usage**: `RET`
* **Cycles**: 5

#### `PUSH` (0x18)

* Pushes the value at the specified address (or immediate) to the stack.
* **Usage**: `PUSH [addr]` or `PUSH immediate`
* **Cycles**: 3

#### `POP` (0x19)

* Pops the value from the stack into the specified address.
* **Usage**: `POP [addr]`
* **Cycles**: 3

### Memory Operations

#### `MEMCPY` (0x1F)

* Copies a block of memory from `[src]` to `[dest]`, for `len` bytes.
* `len` can be an address or immediate.
* **Usage**: `MEMCPY [dest], [src], len`
* **Cycles**: 10 + N

#### `MEMSET` (0x22)

* Sets a block of memory to a specific value.
* **Usage**: `MEMSET [dest], value, len`
* **Example**: `MEMSET [0x8000], 0, 16` ; Clear 16 bytes
* **Cycles**: 5 + N

### System Operations

#### `RND` (0x21)

* Writes a random number between 0 and 255 to `[dest]`.
* Sets ZF if result is zero.
* **Usage**: `RND [dest]`
* **Cycles**: 3

#### `TICK` (0x1C)

* Stores current system tick count (low 8 bits) into `[dest]`.
* **Usage**: `TICK [dest]`
* **Cycles**: 3

#### `LOG` (0x1E)

* Logs a value to the host console for debugging.
* Accepts either a memory address or an immediate value.
* 
* **Usage**:  
  - `LOG [addr]` → logs the value stored at memory address  
  - `LOG 42` → logs the immediate value `42`

* **Cycles**: 3


### Graphics Operations

#### `PSET` (0x80)

* Draw a pixel at position specified by RECT_X, RECT_Y with current PPU_COLOR
* **Usage**: `PSET`
* **Registers**: 
  * `0xD806` (RECT_X): X coordinate
  * `0xD807` (RECT_Y): Y coordinate
  * `0xD800` (PPU_COLOR): Current color
* **Cycles**: 1

#### `CLS` (0x81)

* Clears the screen using PPU_BGCLR
* **Usage**: `CLS`
* **Registers**:
  * `0xD801` (PPU_BGCLR): Background color
* **Cycles**: 1

#### `SETCOLOR` (0x82)

* Sets the current drawing color by writing to `PPU_COLOR`.
* Accepts either an immediate value (`0–15`) or a memory address containing the color.
* **Usage**:
  * `SETCOLOR 6` → sets color 6
  * `SETCOLOR [0x8000]` → sets color from memory at 0x8000
* **Writes to**:
  * `0xD800` (PPU_COLOR)
* **Cycles**: 2

#### `LINE` (0x83)

* Draws a line using LINE registers
* **Usage**: `LINE`
* **Registers**:
  * `0xD802` (LINE_X1): Start X
  * `0xD803` (LINE_Y1): Start Y
  * `0xD804` (LINE_X2): End X
  * `0xD805` (LINE_Y2): End Y
* **Cycles**: 1

#### `RECT` (0x84)

* Draws a rectangle outline using RECT registers
* **Usage**: `RECT`
* **Registers**:
  * `0xD806` (RECT_X): Top-left X
  * `0xD807` (RECT_Y): Top-left Y
  * `0xD808` (RECT_W): Width
  * `0xD809` (RECT_H): Height
* **Cycles**: 1

#### `FILLRECT` (0x85)

* Draws a filled rectangle using FRECT registers
* **Usage**: `FILLRECT`
* **Registers**:
  * `0xD80A` (FRECT_X): Top-left X
  * `0xD80B` (FRECT_Y): Top-left Y
  * `0xD80C` (FRECT_W): Width
  * `0xD80D` (FRECT_H): Height
* **Cycles**: 1

#### `CIRCLE` (0x86)

* Draws a circle outline using CIRC registers
* **Usage**: `CIRC`
* **Registers**:
  * `0xD80E` (CIRC_X): Center X
  * `0xD80F` (CIRC_Y): Center Y
  * `0xD810` (CIRC_R): Radius
* **Cycles**: 1

#### `FILLCIRCLE` (0x87)

* Draws a filled circle using FCIRC registers
* **Usage**: `FILLCIRCLE`
* **Registers**:
  * `0xD811` (FCIRC_X): Center X
  * `0xD812` (FCIRC_Y): Center Y
  * `0xD813` (FCIRC_R): Radius
* **Cycles**: 1

#### `RSTPAL` (0x88)

* Restores the Lu8 default palette (inspired by PICO-8).
* Resets all 16 palette colors to their original RGB values.
* Useful when you want to undo runtime palette changes.
* **Usage**: `RSTPAL`
* **Cycles**: 1
* **Note**: This affects rendering immediately.

```asm
; Example: Restore palette and clear screen
RSTPAL
MOV [0xD801], 0    ; Black background
CLS
```

#### `VSYNC` (0xFE)

* Signal end of frame
* **Usage**: `VSYNC`
* **Cycles**: 1

#### `HALT` (0xFF)

* Halts CPU execution permanently.
* The VM will stop ticking once this instruction is executed.
* **Usage**: `HALT`
* **Cycles**: 1
* **Note**: After `HALT` is called, the program stops and will not resume unless the VM is reset or restarted.

** Example **
``àsm
    ...
    VSYNC
    HALT
```

---

## Syntax Rules

### Labels

* Must end with a colon `:`
* Used as jump targets
* **Example**:

  ```asm
  main_loop:
      JMP main_loop
  ```

### Memory References

* Use square brackets for memory addresses
* **Example**: `[0x8000]`

### Immediate Values

* Raw numeric values without brackets
* **Example**: `MOV [0x8000], 64`

### Comments

* Use `;` or `//` for single-line comments
* Everything after the symbol is ignored
* **Example**:

  ```asm
  MOV [0x8000], 64 ; set x position
  ```

---

## Assembler Features

* Two-pass label resolution
* Label usage before definition is allowed
* Immediate and memory value detection
* Syntax error checking with meaningful messages
* Inline comment stripping
* Clean and flat bytecode output for the LU8 VM

---

## Memory Map

### Data Section (0x8000-0xBFFF)
* General purpose data storage
* Variables and game state

### Graphics Section (0xC000-0xDFFF)
* `0xC000-0xC7FF`: Sprite data
* `0xC800-0xCFFF`: Tile data
* `0xD000-0xD7FF`: Screen buffer
* `0xD800-0xDFFF`: PPU control registers

### System Flags (0xFF00-0xFF05)
* `0xFF00`: Zero Flag (ZF)
* `0xFF01`: Negative Flag (NF)
* `0xFF02`: Carry Flag (CF)
* `0xFF03`: Overflow Flag (OF)
* `0xFF04`: Greater Flag (GF)
* `0xFF05`: Less Flag (LF)

---

## Example

```asm
; Draw a red pixel
; Data Section:
; 0x8000: ball_x (logic position)
; 0x8001: ball_dx (direction)

; PPU Registers:
; 0xD800: PPU_COLOR (drawing color)
; 0xD806: RECT_X (drawing position X)
; 0xD807: RECT_Y (drawing position Y)

start:
    MOV [0x8000], 64     ; logic_x = 64
    MOV [0xD806], 64     ; RECT_X = 64
    MOV [0xD807], 64     ; RECT_Y = 64
    MOV [0x8001], 1      ; dx = 1

main_loop:
    CLS
    SETCOLOR 8 ; color red, same as:  MOV [0xD800], 8
    PSET
    VSYNC
    HALT
```
