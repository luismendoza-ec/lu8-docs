; ========================================
; Pong.asm — Example Program for Lu8 VM
; ========================================
;
; This is a minimal two-player Pong clone
; written in Lu8 Assembly Language. It runs
; entirely on the virtual CPU, draws using
; memory-mapped PPU registers, and plays
; sound via the APU system.
;
; ⚠️ This is not a full game — it's a working
; demonstration of how to structure logic,
; draw shapes, handle input, and trigger
; sound effects in the Lu8 environment.
;
; Built for Lu8 Fantasy Console
; Author: Luis Mendoza

; --- Constants ---
P1_X        EQU 10          ; Left paddle X position
P2_X        EQU 110         ; Right paddle X position
PADDLE_H    EQU 20          ; Paddle height
PADDLE_W    EQU 4           ; Paddle width
BALL_SIZE   EQU 3           ; Ball size
SCREEN_W    EQU 128         ; Screen width
SCREEN_H    EQU 128         ; Screen height
BALL_SPEED  EQU 1           ; Ball movement speed
PADDLE_SPEED EQU 2          ; Paddle movement speed
START_BTN   EQU 0x08        ; Start button (bit 3)

; --- Sound Constants ---
PULSE1_CTRL EQU 0xD820      ; Pulse 1 control register
PULSE1_VOL  EQU 0xD821      ; Pulse 1 volume register
PULSE1_FREQ_L EQU 0xD823    ; Pulse 1 frequency low byte
PULSE1_FREQ_H EQU 0xD824    ; Pulse 1 frequency high byte
PULSE1_DUTY EQU 0xD825      ; Pulse 1 duty cycle

TRIANGLE_CTRL EQU 0xD840    ; Triangle control register
TRIANGLE_FREQ_L EQU 0xD843  ; Triangle frequency low byte
TRIANGLE_FREQ_H EQU 0xD844  ; Triangle frequency high byte

; Sound duration (in frames)
SOUND_DURATION EQU 3        ; Duration of sound effects

start:
    ; Initialize game state
    MOV [0x8000], 50    ; p1_y - Left paddle Y position
    MOV [0x8001], 50    ; p2_y - Right paddle Y position
    MOV [0x8002], 60    ; ball_x - Ball X position
    MOV [0x8003], 60    ; ball_y - Ball Y position
    MOV [0x8004], 1     ; ball_dx - Ball X direction (1 = right, 0 = left)
    MOV [0x8005], 1     ; ball_dy - Ball Y direction (1 = down, 0 = up)
    MOV [0x800F], 0     ; game_started flag
    MOV [0x8010], 0     ; sound timer

    ; Initialize sound
    MOV [PULSE1_CTRL], 0     ; Disable Pulse 1
    MOV [PULSE1_VOL], 0x8F   ; Volume 8, no decay
    MOV [PULSE1_DUTY], 2     ; 50% duty cycle
    
    MOV [TRIANGLE_CTRL], 0   ; Disable Triangle

wait_start:
    ; Clear screen
    MOV [0xD801], 0
    CLS
    
    ; Set drawing color
    SETCOLOR 7
    
    ; Draw left paddle (P1)
    MOV [0xD80A], P1_X
    MOV [0xD80B], [0x8000]
    MOV [0xD80C], PADDLE_W
    MOV [0xD80D], PADDLE_H
    FILLRECT
    
    ; Draw right paddle (P2)
    MOV [0xD80A], P2_X
    MOV [0xD80B], [0x8001]
    MOV [0xD80C], PADDLE_W
    MOV [0xD80D], PADDLE_H
    FILLRECT
    
    ; Draw ball
    MOV [0xD80A], [0x8002]
    MOV [0xD80B], [0x8003]
    MOV [0xD80C], BALL_SIZE
    MOV [0xD80D], BALL_SIZE
    FILLRECT
    
    ; Check start button (either player can start)
    MOV [0x8006], [0xFF10]  ; p1 input
    MOV [0x8007], [0xFF11]  ; p2 input
    
    ; Check P1 start
    MOV [0x8008], [0x8006]
    AND [0x8008], START_BTN
    CMP [0x8008], START_BTN
    JZ .start_game
    
    ; Check P2 start
    MOV [0x8008], [0x8007]
    AND [0x8008], START_BTN
    CMP [0x8008], START_BTN
    JZ .start_game
    
    VSYNC
    JMP wait_start
    
