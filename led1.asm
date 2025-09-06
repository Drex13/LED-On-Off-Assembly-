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
    ; Configurar puertos
    CLRF    TRISB           
    CLRF    LATB           
    
    
    MOVLW   0x01           
    MOVWF   TRISA
    BSF     PORTA, 0       

MainLoop:
    ; Leer estado del botón (RA0)
    BTFSS   PORTA, 0       
    GOTO    BotonPresionado 
    
    ; Botón NO presionado - Apagar todos los LEDs
    CLRF    LATB            
    GOTO    MainLoop       

BotonPresionado:
    
    MOVLW   0x0F     ; 00001111 prendidos      
    MOVWF   LATB           
    CALL    Retardo_5s     
    
    ; APAGAR todos los LEDs
    CLRF    LATB      ; 00000000 - Apagar todos los LEDs      
    CALL    Retardo_2s     
    
    ; Verificar si el botón sigue presionado
    BTFSC   PORTA, 0       
    GOTO    MainLoop       
    
    GOTO    BotonPresionado 

; Subrutina de Retardo de 5 Segundos
Retardo_5s:
    MOVLW   125            
    MOVWF   ContadorExterno

LoopExterno5s:
    MOVLW   200            
    MOVWF   ContadorInterno

LoopInterno5s:
    NOP
    NOP
    NOP
    NOP
    
    ; Verificar botón durante el retardo
    BTFSC   PORTA, 0       
    RETURN                 
    
    DECFSZ  ContadorInterno, F
    GOTO    LoopInterno5s

    DECFSZ  ContadorExterno, F
    GOTO    LoopExterno5s

    RETURN

; Subrutina de Retardo de 2 Segundos
Retardo_2s:
    MOVLW   50             
    MOVWF   ContadorExterno

LoopExterno2s:
    MOVLW   200            
    MOVWF   ContadorInterno

LoopInterno2s:
    NOP
    NOP
    NOP
    NOP
    
    ; Verificar botón durante el retardo
    BTFSC   PORTA, 0       
    RETURN                 
    
    DECFSZ  ContadorInterno, F
    GOTO    LoopInterno2s

    DECFSZ  ContadorExterno, F
    GOTO    LoopExterno2s

    RETURN

; Variables
PSECT udata
ContadorExterno:   DS 1
ContadorInterno:   DS 1

END