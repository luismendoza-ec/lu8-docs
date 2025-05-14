# Lu8 Room Format Specification

## Overview
The `.room` file format is the binary format used by the Lu8 virtual machine to store compiled programs. It consists of a header followed by the program's binary data.

## Note
This documentation is a work in progress and may change as the project evolves. Features, syntax, and behavior are subject to revision during development.

## File Structure
```
+------------------+
|     Header       |  9 bytes
+------------------+
|   Program Data   |  Variable size
+------------------+
```

## Header Format
The header is a 9-byte structure with the following layout:

| Offset | Size | Name    | Description                    |
|--------|------|---------|--------------------------------|
| 0x00   | 4    | Magic   | Magic number ("LU8\0")        |
| 0x04   | 1    | Version | Format version (currently 1)   |
| 0x05   | 2    | Size    | Size of program data in bytes |
| 0x07   | 2    | Flags   | Reserved for future use       |

### Field Details

#### Magic (4 bytes)
- Fixed value: `4C 55 38 00` (ASCII "LU8\0")
- Used to identify valid .room files
- Must match exactly to be considered a valid file

#### Version (1 byte)
- Current version: 1
- Will be incremented for incompatible format changes
- VM will reject files with unsupported versions

#### Size (2 bytes, little-endian)
- Maximum program size: 65,535 bytes
- Represents the exact size of the program data following the header
- Used for validation and memory allocation

#### Flags (2 bytes, little-endian)
- Currently unused, reserved for future extensions
- Must be set to 0 in current version
- May be used for:
  - Compression flags
  - Memory layout hints
  - Debug information presence
  - Other metadata

## Program Data
- Follows immediately after the header
- Contains the actual compiled program bytes
- Size must match the value in the header
- Format is raw binary, ready to be loaded into VM memory
- Programs are loaded at 0x1000 (after BIOS region)
- Maximum program size is limited to available memory (28KB)

## Memory Layout
When a .room file is loaded:
- BIOS occupies 0x0000-0x0FFF (4KB)
- Program is loaded at 0x1000
- Available program space is 28KB (0x1000-0x7FFF)
- Stack and other memory regions remain unchanged

## Version History
### Version 1 (Current)
- Initial release
- Basic header with magic number and size
- Uncompressed program data
- Reserved flags field for future use

## File Operations
### Creating a .room File
1. Assemble the source code to binary
2. Create header with:
   - Magic number "LU8\0"
   - Version set to 1
   - Size set to program length
   - Flags set to 0
3. Write header followed by program data

### Loading a .room File
1. Verify BIOS is loaded and valid
2. Read and verify .room header
3. Check program size fits in available memory
4. Load program starting at 0x1000
5. Initialize program execution
6. Enforce memory protection

## Error Handling
The VM will reject .room files if:
- File is smaller than header size (9 bytes)
- Magic number doesn't match "LU8\0"
- Version is not supported
- Actual file size doesn't match header size
- Program size exceeds available memory (28KB)
- Program attempts to overwrite BIOS region

## Future Extensions
The format is designed to be extensible through:
- Version field for major format changes
- Flags field for feature toggles
- Reserved header space for backward compatibility

## Tools
- `lu8 --compile game.asm` - Creates a .room file from assembly
- `lu8 --room game.room` - Loads and executes a .room file 