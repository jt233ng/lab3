.thumb
.thumb_func
.global main

.equ BTN_ON_PIN, 2
.equ BTN_OFF_PIN, 3
.equ LED1_PIN, 0
.equ LED2_PIN, 1
.equ GPIO_IN, 0
.equ GPIO_OUT, 1

main:
    @buttons
    mov r0, #BTN_ON_PIN
    bl link_gpio_init
    mov r0, #BTN_ON_PIN
    mov r1, #GPIO_IN
    bl link_gpio_set_dir
    mov r0, #BTN_ON_PIN
    bl link_gpio_pull_up


    mov r0, #BTN_OFF_PIN
    bl link_gpio_init
    mov r0, #BTN_OFF_PIN
    mov r1, #GPIO_IN
    bl link_gpio_set_dir
    mov r0, #BTN_OFF_PIN
    bl link_gpio_pull_up
   

    @LEDs
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

loop:
    mov r0, #BTN_ON_PIN       @ Pin from Button1
    bl link_gpio_get             @ Take the input 1
    mov r4, r0              @ r4 = button1 state safe the state

    mov r0, #BTN_OFF_PIN
    bl link_gpio_get
    mov r5, r0              @ r5 = button2 state

    cmp r4, #1
    bne Make_ON          @ make on  

    cmp r5, #1              @ Wir ergleichen auf 1 da Pull up        
    bne Make_off            @ make Off not equal 1 != 0 than jump

    b loop

Make_ON:
   
    mov r0, #LED2_PIN
    mov r1, #1
    bl link_gpio_put

    mov r0, #LED1_PIN
    mov r1, #1
    bl link_gpio_put

    b loop

Make_off:

    mov r0, #LED1_PIN
    mov r1, #0
    bl link_gpio_put

    mov r0, #LED2_PIN
    mov r1, #0
    bl link_gpio_put

    b loop
