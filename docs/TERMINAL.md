# Author and License

**Author**: Luis A. Mendoza - Creator of Lu8

This documentation is part of the Lu8 Fantasy Console project. While this documentation serves as a reference for the current implementation and capabilities, please note that the project is under active and continuous development, and the documentation may change accordingly.

## License and Copyright

© 2024 Luis A. Mendoza. All rights reserved.

This documentation and the Lu8 Fantasy Console are original works created by Luis A. Mendoza. The Lu8 system is a fictional console design and implementation that does not correspond to any existing hardware or other projects. This is a closed-source project, and all rights to the design, implementation, and documentation are reserved.

---

# Lu8 Terminal Documentation

The Lu8 Terminal is a web-based command-line interface that provides control over the Lu8 Virtual Machine and its components. It offers a set of commands for managing the VM, loading and saving programs, monitoring system resources, and more.

## Features

- Interactive command-line interface with syntax highlighting
- Real-time system monitoring
- File management for ASM and binary files
- VM control commands
- System status information

## Command Reference

### System Control Commands

#### `start`
Starts the Lu8 VM and runs the current code.
- Enables pause, shutdown, and reboot buttons
- Disables the run button
- Initializes the VM with current program

#### `reboot`
Reboots the Lu8 VM with the current code.
- Performs a clean shutdown first
- Reinitializes the VM
- Maintains current program state

#### `pause`
Pauses the Lu8 VM execution.
- Disables pause button
- Enables run button (changes to resume)
- Preserves VM state

#### `resume`
Resumes the Lu8 VM execution after a pause.
- Disables run button
- Enables pause button
- Continues from paused state

#### `shutdown`
Shuts down the Lu8 VM.
- Disables pause, shutdown, and reboot buttons
- Enables run button
- Cleans up VM resources

### File Management Commands

#### `load`
Opens a file dialog to load an ASM file.
- Supports .asm files
- Loads code into the editor
- Preserves current VM state

#### `rom`
Opens a file dialog to load and run a binary file.
- Supports .lu8 files
- Loads and executes binary directly
- Bypasses editor

#### `save`
Opens a file dialog to save the current ASM code.
- Saves current editor content
- Supports .asm files
- Preserves formatting

#### `compile`
Compiles the current code and saves it as a binary file.
- Creates .lu8 binary file
- Includes proper headers
- Ready for direct execution

### Monitoring Commands

#### `monitor`
Shows current monitoring status.
- Displays CPU monitoring state
- Shows RAM monitoring state
- Provides real-time status

#### `monitor-cpu`
Toggles CPU monitoring.
- Enables/disables CPU usage tracking
- Updates monitoring display
- Affects performance metrics

#### `monitor-ram`
Toggles RAM monitoring.
- Enables/disables RAM usage tracking
- Updates memory display
- Shows memory allocation

#### `monitor-on`
Enables all monitoring features.
- Activates CPU monitoring
- Activates RAM monitoring
- Updates all displays

#### `monitor-off`
Disables all monitoring features.
- Deactivates CPU monitoring
- Deactivates RAM monitoring
- Reduces overhead

### Utility Commands

#### `help`
Shows available commands.
- Lists all commands
- Provides brief descriptions
- Shows command syntax

#### `status`
Shows the current status of the Lu8 VM.
- Displays running state
- Shows CPU usage percentage
- Indicates if VM is paused

#### `clear`
Clears the terminal.
- Removes all output
- Resets prompt
- Maintains command history

## Terminal Features

### Syntax Highlighting
The terminal provides color-coded output for:
- Information messages (green)
- Warning messages (yellow)
- Error messages (red)
- Hexadecimal values (magenta)
- Decimal numbers (cyan)

### Command History
- Maintains command history
- Supports command recall
- Preserves session history

### Error Handling
- Clear error messages
- Command validation
- State-aware feedback

## Usage Examples

### Basic VM Control
```bash
$ status
VM is powered off
$ start
[INFO] VM started
$ pause
[INFO] VM paused
$ resume
[INFO] VM resumed
$ shutdown
[INFO] VM shut down
```

### File Operations
```bash
$ load
[INFO] Loading ASM file...
$ save
[INFO] Saving ASM file...
$ compile
[INFO] Compiling to binary...
$ rom
[INFO] Loading ROM file...
```

### Monitoring
```bash
$ monitor
Monitoring Status:
  CPU: Enabled
  RAM: Disabled
$ monitor-ram
RAM monitoring enabled
$ monitor-off
All monitoring disabled
```

## Notes

- The terminal is integrated with the Lu8 development environment
- Commands are case-sensitive
- Some commands require specific VM states to function
- Monitoring commands may impact performance
- File operations are handled through the browser's file system 