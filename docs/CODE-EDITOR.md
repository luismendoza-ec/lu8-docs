# Author and License

**Author**: Luis A. Mendoza - Creator of Lu8

This documentation is part of the Lu8 Fantasy Console project. While this documentation serves as a reference for the current implementation and capabilities, please note that the project is under active and continuous development, and the documentation may change accordingly.

## License and Copyright

© 2024 Luis A. Mendoza. All rights reserved.

This documentation and the Lu8 Fantasy Console are original works created by Luis A. Mendoza. The Lu8 system is a fictional console design and implementation that does not correspond to any existing hardware or other projects. This is a closed-source project, and all rights to the design, implementation, and documentation are reserved.

---

# Lu8 Code Editor

The Lu8 Code Editor is a specialized web-based editor designed specifically for writing and editing Lu8 assembly code. Built on top of Monaco Editor (the same editor that powers VS Code), it provides a rich development experience with features tailored for Lu8 assembly programming.

## Features

### Syntax Highlighting
The editor provides comprehensive syntax highlighting for Lu8 assembly code:

- **Control Flow Instructions** (Blue)
  - NOP, JMP, JNZ, JZ, JEQ, JNEQ, JG, JL, JGE, JLE, CALL, RET
  - HALT instruction (special red highlighting)

- **Data Movement Instructions** (Teal)
  - MOV, PUSH, POP, MEMCPY, MEMSET

- **Arithmetic Instructions** (Light Yellow)
  - ADD, SUB, MUL, DIV, MOD, INC, DEC

- **Logical Instructions** (Gold)
  - AND, OR, XOR, NOT, SHL, SHR

- **Comparison Instructions** (Orange)
  - CMP

- **System Instructions** (Light Blue)
  - RND, TICK, LOG

- **Graphics Instructions** (Purple)
  - PSET, CLS, SETCOLOR, LINE, RECT, FILLRECT
  - CIRCLE, FILLCIRCLE, RSTPAL, DRAWCHAR, VSYNC

- **Other Elements**
  - Memory addresses: `[0x8000]` (Orange)
  - Hexadecimal values: `0xFF` (Orange)
  - Decimal numbers (Light Green)
  - Comments: `;` or `//` (Green)
  - Labels: `start:` (Teal)
  - Constants: UPPERCASE (Light Yellow)
  - Directives: DB, EQU (Orange)

### IntelliSense Features

#### Hover Information
- Hover over any instruction to see detailed documentation
- Shows instruction description, syntax, and examples
- Provides immediate feedback on instruction usage

#### Auto-completion
- Suggests available instructions as you type
- Includes instruction documentation in suggestions
- Supports all Lu8 assembly instructions

### Code Organization

#### Sections
The editor supports the standard Lu8 program structure:
- Code section (0x1000-0x7FFF)
- Data section
- Label definitions
- Constants

#### Directives
- `DB` for defining raw bytes
- `EQU` for defining constants

### Integration Features

#### File Operations
- Load ASM files (.asm)
- Save ASM files
- Compile to binary (.lu8)
- Load binary files directly

#### Development Tools
- Integrated with Lu8 VM
- Real-time compilation
- Direct execution
- Error reporting

## Usage

### Basic Editing
```asm
; Example program
start:
    MOV [0x8000], 42    ; Set initial value
    ADD [0x8001], 10    ; Add to value
    CMP [0x8000], [0x8001]
    JNZ start           ; Loop if not equal
    HALT
```

### Working with Labels
```asm
main_loop:
    MOV [0x8000], 0     ; Reset counter
    JMP process_data    ; Jump to subroutine

process_data:
    INC [0x8000]        ; Increment counter
    CMP [0x8000], 10    ; Check limit
    JNZ process_data    ; Continue if not done
    RET                 ; Return to main loop
```

### Using Constants
```asm
SCREEN_WIDTH EQU 128
SCREEN_HEIGHT EQU 128

    MOV [0x8000], SCREEN_WIDTH
    MOV [0x8001], SCREEN_HEIGHT
```

## Editor Integration

### Development Workflow
1. Write or load ASM code
2. Edit with syntax highlighting and IntelliSense
3. Compile to binary
4. Run in VM
5. Monitor execution
6. Debug if needed

## Best Practices

### Code Organization
- Use meaningful labels
- Group related code
- Add descriptive comments
- Define constants for magic numbers

### Performance
- Optimize loops
- Use appropriate instructions
- Minimize memory access
- Consider cycle counts

### Debugging
- Use LOG instruction for debugging
- Add strategic HALT points
- Monitor memory values
- Check CPU flags

## Notes

- The editor is integrated with the Lu8 development environment
- All features are available in the web interface
- No additional installation required
- Supports modern browser features
- Automatic saving and recovery
- Real-time error checking 