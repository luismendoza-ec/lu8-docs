# Author and License

**Author**: Luis A. Mendoza - Creator of Lu8

This documentation is part of the Lu8 Fantasy Console project. While this documentation serves as a reference for the current implementation and capabilities, please note that the project is under active and continuous development, and the documentation may change accordingly.

## License and Copyright

© 2024 Luis A. Mendoza. All rights reserved.

This documentation and the Lu8 Fantasy Console are original works created by Luis A. Mendoza. The Lu8 system is a fictional console design and implementation that does not correspond to any existing hardware or other projects. This is a closed-source project, and all rights to the design, implementation, and documentation are reserved.

---

# Lu8 Input System Documentation

## Overview
The Lu8 Input System provides support for both traditional NES-style controller input and mouse input, making it versatile for different types of games and applications.

## Hardware Emulation

### NES-Style Controller Input
The system emulates two 8-bit input registers similar to the NES controller, where each bit represents a specific button state for each player:

```
Bit Layout (0xFF10 Register - Player 1):
┌─────────┬─────────┬────────┬────────┬─────────┬──────────┬────────┬───────┐
│ Bit 7   │ Bit 6   │ Bit 5  │ Bit 4  │ Bit 3   │ Bit 2    │ Bit 1  │ Bit 0 │
│ RIGHT   │ LEFT    │ DOWN   │ UP     │ START   │ SELECT   │ B      │ A     │
└─────────┴─────────┴────────┴────────┴─────────┴──────────┴────────┴───────┘

Bit Layout (0xFF11 Register - Player 2):
┌─────────┬─────────┬────────┬────────┬─────────┬──────────┬────────┬───────┐
│ Bit 7   │ Bit 6   │ Bit 5  │ Bit 4  │ Bit 3   │ Bit 2    │ Bit 1  │ Bit 0 │
│ RIGHT   │ LEFT    │ DOWN   │ UP     │ START   │ SELECT   │ B      │ A     │
└─────────┴─────────┴────────┴────────┴─────────┴──────────┴────────┴───────┘
```

### Mouse Input
The system provides three additional registers for mouse input:

```
Mouse Position and Button State:
┌─────────────┬─────────────┬─────────────┐
│ 0xFF16      │ 0xFF17      │ 0xFF18      │
│ MOUSE_X     │ MOUSE_Y     │ MOUSE_BTN   │
└─────────────┴─────────────┴─────────────┘

Mouse Button Layout (0xFF18):
┌─────────┬─────────┬────────┬────────┬─────────┬──────────┬────────┬───────┐
│ Bit 7   │ Bit 6   │ Bit 5  │ Bit 4  │ Bit 3   │ Bit 2    │ Bit 1  │ Bit 0 │
│ Unused  │ Unused  │ Unused │ Unused │ Unused  │ Unused   │ Middle │ Left  │
└─────────┴─────────┴────────┴────────┴─────────┴──────────┴────────┴───────┘
```

## Memory Mapping

### Controller Input
- Player 1: `0xFF10` (Read-only)
- Player 2: `0xFF11` (Read-only)
- Player 1 btnp: `0xFF12` (Read-only)
- Player 2 btnp: `0xFF13` (Read-only)
- Input Initial Delay: `0xFF14` (Read/Write)
- Input Repeat Interval: `0xFF15` (Read/Write)

### Mouse Input
- Mouse X Position: `0xFF16` (Read-only) - X coordinate (0-127)
- Mouse Y Position: `0xFF17` (Read-only) - Y coordinate (0-127)
- Mouse Buttons: `0xFF18` (Read-only) - Button state register

## Button Constants

### Controller Buttons
```c
BUTTON_A      = 0x01  // Bit 0
BUTTON_B      = 0x02  // Bit 1
BUTTON_SELECT = 0x04  // Bit 2
BUTTON_START  = 0x08  // Bit 3
BUTTON_UP     = 0x10  // Bit 4
BUTTON_DOWN   = 0x20  // Bit 5
BUTTON_LEFT   = 0x40  // Bit 6
BUTTON_RIGHT  = 0x80  // Bit 7
```

### Mouse Buttons
```c
MOUSE_LEFT   = 0x01  // Bit 0
MOUSE_MIDDLE = 0x02  // Bit 1
MOUSE_RIGHT  = 0x04  // Bit 2
```

## Player Constants
```c
PLAYER_1    = 0       // First player index
PLAYER_2    = 1       // Second player index
MAX_PLAYERS = 2       // Total number of supported players
```

## Keyboard to Console Button Mapping

### Visual Keyboard Layout

