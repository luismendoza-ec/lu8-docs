; === Animated test: circle that bounces vertically ===

start:
    MOV [0x8000], 60     ; pos_y
    MOV [0x8001], 1      ; dir_y (1 = abajo, 0 = arriba)

.loop:
    ; Black background
    MOV [0xD801], 0
    CLS

    ; White rectangle
    SETCOLOR 15
    MOV [0xD806], 10
    MOV [0xD807], 10
    MOV [0xD808], 50
    MOV [0xD809], 30
    RECT

    ; Red filled rectangle
    SETCOLOR 8
    MOV [0xD80A], 70
    MOV [0xD80B], 10
    MOV [0xD80C], 40
    MOV [0xD80D], 20
    FILLRECT

    ; Blue line
    SETCOLOR 12 ; OR  MOV [0xD800], 12
    MOV [0xD802], 0
    MOV [0xD803], 127
    MOV [0xD804], 127
    MOV [0xD805], 0
    LINE

    ; === Animation: yellow circle ===
    SETCOLOR 14
    MOV [0xD810], 10       ; radius
    MOV [0xD80E], 40       ; x fixed
    MOV [0xD80F], [0x8000] ; y animated
    CIRCLE

    ; Vertical movement
    MOV [0x8002], [0x8001] ; dir_y
    CMP [0x8002], 0
    JZ .move_up

.move_down:
    ADD [0x8000], 1
    MOV [0x8003], [0x8000]
    ADD [0x8003], 10       ; y + r
    CMP [0x8003], 128
    JL .done_move
    MOV [0x8001], 0        ; change direction to up
    JMP .done_move

.move_up:
    SUB [0x8000], 1
    CMP [0x8000], 0
    JG .done_move
    MOV [0x8001], 1        ; change direction to down

.done_move:
    VSYNC
    JMP .loop
