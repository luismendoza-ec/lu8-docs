## BIOS

The BIOS is a critical component of the Lu8 system that is responsible for initial system setup and cartridge management.

### BIOS Memory Region

* Occupies `0x0000 - 0x0FFF` (4KB)
* **Write-protected**: any writes to this region are rejected at runtime
* Must be loaded before any `.lu8` program can be executed

### BIOS Responsibilities

* Initializes video and system state
* Loads the **Lu8 Default Palette** (inspired by the classic PICO-8 palette)
* Clears the screen and sets a background color
* Validates the presence of a cartridge by checking for the magic number `0x1B`
* If a valid cartridge is present, control is transferred to `0x1001`
* If no cartridge is present, a fallback animation is rendered with randomly generated shapes using the loaded palette

### Default Palette (Lu8 Default Palette)

The BIOS initializes the 16-color palette in memory addresses `0xD850 - 0xD87F` (48 bytes). Each color has 3 bytes: Red, Green, and Blue.

| Index | Color Name  | Hex Code  | Memory Range    |
| ----- | ----------- | --------- | --------------- |
| 0     | Black       | `#000000` | `0xD850–0xD852` |
| 1     | Dark Blue   | `#1D2B53` | `0xD853–0xD855` |
| 2     | Dark Purple | `#7E2553` | `0xD856–0xD858` |
| 3     | Dark Green  | `#008751` | `0xD859–0xD85B` |
| 4     | Brown       | `#AB5236` | `0xD85C–0xD85E` |
| 5     | Dark Gray   | `#5F574F` | `0xD85F–0xD861` |
| 6     | Light Gray  | `#C2C3C7` | `0xD862–0xD864` |
| 7     | White       | `#FFF1E8` | `0xD865–0xD867` |
| 8     | Red         | `#FF004D` | `0xD868–0xD86A` |
| 9     | Orange      | `#FFA300` | `0xD86B–0xD86D` |
| 10    | Yellow      | `#FFEC27` | `0xD86E–0xD870` |
| 11    | Green       | `#00E436` | `0xD871–0xD873` |
| 12    | Blue        | `#29ADFF` | `0xD874–0xD876` |
| 13    | Lavender    | `#83769C` | `0xD877–0xD879` |
| 14    | Pink        | `#FF77A8` | `0xD87A–0xD87C` |
| 15    | Peach       | `#FFCCAA` | `0xD87D–0xD87F` |

These values are written directly to the memory-mapped palette region and can be modified later by programs or games using regular `MOV` instructions.

### BIOS Fallback Mode (No Cartridge)

If the cartridge signature is missing or incorrect:

* The BIOS draws colorful random rectangles and circles on screen
* It uses the default palette, allowing users to verify that the system is working
* The animation repeats every frame and showcases basic PPU features

### BIOS and Program Handoff

* Valid `.lu8` programs must start with `0x1B` at address `0x1000`
* The BIOS reads this byte to detect and validate the cartridge
* If valid, the BIOS jumps to `0x1001` to hand over execution