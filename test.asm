# ==========================================================
#          MACROS (SIMPLE)
# ==========================================================
.macro do_syscall(%n)
	li $v0, %n
	syscall
.end_macro

.macro exit
	do_syscall(10)
.end_macro

.macro allocate_stack(%val)
	addi	$sp, $sp, %val
	sw	$ra, 0($sp)
.end_macro

.macro deallocate_stack(%val)
	lw	$ra, 0($sp)
	addi	$sp, $sp, %val
.end_macro

.macro print_integer(%label)
	move $a0, %label
	do_syscall(1)
.end_macro

.macro print_float(%label)
	lwc1 $f12, %label
	do_syscall(2)
.end_macro

.macro print_hex(%label)
	move $a0, %label
	do_syscall(34)
.end_macro

.macro print_newline
	la $a0, newline
	do_syscall(4)
.end_macro

.macro print_space
	la $a0, newspace
	do_syscall(4)
.end_macro

.macro print_tab
	la $a0, htab
	do_syscall(4)
.end_macro

.macro print_str(%label)
	la $a0, %label
	do_syscall(4)
.end_macro

.macro read_str(%label, %len)
	la $a0, %label
	li $a1, %len
	do_syscall(8)
.end_macro

.macro allocate_str(%label, %str)
	%label: .asciiz %str
.end_macro

.macro allocate_bytes(%label, %n)
	%label: .space %n
.end_macro

.macro read_int(%label)
	do_syscall(5)
	move %label, $v0
.end_macro

# ==========================================================
#          MACROS (LABORATORY)
# ==========================================================
.macro bf_increment
	lw	$t0, 0($s0)
	addi $t0, $t0, 1
	andi $t0, $t0, 0xFF
	sw	$t0, 0($s0)
.end_macro

.macro bf_decrement
	lw	$t0, 0($s0)
	addi $t0, $t0, -1
	andi $t0, $t0, 0xFF
	sw	$t0, 0($s0)
.end_macro

.macro bf_left
	# sub $t0, $s0, $s1
	# beqz $t0, bf_left_invalid
	addi $s0, $s0, -4
	bf_left_invalid:
.end_macro

.macro bf_right
	addi $s0, $s0, 4 
.end_macro

.macro bf_print
	lw	$a0, 0($s0)
	do_syscall(11)
.end_macro

.macro bf_read
	do_syscall(12)
	sw	$v0, 0($s0)
.end_macro

.macro bf_loop_start(%label)
	lw $t0, 0($s0)
	beqz $t0, %label
.end_macro

.macro bf_loop_end(%label)
	lw $t0, 0($s0)
	bnez $t0, %label
.end_macro

# ==========================================================
#          MAIN CODE
# ==========================================================
.text
la $s0, pointer
la $s1, pointer
bf_increment
bf_right
bf_increment
bf_increment
loop_0_start:
bf_loop_start(loop_0_end)
loop_1_start:
bf_loop_start(loop_1_end)
bf_right
bf_right
bf_read
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
loop_2_start:
bf_loop_start(loop_2_end)
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
loop_3_start:
bf_loop_start(loop_3_end)
bf_decrement
bf_left
bf_increment
bf_right
bf_loop_end(loop_3_start)
loop_3_end:
bf_loop_end(loop_2_start)
loop_2_end:
bf_left
bf_loop_end(loop_1_start)
loop_1_end:
bf_left
loop_4_start:
bf_loop_start(loop_4_end)
bf_left
bf_loop_end(loop_4_start)
loop_4_end:
bf_right
bf_right
bf_right
bf_right
loop_5_start:
bf_loop_start(loop_5_end)
bf_left
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
loop_6_start:
bf_loop_start(loop_6_end)
bf_decrement
bf_right
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_left
bf_loop_end(loop_6_start)
loop_6_end:
bf_left
loop_7_start:
bf_loop_start(loop_7_end)
bf_decrement
bf_right
bf_increment
bf_left
bf_loop_end(loop_7_start)
loop_7_end:
bf_left
loop_8_start:
bf_loop_start(loop_8_end)
bf_decrement
bf_right
bf_increment
bf_left
bf_loop_end(loop_8_start)
loop_8_end:
bf_right
bf_right
bf_right
bf_right
bf_loop_end(loop_5_start)
loop_5_end:
bf_left
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
loop_9_start:
bf_loop_start(loop_9_end)
bf_decrement
bf_left
bf_left
bf_increment
bf_right
bf_right
bf_loop_end(loop_9_start)
loop_9_end:
bf_left
bf_decrement
bf_loop_end(loop_0_start)
loop_0_end:
bf_left
bf_decrement
loop_10_start:
bf_loop_start(loop_10_end)
loop_11_start:
bf_loop_start(loop_11_end)
bf_decrement
bf_right
bf_increment
bf_left
loop_12_start:
bf_loop_start(loop_12_end)
bf_decrement
bf_right
bf_increment
bf_left
loop_13_start:
bf_loop_start(loop_13_end)
bf_decrement
bf_right
bf_increment
bf_left
loop_14_start:
bf_loop_start(loop_14_end)
bf_decrement
bf_right
bf_increment
bf_left
loop_15_start:
bf_loop_start(loop_15_end)
bf_decrement
bf_right
bf_increment
bf_left
loop_16_start:
bf_loop_start(loop_16_end)
bf_decrement
bf_right
bf_increment
bf_left
loop_17_start:
bf_loop_start(loop_17_end)
bf_decrement
bf_right
bf_increment
bf_left
loop_18_start:
bf_loop_start(loop_18_end)
bf_decrement
bf_right
bf_increment
bf_left
loop_19_start:
bf_loop_start(loop_19_end)
bf_decrement
bf_right
bf_increment
bf_left
loop_20_start:
bf_loop_start(loop_20_end)
bf_decrement
bf_right
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_decrement
bf_right
bf_increment
bf_left
bf_left
loop_21_start:
bf_loop_start(loop_21_end)
bf_decrement
bf_right
bf_right
bf_right
bf_increment
bf_left
bf_left
bf_left
bf_loop_end(loop_21_start)
loop_21_end:
bf_loop_end(loop_20_start)
loop_20_end:
bf_loop_end(loop_19_start)
loop_19_end:
bf_loop_end(loop_18_start)
loop_18_end:
bf_loop_end(loop_17_start)
loop_17_end:
bf_loop_end(loop_16_start)
loop_16_end:
bf_loop_end(loop_15_start)
loop_15_end:
bf_loop_end(loop_14_start)
loop_14_end:
bf_loop_end(loop_13_start)
loop_13_end:
bf_loop_end(loop_12_start)
loop_12_end:
bf_right
bf_right
bf_right
loop_22_start:
bf_loop_start(loop_22_end)
bf_decrement
bf_left
bf_left
bf_left
bf_increment
bf_right
bf_right
bf_right
bf_loop_end(loop_22_start)
loop_22_end:
bf_left
bf_left
bf_left
bf_loop_end(loop_11_start)
loop_11_end:
bf_right
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_increment
bf_right
bf_loop_end(loop_10_start)
loop_10_end:
bf_left
loop_23_start:
bf_loop_start(loop_23_end)
bf_print
bf_left
bf_left
bf_loop_end(loop_23_start)
loop_23_end:
# ==========================================================
#          DATA
# ==========================================================
.data
	prep: .word 0:4096
	pointer: .word 0:4096
	newline: .asciiz "\n"
	newspace: .asciiz " "
	htab: .asciiz "\t"
	