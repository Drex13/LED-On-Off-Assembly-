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
    
    ; Configurar PORTA (botón en RA0)
    MOVLW   0x01           
    MOVWF   TRISA
    BSF     PORTA, 0      
    
    ; Inicializar contador de secuencia
    CLRF    Secuencia      

MainLoop:
    ; Verificar si botón fue presionado
    BTFSS   PORTA, 0       
    GOTO    CambiarSecuencia 
    
    ; Ejecutar secuencia actual automáticamente
    MOVF    Secuencia, W   
    ANDLW   0x03           ; Mantener entre 0-3 (4 secuencias)
    
    ; Seleccionar patrón según secuencia
    MOVLW   0x00
    XORWF   Secuencia, W
    BZ      Secuencia0     ; Secuencia 0: Todos simultáneos
    
    MOVLW   0x01
    XORWF   Secuencia, W
    BZ      Secuencia1     ; Secuencia 1: LEDs 1, 3 y 4
    
    MOVLW   0x02
    XORWF   Secuencia, W
    BZ      Secuencia2     ; Secuencia 2: Todos prendidos
    
    GOTO    Secuencia3     ; Secuencia 3: Apagados

; SECUENCIA 0: Todos los LEDs simultáneos (ON-OFF)
Secuencia0:
    MOVLW   0x0F          
    MOVWF   LATB
    CALL    Retardo_2s
    CLRF    LATB          
    CALL    Retardo_1s
    GOTO    MainLoop

; SECUENCIA 1: LEDs 1, 3 y 4 (RB0, RB2, RB3)
Secuencia1:
    MOVLW   0x0D          
    MOVWF   LATB           
    CALL    Retardo_2s
    CLRF    LATB           
    CALL    Retardo_1s
    GOTO    MainLoop

; SECUENCIA 2: Todos los LEDs siempre prendidos
Secuencia2:
    MOVLW   0x0F           
    MOVWF   LATB
    CALL    Retardo_2s     
    GOTO    MainLoop

; SECUENCIA 3: Todos los LEDs siempre apagados
Secuencia3:
    CLRF    LATB           
    CALL    Retardo_2s    
    GOTO    MainLoop

; CAMBIAR SECUENCIA AL PRESIONAR BOTÓN
CambiarSecuencia:
    
    BTFSS   PORTA, 0       
    GOTO    $-1            
    
    ; Cambiar a siguiente secuencia
    INCF    Secuencia, F   
    MOVLW   0x03            
    ANDWF   Secuencia, F   
    GOTO    MainLoop

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
    BTFSS   PORTA, 0      
    RETURN                
    DECFSZ  ContadorInterno, F
    GOTO    LoopInterno2s
    DECFSZ  ContadorExterno, F
    GOTO    LoopExterno2s
    RETURN

; Subrutina de Retardo de 1 Segundo
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
    BTFSS   PORTA, 0      
    RETURN                 
    DECFSZ  ContadorInterno, F
    GOTO    LoopInterno1s
    DECFSZ  ContadorExterno, F
    GOTO    LoopExterno1s
    RETURN

; Variables
PSECT udata
ContadorExterno:   DS 1
ContadorInterno:   DS 1
Secuencia:         DS 1    

END