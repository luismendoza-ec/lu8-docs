# Author and License

**Author**: Luis A. Mendoza - Creator of Lu8

This documentation is part of the Lu8 Fantasy Console project. While this documentation serves as a reference for the current implementation and capabilities, please note that the project is under active and continuous development, and the documentation may change accordingly.

## License and Copyright

© 2024 Luis A. Mendoza. All rights reserved.

This documentation and the Lu8 Fantasy Console are original works created by Luis A. Mendoza. The Lu8 system is a fictional console design and implementation that does not correspond to any existing hardware or other projects. This is a closed-source project, and all rights to the design, implementation, and documentation are reserved.

---

# LU8 Memory Map Technical Documentation

## Overview

The LU8 memory system is organized into distinct sections, providing a structured approach to memory management and access.

---

## Memory Layout

### Total Memory Space

* **Size**: 64KB (`0x0000 - 0xFFFF`)
* **Divided into**: 4 primary sections + Flags & I/O

### Memory Sections

#### 1. Code Section (32KB)

* **Range**: `0x0000 - 0x7FFF`
* **Purpose**: Stores system BIOS firmware and executable program instructions
* **Access**: Read / Execute
* **Subsections**:
  - BIOS: `0x0000 - 0x0FFF` (4KB)
  - Cart/Program: `0x1000 - 0x7FFF` (28KB)

#### 2. Data Section (16KB)

* **Range**: `0x8000 - 0xBFFF`
* **Purpose**: General-purpose variable and data storage
* **Access**: Read / Write
* **Special Addresses**:
  - Return Value Address: `0x800F` (Used for function return values)

#### 3. Graphics Section (8KB)

* **Range**: `0xC000 - 0xDFFF`
* **Purpose**: Graphics memory and audio control
* **Access**: Read / Write
* **Subsections**:
  - Sprite Data: `0xC000 - 0xC7FF`
  - Tile Data: `0xC800 - 0xCFFF`
  - Screen Buffer: `0xD000 - 0xD7FF`
  - PPU Control: `0xD800 - 0xD81F`
  - APU Base: `0xD820` (5 channels, 16 bytes each)
  - Palette: `0xD850 - 0xD86F`

#### 4. Stack Section (8KB)

* **Range**: `0xE000 - 0xFFFF`
* **Purpose**: Stack operations and system flags
* **Access**: Read / Write

#### 5. Flags & I/O Section

* **CPU Flags**: `0xFF00 - 0xFF05`
  - Zero Flag (ZF): `0xFF00`
  - Negative Flag (NF): `0xFF01`
  - Carry Flag (CF): `0xFF02`
  - Overflow Flag (OF): `0xFF03`
  - Greater Flag (GF): `0xFF04`
  - Less Flag (LF): `0xFF05`

* **Input Registers**: `0xFF10 - 0xFF18`
  - Player 1 Input: `0xFF10`
  - Player 2 Input: `0xFF11`
  - Player 1 btnp: `0xFF12`
  - Player 2 btnp: `0xFF13`
  - Input Initial Delay: `0xFF14`
  - Input Repeat Interval: `0xFF15`
  - Mouse X Position: `0xFF16`
  - Mouse Y Position: `0xFF17`
  - Mouse Buttons: `0xFF18`

---

## Graphics & Audio Memory Layout (0xC000 - 0xDFFF)

### Graphics Memory Map

| Subsection                | Range             | Size  | Purpose                                |
|--------------------------|-------------------|-------|----------------------------------------|
| Sprite Data              | `0xC000`-`0xC7FF` | 2KB   | Sprite definitions                     |
| Tile Data                | `0xC800`-`0xCFFF` | 2KB   | Tile definitions                       |
| Screen Buffer            | `0xD000`-`0xD7FF` | 2KB   | Framebuffer output                     |
| PPU Control Registers    | `0xD800`-`0xD81F` | 32B   | Drawing control registers              |
| APU Channel Registers    | `0xD820`-`0xD84F` | 48B   | 5 audio channels × 16 bytes each       |
| Color Palette            | `0xD850`-`0xD86F` | 32B   | Color palette data                     |

### PPU Control Registers (0xD800 - 0xD81F)

