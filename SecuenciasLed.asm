    LIST    P=18F4550
    #include <xc.inc>
    
    ; configuración
    CONFIG  FOSC = INTOSCIO_EC
    CONFIG  FCMEN = OFF
    CONFIG  IESO = OFF
    CONFIG  WDT = OFF
    CONFIG  PBADEN = OFF
    CONFIG  LVP = OFF
    
    ; variables
    CONTADOR    EQU 0x20
    TIEMPO1     EQU 0x21
    TIEMPO2     EQU 0x22
    TIEMPO3     EQU 0x23
    SECUENCIA   EQU 0x24
    
    ORG     0x0000
    GOTO    PROGRAMA_PRINCIPAL

PROGRAMA_PRINCIPAL:
    ; Preparar el puerto B para los LEDs
    MOVLW   0xF0        ; RB0-RB3 = salidas
    MOVWF   TRISB
    CLRF    LATB        ; Apagar todos los LEDs
    
    ; Configurar el reloj interno
    MOVLW   0x72        ; 8MHz
    MOVWF   OSCCON
    
    CLRF    SECUENCIA   ; Empezar con secuencia 0

BUCLE_PRINCIPAL:
    ; Verificar qué secuencia ejecutar
    MOVF    SECUENCIA, W
    BZ      SECUENCIA_CARRERA
    XORLW   0x01
    BZ      SECUENCIA_PARPADEO
    BRA     SECUENCIA_BINARIO

; Secuencia 1: Carrera de LEDs
SECUENCIA_CARRERA:
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
    
    BRA     CAMBIAR_SECUENCIA

; Secuencia 2: Parpadeo de todos
SECUENCIA_PARPADEO:
    MOVLW   0x03        ; Repetir 3 veces
    MOVWF   CONTADOR
PARPADEO_LOOP:
    MOVLW   0x0F        ; Encender los 4 LEDs
    MOVWF   LATB
    CALL    ESPERAR_LARGO
    
    CLRF    LATB        ; Apagar todos
    CALL    ESPERAR_LARGO
    
    DECFSZ  CONTADOR, F
    BRA     PARPADEO_LOOP
    
    BRA     CAMBIAR_SECUENCIA

; Secuencia 3: Contador 
SECUENCIA_BINARIO:
    CLRF    CONTADOR
    MOVLW   0x10        ; Contar de 0 a 15
    MOVWF   LATB        
BINARIO_LOOP:
    MOVFF   CONTADOR, LATB
    CALL    ESPERAR_LARGO
    INCF    CONTADOR, F
    DECFSZ  LATB, F
    BRA     BINARIO_LOOP

; Cambiar a la siguiente secuencia
CAMBIAR_SECUENCIA:
    INCF    SECUENCIA, F
    MOVLW   0x03
    CPFSLT  SECUENCIA   ; Si SECUENCIA >= 3, resetear a 0
    CLRF    SECUENCIA
    
    CALL    ESPERAR_LARGO
    CALL    ESPERAR_LARGO
    
    BRA     BUCLE_PRINCIPAL

; Retardo corto
ESPERAR:
    MOVLW   0x20
    MOVWF   TIEMPO3
CICLO3:
    MOVLW   0xFF
    MOVWF   TIEMPO2
CICLO2:
    MOVLW   0xFF
    MOVWF   TIEMPO1
CICLO1:
    DECFSZ  TIEMPO1, F
    BRA     CICLO1
    DECFSZ  TIEMPO2, F
    BRA     CICLO2
    DECFSZ  TIEMPO3, F
    BRA     CICLO3
    RETURN

; Retardo largo
ESPERAR_LARGO:
    MOVLW   0x80
    MOVWF   TIEMPO3
CICLO3_LARGO:
    MOVLW   0xFF
    MOVWF   TIEMPO2
CICLO2_LARGO:
    MOVLW   0xFF
    MOVWF   TIEMPO1
CICLO1_LARGO:
    DECFSZ  TIEMPO1, F
    BRA     CICLO1_LARGO
    DECFSZ  TIEMPO2, F
    BRA     CICLO2_LARGO
    DECFSZ  TIEMPO3, F
    BRA     CICLO3_LARGO
    RETURN

    END