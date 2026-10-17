.thumb
.thumb_func
.global main

.equ BTN_ON_PIN, 2
.equ BTN_OFF_PIN, 3
.equ LED1_PIN, 0
.equ LED2_PIN, 1

.equ GPIO_IN, 0
.equ GPIO_OUT, 1

.equ GPIO_OUT_SET, 0xd0000014 @Adressen diesmal direkt
.equ GPIO_OUT_CLR, 0xd0000018
.equ GPIO_IN_REG,  0xd0000004

main:
    @LEDs initalisieren
    mov r0, #LED1_PIN
    bl link_gpio_init
    mov r0, #LED1_PIN
    mov r1, #GPIO_OUT
    bl link_gpio_set_dir

    mov r0, #LED2_PIN
    bl link_gpio_init
    mov r0, #LED2_PIN
    mov r1, #GPIO_OUT
    bl link_gpio_set_dir

    @buttons
    mov r0, #BTN_ON_PIN
    bl link_gpio_init
    mov r0, #BTN_ON_PIN
    mov r1, #GPIO_IN
    bl link_gpio_set_dir
    mov r0, #BTN_ON_PIN
    bl link_gpio_pull_up @ pull up verwenden gedrückt dann 0

    mov r0, #BTN_OFF_PIN
    bl link_gpio_init
    mov r0, #BTN_OFF_PIN
    mov r1, #GPIO_IN
    bl link_gpio_set_dir
    mov r0, #BTN_OFF_PIN
    bl link_gpio_pull_up

loop:
    LDR R2, =GPIO_IN_REG @LAde alle eingänge hardware memory zugriff
    LDR R0, [R2]

    LSR R4, R0, #2 @2 Nach Rechts damit 2 an nullter stelle ist
    MOV R1, #1
    AND R4, R1 @Bitmaske mit flag set

    CMP R4, #1
    BNE Make_ON @Wenn nicht gleich dann spring

    @ Button GP3
    LSR R5, R0, #3
    MOV R1, #1
    AND R5, R1

    CMP R5, #1
    BNE Make_OFF

    B loop

Make_ON:
    mov r0, #LED1_PIN @ wenn on soll dann gehe weiter zu pin_on
    bl pin_on

    mov r0, #LED2_PIN
    bl pin_on

    b loop

Make_OFF:
    mov r0, #LED1_PIN
    bl pin_off

    mov r0, #LED2_PIN
    bl pin_off

    b loop


pin_on:
    ldr r2, =GPIO_OUT_SET @lade Hardwareadresse
    mov r1, #1
    lsl r1, r0 @Hier steht der LED Pin also wie viel nach links damit richtig pin aktiviert wird
    str r1, [r2] @schriebe werte aus R1 an die Hardware adresse r2
    bx lr @ Springe zurpck an die ahrdware adresse wo die subrotine gestartet ist


pin_off:
    ldr r2, =GPIO_OUT_CLR
    mov r1, #1
    lsl r1, r0
    str r1, [r2]
    bx lr