.start_game:
    MOV [0x800F], 1     ; Set game_started flag

main:
    ; Clear screen
    MOV [0xD801], 0
    CLS

    ; Update sound timer and stop sounds if needed
    MOV [0x8011], [0x8010]   ; Get current timer
    CMP [0x8011], 0
    JZ .check_input          ; Skip if no sound playing
    DEC [0x8010]             ; Decrease timer
    MOV [0x8011], [0x8010]   ; Check if reached zero
    CMP [0x8011], 0
    JNZ .check_input         ; Skip if still playing
    MOV [PULSE1_CTRL], 0     ; Stop Pulse 1
    MOV [TRIANGLE_CTRL], 0   ; Stop Triangle

.check_input:
    ; Read player inputs
    ; We switch the inputs because the buttons in the keyboard are inverted
    MOV [0x8006], [0xFF11]  ; p1 input, but for this game using p2 input register
    MOV [0x8007], [0xFF10]  ; p2 input, but for this game using p1 input register

    ; Move P1 paddle - up
    MOV [0x8008], [0x8006]
    AND [0x8008], 0x10
    CMP [0x8008], 0x10
    JNZ .p1_down
    MOV [0x8009], [0x8000]
    SUB [0x8009], PADDLE_SPEED
    ; Check upper bound
    CMP [0x8009], 0
    JL .p1_down
    MOV [0x8000], [0x8009]
.p1_down:
    MOV [0x8008], [0x8006]
    AND [0x8008], 0x20
    CMP [0x8008], 0x20
    JNZ .p2_up
    MOV [0x8009], [0x8000]
    ADD [0x8009], PADDLE_SPEED
    ; Check lower bound
    MOV [0x800A], [0x8009]
    ADD [0x800A], PADDLE_H
    CMP [0x800A], SCREEN_H
    JGE .p2_up
    MOV [0x8000], [0x8009]

.p2_up:
    MOV [0x8008], [0x8007]
    AND [0x8008], 0x10
    CMP [0x8008], 0x10
    JNZ .p2_down
    MOV [0x8009], [0x8001]
    SUB [0x8009], PADDLE_SPEED
    ; Check upper bound
    CMP [0x8009], 0
    JL .p2_down
    MOV [0x8001], [0x8009]
.p2_down:
    MOV [0x8008], [0x8007]
    AND [0x8008], 0x20
    CMP [0x8008], 0x20
    JNZ .update_ball
    MOV [0x8009], [0x8001]
    ADD [0x8009], PADDLE_SPEED
    ; Check lower bound
    MOV [0x800A], [0x8009]
    ADD [0x800A], PADDLE_H
    CMP [0x800A], SCREEN_H
    JGE .update_ball
    MOV [0x8001], [0x8009]

; --- Update ball position ---
.update_ball:
    ; Check if game is started
    CMP [0x800F], 0
    JZ .draw
    
    ; Update X position based on direction
    MOV [0x8008], [0x8004]
    CMP [0x8008], 0
    JZ .ball_left
    ; Move right
    MOV [0x8009], [0x8002]
    ADD [0x8009], BALL_SPEED
    MOV [0x8002], [0x8009]
    JMP .ball_y
.ball_left:
    ; Move left
    MOV [0x8009], [0x8002]
    SUB [0x8009], BALL_SPEED
    MOV [0x8002], [0x8009]

.ball_y:
    ; Update Y position based on direction
    MOV [0x8008], [0x8005]
    CMP [0x8008], 0
    JZ .ball_up
    ; Move down
    MOV [0x8009], [0x8003]
    ADD [0x8009], BALL_SPEED
    MOV [0x8003], [0x8009]
    JMP .check_bounds
.ball_up:
    ; Move up
    MOV [0x8009], [0x8003]
    SUB [0x8009], BALL_SPEED
    MOV [0x8003], [0x8009]

; --- Check boundaries ---
.check_bounds:
    ; Check vertical bounds
    MOV [0x8009], [0x8003]
    CMP [0x8009], 0
    JG .check_bottom
    MOV [0x8003], 0
    MOV [0x8005], 1     ; Bounce down
    CALL .play_wall_sound
