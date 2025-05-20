start:
    ; Fill the region at 0x9000 with the value 0xAA (170) for 8 bytes
    MEMSET [0x8000], 0xAA, 8

    LOG [0x8000]
    LOG [0x8001]
    LOG [0x8002]
    LOG [0x8003]
    LOG [0x8004]
    LOG [0x8005]
    LOG [0x8006]

    ; End execution
    HALT
