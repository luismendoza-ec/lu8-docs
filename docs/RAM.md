# LU8 Virtual RAM Technical Documentation

## Overview

The LU8 RAM is a 64KB (65,536 bytes) memory system with memory-mapped I/O support. It forms the foundation of the LU8 Virtual Machine's memory architecture, enabling direct memory access, dynamic I/O registration, and program loading.

## Note
This documentation is a work in progress and may change as the project evolves. Features, syntax, and behavior are subject to revision during development.

---

## Architecture

### Memory Size

* **Total Size**: 64KB (`0x0000` – `0xFFFF`)
* **Implementation**: `std::vector<uint8_t>` or raw `uint8_t*`
* **Word Size**: 8-bit (1 byte)
* **Access**: Byte-addressable
* **Endianess**: Little-endian for multi-byte operations

### Memory Organization

* Linear address space
* 1-byte granularity
* Address wrap-around enforced by 16-bit masking (`addr & 0xFFFF`)

### Memory-Mapped I/O

* I/O handlers are mapped to specific addresses via a hash map (`std::unordered_map<uint16_t, Handler>`)
* Each handler supports:

  * Optional `read()` callback
  * Optional `write(uint8_t)` callback
* Used for peripheral devices like PPU, audio, etc.

---

## Core Features

### 1. Direct Memory Access

* All read/write operations are masked to 16-bit address and 8-bit value
* Standard RAM access via `read(addr)` / `write(addr, value)`

### 2. I/O Handling

* Devices can be registered at specific addresses
* Both read and write callbacks are supported
* Memory access is automatically redirected when handlers exist

### 3. Program Loading

* RAM supports bulk loading from byte arrays
* Programs can be loaded at any offset
* A `.clear()` method resets memory to zero

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

## Memory Operations (C++)

### Read

```cpp
uint8_t RAM::read(uint16_t addr) {
    addr &= 0xFFFF; // 16-bit masking
    auto it = ioHandlers.find(addr);
    if (it != ioHandlers.end() && it->second.read) {
        return it->second.read();
    }
    return memory[addr];
}
```

### Write

```cpp
void RAM::write(uint16_t addr, uint8_t value) {
    addr &= 0xFFFF;
    value &= 0xFF;
    auto it = ioHandlers.find(addr);
    if (it != ioHandlers.end() && it->second.write) {
        it->second.write(value);
    } else {
        memory[addr] = value;
    }
}
```

### I/O Registration

```cpp
void RAM::mapIO(uint16_t addr, IOHandler handler) {
    addr &= 0xFFFF;
    ioHandlers[addr] = handler;
}
```

---

## Performance Considerations

* **Fast Access**: `memory[]` direct indexing is near-zero overhead
* **I/O Delegation**: Minimal branching for handler checks
* **Masked Access**: Prevents out-of-bounds errors
* **No Memory Protection**: All memory is writable for performance
* **Future Enhancements**: Optional bounds checking or debugging traps

---

## Example: Loading a Program

```cpp
void RAM::loadProgram(const std::vector<uint8_t>& data, uint16_t startAddr) {
    for (size_t i = 0; i < data.size(); ++i) {
        memory[startAddr + i] = data[i];
    }
}
```

---

## Summary

The LU8 RAM system is designed for speed and flexibility. With memory-mapped I/O and clean abstraction layers for device communication, it enables modular design and straightforward integration with peripherals like the PPU and APU.

It combines raw memory access performance with high-level extensibility.
