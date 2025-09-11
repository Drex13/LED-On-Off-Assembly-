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
    ; --- DETECCIÓN DE BOTÓN ---
    MOVF PORTB, W, A
    ANDLW 0x01           ; Solo bit 0 (RB0)
    MOVWF Temp, A        ; Guardar estado actual
    
    ; Comparar con estado anterior
    XORWF BotonAnt, W, A
    BZ NoCambioBoton     ; Si no hay cambio, saltar
    
    ; Hubo cambio?
    BTFSS Temp, 0, A     ; Verificar bit 0 del estado actual
    GOTO NoCambioBoton   
    
    ; Cambiar secuencia
    INCF SecuenciaActual, F, A
    MOVLW 3
    CPFSLT SecuenciaActual, A
    CLRF SecuenciaActual, A
    
    ; Indicar cambio con parpadeo rápido
    MOVLW 0x0F
    MOVWF LATD, A
    CALL Retardo_200ms
    CLRF LATD, A
    CALL Retardo_200ms

NoCambioBoton:
    ; Actualizar estado anterior del botón
    MOVFF Temp, BotonAnt
    
    ; --- EJECUTAR SECUENCIA ACTUAL ---
    MOVF SecuenciaActual, W, A
    BZ Secuencia1        ; Si es 0, ir a Secuencia1
    
    MOVLW 1
    SUBWF SecuenciaActual, W, A
    BZ Secuencia2        ; Si es 1, ir a Secuencia2
    
    MOVLW 2
    SUBWF SecuenciaActual, W, A
    BZ Secuencia3        ; Si es 2, ir a Secuencia3
    
    ; Por seguridad, si no es ninguna, ir a Secuencia1
    GOTO Secuencia1

; --- SECUENCIA 1: Movimiento 1-2-3-4 ---
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
    
    ; PAUSA antes de repetir la secuencia
    CLRF LATD, A         ; Apagar todos los LEDs
    CALL Retardo_1s      ; Pausa de 1 segundo
    CALL Retardo_1s      ; Otra pausa de 1 segundo 
    
    GOTO BuclePrincipal

; --- SECUENCIA 2: Movimiento 4-3-2-1 ---
Secuencia2:
    MOVLW 0x08
    MOVWF LATD, A
    CALL Retardo_1s
    
    MOVLW 0x04
    MOVWF LATD, A
    CALL Retardo_1s
    
    MOVLW 0x02
    MOVWF LATD, A
    CALL Retardo_1s
    
    MOVLW 0x01
    MOVWF LATD, A
    CALL Retardo_1s
    
    ; PAUSA antes de repetir la secuencia
    CLRF LATD, A         ; Apagar todos los LEDs
    CALL Retardo_1s      ; Pausa de 1 segundo
    CALL Retardo_1s      ; Otra pausa de 1 segundo 
    
    GOTO BuclePrincipal

; --- SECUENCIA 3: Intermitente alterno ---
Secuencia3:
    MOVLW 0x09           ; 1001 - LEDs 1 y 4
    MOVWF LATD, A
    CALL Retardo_1s
    
    MOVLW 0x06           ; 0110 - LEDs 2 y 3
    MOVWF LATD, A
    CALL Retardo_1s
    
    ; Repetir el parpadeo varias veces antes de pausa
    MOVLW 0x09
    MOVWF LATD, A
    CALL Retardo_1s
    
    MOVLW 0x06
    MOVWF LATD, A
    CALL Retardo_1s
    
    MOVLW 0x09
    MOVWF LATD, A
    CALL Retardo_1s
    
    MOVLW 0x06
    MOVWF LATD, A
    CALL Retardo_1s
    
    ; PAUSA antes de repetir la secuencia
    CLRF LATD, A         ; Apagar todos los LEDs
    CALL Retardo_1s      ; Pausa de 1 segundo
    CALL Retardo_1s      ; Otra pausa de 1 segundo 
    
    GOTO BuclePrincipal

; --- RUTINAS DE RETARDO ---
Retardo_200ms:
    MOVLW 200
    MOVWF ContadorExterno, A
Ret200ms_Loop:
    CALL Delay_1ms
    DECFSZ ContadorExterno, F, A
    GOTO Ret200ms_Loop
    RETURN

Retardo_1s:
    MOVLW 250
    MOVWF ContadorExterno, A
R1s_Loop1:
    CALL Delay_1ms
    DECFSZ ContadorExterno, F, A
    GOTO R1s_Loop1
    
    MOVLW 250
    MOVWF ContadorExterno, A
R1s_Loop2:
    CALL Delay_1ms
    DECFSZ ContadorExterno, F, A
    GOTO R1s_Loop2
    
    MOVLW 250
    MOVWF ContadorExterno, A
R1s_Loop3:
    CALL Delay_1ms
    DECFSZ ContadorExterno, F, A
    GOTO R1s_Loop3
    
    MOVLW 250
    MOVWF ContadorExterno, A
R1s_Loop4:
    CALL Delay_1ms
    DECFSZ ContadorExterno, F, A
    GOTO R1s_Loop4
    RETURN

Delay_1ms:
    MOVLW 100
    MOVWF ContadorInterno, A
D1ms_Loop:
    NOP
    NOP
    NOP
    DECFSZ ContadorInterno, F, A
    GOTO D1ms_Loop
    RETURN
    
    END