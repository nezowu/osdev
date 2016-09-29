#generate 16-bit code
.code16

#hint the assembler that here is the executable code located
.text
.globl _start;
#boot code entry
_start:
      jmp _boot                           #jump to boot code
.func
Writestr:
	lea menu,	%si
1:
	lodsb
	orb	%al,	%al
	jz	1f
	movb	$0xe,	%ah
	int	$0x10

	mov	$0x86,	%ah
	mov	$0x1,	%cx
	int	$0x15

	jmp	1b
1:
	ret
.endfunc

     .macro mWriteString str              #macro which calls a function to print a string
          leaw  \str, %si
          call .writeStringIn
     .endm

     #function to print the string
     .writeStringIn:
          lodsb
          orb  %al, %al
          jz   .writeStringOut
          movb $0x0e, %ah
          int  $0x10

	mov	$0x86,	%ah
	mov	$0x2,	%cx
          jmp  .writeStringIn
     .writeStringOut:
     ret

welcome: .asciz "Hello, World\n\r"  #here we define the string
goodby: .asciz "Good By very little friedns\r\nreboot will over 5 seconds\r\n"
menu:	.asciz "choose level download:\r\n1 - nomal boot\r\n2 - fast reboot\r\n"
mistake:	.asciz "Mistake, try again\r\n"

_boot:
     mWriteString welcome
	mov $0x86,	%ah
	mov $0x10,	%cx
	int $0x15
	call Writestr

	mov	$0x00,	%ah
	int	$0x16

	cmp	$0x02,	%ah
	je	Exit

	cmp	$0x03,	%ah
	je	reboot

	lea	mistake,	%si
1:
	lodsb
	orb	%al,	%al
	jz	1f
	movb	$0xe,	%ah
	int	$0x10
	jmp	1b
1:
	mov	$0x86,	%ah
	mov	$0x30,	%cx
	int	$0x15

	jmp reboot

Exit:
	lea goodby,	%si
1:
	lodsb
	orb	%al,	%al
	jz	1f
	movb	$0xe,	%ah
	int	$0x10

	mov	$0x86,	%ah
	mov	$0x1,	%cx
	int	$0x15

	jmp	1b
1:
#	ret

	mov	$0x86,	%ah
	mov	$0x50,	%cx
	int	$0x15

reboot:
	ljmp	$0xffff, $0x0000

     #move to 510th byte from the start and append boot signature
     . = _start + 510
     .word 0xaa55
