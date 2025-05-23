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
* **Divided into**: 6 primary sections

### Memory Sections

#### 1. BIOS Section (4KB)

* **Range**: `0x0000 - 0x0FFF`
* **Purpose**: Stores system BIOS firmware
* **Access**: Read / Execute only (Write protected)
* **Notes**: 
  - Loaded automatically on system reset
  - Cannot be overwritten by programs
  - Contains essential system routines
  - Protected by memory protection system

#### 2. Code Section (28KB)

* **Range**: `0x1000 - 0x7FFF`
* **Purpose**: Stores executable program instructions
* **Access**: Read / Execute
* **Notes**:
  - Programs are loaded starting at `0x1000`
  - Space after BIOS for user programs
  - Maximum program size is 28KB

#### 3. Data Section (16KB)

* **Range**: `0x8000 - 0xBFFF`
* **Purpose**: General-purpose variable and data storage
* **Access**: Read / Write
* **Notes**:
  - Used for program variables and game state
  - Fully accessible for read/write operations

#### 4. Graphics & Audio Section (8KB)

* **Range**: `0xC000 - 0xDFFF`
* **Purpose**: Graphics memory (sprites, tiles, framebuffer), drawing registers, and APU audio channels
* **Access**: Read / Write
* **Notes**:
  - Memory-mapped I/O for PPU and APU
  - Direct access to framebuffer and control registers

#### 5. Stack Section (8KB)

* **Range**: `0xE000 - 0xFFFF`
* **Purpose**: Function call stack, local variables, return addresses
* **Access**: Read / Write (Stack grows downward)
* **Notes**:
  - Initialized at top (`0xFFFF`)
  - Stack overflow and underflow are detected
  - Used for subroutine calls and local variables

#### 6. I/O Registers (256B)

* **Range**: `0xFF00 - 0xFFFF`
* **Purpose**: CPU status flags, input register, indirect VRAM access
* **Access**: Memory-mapped I/O (Read / Write or Read-only)
* **Notes**:
  - Includes system flags and input registers
  - Some registers are read-only (e.g., input)
  - Used for system control and status

---

## Graphics & Audio Memory Layout (within `0xC000` – `0xDFFF`)

| Subsection                | Range             | Size  | Purpose                                               |
|---------------------------|-------------------|-------|-------------------------------------------------------|
| Sprite Data               | `0xC000`–`0xC7FF` | 2KB   | Sprite definitions                                    |
| Tile Data                 | `0xC800`–`0xCFFF` | 2KB   | Tile definitions                                      |
| Screen Buffer             | `0xD000`–`0xD7FF` | 2KB   | Framebuffer output                                    |
| Drawing Control Registers | `0xD800`–`0xD81F` | 32B   | PPU drawing command registers                         |
| APU Channel Registers     | `0xD820`–`0xD84F` | 48B   | Audio channel configuration                           |
| Color Palette             | `0xD850`–`0xD88F` | 64B   | 16-color palette (48B used, 16B padding)              |
| Font Memory               | `0xD890`–`0xDCFF` | 1136B | System font (896B used for 112 glyphs × 8 bytes)      |
| Reserved Tables Area      | `0xDD00`–`0xDDFF` | 256B  | Scroll buffers, blending tables, or LUTs              |
| Extended Reserved         | `0xDE00`–`0xDFFF` | 512B  | Reserved for future extensions or BIOS scratch space  |

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