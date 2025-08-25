;=========================================================
; C�digo en Assembler para PIC18F4550
; Parpadeo de LED en RB0 cada 1 segundo
; Usa retardos sin interrupciones ni Timer0
; Frecuencia: 8 MHz (Oscilador Interno)
; Ensamblador: MPLAB XC8 3.0
;=========================================================

    #include <xc.inc>   ; Incluir definiciones del ensamblador para PIC18F4550

    ; Configuraci�n de bits de configuraci�n (Fuses)
    CONFIG  FOSC = INTOSCIO_EC   ; Usa el oscilador interno a 8 MHz
    CONFIG  WDT = OFF            ; Deshabilitar el Watchdog Timer
    CONFIG  LVP = OFF            ; Deshabilitar la programaci�n en bajo voltaje
    CONFIG  PBADEN = OFF         ; Configurar los pines de PORTB como digitales

    ;===============================================
    ; Vectores de Inicio
    ;===============================================

    PSECT  resetVec, class=CODE, reloc=2  ; Secci�n para el vector de reinicio
    ORG     0x00                          ; Direcci�n de inicio
    GOTO    Inicio                         ; Saltar a la rutina de inicio

    ;===============================================
    ; C�digo Principal
    ;===============================================
    
    PSECT  main_code, class=CODE, reloc=2  ; Secci�n de c�digo principal

Inicio:
    CLRF    TRISB       ; Configurar PORTB como salida (0 = salida, 1 = entrada)
    CLRF    LATB        ; Apagar todos los pines de PORTB (LED apagado inicialmente)

Loop:
    BTG     LATB, 0     ; Alternar el estado del LED en RB0 (si est� encendido, lo apaga y viceversa)
    CALL    Retardo_1s  ; Llamar a la rutina de retardo de 1 segundo
    GOTO    Loop        ; Repetir el proceso de parpadeo en bucle infinito

    ;===============================================
    ; Subrutina de Retardo de 1 Segundo (Aprox.)
    ;===============================================

Retardo_1s:
    MOVLW   25          ; Cargar el valor 25 en el registro W (contador externo)
    MOVWF   ContadorExterno  ; Guardar el valor en la variable ContadorExterno

LoopExterno:
    MOVLW   250         ; Cargar el valor 250 en el registro W (contador interno)
    MOVWF   ContadorInterno  ; Guardar el valor en la variable ContadorInterno

LoopInterno:
    NOP                 ; No hacer nada (consume un ciclo de instrucci�n)
    NOP                 ; No hacer nada (consume otro ciclo)
    NOP                 ; No hacer nada (consume otro ciclo)
    
    DECFSZ  ContadorInterno, F  ; Decrementar ContadorInterno, si es cero, salta la siguiente instrucci�n
    GOTO    LoopInterno         ; Si no es cero, repetir el bucle interno

    DECFSZ  ContadorExterno, F  ; Decrementar ContadorExterno, si es cero, salta la siguiente instrucci�n
    GOTO    LoopExterno         ; Si no es cero, repetir el bucle externo

    RETURN              ; Retornar al programa principal despu�s del retardo

    ;===============================================
    ; Definici�n de Variables
    ;===============================================

    PSECT udata  ; Secci�n de datos sin inicializar (variables en RAM)
ContadorExterno:   DS 1   ; Reserva 1 byte de memoria para el contador externo
ContadorInterno:   DS 1   ; Reserva 1 byte de memoria para el contador interno

    END            ; Fin del c�digo

;prueba 2 del git, este codigo es del profesor
