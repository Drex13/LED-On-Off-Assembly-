;=========================================================
; PIC18F4550 | XC8 pic-as (.s)
; LED RB0 y RB1: ON 5 s, OFF 2 s  | INTOSC = 8 MHz
;=========================================================

; ---- FUSES (deben ir antes del include) ----
    CONFIG  FOSC   = INTOSCIO_EC
    CONFIG  FCMEN  = OFF
    CONFIG  IESO   = OFF
    CONFIG  WDT    = OFF
    CONFIG  PBADEN = OFF
    CONFIG  LVP    = OFF

#include <xc.inc>

;=========================================================
; Vector de RESET
;=========================================================
    PSECT   resetVec, class=CODE, abs, delta=2
    ORG     0x0000
    GOTO    Inicio

;=========================================================
; Variables
;=========================================================
    PSECT   udata_acs
ContadorExterno:   DS 1
ContadorInterno:   DS 1

;=========================================================
; Programa principal
;=========================================================
    PSECT   main_code, class=CODE, reloc=2

Inicio:
    ; ----- Configuración reloj: 8 MHz -----
    MOVLW   0x72
    MOVWF   OSCCON
    CLRF    OSCTUNE

    ; ----- Digital I/O -----
    MOVLW   0x0F
    MOVWF   ADCON1
    MOVLW   0x07
    MOVWF   CMCON

    ; ----- PORTB salida, LEDs OFF -----
    CLRF    TRISB
    BCF     LATB,0
    BCF     LATB,1

Loop:
    ; ---------- LEDS ON 5 s ----------
    BSF     LATB,0      ; LED1 (RB0) ON
    BSF     LATB,1      ; LED2 (RB1) ON
    CALL    Retardo_1s
    CALL    Retardo_1s
    CALL    Retardo_1s
    CALL    Retardo_1s
    CALL    Retardo_1s

    ; ---------- LEDS OFF 2 s ----------
    BCF     LATB,0      ; LED1 (RB0) OFF
    BCF     LATB,1      ; LED2 (RB1) OFF
    CALL    Retardo_1s
    CALL    Retardo_1s

    GOTO    Loop

;=========================================================
; Retardos
;=========================================================
Retardo_1s:
    MOVLW   250
    MOVWF   ContadorExterno
R1s_B0:
    CALL    Delay_1ms
    DECFSZ  ContadorExterno, F
    GOTO    R1s_B0

    MOVLW   250
    MOVWF   ContadorExterno
R1s_B1:
    CALL    Delay_1ms
    DECFSZ  ContadorExterno, F
    GOTO    R1s_B1

    MOVLW   250
    MOVWF   ContadorExterno
R1s_B2:
    CALL    Delay_1ms
    DECFSZ  ContadorExterno, F
    GOTO    R1s_B2

    MOVLW   250
    MOVWF   ContadorExterno
R1s_B3:
    CALL    Delay_1ms
    DECFSZ  ContadorExterno, F
    GOTO    R1s_B3

    RETURN

Delay_1ms:
    MOVLW   200
    MOVWF   ContadorInterno
D1ms_L1:
    NOP
    NOP
    DECFSZ  ContadorInterno, F
    GOTO    D1ms_L1

    MOVLW   200
    MOVWF   ContadorInterno
D1ms_L2:
    NOP
    NOP
    DECFSZ  ContadorInterno, F
    GOTO    D1ms_L2

    NOP
    NOP
    RETURN

    END