```
Player 1 Controls:                    Player 2 Controls:
┌───────────────────────┐            ┌───────────────────────┐
│     [↑]               │            │      [W]              │
│  [←][↓][→]            │            │   [A][S][D]           │
│                       │            │                       │
│  [Z] = A Button       │            │  [F] = A Button       │
│  [X] = B Button       │            │  [G] = B Button       │
│                       │            │                       │
│  [RShift] = Select    │            │  [LShift] = Select    │
│  [Enter]  = Start     │            │  [T]     = Start      │
└───────────────────────┘            └───────────────────────┘
```

### Detailed Mapping

#### Player 1
| Console Button | Keyboard Key | Description                    |
|---------------|--------------|--------------------------------|
| D-Pad Up      | ArrowUp     | Move up/Navigate up            |
| D-Pad Down    | ArrowDown   | Move down/Navigate down        |
| D-Pad Left    | ArrowLeft   | Move left/Navigate left        |
| D-Pad Right   | ArrowRight  | Move right/Navigate right      |
| A Button      | Z           | Primary action/Confirm         |
| B Button      | X           | Secondary action/Cancel        |
| Select        | ShiftRight  | Open menu/Secondary menu       |
| Start         | Enter       | Pause/Start/Menu confirmation  |

#### Player 2
| Console Button | Keyboard Key | Description                    |
|---------------|--------------|--------------------------------|
| D-Pad Up      | W           | Move up/Navigate up            |
| D-Pad Down    | S           | Move down/Navigate down        |
| D-Pad Left    | A           | Move left/Navigate left        |
| D-Pad Right   | D           | Move right/Navigate right      |
| A Button      | F           | Primary action/Confirm         |
| B Button      | G           | Secondary action/Cancel        |
| Select        | ShiftLeft   | Open menu/Secondary menu       |
| Start         | T           | Pause/Start/Menu confirmation  |

### Notes
- Player 1 uses arrow keys for movement, following traditional gaming conventions
- Player 2 uses WASD layout, common in PC gaming
- Action buttons are placed in ergonomic positions for both players
- Select/Start buttons are positioned to avoid accidental presses
- All keys can be pressed simultaneously for complex inputs
- The layout is designed to allow comfortable two-player gameplay on a single keyboard
- Input states are updated every frame
- Button states are automatically cleared on system reset

## Assembly Usage Examples

### 1. Basic Button Check for Both Players
```assembly
; Check if A button is pressed for either player
    MOV [0x8000], [0xFF10]    ; Read Player 1 input register
    MOV [0x8001], [0xFF11]    ; Read Player 2 input register
    
    ; Check Player 1 A button
    MOV [0x8002], [0x8000]
    AND [0x8002], 0x01      ; Mask for A button
    CMP [0x8002], 0x01      ; Compare with A button mask
    JZ .p1_a_pressed
    
    ; Check Player 2 A button
    MOV [0x8002], [0x8001]
    AND [0x8002], 0x01      ; Mask for A button
    CMP [0x8002], 0x01      ; Compare with A button mask
    JZ .p2_a_pressed
```

### 2. Two-Player Movement Example
```assembly
; Handle both players' movement
.check_input:
    ; Player 1 movement
    MOV [0x8000], [0xFF10]    ; Read P1 input
    MOV [0x8001], [0x8000]
    AND [0x8001], 0x80      ; RIGHT mask
    CMP [0x8001], 0x80
    JZ .move_p1_right
    
    ; Player 2 movement
    MOV [0x8002], [0xFF11]    ; Read P2 input
    MOV [0x8003], [0x8002]
    AND [0x8003], 0x80      ; RIGHT mask
    CMP [0x8003], 0x80
    JZ .move_p2_right
    
    ; Continue checking other directions...
```

### 3. Competitive Game Example
```assembly
; Two-player game state check
.game_loop:
    ; Read both player inputs
    MOV [0x8000], [0xFF10]    ; P1 input
    MOV [0x8001], [0xFF11]    ; P2 input
    
    ; Store player positions
    MOV [0x8010], [0xD806]    ; P1 X position
    MOV [0x8011], [0xD807]    ; P1 Y position
    MOV [0x8012], [0xD808]    ; P2 X position
    MOV [0x8013], [0xD809]    ; P2 Y position
    
    ; Process P1 input
    CALL process_p1_input
    
    ; Process P2 input
    CALL process_p2_input
    
    ; Check for collisions
    CALL check_collision
    
    VSYNC
    JMP .game_loop
```

