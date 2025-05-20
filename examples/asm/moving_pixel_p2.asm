; Lu8 Retro Console
; Two Players Moving Pixels Demo
; 
; Player 1 Controls (Arrow Keys + Z/X):
; - Arrow keys: Move pixel
; - Z (A): Change color (increment)
; - X (B): Change color (decrement)
; - Start/Select: Reset program
;
; Player 2 Controls (WASD + F/G):
; - WASD: Move pixel
; - F (A): Change color (increment)
; - G (B): Change color (decrement)
; - T/LShift: Reset program

; Memory map:
; Player 1:
; 0x8000: P1 X position
; 0x8001: P1 Y position
; 0x8002: P1 color
; 0x8003: P1 input buffer
; 0x8004: P1 temporary storage
;
; Player 2:
; 0x8010: P2 X position
; 0x8011: P2 Y position
; 0x8012: P2 color
; 0x8013: P2 input buffer
; 0x8014: P2 temporary storage

; Initialize starting positions
    ; Player 1 (left side)
    MOV [0x8000], 32      ; P1 X = 32 (left side)
    MOV [0x8001], 64      ; P1 Y = 64 (center)
    MOV [0x8002], 1      ; P1 initial color = 1

    ; Player 2 (right side)
    MOV [0x8010], 96      ; P2 X = 96 (right side)
    MOV [0x8011], 64      ; P2 Y = 64 (center)
    MOV [0x8012], 2      ; P2 initial color = 2

.main_loop:
    ; Clear screen
    MOV [0xD801], 0      ; Set background color to 0
    CLS                       ; Clear screen

    ; Read input for both players
    MOV [0x8003], [0xFF10]    ; Read P1 input register
    MOV [0x8013], [0xFF11]    ; Read P2 input register

    ; Process Player 1 input
    CALL process_p1_input

    ; Process Player 2 input
    CALL process_p2_input

    ; Draw both pixels
    CALL draw_pixels

    VSYNC                     ; Wait for next frame
    JMP .main_loop

; Player 1 input processing
process_p1_input:
    ; Check Start/Select for reset
    MOV [0x8004], [0x8003]
    AND [0x8004], 12      ; Mask for Start/Select
    CMP [0x8004], 0      ; If either is pressed
    JNZ .reset_p1

    ; Check RIGHT
    MOV [0x8004], [0x8003]
    AND [0x8004], 128      ; RIGHT mask
    CMP [0x8004], 128
    JZ .move_p1_right

    ; Check LEFT
    MOV [0x8004], [0x8003]
    AND [0x8004], 64      ; LEFT mask
    CMP [0x8004], 64
    JZ .move_p1_left

    ; Check DOWN
    MOV [0x8004], [0x8003]
    AND [0x8004], 32      ; DOWN mask
    CMP [0x8004], 32
    JZ .move_p1_down

    ; Check UP
    MOV [0x8004], [0x8003]
    AND [0x8004], 16      ; UP mask
    CMP [0x8004], 16
    JZ .move_p1_up

    ; Check A button (increment color)
    MOV [0x8004], [0x8003]
    AND [0x8004], 1      ; A button mask
    CMP [0x8004], 1
    JZ .increment_p1_color

    ; Check B button (decrement color)
    MOV [0x8004], [0x8003]
    AND [0x8004], 2      ; B button mask
    CMP [0x8004], 2
    JZ .decrement_p1_color

    RET

; Player 2 input processing
process_p2_input:
    ; Check Start/Select for reset
    MOV [0x8014], [0x8013]
    AND [0x8014], 12      ; Mask for Start/Select
    CMP [0x8014], 0      ; If either is pressed
    JNZ .reset_p2

    ; Check RIGHT (D key)
    MOV [0x8014], [0x8013]
    AND [0x8014], 128      ; RIGHT mask
    CMP [0x8014], 128
    JZ .move_p2_right

    ; Check LEFT (A key)
    MOV [0x8014], [0x8013]
    AND [0x8014], 64      ; LEFT mask
    CMP [0x8014], 64
    JZ .move_p2_left

    ; Check DOWN (S key)
    MOV [0x8014], [0x8013]
    AND [0x8014], 32      ; DOWN mask
    CMP [0x8014], 32
    JZ .move_p2_down

    ; Check UP (W key)
    MOV [0x8014], [0x8013]
    AND [0x8014], 16      ; UP mask
    CMP [0x8014], 16
    JZ .move_p2_up

    ; Check A button (increment color)
    MOV [0x8014], [0x8013]
    AND [0x8014], 1      ; A button mask
    CMP [0x8014], 1
    JZ .increment_p2_color

    ; Check B button (decrement color)
    MOV [0x8014], [0x8013]
    AND [0x8014], 2      ; B button mask
    CMP [0x8014], 2
    JZ .decrement_p2_color

    RET

