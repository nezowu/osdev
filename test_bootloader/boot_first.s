.code16

.text
.globl _start;
#точка входа в программу
_start:
	jmp _boot #прыгаем на метку _boot: в код выполнения

welcome:	.asciz "Hello, World\n\r"  #here we define the string
goodby:		.asciz "This is normal level\r\nreboot will over 3 seconds\r\n"
menu:		.asciz "choose level download:\r\n1 - nomal boot\r\n2 - fast reboot\r\n"
mistake:	.asciz "Mistake, try again\r\nreboot now"

.macro mWait str
	mov $0x86,	%ah
	mov \str,	%cx
	int $0x15
.endm

.macro mWritestr str
	lea	\str,	%si
	call Writestr
.endm

.func
Writestr:
1:	lodsb
	orb	%al,	%al
	jz	1f
	movb	$0xe,	%ah
	int	$0x10

#	mWait $0x1
	mov $0x86,	%ah
	mov $0x0,	%cx
	mov $0x5000,	%dx
	int $0x15

	jmp	1b
1:	ret
.endfunc

_boot:
	mWritestr welcome
	mWait $0x5
	mWritestr menu

	mov	$0x00,	%ah
	int	$0x16

	cmp	$0x02,	%ah
	je	Exit

	cmp	$0x03,	%ah
	je	reboot

	mWritestr mistake	

	mWait $0x10
	jmp reboot

Exit:
	mWritestr goodby
	mWait $0x30

reboot:
	ljmp	$0xffff, $0x0000

#Заполняем оставшееся место до сигнатуры нулями
.fill	(510 - (. - _start)), 1, 0
.word 0xaa55
