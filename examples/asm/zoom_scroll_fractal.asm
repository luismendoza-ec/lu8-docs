; Zooming stripes with XOR waves

    MOV [0x8000], 0

.loop_y:
    CMP [0x8000], 127
    JG .done

    MOV [0x8001], 0

.loop_x:
    CMP [0x8001], 127
    JG .next_y

    ; color = ((x*3) ^ (y*7)) & 0x0F
    MOV [0x8002], [0x8001]
    MUL [0x8002], 3

    MOV [0x8003], [0x8000]
    MUL [0x8003], 7

    XOR [0x8002], [0x8003]
    AND [0x8002], 0x0F

    MOV [0xD806], [0x8001]
    MOV [0xD807], [0x8000]
    MOV [0xD800], [0x8002]
    PSET

    INC [0x8001]
    JMP .loop_x

.next_y:
    INC [0x8000]
    JMP .loop_y

.done:
    VSYNC
    JMP .done
