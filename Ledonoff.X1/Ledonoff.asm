;=========================================================
; Código en Assembler para PIC18F4550
; Parpadeo de LED en RB0 cada 1 segundo
; Usa retardos sin interrupciones ni Timer0
; Frecuencia: 8 MHz (Oscilador Interno)
; Ensamblador: MPLAB XC8 3.0
;=========================================================

    #include <xc.inc>   ; Incluir definiciones del ensamblador para PIC18F4550

    ; Configuración de bits de configuración (Fuses)
    CONFIG  FOSC = INTOSCIO_EC   ; Usa el oscilador interno a 8 MHz
    CONFIG  WDT = OFF            ; Deshabilitar el Watchdog Timer
    CONFIG  LVP = OFF            ; Deshabilitar la programación en bajo voltaje
    CONFIG  PBADEN = OFF         ; Configurar los pines de PORTB como digitales

    ;===============================================
    ; Vectores de Inicio
    ;===============================================

    PSECT  resetVec, class=CODE, reloc=2  ; Sección para el vector de reinicio
    ORG     0x00                          ; Dirección de inicio
    GOTO    Inicio                         ; Saltar a la rutina de inicio

    ;===============================================
    ; Código Principal
    ;===============================================
    
    PSECT  main_code, class=CODE, reloc=2  ; Sección de código principal

Inicio:
    CLRF    TRISB       ; Configurar PORTB como salida (0 = salida, 1 = entrada)
    CLRF    LATB        ; Apagar todos los pines de PORTB (LED apagado inicialmente)

Loop:
    BSF     LATB, 0     ; Alternar el estado del LED en RB0 (si está encendido, lo apaga y viceversa)
    CALL    Retardo_1s; Llamar a la rutina de retardo de 1 segundo
    CALL    Retardo_1s;
    CALL    Retardo_1s;
    CALL    Retardo_1s;
    CALL    Retardo_1s;
    
    BCF     LATB, 0        ; Apaga LED en RB0
    CALL    Retardo_1s     ; Espera 1s
    CALL    Retardo_1s     ; Espera 2s en total
    
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
    NOP                 ; No hacer nada (consume un ciclo de instrucción)
    NOP                 ; No hacer nada (consume otro ciclo)
    NOP                 ; No hacer nada (consume otro ciclo)
    
    DECFSZ  ContadorInterno, F  ; Decrementar ContadorInterno, si es cero, salta la siguiente instrucción
    GOTO    LoopInterno         ; Si no es cero, repetir el bucle interno

    DECFSZ  ContadorExterno, F  ; Decrementar ContadorExterno, si es cero, salta la siguiente instrucción
    GOTO    LoopExterno         ; Si no es cero, repetir el bucle externo

    RETURN              ; Retornar al programa principal después del retardo

    ;===============================================
    ; Definición de Variables
    ;===============================================

    PSECT udata  ; Sección de datos sin inicializar (variables en RAM)
ContadorExterno:   DS 1   ; Reserva 1 byte de memoria para el contador externo
ContadorInterno:   DS 1   ; Reserva 1 byte de memoria para el contador interno

    END            ; Fin del código



