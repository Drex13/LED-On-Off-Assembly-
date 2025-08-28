CONFIG  FOSC = INTOSCIO_EC
    CONFIG  FCMEN = OFF
    CONFIG  IESO = OFF
    CONFIG  WDT = OFF
    CONFIG  PBADEN = OFF
    CONFIG  LVP = OFF

#include <xc.inc>

    PSECT resetVec, class=CODE, abs, delta=2
    ORG 0x0000
    GOTO Inicio

    PSECT udata_acs
ContadorExterno: DS 1
ContadorInterno: DS 1

    PSECT main_code, class=CODE, reloc=2
Inicio:
    MOVLW 0x72
    MOVWF OSCCON
    CLRF OSCTUNE
    MOVLW 0x0F
    MOVWF ADCON1
    MOVLW 0x07
    MOVWF CMCON
    CLRF TRISB
    BCF LATB,0

Loop:
    BSF LATB,0
    CALL Retardo_1s
    CALL Retardo_1s
    CALL Retardo_1s
    CALL Retardo_1s
    CALL Retardo_1s
    BCF LATB,0
    CALL Retardo_1s
    CALL Retardo_1s
    GOTO Loop

Retardo_1s:
    MOVLW 150
    MOVWF ContadorExterno
R1s_B0:
    CALL Delay_1ms
    DECFSZ ContadorExterno,F
    GOTO R1s_B0

    MOVLW 150
    MOVWF ContadorExterno
R1s_B1:
    CALL Delay_1ms
    DECFSZ ContadorExterno,F
    GOTO R1s_B1

    MOVLW 150
    MOVWF ContadorExterno
R1s_B2:
    CALL Delay_1ms
    DECFSZ ContadorExterno,F
    GOTO R1s_B2

    MOVLW 150
    MOVWF ContadorExterno
R1s_B3:
    CALL Delay_1ms
    DECFSZ ContadorExterno,F
    GOTO R1s_B3
    RETURN

Delay_1ms:
    MOVLW 225
    MOVWF ContadorInterno
D1ms_L1:
    NOP
    NOP
    DECFSZ ContadorInterno,F
    GOTO D1ms_L1

    MOVLW 225
    MOVWF ContadorInterno
D1ms_L2:
    NOP
    NOP
    DECFSZ ContadorInterno,F
    GOTO D1ms_L2

    NOP
    NOP
    RETURN

    END



