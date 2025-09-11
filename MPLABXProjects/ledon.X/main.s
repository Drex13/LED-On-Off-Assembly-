    LIST    P=18F4550
    #include <xc.inc>

    CONFIG  FOSC = INTOSCIO_EC
    CONFIG  FCMEN = OFF
    CONFIG  IESO = OFF
    CONFIG  WDT = OFF
    CONFIG  PBADEN = OFF
    CONFIG  LVP = OFF

    PSECT   udata_acs
CONTADOR:   DS 1
TIEMPO1:    DS 1
TIEMPO2:    DS 1
TIEMPO3:    DS 1
PAUSA:      DS 1
TEMP:       DS 1
BOTON_ANT:  DS 1

    PSECT   resetVec,class=CODE,reloc=2
    GOTO    INICIO

    PSECT   code
INICIO:
    MOVLW   0x0F
    MOVWF   ADCON1, A
    MOVLW   0x07
    MOVWF   CMCON, A
    MOVLW   0x72
    MOVWF   OSCCON, A

    MOVLW   0xF0           ; RB7..RB4=1 (entradas), RB3..RB0=0 (salidas)
    MOVWF   TRISB, A
    BCF     INTCON2,7      ; habilita pull-ups en PORTB
    CLRF    LATB, A

    CLRF    PAUSA, A
    MOVLW   1              ; botón suelto (RB4=1 por pull-up)
    MOVWF   BOTON_ANT, A

MAIN_LOOP:
    BSF     LATB,0, A
    CALL    RETARDO_1S
    CALL    ESPERA_PAUSA

    BCF     LATB,0, A
    CALL    RETARDO_1S
    CALL    ESPERA_PAUSA

    BRA     MAIN_LOOP

RETARDO_1S:
    MOVLW   0x20
    MOVWF   TIEMPO3, A
R3:
    MOVLW   0xFF
    MOVWF   TIEMPO2, A
R2:
    MOVLW   0xFF
    MOVWF   TIEMPO1, A
R1:
    DECFSZ  TIEMPO1, F, A
    BRA     R1
    DECFSZ  TIEMPO2, F, A
    BRA     R2
    DECFSZ  TIEMPO3, F, A
    BRA     R3
    RETURN

ESPERA_PAUSA:
    CALL    CHECK_BOTON_TOGGLE
    MOVF    PAUSA, W, A
    BZ      EP_EXIT
EP_LOOP:
    CALL    CHECK_BOTON_TOGGLE
    NOP
    NOP
    MOVF    PAUSA, W, A
    BNZ     EP_LOOP
EP_EXIT:
    RETURN

CHECK_BOTON_TOGGLE:
    BTFSC   PORTB,4, A
    GOTO    BTN_SUELTO1
    CLRF    TEMP, A
    GOTO    BTN_SAMPLE1
BTN_SUELTO1:
    MOVLW   1
    MOVWF   TEMP, A
BTN_SAMPLE1:
    MOVF    TEMP, W, A
    XORWF   BOTON_ANT, W, A
    BZ      CBT_END

    CALL    DEBOUNCE_20MS

    BTFSC   PORTB,4, A
    GOTO    BTN_SUELTO2
    CLRF    TEMP, A
    GOTO    BTN_SAMPLE2
BTN_SUELTO2:
    MOVLW   1
    MOVWF   TEMP, A
BTN_SAMPLE2:
    MOVF    TEMP, W, A
    MOVWF   BOTON_ANT, A
    MOVF    TEMP, W, A
    BNZ     CBT_END
    MOVLW   1
    XORWF   PAUSA, F, A
CBT_END:
    RETURN

DEBOUNCE_20MS:
    MOVLW   100
    MOVWF   CONTADOR, A
DB_L:
    NOP
    NOP
    NOP
    NOP
    DECFSZ  CONTADOR, F, A
    BRA     DB_L
    RETURN

    END
