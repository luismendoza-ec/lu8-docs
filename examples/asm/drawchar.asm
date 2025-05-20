start:
    ; Clear screen (black)
    MOV [0xD801], 0
    CLS
    ; Verify if the glyph 'A' is loaded in memory
    LOG [0xD890]
    LOG [0xD891]
    LOG [0xD892]
    LOG [0xD893]
    LOG [0xD894]
    LOG [0xD895]
    LOG [0xD896]

draw_a:
    SETCOLOR 6
    ; Set X,Y position
    MOV [0xD806], 10
    MOV [0xD807], 20
    MOV [0x8000], 0x41    ; ASCII code for 'A'
    ; Draw character at index 0: 'A'
    DRAWCHAR 65
VSYNC
HALT
