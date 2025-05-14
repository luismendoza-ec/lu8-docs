# Lu8 Input System Documentation

## Overview
The Lu8 Input System is designed to mimic the NES (Nintendo Entertainment System) controller functionality, providing support for two players with a familiar input interface for retro-style games and applications.

## Note
This documentation is a work in progress and may change as the project evolves. Features, syntax, and behavior are subject to revision during development.

## Hardware Emulation
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

## Memory Mapping
The input states are mapped to memory addresses:
- Player 1: `0xFF10` (Read-only)
- Player 2: `0xFF11` (Read-only)

## Button Constants
The following button masks are defined for easy access:
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
│     [↑]              │            │      [W]              │
│  [←][↓][→]          │            │   [A][S][D]          │
│                      │            │                      │
│  [Z] = A Button      │            │  [F] = A Button      │
│  [X] = B Button      │            │  [G] = B Button      │
│                      │            │                      │
│  [RShift] = Select   │            │  [LShift] = Select   │
│  [Enter]  = Start    │            │  [T]     = Start     │
└───────────────────────┘            └───────────────────────┘
```

### Detailed Mapping

#### Player 1
| Console Button | Keyboard Key | Description                    |
|---------------|--------------|--------------------------------|
| D-Pad Up      | ↑ (Up)      | Move up/Navigate up            |
| D-Pad Down    | ↓ (Down)    | Move down/Navigate down        |
| D-Pad Left    | ← (Left)    | Move left/Navigate left        |
| D-Pad Right   | → (Right)   | Move right/Navigate right      |
| A Button      | Z           | Primary action/Confirm         |
| B Button      | X           | Secondary action/Cancel        |
| Select        | Right Shift | Open menu/Secondary menu       |
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
| Select        | Left Shift  | Open menu/Secondary menu       |
| Start         | T           | Pause/Start/Menu confirmation  |

### Notes
- Player 1 uses arrow keys for movement, following traditional gaming conventions
- Player 2 uses WASD layout, common in PC gaming
- Action buttons are placed in ergonomic positions for both players
- Select/Start buttons are positioned to avoid accidental presses
- All keys can be pressed simultaneously for complex inputs
- The layout is designed to allow comfortable two-player gameplay on a single keyboard

## Assembly Usage Examples

### 1. Basic Button Check for Both Players
```assembly
; Check if A button is pressed for either player
    MOV [0x8000], [0xFF10]    ; Read Player 1 input register
    MOV [0x8001], [0xFF11]    ; Read Player 2 input register
    
    ; Check Player 1 A button
    MOV [0x8002], [0x8000]
    AND [0x8002], 0xFE01      ; Mask for A button
    CMP [0x8002], 0xFE01      ; Compare with A button mask
    JZ .p1_a_pressed
    
    ; Check Player 2 A button
    MOV [0x8002], [0x8001]
    AND [0x8002], 0xFE01      ; Mask for A button
    CMP [0x8002], 0xFE01      ; Compare with A button mask
    JZ .p2_a_pressed
```

### 2. Two-Player Movement Example
```assembly
; Handle both players' movement
.check_input:
    ; Player 1 movement
    MOV [0x8000], [0xFF10]    ; Read P1 input
    MOV [0x8001], [0x8000]
    AND [0x8001], 0xFE80      ; RIGHT mask
    CMP [0x8001], 0xFE80
    JZ .move_p1_right
    
    ; Player 2 movement
    MOV [0x8002], [0xFF11]    ; Read P2 input
    MOV [0x8003], [0x8002]
    AND [0x8003], 0xFE80      ; RIGHT mask
    CMP [0x8003], 0xFE80
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

- Each player has their own 8-bit input register
- Both registers are read-only from the VM perspective
- Input states are updated every frame
- Multiple buttons can be pressed simultaneously per player
- Button states are automatically cleared on system reset

## Limitations

- Maximum of 2 players supported
- No analog input support
- No input buffering at the hardware level
- 8 buttons per player maximum due to 8-bit register limitation
- No support for additional controller types 