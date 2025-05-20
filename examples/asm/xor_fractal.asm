; XOR fractal pattern using PSET

    MOV [0x8000], 0    ; y = 0

.loop_y:
    CMP [0x8000], 127    ; if y > 127
    JG .done

    MOV [0x8001], 0    ; x = 0

.loop_x:
    CMP [0x8001], 127    ; if x > 127
    JG .next_y

    ; Calculate color = (x ^ y) & 0x0F
    MOV [0x8002], [0x8001]  ; temp = x
    XOR [0x8002], [0x8000]  ; temp ^= y
    AND [0x8002], 0x0F    ; color = temp & 0x0F

    ; Set pixel coordinates
    MOV [0xD806], [0x8001]  ; RECT_X = x
    MOV [0xD807], [0x8000]  ; RECT_Y = y
    MOV [0xD800], [0x8002]  ; PPU_COLOR = color
    PSET

    INC [0x8001]
    JMP .loop_x

.next_y:
    INC [0x8000]
    JMP .loop_y

.done:
    VSYNC
    JMP .done              ; freeze on frame
