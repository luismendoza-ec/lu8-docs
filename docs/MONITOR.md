# Author and License

**Author**: Luis A. Mendoza - Creator of Lu8

This documentation is part of the Lu8 Fantasy Console project. While this documentation serves as a reference for the current implementation and capabilities, please note that the project is under active and continuous development, and the documentation may change accordingly.

## License and Copyright

© 2024 Luis A. Mendoza. All rights reserved.

This documentation and the Lu8 Fantasy Console are original works created by Luis A. Mendoza. The Lu8 system is a fictional console design and implementation that does not correspond to any existing hardware or other projects. This is a closed-source project, and all rights to the design, implementation, and documentation are reserved.

---

# Monitoring System

The Lu8 monitoring system provides tools for debugging and analyzing the virtual machine's performance. This system includes monitors for CPU and RAM, which can be enabled or disabled as needed.

## Performance Considerations

⚠️ **Important**: The monitoring system is primarily designed for debugging purposes. Its activation may affect VM performance depending on the HOST system hardware. It is recommended to:

- Enable monitoring only when necessary for debugging
- Disable monitoring during normal development
- Monitor performance impact when using these tools

## CPU Monitoring

### Displayed Information
- **PC (Program Counter)**: Current execution address
- **Last Instruction**: Most recently executed instruction
- **Flags**: Current system flags status
- **Cycles**: Total CPU cycle counter
- **Status**: Current VM state (Running/Paused/Stopped)
- **CPU Usage**: Percentage of cycles used per frame

### Enable/Disable
```bash
# Check current status
monitor

# Toggle CPU monitoring
monitor-cpu

# Enable all monitoring
monitor-on

# Disable all monitoring
monitor-off
```

## RAM Monitoring

### Displayed Information
- **Recent Operations**: Last 5 memory operations
- **Section Filtering**: 
  - Code (0x1000-0x7FFF)
  - Data (0x8000-0xBFFF)
  - Graphics (0xC000-0xDFFF)
  - Stack (0xE000-0xFEFF)
  - Flags (0xFF00-0xFFFF)

### Operation Details
Each operation shows:
- Memory address
- Read/written value
- Operation type (READ/WRITE)
- Memory section
- Execution tick

### Enable/Disable
```bash
# Check current status
monitor

# Toggle RAM monitoring
monitor-ram

# Enable all monitoring
monitor-on

# Disable all monitoring
monitor-off
```

## Performance Impact

### CPU Monitoring
- Adds per-frame overhead for statistics calculation
- Updates user interface every frame
- Minimal impact on modern systems
- May affect precise timing on slow systems

### RAM Monitoring
- Records each memory operation
- Maintains a buffer of recent operations
- Real-time operation filtering
- More significant impact than CPU monitoring

## Best Practices

1. **Selective Use**
   - Enable only necessary monitoring
   - Disable when not required
   - Use section filters for RAM

2. **Effective Debugging**
   - Enable monitoring only during debugging
   - Use filters to reduce overhead
   - Disable in production

3. **Optimization**
   - Monitor performance impact
   - Adjust update frequency if needed
   - Consider HOST system hardware

## Technical Notes

- Monitoring updates every frame (60 FPS)
- RAM operations are logged in real-time
- CPU usage is calculated as percentage of cycles per frame
- Memory section filters reduce overhead
- System is designed to be non-intrusive when disabled 