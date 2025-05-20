; Lu8 Retro Console
; Moving Pixel Demo with Input Controls
; Controls:
; - Arrow keys: Move pixel
; - A: Change color (increment)
; - B: Change color (decrement)
; - Start/Select: Reset program

; Memory map:
; 0x8000: Current X position
; 0x8001: Current Y position
; 0x8002: Current color
; 0x8003: Input buffer
; 0x8004: Temporary storage

; Initialize starting position (center of screen)
    MOV [0x8000], 64      ; X = 64 (center)
    MOV [0x8001], 64      ; Y = 64 (center)
    MOV [0x8002], 1      ; Initial color = 1

.main_loop:
    ; Clear screen
    MOV [0xD801], 0      ; Set background color to 0
    CLS                       ; Clear screen

    ; Read input
    MOV [0x8003], [0xFF10]    ; Read input register

    ; Check Start/Select for reset
    MOV [0x8004], [0x8003]
    AND [0x8004], 12      ; Mask for Start/Select
    CMP [0x8004], 0      ; If either is pressed
    JNZ .reset_program

    ; Check directional input
    ; Check RIGHT
    MOV [0x8004], [0x8003]
    AND [0x8004], 128      ; RIGHT mask
    CMP [0x8004], 128
    JZ .move_right

    ; Check LEFT
    MOV [0x8004], [0x8003]
    AND [0x8004], 64      ; LEFT mask
    CMP [0x8004], 64
    JZ .move_left

    ; Check DOWN
    MOV [0x8004], [0x8003]
    AND [0x8004], 32      ; DOWN mask
    CMP [0x8004], 32
    JZ .move_down

    ; Check UP
    MOV [0x8004], [0x8003]
    AND [0x8004], 16      ; UP mask
    CMP [0x8004], 16
    JZ .move_up

    ; Check A button (increment color)
    MOV [0x8004], [0x8003]
    AND [0x8004], 1      ; A button mask
    CMP [0x8004], 1
    JZ .increment_color

    ; Check B button (decrement color)
    MOV [0x8004], [0x8003]
    AND [0x8004], 2      ; B button mask
    CMP [0x8004], 2
    JZ .decrement_color

.draw_pixel:
    ; Set pixel position
    MOV [0xD806], [0x8000]    ; Set X position
    MOV [0xD807], [0x8001]    ; Set Y position
    MOV [0xD800], [0x8002]    ; Set color
    PSET                      ; Draw pixel

    VSYNC                     ; Wait for next frame
    JMP .main_loop

.move_right:
    MOV [0x8004], [0x8000]
    CMP [0x8004], 127      ; Check if at right edge (127)
    JZ .draw_pixel
    INC [0x8000]              ; Increment X
    JMP .draw_pixel

.move_left:
    MOV [0x8004], [0x8000]
    CMP [0x8004], 0      ; Check if at left edge (0)
    JZ .draw_pixel
    DEC [0x8000]              ; Decrement X
    JMP .draw_pixel

.move_down:
    MOV [0x8004], [0x8001]
    CMP [0x8004], 127      ; Check if at bottom edge (127)
    JZ .draw_pixel
    INC [0x8001]              ; Increment Y
    JMP .draw_pixel

.move_up:
    MOV [0x8004], [0x8001]
    CMP [0x8004], 0      ; Check if at top edge (0)
    JZ .draw_pixel
    DEC [0x8001]              ; Decrement Y
    JMP .draw_pixel

.increment_color:
    MOV [0x8004], [0x8002]
    CMP [0x8004], 15      ; Check if at max color (15)
    JZ .draw_pixel
    INC [0x8002]              ; Increment color
    JMP .draw_pixel

.decrement_color:
    MOV [0x8004], [0x8002]
    CMP [0x8004], 0      ; Check if at min color (0)
    JZ .draw_pixel
    DEC [0x8002]              ; Decrement color
    JMP .draw_pixel

.reset_program:
    ; Reset to initial state
    MOV [0x8000], 64      ; Reset X to center
    MOV [0x8001], 64      ; Reset Y to center
    MOV [0x8002], 1      ; Reset color to 1
    JMP .draw_pixel 