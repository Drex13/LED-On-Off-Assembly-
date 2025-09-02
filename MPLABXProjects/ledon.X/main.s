;=========================================================
; PIC18F4550  | XC8 pic-as (v3.x)
; LED en RB0: ON 5000 ms, OFF 2000 ms
; Oscilador interno 8 MHz
;=========================================================

            #include <xc.inc>

;----------------------------
; CONFIG (fuses)
;----------------------------
    CONFIG  FOSC   = INTOSCIO_EC   ; Oscilador interno, RA6/RA7 como I/O
    CONFIG  WDT    = OFF
    CONFIG  PBADEN = OFF
    CONFIG  LVP    = OFF

;----------------------------
; Vector de reset
;----------------------------
    PSECT   resetVec,class=CODE,reloc=2
    ORG     0x0000
    GOTO    Inicio

;----------------------------
; Código principal
;----------------------------
    PSECT   main_code,class=CODE,reloc=2

Inicio:
    ; Forzar 8 MHz en OSCCON
    MOVLW   0x72
    MOVWF   OSCCON

    ; PORTB como salida
    CLRF    TRISB
    BCF     LATB,0          ; LED OFF inicial

MainLoop:
    ; ----- LED ON 5000 ms -----
    BSF     LATB,0
    CALL    Retardo_5s

    ; ----- LED OFF 2000 ms -----
    BCF     LATB,0
    CALL    Retardo_2s

    GOTO    MainLoop

;------------------------------------------
; Retardos (hardcodeados con bucles)
; Nota: aquí muestro ejemplos con llamadas repetidas
;       a Delay_1s, así no necesitas variables.
;------------------------------------------
Retardo_5s:
    CALL Delay_1s
    CALL Delay_1s
    CALL Delay_1s
    CALL Delay_1s
    CALL Delay_1s
    RETURN

Retardo_2s:
    CALL Delay_1s
    CALL Delay_1s
    RETURN

;------------------------------------------
; Delay_1s
;   1 segundo aprox. (llama 1000 veces a Delay_1ms)
;------------------------------------------
Delay_1s:
    MOVLW   D'250'       ; 250*4 = 1000 ms
    MOVWF   R1
D1s_loop:
    CALL Delay_4ms       ; cada llamada ?4 ms
    DECFSZ  R1,F
    GOTO D1s_loop
    RETURN

;------------------------------------------
; Delay_4ms (?4ms @ 8 MHz)
;------------------------------------------
Delay_4ms:
    ; Bucle calibrado (ejemplo)
    MOVLW   D'250'
    MOVWF   R2
D4ms_loop:
    NOP
    NOP
    NOP
    DECFSZ  R2,F
    GOTO D4ms_loop
    RETURN

    END
