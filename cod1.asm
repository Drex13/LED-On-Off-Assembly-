; Proyecto: Secuencia de 4 LEDs con 3 modos y botón
; PIC18F4550
; LEDs en RC0, RC1, RC2, RC3
; Botón en RB0 (cambia entre Secuencias)

        LIST    P=18F4550
        #include <xc.inc>
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

    BSF     TRISB,0       ; RB0 como entrada para botón

    CLRF    Modo          ; Modo = 0 (Secuencia1 por defecto)
    CLRF    BotonAnt      ; Estado anterior del botón

; ---------- Bucle Principal ----------
CICLO:
    ; Leer botón en RB0
    BTFSC   PORTB,0       ; si RB0 = 1
    GOTO    BotonPres
    CLRF    BotonNow
    GOTO    BotonCheck
BotonPres:
    MOVLW   1
    MOVWF   BotonNow

BotonCheck:
    ; Detectar cambio de estado
    MOVF    BotonNow,W
    SUBWF   BotonAnt,W
    BZ      NoCambio       ; si no cambió, continuar

    ; Hubo cambio, actualizar BotonAnt
    MOVF    BotonNow,W
    MOVWF   BotonAnt

    ; Si es flanco de subida (BotonNow = 1), cambiar modo
    MOVF    BotonNow,W
    BZ      NoCambio        ; si es 0, no hacer nada
    INCF    Modo,F
    MOVLW   3
    CPFSGT  Modo
    CLRF    Modo            ; reinicia a 0 si Modo > 2

NoCambio:
    ; Ejecutar secuencia según Modo
    MOVF    Modo,W
    BZ      RunSeq1
    MOVLW   1
    SUBWF   Modo,W
    BZ      RunSeq2
    GOTO    RunSeq3

RunSeq1:
    CALL    SECUENCIA1
    GOTO    CICLO

RunSeq2:
    CALL    SECUENCIA2
    GOTO    CICLO

RunSeq3:
    CALL    SECUENCIA3
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

SECUENCIA2:    ; Ida y vuelta
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

SECUENCIA3:    ; Todos los LEDs parpadean
    MOVLW   B'00001111'   ; Encender RC0..RC3
    MOVWF   LATC
    CALL    DELAY1S
    CLRF    LATC          ; Apagar todos
    CALL    DELAY1S
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



        END
