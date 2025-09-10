    LIST    P=18F4550
    #include <xc.inc>
    
    ; Configuración 
    CONFIG  FOSC = INTOSCIO_EC
    CONFIG  FCMEN = OFF
    CONFIG  IESO = OFF
    CONFIG  WDT = OFF
    CONFIG  PBADEN = OFF
    CONFIG  LVP = OFF
    
    ; variables 
    PSECT   udata_acs
CONTADOR:    DS 1
TIEMPO1:     DS 1
TIEMPO2:     DS 1
TIEMPO3:     DS 1
SECUENCIA:   DS 1
TEMP:        DS 1
BOTON_ANT:   DS 1

    PSECT   resetVec,class=CODE,reloc=2
    GOTO    PROGRAMA_PRINCIPAL

    ; Código principal
    PSECT   code
PROGRAMA_PRINCIPAL:
    ; Preparar el puerto B para LEDs
    MOVLW   0xF0        
    MOVWF   TRISB, A
    CLRF    LATB, A
    
    ; Configurar reloj interno a 8MHz
    MOVLW   0x72        
    MOVWF   OSCCON, A
    
    ; Iniciar variables
    CLRF    SECUENCIA, A
    CLRF    BOTON_ANT, A

BUCLE_PRINCIPAL:
    ; Verificar qué secuencia mostrar
    MOVF    SECUENCIA, W, A
    BZ      SECUENCIA_CARRERA
    XORLW   0x01
    BZ      SECUENCIA_PARPADEO
    BRA     SECUENCIA_BINARIO

; Secuencia 1: LEDs que corren
SECUENCIA_CARRERA:
    MOVLW   0x01
    MOVWF   LATB, A
    CALL    ESPERAR
    
    MOVLW   0x02
    MOVWF   LATB, A
    CALL    ESPERAR
    
    MOVLW   0x04
    MOVWF   LATB, A
    CALL    ESPERAR
    
    MOVLW   0x08
    MOVWF   LATB, A
    CALL    ESPERAR
    
    CLRF    LATB, A
    CALL    ESPERAR
    
    BRA     BUCLE_PRINCIPAL

; Secuencia 2: Todos parpadean
SECUENCIA_PARPADEO:
    MOVLW   0x03
    MOVWF   CONTADOR, A
PARPADEO_LOOP:
    MOVLW   0x0F
    MOVWF   LATB, A
    CALL    ESPERAR_LARGO
    
    CLRF    LATB, A
    CALL    ESPERAR_LARGO
    
    DECFSZ  CONTADOR, F, A
    BRA     PARPADEO_LOOP
    
    BRA     BUCLE_PRINCIPAL

; Secuencia 3: Contador binario
SECUENCIA_BINARIO:
    CLRF    CONTADOR, A
    MOVLW   0x10
    MOVWF   TEMP, A
BINARIO_LOOP:
    MOVF    CONTADOR, W, A
    MOVWF   LATB, A
    CALL    ESPERAR_LARGO
    
    INCF    CONTADOR, F, A
    DECFSZ  TEMP, F, A
    BRA     BINARIO_LOOP
    
    BRA     BUCLE_PRINCIPAL

; Retardo corto
ESPERAR:
    MOVLW   0x20
    MOVWF   TIEMPO3, A
CICLO3:
    MOVLW   0xFF
    MOVWF   TIEMPO2, A
CICLO2:
    MOVLW   0xFF
    MOVWF   TIEMPO1, A
CICLO1:
    DECFSZ  TIEMPO1, F, A
    BRA     CICLO1
    DECFSZ  TIEMPO2, F, A
    BRA     CICLO2
    DECFSZ  TIEMPO3, F, A
    BRA     CICLO3
    RETURN

; Retardo largo
ESPERAR_LARGO:
    MOVLW   0x80
    MOVWF   TIEMPO3, A
CICLO3_LARGO:
    MOVLW   0xFF
    MOVWF   TIEMPO2, A
CICLO2_LARGO:
    MOVLW   0xFF
    MOVWF   TIEMPO1, A
CICLO1_LARGO:
    DECFSZ  TIEMPO1, F, A
    BRA     CICLO1_LARGO
    DECFSZ  TIEMPO2, F, A
    BRA     CICLO2_LARGO
    DECFSZ  TIEMPO3, F, A
    BRA     CICLO3_LARGO
    RETURN

    END