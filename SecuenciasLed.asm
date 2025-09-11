    LIST    P=18F4550
    #include <xc.inc>

    CONFIG  FOSC = INTOSCIO_EC
    CONFIG  FCMEN = OFF
    CONFIG  IESO = OFF
    CONFIG  WDT = OFF
    CONFIG  PBADEN = OFF
    CONFIG  LVP = OFF

    PSECT udata_acs
    ContadorExterno: DS 1
    ContadorInterno: DS 1
    SecuenciaActual: DS 1
    BotonAnt: DS 1
    Temp: DS 1

    PSECT main_code, class=CODE, reloc=2

Inicio:
    MOVLW 0x72
    MOVWF OSCCON, A
    CLRF OSCTUNE, A
    MOVLW 0x0F
    MOVWF ADCON1, A
    MOVLW 0x07
    MOVWF CMCON, A
    
    CLRF TRISD, A        ; PORTD como salida (LEDs en RD0-RD3)
    CLRF LATD, A         ; LEDs apagados
    
    BSF TRISB, 0, A      ; RB0 como entrada para botón
    CLRF BotonAnt, A     ; Estado anterior del botón
    CLRF SecuenciaActual, A ; Secuencia inicial 0

BuclePrincipal:
    ; Verificar secuencia actual
    MOVF SecuenciaActual, W, A
    BZ Secuencia1        ; Si es 0, ir a Secuencia1
    
    MOVLW 1
    SUBWF SecuenciaActual, W, A
    BZ Secuencia2        ; Si es 1, ir a Secuencia2
    
    MOVLW 2
    SUBWF SecuenciaActual, W, A
    BZ Secuencia3        ; Si es 2, ir a Secuencia3
    
    GOTO Secuencia1      ; Por seguridad, ir a Secuencia1

Secuencia1:
    MOVLW 0x01
    MOVWF LATD, A
    CALL Retardo_1s
    
    MOVLW 0x02
    MOVWF LATD, A
    CALL Retardo_1s
    
    MOVLW 0x04
    MOVWF LATD, A
    CALL Retardo_1s
    
    MOVLW 0x08
    MOVWF LATD, A
    CALL Retardo_1s
    
    CLRF LATD, A
    CALL Retardo_1s
    CALL Retardo_1s
    GOTO BuclePrincipal

Secuencia2:
    MOVLW 0x03
    MOVWF ContadorExterno, A
Parpadeo:
    MOVLW 0x0F
    MOVWF LATD, A
    CALL Retardo_1s
    CLRF LATD, A
    CALL Retardo_1s
    DECFSZ ContadorExterno, F, A
    GOTO Parpadeo
    GOTO BuclePrincipal

Secuencia3:
    CLRF ContadorExterno, A
    MOVLW 16
Contar:
    MOVF ContadorExterno, W, A
    MOVWF LATD, A
    CALL Retardo_1s
    INCF ContadorExterno, F, A
    DECFSZ WREG, F
    GOTO Contar
    GOTO BuclePrincipal

Retardo_1s:
    MOVLW 200
    MOVWF ContadorExterno, A
Loop3:
    MOVLW 255
    MOVWF ContadorInterno, A
Loop2:
    MOVLW 255
    MOVWF Temp, A
Loop1:
    DECFSZ Temp, F, A
    GOTO Loop1
    DECFSZ ContadorInterno, F, A
    GOTO Loop2
    DECFSZ ContadorExterno, F, A
    GOTO Loop3
    RETURN

    END