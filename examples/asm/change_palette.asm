; ========================================
; Test restoring Lu8 palette at runtime
; ========================================

start:
    ; Overwrite color index 8 (#FF004D by default) with lime green (#00FF00)
    MOV [0xD868], 0      ; Red component
    MOV [0xD869], 255    ; Green component
    MOV [0xD86A], 0      ; Blue component

    ; Set background color to 0 (black)
    MOV [0xD801], 0
    CLS

    ; Set draw color to color 8
    ; MOV [0xD800], 8
    SETCOLOR 8

    ; Draw a filled rectangle in lime green
    MOV [0xD80A], 20     ; FRECT_X
    MOV [0xD80B], 20     ; FRECT_Y
    MOV [0xD80C], 80     ; FRECT_W
    MOV [0xD80D], 80     ; FRECT_H
    FILLRECT

    ; Wait ~60 frames (~1 second at 60 FPS)
    MOV [0x8000], 60
.delay_loop:
    VSYNC
    DEC [0x8000]
    CMP [0x8000], 0
    JNZ .delay_loop

    ; Restore palette to default (red is back at index 8)
    RSTPAL

    ; Set background color to 0 (black)
    MOV [0xD801], 0
    CLS

    ; Use index 8 again — now it's red (#FF004D)
    ; MOV [0xD800], 8
    SETCOLOR 8

    ; Draw same rectangle again with restored color
    MOV [0xD80A], 20     ; FRECT_X
    MOV [0xD80B], 20     ; FRECT_Y
    MOV [0xD80C], 80     ; FRECT_W
    MOV [0xD80D], 80     ; FRECT_H
    FILLRECT

.loop:
    VSYNC
    JMP .loop
