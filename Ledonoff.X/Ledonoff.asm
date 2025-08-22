;=========================================================
; Código en Assembler para PIC18F4550
; LED en RB0: Encendido 5000 ms, Apagado 2000 ms
; Usa retardos sin interrupciones ni Timer0
; Frecuencia: 8 MHz (Oscilador Interno)
; Ensamblador: MPLAB XC8
;=========================================================

    #include <xc.inc>   ; Definiciones para PIC18F4550

    ; Configuración de Fuses
    CONFIG  FOSC = INTOSCIO_EC   ; Oscilador interno a 8 MHz
    CONFIG  WDT = OFF            ; Deshabilitar Watchdog
    CONFIG  LVP = OFF            ; Deshabilitar programación en bajo voltaje
    CONFIG  PBADEN = OFF         ; PORTB digital

    ;===============================================
    ; Vector de Reset
    ;===============================================
    PSECT  resetVec, class=CODE, reloc=2
    ORG     0x00
    GOTO    Inicio

    ;===============================================
    ; Código Principal
    ;===============================================
    PSECT  main_code, class=CODE, reloc=2

Inicio:
    CLRF    TRISB       ; PORTB como salida
    CLRF    LATB        ; LEDs apagados

Loop:
    BSF     LATB,0      ; Enciende LED en RB0
    CALL    Retardo_5s  ; Espera 5000 ms

    BCF     LATB,0      ; Apaga LED en RB0
    CALL    Retardo_2s  ; Espera 2000 ms

    GOTO    Loop        ; Repetir ciclo

    ;===============================================
    ; Subrutinas de Retardos
    ;===============================================
Retardo_1s:
    MOVLW   25
    MOVWF   ContadorExterno

LoopExterno:
    MOVLW   250
    MOVWF   ContadorInterno

LoopInterno:
    NOP
    NOP
    NOP

    DECFSZ  ContadorInterno, F
    GOTO    LoopInterno

    DECFSZ  ContadorExterno, F
    GOTO    LoopExterno

    RETURN

; ----- Retardos Mayores usando Retardo_1s -----
Retardo_5s:
    MOVLW   5
    MOVWF   ContadorSec
R5s_loop:
    CALL    Retardo_1s
    DECFSZ  ContadorSec, F
    GOTO    R5s_loop
    RETURN

Retardo_2s:
    MOVLW   2
    MOVWF   ContadorSec
R2s_loop:
    CALL    Retardo_1s
    DECFSZ  ContadorSec, F
    GOTO    R2s_loop
    RETURN

    ;===============================================
    ; Variables
    ;===============================================
    PSECT udata
ContadorExterno:   DS 1
ContadorInterno:   DS 1
ContadorSec:       DS 1

    END



