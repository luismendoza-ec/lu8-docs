# Lu8 Color Palette

This is the **default color palette** used by the Lu8 fantasy console, loaded by the BIOS on system reset. The palette consists of **16 programmatically changeable colors**, each defined by **3 RGB bytes** stored in memory.

---

## Default Palette (0–15)

This is the initial palette, known as the **Lu8 Default Palette**, inspired by PICO-8:

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

---

## Palette Memory Layout

The current palette is stored in memory from:

```
0xD850 – 0xD87F
```

Each color occupies **3 bytes** in the order Red, Green, Blue. For example:

| Color Index | Address Range     | Bytes   |
| ----------- | ----------------- | ------- |
| 0           | `0xD850`–`0xD852` | R, G, B |
| 1           | `0xD853`–`0xD855` | R, G, B |
| ...         | ...               | ...     |
| 15          | `0xD87D`–`0xD87F` | R, G, B |

You can write new RGB values at runtime using `MOV` or computed expressions.

---

## Notes

* The default palette is loaded by the BIOS at startup.
* Programs can modify the palette by writing directly to `0xD850–0xD87F`.
* Color values are 8-bit integers (0–255).
* There is **no hidden palette**.
* Color index `0` is typically treated as **transparent** in sprite systems (if applicable).

---

## Using Colors in ASM

To draw with a specific color:

1. Write the color index to `0xD800`
2. Call the `SETCOLOR` instruction

To clear the screen:

1. Write the background color index to `0xD801`
2. Call `CLS`

### Example

```asm
    ; Set background to blue and clear
    MOV [0xD801], 12
    CLS

    ; Set drawing color to red
    MOV [0xD800], 8
    SETCOLOR

    ; Draw a red box
    MOV [0xD80A], 10
    MOV [0xD80B], 20
    MOV [0xD80C], 5
    MOV [0xD80D], 5
    FILLRECT
```

### Changing Palette Color at Runtime

```asm
    ; Set color index 3 to RGB(100, 200, 50)
    MOV [0xD859], 100   ; Red component (index 3 * 3 = 9 offset)
    MOV [0xD85A], 200   ; Green
    MOV [0xD85B], 50    ; Blue
```