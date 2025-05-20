; Factorial Calculator Demo
; Memory map:
; 0x8000: Input number
; 0x8001: Result low byte
; 0x8002: Result high byte
; 0x8003-0x8004: Temporary storage

    ; Initialize input number (calculate factorial of 5)
    MOV [0x8000], 5
    
    ; Log initial number
    LOG [0x8000]        ; Show input number
    
    ; Call factorial function
    CALL factorial
    
    ; Log the result
    LOG [0x8001]        ; Show factorial result
    
    ; Display result using pattern
    MOV [0x8003], 0  ; y coordinate
.display:
    MOV [0x8004], 0  ; x coordinate
.display_line:
    ; Draw pixels based on result
    MOV [0xD806], [0x8004]  ; x
    MOV [0xD807], [0x8003]  ; y
    MOV [0xD800], [0x8001]  ; color from result
    PSET
    
    INC [0x8004]
    CMP [0x8004], 128
    JL .display_line
    
    INC [0x8003]
    CMP [0x8003], 128
    JL .display
    
    VSYNC
    JMP .display  ; Loop forever

; Factorial function
; Input: [0x8000]
; Output: [0x8001-0x8002]
factorial:
    ; Save registers
    PUSH [0x8001]
    PUSH [0x8002]
    
    ; Initialize result to 1
    MOV [0x8001], 1
    MOV [0x8002], 0
    
    ; Log initial state
    LOG [0x8001]        ; Show initial result (1)
    
    ; Check if input is 0 or 1
    CMP [0x8000], 1
    JL .factorial_done  ; if n <= 1, return 1
    
.factorial_loop:
    ; Multiply current result by counter
    MOV [0x8001], [0x8001]
    MUL [0x8001], [0x8000]
    
    ; Log current multiplication step
    LOG [0x8000]        ; Show current multiplier
    LOG [0x8001]        ; Show current result
    
    ; Decrease counter
    DEC [0x8000]
    
    ; Continue if counter > 1
    CMP [0x8000], 1
    JG .factorial_loop
    
.factorial_done:
    ; Log final state before restoring registers
    LOG [0x8001]        ; Show final result
    
    ; Restore registers in reverse order
    POP [0x8002]
    POP [0x8001]
    RET
