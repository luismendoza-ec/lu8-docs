# Author and License

**Author**: Luis A. Mendoza - Creator of Lu8

This documentation is part of the Lu8 Fantasy Console project. While this documentation serves as a reference for the current implementation and capabilities, please note that the project is under active and continuous development, and the documentation may change accordingly.

## License and Copyright

© 2024 Luis A. Mendoza. All rights reserved.

This documentation and the Lu8 Fantasy Console are original works created by Luis A. Mendoza. The Lu8 system is a fictional console design and implementation that does not correspond to any existing hardware or other projects. This is a closed-source project, and all rights to the design, implementation, and documentation are reserved.

---

# Lu8 Audio Processing Unit (APU) Documentation

The Lu8 APU is inspired by the NES sound chip, featuring 5 audio channels with distinct characteristics for creating music and sound effects.

## Table of Contents
- [Channel Overview](#channel-overview)
- [Memory Map](#memory-map)
- [Channel Details](#channel-details)
  - [Pulse Channels](#pulse-channels)
  - [Triangle Channel](#triangle-channel)
  - [Noise Channel](#noise-channel)
  - [DMC Channel](#dmc-channel)
- [Programming Examples](#programming-examples)
  - [Basic Sound Generation](#basic-sound-generation)
  - [Music Examples](#music-examples)
  - [Sound Effects](#sound-effects)
  - [Advanced Techniques](#advanced-techniques)

## Channel Overview

The APU features 5 distinct audio channels:

1. **Pulse 1**: Square wave with variable duty cycle, sweep, and envelope
2. **Pulse 2**: Identical to Pulse 1, typically used for harmony
3. **Triangle**: Fixed triangle wave, ideal for bass lines
4. **Noise**: White noise generator for percussion
5. **DMC** (Delta Modulation Channel): Sample playback

## Memory Map

The APU occupies memory addresses from `0xD820` to `0xD8AF`. Each channel has 16 bytes of registers:

| Channel   | Base Address | End Address |
|-----------|-------------|-------------|
| Pulse 1   | 0xD820      | 0xD82F      |
| Pulse 2   | 0xD830      | 0xD83F      |
| Triangle  | 0xD840      | 0xD84F      |
| Noise     | 0xD850      | 0xD85F      |
| DMC       | 0xD860      | 0xD86F      |

### Register Layout per Channel

| Offset | Name      | Description                    | Channels       |
|--------|-----------|--------------------------------|----------------|
| 0      | CTRL      | Control (enable/loop)          | All           |
| 1      | VOL       | Volume/Envelope                | All except Triangle |
| 2      | SWEEP     | Sweep control                  | Pulse only    |
| 3      | FREQ_L    | Frequency (low byte)           | All           |
| 4      | FREQ_H    | Frequency (high byte)          | All           |
| 5      | DUTY      | Duty cycle                     | Pulse only    |
| 6      | LENGTH    | Sound length                   | All           |
| 7      | PHASE     | Phase                          | All           |
| 8      | DMC_DATA  | Sample data                    | DMC only      |
| 9      | DMC_RATE  | Playback rate                  | DMC only      |
| 10     | DMC_LOOP  | Loop control                   | DMC only      |
| 11-15  | RESERVED  | Reserved for future use        | All           |

## Channel Details

### Pulse Channels

Both Pulse 1 and Pulse 2 are square wave generators with the following features:

- **Duty Cycles**: 4 preset ratios
  - 0: 12.5% (thin sound)
  - 1: 25% (standard square)
  - 2: 50% (full square)
  - 3: 75% (inverse 25%)

- **Sweep Unit**:
  - Period: 0-7 (higher = slower)
  - Direction: 0 = increase, 1 = decrease
  - Shift: 0-7 (amount of frequency change)

- **Volume Envelope**:
  - Initial volume: 0-15
  - Decay rate: 0-15
  - Loop flag

#### Example: Basic Pulse Setup
```assembly
; Configure Pulse 1 for a sustained note
MOV [0xD820], 0       ; Disable channel
MOV [0xD821], 0xCF    ; Volume 12 + envelope enabled
MOV [0xD822], 0x70    ; Sweep: period 7, no negate
MOV [0xD825], 2       ; 50% duty cycle
MOV [0xD823], 152     ; Frequency low (C5 note)
MOV [0xD824], 2       ; Frequency high
MOV [0xD820], 3       ; Enable + loop
```

### Triangle Channel

The Triangle channel produces a fixed triangle waveform:

- No volume control
- Smoother sound than pulse waves
- Ideal for bass lines and smooth melodies

#### Example: Triangle Bass Line
```assembly
; Configure Triangle for bass note
MOV [0xD840], 0       ; Disable channel
MOV [0xD846], 255     ; Maximum length
MOV [0xD843], 97      ; Frequency low (G4 note)
MOV [0xD844], 1       ; Frequency high
MOV [0xD840], 3       ; Enable + loop
```

### Noise Channel

The Noise channel generates pseudo-random waveforms:

- Variable frequency for different noise "colors"
- Volume envelope support
- Perfect for percussion and effects

#### Example: Hi-hat Sound
```assembly
; Configure Noise for hi-hat
MOV [0xD850], 0       ; Disable channel
MOV [0xD851], 0x8F    ; Volume 8 + fast decay
MOV [0xD853], 0x0A    ; High frequency noise
MOV [0xD856], 10      ; Short length
MOV [0xD850], 1       ; Enable (no loop)
```

### DMC Channel

The Delta Modulation Channel plays back digital samples:

- 1-bit delta encoding
- Variable playback rate
- 256-byte sample buffer

#### Example: Playing a Sample
```assembly
; Configure DMC for sample playback
MOV [0xD860], 0       ; Disable channel
MOV [0xD869], 64      ; Set playback rate
MOV [0xD86A], 1       ; Enable loop

; Load sample data
MOV [0xD868], 127     ; Sample data
MOV [0xD868], 64      ; Next sample
MOV [0xD868], 32      ; Next sample
; ... more sample data ...

MOV [0xD860], 3       ; Enable + loop
```

## Programming Examples

### Basic Sound Generation

1. **Simple Beep**
```assembly
; Generate a 440Hz beep
MOV [0xD820], 0       ; Disable Pulse 1
MOV [0xD821], 0x8F    ; Volume 8
MOV [0xD825], 2       ; 50% duty
MOV [0xD823], 68      ; Freq low (A4)
MOV [0xD824], 2       ; Freq high
MOV [0xD820], 1       ; Enable (no loop)
```

2. **Sliding Tone**
```assembly
; Create frequency slide effect
MOV [0xD820], 0       ; Disable Pulse 1
MOV [0xD821], 0x8F    ; Volume 8
MOV [0xD822], 0x41    ; Sweep down
MOV [0xD825], 2       ; 50% duty
MOV [0xD823], 255     ; Start frequency
MOV [0xD824], 2
MOV [0xD820], 3       ; Enable + loop
```

### Music Examples

1. **Simple Melody (Mary Had a Little Lamb)**
```assembly
; Setup Pulse 1
MOV [0xD820], 0
MOV [0xD821], 0xCF    ; Volume 12 + envelope
MOV [0xD825], 2       ; 50% duty

; E4
MOV [0xD823], 169
MOV [0xD824], 1
MOV [0xD820], 1
VSYNC
VSYNC
VSYNC

; D4
MOV [0xD823], 190
MOV [0xD824], 1
MOV [0xD820], 1
VSYNC
VSYNC
VSYNC

; C4
MOV [0xD823], 214
MOV [0xD824], 1
MOV [0xD820], 1
VSYNC
VSYNC
VSYNC

; D4
MOV [0xD823], 190
MOV [0xD824], 1
MOV [0xD820], 1
VSYNC
VSYNC
VSYNC
```

2. **Three-Channel Harmony**
```assembly
; Setup all channels
; Pulse 1 (melody)
MOV [0xD820], 0
MOV [0xD821], 0xCF    ; Volume 12 + envelope
MOV [0xD825], 2       ; 50% duty

; Pulse 2 (harmony)
MOV [0xD830], 0
MOV [0xD831], 0x8F    ; Volume 8 + envelope
MOV [0xD835], 1       ; 25% duty

; Triangle (bass)
MOV [0xD840], 0
MOV [0xD846], 255     ; Full length

; Play C major chord
MOV [0xD823], 152     ; C5 (melody)
MOV [0xD824], 2
MOV [0xD820], 3

MOV [0xD833], 114     ; E5 (harmony)
MOV [0xD834], 2
MOV [0xD830], 3

MOV [0xD843], 97      ; G4 (bass)
MOV [0xD844], 1
MOV [0xD840], 3
```

### Sound Effects

1. **Explosion Effect**
```assembly
; Using Noise + Pulse for explosion
; Noise component
MOV [0xD850], 0
MOV [0xD851], 0xFF    ; Full volume + decay
MOV [0xD853], 0x02    ; Low frequency noise
MOV [0xD856], 30      ; Medium length
MOV [0xD850], 1       ; Enable

; Pulse component (rumble)
MOV [0xD820], 0
MOV [0xD821], 0xCF
MOV [0xD822], 0x71    ; Sweep down
MOV [0xD825], 3       ; 75% duty
MOV [0xD823], 50      ; Low frequency
MOV [0xD824], 0
MOV [0xD820], 1
```

2. **Coin Pickup**
```assembly
; High-pitched ascending beep
MOV [0xD820], 0
MOV [0xD821], 0x8F    ; Volume 8 + decay
MOV [0xD822], 0x30    ; Sweep up
MOV [0xD825], 1       ; 25% duty
MOV [0xD823], 200     ; Start frequency
MOV [0xD824], 1
MOV [0xD826], 10      ; Short duration
MOV [0xD820], 1       ; Enable once
```

### Advanced Techniques

1. **Arpeggio Effect**
```assembly
; Rapid chord arpeggio
arpeggio:
    ; C4
    MOV [0xD823], 214
    MOV [0xD824], 1
    MOV [0xD820], 1
    VSYNC

    ; E4
    MOV [0xD823], 169
    MOV [0xD824], 1
    MOV [0xD820], 1
    VSYNC

    ; G4
    MOV [0xD823], 142
    MOV [0xD824], 1
    MOV [0xD820], 1
    VSYNC

    JMP arpeggio
```

2. **Echo Effect**
```assembly
; Using two pulse channels for echo
; Main sound
MOV [0xD820], 0
MOV [0xD821], 0xCF
MOV [0xD825], 2
MOV [0xD823], 152
MOV [0xD824], 2
MOV [0xD820], 1

; Echo (lower volume, slight delay)
VSYNC
VSYNC
MOV [0xD830], 0
MOV [0xD831], 0x4F    ; Lower volume
MOV [0xD835], 2
MOV [0xD833], 152
MOV [0xD834], 2
MOV [0xD830], 1
```

## Frequency Table

Here's a table of common musical notes and their frequency values:

| Note | Frequency (Hz) | Low Byte | High Byte |
|------|---------------|----------|------------|
| C4   | 261.63        | 214      | 1         |
| D4   | 293.66        | 190      | 1         |
| E4   | 329.63        | 169      | 1         |
| F4   | 349.23        | 160      | 1         |
| G4   | 392.00        | 142      | 1         |
| A4   | 440.00        | 127      | 1         |
| B4   | 493.88        | 113      | 1         |
| C5   | 523.25        | 107      | 1         |

## Tips and Best Practices

1. Always disable a channel before configuring it
2. Use envelope and sweep for more dynamic sounds
3. The Triangle channel is best for bass lines due to its smooth waveform
4. Combine multiple channels for richer sounds
5. Use the Noise channel sparingly to avoid overwhelming the mix
6. Keep DMC samples short to conserve memory

## Troubleshooting

Common issues and solutions:

1. **No Sound**
   - Check if channel is enabled (CTRL register)
   - Verify volume settings
   - Ensure frequency values are in valid range

2. **Distorted Sound**
   - Check for frequency overflow
   - Reduce number of active channels
   - Verify sweep settings

3. **Clicks/Pops**
   - Disable channel before changing frequency
   - Use envelope for volume changes
   - Implement smooth transitions

## Performance Considerations

- The APU updates at 44.1kHz
- Each channel consumes CPU cycles
- DMC playback requires careful memory management
- Excessive use of VSYNC can affect timing

## Register Quick Reference

### Pulse Channels (0xD820-0xD82F, 0xD830-0xD83F)
```
CTRL    = Base + 0    ; %000000LC (L=Loop, C=Channel Enable)
VOL     = Base + 1    ; %VVVVDDDD (V=Volume, D=Decay)
SWEEP   = Base + 2    ; %EPPPNSSS (E=Enable, P=Period, N=Negate, S=Shift)
FREQ_L  = Base + 3    ; Frequency LSB
FREQ_H  = Base + 4    ; Frequency MSB
DUTY    = Base + 5    ; 0-3 (12.5%, 25%, 50%, 75%)
LENGTH  = Base + 6    ; Sound length (0=Infinite)
PHASE   = Base + 7    ; Initial phase
```

### Triangle Channel (0xD840-0xD84F)
```
CTRL    = 0xD840      ; %000000LC
FREQ_L  = 0xD843      ; Frequency LSB
FREQ_H  = 0xD844      ; Frequency MSB
LENGTH  = 0xD846      ; Sound length
```

### Noise Channel (0xD850-0xD85F)
```
CTRL    = 0xD850      ; %000000LC
VOL     = 0xD851      ; %VVVVDDDD
FREQ_L  = 0xD853      ; Noise period
LENGTH  = 0xD856      ; Sound length
```

### DMC Channel (0xD860-0xD86F)
```
CTRL    = 0xD860      ; %000000LC (L=Loop, C=Channel Enable)
DATA    = 0xD868      ; Sample data
RATE    = 0xD869      ; Playback rate
LOOP    = 0xD86A      ; Loop control
RESERVED = 0xD86B-0xD86F ; Reserved for future use
```
