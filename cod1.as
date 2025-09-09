; Proyecto: Secuencia de 4 LEDs
; PIC18F4550
; LEDs en RC0, RC1, RC2, RC3
; Cada LED se enciende 1s, luego todos apagados 2s

        LIST    P=18F4550
        INCLUDE <P18F4550.INC>
        CONFIG  FOSC=INTOSCIO_EC, WDT=OFF, LVP=OFF, PBADEN=OFF

        PSECT  resetVec, class=CODE, reloc=2
        ORG     0x00
        GOTO    MAIN

; -----------------------------------------
; PROGRAMA PRINCIPAL
; -----------------------------------------
MAIN:
PSECT  main_code, class=CODE, reloc=2

    ; Configuración de OSCCON (8 MHz, oscilador interno)
    MOVLW   B'01110000'   ; IRCF=111 (8 MHz), SCS=00 (usar FOSC)
    MOVWF   OSCCON

    CLRF    LATC          ; limpiar puerto C
    CLRF    TRISC         ; puerto C como salida

CICLO:
    ; Encender LED RC0
    BSF     LATC,0
    CALL    DELAY1S
    BCF     LATC,0

    ; Encender LED RC1
    BSF     LATC,1
    CALL    DELAY1S
    BCF     LATC,1

    ; Encender LED RC2
    BSF     LATC,2
    CALL    DELAY1S
    BCF     LATC,2

    ; Encender LED RC3
    BSF     LATC,3
    CALL    DELAY1S
    BCF     LATC,3

    ; Apagar todos y es