### 1. Mouse Input Example
```assembly
; Read mouse position and draw a square
    ; Read mouse state
    MOV [0x8000], [0xFF16]  ; Mouse X
    MOV [0x8001], [0xFF17]  ; Mouse Y
    MOV [0x8002], [0xFF18]  ; Mouse buttons

    ; Check left button (bit 0)
    MOV [0x8004], [0x8002]
    AND [0x8004], 1
    CMP [0x8004], 1
    JZ .set_red

    ; Default: white
    MOV [0x8003], 7
    JMP .draw

.set_red:
    MOV [0x8003], 8

.draw:
    ; Draw filled rectangle at mouse position
    SETCOLOR [0x8003]
    MOV [0xD80A], [0x8000]  ; FRECT_X
    MOV [0xD80B], [0x8001]  ; FRECT_Y
    MOV [0xD80C], 4         ; FRECT_W
    MOV [0xD80D], 4         ; FRECT_H
    FILLRECT
```

## Lua Scripting – Button Input with `btn()` and `btnp()`

Lu8 supports two input checking functions from Lua scripts:

### `btn()`
```lua
-- Check if the RIGHT button is held by Player 1
if btn(BUTTON_RIGHT) then
  print("Player 1 is moving right!")
end

-- Check if the A button is held by Player 2
if btn(BUTTON_A, PLAYER_2) then
  print("Player 2 pressed A")
end
```

* `btn(mask, player?) → boolean`
* Defaults to Player 1 if `player` is not provided.
* Returns `true` if the specified button is currently held.

### `btnp()`
```lua
-- Check if the A button was just pressed by Player 1
if btnp(BUTTON_A) then
  print("Player 1 just pressed A!")
end

-- Check if the B button was just pressed by Player 2
if btnp(BUTTON_B, PLAYER_2) then
  print("Player 2 just pressed B")
end
```

* `btnp(mask, player?) → boolean`
* Defaults to Player 1 if `player` is not provided.
* Returns `true` if the specified button was just pressed or held long enough to trigger a repeat.
* Emulates PICO-8's btnp() behavior with:
  - Initial delay of 15 frames before repeating
  - Repeat interval of 4 frames after initial delay
  - Detects both initial press and repeat events

These functions abstract the bitmask logic and register reading behind a simple, readable syntax ideal for game logic in Lua.

## Best Practices

1. **Input Reading**: Always read both player inputs at the start of your game loop:
```assembly
    MOV [0x8000], [0xFF10]    ; Store P1 input
    MOV [0x8001], [0xFF11]    ; Store P2 input
```

2. **Input Processing**: Process each player's input separately for cleaner code:
```assembly
    ; Process each player independently
    CALL handle_p1_input
    CALL handle_p2_input
```

3. **State Management**: Keep player states in separate memory regions:
```assembly
    ; Player 1 state: 0x8100-0x810F
    ; Player 2 state: 0x8110-0x811F
```

## Technical Details

### Controller Input
- Each player has their own 8-bit input register
- Both registers are read-only from the VM perspective
- Input states are updated every frame
- Multiple buttons can be pressed simultaneously per player
- Button states are automatically cleared on system reset
- Input handling is synchronized with the frame rate (60 FPS)
- Input events are captured only when the canvas has focus
- The btnp() functionality uses two additional read-only registers (0xFF12, 0xFF13)
- Button press detection includes both initial press and repeat events
- Input timing configuration can be modified through memory-mapped registers:
  - `0xFF14`: Initial delay before repeating (default: 15 frames, set by BIOS)
  - `0xFF15`: Repeat interval after initial delay (default: 4 frames, set by BIOS)
  - Both values must be at least 1 frame
  - Values are reset to BIOS defaults on system reset

### Mouse Input
- Mouse coordinates are scaled to fit the 128x128 screen
- X and Y positions are clamped to 0-127 range
- Mouse button states are updated in real-time
- Mouse input is only captured when the canvas has focus
- Right-click context menu is automatically prevented
- Mouse position is relative to the canvas element
- Mouse input is synchronized with the frame rate (60 FPS)

## Limitations

### Controller Input
- Maximum of 2 players supported
- No analog input support
- No input buffering at the hardware level
- 8 buttons per player maximum due to 8-bit register limitation
- No support for additional controller types
- Input is only captured when the canvas has focus
- No support for gamepad/controller input
- Input timing configuration values must be at least 1 frame

### Mouse Input
- Limited to 128x128 resolution
- Only three mouse buttons supported (left, middle, right)
- No support for mouse wheel
- No support for additional mouse buttons
- Mouse input is only captured when the canvas has focus
- No support for absolute positioning devices
- No support for touch input 