; Draw both pixels
draw_pixels:
    ; Draw Player 1 pixel
    MOV [0xD806], [0x8000]    ; Set P1 X position
    MOV [0xD807], [0x8001]    ; Set P1 Y position
    MOV [0xD800], [0x8002]    ; Set P1 color
    PSET                      ; Draw P1 pixel

    ; Draw Player 2 pixel
    MOV [0xD806], [0x8010]    ; Set P2 X position
    MOV [0xD807], [0x8011]    ; Set P2 Y position
    MOV [0xD800], [0x8012]    ; Set P2 color
    PSET                      ; Draw P2 pixel

    RET

; Player 1 movement handlers
.move_p1_right:
    MOV [0x8004], [0x8000]
    CMP [0x8004], 127      ; Check if at right edge (127)
    JZ .p1_done
    INC [0x8000]              ; Increment X
    JMP .p1_done

.move_p1_left:
    MOV [0x8004], [0x8000]
    CMP [0x8004], 0      ; Check if at left edge (0)
    JZ .p1_done
    DEC [0x8000]              ; Decrement X
    JMP .p1_done

.move_p1_down:
    MOV [0x8004], [0x8001]
    CMP [0x8004], 127      ; Check if at bottom edge (127)
    JZ .p1_done
    INC [0x8001]              ; Increment Y
    JMP .p1_done

.move_p1_up:
    MOV [0x8004], [0x8001]
    CMP [0x8004], 0      ; Check if at top edge (0)
    JZ .p1_done
    DEC [0x8001]              ; Decrement Y
    JMP .p1_done

.increment_p1_color:
    MOV [0x8004], [0x8002]
    CMP [0x8004], 15      ; Check if at max color (15)
    JZ .p1_done
    INC [0x8002]              ; Increment color
    JMP .p1_done

.decrement_p1_color:
    MOV [0x8004], [0x8002]
    CMP [0x8004], 0      ; Check if at min color (0)
    JZ .p1_done
    DEC [0x8002]              ; Decrement color
    JMP .p1_done

.reset_p1:
    MOV [0x8000], 32      ; Reset P1 X to left side
    MOV [0x8001], 64      ; Reset P1 Y to center
    MOV [0x8002], 1      ; Reset P1 color to 1
    JMP .p1_done

.p1_done:
    RET

; Player 2 movement handlers
.move_p2_right:
    MOV [0x8014], [0x8010]
    CMP [0x8014], 127      ; Check if at right edge (127)
    JZ .p2_done
    INC [0x8010]              ; Increment X
    JMP .p2_done

.move_p2_left:
    MOV [0x8014], [0x8010]
    CMP [0x8014], 0      ; Check if at left edge (0)
    JZ .p2_done
    DEC [0x8010]              ; Decrement X
    JMP .p2_done

.move_p2_down:
    MOV [0x8014], [0x8011]
    CMP [0x8014], 127      ; Check if at bottom edge (127)
    JZ .p2_done
    INC [0x8011]              ; Increment Y
    JMP .p2_done

.move_p2_up:
    MOV [0x8014], [0x8011]
    CMP [0x8014], 0      ; Check if at top edge (0)
    JZ .p2_done
    DEC [0x8011]              ; Decrement Y
    JMP .p2_done

.increment_p2_color:
    MOV [0x8014], [0x8012]
    CMP [0x8014], 15      ; Check if at max color (15)
    JZ .p2_done
    INC [0x8012]              ; Increment color
    JMP .p2_done

.decrement_p2_color:
    MOV [0x8014], [0x8012]
    CMP [0x8014], 0      ; Check if at min color (0)
    JZ .p2_done
    DEC [0x8012]              ; Decrement color
    JMP .p2_done

.reset_p2:
    MOV [0x8010], 96      ; Reset P2 X to right side
    MOV [0x8011], 64      ; Reset P2 Y to center
    MOV [0x8012], 2      ; Reset P2 color to 2
    JMP .p2_done

.p2_done:
    RET 