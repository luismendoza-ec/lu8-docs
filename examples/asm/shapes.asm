; === Test of PPU: Rect, FillRect, Line, Circle ===
start:
    ; Black background
    MOV [0xD801], 2
    CLS

.loop:
    ; White rectangle (border)  
    SETCOLOR 7 ; white
    MOV [0xD806], 10       ; RECT_X
    MOV [0xD807], 10       ; RECT_Y
    MOV [0xD808], 50       ; RECT_W
    MOV [0xD809], 30       ; RECT_H
    RECT

    ; Red filled rectangle
    SETCOLOR 8 ; red
    MOV [0xD80A], 70       ; FRECT_X
    MOV [0xD80B], 10       ; FRECT_Y
    MOV [0xD80C], 40       ; FRECT_W
    MOV [0xD80D], 20       ; FRECT_H
    FILLRECT

    ; Green circle
    SETCOLOR 10 ; green
    MOV [0xD80E], 40       ; CIRC_X
    MOV [0xD80F], 60       ; CIRC_Y
    MOV [0xD810], 10       ; CIRC_R
    CIRCLE

    ; Blue line
    SETCOLOR 12 ; blue
    MOV [0xD802], 0        ; LINE_X1
    MOV [0xD803], 127      ; LINE_Y1
    MOV [0xD804], 127      ; LINE_X2
    MOV [0xD805], 0        ; LINE_Y2
    LINE

    ; Wait for next frame
    VSYNC
    JMP .loop
