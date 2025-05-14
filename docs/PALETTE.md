# Lu8 Color Palette

This is the official color palette used by the Lu8 fantasy console. It includes 16 fixed colors inspired by retro systems, presented as hexadecimal RGB values.

## Note
This documentation is a work in progress and may change as the project evolves. Features, syntax, and behavior are subject to revision during development.

## Standard Palette (0–15)

| Index | Color Name  | Hex Code  |
| ----- | ----------- | --------- |
| 0     | Black       | `#000000` |
| 1     | Dark Blue   | `#1D2B53` |
| 2     | Dark Purple | `#7E2553` |
| 3     | Dark Green  | `#008751` |
| 4     | Brown       | `#AB5236` |
| 5     | Dark Gray   | `#5F574F` |
| 6     | Light Gray  | `#C2C3C7` |
| 7     | White       | `#FFF1E8` |
| 8     | Red         | `#FF004D` |
| 9     | Orange      | `#FFA300` |
| 10    | Yellow      | `#FFEC27` |
| 11    | Green       | `#00E436` |
| 12    | Blue        | `#29ADFF` |
| 13    | Purple      | `#83769C` |
| 14    | Pink        | `#FF77A8` |
| 15    | Peach       | `#FFCCAA` |

## Notes

* This palette is fixed and defined in the VM source code:

  ```cpp
  static const char* LU8_PALETTE[16] = {
      "#000000", "#1D2B53", "#7E2553", "#008751",
      "#AB5236", "#5F574F", "#C2C3C7", "#FFF1E8",
      "#FF004D", "#FFA300", "#FFEC27", "#00E436",
      "#29ADFF", "#83769C", "#FF77A8", "#FFCCAA"
  };
  ```
* Colors are indexed (0–15) and used directly in graphics instructions via memory-mapped registers.
* There is currently **no hidden palette**.
* Color 0 is typically used as the transparent color by default.

## Using Colors in ASM

To select a color for drawing, you must write the desired color index (0–15) into the memory-mapped register `0xD800`, which corresponds to `PPU_COLOR`. Then you must invoke `SETCOLOR`.

To clear the screen (`CLS`), the background color must be written to register `0xD801` before calling `CLS`.

### Example (ASM):

```asm
    ; Set background color to blue (index 12) and clear screen
    MOV [0xD801], 12  ; Background color
    CLS               ; Clear screen using that color

    ; Set drawing color to red (index 8)
    MOV [0xD800], 8
    SETCOLOR

    ; Draw a red rectangle
    MOV [0xD80A], 10  ; X position
    MOV [0xD80B], 20  ; Y position
    MOV [0xD80C], 5   ; Width
    MOV [0xD80D], 5   ; Height
    FILLRECT
```

You can change the drawing color at any time before a draw instruction (e.g., `LINE`, `RECT`, `FILLRECT`, `PSET`, etc.) by updating `0xD800` and calling `SETCOLOR` again.