| Address    | Name        | Purpose                           |
|------------|-------------|-----------------------------------|
| `0xD800`   | `PPU_COLOR` | Current drawing color (0-15)      |
| `0xD801`   | `PPU_BGCLR` | Background clear color            |
| `0xD802`   | `LINE_X1`   | Line start X                      |
| `0xD803`   | `LINE_Y1`   | Line start Y                      |
| `0xD804`   | `LINE_X2`   | Line end X                        |
| `0xD805`   | `LINE_Y2`   | Line end Y                        |
| `0xD806`   | `RECT_X`    | Rectangle top-left X              |
| `0xD807`   | `RECT_Y`    | Rectangle top-left Y              |
| `0xD808`   | `RECT_W`    | Rectangle width                   |
| `0xD809`   | `RECT_H`    | Rectangle height                  |
| `0xD80A`   | `FRECT_X`   | Filled rectangle X                |
| `0xD80B`   | `FRECT_Y`   | Filled rectangle Y                |
| `0xD80C`   | `FRECT_W`   | Filled rectangle width            |
| `0xD80D`   | `FRECT_H`   | Filled rectangle height           |
| `0xD80E`   | `CIRC_X`    | Circle center X                   |
| `0xD80F`   | `CIRC_Y`    | Circle center Y                   |
| `0xD810`   | `CIRC_R`    | Circle radius                     |
| `0xD811`   | `FCIRC_X`   | Filled circle center X            |
| `0xD812`   | `FCIRC_Y`   | Filled circle center Y            |
| `0xD813`   | `FCIRC_R`   | Filled circle radius              |
| `0xD814`-`0xD81F` | Reserved | Reserved for future extensions    |

### APU Channel Layout (0xD820 - 0xD84F)

Each audio channel occupies 16 bytes, with 5 channels total:
- Pulse 1: `0xD820`-`0xD82F`
- Pulse 2: `0xD830`-`0xD83F`
- Triangle: `0xD840`-`0xD84F`
- Noise: `0xD850`-`0xD85F`
- DMC: `0xD860`-`0xD86F`

Channel Register Offsets:
- `+0`: Control
- `+1`: Volume
- `+2`: Sweep
- `+3`: Frequency (Low)
- `+4`: Frequency (High)
- `+5`: Duty
- `+6`: Length
- `+7`: Phase
- `+8`: Sample (DMC only)
- `+9`: Rate (DMC only)
- `+10`: Loop (DMC only)
- `+11`-`+15`: Reserved

---

## Memory Access Types

### Code Section

* Used by the CPU for instruction fetching
* Read/Execute only
* Write operations are discouraged and may be ignored or cause errors
* Protected by memory protection system

### Data Section

* Used by programs for dynamic memory and variables
* Fully readable and writable
* No special protection or restrictions

### Graphics & Audio Section

* Accessible by CPU, PPU, and APU
* Includes video RAM, tile/sprite memory, drawing registers, and APU channel configuration
* Fully readable and writable
* Memory-mapped I/O for hardware access

### Stack Section

* Managed by CPU stack operations (e.g., `PUSH`, `POP`)
* Located in `0xE000` - `0xFFFF`
* Initialized at top (`0xFFFF`), grows downward
* Stack overflow and underflow are detected
* Used for subroutine calls and local variables

### I/O Register Section

* Located in `0xFF00` - `0xFFFF`
* Memory-mapped system registers (e.g., CPU flags, input, indirect VRAM access)
* Access may be read-only, write-only, or read/write depending on the register
* Should not be used for general-purpose data or stack
* Includes system flags and input registers

---

## Special Memory Locations

### System Flags (Status Registers)

| Address  | Description        |
| -------- | ------------------ |
| `0xFF00` | Zero Flag (ZF)     |
| `0xFF01` | Negative Flag (NF) |
| `0xFF02` | Carry Flag (CF)    |
| `0xFF03` | Overflow Flag (OF) |
| `0xFF04` | Greater Flag (GF)  |
| `0xFF05` | Less Flag (LF)     |

### PPU VRAM Access Registers (Indirect)

| Address  | Description               |
| -------- | ------------------------- |
| `0xFF06` | PPUADDR (VRAM addr latch) |
| `0xFF07` | PPUDATA (write to VRAM)   |

