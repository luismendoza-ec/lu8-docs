# Author and License

**Author**: Luis A. Mendoza - Creator of Lu8

This documentation is part of the Lu8 Fantasy Console project. While this documentation serves as a reference for the current implementation and capabilities, please note that the project is under active and continuous development, and the documentation may change accordingly.

## License and Copyright

© 2024 Luis A. Mendoza. All rights reserved.

This documentation and the Lu8 Fantasy Console are original works created by Luis A. Mendoza. The Lu8 system is a fictional console design and implementation that does not correspond to any existing hardware or other projects. This is a closed-source project, and all rights to the design, implementation, and documentation are reserved.

---

# LU8 Virtual RAM Technical Documentation

## Overview

The LU8 RAM is a 64KB (65,536 bytes) memory system with memory-mapped I/O support. It forms the foundation of the LU8 Virtual Machine's memory architecture, enabling direct memory access, dynamic I/O registration, and program loading.

---

## Architecture

### Memory Size

* **Total Size**: 64KB (`0x0000` – `0xFFFF`)
* **Implementation**: `Uint8Array`
* **Word Size**: 8-bit (1 byte)
* **Access**: Byte-addressable
* **Endianess**: Little-endian for multi-byte operations

### Memory Organization

* Linear address space
* 1-byte granularity
* Address wrap-around enforced by 16-bit masking (`addr & 0xFFFF`)
* Memory sections:
  * CODE (0x0000 - 0x7FFF)
  * DATA (0x8000 - 0xBFFF)
  * GFX (0xC000 - 0xDFFF)
  * STACK (0xE000 - 0xFFFF)
  * FLAGS (0xFF00 - 0xFF05)
  * IO (0xFF06 - 0xFFFF)

### Memory-Mapped I/O

* I/O handlers are mapped to specific addresses via a Map (`Map<number, IOHandler>`)
* Each handler supports:
  * Optional `read()` callback
  * Optional `write(uint8_t)` callback
* Used for peripheral devices like PPU, APU, and Input

---

## Core Features

### 1. Direct Memory Access

* All read/write operations are masked to 16-bit address and 8-bit value
* Standard RAM access via `read(addr)` / `write(addr, value)`
* Memory operations are monitored when RAM monitoring is enabled

### 2. I/O Handling

* Devices can be registered at specific addresses
* Both read and write callbacks are supported
* Memory access is automatically redirected when handlers exist
* I/O handlers are used for:
  * PPU framebuffer (0xD000 - 0xD7FF)
  * APU registers (0xD820 - 0xD8AF)
  * Input registers (0xFF10 - 0xFF11)
  * Palette memory (0xD850 - 0xD87F)

### 3. Program Loading

* RAM supports bulk loading from byte arrays
* Programs can be loaded at any offset
* A `.clear()` method resets memory to zero
* Loading into I/O-mapped addresses is prevented

### 4. Memory Monitoring

* Recent memory operations are tracked (up to 5 operations)
* Each operation includes:
  * Address
  * Value
  * Operation type (READ/WRITE)
  * Tick count
  * Memory section
* Monitoring can be enabled/disabled via configuration

### Special RAM Addresses

| Address   | Purpose               |
|-----------|------------------------|
| `0xFF00`  | Zero Flag (ZF)         |
| `0xFF01`  | Negative Flag (NF)     |
| `0xFF02`  | Carry Flag (CF)        |
| `0xFF03`  | Overflow Flag (OF)     |
| `0xFF04`  | Greater Flag (GF)      |
| `0xFF05`  | Less Flag (LF)         |

---

## Memory Operations

### Read

```typescript
read(addr: number): number {
    addr &= 0xFFFF;
    const handler = this.ioHandlers.get(addr);
    let value: number;
    
    if (handler?.read) {
        value = handler.read() & 0xFF;
    } else {
        value = this.memory[addr];
    }

    this.addOperation(addr, value, 'READ');
    return value;
}
```

### Write

```typescript
write(addr: number, value: number): void {
    addr &= 0xFFFF;
    value &= 0xFF;
    const handler = this.ioHandlers.get(addr);
    
    if (handler?.write) {
        handler.write(value);
    } else {
        this.memory[addr] = value;
    }

    this.addOperation(addr, value, 'WRITE');
}
```

### I/O Registration

```typescript
mapIO(addr: number, handler: IOHandler): void {
    addr &= 0xFFFF;
    this.ioHandlers.set(addr, handler);
}
```

---

## Performance Considerations

* **Fast Access**: `Uint8Array` direct indexing is near-zero overhead
* **I/O Delegation**: Minimal branching for handler checks
* **Masked Access**: Prevents out-of-bounds errors
* **No Memory Protection**: All memory is writable for performance
* **Memory Monitoring**: Optional feature with minimal overhead
* **Future Enhancements**: Optional bounds checking or debugging traps

---

## Example: Loading a Program

```typescript
loadProgram(data: Uint8Array, start: number = 0x0000): void {
    for (let i = 0; i < data.length; i++) {
        const addr = (start + i) & 0xFFFF;
        if (this.ioHandlers.has(addr)) {
            throw new Error(`Attempt to load program into I/O-mapped address at 0x${addr.toString(16).padStart(4, '0')}`);
        }
        this.memory[addr] = data[i];
    }
}
```

---

## Summary

The LU8 RAM system is designed for speed and flexibility. With memory-mapped I/O and clean abstraction layers for device communication, it enables modular design and straightforward integration with peripherals like the PPU and APU.

It combines raw memory access performance with high-level extensibility and optional monitoring capabilities.
