    LIST    P=18F4550
    #include <xc.inc>
    
    ; configuración
    CONFIG  FOSC = INTOSCIO_EC
    CONFIG  FCMEN = OFF
    CONFIG  IESO = OFF
    CONFIG  WDT = OFF
    CONFIG  PBADEN = OFF
    CONFIG  LVP = OFF
    
    ORG     0x0000
    GOTO    PROGRAMA_PRINCIPAL

PROGRAMA_PRINCIPAL:
    ; Preparar el puerto B para los LEDs
    MOVLW   0xF0        
    MOVWF   TRISB
    CLRF    LATB
    
    ; Configurar el reloj interno
    MOVLW   0x72        
    MOVWF   OSCCON
    
    ; secuencia
SECUENCIA:
    MOVLW   0x01
    MOVWF   LATB
    CALL    ESPERAR
    
    MOVLW   0x02
    MOVWF   LATB
    CALL    ESPERAR
    
    MOVLW   0x04
    MOVWF   LATB
    CALL    ESPERAR
    
    MOVLW   0x08
    MOVWF   LATB
    CALL    ESPERAR
    
    CLRF    LATB
    CALL    ESPERAR
    
    BRA     SECUENCIA

; Retardo usando registros directamente
ESPERAR:
    MOVLW   0x40
    MOVWF   0x20    ; Usamos dirección directa
CICLO3:
    MOVLW   0xFF
    MOVWF   0x21
CICLO2:
    MOVLW   0xFF
    MOVWF   0x22
CICLO1:
    DECFSZ  0x22, F
    BRA     CICLO1
    DECFSZ  0x21, F
    BRA     CICLO2
    DECFSZ  0x20, F
    BRA     CICLO3
    RETURN

    END