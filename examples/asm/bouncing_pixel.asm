; Bouncing Pixel (Left ↔ Right)
; Uses CMP with immediates like 0xFE01 for value 1

start:
    MOV [0x8000], 0         ; logic_x (in data section)
    MOV [0xD806], 0         ; RECT_X (used by PSET)
    MOV [0xD807], 64        ; RECT_Y (used by PSET)
    ; MOV [0xD800], 8         ; PPU_COLOR (red)
    MOV [0x8001], 1         ; dir (1 = right) (in data section)
    MOV [0x8002], 127       ; max x (in data section)

main_loop:
    CLS

    CMP [0x8001], 1    ; if dir == 1
    JEQ dir_right

    ; else: direction is left
    CMP [0x8000], 0    ; if x == 0
    JEQ switch_right
    DEC [0x8000]
    JMP draw

dir_right:
    CMP [0x8000], [0x8002]  ; if x == max
    JEQ switch_left
    INC [0x8000]
    JMP draw

switch_left:
    MOV [0x8001], 0         ; dir = left
    JMP draw

switch_right:
    MOV [0x8001], 1         ; dir = right
    JMP draw

draw:
    MOV [0xD806], [0x8000]  ; logic_x → RECT_X
    SETCOLOR 8                
    PSET                    ; Draw using RECT_X, RECT_Y
    VSYNC
    JMP main_loop
