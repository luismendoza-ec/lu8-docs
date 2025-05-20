; Rolling Ball - Left to Right and Wrap
; Memory map:
; Data Section (0x8000-0x8FFF):
; 0x8000: ball_x
; 0x8001: ball_y
; 0x8002: ball_dx
;
; PPU Registers (0xD800-0xDFFF):
; 0xD800: PPU_COLOR
; 0xD80E: CIRC_X
; 0xD80F: CIRC_Y
; 0xD810: CIRC_R

start:
    MOV [0x8000], 0      ; ball_x = 0
    MOV [0x8001], 64     ; ball_y = 64
    MOV [0x8002], 2      ; dx = 2
    MOV [0xD810], 5      ; CIRC_R = 5 (radius)

main_loop:
    CLS

    ; Update position
    ADD [0x8000], [0x8002]   ; x += 2

    ; If x >= 126, reset to 0 (simulate wrap)
    CMP [0x8000], 126
    JNZ skip_reset
    MOV [0x8000], 0

skip_reset:
    ; Copy position to PPU circle registers
    MOV [0xD80E], [0x8000]   ; CIRC_X = ball_x
    MOV [0xD80F], [0x8001]   ; CIRC_Y = ball_y

    SETCOLOR 8                ; Use current PPU_COLOR
    CIRCLE                  ; Draw using CIRC_X, CIRC_Y, CIRC_R
    VSYNC
    JMP main_loop