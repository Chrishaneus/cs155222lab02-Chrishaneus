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
loop_0_start:
bf_loop_start(loop_0_end)
bf_decrement
bf_loop_end(loop_0_start)
loop_0_end:
# ==========================================================
#          DATA
# ==========================================================
.data
	prep: .word 0:128
	pointer: .word 0:2048
	newline: .asciiz "\n"
	newspace: .asciiz " "
	htab: .asciiz "\t"
	