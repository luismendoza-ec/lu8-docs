# Author and License

**Author**: Luis A. Mendoza - Creator of Lu8

This documentation is part of the Lu8 Fantasy Console project. While this documentation serves as a reference for the current implementation and capabilities, please note that the project is under active and continuous development, and the documentation may change accordingly.

## License and Copyright

© 2024 Luis A. Mendoza. All rights reserved.

This documentation and the Lu8 Fantasy Console are original works created by Luis A. Mendoza. The Lu8 system is a fictional console design and implementation that does not correspond to any existing hardware or other projects. This is a closed-source project, and all rights to the design, implementation, and documentation are reserved.

---

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
0xD850 – 0xD88F
```

Each color occupies **3 bytes** in the order Red, Green, Blue. For example:

| Color Index | Address Range     | Bytes   |
| ----------- | ----------------- | ------- |
| 0           | `0xD850`–`0xD852` | R, G, B |
| 1           | `0xD853`–`0xD855` | R, G, B |
| ...         | ...               | ...     |
| 15          | `0xD87D`–`0xD88F` | R, G, B |

You can write new RGB values at runtime using `MOV` or computed expressions.

---

## Notes

* The default palette is loaded by the BIOS at startup.
* Programs can modify the palette by writing directly to `0xD850–0xD88F`.
* Color values are 8-bit integers (0–255).
* There is **no hidden palette**.
* Color index `0` is typically treated as **transparent** in sprite systems (if applicable).

---

## Using Colors in ASM

To draw with a specific color, use `SETCOLOR` with an immediate or memory-based value:

1. Set the color using `SETCOLOR <value>` or `SETCOLOR [addr]`
2. Then use drawing instructions like `PSET`, `RECT`, etc.

To clear the screen:

1. Write the background color index to `0xD801`
2. Call `CLS`

### Example

```asm
    ; Set background to blue and clear screen
    MOV [0xD801], 12
    CLS

    ; Set drawing color to red
    SETCOLOR 8

    ; Draw a red box
    MOV [0xD80A], 10
    MOV [0xD80B], 20
    MOV [0xD80C], 5
    MOV [0xD80D], 5
    FILLRECT

    HALT ; Stops the program

```

### Changing Palette Color at Runtime

```asm
    ; Set color index 3 to RGB(100, 200, 50)
    MOV [0xD859], 100   ; Red component (index 3 * 3 = 9 offset)
    MOV [0xD85A], 200   ; Green
    MOV [0xD85B], 50    ; Blue
```