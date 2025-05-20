; Test of data section
; This program tests the handling of data with the DB directive

; Code
start:
    MOV [0x8000], 8          ; num bytes to copy
    MEMCPY [0x8010], data, 8  ; dest, src, len, we can use the label with [] or without
    
    ; Show the copied bytes
    LOG [0x8010]
    VSYNC                    ; Wait for a frame to ensure the log is shown
    LOG [0x8011]
    VSYNC
    LOG [0x8012]
    VSYNC
    LOG [0x8013]
    VSYNC
    LOG [0x8014]
    VSYNC
    LOG [0x8015]
    VSYNC
    LOG [0x8016]
    VSYNC
    LOG [0x8017]
    VSYNC
    HALT

; Data section
data:
    DB 0xDE, 0xAD, 0xBE, 0xEF, 0x66, 0x77, 0x99, 0xAA
data2:
    DB 0xBE, 0xBE


