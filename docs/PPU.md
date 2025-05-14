# Lu8 Picture Processing Unit (PPU) Documentation

The Lu8 PPU (Picture Processing Unit) is a low-level, retro-inspired graphics renderer for the Lu8 Mini Console. It supports pixel-based drawing with primitives such as lines, rectangles, and circles. The system is memory-mapped and programmable in assembly.

## Note
This documentation is a work in progress and may change as the project evolves. Features, syntax, and behavior are subject to revision during development.

## Table of Contents

* [Overview](#overview)
* [Memory Map](#memory-map)
* [Framebuffer Access](#framebuffer-access)
* [VRAM Access](#vram-access)
* [Drawing Primitives](#drawing-primitives)

  * [Set Pixel](#set-pixel)
  * [Clear Screen](#clear-screen)
  * [Lines](#lines)
  * [Rectangles](#rectangles)
  * [Circles](#circles)
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

---

## Memory Map

| Component     | Address Range     | Size        |
| ------------- | ----------------- | ----------- |
| Framebuffer   | Mapped internally | 128x128     |
| VRAM          | 0x0000 - 0x0FFF   | 4KB         |
| PPU Registers | 0xD800 - 0xD81F   | Control I/O |

---

## Framebuffer Access

### `pset(x, y, color)`

Sets the pixel at `(x, y)` to the specified color index (0-15).

### `clear(color)`

Fills the entire screen with the specified color.

### `setFramebufferPixel(offset, value)`

Sets the raw pixel data at the specified framebuffer offset.

### `getFramebufferPixel(offset)`

Returns the color value at the specified framebuffer offset.

---

## VRAM Access

### `writePPUADDR(value)`

Sets the high or low byte of the VRAM address register. Must be called twice to complete a full 16-bit address.

### `writePPUDATA(value)`

Writes data to the VRAM at the address set by `writePPUADDR`. After writing, the address auto-increments.

### `writeVRAM(addr, value)`

Writes directly to a given VRAM address.

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

---

## Color Management

### `setColor(index)`

Sets the current color used for all drawing operations.

> Only values from 0 to 15 are valid. Values are masked with `0x0F`.

In assembly:

```assembly
MOV [0xD800], 0x0F    ; Set color index 15
SETCOLOR              ; Apply it to PPU
```

---

## Palette Control

### `setPalette(paletteArray)`

Accepts a list of 16 HTML color strings (e.g., `"#FF0000"`) to define the rendering palette.

### `defaultPalette()`

Returns an empty vector by default, but this can be overridden to include a predefined palette.

---

## Reset Behavior

### `reset()`

* Clears VRAM and framebuffer
* Resets address latches
* Sets `vramAddress = 0`
* Default `currentColor = 7`

---

## Assembly Interface

The following PPU operations are exposed as custom opcodes:

| Instruction  | Opcode | Register Usage                       | Description                             |
| ------------ | ------ | ------------------------------------ | --------------------------------------- |
| `PSET`       | 0x80   | X: `0xD806`, Y: `0xD807`             | Draw pixel at (X, Y) with current color |
| `CLS`        | 0x81   | Color: `0xD801`                      | Clear screen with color                 |
| `SETCOLOR`   | 0x82   | Color: `0xD800`                      | Set drawing color                       |
| `LINE`       | 0x83   | X1/Y1: `0xD802/3`, X2/Y2: `0xD804/5` | Draw line                               |
| `RECT`       | 0x84   | X/Y/W/H: `0xD806–0xD809`             | Draw rectangle outline                  |
| `FILLRECT`   | 0x85   | X/Y/W/H: `0xD80A–0xD80D`             | Draw filled rectangle                   |
| `CIRCLE`     | 0x86   | X/Y/R: `0xD80E–0xD810`               | Draw circle outline                     |
| `FILLCIRCLE` | 0x87   | X/Y/R: `0xD811–0xD813`               | Draw filled circle                      |

These instructions are 1-byte opcodes executed directly by the virtual CPU. Values must be preloaded into the specified addresses.

---

## Tips

* Always validate coordinates before drawing to avoid memory corruption.
* Use `CLS` at the start of each frame if you're manually managing redraws.
* Avoid writing to VRAM during visible frame rendering to prevent visual artifacts.
