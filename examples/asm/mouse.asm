; This program reads the mouse position and button state,
; and draws a 4x4 square at the cursor position.
; If the left button is pressed, it draws red (color 8),
; otherwise it draws white (color 7).

.main_loop:
    ; --------------------------------
    ; Clear screen first
    ; --------------------------------
    MOV [0xD801], 0    ; Background color = black
    CLS

    ; --------------------------------
    ; Read mouse state
    ; --------------------------------
    MOV [0x8000], [0xFF16]  ; Mouse X
    MOV [0x8001], [0xFF17]  ; Mouse Y
    MOV [0x8002], [0xFF18]  ; Mouse buttons

    ; --------------------------------
    ; Check left button (bit 0)
    ; --------------------------------
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
    ; --------------------------------
    ; Setup FILLRECT
    ; --------------------------------
    SETCOLOR [0x8003]

    MOV [0xD80A], [0x8000]  ; FRECT_X
    MOV [0xD80B], [0x8001]  ; FRECT_Y
    MOV [0xD80C], 4         ; FRECT_W
    MOV [0xD80D], 4         ; FRECT_H
    FILLRECT

    ; --------------------------------
    ; Wait and loop
    ; --------------------------------
    VSYNC
    JMP .main_loop
