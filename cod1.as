; Proyecto: Encendido de LED 
; PIC18F4550
; LED en RC0
; Encendido 5 segundos, apagado 2 segundos

        LIST    P=18F4550
        INCLUDE <P18F4550.INC>
        CONFIG  OSC=HS, WDT=OFF, LVP=OFF

        ORG     0x00
        GOTO    MAIN

; -----------------------------------------
; PROGRAMA PRINCIPAL
; -----------------------------------------
MAIN:
        CLRF    LATC          ; limpiar LATC
        CLRF    TRISC         ; puerto C como salida

CICLO:
        BSF     LATC,0        ; enciende LED (RC0 = 1)
        CALL    DELAY5S       ; retardo de 5 segundos
        BCF     LATC,0        ; apaga LED (RC0 = 0)
        CALL    DELAY2S       ; retardo de 2 segundos
        GOTO    CICLO         ; repetir siempre

; -----------------------------------------
; SUBRUTINAS DE RETARDO
; Nota: dependen de la frecuencia de reloj (ej: 4 MHz)
; -----------------------------------------

; Retardo aproximado de 1 segundo
DELAY1S:
        MOVLW   B'11111111'   ; WREG = 255 (contador alto)
        MOVWF   0x20
L1:     MOVLW   B'11111111'   ; WREG = 255 (contador bajo)
        MOVWF   0x21
L2:     DECFSZ  0x21,F        ; decrementa, salta si llega a 0
        GOTO    L2
        DECFSZ  0x20,F
        GOTO    L1
        RETURN

; Retardo de 5 segundos (5 veces DELAY1S)
DELAY5S:
        MOVLW   B'00000101'   ; WREG = 5
        MOVWF   0x22
L3:     CALL    DELAY1S
        DECFSZ  0x22,F
        GOTO    L3
        RETURN

; Retardo de 2 segundos (2 veces DELAY1S)
DELAY2S:
        MOVLW   B'00000010'   ; WREG = 2
        MOVWF   0x23
L4:     CALL    DELAY1S
        DECFSZ  0x23,F
        GOTO    L4
        RETURN

        END