.check_bottom:
    MOV [0x8009], [0x8003]
    ADD [0x8009], BALL_SIZE
    CMP [0x8009], SCREEN_H
    JL .check_paddles
    MOV [0x8003], SCREEN_H
    SUB [0x8003], BALL_SIZE
    MOV [0x8005], 0     ; Bounce up
    CALL .play_wall_sound

; --- Check paddle collisions ---
.check_paddles:
    ; Check left paddle (P1)
    MOV [0x8008], [0x8002]    ; Ball X
    CMP [0x8008], P1_X
    JL .check_right           ; Ball is left of P1 paddle
    MOV [0x8009], P1_X
    ADD [0x8009], PADDLE_W
    CMP [0x8008], [0x8009]
    JG .check_right          ; Ball is right of P1 paddle

    ; Check if ball Y is within P1 paddle height
    MOV [0x800A], [0x8003]   ; Ball Y
    MOV [0x800B], [0x8000]   ; P1 Y
    CMP [0x800A], [0x800B]
    JL .check_right          ; Ball is above paddle
    MOV [0x800C], [0x800B]
    ADD [0x800C], PADDLE_H
    CMP [0x800A], [0x800C]
    JG .check_right          ; Ball is below paddle

    MOV [0x8004], 1          ; Bounce right
    CALL .play_paddle_sound
    JMP .draw

.check_right:
    ; Check right paddle (P2)
    MOV [0x8008], [0x8002]    ; Ball X
    ADD [0x8008], BALL_SIZE
    CMP [0x8008], P2_X
    JL .check_game_over       ; Ball is left of P2 paddle
    MOV [0x8009], P2_X
    ADD [0x8009], PADDLE_W
    CMP [0x8008], [0x8009]
    JG .check_game_over      ; Ball is right of P2 paddle

    ; Check if ball Y is within P2 paddle height
    MOV [0x800A], [0x8003]   ; Ball Y
    MOV [0x800B], [0x8001]   ; P2 Y
    CMP [0x800A], [0x800B]
    JL .check_game_over      ; Ball is above paddle
    MOV [0x800C], [0x800B]
    ADD [0x800C], PADDLE_H
    CMP [0x800A], [0x800C]
    JG .check_game_over      ; Ball is below paddle

    MOV [0x8004], 0          ; Bounce left
    CALL .play_paddle_sound
    JMP .draw

.check_game_over:
    ; Check if ball is out of bounds horizontally
    MOV [0x8009], [0x8002]
    CMP [0x8009], 0
    JL .game_over
    ADD [0x8009], BALL_SIZE
    CMP [0x8009], SCREEN_W
    JG .game_over
    JMP .draw

.game_over:
    JMP start

; --- Draw everything ---
.draw:
    SETCOLOR 7

    ; Draw P1 paddle
    MOV [0xD80A], P1_X
    MOV [0xD80B], [0x8000]
    MOV [0xD80C], PADDLE_W
    MOV [0xD80D], PADDLE_H
    FILLRECT

    ; Draw P2 paddle
    MOV [0xD80A], P2_X
    MOV [0xD80B], [0x8001]
    MOV [0xD80C], PADDLE_W
    MOV [0xD80D], PADDLE_H
    FILLRECT

    ; Draw ball
    MOV [0xD80A], [0x8002]
    MOV [0xD80B], [0x8003]
    MOV [0xD80C], BALL_SIZE
    MOV [0xD80D], BALL_SIZE
    FILLRECT

    VSYNC
    JMP main

; --- Play paddle hit sound ---
.play_paddle_sound:
    MOV [PULSE1_CTRL], 0      ; Disable first
    MOV [PULSE1_FREQ_L], 150  ; High frequency beep
    MOV [PULSE1_FREQ_H], 2
    MOV [PULSE1_CTRL], 1      ; Enable, no loop
    MOV [0x8010], SOUND_DURATION  ; Set sound timer
    RET

; --- Play wall hit sound ---
.play_wall_sound:
    MOV [TRIANGLE_CTRL], 0     ; Disable first
    MOV [TRIANGLE_FREQ_L], 200 ; Lower frequency beep
    MOV [TRIANGLE_FREQ_H], 1
    MOV [TRIANGLE_CTRL], 1     ; Enable, no loop
    MOV [0x8010], SOUND_DURATION  ; Set sound timer
    RET
