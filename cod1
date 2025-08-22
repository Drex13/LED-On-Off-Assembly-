        LIST    P=18F4550
        INCLUDE <P18F4550.INC>
        CONFIG  OSC=HS, WDT=OFF, LVP=OFF

        ORG     00000000
        GOTO    MAIN
; PROGRAMA PRINCIPAL
MAIN:
        CLRF    LATC          ; limpiar LATC
        CLRF    TRISC         ; puerto C como salida

CICLO:
        BSF     LATC,0        ; enciende LED
        CALL    DELAY5S       ; retardo de 5 segundos
        BCF     LATC,0        ; apaga LED
        CALL    DELAY2S       ; retardo de 2 segundos
        GOTO    CICLO         ; repetir siempre
