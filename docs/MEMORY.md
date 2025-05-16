# LU8 Memory Map Technical Documentation

## Overview

The LU8 memory system is organized into distinct sections, providing a structured approach to memory management and access.

---

## Memory Layout

### Total Memory Space

* **Size**: 64KB (`0x0000 - 0xFFFF`)
* **Divided into**: 4 primary sections

### Memory Sections

#### 1. BIOS Section (4KB)

* **Range**: `0x0000 - 0x0FFF`
* **Purpose**: Stores system BIOS firmware
* **Access**: Read / Execute only (Write protected)
* **Notes**: 
  - Loaded automatically on system reset
  - Cannot be overwritten by programs
  - Contains essential system routines

#### 2. Code Section (28KB)

* **Range**: `0x1000 - 0x7FFF`
* **Purpose**: Stores executable program instructions
* **Access**: Read / Execute
* **Notes**:
  - Programs are loaded starting at `0x1000`
  - Space after BIOS for user programs

#### 3. Data Section (16KB)

* **Range**: `0x8000 - 0xBFFF`
* **Purpose**: General-purpose variable and data storage
* **Access**: Read / Write

#### 4. Graphics & Audio Section (8KB)

* **Range**: `0xC000 - 0xDFFF`
* **Purpose**: Graphics memory (sprites, tiles, framebuffer), drawing registers, and APU audio channels
* **Access**: Read / Write

#### 5. Stack Section (~7.75KB)

* **Range**: `0xE000 - 0xFEFF`
* **Purpose**: Function call stack, local variables, return addresses
* **Access**: Read / Write (Stack grows downward)

#### 6. I/O Registers (256B)

* **Range**: `0xFF00 - 0xFFFF`
* **Purpose**: CPU status flags, input register, indirect VRAM access
* **Access**: Memory-mapped I/O (Read / Write or Read-only)

---

## Graphics & Audio Memory Layout (within 0xC000 - 0xDFFF)

| Subsection                | Range             | Size    | Purpose                       |
| ------------------------- | ----------------- | ------- | ----------------------------- |
| Sprite Data               | `0xC000`-`0xC7FF` | 2KB     | Sprite definitions            |
| Tile Data                 | `0xC800`-`0xCFFF` | 2KB     | Tile definitions              |
| Screen Buffer             | `0xD000`-`0xD7FF` | 2KB     | Framebuffer output            |
| Drawing Control Registers | `0xD800`-`0xD81F` | 32B     | PPU drawing command registers |
| APU Channel Registers     | `0xD820`-`0xD84F` | 48B     | Audio channel configuration   |
| Reserved Graphics Memory  | `0xD850`-`0xDFFF` | 1968B   | Color Palette (48B) + Reserved for future use |

---

## Memory Access Types

### Code Section

* Used by the CPU for instruction fetching
* Read/Execute only
* Write operations are discouraged and may be ignored or cause errors

### Data Section

* Used by programs for dynamic memory and variables
* Fully readable and writable

### Graphics & Audio Section

* Accessible by CPU, PPU, and APU
* Includes video RAM, tile/sprite memory, drawing registers, and APU channel configuration
* Fully readable and writable

### Stack Section

* Managed by CPU stack operations (e.g., `PUSH`, `POP`)
* Located in `0xE000` - `0xFEFF`
* Initialized at top (`0xFEFF`), grows downward
* Stack overflow and underflow are detected

### I/O Register Section

* Located in `0xFF00` - `0xFFFF`
* Memory-mapped system registers (e.g., CPU flags, input, indirect VRAM access)
* Access may be read-only, write-only, or read/write depending on the register
* Should not be used for general-purpose data or stack

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

### Input Register

| Address  | Description                                                     |
| -------- | --------------------------------------------------------------- |
| `0xFF10` | INPUT - 8-bit input register (buttons A/B/Select/Start + D-pad) |

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


## 🎨 Color Palette Memory (0xD850–0xD87F)

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

The rest of the region from `0xD890–0xDFFF` (1920 bytes) remains reserved for future use, such as:

- Additional palettes
- Tilemap control
- Scroll buffers
- User-defined LUTs

---

## 🎵 APU Channel Registers (0xD820–0xD84F)

Each channel occupies 16 bytes (5 channels = 80 bytes total). Channels: Pulse1, Pulse2, Triangle, Noise, DMC.

| Offset | Name         | Description                  |
| ------ | ------------ | ---------------------------- |
| +0     | `CTRL`       | Enable, loop                 |
| +1     | `VOL`        | Volume (0-15)                |
| +2     | `SWEEP`      | Sweep (pulse only)           |
| +3     | `FREQ_L`     | Frequency low byte           |
| +4     | `FREQ_H`     | Frequency high byte          |
| +5     | `DUTY`       | Duty cycle (pulse only)      |
| +6     | `LENGTH`     | Duration in samples          |
| +7     | `PHASE`      | Initial phase                |
| +8     | `DMC_SAMPLE` | Sample data write (DMC only) |
| +9–15  | —            | Reserved / Future use        |

Use helper functions in `APUMemory` namespace to get addresses per channel.

---

## Notes

* All memory addresses are 16-bit.
* Memory-mapped I/O follows a predictable pattern to simplify emulator and hardware logic.
* Some addresses may be reserved for future extensions of the LU8 system.

```asm
; Example: Write to VRAM using indirect addressing
MOV [0xFF06], 0x20     ; Set high byte of VRAM address
MOV [0xFF06], 0x00     ; Set low byte of VRAM address
MOV [0xFF07], 42       ; Write value 42 to VRAM
```

---

This memory model ensures that code, graphics, data, and audio are clearly separated, simplifying debugging and performance tuning.

## Memory Protection

* BIOS region (`0x0000 - 0x0FFF`) is write-protected
* Attempts to write to BIOS memory will trigger a runtime error
* BIOS verification is performed on load
* Programs cannot be loaded into BIOS space

## Loading Order

1. BIOS is loaded first at `0x0000` during system reset
2. BIOS is verified for integrity
3. Programs are loaded at `0x1000` after BIOS
4. Memory protection is enforced during execution
