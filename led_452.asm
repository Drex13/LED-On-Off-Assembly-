;
; led_452.asm - PIC18F452 (MPASM/MPASMX)
; LED en RB0: encender 5000 ms y apagar 2000 ms, en bucle.
;
; Oscilador: HS con cristal 8 MHz (ajusta si usas otro)
; Toolchain: MPASM/MPASMX en MPLAB X
;
        LIST    P=18F452, F=INHX32
        RADIX   DEC
        #include <p18f452.inc>

;==================== CONFIGURACION ====================
        CONFIG  OSC = HS
        CONFIG  WDT = OFF
        CONFIG  LVP = OFF
        CONFIG  PBADEN = OFF
        CONFIG  MCLRE = ON

;==================== VARIABLES ========================
        CBLOCK  0x20
COUNT1
COUNT2
COUNT3
        ENDC

;==================== RESET ============================
        ORG     0x0000
        goto    START

START:
        ; Poner entradas analogicas a digital
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
; Ajusta los contadores si tu cristal difiere.
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
