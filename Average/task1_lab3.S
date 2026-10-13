.thumb_func         @ Necessary because sdk uses BLX
.global main        @ Provide program starting address to linker

main:
    BL stdio_init_all    @ initialize uart or usb

loop:
    LDR R0, =my_array
    MOV R1, #8           @ 8 elements in the array
    BL average           @ Call the subroutine average, with parameters R0 and R1

    @Print string and average value
    MOV R1, R0           @ Move average value to printf parameter R1
    LDR R0, =message_str @ load address of helloworld string
    BL printf           @ Call pico_printf
    B loop              @ loop forever

@Subroutine average takes the parameters:
@R0 - Memory address to first element of integer array
@R1 - Number of integers in the array
@R0 - Return value (integer average value)

average:
	MOV R2, #0 @ vorher R4 genommen problem hauptprogramm erwartet laut regeln das R4 sich nciht ändert
	loop_av:
		LDR R3, [R0]
    	ADD R2, R2, R3
		ADD R0, R0, #4
		SUB R1, R1, #1
		BNE loop_av
	LSR R2, R2, #3
	MOV R0, R2
	BX LR

.data
    .align 4            @ necessary alignment
message_str: .asciz "Average value %d\n"

    .align 4            @ necessary alignment
my_array: .word 10, 20, 30, 40, 50, 60, 70, 80