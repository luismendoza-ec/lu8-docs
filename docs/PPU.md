# Author and License

**Author**: Luis A. Mendoza - Creator of Lu8

This documentation is part of the Lu8 Fantasy Console project. While this documentation serves as a reference for the current implementation and capabilities, please note that the project is under active and continuous development, and the documentation may change accordingly.

## License and Copyright

© 2024 Luis A. Mendoza. All rights reserved.

This documentation and the Lu8 Fantasy Console are original works created by Luis A. Mendoza. The Lu8 system is a fictional console design and implementation that does not correspond to any existing hardware or other projects. This is a closed-source project, and all rights to the design, implementation, and documentation are reserved.

---

# Lu8 Picture Processing Unit (PPU) Documentation

The Lu8 PPU (Picture Processing Unit) is a low-level, retro-inspired graphics renderer for the Lu8 Mini Console. It supports pixel-based drawing with primitives such as lines, rectangles, and circles. The system is memory-mapped and programmable in assembly.

## Table of Contents

* [Overview](#overview)
* [Memory Map](#memory-map)
* [Framebuffer Access](#framebuffer-access)
* [VRAM Access](#vram-access)
* [Drawing Primitives](#drawing-primitives)
* [Color Management](#color-management)
* [Palette Control](#palette-control)
* [Reset Behavior](#reset-behavior)
* [Assembly Interface](#assembly-interface)

---

## Overview

The Lu8 PPU allows direct control over a 128x128 framebuffer with 16 colors (4-bit palette index). It features a separate 4KB VRAM for graphics data and uses memory-mapped IO for data access.

* **Resolution**: 128x128 pixels
* **Color Depth**: 4-bit per pixel (palette index)
* **Framebuffer Size**: 16,384 bytes
* **VRAM Size**: 4,096 bytes
* **Default Color**: 7 (White)

---

## Memory Map

| Component     | Address Range     | Size        | Purpose                                    |
| ------------- | ----------------- | ----------- | ------------------------------------------ |
| Sprite Data   | `0xC000`-`0xC7FF` | 2KB         | Sprite definitions                         |
| Tile Data     | `0xC800`-`0xCFFF` | 2KB         | Tile definitions                           |
| Screen Buffer | `0xD000`-`0xD7FF` | 2KB         | Framebuffer output                         |
| PPU Registers | `0xD800`-`0xD81F` | 32B         | Drawing control registers                  |
| APU Registers | `0xD820`-`0xD84F` | 48B         | Audio channel configuration                |
| Color Palette | `0xD850`-`0xD88F` | 64B         | 16-color palette (48B used, 16B padding)   |
| Font Memory   | `0xD890`-`0xDCFF` | 1136B       | System font (896B used for 112 glyphs)     |
| Reserved      | `0xDD00`-`0xDFFF` | 768B        | Reserved for future use                    |

---

## Framebuffer Access

### `pset(x, y, color)`

Sets the pixel at `(x, y)` to the specified color index (0-15). Values are automatically masked to 4 bits.

### `clear(color)`

Fills the entire screen with the specified color index (0-15).

### `setFramebufferPixel(offset, value)`

Sets the raw pixel data at the specified framebuffer offset. Value is masked to 4 bits.

### `getFramebufferPixel(offset)`

Returns the color value at the specified framebuffer offset.

---

## VRAM Access

### `writePPUADDR(value)`

Sets the high or low byte of the VRAM address register. Must be called twice to complete a full 16-bit address.

### `writePPUDATA(value)`

Writes data to the VRAM at the address set by `writePPUADDR`. After writing, the address auto-increments.

### `writeVRAM(addr, value)`

Writes directly to a given VRAM address. Value is masked to 4 bits.

### `readVRAM(addr)`

Reads the value from a specific VRAM address.

---

## Drawing Primitives

### Set Pixel

```assembly
MOV [0xD806], 10      ; X
MOV [0xD807], 20      ; Y
PSET                  ; Draw pixel at (10, 20)
```

### Clear Screen

```assembly
MOV [0xD801], 0x02    ; Background color
CLS                   ; Clear screen
```

### Lines

```assembly
MOV [0xD802], 10      ; X1
MOV [0xD803], 10      ; Y1
MOV [0xD804], 100     ; X2
MOV [0xD805], 100     ; Y2
LINE                  ; Draw line
```

### Rectangles

```assembly
MOV [0xD806], 20      ; X1
MOV [0xD807], 20      ; Y1
MOV [0xD808], 40      ; Width
MOV [0xD809], 20      ; Height
RECT                  ; Outline rectangle
FILLRECT              ; Filled rectangle
```

### Circles

```assembly
MOV [0xD80E], 64      ; X
MOV [0xD80F], 64      ; Y
MOV [0xD810], 15      ; Radius
CIRCLE                ; Outline
FILLCIRCLE            ; Fill
```

### Text Drawing

```assembly
MOV [0xD806], 10      ; X
MOV [0xD807], 20      ; Y
DRAWCHAR 65           ; Draw 'A' at (10, 20)
```

---

## Color Management

### `setColor(index)`

Sets the current color used for all drawing operations by writing to `PPU_COLOR` (`0xD800`).

> Only values from 0 to 15 are valid. Values are masked with `0x0F`.

In assembly:

```assembly
SETCOLOR 15         ; Set drawing color to index 15 (e.g. pink)
SETCOLOR [0x8000]   ; Set drawing color using value from memory
```

---

## Palette Control

The Lu8 PPU uses a 16-color palette, where each color is defined by 3 bytes: **Red**, **Green**, and **Blue**. The palette resides in memory at:

```
0xD850 – 0xD87F
```

Each palette index occupies 3 consecutive bytes:

| Index | Memory Range  | Components |
| ----- | ------------- | ---------- |
| 0     | 0xD850–0xD852 | R, G, B    |
| 1     | 0xD853–0xD855 | R, G, B    |
| ...   | ...           | ...        |
| 15    | 0xD87D–0xD87F | R, G, B    |

### Runtime Modification

Colors can be changed at any time from assembly code:

```asm
; Set color 0 to red
MOV [0xD850], 255   ; Red
MOV [0xD851], 0     ; Green
MOV [0xD852], 0     ; Blue
```

> ⚠️ All values must be in the range `0–255`. Use `MOD` if needed to limit dynamic values.

### BIOS Default Palette

On reset, the **BIOS initializes the palette** with the *Lu8 Default Palette*, inspired by PICO-8:

```text
"#000000", "#1D2B53", "#7E2553", "#008751",
"#AB5236", "#5F574F", "#C2C3C7", "#FFF1E8",
"#FF004D", "#FFA300", "#FFEC27", "#00E436",
"#29ADFF", "#83769C", "#FF77A8", "#FFCCAA"
```

Programs are free to overwrite any palette entry as needed.

---

## Reset Behavior

### `reset()`

* Clears VRAM and framebuffer
* Resets address latches
* Sets `vramAddress = 0`
* Default `currentColor = 7`
* Resets palette to default values

---

## Assembly Interface

The following PPU operations are exposed as custom opcodes:

| Instruction  | Opcode | Register Usage                       | Description                             |
| ------------ | ------ | ------------------------------------ | --------------------------------------- |
| `PSET`       | 0x80   | X: `0xD806`, Y: `0xD807`             | Draw pixel at (X, Y) with current color |
| `CLS`        | 0x81   | Color: `0xD801`                      | Clear screen with color                 |
| `SETCOLOR`   | 0x82   | → `0xD800` (PPU_COLOR)               | Set drawing color from operand          |
| `LINE`       | 0x83   | X1/Y1: `0xD802/3`, X2/Y2: `0xD804/5` | Draw line                               |
| `RECT`       | 0x84   | X/Y/W/H: `0xD806–0xD809`             | Draw rectangle outline                  |
| `FILLRECT`   | 0x85   | X/Y/W/H: `0xD80A–0xD80D`             | Draw filled rectangle                   |
| `CIRCLE`     | 0x86   | X/Y/R: `0xD80E–0xD810`               | Draw circle outline                     |
| `FILLCIRCLE` | 0x87   | X/Y/R: `0xD811–0xD813`               | Draw filled circle                      |
| `RSTPAL`     | 0x88   | None                                 | Reset palette to default                |
| `DRAWCHAR`   | 0x89   | X: `0xD806`, Y: `0xD807`             | Draw character from font data           |
| `PGET`       | 0x8A   | X: `0xD806`, Y: `0xD807`             | Get pixel color at (X, Y)               |

These instructions are 1-byte opcodes executed directly by the virtual CPU. Values must be preloaded into the specified addresses.

---

## Tips

* Always validate coordinates before drawing to avoid memory corruption
* Use `CLS` at the start of each frame if you're manually managing redraws
* Avoid writing to VRAM during visible frame rendering to prevent visual artifacts
* Use `RSTPAL` to restore the default palette if needed
* The font memory contains 112 glyphs, each 8x8 pixels
* All color values are automatically masked to 4 bits (0-15)
* The framebuffer is updated immediately after each drawing operation
* Use `VSYNC` to synchronize with the frame rate (60 FPS)
