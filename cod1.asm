; Proyecto: Secuencia de 4 LEDs con 2 modos
; PIC18F4550
; LEDs en RC0, RC1, RC2, RC3
; Secuencia 1: uno por uno
; Secuencia 2: ida y vuelta (chenille)

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
    ; -------- SECUENCIA 1 --------
    CALL    SECUENCIA1
    CALL    DELAY2S        ; pausa entre secuencias

    ; -------- SECUENCIA 2 --------
    CALL    SECUENCIA2
    CALL    DELAY2S        ; pausa entre secuencias

    GOTO    CICLO

; -----------------------------------------
; SUBRUTINAS DE SECUENCIA
; -----------------------------------------

SECUENCIA1:    ; Encender LEDs uno por uno
    BSF     LATC,0
    CALL    DELAY1S
    BCF     LATC,0

    BSF     LATC,1
    CALL    DELAY1S
    BCF     LATC,1

    BSF     LATC,2
    CALL    DELAY1S
    BCF     LATC,2

    BSF     LATC,3
    CALL    DELAY1S
    BCF     LATC,3

    RETURN

SECUENCIA2:    ; 
    ; Ida
    BSF     LATC,0
    CALL    DELAY1S
    BCF     LATC,0

    BSF     LATC,1
    CALL    DELAY1S
    BCF     LATC,1

    BSF     LATC,2
    CALL    DELAY1S
    BCF     LATC,2

    BSF     LATC,3
    CALL    DELAY1S
    BCF     LATC,3

    ; Vuelta
    BSF     LATC,2
    CALL    DELAY1S
    BCF     LATC,2

    BSF     LATC,1
    CALL    DELAY1S
    BCF     LATC,1

    RETURN

; -----------------------------------------
; SUBRUTINAS DE RETARDO
; -----------------------------------------

; Retardo aproximado de 1 segundo
DELAY1S:
        MOVLW   D'255'
        MOVWF   0x20
L1:     MOVLW   D'255'
        MOVWF   0x21
L2:     DECFSZ  0x21,F
        GOTO    L2
        DECFSZ  0x20,F
        GOTO    L1
        RETURN

; Retardo de 2 segundos (2 veces DELAY1S)
DELAY2S:
        MOVLW   D'2'
        MOVWF   0x22
L3:     CALL    DELAY1S
        DECFSZ  0x22,F
        GOTO    L3
        RETURN

        END
