;=========================================================
; Código en Assembler para PIC18F4550
; LED ON: 5000ms, LED OFF: 2000ms
; Frecuencia: 8 MHz (Oscilador Interno)
; Ensamblador: MPLAB XC8 3.0
;=========================================================

#include 

; Configuración de bits de configuración (Fuses)
CONFIG  FOSC = INTOSCIO_EC   ; Oscilador interno a 8 MHz
CONFIG  WDT = OFF            ; Watchdog Timer deshabilitado
CONFIG  LVP = OFF            ; Programación en bajo voltaje deshabilitada
CONFIG  PBADEN = OFF         ; Pines de PORTB como digitales

; Vectores de Inicio
PSECT  resetVec, class=CODE, reloc=2
ORG     0x00
GOTO    Inicio

; Código Principal
PSECT  main_code, class=CODE, reloc=2

Inicio:
    CLRF    TRISB       ; PORTB como salida
    CLRF    LATB        ; Apagar todos los LEDs

MainLoop:
    ; Encender LED (5000ms)
    BSF     LATB, 0     ; Encender LED en RB0
    CALL    Retardo_5s  ; Esperar 5 segundos
    
    ; Apagar LED (2000ms)
    BCF     LATB, 0     ; Apagar LED en RB0
    CALL    Retardo_2s  ; Esperar 2 segundos
    
    GOTO    MainLoop    ; Repetir ciclo

; Subrutina de Retardo de 5 Segundos
Retardo_5s:
    MOVLW   125         ; Contador externo para 5 segundos
    MOVWF   ContadorExterno

LoopExterno5s:
    MOVLW   200         ; Contador interno
    MOVWF   ContadorInterno

LoopInterno5s:
    NOP
    NOP
    NOP
    NOP
    
    DECFSZ  ContadorInterno, F
    GOTO    LoopInterno5s

    DECFSZ  ContadorExterno, F
    GOTO    LoopExterno5s

    RETURN

; Subrutina de Retardo de 2 Segundos
Retardo_2s:
    MOVLW   50          ; Contador externo para 2 segundos
    MOVWF   ContadorExterno

LoopExterno2s:
    MOVLW   200         ; Contador interno
    MOVWF   ContadorInterno

LoopInterno2s:
    NOP
    NOP
    NOP
    NOP
    
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