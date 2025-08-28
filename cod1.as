;=========================================================
; Proyecto: Encendido de LED 
; PIC18F4550
; LED en RC0
; Encendido 5 segundos, apagado 2 segundos
;=========================================================

        LIST    P=18F4550
        INCLUDE <P18F4550.INC>

;------------------------------------------
; CONFIGURACIÓN DE FUSES
;------------------------------------------
        CONFIG  FOSC = INTOSCIO_EC   ; Oscilador interno
        CONFIG  WDT = OFF            ; Deshabilitar Watchdog
        CONFIG  LVP = OFF            ; Deshabilitar programación en bajo voltaje
        CONFIG  PBADEN = OFF         ; PORTB digital

;------------------------------------------
; VECTOR DE REINICIO
;------------------------------------------
        PSECT  resetVec, class=CODE, reloc=2
        ORG     0x00
        GOTO    MAIN

;------------------------------------------
; PROGRAMA PRINCIPAL
;------------------------------------------
MAIN:
        PSECT  main_code, class=CODE, reloc=2

        ; Configuración de OSCCON (8 MHz, oscilador interno)
        BSF     OSCCON, IRCF2
        BSF     OSCCON, IRCF1
        BSF     OSCCON, IRCF0    ; IRCF = 111 → 8 MHz
        BSF     OSCCON, SCS0
        BCF     OSCCON, SCS1     ; SCS = 01 → Oscilador Interno

        CLRF    LATC          ; limpiar LATC
        CLRF    TRISC         ; puerto C como salida

CICLO:
        BSF     LATC,0        ; enciende LED (RC0 = 1)
        CALL    DELAY5S       ; retardo de 5 segundos
        BCF     LATC,0        ; apaga LED (RC0 = 0)
        CALL    DELAY2S       ; retardo de 2 segundos
        GOTO    CICLO         ; repetir siempre

;------------------------------------------
; SUBRUTINAS DE RETARDO
; (aproximadas para Fosc = 8 MHz)
;------------------------------------------

; Retardo aproximado de 1 segundo
DELAY1S:
        MOVLW   0xFF          ; 255
        MOVWF   0x20
L1:     MOVLW   0xFF
        MOVWF   0x21
L2:     DECFSZ  0x21,F
        GOTO    L2
        DECFSZ  0x20,F
        GOTO    L1
        RETURN

; Retardo de 5 segundos (5 veces DELAY1S)
DELAY5S:
        MOVLW   0x05
        MOVWF   0x22
L3:     CALL    DELAY1S
        DECFSZ  0x22,F
        GOTO    L3
        RETURN

; Retardo de 2 segundos (2 veces DELAY1S)
DELAY2S:
        MOVLW   0x02
        MOVWF   0x23
L4:     CALL    DELAY1S
        DECFSZ  0x23,F
        GOTO    L4
        RETURN

        END

