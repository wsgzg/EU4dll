EXTERN	eventDialogProc1ReturnAddress	:	QWORD
EXTERN	eventDialogProc2ReturnAddress1	:	QWORD
EXTERN	eventDialogProc2ReturnAddress2	:	QWORD

ESCAPE_SEQ_1	=	10h
ESCAPE_SEQ_2	=	11h
ESCAPE_SEQ_3	=	12h
ESCAPE_SEQ_4	=	13h
LOW_SHIFT		=	0Eh
HIGH_SHIFT		=	9h
SHIFT_2			=	LOW_SHIFT
SHIFT_3			=	900h
SHIFT_4			=	8F2h
NO_FONT			=	98Fh
NOT_DEF			=	2026h

;temporary space for code point
.DATA
	eventDialogProc1Flag	DD	0

.CODE
eventDialogProc1 PROC
	cmp		byte ptr [rcx + rax], ESCAPE_SEQ_1;
	jz		JMP_A;
	cmp		byte ptr [rcx + rax], ESCAPE_SEQ_2;
	jz		JMP_B;
	cmp		byte ptr [rcx + rax], ESCAPE_SEQ_3;
	jz		JMP_C;
	cmp		byte ptr [rcx + rax], ESCAPE_SEQ_4;
	jz		JMP_D;

	mov		eventDialogProc1Flag, 0h;
	movzx	eax, byte ptr [rcx + rax];
	jmp		JMP_E;

JMP_A:
	movzx	eax, word ptr [rcx + rax + 1];
	jmp		JMP_G;

JMP_B:
	movzx	eax, word ptr [rcx + rax + 1];
	sub		eax, SHIFT_2;
	jmp		JMP_G;

JMP_C:
	movzx	eax, word ptr [rcx + rax + 1];
	add		eax, SHIFT_3;
	jmp		JMP_G;

JMP_D:
	movzx	eax, word ptr [rcx + rax + 1];
	add		eax, SHIFT_4;

JMP_G:
	movzx	eax, ax;
	cmp		eax, NO_FONT;
	ja		JMP_F;
	mov		eax, NOT_DEF;

JMP_F:
	mov		eventDialogProc1Flag, 1h;
	add		edi, 2;

JMP_E:
	mov		rsi, qword ptr [r10 + rax * 8];
	movss	xmm1, dword ptr [r10 + 848h];
	test	rsi, rsi;
	push	eventDialogProc1ReturnAddress;
	ret;
eventDialogProc1 ENDP

;-------------------------------------------;

eventDialogProc2 PROC
	cvtdq2ps	xmm0, xmm0;
	mulss		xmm0, xmm1;
	ucomiss		xmm0, xmm8;
	jp			JMP_A;
	jnz			JMP_A;
	cmp			eventDialogProc1Flag,1h;
	jz			JMP_A;

	push		eventDialogProc2ReturnAddress1;
	ret;

JMP_A:
	push		eventDialogProc2ReturnAddress2;
	ret;
eventDialogProc2 ENDP
END