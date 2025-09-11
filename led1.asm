#include <xc.inc>

; Configuracion
CONFIG  FOSC = INTOSCIO_EC   
CONFIG  WDT = OFF            
CONFIG  LVP = OFF            
CONFIG  PBADEN = OFF        
CONFIG  MCLRE = ON           

PSECT  resetVec, class=CODE, reloc=2
ORG     0x00
GOTO    Inicio

PSECT  main_code, class=CODE, reloc=2

Inicio:
    
    CLRF    TRISB           
    CLRF    LATB            
    
    
    MOVLW   0x01           
    MOVWF   TRISA
    BSF     PORTA, 0       
    
  
    CLRF    Secuencia      ; 0-2 para 3 secuencias

MainLoop:
    ; Verificar si botón fue presionado
    BTFSS   PORTA, 0       ; Botón NO presionado?
    GOTO    CambiarSecuencia ; Botón presionado, cambiar secuencia
    
    
    MOVF    Secuencia, W   ; Cargar número de secuencia
    ANDLW   0x03           ; Mantener entre 0-2
    
    
    MOVLW   0x00
    XORWF   Secuencia, W
    BZ      Secuencia0     ; Secuencia 0: Todos
    
    MOVLW   0x01
    XORWF   Secuencia, W
    BZ      Secuencia1     ; Secuencia 1: Pares 1+3 y 2+4
    
    GOTO    Secuencia2     ; Secuencia 2: Pares 1+4 y 2+3

; SECUENCIA 0: Todos los LEDs simultáneos
Secuencia0:
    MOVLW   0x0F           ; Todos ON
    MOVWF   LATB
    CALL    Retardo_1s
    CLRF    LATB           ; Todos OFF
    CALL    Retardo_1s
    GOTO    MainLoop

; SECUENCIA 1: LEDs 1+3 y 2+4 alternados
Secuencia1:
    MOVLW   0x05           ;  RB0 y RB2 ON 
    MOVWF   LATB
    CALL    Retardo_1s
    CLRF    LATB           ; Todos OFF
    CALL    Retardo_0_5s
    
    MOVLW   0x0A           ; RB1 y RB3 ON 
    MOVWF   LATB
    CALL    Retardo_1s
    CLRF    LATB           ; Todos OFF
    CALL    Retardo_0_5s
    GOTO    MainLoop

; SECUENCIA 2: LEDs 1+4 y 2+3 alternados
Secuencia2:
    MOVLW   0x09           ;  RB0 y RB3 ON 
    MOVWF   LATB
    CALL    Retardo_1s
    CLRF    LATB           ; Todos OFF
    CALL    Retardo_0_5s
    
    MOVLW   0x06           ; RB1 y RB2 ON 
    MOVWF   LATB
    CALL    Retardo_1s
    CLRF    LATB           ; Todos OFF
    CALL    Retardo_0_5s
    GOTO    MainLoop

; CAMBIAR SECUENCIA AL PRESIONAR BOTÓN
CambiarSecuencia:
   
    BTFSS   PORTA, 0       ; Botón sigue presionado?
    GOTO    $-1            ; Esperar hasta que se suelte
    
   
    INCF    Secuencia, F   ; Incrementar número de secuencia
    MOVLW   0x03           ; 
    ANDWF   Secuencia, F   ; Mantener entre 0-2
    GOTO    MainLoop


Retardo_1s:
    MOVLW   25             
    MOVWF   ContadorExterno
LoopExterno1s:
    MOVLW   200            
    MOVWF   ContadorInterno
LoopInterno1s:
    NOP
    NOP
    NOP
    NOP
    BTFSS   PORTA, 0       ; Verificar si botón es presionado
    RETURN                 
    DECFSZ  ContadorInterno, F
    GOTO    LoopInterno1s
    DECFSZ  ContadorExterno, F
    GOTO    LoopExterno1s
    RETURN


Retardo_0_5s:
    MOVLW   12             
    MOVWF   ContadorExterno
LoopExterno05s:
    MOVLW   200            
    MOVWF   ContadorInterno
LoopInterno05s:
    NOP
    NOP
    NOP
    NOP
    BTFSS   PORTA, 0       ; Verificar si botón es presionado
    RETURN                 
    DECFSZ  ContadorInterno, F
    GOTO    LoopInterno05s
    DECFSZ  ContadorExterno, F
    GOTO    LoopExterno05s
    RETURN

; Variables
PSECT udata
ContadorExterno:   DS 1
ContadorInterno:   DS 1
Secuencia:         DS 1    ; 0-2 para 3 secuencias

END