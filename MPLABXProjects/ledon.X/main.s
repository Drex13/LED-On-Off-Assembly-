

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

    ;----------------------------
; RAM (variables)
;----------------------------
    PSECT   udata
msH:            DS 1      ; contador ms alto (16-bit)
msL:            DS 1      ; contador ms bajo
c1:             DS 1      ; contador interno para 1 ms
    
    ;===============================================
    ; Código Principal
    ;===============================================
    
    PSECT  main_code, class=CODE, reloc=2  ; Sección de código principal

Inicio:
    ; Seleccionar INTOSC = 8 MHz y usarlo como reloj del sistema
    ; OSCCON: IRCF=111 (8 MHz), SCS=10 (INTOSC)
    MOVLW   0x72
    MOVWF   OSCCON

    ; Opcional: forzar todo a digital y apagar comparadores
    MOVLW   0x0F
    MOVWF   ADCON1
    MOVLW   0x07
    MOVWF   CMCON

    ; Configurar RB0 como salida, y apagar LED inicialmente
    CLRF    TRISB
    BCF     LATB,0
    
    MainLoop:
    ; ---------- LED ON 5000 ms ----------
    BSF     LATB,0                 ; LED encendido
    MOVLW   0x13                   ; 5000 = 0x1388  ? msH=0x13, msL=0x88
    MOVWF   msH
    MOVLW   0x88
    MOVWF   msL
    CALL    Espera_ms_16

    ; ---------- LED OFF 2000 ms ----------
    BCF     LATB,0                 ; LED apagado
    MOVLW   0x07                   ; 2000 = 0x07D0 ? msH=0x07, msL=0xD0
    MOVWF   msH
    MOVLW   0xD0
    MOVWF   msL
    CALL    Espera_ms_16

    GOTO    MainLoop

    ;------------------------------------------
; Espera_ms_16
;   Espera el número de milisegundos indicado
;   en (msH:msL), 16 bits unsigned.
;   Usa Delay_1ms (?1.000 ms @ Fosc=8 MHz).
;------------------------------------------
Espera_ms_16:
    ; Si msH=0 y msL=0 ? return inmediato
Ems_loop:
    CALL    Delay_1ms

    DECFSZ  msL,F
    GOTO    Ems_loop
    DECFSZ  msH,F
    GOTO    Ems_loop
    RETURN

;------------------------------------------
; Delay_1ms (? exacto a 8 MHz)
;   Fosc = 8 MHz ? Fcy = 2 MHz ? 1 ms = 2000 ciclos
;   Dos bucles de 200 iteraciones:
;     Cada iteración (excepto la última) = 5 ciclos
;     Total por bucle = 5*N - 1 = 999 ciclos (N=200)
;   Dos bucles = 1998 ciclos; +2 NOP = 2000 ciclos
;------------------------------------------
Delay_1ms:
    MOVLW   200
    MOVWF   c1
D1ms_L1:
    NOP
    NOP
    DECFSZ  c1,F
    GOTO    D1ms_L1               ; (5*N - 1) = 999 ciclos

    MOVLW   200
    MOVWF   c1
D1ms_L2:
    NOP
    NOP
    DECFSZ  c1,F
    GOTO    D1ms_L2               ; 999 ciclos

    NOP                            ; +2 ciclos para cerrar en 2000
    NOP
    RETURN

    END