;=========================================================
; PIC18F4550 | XC8 pic-as (.s)
; LED RB0: ON 5 s, OFF 2 s  | INTOSC = 8 MHz
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
; Vector de RESET (usar sección ABS para evitar errores)
;=========================================================
    PSECT   resetVec, class=CODE, abs, delta=2
    ORG     0x0000
    GOTO    Inicio

;=========================================================
; Variables (ACCESS para evitar selección de banco)
;=========================================================
    PSECT   udata_acs
ContadorExterno:   DS 1    ; usado por Retardo_1s (bloques de 250 ms)
ContadorInterno:   DS 1    ; usado por Delay_1ms (bucles internos)

;=========================================================
; Programa
;=========================================================
    PSECT   main_code, class=CODE, reloc=2

Inicio:
    ; ----- Reloj: INTOSC = 8 MHz, usar INTOSC como fuente -----
    MOVLW   0x72            ; IRCF=111 (8MHz), SCS=10 (INTOSC)
    MOVWF   OSCCON
    CLRF    OSCTUNE         ; sin ajuste fino (opcional)

    ; Opcional: forzar todo digital / comparadores OFF
    MOVLW   0x0F
    MOVWF   ADCON1
    MOVLW   0x07
    MOVWF   CMCON

    ; E/S: PORTB salida, LED RB0 apagado
    CLRF    TRISB
    BCF     LATB,0

Loop:
    ; ---------- LED ON 5 s ----------
    BSF     LATB,0
    CALL    Retardo_1s
    CALL    Retardo_1s
    CALL    Retardo_1s
    CALL    Retardo_1s
    CALL    Retardo_1s

    ; ---------- LED OFF 2 s ----------
    BCF     LATB,0
    CALL    Retardo_1s
    CALL    Retardo_1s

    GOTO    Loop

;=========================================================
; Retardos
;   - Delay_1ms: ~1.000 ms @ Fosc=8 MHz (Fcy=2 MHz ? 0.5 us/instr)
;   - Retardo_1s: 4 bloques de 250 × Delay_1ms = 1000 ms
;     (usa solo ContadorExterno; Delay_1ms usa ContadorInterno)
;=========================================================

; --- 1 segundo exacto por software (4 × 250 ms) ---
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

; --- 1 ms @ 8 MHz (?2000 ciclos) ---
; Dos bucles de 200 iteraciones (~999 + ~999 ciclos) + 2 NOP = ~2000
Delay_1ms:
    MOVLW   200
    MOVWF   ContadorInterno
D1ms_L1:
    NOP
    NOP
    DECFSZ  ContadorInterno, F
    GOTO    D1ms_L1          ; ~999 ciclos

    MOVLW   200
    MOVWF   ContadorInterno
D1ms_L2:
    NOP
    NOP
    DECFSZ  ContadorInterno, F
    GOTO    D1ms_L2          ; ~999 ciclos

    NOP                       ; +2 ciclos ? ~2000 ciclos
    NOP
    RETURN

    END
