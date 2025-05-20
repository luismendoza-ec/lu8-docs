# Author and License

**Author**: Luis A. Mendoza - Creator of Lu8

This documentation is part of the Lu8 Fantasy Console project. While this documentation serves as a reference for the current implementation and capabilities, please note that the project is under active and continuous development, and the documentation may change accordingly.

## License and Copyright

© 2024 Luis A. Mendoza. All rights reserved.

This documentation and the Lu8 Fantasy Console are original works created by Luis A. Mendoza. The Lu8 system is a fictional console design and implementation that does not correspond to any existing hardware or other projects. This is a closed-source project, and all rights to the design, implementation, and documentation are reserved.

---

# Hex Dump Viewer

The Hex Dump viewer is a feature that allows you to inspect the raw binary content of the currently loaded cartridge in memory. This tool is particularly useful for debugging and understanding the structure of your programs at a low level.

## Overview

The Hex Dump viewer displays the executable payload of your loaded cartridge in a hexadecimal format. It shows:

- Memory addresses in hexadecimal format
- Raw byte values in hexadecimal
- ASCII representation of the bytes (when possible)
- A clean, formatted layout for easy reading

## Important Notes

- The Hex Dump only shows the executable payload of the cartridge that is currently loaded in memory
- The ROM header (which contains metadata like version, size, and flags) is not displayed in this view
- The header can be found in the original .lu8 file but is stripped when the cartridge is loaded into memory
- The view updates automatically when a new cartridge is loaded

## Format

The hex dump is displayed in the following format:

```
0x00000000: 1b 81 01 00 80 00 fe 21 01 80 1d 01 80 10 fe 82    .......!........
0x00000010: 01 80 21 02 80 21 03 80 1d 02 80 80 fe 1d 03 80    ..!..!..........
```

Where:
- Left column: Memory address in hexadecimal
- Middle columns: Raw bytes in hexadecimal
- Right column: ASCII representation of the bytes

## Usage

1. Load a cartridge using the "Load ROM" button in the toolbar
2. Click on the "Hex Dump" tab in the right panel
3. The hex dump will automatically display the contents of your loaded cartridge

## Technical Details

- The hex dump is generated using the `hexy` library
- The display is configured with:
  - 16 bytes per line
  - Hexadecimal numbering
  - ASCII annotation
  - Lowercase hexadecimal values
  - 2-space indentation

## Limitations

- The hex dump is read-only
- Changes made to memory during program execution are not reflected in real-time
- The view only shows the executable payload, not the ROM header or other metadata 