### Input Registers

| Address  | Description                                                     |
| -------- | --------------------------------------------------------------- |
| `0xFF10` | Player 1 Input - 8-bit input register (buttons A/B/Select/Start + D-pad) |
| `0xFF11` | Player 2 Input - 8-bit input register (buttons A/B/Select/Start + D-pad) |
| `0xFF12` | Player 1 btnp - 8-bit register for button press detection (emulates PICO-8's btnp) |
| `0xFF13` | Player 2 btnp - 8-bit register for button press detection (emulates PICO-8's btnp) |
| `0xFF14` | Input Initial Delay - Configures initial delay before repeating (in frames, initialized to 15 by BIOS) |
| `0xFF15` | Input Repeat Interval - Configures repeat interval after initial delay (in frames, initialized to 4 by BIOS) |
| `0xFF16` | Mouse X Position - Current X coordinate (0-127) |
| `0xFF17` | Mouse Y Position - Current Y coordinate (0-127) |
| `0xFF18` | Mouse Buttons - 8-bit register for mouse button states (bits 0-2: left, middle, right) |

---

## 🎨 PPU Drawing Control Registers (0xD800–0xD81F)

| Address         | Name        | Purpose                           |
| --------------- | ----------- | --------------------------------- |
| `0xD800`        | `PPU_COLOR` | Current drawing color (0–15)      |
| `0xD801`        | `PPU_BGCLR` | Background clear color (optional) |
| `0xD802`        | `LINE_X1`   | Line start X                      |
| `0xD803`        | `LINE_Y1`   | Line start Y                      |
| `0xD804`        | `LINE_X2`   | Line end X                        |
| `0xD805`        | `LINE_Y2`   | Line end Y                        |
| `0xD806`        | `RECT_X`    | Rectangle top-left X              |
| `0xD807`        | `RECT_Y`    | Rectangle top-left Y              |
| `0xD808`        | `RECT_W`    | Rectangle width                   |
| `0xD809`        | `RECT_H`    | Rectangle height                  |
| `0xD80A`        | `FRECT_X`   | Filled rectangle X                |
| `0xD80B`        | `FRECT_Y`   | Filled rectangle Y                |
| `0xD80C`        | `FRECT_W`   | Filled rectangle width            |
| `0xD80D`        | `FRECT_H`   | Filled rectangle height           |
| `0xD80E`        | `CIRC_X`    | Circle center X                   |
| `0xD80F`        | `CIRC_Y`    | Circle center Y                   |
| `0xD810`        | `CIRC_R`    | Circle radius                     |
| `0xD811`        | `FCIRC_X`   | Filled circle center X            |
| `0xD812`        | `FCIRC_Y`   | Filled circle center Y            |
| `0xD813`        | `FCIRC_R`   | Filled circle radius              |
| `0xD814–0xD81F` | —           | Reserved for future extensions    |


## 🎨 Color Palette Memory (0xD850–0xD88F)

The LU8 system uses a 16-color fixed index palette (`0–15`). Each index can be dynamically modified at runtime via memory-mapped writes to this region.

| Range         | Description                       |
| ------------- | --------------------------------- |
| `0xD850`      | Red component of color index 0    |
| `0xD851`      | Green component of color index 0  |
| `0xD852`      | Blue component of color index 0   |
| `0xD853`      | Red component of color index 1    |
| `0xD854`      | Green component of color index 1  |
| `0xD855`      | Blue component of color index 1   |
| ...           | ...                               |
| `0xD88D`      | Red component of color index 15   |
| `0xD88E`      | Green component of color index 15 |
| `0xD88F`      | Blue component of color index 15  |

### 📦 Total size: 48 bytes  
Each color index is composed of 3 bytes: R (Red), G (Green), B (Blue).

### 🧠 Usage Notes:
- Writing to these addresses will immediately update the color used for that palette index.
- Valid values per channel: `0x00–0xFF`
- This allows the BIOS to load a default palette, and game cartridges to override it.

### 💡 Example in ASM:
```asm
; Set palette index 3 to bright yellow (#FFFF00)
MOV [0xD859], 255 ; Red
MOV [0xD85A], 255 ; Green
MOV [0xD85B], 0   ; Blue
```