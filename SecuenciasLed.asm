    LIST    P=18F4550
    #include <xc.inc>
    
    ; Configuración
    CONFIG  FOSC = INTOSCIO_EC
    CONFIG  FCMEN = OFF
    CONFIG  IESO = OFF
    CONFIG  WDT = OFF
    CONFIG  PBADEN = OFF
    CONFIG  LVP = OFF
    
    ; Variables
CONTADOR    EQU 0x20
TIEMPO1     EQU 0x21
TIEMPO2     EQU 0x22
TIEMPO3     EQU 0x23
SECUENCIA   EQU 0x24
    
    ORG     0x0000
    GOTO    INICIO

INICIO:
    ; Configurar puertos
    ; RB0 como entrada (botón), RD0-RD3 como salidas (LEDs)
    MOVLW   0x01        
    MOVWF   TRISB
    MOVLW   0x00        
    MOVWF   TRISD
    CLRF    LATD        ; Apagar todos los LEDs
    
    ; Iniciar variable de secuencia
    CLRF    SECUENCIA

PRINCIPAL:
    ; Verificar secuencia actual
    MOVF    SECUENCIA, W
    BZ      SECUENCIA1
    XORLW   1
    BZ      SECUENCIA2
    BRA     SECUENCIA3

SECUENCIA1:
    ; Carrera de LEDs 
    MOVLW   1
    MOVWF   LATD
    CALL    RETARDO
    
    MOVLW   2
    MOVWF   LATD
    CALL    RETARDO
    
    MOVLW   4
    MOVWF   LATD
    CALL    RETARDO
    
    MOVLW   8
    MOVWF   LATD
    CALL    RETARDO
    
    CLRF    LATD
    CALL    RETARDO
    BRA     CAMBIAR_SECUENCIA

SECUENCIA2:
    ; Parpadeo LEDs 
    MOVLW   3
    MOVWF   CONTADOR
PARPADEO:
    MOVLW   15         ; RD0-RD3 encendidos
    MOVWF   LATD
    CALL    RETARDO_LARGO
    
    CLRF    LATD       ; Todos apagados
    CALL    RETARDO_LARGO
    
    DECFSZ  CONTADOR, F
    BRA     PARPADEO
    BRA     CAMBIAR_SECUENCIA

SECUENCIA3:
    ; Contador 
    CLRF    CONTADOR
    MOVLW   16
CONTAR:
    MOVF    CONTADOR, W
    MOVWF   LATD
    CALL    RETARDO_LARGO
    INCF    CONTADOR, F
    DECFSZ  WREG, F
    BRA     CONTAR

CAMBIAR_SECUENCIA:
    ; Cambiar a siguiente secuencia
    INCF    SECUENCIA, F
    MOVLW   3
    CPFSLT  SECUENCIA
    CLRF    SECUENCIA
    
    ; Pequeña pausa entre secuencias
    CALL    RETARDO_LARGO
    BRA     PRINCIPAL

RETARDO:
    ; Retardo corto
    MOVLW   100
    MOVWF   TIEMPO3
LOOP3:
    MOVLW   255
    MOVWF   TIEMPO2
LOOP2:
    MOVLW   255
    MOVWF   TIEMPO1
LOOP1:
    DECFSZ  TIEMPO1, F
    BRA     LOOP1
    DECFSZ  TIEMPO2, F
    BRA     LOOP2
    DECFSZ  TIEMPO3, F
    BRA     LOOP3
    RETURN

RETARDO_LARGO:
    ; Retardo largo
    MOVLW   200
    MOVWF   TIEMPO3
LOOP3_L:
    MOVLW   255
    MOVWF   TIEMPO2
LOOP2_L:
    MOVLW   255
    MOVWF   TIEMPO1
LOOP1_L:
    DECFSZ  TIEMPO1, F
    BRA     LOOP1_L
    DECFSZ  TIEMPO2, F
    BRA     LOOP2_L
    DECFSZ  TIEMPO3, F
    BRA     LOOP3_L
    RETURN

    END