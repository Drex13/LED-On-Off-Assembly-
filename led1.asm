#include <xc.inc>


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
    CLRF    TRISB           ; RB como salida
    CLRF    LATB            ; LEDs apagados

    MOVLW   0x01           
    MOVWF   TRISA           ; RA0 como entrada
    CLRF    LATA

    CLRF    Secuencia       ; 0-2 para 3 secuencias

MainLoop:
    ;--- Verificar botón ---
    BTFSC   PORTA, 0        ; RA0=0  skip
    GOTO    CambiarSecuencia ; RA0=1   cambiar secuencia

    
    MOVF    Secuencia, W
    ANDLW   0x03
    
    MOVLW   0x00
    XORWF   Secuencia, W
    BZ      Secuencia0
    
    MOVLW   0x01
    XORWF   Secuencia, W
    BZ      Secuencia1
    
    GOTO    Secuencia2


Secuencia0:
    MOVLW   0x0F           ; Todos ON
    MOVWF   LATB
    CALL    Retardo_1s
    CLRF    LATB
    CALL    Retardo_1s
    GOTO    MainLoop


Secuencia1:
    MOVLW   0x05           ; RB0 y RB2 ON 
    MOVWF   LATB
    CALL    Retardo_1s
    CLRF    LATB
    CALL    Retardo_0_5s
    
    MOVLW   0x0A           ; RB1 y RB3 ON 
    MOVWF   LATB
    CALL    Retardo_1s
    CLRF    LATB
    CALL    Retardo_0_5s
    GOTO    MainLoop


Secuencia2:
    MOVLW   0x09           ; RB0 y RB3 ON 
    MOVWF   LATB
    CALL    Retardo_1s
    CLRF    LATB
    CALL    Retardo_0_5s
    
    MOVLW   0x06           ; RB1 y RB2 ON 
    MOVWF   LATB
    CALL    Retardo_1s
    CLRF    LATB
    CALL    Retardo_0_5s
    GOTO    MainLoop


CambiarSecuencia:
    
EsperarSoltar:
    BTFSC   PORTA,0         ; Si sigue presionado esperar
    GOTO    EsperarSoltar

 
    CALL    Retardo_Debounce

    INCF    Secuencia, F
    MOVLW   0x03
    ANDWF   Secuencia, F    ; mantener entre 0?2
    GOTO    MainLoop

;RETARDOS
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
    BTFSC   PORTA,0         ; si botón presionado  salir
    RETURN
    DECFSZ  ContadorInterno,F
    GOTO    LoopInterno1s
    DECFSZ  ContadorExterno,F
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
    BTFSC   PORTA,0         ; si botón presionado  salir
    RETURN
    DECFSZ  ContadorInterno,F
    GOTO    LoopInterno05s
    DECFSZ  ContadorExterno,F
    GOTO    LoopExterno05s
    RETURN

Retardo_Debounce:
    MOVLW   50
    MOVWF   ContadorInterno
DebounceLoop:
    DECFSZ  ContadorInterno,F
    GOTO    DebounceLoop
    RETURN

PSECT udata
ContadorExterno:   DS 1
ContadorInterno:   DS 1
Secuencia:         DS 1    

END
