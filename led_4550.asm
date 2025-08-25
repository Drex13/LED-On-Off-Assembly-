;
; led_4550.asm - PIC18F4550 (MPASM/MPASMX)
; LED en RB0: encender 5000 ms y apagar 2000 ms, en bucle.
;
; Oscilador: INTOSC 8 MHz (config + OSCCON=0x72)
; Toolchain: MPASM/MPASMX en MPLAB X
;
        LIST    P=18F4550, F=INHX32
        RADIX   DEC
        #include <p18f4550.inc>

;==================== CONFIGURACION ====================
        CONFIG  FOSC = INTOSCIO_EC      ; Oscilador interno, RA6/RA7 I/O
        CONFIG  WDT  = OFF
        CONFIG  LVP  = OFF
        CONFIG  PBADEN = OFF            ; PORTB<4:0> digitales tras reset
        CONFIG  MCLRE = ON

;==================== VARIABLES ========================
        CBLOCK  0x20
COUNT1
COUNT2
COUNT3
        ENDC

;==================== RESEt ============================
        ORG     0x0000
        goto    START

; (No usamos interrupciones; vector a 0x0008 no necesario)
;=======================================================

START:
        ; Seleccionar 8 MHz en el oscilador interno:
        movlw   0x72                  ; IDLEN=0, IRCF=111(8MHz), SCS=10
        movwf   OSCCON

        ; Hacer todos los pines analogicos -> digitales
        movlw   0x0F
        movwf   ADCON1

        ; RB0 salida y en 0
        bcf     TRISB,0
        bcf     LATB,0

MAIN_LOOP:
        ; --- LED ON 5000 ms ---
        bsf     LATB,0
        movlw   5
        call    DELAY_SEC

        ; --- LED OFF 2000 ms ---
        bcf     LATB,0
        movlw   2
        call    DELAY_SEC

        goto    MAIN_LOOP

;==================== TEMPORIZADORES ===================
; DELAY_SEC: espera W segundos (aprox). Usa DELAY_1S.
DELAY_SEC:
        movwf   COUNT3
SEC_LOOP:
        call    DELAY_1S
        decfsz  COUNT3, f
        goto    SEC_LOOP
        return

; DELAY_1S: retardo aproximado de 1 segundo para Fosc=8MHz
; Ajusta los contadores si tu simulador/placa difiere.
DELAY_1S:
        movlw   250
        movwf   COUNT1
L1:
        movlw   250
        movwf   COUNT2
L2:
        nop
        nop
        decfsz  COUNT2, f
        goto    L2
        decfsz  COUNT1, f
        goto    L1
        return

        END
