; GENERATED FILE - do not edit. Run `make disassemble` instead.
; Linear baseline: code and embedded data are not separated yet.
; ROM image: tm1 @ $0000, tm2 @ $2000, tm3 @ $4000.

; z80dasm 1.2.0

	org 00000h
VIDEO_RAM:	equ 0xa400
WORK_RAM:	equ 0xa800
SPRITE_RAM_POSITION_CODE:	equ 0xb000
; Read/write meaning depends on bus direction.
SCANLINE_READ_SOUND_COMMAND_WRITE:	equ 0xc000
DSW2_READ_WATCHDOG_WRITE:	equ 0xc200
INPUT_SYSTEM:	equ 0xc300
LATCH_FLIP_SCREEN:	equ 0xc302
LATCH_SOUND_IRQ:	equ 0xc304
LATCH_VIDEO_ENABLE:	equ 0xc308
LATCH_COIN_COUNTER_1:	equ 0xc30a
LATCH_COIN_COUNTER_2:	equ 0xc30c
INPUT_PLAYER_1:	equ 0xc320
INPUT_PLAYER_2:	equ 0xc340
DSW1_READ:	equ 0xc360

; Z80 vectors
RESET_VECTOR:
	jp l07b1h		;0000	c3 b1 07	. . .
l0003h:
	rst 38h			;0003	ff		.
l0004h:
	rst 38h			;0004	ff		.
	rst 38h			;0005	ff		.
l0006h:
	inc sp			;0006	33		3
	ld c,e			;0007	4b		K
l0008h:
	add a,l			;0008	85		.
l0009h:
	ld l,a			;0009	6f		o
	jr nc,l000dh		;000a	30 01		0 .
	inc h			;000c	24		$
l000dh:
	ld a,(hl)		;000d	7e		~
	ret			;000e	c9		.
	ld c,a			;000f	4f		O
l0010h:
	add a,a			;0010	87		.
l0011h:
	rst 18h			;0011	df		.
	ld e,(hl)		;0012	5e		^
	inc hl			;0013	23		#
	ld d,(hl)		;0014	56		V
	inc hl			;0015	23		#
	ret			;0016	c9		.
	ld c,(hl)		;0017	4e		N
	add a,l			;0018	85		.
	ld l,a			;0019	6f		o
l001ah:
	ret nc			;001a	d0		.
	inc h			;001b	24		$
	ret			;001c	c9		.
	rst 38h			;001d	ff		.
	rst 38h			;001e	ff		.
l001fh:
	ld b,c			;001f	41		A
l0020h:
	ld a,e			;0020	7b		{
	sub 020h		;0021	d6 20		.  
	ld e,a			;0023	5f		_
	ret nc			;0024	d0		.
	dec d			;0025	15		.
	ret			;0026	c9		.
	ld c,l			;0027	4d		M
l0028h:
	ld a,e			;0028	7b		{
	add a,020h		;0029	c6 20		.  
	ld e,a			;002b	5f		_
	ret nc			;002c	d0		.
	inc d			;002d	14		.
	ret			;002e	c9		.
	ld c,c			;002f	49		I
	pop hl			;0030	e1		.
	rst 10h			;0031	d7		.
	ex de,hl		;0032	eb		.
	jp (hl)			;0033	e9		.
	rst 38h			;0034	ff		.
	rst 38h			;0035	ff		.
	rst 38h			;0036	ff		.
	rst 38h			;0037	ff		.
l0038h:
	push hl			;0038	e5		.
	ld h,0ach		;0039	26 ac		& .
	ld a,(0a9b2h)		;003b	3a b2 a9	: . .
	ld l,a			;003e	6f		o
	bit 7,(hl)		;003f	cb 7e		. ~
	jr z,l004dh		;0041	28 0a		( .
	ld (hl),d		;0043	72		r
	inc l			;0044	2c		,
	ld (hl),e		;0045	73		s
	inc l			;0046	2c		,
	ld a,l			;0047	7d		}
	and 03fh		;0048	e6 3f		. ?
	ld (0a9b2h),a		;004a	32 b2 a9	2 . .
l004dh:
	pop hl			;004d	e1		.
	ret			;004e	c9		.
	rrca			;004f	0f		.
l0050h:
	and a			;0050	a7		.
	ld de,077edh		;0051	11 ed 77	. . w
	ld l,b			;0054	68		h
	rst 10h			;0055	d7		.
l0056h:
	inc (hl)		;0056	34		4
	pop af			;0057	f1		.
l0058h:
	rst 10h			;0058	d7		.
	and l			;0059	a5		.
l005ah:
	dec sp			;005a	3b		;
	ld a,h			;005b	7c		|
l005ch:
	defb 0fdh,03bh,07dh ;illegal sequence	;005c	fd 3b 7d	. ; }
l005fh:
	pop af			;005f	f1		.
l0060h:
	call c,08ca5h		;0060	dc a5 8c	. . .
	ld d,a			;0063	57		W
	inc (hl)		;0064	34		4
	cp c			;0065	b9		.
NMI_VECTOR:
	jp l00d8h		;0066	c3 d8 00	. . .
sub_0069h:
	ld (DSW2_READ_WATCHDOG_WRITE),a	;0069	32 00 c2	2 . .
	ld hl,0b411h		;006c	21 11 b4	! . .
	ld b,030h		;006f	06 30		. 0
l0071h:
	ld (hl),000h		;0071	36 00		6 .
	inc hl			;0073	23		#
	djnz l0071h		;0074	10 fb		. .
	ld (DSW2_READ_WATCHDOG_WRITE),a	;0076	32 00 c2	2 . .
	ld hl,0b410h		;0079	21 10 b4	! . .
	ld b,030h		;007c	06 30		. 0
l007eh:
	ld (hl),000h		;007e	36 00		6 .
	inc hl			;0080	23		#
	djnz l007eh		;0081	10 fb		. .
	ld (DSW2_READ_WATCHDOG_WRITE),a	;0083	32 00 c2	2 . .
	ld hl,WORK_RAM		;0086	21 00 a8	! . .
l0089h:
	ld de,0a801h		;0089	11 01 a8	. . .
	ld bc,007ffh		;008c	01 ff 07	. . .
	ld (hl),000h		;008f	36 00		6 .
	ldir			;0091	ed b0		. .
	ld (DSW2_READ_WATCHDOG_WRITE),a	;0093	32 00 c2	2 . .
	ld b,000h		;0096	06 00		. .
	ld hl,l00d8h		;0098	21 d8 00	! . .
	xor a			;009b	af		.
l009ch:
	add a,(hl)		;009c	86		.
l009dh:
	inc hl			;009d	23		#
	djnz l009ch		;009e	10 fc		. .
l00a0h:
	sub 087h		;00a0	d6 87		. .
	call nz,l00d8h		;00a2	c4 d8 00	. . .
	jp l5866h		;00a5	c3 66 58	. f X
l00a8h:
	ld (INPUT_SYSTEM),a	;00a8	32 00 c3	2 . .
	ld (DSW2_READ_WATCHDOG_WRITE),a	;00ab	32 00 c2	2 . .
	jp l0b93h		;00ae	c3 93 0b	. . .
sub_00b1h:
	ld hl,0a420h		;00b1	21 20 a4	!   .
	ld c,00eh		;00b4	0e 0e		. .
l00b6h:
	ld de,l0020h		;00b6	11 20 00	.   .
	add hl,de		;00b9	19		.
	ld b,010h		;00ba	06 10		. .
l00bch:
	call sub_00c7h		;00bc	cd c7 00	. . .
	inc hl			;00bf	23		#
	inc hl			;00c0	23		#
	djnz l00bch		;00c1	10 f9		. .
	dec c			;00c3	0d		.
	jr nz,l00b6h		;00c4	20 f0		  .
	ret			;00c6	c9		.
sub_00c7h:
	push hl			;00c7	e5		.
	ld (hl),056h		;00c8	36 56		6 V
	inc hl			;00ca	23		#
	ld (hl),083h		;00cb	36 83		6 .
	ld de,l001fh		;00cd	11 1f 00	. . .
	add hl,de		;00d0	19		.
	ld (hl),0c7h		;00d1	36 c7		6 .
	inc hl			;00d3	23		#
	ld (hl),0efh		;00d4	36 ef		6 .
	pop hl			;00d6	e1		.
	ret			;00d7	c9		.
l00d8h:
	push af			;00d8	f5		.
l00d9h:
	push bc			;00d9	c5		.
	push de			;00da	d5		.
	push hl			;00db	e5		.
	ex af,af'		;00dc	08		.
	exx			;00dd	d9		.
	push af			;00de	f5		.
	push bc			;00df	c5		.
l00e0h:
	push de			;00e0	d5		.
	push hl			;00e1	e5		.
	push ix			;00e2	dd e5		. .
	push iy			;00e4	fd e5		. .
	call sub_0365h		;00e6	cd 65 03	. e .
	call sub_5286h		;00e9	cd 86 52	. . R
	xor a			;00ec	af		.
	ld (INPUT_SYSTEM),a	;00ed	32 00 c3	2 . .
	ld (DSW2_READ_WATCHDOG_WRITE),a	;00f0	32 00 c2	2 . .
	inc a			;00f3	3c		<
	ld (0a987h),a		;00f4	32 87 a9	2 . .
	ld a,(0ad32h)		;00f7	3a 32 ad	: 2 .
	and a			;00fa	a7		.
	jr z,l0106h		;00fb	28 09		( .
l00fdh:
	ld a,(0a9c2h)		;00fd	3a c2 a9	: . .
l0100h:
	and a			;0100	a7		.
l0101h:
	jr nz,l0106h		;0101	20 03		  .
l0103h:
	ld (0a987h),a		;0103	32 87 a9	2 . .
l0106h:
	ld a,(0a987h)		;0106	3a 87 a9	: . .
l0109h:
	ld (LATCH_FLIP_SCREEN),a	;0109	32 02 c3	2 . .
l010ch:
	ld a,(DSW2_READ_WATCHDOG_WRITE)	;010c	3a 00 c2	: . .
	cpl			;010f	2f		/
l0110h:
	ld (0a9adh),a		;0110	32 ad a9	2 . .
l0113h:
	ld a,(INPUT_SYSTEM)	;0113	3a 00 c3	: . .
l0116h:
	cpl			;0116	2f		/
l0117h:
	ld (0a9aeh),a		;0117	32 ae a9	2 . .
	ld a,(INPUT_PLAYER_1)	;011a	3a 20 c3	:   .
	cpl			;011d	2f		/
	ld (0a9afh),a		;011e	32 af a9	2 . .
	ld a,(INPUT_PLAYER_2)	;0121	3a 40 c3	: @ .
l0124h:
	cpl			;0124	2f		/
	ld (0a9b0h),a		;0125	32 b0 a9	2 . .
	ld a,(DSW1_READ)	;0128	3a 60 c3	: ` .
	cpl			;012b	2f		/
l012ch:
	ld (0a9b1h),a		;012c	32 b1 a9	2 . .
l012fh:
	ld hl,0a980h		;012f	21 80 a9	! . .
	inc (hl)		;0132	34		4
l0133h:
	ld hl,0a9ceh		;0133	21 ce a9	! . .
	ld a,(hl)		;0136	7e		~
	inc a			;0137	3c		<
l0138h:
	daa			;0138	27		'
	ld (hl),a		;0139	77		w
l013ah:
	ld hl,0a817h		;013a	21 17 a8	! . .
	ld a,(hl)		;013d	7e		~
l013eh:
	and a			;013e	a7		.
	jr z,l0142h		;013f	28 01		( .
	dec (hl)		;0141	35		5
l0142h:
	ld hl,0a812h		;0142	21 12 a8	! . .
l0145h:
	ld a,(hl)		;0145	7e		~
l0146h:
	and a			;0146	a7		.
l0147h:
	jr z,l014ah		;0147	28 01		( .
l0149h:
	dec (hl)		;0149	35		5
l014ah:
	ld hl,0a8f4h		;014a	21 f4 a8	! . .
	ld a,(hl)		;014d	7e		~
	and a			;014e	a7		.
	jr z,l0152h		;014f	28 01		( .
	dec (hl)		;0151	35		5
l0152h:
	call sub_48beh		;0152	cd be 48	. . H
	ld hl,l0174h		;0155	21 74 01	! t .
	push hl			;0158	e5		.
	ld a,(0a9abh)		;0159	3a ab a9	: . .
	and 003h		;015c	e6 03		. .
	rst 30h			;015e	f7		.
	jp nz,05115h		;015f	c2 15 51	. . Q
	ld d,0feh		;0162	16 fe		. .
	rla			;0164	17		.
	rra			;0165	1f		.
	rrca			;0166	0f		.
sub_0167h:
	ld l,a			;0167	6f		o
	and (hl)		;0168	a6		.
	inc d			;0169	14		.
	adc a,b			;016a	88		.
	ld d,a			;016b	57		W
	and l			;016c	a5		.
	cp a			;016d	bf		.
	inc (hl)		;016e	34		4
	rst 10h			;016f	d7		.
	pop af			;0170	f1		.
	sub (hl)		;0171	96		.
	pop af			;0172	f1		.
	cp c			;0173	b9		.
l0174h:
	call sub_55d4h		;0174	cd d4 55	. . U
	pop iy			;0177	fd e1		. .
	pop ix			;0179	dd e1		. .
	pop hl			;017b	e1		.
	pop de			;017c	d1		.
	pop bc			;017d	c1		.
	pop af			;017e	f1		.
l017fh:
	exx			;017f	d9		.
l0180h:
	ex af,af'		;0180	08		.
	pop hl			;0181	e1		.
	pop de			;0182	d1		.
	pop bc			;0183	c1		.
	ld a,(01600h)		;0184	3a 00 16	: . .
	ld (INPUT_SYSTEM),a	;0187	32 00 c3	2 . .
l018ah:
	pop af			;018a	f1		.
	ret			;018b	c9		.
sub_018ch:
	add a,a			;018c	87		.
	jr nc,l0190h		;018d	30 01		0 .
	inc h			;018f	24		$
l0190h:
	add a,l			;0190	85		.
	ld l,a			;0191	6f		o
	jr nc,l0195h		;0192	30 01		0 .
	inc h			;0194	24		$
l0195h:
	ld e,(hl)		;0195	5e		^
	inc hl			;0196	23		#
	ld d,(hl)		;0197	56		V
	inc hl			;0198	23		#
	ret			;0199	c9		.
sub_019ah:
	ld hl,VIDEO_RAM		;019a	21 00 a4	! . .
	ld (0a989h),hl		;019d	22 89 a9	" . .
	ld a,020h		;01a0	3e 20		>  
	ld (0a988h),a		;01a2	32 88 a9	2 . .
	ld b,0f0h		;01a5	06 f0		. .
	ld hl,l4ba5h		;01a7	21 a5 4b	! . K
	xor a			;01aa	af		.
l01abh:
	add a,(hl)		;01ab	86		.
	inc hl			;01ac	23		#
	djnz l01abh		;01ad	10 fc		. .
	sub 011h		;01af	d6 11		. .
	call nz,sub_0167h	;01b1	c4 67 01	. g .
	ret			;01b4	c9		.
sub_01b5h:
	ld hl,0a404h		;01b5	21 04 a4	! . .
	ld (0a989h),hl		;01b8	22 89 a9	" . .
	ld a,(l0ccdh)		;01bb	3a cd 0c	: . .
	ld (0a988h),a		;01be	32 88 a9	2 . .
	ret			;01c1	c9		.
sub_01c2h:
	ld hl,(0a989h)		;01c2	2a 89 a9	* . .
	ld b,020h		;01c5	06 20		.  
	ld de,l0020h		;01c7	11 20 00	.   .
l01cah:
	ld (hl),0f1h		;01ca	36 f1		6 .
	res 2,h			;01cc	cb 94		. .
	ld (hl),010h		;01ce	36 10		6 .
	set 2,h			;01d0	cb d4		. .
	add hl,de		;01d2	19		.
	djnz l01cah		;01d3	10 f5		. .
	ld hl,(0a989h)		;01d5	2a 89 a9	* . .
	inc hl			;01d8	23		#
	ld (0a989h),hl		;01d9	22 89 a9	" . .
	ld hl,0a988h		;01dc	21 88 a9	! . .
	dec (hl)		;01df	35		5
	ret			;01e0	c9		.
sub_01e1h:
	xor a			;01e1	af		.
	ld (0a9e2h),a		;01e2	32 e2 a9	2 . .
	ld hl,(l0d45h)		;01e5	2a 45 0d	* E .
	ld (0a9e3h),hl		;01e8	22 e3 a9	" . .
	ld hl,(0280ch)		;01eb	2a 0c 28	* . (
	ld (0a9e5h),hl		;01ee	22 e5 a9	" . .
l01f1h:
	ld b,000h		;01f1	06 00		. .
	ld hl,l0e33h		;01f3	21 33 0e	! 3 .
	xor a			;01f6	af		.
l01f7h:
	add a,(hl)		;01f7	86		.
	inc hl			;01f8	23		#
	djnz l01f7h		;01f9	10 fc		. .
	sub 0fdh		;01fb	d6 fd		. .
l01fdh:
	call nz,sub_0069h	;01fd	c4 69 00	. i .
	ret			;0200	c9		.
sub_0201h:
	call sub_026fh		;0201	cd 6f 02	. o .
	ld hl,(l32f3h+2)	;0204	2a f5 32	* . 2
	ld bc,(0a9e3h)		;0207	ed 4b e3 a9	. K . .
	and a			;020b	a7		.
	sbc hl,bc		;020c	ed 42		. B
	add hl,hl		;020e	29		)
	add hl,hl		;020f	29		)
	add hl,hl		;0210	29		)
	add hl,hl		;0211	29		)
	ld a,000h		;0212	3e 00		> .
	sbc a,000h		;0214	de 00		. .
	ld l,h			;0216	6c		l
	ld h,a			;0217	67		g
	ld (0a9e7h),hl		;0218	22 e7 a9	" . .
	ld hl,(00b45h)		;021b	2a 45 0b	* E .
	ld bc,(0a9e5h)		;021e	ed 4b e5 a9	. K . .
	and a			;0222	a7		.
	sbc hl,bc		;0223	ed 42		. B
	add hl,hl		;0225	29		)
	add hl,hl		;0226	29		)
	add hl,hl		;0227	29		)
	add hl,hl		;0228	29		)
	ld a,000h		;0229	3e 00		> .
	sbc a,000h		;022b	de 00		. .
	ld l,h			;022d	6c		l
	ld h,a			;022e	67		g
	ld (0a9e9h),hl		;022f	22 e9 a9	" . .
l0232h:
	ld hl,(0a9e3h)		;0232	2a e3 a9	* . .
	ld bc,(0a9e7h)		;0235	ed 4b e7 a9	. K . .
	add hl,bc		;0239	09		.
	ld (0a9e3h),hl		;023a	22 e3 a9	" . .
	ld hl,(0a9e5h)		;023d	2a e5 a9	* . .
	ld bc,(0a9e9h)		;0240	ed 4b e9 a9	. K . .
	add hl,bc		;0244	09		.
	ld (0a9e5h),hl		;0245	22 e5 a9	" . .
	call sub_026fh		;0248	cd 6f 02	. o .
	ld de,(014b2h)		;024b	ed 5b b2 14	. [ . .
	and a			;024f	a7		.
	sbc hl,de		;0250	ed 52		. R
	jp nz,l0232h		;0252	c2 32 02	. 2 .
	ld hl,0a9e2h		;0255	21 e2 a9	! . .
	inc (hl)		;0258	34		4
	ld a,(hl)		;0259	7e		~
	ld hl,l0290h		;025a	21 90 02	! . .
	rst 10h			;025d	d7		.
	ld hl,0a9e3h		;025e	21 e3 a9	! . .
	ld (hl),000h		;0261	36 00		6 .
	inc hl			;0263	23		#
	ld (hl),e		;0264	73		s
	ld hl,0a9e5h		;0265	21 e5 a9	! . .
	ld (hl),000h		;0268	36 00		6 .
	inc hl			;026a	23		#
	ld (hl),d		;026b	72		r
	ld a,e			;026c	7b		{
	and a			;026d	a7		.
	ret			;026e	c9		.
sub_026fh:
	ld a,(0a9e4h)		;026f	3a e4 a9	: . .
	add a,a			;0272	87		.
	add a,a			;0273	87		.
	add a,a			;0274	87		.
	ld l,a			;0275	6f		o
	ld h,000h		;0276	26 00		& .
	add hl,hl		;0278	29		)
	add hl,hl		;0279	29		)
	ld a,(0a9e6h)		;027a	3a e6 a9	: . .
	add a,l			;027d	85		.
	ld l,a			;027e	6f		o
	ld a,0a4h		;027f	3e a4		> .
	add a,h			;0281	84		.
	ld h,a			;0282	67		g
	ld a,(0ad0bh)		;0283	3a 0b ad	: . .
	ld (hl),a		;0286	77		w
	res 2,h			;0287	cb 94		. .
	ld a,(0ad0ch)		;0289	3a 0c ad	: . .
	ld (hl),a		;028c	77		w
	set 2,h			;028d	cb d4		. .
	ret			;028f	c9		.
l0290h:
	djnz l0296h		;0290	10 04		. .
	ld de,01204h		;0292	11 04 12	. . .
l0295h:
	inc b			;0295	04		.
l0296h:
	inc de			;0296	13		.
	inc b			;0297	04		.
	inc d			;0298	14		.
	inc b			;0299	04		.
	dec d			;029a	15		.
	inc b			;029b	04		.
	ld d,004h		;029c	16 04		. .
	rla			;029e	17		.
	inc b			;029f	04		.
	jr l02a6h		;02a0	18 04		. .
	add hl,de		;02a2	19		.
	inc b			;02a3	04		.
	ld a,(de)		;02a4	1a		.
	inc b			;02a5	04		.
l02a6h:
	dec de			;02a6	1b		.
	inc b			;02a7	04		.
	inc e			;02a8	1c		.
	inc b			;02a9	04		.
	dec e			;02aa	1d		.
	inc b			;02ab	04		.
	dec e			;02ac	1d		.
	dec b			;02ad	05		.
	dec e			;02ae	1d		.
	ld b,01dh		;02af	06 1d		. .
	rlca			;02b1	07		.
	dec e			;02b2	1d		.
	ex af,af'		;02b3	08		.
	dec e			;02b4	1d		.
	add hl,bc		;02b5	09		.
	dec e			;02b6	1d		.
	ld a,(bc)		;02b7	0a		.
	dec e			;02b8	1d		.
	dec bc			;02b9	0b		.
	dec e			;02ba	1d		.
	inc c			;02bb	0c		.
	dec e			;02bc	1d		.
	dec c			;02bd	0d		.
	dec e			;02be	1d		.
	ld c,01dh		;02bf	0e 1d		. .
	rrca			;02c1	0f		.
	dec e			;02c2	1d		.
	djnz $+31		;02c3	10 1d		. .
	ld de,l121dh		;02c5	11 1d 12	. . .
	dec e			;02c8	1d		.
	inc de			;02c9	13		.
	dec e			;02ca	1d		.
	inc d			;02cb	14		.
	dec e			;02cc	1d		.
	dec d			;02cd	15		.
	dec e			;02ce	1d		.
	ld d,01dh		;02cf	16 1d		. .
	rla			;02d1	17		.
	dec e			;02d2	1d		.
	jr $+31			;02d3	18 1d		. .
	add hl,de		;02d5	19		.
	dec e			;02d6	1d		.
	ld a,(de)		;02d7	1a		.
	dec e			;02d8	1d		.
	dec de			;02d9	1b		.
	dec e			;02da	1d		.
	inc e			;02db	1c		.
	dec e			;02dc	1d		.
	dec e			;02dd	1d		.
	dec e			;02de	1d		.
	ld e,01ch		;02df	1e 1c		. .
	ld e,01bh		;02e1	1e 1b		. .
	ld e,01ah		;02e3	1e 1a		. .
	ld e,019h		;02e5	1e 19		. .
	ld e,018h		;02e7	1e 18		. .
	ld e,017h		;02e9	1e 17		. .
	ld e,016h		;02eb	1e 16		. .
	ld e,015h		;02ed	1e 15		. .
	ld e,014h		;02ef	1e 14		. .
l02f1h:
	ld e,013h		;02f1	1e 13		. .
	ld e,012h		;02f3	1e 12		. .
	ld e,011h		;02f5	1e 11		. .
	ld e,010h		;02f7	1e 10		. .
	ld e,00fh		;02f9	1e 0f		. .
	ld e,00eh		;02fb	1e 0e		. .
	ld e,00dh		;02fd	1e 0d		. .
l02ffh:
	ld e,00ch		;02ff	1e 0c		. .
	ld e,00bh		;0301	1e 0b		. .
l0303h:
	ld e,00ah		;0303	1e 0a		. .
	ld e,009h		;0305	1e 09		. .
	ld e,008h		;0307	1e 08		. .
l0309h:
	ld e,007h		;0309	1e 07		. .
	ld e,006h		;030b	1e 06		. .
	ld e,005h		;030d	1e 05		. .
	ld e,004h		;030f	1e 04		. .
	ld e,003h		;0311	1e 03		. .
	ld e,002h		;0313	1e 02		. .
	ld e,002h		;0315	1e 02		. .
	dec e			;0317	1d		.
	ld (bc),a		;0318	02		.
	inc e			;0319	1c		.
	ld (bc),a		;031a	02		.
	dec de			;031b	1b		.
	ld (bc),a		;031c	02		.
	ld a,(de)		;031d	1a		.
	ld (bc),a		;031e	02		.
	add hl,de		;031f	19		.
	ld (bc),a		;0320	02		.
	jr l0325h		;0321	18 02		. .
	rla			;0323	17		.
	ld (bc),a		;0324	02		.
l0325h:
	ld d,002h		;0325	16 02		. .
	dec d			;0327	15		.
	ld (bc),a		;0328	02		.
	inc d			;0329	14		.
	ld (bc),a		;032a	02		.
	inc de			;032b	13		.
	ld (bc),a		;032c	02		.
	ld (de),a		;032d	12		.
	ld (bc),a		;032e	02		.
	ld de,l1002h		;032f	11 02 10	. . .
	ld (bc),a		;0332	02		.
	rrca			;0333	0f		.
	ld (bc),a		;0334	02		.
	ld c,002h		;0335	0e 02		. .
	dec c			;0337	0d		.
	ld (bc),a		;0338	02		.
	inc c			;0339	0c		.
	ld (bc),a		;033a	02		.
	dec bc			;033b	0b		.
	ld (bc),a		;033c	02		.
	ld a,(bc)		;033d	0a		.
	ld (bc),a		;033e	02		.
	add hl,bc		;033f	09		.
	ld (bc),a		;0340	02		.
	ex af,af'		;0341	08		.
	ld (bc),a		;0342	02		.
	rlca			;0343	07		.
	ld (bc),a		;0344	02		.
	ld b,002h		;0345	06 02		. .
	dec b			;0347	05		.
	ld (bc),a		;0348	02		.
	inc b			;0349	04		.
	inc bc			;034a	03		.
	inc b			;034b	04		.
	inc b			;034c	04		.
	inc b			;034d	04		.
	dec b			;034e	05		.
	inc b			;034f	04		.
	ld b,004h		;0350	06 04		. .
	rlca			;0352	07		.
	inc b			;0353	04		.
	ex af,af'		;0354	08		.
	inc b			;0355	04		.
	add hl,bc		;0356	09		.
	inc b			;0357	04		.
	ld a,(bc)		;0358	0a		.
	inc b			;0359	04		.
	dec bc			;035a	0b		.
	inc b			;035b	04		.
	inc c			;035c	0c		.
	inc b			;035d	04		.
	dec c			;035e	0d		.
	inc b			;035f	04		.
	ld c,004h		;0360	0e 04		. .
	rrca			;0362	0f		.
	inc b			;0363	04		.
	nop			;0364	00		.
sub_0365h:
	ld hl,0aa30h		;0365	21 30 aa	! 0 .
	ld de,0b010h		;0368	11 10 b0	. . .
l036bh:
	ld a,(0a987h)		;036b	3a 87 a9	: . .
	and a			;036e	a7		.
	jp z,l0556h		;036f	ca 56 05	. V .
	ldi			;0372	ed a0		. .
	ldi			;0374	ed a0		. .
	ldi			;0376	ed a0		. .
	ldi			;0378	ed a0		. .
	ldi			;037a	ed a0		. .
	ldi			;037c	ed a0		. .
	ld hl,0aa10h		;037e	21 10 aa	! . .
	ldi			;0381	ed a0		. .
	ldi			;0383	ed a0		. .
	ldi			;0385	ed a0		. .
	ldi			;0387	ed a0		. .
	ldi			;0389	ed a0		. .
	ldi			;038b	ed a0		. .
	ldi			;038d	ed a0		. .
	ldi			;038f	ed a0		. .
	ldi			;0391	ed a0		. .
	ldi			;0393	ed a0		. .
l0395h:
	ldi			;0395	ed a0		. .
	ldi			;0397	ed a0		. .
	ldi			;0399	ed a0		. .
	ldi			;039b	ed a0		. .
	ldi			;039d	ed a0		. .
	ldi			;039f	ed a0		. .
	ldi			;03a1	ed a0		. .
	ldi			;03a3	ed a0		. .
	ldi			;03a5	ed a0		. .
	ldi			;03a7	ed a0		. .
	ldi			;03a9	ed a0		. .
	ldi			;03ab	ed a0		. .
	ldi			;03ad	ed a0		. .
	ldi			;03af	ed a0		. .
	ldi			;03b1	ed a0		. .
	ldi			;03b3	ed a0		. .
	ldi			;03b5	ed a0		. .
	ldi			;03b7	ed a0		. .
	ldi			;03b9	ed a0		. .
	ldi			;03bb	ed a0		. .
	ldi			;03bd	ed a0		. .
	ldi			;03bf	ed a0		. .
	ld hl,0aa36h		;03c1	21 36 aa	! 6 .
	ldi			;03c4	ed a0		. .
	ldi			;03c6	ed a0		. .
	ldi			;03c8	ed a0		. .
	ldi			;03ca	ed a0		. .
	ldi			;03cc	ed a0		. .
	ldi			;03ce	ed a0		. .
	ldi			;03d0	ed a0		. .
	ldi			;03d2	ed a0		. .
	ldi			;03d4	ed a0		. .
	ldi			;03d6	ed a0		. .
	ld hl,0aa60h		;03d8	21 60 aa	! ` .
	ld de,0b410h		;03db	11 10 b4	. . .
	ldi			;03de	ed a0		. .
	ld a,(hl)		;03e0	7e		~
	add a,00eh		;03e1	c6 0e		. .
	cpl			;03e3	2f		/
	ld (de),a		;03e4	12		.
	inc l			;03e5	2c		,
	inc e			;03e6	1c		.
	ldi			;03e7	ed a0		. .
	ld a,(hl)		;03e9	7e		~
	add a,00eh		;03ea	c6 0e		. .
	cpl			;03ec	2f		/
	ld (de),a		;03ed	12		.
	inc l			;03ee	2c		,
	inc e			;03ef	1c		.
	ldi			;03f0	ed a0		. .
	ld a,(hl)		;03f2	7e		~
	add a,00eh		;03f3	c6 0e		. .
	cpl			;03f5	2f		/
	ld (de),a		;03f6	12		.
	inc l			;03f7	2c		,
	inc e			;03f8	1c		.
	ld hl,0aa40h		;03f9	21 40 aa	! @ .
	ldi			;03fc	ed a0		. .
	ld a,(hl)		;03fe	7e		~
	add a,00eh		;03ff	c6 0e		. .
l0401h:
	cpl			;0401	2f		/
l0402h:
	ld (de),a		;0402	12		.
	inc l			;0403	2c		,
	inc e			;0404	1c		.
	ldi			;0405	ed a0		. .
	ld a,(hl)		;0407	7e		~
	add a,00eh		;0408	c6 0e		. .
	cpl			;040a	2f		/
l040bh:
	ld (de),a		;040b	12		.
l040ch:
	inc l			;040c	2c		,
l040dh:
	inc e			;040d	1c		.
	ldi			;040e	ed a0		. .
	ld a,(hl)		;0410	7e		~
	add a,00eh		;0411	c6 0e		. .
	cpl			;0413	2f		/
	ld (de),a		;0414	12		.
	inc l			;0415	2c		,
	inc e			;0416	1c		.
	ldi			;0417	ed a0		. .
	ld a,(hl)		;0419	7e		~
	add a,00eh		;041a	c6 0e		. .
	cpl			;041c	2f		/
	ld (de),a		;041d	12		.
	inc l			;041e	2c		,
	inc e			;041f	1c		.
	ldi			;0420	ed a0		. .
	ld a,(hl)		;0422	7e		~
	add a,00eh		;0423	c6 0e		. .
	cpl			;0425	2f		/
	ld (de),a		;0426	12		.
	inc l			;0427	2c		,
	inc e			;0428	1c		.
	ldi			;0429	ed a0		. .
	ld a,(hl)		;042b	7e		~
	add a,00eh		;042c	c6 0e		. .
	cpl			;042e	2f		/
	ld (de),a		;042f	12		.
	inc l			;0430	2c		,
	inc e			;0431	1c		.
	ldi			;0432	ed a0		. .
	ld a,(hl)		;0434	7e		~
	add a,00eh		;0435	c6 0e		. .
	cpl			;0437	2f		/
	ld (de),a		;0438	12		.
	inc l			;0439	2c		,
	inc e			;043a	1c		.
	ldi			;043b	ed a0		. .
	ld a,(hl)		;043d	7e		~
	add a,00eh		;043e	c6 0e		. .
	cpl			;0440	2f		/
	ld (de),a		;0441	12		.
	inc l			;0442	2c		,
	inc e			;0443	1c		.
	ldi			;0444	ed a0		. .
	ld a,(hl)		;0446	7e		~
	add a,00eh		;0447	c6 0e		. .
	cpl			;0449	2f		/
	ld (de),a		;044a	12		.
	inc l			;044b	2c		,
	inc e			;044c	1c		.
	ldi			;044d	ed a0		. .
	ld a,(hl)		;044f	7e		~
	add a,00eh		;0450	c6 0e		. .
	cpl			;0452	2f		/
	ld (de),a		;0453	12		.
	inc l			;0454	2c		,
	inc e			;0455	1c		.
	ldi			;0456	ed a0		. .
	ld a,(hl)		;0458	7e		~
	add a,00eh		;0459	c6 0e		. .
	cpl			;045b	2f		/
	ld (de),a		;045c	12		.
	inc l			;045d	2c		,
	inc e			;045e	1c		.
	ldi			;045f	ed a0		. .
	ld a,(hl)		;0461	7e		~
	add a,00eh		;0462	c6 0e		. .
	cpl			;0464	2f		/
	ld (de),a		;0465	12		.
	inc l			;0466	2c		,
	inc e			;0467	1c		.
	ldi			;0468	ed a0		. .
	ld a,(hl)		;046a	7e		~
	add a,00eh		;046b	c6 0e		. .
	cpl			;046d	2f		/
	ld (de),a		;046e	12		.
	inc l			;046f	2c		,
	inc e			;0470	1c		.
	ldi			;0471	ed a0		. .
	ld a,(hl)		;0473	7e		~
	add a,00eh		;0474	c6 0e		. .
	cpl			;0476	2f		/
	ld (de),a		;0477	12		.
	inc l			;0478	2c		,
	inc e			;0479	1c		.
	ldi			;047a	ed a0		. .
	ld a,(hl)		;047c	7e		~
	add a,00eh		;047d	c6 0e		. .
	cpl			;047f	2f		/
	ld (de),a		;0480	12		.
	inc l			;0481	2c		,
	inc e			;0482	1c		.
	ldi			;0483	ed a0		. .
	ld a,(hl)		;0485	7e		~
	add a,00eh		;0486	c6 0e		. .
	cpl			;0488	2f		/
	ld (de),a		;0489	12		.
	inc l			;048a	2c		,
	inc e			;048b	1c		.
	ld hl,0aa66h		;048c	21 66 aa	! f .
	ldi			;048f	ed a0		. .
	ld a,(hl)		;0491	7e		~
	add a,00eh		;0492	c6 0e		. .
	cpl			;0494	2f		/
	ld (de),a		;0495	12		.
	inc l			;0496	2c		,
	inc e			;0497	1c		.
	ldi			;0498	ed a0		. .
	ld a,(hl)		;049a	7e		~
	add a,00eh		;049b	c6 0e		. .
	cpl			;049d	2f		/
	ld (de),a		;049e	12		.
	inc l			;049f	2c		,
	inc e			;04a0	1c		.
	ldi			;04a1	ed a0		. .
	ld a,(hl)		;04a3	7e		~
	add a,00eh		;04a4	c6 0e		. .
	cpl			;04a6	2f		/
	ld (de),a		;04a7	12		.
	inc l			;04a8	2c		,
	inc e			;04a9	1c		.
	ldi			;04aa	ed a0		. .
	ld a,(hl)		;04ac	7e		~
	add a,00eh		;04ad	c6 0e		. .
	cpl			;04af	2f		/
	ld (de),a		;04b0	12		.
	inc l			;04b1	2c		,
	inc e			;04b2	1c		.
	ldi			;04b3	ed a0		. .
	ld a,(hl)		;04b5	7e		~
	add a,00eh		;04b6	c6 0e		. .
	cpl			;04b8	2f		/
	ld (de),a		;04b9	12		.
	inc l			;04ba	2c		,
	inc e			;04bb	1c		.
l04bch:
	ld a,(0a9abh)		;04bc	3a ab a9	: . .
	cp 003h			;04bf	fe 03		. .
	ret nz			;04c1	c0		.
	ld a,(0a9ach)		;04c2	3a ac a9	: . .
	ld hl,l0831h+1		;04c5	21 32 08	! 2 .
	cp (hl)			;04c8	be		.
	ret c			;04c9	d8		.
	cp 008h			;04ca	fe 08		. .
	ret nc			;04cc	d0		.
	ld a,(0b411h)		;04cd	3a 11 b4	: . .
	add a,080h		;04d0	c6 80		. .
	jr c,l04deh		;04d2	38 0a		8 .
	ld (0b411h),a		;04d4	32 11 b4	2 . .
	ld hl,0b010h		;04d7	21 10 b0	! . .
	ld a,(hl)		;04da	7e		~
	add a,080h		;04db	c6 80		. .
	ld (hl),a		;04dd	77		w
l04deh:
	ld a,(0b413h)		;04de	3a 13 b4	: . .
	add a,080h		;04e1	c6 80		. .
	jr c,l04efh		;04e3	38 0a		8 .
	ld (0b413h),a		;04e5	32 13 b4	2 . .
	ld hl,0b012h		;04e8	21 12 b0	! . .
	ld a,(hl)		;04eb	7e		~
	add a,080h		;04ec	c6 80		. .
	ld (hl),a		;04ee	77		w
l04efh:
	ld a,(0b415h)		;04ef	3a 15 b4	: . .
	add a,080h		;04f2	c6 80		. .
	jr c,l0500h		;04f4	38 0a		8 .
	ld (0b415h),a		;04f6	32 15 b4	2 . .
	ld hl,0b014h		;04f9	21 14 b0	! . .
	ld a,(hl)		;04fc	7e		~
	add a,080h		;04fd	c6 80		. .
	ld (hl),a		;04ff	77		w
l0500h:
	ld a,(0b437h)		;0500	3a 37 b4	: 7 .
	add a,080h		;0503	c6 80		. .
	jr c,l0511h		;0505	38 0a		8 .
	ld (0b437h),a		;0507	32 37 b4	2 7 .
	ld hl,0b036h		;050a	21 36 b0	! 6 .
	ld a,(hl)		;050d	7e		~
	add a,080h		;050e	c6 80		. .
	ld (hl),a		;0510	77		w
l0511h:
	ld a,(0b439h)		;0511	3a 39 b4	: 9 .
	add a,080h		;0514	c6 80		. .
	jr c,l0522h		;0516	38 0a		8 .
	ld (0b439h),a		;0518	32 39 b4	2 9 .
	ld hl,0b038h		;051b	21 38 b0	! 8 .
	ld a,(hl)		;051e	7e		~
	add a,080h		;051f	c6 80		. .
	ld (hl),a		;0521	77		w
l0522h:
	ld a,(0b43bh)		;0522	3a 3b b4	: ; .
	add a,080h		;0525	c6 80		. .
	jr c,l0533h		;0527	38 0a		8 .
	ld (0b43bh),a		;0529	32 3b b4	2 ; .
	ld hl,0b03ah		;052c	21 3a b0	! : .
	ld a,(hl)		;052f	7e		~
	add a,080h		;0530	c6 80		. .
	ld (hl),a		;0532	77		w
l0533h:
	ld a,(0b43dh)		;0533	3a 3d b4	: = .
	add a,080h		;0536	c6 80		. .
	jr c,l0544h		;0538	38 0a		8 .
	ld (0b43dh),a		;053a	32 3d b4	2 = .
	ld hl,0b03ch		;053d	21 3c b0	! < .
	ld a,(hl)		;0540	7e		~
	add a,080h		;0541	c6 80		. .
	ld (hl),a		;0543	77		w
l0544h:
	ld a,(0b43fh)		;0544	3a 3f b4	: ? .
	add a,080h		;0547	c6 80		. .
	jr c,l0555h		;0549	38 0a		8 .
	ld (0b43fh),a		;054b	32 3f b4	2 ? .
	ld hl,0b03eh		;054e	21 3e b0	! > .
	ld a,(hl)		;0551	7e		~
	add a,080h		;0552	c6 80		. .
	ld (hl),a		;0554	77		w
l0555h:
	ret			;0555	c9		.
l0556h:
	ld a,(hl)		;0556	7e		~
	add a,00fh		;0557	c6 0f		. .
	cpl			;0559	2f		/
	ld (de),a		;055a	12		.
	inc l			;055b	2c		,
	inc e			;055c	1c		.
	ldi			;055d	ed a0		. .
	ld a,(hl)		;055f	7e		~
	add a,00fh		;0560	c6 0f		. .
	cpl			;0562	2f		/
	ld (de),a		;0563	12		.
	inc l			;0564	2c		,
	inc e			;0565	1c		.
	ldi			;0566	ed a0		. .
	ld a,(hl)		;0568	7e		~
	add a,00fh		;0569	c6 0f		. .
	cpl			;056b	2f		/
	ld (de),a		;056c	12		.
	inc l			;056d	2c		,
	inc e			;056e	1c		.
	ldi			;056f	ed a0		. .
	ld hl,0aa10h		;0571	21 10 aa	! . .
	ld a,(hl)		;0574	7e		~
	add a,00fh		;0575	c6 0f		. .
	cpl			;0577	2f		/
	ld (de),a		;0578	12		.
	inc l			;0579	2c		,
	inc e			;057a	1c		.
	ldi			;057b	ed a0		. .
	ld a,(hl)		;057d	7e		~
	add a,00fh		;057e	c6 0f		. .
	cpl			;0580	2f		/
	ld (de),a		;0581	12		.
	inc l			;0582	2c		,
	inc e			;0583	1c		.
	ldi			;0584	ed a0		. .
	ld a,(hl)		;0586	7e		~
	add a,00fh		;0587	c6 0f		. .
	cpl			;0589	2f		/
	ld (de),a		;058a	12		.
	inc l			;058b	2c		,
	inc e			;058c	1c		.
	ldi			;058d	ed a0		. .
	ld a,(hl)		;058f	7e		~
	add a,00fh		;0590	c6 0f		. .
	cpl			;0592	2f		/
	ld (de),a		;0593	12		.
	inc l			;0594	2c		,
	inc e			;0595	1c		.
	ldi			;0596	ed a0		. .
	ld a,(hl)		;0598	7e		~
	add a,00fh		;0599	c6 0f		. .
	cpl			;059b	2f		/
	ld (de),a		;059c	12		.
	inc l			;059d	2c		,
	inc e			;059e	1c		.
	ldi			;059f	ed a0		. .
	ld a,(hl)		;05a1	7e		~
	add a,00fh		;05a2	c6 0f		. .
	cpl			;05a4	2f		/
	ld (de),a		;05a5	12		.
	inc l			;05a6	2c		,
	inc e			;05a7	1c		.
	ldi			;05a8	ed a0		. .
	ld a,(hl)		;05aa	7e		~
	add a,00fh		;05ab	c6 0f		. .
	cpl			;05ad	2f		/
	ld (de),a		;05ae	12		.
	inc l			;05af	2c		,
	inc e			;05b0	1c		.
	ldi			;05b1	ed a0		. .
	ld a,(hl)		;05b3	7e		~
	add a,00fh		;05b4	c6 0f		. .
	cpl			;05b6	2f		/
	ld (de),a		;05b7	12		.
	inc l			;05b8	2c		,
	inc e			;05b9	1c		.
	ldi			;05ba	ed a0		. .
	ld a,(hl)		;05bc	7e		~
	add a,00fh		;05bd	c6 0f		. .
	cpl			;05bf	2f		/
	ld (de),a		;05c0	12		.
	inc l			;05c1	2c		,
	inc e			;05c2	1c		.
	ldi			;05c3	ed a0		. .
	ld a,(hl)		;05c5	7e		~
	add a,00fh		;05c6	c6 0f		. .
	cpl			;05c8	2f		/
	ld (de),a		;05c9	12		.
	inc l			;05ca	2c		,
	inc e			;05cb	1c		.
	ldi			;05cc	ed a0		. .
	ld a,(hl)		;05ce	7e		~
	add a,00fh		;05cf	c6 0f		. .
	cpl			;05d1	2f		/
	ld (de),a		;05d2	12		.
	inc l			;05d3	2c		,
	inc e			;05d4	1c		.
	ldi			;05d5	ed a0		. .
	ld a,(hl)		;05d7	7e		~
	add a,00fh		;05d8	c6 0f		. .
	cpl			;05da	2f		/
	ld (de),a		;05db	12		.
	inc l			;05dc	2c		,
	inc e			;05dd	1c		.
	ldi			;05de	ed a0		. .
	ld a,(hl)		;05e0	7e		~
	add a,00fh		;05e1	c6 0f		. .
	cpl			;05e3	2f		/
	ld (de),a		;05e4	12		.
	inc l			;05e5	2c		,
	inc e			;05e6	1c		.
	ldi			;05e7	ed a0		. .
	ld a,(hl)		;05e9	7e		~
	add a,00fh		;05ea	c6 0f		. .
	cpl			;05ec	2f		/
	ld (de),a		;05ed	12		.
	inc l			;05ee	2c		,
	inc e			;05ef	1c		.
	ldi			;05f0	ed a0		. .
	ld a,(hl)		;05f2	7e		~
	add a,00fh		;05f3	c6 0f		. .
	cpl			;05f5	2f		/
	ld (de),a		;05f6	12		.
	inc l			;05f7	2c		,
	inc e			;05f8	1c		.
	ldi			;05f9	ed a0		. .
	ld a,(hl)		;05fb	7e		~
	add a,00fh		;05fc	c6 0f		. .
	cpl			;05fe	2f		/
	ld (de),a		;05ff	12		.
	inc l			;0600	2c		,
l0601h:
	inc e			;0601	1c		.
	ldi			;0602	ed a0		. .
	ld hl,0aa36h		;0604	21 36 aa	! 6 .
	ld a,(hl)		;0607	7e		~
	add a,00fh		;0608	c6 0f		. .
	cpl			;060a	2f		/
	ld (de),a		;060b	12		.
	inc l			;060c	2c		,
	inc e			;060d	1c		.
	ldi			;060e	ed a0		. .
	ld a,(hl)		;0610	7e		~
	add a,00fh		;0611	c6 0f		. .
	cpl			;0613	2f		/
	ld (de),a		;0614	12		.
	inc l			;0615	2c		,
	inc e			;0616	1c		.
	ldi			;0617	ed a0		. .
	ld a,(hl)		;0619	7e		~
	add a,00fh		;061a	c6 0f		. .
	cpl			;061c	2f		/
	ld (de),a		;061d	12		.
	inc l			;061e	2c		,
	inc e			;061f	1c		.
	ldi			;0620	ed a0		. .
	ld a,(hl)		;0622	7e		~
	add a,00fh		;0623	c6 0f		. .
	cpl			;0625	2f		/
	ld (de),a		;0626	12		.
	inc l			;0627	2c		,
	inc e			;0628	1c		.
	ldi			;0629	ed a0		. .
	ld a,(hl)		;062b	7e		~
	add a,00fh		;062c	c6 0f		. .
	cpl			;062e	2f		/
	ld (de),a		;062f	12		.
	inc l			;0630	2c		,
	inc e			;0631	1c		.
	ldi			;0632	ed a0		. .
	ld hl,0aa60h		;0634	21 60 aa	! ` .
	ld de,0b410h		;0637	11 10 b4	. . .
	ld a,(hl)		;063a	7e		~
	xor 0c0h		;063b	ee c0		. .
	ld (de),a		;063d	12		.
	inc l			;063e	2c		,
	inc e			;063f	1c		.
	ld a,(hl)		;0640	7e		~
	inc a			;0641	3c		<
	ld (de),a		;0642	12		.
	inc l			;0643	2c		,
	inc e			;0644	1c		.
	ld a,(hl)		;0645	7e		~
	xor 0c0h		;0646	ee c0		. .
	ld (de),a		;0648	12		.
	inc l			;0649	2c		,
	inc e			;064a	1c		.
	ld a,(hl)		;064b	7e		~
	inc a			;064c	3c		<
	ld (de),a		;064d	12		.
	inc l			;064e	2c		,
	inc e			;064f	1c		.
	ld a,(hl)		;0650	7e		~
	xor 0c0h		;0651	ee c0		. .
	ld (de),a		;0653	12		.
	inc l			;0654	2c		,
	inc e			;0655	1c		.
	ld a,(hl)		;0656	7e		~
	inc a			;0657	3c		<
	ld (de),a		;0658	12		.
	inc l			;0659	2c		,
	inc e			;065a	1c		.
	ld hl,0aa40h		;065b	21 40 aa	! @ .
	ld a,(hl)		;065e	7e		~
	xor 0c0h		;065f	ee c0		. .
	ld (de),a		;0661	12		.
	inc l			;0662	2c		,
	inc e			;0663	1c		.
	ld a,(hl)		;0664	7e		~
	inc a			;0665	3c		<
	ld (de),a		;0666	12		.
	inc l			;0667	2c		,
	inc e			;0668	1c		.
	ld a,(hl)		;0669	7e		~
	xor 0c0h		;066a	ee c0		. .
	ld (de),a		;066c	12		.
	inc l			;066d	2c		,
	inc e			;066e	1c		.
	ld a,(hl)		;066f	7e		~
	inc a			;0670	3c		<
	ld (de),a		;0671	12		.
	inc l			;0672	2c		,
	inc e			;0673	1c		.
	ld a,(hl)		;0674	7e		~
	xor 0c0h		;0675	ee c0		. .
	ld (de),a		;0677	12		.
	inc l			;0678	2c		,
	inc e			;0679	1c		.
	ld a,(hl)		;067a	7e		~
	inc a			;067b	3c		<
	ld (de),a		;067c	12		.
	inc l			;067d	2c		,
	inc e			;067e	1c		.
	ld a,(hl)		;067f	7e		~
	xor 0c0h		;0680	ee c0		. .
	ld (de),a		;0682	12		.
	inc l			;0683	2c		,
	inc e			;0684	1c		.
	ld a,(hl)		;0685	7e		~
	inc a			;0686	3c		<
	ld (de),a		;0687	12		.
	inc l			;0688	2c		,
	inc e			;0689	1c		.
	ld a,(hl)		;068a	7e		~
	xor 0c0h		;068b	ee c0		. .
	ld (de),a		;068d	12		.
	inc l			;068e	2c		,
	inc e			;068f	1c		.
	ld a,(hl)		;0690	7e		~
	inc a			;0691	3c		<
	ld (de),a		;0692	12		.
	inc l			;0693	2c		,
	inc e			;0694	1c		.
	ld a,(hl)		;0695	7e		~
	xor 0c0h		;0696	ee c0		. .
	ld (de),a		;0698	12		.
	inc l			;0699	2c		,
	inc e			;069a	1c		.
	ld a,(hl)		;069b	7e		~
	inc a			;069c	3c		<
	ld (de),a		;069d	12		.
	inc l			;069e	2c		,
	inc e			;069f	1c		.
	ld a,(hl)		;06a0	7e		~
	xor 0c0h		;06a1	ee c0		. .
	ld (de),a		;06a3	12		.
	inc l			;06a4	2c		,
	inc e			;06a5	1c		.
	ld a,(hl)		;06a6	7e		~
	inc a			;06a7	3c		<
	ld (de),a		;06a8	12		.
	inc l			;06a9	2c		,
	inc e			;06aa	1c		.
	ld a,(hl)		;06ab	7e		~
	xor 0c0h		;06ac	ee c0		. .
	ld (de),a		;06ae	12		.
	inc l			;06af	2c		,
	inc e			;06b0	1c		.
	ld a,(hl)		;06b1	7e		~
	inc a			;06b2	3c		<
	ld (de),a		;06b3	12		.
	inc l			;06b4	2c		,
	inc e			;06b5	1c		.
	ld a,(hl)		;06b6	7e		~
	xor 0c0h		;06b7	ee c0		. .
	ld (de),a		;06b9	12		.
	inc l			;06ba	2c		,
	inc e			;06bb	1c		.
	ld a,(hl)		;06bc	7e		~
	inc a			;06bd	3c		<
	ld (de),a		;06be	12		.
	inc l			;06bf	2c		,
	inc e			;06c0	1c		.
	ld a,(hl)		;06c1	7e		~
	xor 0c0h		;06c2	ee c0		. .
	ld (de),a		;06c4	12		.
	inc l			;06c5	2c		,
	inc e			;06c6	1c		.
	ld a,(hl)		;06c7	7e		~
	inc a			;06c8	3c		<
	ld (de),a		;06c9	12		.
	inc l			;06ca	2c		,
	inc e			;06cb	1c		.
	ld a,(hl)		;06cc	7e		~
	xor 0c0h		;06cd	ee c0		. .
	ld (de),a		;06cf	12		.
	inc l			;06d0	2c		,
	inc e			;06d1	1c		.
	ld a,(hl)		;06d2	7e		~
	inc a			;06d3	3c		<
	ld (de),a		;06d4	12		.
	inc l			;06d5	2c		,
	inc e			;06d6	1c		.
	ld a,(hl)		;06d7	7e		~
	xor 0c0h		;06d8	ee c0		. .
	ld (de),a		;06da	12		.
	inc l			;06db	2c		,
	inc e			;06dc	1c		.
	ld a,(hl)		;06dd	7e		~
	inc a			;06de	3c		<
	ld (de),a		;06df	12		.
	inc l			;06e0	2c		,
	inc e			;06e1	1c		.
	ld a,(hl)		;06e2	7e		~
	xor 0c0h		;06e3	ee c0		. .
	ld (de),a		;06e5	12		.
	inc l			;06e6	2c		,
	inc e			;06e7	1c		.
	ld a,(hl)		;06e8	7e		~
	inc a			;06e9	3c		<
	ld (de),a		;06ea	12		.
	inc l			;06eb	2c		,
	inc e			;06ec	1c		.
	ld a,(hl)		;06ed	7e		~
	xor 0c0h		;06ee	ee c0		. .
	ld (de),a		;06f0	12		.
	inc l			;06f1	2c		,
	inc e			;06f2	1c		.
	ld a,(hl)		;06f3	7e		~
	inc a			;06f4	3c		<
	ld (de),a		;06f5	12		.
	inc l			;06f6	2c		,
	inc e			;06f7	1c		.
	ld a,(hl)		;06f8	7e		~
	xor 0c0h		;06f9	ee c0		. .
	ld (de),a		;06fb	12		.
	inc l			;06fc	2c		,
	inc e			;06fd	1c		.
	ld a,(hl)		;06fe	7e		~
	inc a			;06ff	3c		<
l0700h:
	ld (de),a		;0700	12		.
	inc l			;0701	2c		,
	inc e			;0702	1c		.
	ld a,(hl)		;0703	7e		~
	xor 0c0h		;0704	ee c0		. .
	ld (de),a		;0706	12		.
	inc l			;0707	2c		,
	inc e			;0708	1c		.
	ld a,(hl)		;0709	7e		~
	inc a			;070a	3c		<
	ld (de),a		;070b	12		.
	inc l			;070c	2c		,
	inc e			;070d	1c		.
	ld hl,0aa66h		;070e	21 66 aa	! f .
l0711h:
	ld a,(hl)		;0711	7e		~
	xor 0c0h		;0712	ee c0		. .
	ld (de),a		;0714	12		.
	inc l			;0715	2c		,
	inc e			;0716	1c		.
	ld a,(hl)		;0717	7e		~
	inc a			;0718	3c		<
	ld (de),a		;0719	12		.
	inc l			;071a	2c		,
	inc e			;071b	1c		.
	ld a,(hl)		;071c	7e		~
	xor 0c0h		;071d	ee c0		. .
	ld (de),a		;071f	12		.
	inc l			;0720	2c		,
	inc e			;0721	1c		.
	ld a,(hl)		;0722	7e		~
	inc a			;0723	3c		<
	ld (de),a		;0724	12		.
	inc l			;0725	2c		,
	inc e			;0726	1c		.
	ld a,(hl)		;0727	7e		~
	xor 0c0h		;0728	ee c0		. .
	ld (de),a		;072a	12		.
	inc l			;072b	2c		,
	inc e			;072c	1c		.
	ld a,(hl)		;072d	7e		~
	inc a			;072e	3c		<
	ld (de),a		;072f	12		.
	inc l			;0730	2c		,
	inc e			;0731	1c		.
	ld a,(hl)		;0732	7e		~
	xor 0c0h		;0733	ee c0		. .
	ld (de),a		;0735	12		.
	inc l			;0736	2c		,
	inc e			;0737	1c		.
	ld a,(hl)		;0738	7e		~
	inc a			;0739	3c		<
	ld (de),a		;073a	12		.
	inc l			;073b	2c		,
	inc e			;073c	1c		.
	ld a,(hl)		;073d	7e		~
	xor 0c0h		;073e	ee c0		. .
	ld (de),a		;0740	12		.
	inc l			;0741	2c		,
	inc e			;0742	1c		.
	ld a,(hl)		;0743	7e		~
	inc a			;0744	3c		<
	ld (de),a		;0745	12		.
	inc l			;0746	2c		,
	inc e			;0747	1c		.
	jp l04bch		;0748	c3 bc 04	. . .
	ld b,000h		;074b	06 00		. .
	ld hl,04aa0h		;074d	21 a0 4a	! . J
	xor a			;0750	af		.
l0751h:
	add a,(hl)		;0751	86		.
	inc hl			;0752	23		#
	djnz l0751h		;0753	10 fc		. .
	sub 0b8h		;0755	d6 b8		. .
	jp nz,l08fah		;0757	c2 fa 08	. . .
	ld a,(0ad0ch)		;075a	3a 0c ad	: . .
	cp 005h			;075d	fe 05		. .
	push af			;075f	f5		.
l0760h:
	ld a,005h		;0760	3e 05		> .
	ld (0ad0ch),a		;0762	32 0c ad	2 . .
	ld a,0f1h		;0765	3e f1		> .
	ld (0ad0bh),a		;0767	32 0b ad	2 . .
	call sub_01e1h		;076a	cd e1 01	. . .
	pop af			;076d	f1		.
	call z,sub_0f1ah	;076e	cc 1a 0f	. . .
	jp sub_0f1ah		;0771	c3 1a 0f	. . .
	ld b,000h		;0774	06 00		. .
	ld hl,l4c99h		;0776	21 99 4c	! . L
	sub a			;0779	97		.
l077ah:
	xor (hl)		;077a	ae		.
	inc hl			;077b	23		#
	djnz l077ah		;077c	10 fc		. .
	add a,095h		;077e	c6 95		. .
	call nz,sub_0f11h	;0780	c4 11 0f	. . .
	ld a,(0ad30h)		;0783	3a 30 ad	: 0 .
	and a			;0786	a7		.
	jr z,l07a0h		;0787	28 17		( .
	ld de,(0125bh)		;0789	ed 5b 5b 12	. [ [ .
	ld a,(0ad32h)		;078d	3a 32 ad	: 2 .
	and a			;0790	a7		.
	jr z,l0794h		;0791	28 01		( .
	inc e			;0793	1c		.
l0794h:
	rst 38h			;0794	ff		.
	ld a,(0ad0eh)		;0795	3a 0e ad	: . .
	and a			;0798	a7		.
	jr z,l07a0h		;0799	28 05		( .
l079bh:
	ld d,007h		;079b	16 07		. .
	rst 38h			;079d	ff		.
	jr l07a4h		;079e	18 04		. .
l07a0h:
	ld de,sub_0201h+1	;07a0	11 02 02	. . .
	rst 38h			;07a3	ff		.
l07a4h:
	call sub_0809h		;07a4	cd 09 08	. . .
	call sub_19f0h		;07a7	cd f0 19	. . .
	jp sub_0f1ah		;07aa	c3 1a 0f	. . .
l07adh:
	ld b,a			;07ad	47		G
	jp l5303h		;07ae	c3 03 53	. . S
l07b1h:
	ld a,(06000h)		;07b1	3a 00 60	: . `
	cp 055h			;07b4	fe 55		. U
	jp z,06000h		;07b6	ca 00 60	. . `
	ld sp,SPRITE_RAM_POSITION_CODE	;07b9	31 00 b0	1 . .
	ld (DSW2_READ_WATCHDOG_WRITE),a	;07bc	32 00 c2	2 . .
	ld hl,INPUT_SYSTEM	;07bf	21 00 c3	! . .
	ld b,008h		;07c2	06 08		. .
l07c4h:
	ld (hl),000h		;07c4	36 00		6 .
	inc hl			;07c6	23		#
	djnz l07c4h		;07c7	10 fb		. .
	ld a,(02d4bh)		;07c9	3a 4b 2d	: K -
	ld (LATCH_VIDEO_ENABLE),a	;07cc	32 08 c3	2 . .
	jp sub_0069h		;07cf	c3 69 00	. i .
sub_07d2h:
	ld hl,0a79fh		;07d2	21 9f a7	! . .
	ld de,0ffe0h		;07d5	11 e0 ff	. . .
l07d8h:
	ld b,00eh		;07d8	06 0e		. .
l07dah:
	ld (hl),0f1h		;07da	36 f1		6 .
	res 2,h			;07dc	cb 94		. .
	ld (hl),016h		;07de	36 16		6 .
	set 2,h			;07e0	cb d4		. .
	add hl,de		;07e2	19		.
	djnz l07dah		;07e3	10 f5		. .
	ret			;07e5	c9		.
	call sub_0b06h		;07e6	cd 06 0b	. . .
	call sub_0b39h		;07e9	cd 39 0b	. 9 .
	ld hl,0a61ch		;07ec	21 1c a6	! . .
	ld de,0abfeh		;07ef	11 fe ab	. . .
	call sub_1afch		;07f2	cd fc 1a	. . .
	ld a,(0a9aeh)		;07f5	3a ae a9	: . .
	bit 3,a			;07f8	cb 5f		. _
	jp nz,l3215h		;07fa	c2 15 32	. . 2
	ld a,(0a986h)		;07fd	3a 86 a9	: . .
l0800h:
	dec a			;0800	3d		=
	ret z			;0801	c8		.
l0802h:
	ld de,l0117h+2		;0802	11 19 01	. . .
	rst 38h			;0805	ff		.
	jp sub_0f1ah		;0806	c3 1a 0f	. . .
sub_0809h:
	ld a,(0ad04h)		;0809	3a 04 ad	: . .
	add a,a			;080c	87		.
	ld b,a			;080d	47		G
	add a,a			;080e	87		.
	add a,a			;080f	87		.
	add a,b			;0810	80		.
	ld hl,l087ch		;0811	21 7c 08	! | .
	rst 18h			;0814	df		.
	ld b,(hl)		;0815	46		F
	inc hl			;0816	23		#
	ld c,(hl)		;0817	4e		N
	inc hl			;0818	23		#
	ld a,(0ad02h)		;0819	3a 02 ad	: . .
	ld e,a			;081c	5f		_
	and 007h		;081d	e6 07		. .
	rst 8			;081f	cf		.
	ex af,af'		;0820	08		.
	ld a,e			;0821	7b		{
	ld hl,0a79fh		;0822	21 9f a7	! . .
	ld de,0ffe0h		;0825	11 e0 ff	. . .
	rrca			;0828	0f		.
	rrca			;0829	0f		.
	and 01fh		;082a	e6 1f		. .
	jr z,l0838h		;082c	28 0a		( .
l082eh:
	ld (hl),b		;082e	70		p
	add hl,de		;082f	19		.
	dec a			;0830	3d		=
l0831h:
	jr z,l0838h		;0831	28 05		( .
	ld (hl),c		;0833	71		q
	add hl,de		;0834	19		.
	dec a			;0835	3d		=
	jr nz,l082eh		;0836	20 f6		  .
l0838h:
	ex af,af'		;0838	08		.
	ld (hl),a		;0839	77		w
	add hl,de		;083a	19		.
	ld (hl),0f1h		;083b	36 f1		6 .
	ret			;083d	c9		.
	call sub_0b39h		;083e	cd 39 0b	. 9 .
	call sub_0b06h		;0841	cd 06 0b	. . .
	ld de,l0100h		;0844	11 00 01	. . .
	ld b,002h		;0847	06 02		. .
l0849h:
	rst 38h			;0849	ff		.
	inc e			;084a	1c		.
	djnz l0849h		;084b	10 fc		. .
	inc e			;084d	1c		.
	ld b,005h		;084e	06 05		. .
l0850h:
	rst 38h			;0850	ff		.
	inc e			;0851	1c		.
	djnz l0850h		;0852	10 fc		. .
	ld e,014h		;0854	1e 14		. .
l0856h:
	rst 38h			;0856	ff		.
	inc e			;0857	1c		.
	rst 38h			;0858	ff		.
	ld hl,0176ah		;0859	21 6a 17	! j .
	ld b,018h		;085c	06 18		. .
	xor a			;085e	af		.
l085fh:
	xor (hl)		;085f	ae		.
	inc l			;0860	2c		,
l0861h:
	djnz l085fh		;0861	10 fc		. .
	sub 0c9h		;0863	d6 c9		. .
	jp nz,l08fah		;0865	c2 fa 08	. . .
	jp sub_0f1ah		;0868	c3 1a 0f	. . .
l086bh:
	cp h			;086b	bc		.
	and (hl)		;086c	a6		.
l086dh:
	djnz l089fh		;086d	10 30		. 0
	pop af			;086f	f1		.
l0870h:
	ld a,h			;0870	7c		|
	ld l,b			;0871	68		h
	dec sp			;0872	3b		;
l0873h:
	and l			;0873	a5		.
l0874h:
	jr c,l0873h		;0874	38 fd		8 .
	pop af			;0876	f1		.
	sub (hl)		;0877	96		.
	ld e,l			;0878	5d		]
	rla			;0879	17		.
	sbc a,e			;087a	9b		.
	cp c			;087b	b9		.
l087ch:
	ld c,h			;087c	4c		L
	ld c,a			;087d	4f		O
	pop af			;087e	f1		.
	ld b,c			;087f	41		A
	ld (hl),d		;0880	72		r
	and (hl)		;0881	a6		.
	pop af			;0882	f1		.
	adc a,l			;0883	8d		.
	jp po,l37fbh		;0884	e2 fb 37	. . 7
	and a			;0887	a7		.
	pop af			;0888	f1		.
	xor e			;0889	ab		.
	ld sp,0f107h		;088a	31 07 f1	1 . .
	ld e,d			;088d	5a		Z
	ld (hl),l		;088e	75		u
	add a,l			;088f	85		.
	exx			;0890	d9		.
	dec de			;0891	1b		.
	pop af			;0892	f1		.
	pop bc			;0893	c1		.
	pop hl			;0894	e1		.
	jp m,0b3f1h		;0895	fa f1 b3	. . .
	and b			;0898	a0		.
	ld b,a			;0899	47		G
	ld a,e			;089a	7b		{
	ld a,b			;089b	78		x
	pop af			;089c	f1		.
	inc b			;089d	04		.
	dec b			;089e	05		.
l089fh:
	jp nz,0def1h		;089f	c2 f1 de	. . .
	ld sp,hl		;08a2	f9		.
	cp e			;08a3	bb		.
	sub e			;08a4	93		.
	xor h			;08a5	ac		.
	pop af			;08a6	f1		.
	ld (hl),006h		;08a7	36 06		6 .
	ld c,e			;08a9	4b		K
	pop af			;08aa	f1		.
	xor 0d3h		;08ab	ee d3		. .
	call nc,05e21h		;08ad	d4 21 5e	. ! ^
	inc sp			;08b0	33		3
	ld b,01eh		;08b1	06 1e		. .
	ret			;08b3	c9		.
	call sub_0201h		;08b4	cd 01 02	. . .
	ret nz			;08b7	c0		.
	ld b,000h		;08b8	06 00		. .
	ld hl,l4880h		;08ba	21 80 48	! . H
	sub a			;08bd	97		.
l08beh:
	xor (hl)		;08be	ae		.
	inc hl			;08bf	23		#
	djnz l08beh		;08c0	10 fc		. .
	add a,0d0h		;08c2	c6 d0		. .
	jp nz,l00d9h		;08c4	c2 d9 00	. . .
	ld de,l0113h		;08c7	11 13 01	. . .
	rst 38h			;08ca	ff		.
	ld e,000h		;08cb	1e 00		. .
	rst 38h			;08cd	ff		.
	ld e,014h		;08ce	1e 14		. .
	rst 38h			;08d0	ff		.
	inc e			;08d1	1c		.
	rst 38h			;08d2	ff		.
	ld e,00ch		;08d3	1e 0c		. .
	rst 38h			;08d5	ff		.
	call sub_4bdch		;08d6	cd dc 4b	. . K
	ld hl,0a995h		;08d9	21 95 a9	! . .
	xor a			;08dc	af		.
	ld b,005h		;08dd	06 05		. .
l08dfh:
	ld (hl),a		;08df	77		w
	inc hl			;08e0	23		#
	djnz l08dfh		;08e1	10 fc		. .
	ld (hl),003h		;08e3	36 03		6 .
	ld de,(0a993h)		;08e5	ed 5b 93 a9	. [ . .
	ld a,(0a999h)		;08e9	3a 99 a9	: . .
	ld hl,l12c7h		;08ec	21 c7 12	! . .
	rst 8			;08ef	cf		.
	ld (de),a		;08f0	12		.
	res 2,d			;08f1	cb 92		. .
	ld a,(de)		;08f3	1a		.
	ld (0a990h),a		;08f4	32 90 a9	2 . .
	jp sub_0f1ah		;08f7	c3 1a 0f	. . .
l08fah:
	ld c,e			;08fa	4b		K
	ld bc,l014ah		;08fb	01 4a 01	. J .
	ld c,c			;08fe	49		I
	ld bc,l0147h+1		;08ff	01 48 01	. H .
	ld b,a			;0902	47		G
	ld bc,l0146h		;0903	01 46 01	. F .
	ld b,l			;0906	45		E
	ld bc,00140h		;0907	01 40 01	. @ .
	ld a,001h		;090a	3e 01		> .
	inc a			;090c	3c		<
	ld bc,l013ah		;090d	01 3a 01	. : .
	jr c,$+3		;0910	38 01		8 .
	ld (l2f01h),a		;0912	32 01 2f	2 . /
	ld bc,l012ch+1		;0915	01 2d 01	. - .
	daa			;0918	27		'
	ld bc,l0124h		;0919	01 24 01	. $ .
	ld hl,l1e01h		;091c	21 01 1e	! . .
	ld bc,l0117h+1		;091f	01 18 01	. . .
	dec d			;0922	15		.
	ld bc,l0110h+2		;0923	01 12 01	. . .
	inc c			;0926	0c		.
	ld bc,l0109h		;0927	01 09 01	. . .
	ld b,001h		;092a	06 01		. .
	nop			;092c	00		.
	ld bc,l00fdh		;092d	01 fd 00	. . .
	jp m,0f700h		;0930	fa 00 f7	. . .
	nop			;0933	00		.
	pop af			;0934	f1		.
	nop			;0935	00		.
	xor 000h		;0936	ee 00		. .
	ex de,hl		;0938	eb		.
	nop			;0939	00		.
	push hl			;093a	e5		.
	nop			;093b	00		.
	jp po,0de00h		;093c	e2 00 de	. . .
	nop			;093f	00		.
	ret c			;0940	d8		.
	nop			;0941	00		.
	push de			;0942	d5		.
	nop			;0943	00		.
	pop de			;0944	d1		.
	nop			;0945	00		.
	jp z,0c600h		;0946	ca 00 c6	. . .
	nop			;0949	00		.
	jp 0bc00h		;094a	c3 00 bc	. . .
	nop			;094d	00		.
	or (hl)			;094e	b6		.
	nop			;094f	00		.
	xor (hl)		;0950	ae		.
	nop			;0951	00		.
	xor c			;0952	a9		.
	nop			;0953	00		.
	sbc a,a			;0954	9f		.
	nop			;0955	00		.
	sbc a,h			;0956	9c		.
	nop			;0957	00		.
	sub e			;0958	93		.
	nop			;0959	00		.
	adc a,d			;095a	8a		.
	nop			;095b	00		.
	add a,h			;095c	84		.
	nop			;095d	00		.
	ld a,e			;095e	7b		{
	nop			;095f	00		.
	ld (hl),c		;0960	71		q
	nop			;0961	00		.
	ld l,e			;0962	6b		k
	nop			;0963	00		.
	ld h,c			;0964	61		a
	nop			;0965	00		.
	ld d,a			;0966	57		W
	nop			;0967	00		.
	ld d,b			;0968	50		P
	nop			;0969	00		.
	ld b,l			;096a	45		E
	nop			;096b	00		.
	dec sp			;096c	3b		;
	nop			;096d	00		.
	inc (hl)		;096e	34		4
	nop			;096f	00		.
	add hl,hl		;0970	29		)
	nop			;0971	00		.
	ld e,000h		;0972	1e 00		. .
	inc de			;0974	13		.
	nop			;0975	00		.
	ex af,af'		;0976	08		.
	nop			;0977	00		.
	nop			;0978	00		.
	nop			;0979	00		.
	nop			;097a	00		.
	nop			;097b	00		.
	ret m			;097c	f8		.
	rst 38h			;097d	ff		.
	defb 0edh ;next byte illegal after ed	;097e	ed		.
	rst 38h			;097f	ff		.
	nop			;0980	00		.
	nop			;0981	00		.
	rst 10h			;0982	d7		.
	rst 38h			;0983	ff		.
	call z,0c5ffh		;0984	cc ff c5	. . .
	rst 38h			;0987	ff		.
	cp e			;0988	bb		.
	rst 38h			;0989	ff		.
l098ah:
	or b			;098a	b0		.
	rst 38h			;098b	ff		.
	xor c			;098c	a9		.
	rst 38h			;098d	ff		.
	sbc a,a			;098e	9f		.
	rst 38h			;098f	ff		.
	sub l			;0990	95		.
	rst 38h			;0991	ff		.
	adc a,a			;0992	8f		.
	rst 38h			;0993	ff		.
	add a,l			;0994	85		.
	rst 38h			;0995	ff		.
	ld a,h			;0996	7c		|
	rst 38h			;0997	ff		.
	halt			;0998	76		v
	rst 38h			;0999	ff		.
	ld l,l			;099a	6d		m
	rst 38h			;099b	ff		.
	ld h,h			;099c	64		d
	rst 38h			;099d	ff		.
	ld h,c			;099e	61		a
	rst 38h			;099f	ff		.
	ld h,h			;09a0	64		d
	rst 38h			;09a1	ff		.
	ld d,d			;09a2	52		R
	rst 38h			;09a3	ff		.
	ld c,d			;09a4	4a		J
	rst 38h			;09a5	ff		.
	ld b,h			;09a6	44		D
	rst 38h			;09a7	ff		.
	dec a			;09a8	3d		=
	rst 38h			;09a9	ff		.
	ld a,(l36ffh)		;09aa	3a ff 36	: . 6
	rst 38h			;09ad	ff		.
	cpl			;09ae	2f		/
	rst 38h			;09af	ff		.
	dec hl			;09b0	2b		+
	rst 38h			;09b1	ff		.
	jr z,$+1		;09b2	28 ff		( .
	ld (01effh),hl		;09b4	22 ff 1e	" . .
	rst 38h			;09b7	ff		.
	dec de			;09b8	1b		.
	rst 38h			;09b9	ff		.
	dec d			;09ba	15		.
	rst 38h			;09bb	ff		.
	ld (de),a		;09bc	12		.
	rst 38h			;09bd	ff		.
	rrca			;09be	0f		.
	rst 38h			;09bf	ff		.
	rrca			;09c0	0f		.
	rst 38h			;09c1	ff		.
	ld b,0ffh		;09c2	06 ff		. .
	inc bc			;09c4	03		.
	rst 38h			;09c5	ff		.
	nop			;09c6	00		.
	rst 38h			;09c7	ff		.
	jp m,0f7feh		;09c8	fa fe f7	. . .
	cp 0f4h			;09cb	fe f4		. .
	cp 0eeh			;09cd	fe ee		. .
	cp 0ebh			;09cf	fe eb		. .
	cp 0e8h			;09d1	fe e8		. .
	cp 0e2h			;09d3	fe e2		. .
	cp 0dfh			;09d5	fe df		. .
	cp 0dch			;09d7	fe dc		. .
	cp 0d9h			;09d9	fe d9		. .
	cp 0d3h			;09db	fe d3		. .
	cp 0d1h			;09dd	fe d1		. .
	cp 0ceh			;09df	fe ce		. .
	cp 0c8h			;09e1	fe c8		. .
	cp 0c6h			;09e3	fe c6		. .
	cp 0c4h			;09e5	fe c4		. .
	cp 0c2h			;09e7	fe c2		. .
	cp 0c0h			;09e9	fe c0		. .
	cp 0bbh			;09eb	fe bb		. .
	cp 0bah			;09ed	fe ba		. .
	cp 0b9h			;09ef	fe b9		. .
	cp 0b8h			;09f1	fe b8		. .
	cp 0b7h			;09f3	fe b7		. .
	cp 0b6h			;09f5	fe b6		. .
	cp 0b5h			;09f7	fe b5		. .
	cp 0b5h			;09f9	fe b5		. .
	cp 0b6h			;09fb	fe b6		. .
	cp 0b7h			;09fd	fe b7		. .
	cp 0b8h			;09ff	fe b8		. .
	cp 0b9h			;0a01	fe b9		. .
	cp 0bah			;0a03	fe ba		. .
	cp 0bbh			;0a05	fe bb		. .
	cp 0c0h			;0a07	fe c0		. .
	cp 0c2h			;0a09	fe c2		. .
l0a0bh:
	cp 0c4h			;0a0b	fe c4		. .
	cp 0c6h			;0a0d	fe c6		. .
	cp 0c8h			;0a0f	fe c8		. .
	cp 0ceh			;0a11	fe ce		. .
	cp 0d1h			;0a13	fe d1		. .
	cp 0d3h			;0a15	fe d3		. .
	cp 0d9h			;0a17	fe d9		. .
	cp 0dch			;0a19	fe dc		. .
	cp 0dfh			;0a1b	fe df		. .
	cp 0e2h			;0a1d	fe e2		. .
	cp 0e8h			;0a1f	fe e8		. .
	cp 0ebh			;0a21	fe eb		. .
	cp 0eeh			;0a23	fe ee		. .
	cp 0f4h			;0a25	fe f4		. .
	cp 0f7h			;0a27	fe f7		. .
	cp 0fah			;0a29	fe fa		. .
	cp 000h			;0a2b	fe 00		. .
	rst 38h			;0a2d	ff		.
	inc bc			;0a2e	03		.
	rst 38h			;0a2f	ff		.
	ld b,0ffh		;0a30	06 ff		. .
	add hl,bc		;0a32	09		.
	rst 38h			;0a33	ff		.
	rrca			;0a34	0f		.
	rst 38h			;0a35	ff		.
	ld (de),a		;0a36	12		.
	rst 38h			;0a37	ff		.
	dec d			;0a38	15		.
	rst 38h			;0a39	ff		.
	dec de			;0a3a	1b		.
	rst 38h			;0a3b	ff		.
	ld e,0ffh		;0a3c	1e ff		. .
	ld (sub_28feh+1),hl	;0a3e	22 ff 28	" . (
	rst 38h			;0a41	ff		.
	dec hl			;0a42	2b		+
	rst 38h			;0a43	ff		.
	cpl			;0a44	2f		/
	rst 38h			;0a45	ff		.
	ld (hl),0ffh		;0a46	36 ff		6 .
	ld a,(03dffh)		;0a48	3a ff 3d	: . =
l0a4bh:
	rst 38h			;0a4b	ff		.
	ld b,h			;0a4c	44		D
	rst 38h			;0a4d	ff		.
	ld c,d			;0a4e	4a		J
	rst 38h			;0a4f	ff		.
	ld d,d			;0a50	52		R
	rst 38h			;0a51	ff		.
	ld d,a			;0a52	57		W
	rst 38h			;0a53	ff		.
	ld h,c			;0a54	61		a
	rst 38h			;0a55	ff		.
	ld h,h			;0a56	64		d
	rst 38h			;0a57	ff		.
	ld l,l			;0a58	6d		m
	rst 38h			;0a59	ff		.
	halt			;0a5a	76		v
	rst 38h			;0a5b	ff		.
	ld a,h			;0a5c	7c		|
	rst 38h			;0a5d	ff		.
	add a,l			;0a5e	85		.
	rst 38h			;0a5f	ff		.
	adc a,a			;0a60	8f		.
	rst 38h			;0a61	ff		.
	sub l			;0a62	95		.
	rst 38h			;0a63	ff		.
	sbc a,a			;0a64	9f		.
	rst 38h			;0a65	ff		.
	xor c			;0a66	a9		.
	rst 38h			;0a67	ff		.
	or b			;0a68	b0		.
	rst 38h			;0a69	ff		.
	cp e			;0a6a	bb		.
	rst 38h			;0a6b	ff		.
	push bc			;0a6c	c5		.
	rst 38h			;0a6d	ff		.
	call z,0d7ffh		;0a6e	cc ff d7	. . .
	rst 38h			;0a71	ff		.
	jp po,0edffh		;0a72	e2 ff ed	. . .
	rst 38h			;0a75	ff		.
	ret m			;0a76	f8		.
	rst 38h			;0a77	ff		.
	nop			;0a78	00		.
	nop			;0a79	00		.
	nop			;0a7a	00		.
	nop			;0a7b	00		.
	ex af,af'		;0a7c	08		.
	nop			;0a7d	00		.
	inc de			;0a7e	13		.
	nop			;0a7f	00		.
	ld e,000h		;0a80	1e 00		. .
	add hl,hl		;0a82	29		)
	nop			;0a83	00		.
	inc (hl)		;0a84	34		4
	nop			;0a85	00		.
	dec sp			;0a86	3b		;
	nop			;0a87	00		.
	ld b,l			;0a88	45		E
	nop			;0a89	00		.
	ld d,b			;0a8a	50		P
	nop			;0a8b	00		.
	ld d,a			;0a8c	57		W
	nop			;0a8d	00		.
	ld h,c			;0a8e	61		a
	nop			;0a8f	00		.
	ld l,e			;0a90	6b		k
	nop			;0a91	00		.
	ld (hl),c		;0a92	71		q
	nop			;0a93	00		.
	ld a,e			;0a94	7b		{
	nop			;0a95	00		.
	add a,h			;0a96	84		.
	nop			;0a97	00		.
	adc a,d			;0a98	8a		.
	nop			;0a99	00		.
	sub e			;0a9a	93		.
	nop			;0a9b	00		.
l0a9ch:
	sbc a,h			;0a9c	9c		.
	nop			;0a9d	00		.
	sbc a,a			;0a9e	9f		.
	nop			;0a9f	00		.
	sbc a,a			;0aa0	9f		.
	nop			;0aa1	00		.
	xor (hl)		;0aa2	ae		.
	nop			;0aa3	00		.
	or (hl)			;0aa4	b6		.
	nop			;0aa5	00		.
	cp h			;0aa6	bc		.
	nop			;0aa7	00		.
	jp 0c600h		;0aa8	c3 00 c6	. . .
	nop			;0aab	00		.
	jp z,0d100h		;0aac	ca 00 d1	. . .
	nop			;0aaf	00		.
	push de			;0ab0	d5		.
	nop			;0ab1	00		.
	ret c			;0ab2	d8		.
	nop			;0ab3	00		.
	sbc a,000h		;0ab4	de 00		. .
l0ab6h:
	jp po,0e500h		;0ab6	e2 00 e5	. . .
	nop			;0ab9	00		.
	ex de,hl		;0aba	eb		.
	nop			;0abb	00		.
	xor 000h		;0abc	ee 00		. .
	pop af			;0abe	f1		.
	nop			;0abf	00		.
	xor 000h		;0ac0	ee 00		. .
	jp m,0fd00h		;0ac2	fa 00 fd	. . .
	nop			;0ac5	00		.
	nop			;0ac6	00		.
	ld bc,l0106h		;0ac7	01 06 01	. . .
	add hl,bc		;0aca	09		.
	ld bc,l010ch		;0acb	01 0c 01	. . .
	ld (de),a		;0ace	12		.
	ld bc,l0113h+2		;0acf	01 15 01	. . .
	jr $+3			;0ad2	18 01		. .
	ld e,001h		;0ad4	1e 01		. .
	ld hl,02401h		;0ad6	21 01 24	! . $
	ld bc,00127h		;0ad9	01 27 01	. ' .
	dec l			;0adc	2d		-
	ld bc,l012fh		;0add	01 2f 01	. / .
	daa			;0ae0	27		'
	ld bc,l0138h		;0ae1	01 38 01	. 8 .
	ld a,(l3c01h)		;0ae4	3a 01 3c	: . <
	ld bc,l013eh		;0ae7	01 3e 01	. > .
	ld b,b			;0aea	40		@
	ld bc,l0145h		;0aeb	01 45 01	. E .
	ld b,(hl)		;0aee	46		F
	ld bc,l0147h		;0aef	01 47 01	. G .
	ld c,b			;0af2	48		H
	ld bc,l0149h		;0af3	01 49 01	. I .
	ld c,d			;0af6	4a		J
	ld bc,l014ah+1		;0af7	01 4b 01	. K .
	ld (hl),a		;0afa	77		w
	and (hl)		;0afb	a6		.
	inc de			;0afc	13		.
	defb 0edh ;next byte illegal after ed	;0afd	ed		.
	call c,07da5h		;0afe	dc a5 7d	. . }
	inc (hl)		;0b01	34		4
	pop af			;0b02	f1		.
	pop af			;0b03	f1		.
	pop af			;0b04	f1		.
	cp c			;0b05	b9		.
sub_0b06h:
	ld iy,0aa10h		;0b06	fd 21 10 aa	. ! . .
	ld b,004h		;0b0a	06 04		. .
	ld c,004h		;0b0c	0e 04		. .
	ld d,0a0h		;0b0e	16 a0		. .
	ld e,0d8h		;0b10	1e d8		. .
l0b12h:
	ld (iy+031h),d		;0b12	fd 72 31	. r 1
	ld (iy+000h),e		;0b15	fd 73 00	. s .
	ld (iy+001h),c		;0b18	fd 71 01	. q .
	ld (iy+030h),06ch	;0b1b	fd 36 30 6c	. 6 0 l
	inc iy			;0b1f	fd 23		. #
	inc iy			;0b21	fd 23		. #
	inc c			;0b23	0c		.
	ld a,d			;0b24	7a		z
	sub 010h		;0b25	d6 10		. .
	ld d,a			;0b27	57		W
	djnz l0b12h		;0b28	10 e8		. .
	ret			;0b2a	c9		.
sub_0b2bh:
	ld hl,0aa41h		;0b2b	21 41 aa	! A .
	ld de,RESET_VECTOR+2	;0b2e	11 02 00	. . .
l0b31h:
	ld b,004h		;0b31	06 04		. .
	xor a			;0b33	af		.
l0b34h:
	ld (hl),a		;0b34	77		w
	add hl,de		;0b35	19		.
	djnz l0b34h		;0b36	10 fc		. .
	ret			;0b38	c9		.
sub_0b39h:
	ld a,(0a980h)		;0b39	3a 80 a9	: . .
	bit 0,a			;0b3c	cb 47		. G
	jr z,l0b46h		;0b3e	28 06		( .
	ld de,l0100h		;0b40	11 00 01	. . .
	jp l0038h		;0b43	c3 38 00	. 8 .
l0b46h:
	ld de,0011fh		;0b46	11 1f 01	. . .
	jp l0038h		;0b49	c3 38 00	. 8 .
sub_0b4ch:
	xor a			;0b4c	af		.
l0b4dh:
	add a,(hl)		;0b4d	86		.
	inc hl			;0b4e	23		#
	djnz l0b4dh		;0b4f	10 fc		. .
	cp c			;0b51	b9		.
	ret z			;0b52	c8		.
	ret			;0b53	c9		.
	xor a			;0b54	af		.
l0b55h:
	xor (hl)		;0b55	ae		.
	inc hl			;0b56	23		#
	djnz l0b55h		;0b57	10 fc		. .
	cp c			;0b59	b9		.
	ret z			;0b5a	c8		.
	jp RESET_VECTOR		;0b5b	c3 00 00	. . .
	xor a			;0b5e	af		.
l0b5fh:
	add a,(hl)		;0b5f	86		.
	inc hl			;0b60	23		#
	dec c			;0b61	0d		.
	jr z,l0b66h		;0b62	28 02		( .
	jr l0b5fh		;0b64	18 f9		. .
l0b66h:
	bit 0,a			;0b66	cb 47		. G
	ret z			;0b68	c8		.
	jp RESET_VECTOR		;0b69	c3 00 00	. . .
	ld hl,sub_0b06h		;0b6c	21 06 0b	! . .
	ld b,024h		;0b6f	06 24		. $
	ld c,000h		;0b71	0e 00		. .
l0b73h:
	ld a,(hl)		;0b73	7e		~
	sub c			;0b74	91		.
	inc hl			;0b75	23		#
	djnz l0b73h		;0b76	10 fb		. .
	ex de,hl		;0b78	eb		.
	cp (hl)			;0b79	be		.
	ret			;0b7a	c9		.
	rrca			;0b7b	0f		.
	and a			;0b7c	a7		.
	inc de			;0b7d	13		.
	adc a,b			;0b7e	88		.
	dec c			;0b7f	0d		.
	defb 0edh ;next byte illegal after ed	;0b80	ed		.
	call nz,0edf1h		;0b81	c4 f1 ed	. . .
	call c,0d7a5h		;0b84	dc a5 d7	. . .
	call c,08cf1h		;0b87	dc f1 8c	. . .
	dec c			;0b8a	0d		.
	call c,068dch		;0b8b	dc dc 68	. . h
	dec sp			;0b8e	3b		;
	cp c			;0b8f	b9		.
l0b90h:
	jp l0b93h		;0b90	c3 93 0b	. . .
l0b93h:
	ld h,0ach		;0b93	26 ac		& .
	ld a,(0a9b3h)		;0b95	3a b3 a9	: . .
	ld l,a			;0b98	6f		o
	ld a,(hl)		;0b99	7e		~
	rlca			;0b9a	07		.
	jp c,l0b90h		;0b9b	da 90 0b	. . .
	ld c,(hl)		;0b9e	4e		N
	ld (hl),0ffh		;0b9f	36 ff		6 .
	inc hl			;0ba1	23		#
	ld b,(hl)		;0ba2	46		F
	ld (hl),0ffh		;0ba3	36 ff		6 .
	inc hl			;0ba5	23		#
	ld a,l			;0ba6	7d		}
	and 03fh		;0ba7	e6 3f		. ?
	ld (0a9b3h),a		;0ba9	32 b3 a9	2 . .
	ld a,c			;0bac	79		y
	and 00fh		;0bad	e6 0f		. .
	ld hl,l0bbch		;0baf	21 bc 0b	! . .
	call sub_018ch		;0bb2	cd 8c 01	. . .
	ld a,b			;0bb5	78		x
	ld hl,l0b90h		;0bb6	21 90 0b	! . .
	push hl			;0bb9	e5		.
	ex de,hl		;0bba	eb		.
	jp (hl)			;0bbb	e9		.
l0bbch:
	defb 0ddh,00bh,0f2h ;illegal sequence	;0bbc	dd 0b f2	. . .
	dec bc			;0bbf	0b		.
	rrca			;0bc0	0f		.
	inc c			;0bc1	0c		.
	add hl,sp		;0bc2	39		9
	inc c			;0bc3	0c		.
	sub b			;0bc4	90		.
	inc c			;0bc5	0c		.
	ld (hl),d		;0bc6	72		r
	ld c,l			;0bc7	4d		M
	rst 10h			;0bc8	d7		.
	dec c			;0bc9	0d		.
	xor h			;0bca	ac		.
	ld c,0dch		;0bcb	0e dc		. .
	dec bc			;0bcd	0b		.
	call c,sub_210bh	;0bce	dc 0b 21	. . !
	inc (hl)		;0bd1	34		4
	inc hl			;0bd2	23		#
	inc c			;0bd3	0c		.
	call c,0dc0bh		;0bd4	dc 0b dc	. . .
	dec bc			;0bd7	0b		.
	call c,0dc0bh		;0bd8	dc 0b dc	. . .
	dec bc			;0bdb	0b		.
	ret			;0bdc	c9		.
l0bddh:
	ld hl,l0c50h		;0bdd	21 50 0c	! P .
	call sub_018ch		;0be0	cd 8c 01	. . .
	ex de,hl		;0be3	eb		.
	ld e,(hl)		;0be4	5e		^
	inc hl			;0be5	23		#
	ld d,(hl)		;0be6	56		V
	inc hl			;0be7	23		#
	inc hl			;0be8	23		#
l0be9h:
	ld a,(hl)		;0be9	7e		~
	cp 0b9h			;0bea	fe b9		. .
	ret z			;0bec	c8		.
	ld (de),a		;0bed	12		.
	inc hl			;0bee	23		#
	rst 20h			;0bef	e7		.
	jr l0be9h		;0bf0	18 f7		. .
sub_0bf2h:
	ld hl,l0c50h		;0bf2	21 50 0c	! P .
	call sub_018ch		;0bf5	cd 8c 01	. . .
	ex de,hl		;0bf8	eb		.
	ld e,(hl)		;0bf9	5e		^
	inc hl			;0bfa	23		#
	ld d,(hl)		;0bfb	56		V
	inc hl			;0bfc	23		#
	ld c,(hl)		;0bfd	4e		N
	inc hl			;0bfe	23		#
l0bffh:
	ld a,(hl)		;0bff	7e		~
	cp 0b9h			;0c00	fe b9		. .
	ret z			;0c02	c8		.
	ld (de),a		;0c03	12		.
	res 2,d			;0c04	cb 92		. .
	ld a,c			;0c06	79		y
	ld (de),a		;0c07	12		.
	set 2,d			;0c08	cb d2		. .
	inc hl			;0c0a	23		#
	rst 20h			;0c0b	e7		.
	jp l0bffh		;0c0c	c3 ff 0b	. . .
sub_0c0fh:
	ld hl,l0c50h		;0c0f	21 50 0c	! P .
	call sub_018ch		;0c12	cd 8c 01	. . .
	ex de,hl		;0c15	eb		.
	ld e,(hl)		;0c16	5e		^
	inc hl			;0c17	23		#
	ld d,(hl)		;0c18	56		V
	inc hl			;0c19	23		#
	inc hl			;0c1a	23		#
	ld a,(0ad0ch)		;0c1b	3a 0c ad	: . .
	and 00fh		;0c1e	e6 0f		. .
	ld c,a			;0c20	4f		O
	jr l0bffh		;0c21	18 dc		. .
	ld hl,l0c50h		;0c23	21 50 0c	! P .
	call sub_018ch		;0c26	cd 8c 01	. . .
	ex de,hl		;0c29	eb		.
	ld e,(hl)		;0c2a	5e		^
	inc hl			;0c2b	23		#
	ld d,(hl)		;0c2c	56		V
	inc hl			;0c2d	23		#
	inc hl			;0c2e	23		#
	ld a,(0ad0ch)		;0c2f	3a 0c ad	: . .
	add a,00ah		;0c32	c6 0a		. .
	and 00fh		;0c34	e6 0f		. .
	ld c,a			;0c36	4f		O
	jr l0bffh		;0c37	18 c6		. .
sub_0c39h:
	ld hl,l0c50h		;0c39	21 50 0c	! P .
	call sub_018ch		;0c3c	cd 8c 01	. . .
	ex de,hl		;0c3f	eb		.
	ld e,(hl)		;0c40	5e		^
	inc hl			;0c41	23		#
	ld d,(hl)		;0c42	56		V
	inc hl			;0c43	23		#
	inc hl			;0c44	23		#
l0c45h:
	ld a,(hl)		;0c45	7e		~
	cp 0b9h			;0c46	fe b9		. .
	ret z			;0c48	c8		.
	ld a,0f1h		;0c49	3e f1		> .
	ld (de),a		;0c4b	12		.
	inc hl			;0c4c	23		#
	rst 20h			;0c4d	e7		.
	jr l0c45h		;0c4e	18 f5		. .
l0c50h:
	ld l,e			;0c50	6b		k
	ex af,af'		;0c51	08		.
	ld (hl),e		;0c52	73		s
	ld d,07fh		;0c53	16 7f		. .
	jr nc,l0c74h		;0c55	30 1d		0 .
	ld e,b			;0c57	58		X
	jp m,0d649h		;0c58	fa 49 d6	. I .
l0c5bh:
	dec d			;0c5b	15		.
	ld c,h			;0c5c	4c		L
	ld e,b			;0c5d	58		X
	add hl,bc		;0c5e	09		.
	dec h			;0c5f	25		%
	jp z,06715h		;0c60	ca 15 67	. . g
	ld bc,l4e42h		;0c63	01 42 4e	. B N
	djnz l0c80h		;0c66	10 18		. .
	adc a,048h		;0c68	ce 48		. H
	and h			;0c6a	a4		.
	dec de			;0c6b	1b		.
	jp m,l310ah		;0c6c	fa 0a 31	. . 1
	inc h			;0c6f	24		$
	dec sp			;0c70	3b		;
	ld (de),a		;0c71	12		.
	sbc a,e			;0c72	9b		.
	ld b,l			;0c73	45		E
l0c74h:
	and h			;0c74	a4		.
	inc l			;0c75	2c		,
	ld c,a			;0c76	4f		O
	nop			;0c77	00		.
l0c78h:
	sbc a,(hl)		;0c78	9e		.
	ld sp,l296eh		;0c79	31 6e 29	1 n )
	ld a,e			;0c7c	7b		{
	dec bc			;0c7d	0b		.
	ld e,h			;0c7e	5c		\
	inc (hl)		;0c7f	34		4
l0c80h:
	jp nc,0483eh		;0c80	d2 3e 48	. > H
	inc sp			;0c83	33		3
	ld c,c			;0c84	49		I
	rrca			;0c85	0f		.
	inc d			;0c86	14		.
	ld c,h			;0c87	4c		L
	ld d,h			;0c88	54		T
	ld e,c			;0c89	59		Y
	defb 0edh ;next byte illegal after ed	;0c8a	ed		.
	ld d,l			;0c8b	55		U
	ret c			;0c8c	d8		.
	inc hl			;0c8d	23		#
	nop			;0c8e	00		.
	ld c,c			;0c8f	49		I
	ld c,a			;0c90	4f		O
	ld b,000h		;0c91	06 00		. .
	ld a,(0ad30h)		;0c93	3a 30 ad	: 0 .
	and a			;0c96	a7		.
	jp z,l0ce8h		;0c97	ca e8 0c	. . .
	ld a,c			;0c9a	79		y
	and a			;0c9b	a7		.
	jp z,l0ce9h		;0c9c	ca e9 0c	. . .
	ld hl,l0d27h		;0c9f	21 27 0d	! ' .
	add hl,bc		;0ca2	09		.
	add hl,bc		;0ca3	09		.
	add hl,bc		;0ca4	09		.
	ld de,0ad33h		;0ca5	11 33 ad	. 3 .
	ld a,(0ad32h)		;0ca8	3a 32 ad	: 2 .
	and a			;0cab	a7		.
	jr z,l0cb1h		;0cac	28 03		( .
	ld de,0ad36h		;0cae	11 36 ad	. 6 .
l0cb1h:
	ld a,(de)		;0cb1	1a		.
	add a,(hl)		;0cb2	86		.
	daa			;0cb3	27		'
	ld (de),a		;0cb4	12		.
	inc de			;0cb5	13		.
	inc hl			;0cb6	23		#
	ld a,(de)		;0cb7	1a		.
	adc a,(hl)		;0cb8	8e		.
	daa			;0cb9	27		'
	ld (de),a		;0cba	12		.
	inc de			;0cbb	13		.
	inc hl			;0cbc	23		#
	ld a,(de)		;0cbd	1a		.
	adc a,(hl)		;0cbe	8e		.
	daa			;0cbf	27		'
	ld (de),a		;0cc0	12		.
	ld hl,0a98dh		;0cc1	21 8d a9	! . .
	ld bc,l0003h		;0cc4	01 03 00	. . .
l0cc7h:
	ld a,(de)		;0cc7	1a		.
	cp (hl)			;0cc8	be		.
	jr c,l0cdah		;0cc9	38 0f		8 .
	jr nz,l0cd4h		;0ccb	20 07		  .
l0ccdh:
	dec de			;0ccd	1b		.
	dec hl			;0cce	2b		+
	dec c			;0ccf	0d		.
	jr nz,l0cc7h		;0cd0	20 f5		  .
	jr l0cdah		;0cd2	18 06		. .
l0cd4h:
	ex de,hl		;0cd4	eb		.
	lddr			;0cd5	ed b8		. .
	call sub_0d6bh		;0cd7	cd 6b 0d	. k .
l0cdah:
	ld a,(0ad32h)		;0cda	3a 32 ad	: 2 .
	and a			;0cdd	a7		.
	jr nz,l0ce5h		;0cde	20 05		  .
	call sub_0d57h		;0ce0	cd 57 0d	. W .
	jr l0ce8h		;0ce3	18 03		. .
l0ce5h:
	call sub_0d61h		;0ce5	cd 61 0d	. a .
l0ce8h:
	ret			;0ce8	c9		.
l0ce9h:
	ld a,(0ad31h)		;0ce9	3a 31 ad	: 1 .
	and a			;0cec	a7		.
	jr nz,l0d0ah		;0ced	20 1b		  .
	ld a,(l0b31h)		;0cef	3a 31 0b	: 1 .
	call sub_0bf2h		;0cf2	cd f2 0b	. . .
	call sub_0d57h		;0cf5	cd 57 0d	. W .
	ld a,(015c6h)		;0cf8	3a c6 15	: . .
	call sub_0c39h		;0cfb	cd 39 0c	. 9 .
	ld de,0a501h		;0cfe	11 01 a5	. . .
	ld b,006h		;0d01	06 06		. .
l0d03h:
	ld a,0f1h		;0d03	3e f1		> .
	ld (de),a		;0d05	12		.
	rst 20h			;0d06	e7		.
	djnz l0d03h		;0d07	10 fa		. .
	ret			;0d09	c9		.
l0d0ah:
	ld a,006h		;0d0a	3e 06		> .
	call sub_0bf2h		;0d0c	cd f2 0b	. . .
	call sub_0d57h		;0d0f	cd 57 0d	. W .
	ld a,007h		;0d12	3e 07		> .
	call sub_0bf2h		;0d14	cd f2 0b	. . .
	call sub_0d61h		;0d17	cd 61 0d	. a .
	ret			;0d1a	c9		.
l0d1bh:
	inc a			;0d1b	3c		<
	and d			;0d1c	a2		.
	rst 0			;0d1d	c7		.
	xor h			;0d1e	ac		.
	ld a,h			;0d1f	7c		|
	and d			;0d20	a2		.
	ld b,e			;0d21	43		C
	xor e			;0d22	ab		.
	call m,0bea1h		;0d23	fc a1 be	. . .
	xor h			;0d26	ac		.
l0d27h:
	nop			;0d27	00		.
	nop			;0d28	00		.
	nop			;0d29	00		.
	nop			;0d2a	00		.
	ld bc,RESET_VECTOR	;0d2b	01 00 00	. . .
	ld (bc),a		;0d2e	02		.
	nop			;0d2f	00		.
	nop			;0d30	00		.
	inc bc			;0d31	03		.
	nop			;0d32	00		.
	nop			;0d33	00		.
	inc b			;0d34	04		.
	nop			;0d35	00		.
	nop			;0d36	00		.
	dec b			;0d37	05		.
	nop			;0d38	00		.
	nop			;0d39	00		.
	ld b,000h		;0d3a	06 00		. .
	nop			;0d3c	00		.
	rlca			;0d3d	07		.
	nop			;0d3e	00		.
	nop			;0d3f	00		.
	ex af,af'		;0d40	08		.
	nop			;0d41	00		.
	nop			;0d42	00		.
	add hl,bc		;0d43	09		.
	nop			;0d44	00		.
l0d45h:
	nop			;0d45	00		.
l0d46h:
	djnz l0d48h		;0d46	10 00		. .
l0d48h:
	nop			;0d48	00		.
	dec d			;0d49	15		.
	nop			;0d4a	00		.
	nop			;0d4b	00		.
	jr nz,l0d4eh		;0d4c	20 00		  .
l0d4eh:
	nop			;0d4e	00		.
	jr nc,l0d51h		;0d4f	30 00		0 .
l0d51h:
	nop			;0d51	00		.
	ld b,b			;0d52	40		@
	nop			;0d53	00		.
	nop			;0d54	00		.
	ld d,b			;0d55	50		P
	nop			;0d56	00		.
sub_0d57h:
	ld de,0a781h		;0d57	11 81 a7	. . .
	ld hl,0ad35h		;0d5a	21 35 ad	! 5 .
	ld c,010h		;0d5d	0e 10		. .
	jr l0d73h		;0d5f	18 12		. .
sub_0d61h:
	ld de,0a501h		;0d61	11 01 a5	. . .
	ld hl,0ad38h		;0d64	21 38 ad	! 8 .
	ld c,010h		;0d67	0e 10		. .
	jr l0d73h		;0d69	18 08		. .
sub_0d6bh:
	ld de,0a641h		;0d6b	11 41 a6	. A .
	ld hl,0a98dh		;0d6e	21 8d a9	! . .
	ld c,010h		;0d71	0e 10		. .
l0d73h:
	ld b,000h		;0d73	06 00		. .
	call sub_0da0h		;0d75	cd a0 0d	. . .
	dec hl			;0d78	2b		+
	call sub_0da0h		;0d79	cd a0 0d	. . .
	dec hl			;0d7c	2b		+
	call sub_0d81h		;0d7d	cd 81 0d	. . .
	ret			;0d80	c9		.
sub_0d81h:
	ld a,(hl)		;0d81	7e		~
	rrca			;0d82	0f		.
	rrca			;0d83	0f		.
	rrca			;0d84	0f		.
	rrca			;0d85	0f		.
	call sub_0d90h		;0d86	cd 90 0d	. . .
	rst 20h			;0d89	e7		.
	ld a,(hl)		;0d8a	7e		~
	call sub_0d90h		;0d8b	cd 90 0d	. . .
	rst 20h			;0d8e	e7		.
	ret			;0d8f	c9		.
sub_0d90h:
	and 00fh		;0d90	e6 0f		. .
	push hl			;0d92	e5		.
	ld hl,l0dcch		;0d93	21 cc 0d	! . .
	rst 8			;0d96	cf		.
	pop hl			;0d97	e1		.
	ld (de),a		;0d98	12		.
	res 2,d			;0d99	cb 92		. .
	ld a,c			;0d9b	79		y
	ld (de),a		;0d9c	12		.
	set 2,d			;0d9d	cb d2		. .
	ret			;0d9f	c9		.
sub_0da0h:
	ld a,(hl)		;0da0	7e		~
	rrca			;0da1	0f		.
	rrca			;0da2	0f		.
	rrca			;0da3	0f		.
	rrca			;0da4	0f		.
	call sub_0dafh		;0da5	cd af 0d	. . .
	rst 20h			;0da8	e7		.
	ld a,(hl)		;0da9	7e		~
	call sub_0dafh		;0daa	cd af 0d	. . .
	rst 20h			;0dad	e7		.
	ret			;0dae	c9		.
sub_0dafh:
	and 00fh		;0daf	e6 0f		. .
	jr z,l0db6h		;0db1	28 03		( .
	inc b			;0db3	04		.
	jr l0dbeh		;0db4	18 08		. .
l0db6h:
	ld a,(03246h)		;0db6	3a 46 32	: F 2
	inc b			;0db9	04		.
	dec b			;0dba	05		.
	jr z,l0dbeh		;0dbb	28 01		( .
	xor a			;0dbd	af		.
l0dbeh:
	push hl			;0dbe	e5		.
	ld hl,l0dcch		;0dbf	21 cc 0d	! . .
	rst 8			;0dc2	cf		.
	pop hl			;0dc3	e1		.
	ld (de),a		;0dc4	12		.
	res 2,d			;0dc5	cb 92		. .
	ld a,c			;0dc7	79		y
	ld (de),a		;0dc8	12		.
	set 2,d			;0dc9	cb d2		. .
	ret			;0dcb	c9		.
l0dcch:
	inc de			;0dcc	13		.
	sub (hl)		;0dcd	96		.
	sbc a,e			;0dce	9b		.
	call 07ff3h		;0dcf	cd f3 7f	. . .
	ld h,l			;0dd2	65		e
	ld (bc),a		;0dd3	02		.
	rla			;0dd4	17		.
	ld e,l			;0dd5	5d		]
	pop af			;0dd6	f1		.
	ld de,0a463h		;0dd7	11 63 a4	. c .
	cp 064h			;0dda	fe 64		. d
	jr c,l0de0h		;0ddc	38 02		8 .
	ld a,063h		;0dde	3e 63		> c
l0de0h:
	exx			;0de0	d9		.
	ld b,000h		;0de1	06 00		. .
l0de3h:
	sub 01eh		;0de3	d6 1e		. .
	jr c,l0deah		;0de5	38 03		8 .
	inc b			;0de7	04		.
	jr l0de3h		;0de8	18 f9		. .
l0deah:
	add a,01eh		;0dea	c6 1e		. .
	ld c,000h		;0dec	0e 00		. .
l0deeh:
	sub 00ah		;0dee	d6 0a		. .
	jr c,l0df5h		;0df0	38 03		8 .
	inc c			;0df2	0c		.
	jr l0deeh		;0df3	18 f9		. .
l0df5h:
	add a,00ah		;0df5	c6 0a		. .
	ld d,000h		;0df7	16 00		. .
l0df9h:
	sub 005h		;0df9	d6 05		. .
	jr c,l0e00h		;0dfb	38 03		8 .
	inc d			;0dfd	14		.
	jr l0df9h		;0dfe	18 f9		. .
l0e00h:
	add a,005h		;0e00	c6 05		. .
	ld e,a			;0e02	5f		_
	exx			;0e03	d9		.
	exx			;0e04	d9		.
	ld a,e			;0e05	7b		{
	exx			;0e06	d9		.
	and a			;0e07	a7		.
	jr z,l0e16h		;0e08	28 0c		( .
	ld b,001h		;0e0a	06 01		. .
	ld c,013h		;0e0c	0e 13		. .
l0e0eh:
	ex af,af'		;0e0e	08		.
	call sub_0e8dh		;0e0f	cd 8d 0e	. . .
	ex af,af'		;0e12	08		.
	dec a			;0e13	3d		=
	jr nz,l0e0eh		;0e14	20 f8		  .
l0e16h:
	exx			;0e16	d9		.
	ld a,d			;0e17	7a		z
	exx			;0e18	d9		.
	and a			;0e19	a7		.
	jr z,l0e28h		;0e1a	28 0c		( .
	ld b,032h		;0e1c	06 32		. 2
	ld c,011h		;0e1e	0e 11		. .
l0e20h:
	ex af,af'		;0e20	08		.
	call sub_0e9ch		;0e21	cd 9c 0e	. . .
	ex af,af'		;0e24	08		.
	dec a			;0e25	3d		=
	jr nz,l0e20h		;0e26	20 f8		  .
l0e28h:
	exx			;0e28	d9		.
	ld a,c			;0e29	79		y
	exx			;0e2a	d9		.
	and a			;0e2b	a7		.
	jr z,l0e3ah		;0e2c	28 0c		( .
	ld b,0ceh		;0e2e	06 ce		. .
	ld c,016h		;0e30	0e 16		. .
l0e32h:
	ex af,af'		;0e32	08		.
l0e33h:
	call sub_0e70h		;0e33	cd 70 0e	. p .
	ex af,af'		;0e36	08		.
	dec a			;0e37	3d		=
	jr nz,l0e32h		;0e38	20 f8		  .
l0e3ah:
	exx			;0e3a	d9		.
	ld a,b			;0e3b	78		x
	exx			;0e3c	d9		.
	and a			;0e3d	a7		.
	jr z,l0e4ch		;0e3e	28 0c		( .
	ld b,023h		;0e40	06 23		. #
	ld c,011h		;0e42	0e 11		. .
l0e44h:
	ex af,af'		;0e44	08		.
	call sub_0e70h		;0e45	cd 70 0e	. p .
	ex af,af'		;0e48	08		.
	dec a			;0e49	3d		=
	jr nz,l0e44h		;0e4a	20 f8		  .
l0e4ch:
	ld bc,0f110h		;0e4c	01 10 f1	. . .
l0e4fh:
	ld hl,l59ddh		;0e4f	21 dd 59	! . Y
	add hl,de		;0e52	19		.
	jr c,l0e5ah		;0e53	38 05		8 .
	call sub_0e8dh		;0e55	cd 8d 0e	. . .
	jr l0e4fh		;0e58	18 f5		. .
l0e5ah:
	xor a			;0e5a	af		.
	ld hl,(l00a0h)		;0e5b	2a a0 00	* . .
	ld de,(000a3h)		;0e5e	ed 5b a3 00	. [ . .
	ld bc,(l009dh)		;0e62	ed 4b 9d 00	. K . .
	add hl,de		;0e66	19		.
	add hl,bc		;0e67	09		.
	add a,l			;0e68	85		.
	add a,h			;0e69	84		.
	sub 069h		;0e6a	d6 69		. i
	jp nz,RESET_VECTOR	;0e6c	c2 00 00	. . .
	ret			;0e6f	c9		.
sub_0e70h:
	ld a,b			;0e70	78		x
	inc a			;0e71	3c		<
	ld (de),a		;0e72	12		.
	dec a			;0e73	3d		=
	dec de			;0e74	1b		.
	ld (de),a		;0e75	12		.
	rst 28h			;0e76	ef		.
	ld a,b			;0e77	78		x
	add a,002h		;0e78	c6 02		. .
	ld (de),a		;0e7a	12		.
	inc a			;0e7b	3c		<
	inc de			;0e7c	13		.
	ld (de),a		;0e7d	12		.
	ld hl,0fc00h		;0e7e	21 00 fc	! . .
	add hl,de		;0e81	19		.
	rst 28h			;0e82	ef		.
	ld (hl),c		;0e83	71		q
	dec hl			;0e84	2b		+
	ld (hl),c		;0e85	71		q
	ex de,hl		;0e86	eb		.
	rst 20h			;0e87	e7		.
	ex de,hl		;0e88	eb		.
	ld (hl),c		;0e89	71		q
	inc hl			;0e8a	23		#
	ld (hl),c		;0e8b	71		q
	ret			;0e8c	c9		.
sub_0e8dh:
	ex de,hl		;0e8d	eb		.
	ld (hl),b		;0e8e	70		p
	dec hl			;0e8f	2b		+
	ld (hl),0f1h		;0e90	36 f1		6 .
	res 2,h			;0e92	cb 94		. .
	ld (hl),c		;0e94	71		q
	inc hl			;0e95	23		#
	ld (hl),c		;0e96	71		q
	set 2,h			;0e97	cb d4		. .
	ex de,hl		;0e99	eb		.
	rst 28h			;0e9a	ef		.
	ret			;0e9b	c9		.
sub_0e9ch:
	ex de,hl		;0e9c	eb		.
	inc b			;0e9d	04		.
	ld (hl),b		;0e9e	70		p
	dec b			;0e9f	05		.
	dec hl			;0ea0	2b		+
	ld (hl),b		;0ea1	70		p
	res 2,h			;0ea2	cb 94		. .
	ld (hl),c		;0ea4	71		q
	inc hl			;0ea5	23		#
	ld (hl),c		;0ea6	71		q
	set 2,h			;0ea7	cb d4		. .
	ex de,hl		;0ea9	eb		.
	rst 28h			;0eaa	ef		.
	ret			;0eab	c9		.
	ld a,(0ad01h)		;0eac	3a 01 ad	: . .
	cp 064h			;0eaf	fe 64		. d
	ret nc			;0eb1	d0		.
	ld a,00eh		;0eb2	3e 0e		> .
	call sub_0c0fh		;0eb4	cd 0f 0c	. . .
	rst 28h			;0eb7	ef		.
	rst 28h			;0eb8	ef		.
	ld hl,0ad01h		;0eb9	21 01 ad	! . .
	ld b,001h		;0ebc	06 01		. .
	ld a,(0ad0ch)		;0ebe	3a 0c ad	: . .
	ld c,a			;0ec1	4f		O
	push bc			;0ec2	c5		.
	ld c,000h		;0ec3	0e 00		. .
	ld a,(hl)		;0ec5	7e		~
l0ec6h:
	sub 00ah		;0ec6	d6 0a		. .
	jr c,l0ecdh		;0ec8	38 03		8 .
	inc c			;0eca	0c		.
	jr l0ec6h		;0ecb	18 f9		. .
l0ecdh:
	add a,00ah		;0ecd	c6 0a		. .
	ex af,af'		;0ecf	08		.
	ld a,c			;0ed0	79		y
	pop bc			;0ed1	c1		.
	call sub_0eebh		;0ed2	cd eb 0e	. . .
	rst 20h			;0ed5	e7		.
	ex af,af'		;0ed6	08		.
	call sub_0eebh		;0ed7	cd eb 0e	. . .
	rst 20h			;0eda	e7		.
	ld de,l1748h		;0edb	11 48 17	. H .
	ld bc,l108ch		;0ede	01 8c 10	. . .
l0ee1h:
	ld a,(de)		;0ee1	1a		.
	add a,c			;0ee2	81		.
	ld c,a			;0ee3	4f		O
	inc de			;0ee4	13		.
	djnz l0ee1h		;0ee5	10 fa		. .
	jp nz,l2509h		;0ee7	c2 09 25	. . %
	ret			;0eea	c9		.
sub_0eebh:
	and 00fh		;0eeb	e6 0f		. .
	jr z,l0effh		;0eed	28 10		( .
	ld b,000h		;0eef	06 00		. .
l0ef1h:
	push hl			;0ef1	e5		.
	ld hl,l0f06h		;0ef2	21 06 0f	! . .
	rst 8			;0ef5	cf		.
	pop hl			;0ef6	e1		.
	ld (de),a		;0ef7	12		.
	res 2,d			;0ef8	cb 92		. .
	ld a,c			;0efa	79		y
	ld (de),a		;0efb	12		.
	set 2,d			;0efc	cb d2		. .
	ret			;0efe	c9		.
l0effh:
	ld a,b			;0eff	78		x
	and a			;0f00	a7		.
	jr z,l0ef1h		;0f01	28 ee		( .
	dec b			;0f03	05		.
	rst 28h			;0f04	ef		.
	ret			;0f05	c9		.
l0f06h:
	ex (sp),hl		;0f06	e3		.
	ld c,c			;0f07	49		I
	xor b			;0f08	a8		.
	ld h,h			;0f09	64		d
	daa			;0f0a	27		'
	xor (hl)		;0f0b	ae		.
	ld b,d			;0f0c	42		B
	or b			;0f0d	b0		.
	push de			;0f0e	d5		.
	add a,(hl)		;0f0f	86		.
	pop af			;0f10	f1		.
sub_0f11h:
	ld hl,0a9abh		;0f11	21 ab a9	! . .
	inc (hl)		;0f14	34		4
	xor a			;0f15	af		.
	ld (0a9ach),a		;0f16	32 ac a9	2 . .
	ret			;0f19	c9		.
sub_0f1ah:
	ld hl,0a9ach		;0f1a	21 ac a9	! . .
	inc (hl)		;0f1d	34		4
	ret			;0f1e	c9		.
	ld hl,l0f54h		;0f1f	21 54 0f	! T .
	push hl			;0f22	e5		.
	ld a,(0a9ach)		;0f23	3a ac a9	: . .
	and 00fh		;0f26	e6 0f		. .
	rst 30h			;0f28	f7		.
	or c			;0f29	b1		.
	daa			;0f2a	27		'
	ld e,(hl)		;0f2b	5e		^
	inc sp			;0f2c	33		3
	rst 10h			;0f2d	d7		.
	ld e,e			;0f2e	5b		[
	ld (hl),l		;0f2f	75		u
	ld c,h			;0f30	4c		L
	ld (hl),h		;0f31	74		t
	rlca			;0f32	07		.
	xor a			;0f33	af		.
	ld d,094h		;0f34	16 94		. .
	ld d,(hl)		;0f36	56		V
	sbc a,c			;0f37	99		.
	ld de,l330bh		;0f38	11 0b 33	. . 3
	or h			;0f3b	b4		.
	ex af,af'		;0f3c	08		.
	jp 0e218h		;0f3d	c3 18 e2	. . .
	ld (de),a		;0f40	12		.
	ei			;0f41	fb		.
	ld (de),a		;0f42	12		.
	rrca			;0f43	0f		.
	ld c,d			;0f44	4a		J
	inc hl			;0f45	23		#
	inc de			;0f46	13		.
	or l			;0f47	b5		.
	dec d			;0f48	15		.
	ld (hl),e		;0f49	73		s
	and (hl)		;0f4a	a6		.
	inc d			;0f4b	14		.
	ld a,(hl)		;0f4c	7e		~
	add hl,hl		;0f4d	29		)
	ret m			;0f4e	f8		.
	sub (hl)		;0f4f	96		.
	ld e,l			;0f50	5d		]
	sub (hl)		;0f51	96		.
	inc de			;0f52	13		.
	cp c			;0f53	b9		.
l0f54h:
	ld a,(0ad30h)		;0f54	3a 30 ad	: 0 .
	and a			;0f57	a7		.
	ret nz			;0f58	c0		.
	ld a,(0a986h)		;0f59	3a 86 a9	: . .
	and a			;0f5c	a7		.
	jr nz,l0f70h		;0f5d	20 11		  .
	ld a,(0a9c0h)		;0f5f	3a c0 a9	: . .
	and a			;0f62	a7		.
	ret z			;0f63	c8		.
	ld a,(0a9aeh)		;0f64	3a ae a9	: . .
	and 018h		;0f67	e6 18		. .
	ret z			;0f69	c8		.
l0f6ah:
	call sub_15b6h		;0f6a	cd b6 15	. . .
	jp l1690h		;0f6d	c3 90 16	. . .
l0f70h:
	xor a			;0f70	af		.
	ld (0a9ach),a		;0f71	32 ac a9	2 . .
	ld a,(l1734h+2)		;0f74	3a 36 17	: 6 .
	ld (0a9abh),a		;0f77	32 ab a9	2 . .
	ret			;0f7a	c9		.
sub_0f7bh:
	add a,a			;0f7b	87		.
	add a,a			;0f7c	87		.
	ld hl,l186ah		;0f7d	21 6a 18	! j .
	ld de,0a9d3h		;0f80	11 d3 a9	. . .
	rst 18h			;0f83	df		.
	ldi			;0f84	ed a0		. .
	ldi			;0f86	ed a0		. .
	ldi			;0f88	ed a0		. .
	ldi			;0f8a	ed a0		. .
	ret			;0f8c	c9		.
l0f8dh:
	pop af			;0f8d	f1		.
	ld bc,l02f1h		;0f8e	01 f1 02	. . .
	pop af			;0f91	f1		.
	inc bc			;0f92	03		.
	pop af			;0f93	f1		.
	inc b			;0f94	04		.
	pop af			;0f95	f1		.
	dec b			;0f96	05		.
; First confirmed routines (names remain deliberately behavior-oriented)
SPRITE_RASTER_REWRITE_IF_DUE:
	ld a,(0b411h)		;0f97	3a 11 b4	: . .
	bit 7,a			;0f9a	cb 7f		. .
	jr z,l0fb7h		;0f9c	28 19		( .
	ld c,a			;0f9e	4f		O
	ld a,(SCANLINE_READ_SOUND_COMMAND_WRITE)	;0f9f	3a 00 c0	: . .
	add a,c			;0fa2	81		.
	jr nc,l0fb7h		;0fa3	30 12		0 .
	inc hl			;0fa5	23		#
	inc hl			;0fa6	23		#
	dec hl			;0fa7	2b		+
	dec hl			;0fa8	2b		+
	ld a,c			;0fa9	79		y
	and 07fh		;0faa	e6 7f		. .
	ld (0b411h),a		;0fac	32 11 b4	2 . .
	ld a,(0b010h)		;0faf	3a 10 b0	: . .
	add a,080h		;0fb2	c6 80		. .
	ld (0b010h),a		;0fb4	32 10 b0	2 . .
l0fb7h:
	ld a,(0b413h)		;0fb7	3a 13 b4	: . .
	bit 7,a			;0fba	cb 7f		. .
	jr z,l0fd7h		;0fbc	28 19		( .
	ld c,a			;0fbe	4f		O
	ld a,(SCANLINE_READ_SOUND_COMMAND_WRITE)	;0fbf	3a 00 c0	: . .
	add a,c			;0fc2	81		.
	jr nc,l0fd7h		;0fc3	30 12		0 .
	inc hl			;0fc5	23		#
	inc hl			;0fc6	23		#
	dec hl			;0fc7	2b		+
	dec hl			;0fc8	2b		+
	ld a,c			;0fc9	79		y
	and 07fh		;0fca	e6 7f		. .
	ld (0b413h),a		;0fcc	32 13 b4	2 . .
	ld a,(0b012h)		;0fcf	3a 12 b0	: . .
	add a,080h		;0fd2	c6 80		. .
	ld (0b012h),a		;0fd4	32 12 b0	2 . .
l0fd7h:
	ld a,(0b415h)		;0fd7	3a 15 b4	: . .
	bit 7,a			;0fda	cb 7f		. .
	jr z,l0ff7h		;0fdc	28 19		( .
	ld c,a			;0fde	4f		O
	ld a,(SCANLINE_READ_SOUND_COMMAND_WRITE)	;0fdf	3a 00 c0	: . .
	add a,c			;0fe2	81		.
	jr nc,l0ff7h		;0fe3	30 12		0 .
	inc hl			;0fe5	23		#
	inc hl			;0fe6	23		#
	dec hl			;0fe7	2b		+
	dec hl			;0fe8	2b		+
	ld a,c			;0fe9	79		y
	and 07fh		;0fea	e6 7f		. .
	ld (0b415h),a		;0fec	32 15 b4	2 . .
	ld a,(0b014h)		;0fef	3a 14 b0	: . .
	add a,080h		;0ff2	c6 80		. .
	ld (0b014h),a		;0ff4	32 14 b0	2 . .
l0ff7h:
	ld a,(0b437h)		;0ff7	3a 37 b4	: 7 .
	bit 7,a			;0ffa	cb 7f		. .
	jr z,l1017h		;0ffc	28 19		( .
	ld c,a			;0ffe	4f		O
	ld a,(SCANLINE_READ_SOUND_COMMAND_WRITE)	;0fff	3a 00 c0	: . .
l1002h:
	add a,c			;1002	81		.
	jr nc,l1017h		;1003	30 12		0 .
	inc hl			;1005	23		#
	inc hl			;1006	23		#
	dec hl			;1007	2b		+
	dec hl			;1008	2b		+
	ld a,c			;1009	79		y
	and 07fh		;100a	e6 7f		. .
	ld (0b437h),a		;100c	32 37 b4	2 7 .
	ld a,(0b036h)		;100f	3a 36 b0	: 6 .
	add a,080h		;1012	c6 80		. .
	ld (0b036h),a		;1014	32 36 b0	2 6 .
l1017h:
	ld a,(0b439h)		;1017	3a 39 b4	: 9 .
	bit 7,a			;101a	cb 7f		. .
	jr z,l1037h		;101c	28 19		( .
	ld c,a			;101e	4f		O
	ld a,(SCANLINE_READ_SOUND_COMMAND_WRITE)	;101f	3a 00 c0	: . .
	add a,c			;1022	81		.
	jr nc,l1037h		;1023	30 12		0 .
	inc hl			;1025	23		#
	inc hl			;1026	23		#
	dec hl			;1027	2b		+
	dec hl			;1028	2b		+
	ld a,c			;1029	79		y
	and 07fh		;102a	e6 7f		. .
	ld (0b439h),a		;102c	32 39 b4	2 9 .
	ld a,(0b038h)		;102f	3a 38 b0	: 8 .
	add a,080h		;1032	c6 80		. .
	ld (0b038h),a		;1034	32 38 b0	2 8 .
l1037h:
	ld a,(0b43bh)		;1037	3a 3b b4	: ; .
	bit 7,a			;103a	cb 7f		. .
	jr z,l1057h		;103c	28 19		( .
	ld c,a			;103e	4f		O
	ld a,(SCANLINE_READ_SOUND_COMMAND_WRITE)	;103f	3a 00 c0	: . .
	add a,c			;1042	81		.
	jr nc,l1057h		;1043	30 12		0 .
	inc hl			;1045	23		#
	inc hl			;1046	23		#
	dec hl			;1047	2b		+
	dec hl			;1048	2b		+
	ld a,c			;1049	79		y
	and 07fh		;104a	e6 7f		. .
	ld (0b43bh),a		;104c	32 3b b4	2 ; .
	ld a,(0b03ah)		;104f	3a 3a b0	: : .
	add a,080h		;1052	c6 80		. .
	ld (0b03ah),a		;1054	32 3a b0	2 : .
l1057h:
	ld a,(0b43dh)		;1057	3a 3d b4	: = .
	bit 7,a			;105a	cb 7f		. .
	jr z,l1077h		;105c	28 19		( .
	ld c,a			;105e	4f		O
	ld a,(SCANLINE_READ_SOUND_COMMAND_WRITE)	;105f	3a 00 c0	: . .
	add a,c			;1062	81		.
	jr nc,l1077h		;1063	30 12		0 .
	inc hl			;1065	23		#
	inc hl			;1066	23		#
	dec hl			;1067	2b		+
	dec hl			;1068	2b		+
	ld a,c			;1069	79		y
	and 07fh		;106a	e6 7f		. .
	ld (0b43dh),a		;106c	32 3d b4	2 = .
	ld a,(0b03ch)		;106f	3a 3c b0	: < .
	add a,080h		;1072	c6 80		. .
	ld (0b03ch),a		;1074	32 3c b0	2 < .
l1077h:
	ld a,(0b43fh)		;1077	3a 3f b4	: ? .
	bit 7,a			;107a	cb 7f		. .
	jr z,l1097h		;107c	28 19		( .
	ld c,a			;107e	4f		O
	ld a,(SCANLINE_READ_SOUND_COMMAND_WRITE)	;107f	3a 00 c0	: . .
	add a,c			;1082	81		.
	jr nc,l1097h		;1083	30 12		0 .
	inc hl			;1085	23		#
	inc hl			;1086	23		#
	dec hl			;1087	2b		+
	dec hl			;1088	2b		+
	ld a,c			;1089	79		y
	and 07fh		;108a	e6 7f		. .
l108ch:
	ld (0b43fh),a		;108c	32 3f b4	2 ? .
	ld a,(0b03eh)		;108f	3a 3e b0	: > .
	add a,080h		;1092	c6 80		. .
	ld (0b03eh),a		;1094	32 3e b0	2 > .
l1097h:
	ret			;1097	c9		.
SPRITE_RASTER_REWRITE_WAIT:
	ld a,(0b411h)		;1098	3a 11 b4	: . .
	bit 7,a			;109b	cb 7f		. .
	jr z,l10b8h		;109d	28 19		( .
	ld c,a			;109f	4f		O
	ld a,(SCANLINE_READ_SOUND_COMMAND_WRITE)	;10a0	3a 00 c0	: . .
	add a,c			;10a3	81		.
	jr nc,SPRITE_RASTER_REWRITE_WAIT	;10a4	30 f2		0 .
	inc hl			;10a6	23		#
	inc hl			;10a7	23		#
	dec hl			;10a8	2b		+
	dec hl			;10a9	2b		+
	ld a,c			;10aa	79		y
	and 07fh		;10ab	e6 7f		. .
	ld (0b411h),a		;10ad	32 11 b4	2 . .
	ld a,(0b010h)		;10b0	3a 10 b0	: . .
	add a,080h		;10b3	c6 80		. .
	ld (0b010h),a		;10b5	32 10 b0	2 . .
l10b8h:
	ld a,(0b413h)		;10b8	3a 13 b4	: . .
	bit 7,a			;10bb	cb 7f		. .
	jr z,l10d8h		;10bd	28 19		( .
	ld c,a			;10bf	4f		O
	ld a,(SCANLINE_READ_SOUND_COMMAND_WRITE)	;10c0	3a 00 c0	: . .
	add a,c			;10c3	81		.
	jr nc,l10b8h		;10c4	30 f2		0 .
	inc hl			;10c6	23		#
	inc hl			;10c7	23		#
	dec hl			;10c8	2b		+
	dec hl			;10c9	2b		+
	ld a,c			;10ca	79		y
	and 07fh		;10cb	e6 7f		. .
	ld (0b413h),a		;10cd	32 13 b4	2 . .
	ld a,(0b012h)		;10d0	3a 12 b0	: . .
	add a,080h		;10d3	c6 80		. .
	ld (0b012h),a		;10d5	32 12 b0	2 . .
l10d8h:
	ld a,(0b415h)		;10d8	3a 15 b4	: . .
	bit 7,a			;10db	cb 7f		. .
	jr z,l10f8h		;10dd	28 19		( .
	ld c,a			;10df	4f		O
	ld a,(SCANLINE_READ_SOUND_COMMAND_WRITE)	;10e0	3a 00 c0	: . .
	add a,c			;10e3	81		.
	jr nc,l10d8h		;10e4	30 f2		0 .
	inc hl			;10e6	23		#
	inc hl			;10e7	23		#
	dec hl			;10e8	2b		+
	dec hl			;10e9	2b		+
	ld a,c			;10ea	79		y
	and 07fh		;10eb	e6 7f		. .
	ld (0b415h),a		;10ed	32 15 b4	2 . .
	ld a,(0b014h)		;10f0	3a 14 b0	: . .
	add a,080h		;10f3	c6 80		. .
	ld (0b014h),a		;10f5	32 14 b0	2 . .
l10f8h:
	ld a,(0b437h)		;10f8	3a 37 b4	: 7 .
	bit 7,a			;10fb	cb 7f		. .
sub_10fdh:
	jr z,l1118h		;10fd	28 19		( .
	ld c,a			;10ff	4f		O
	ld a,(SCANLINE_READ_SOUND_COMMAND_WRITE)	;1100	3a 00 c0	: . .
l1103h:
	add a,c			;1103	81		.
	jr nc,l10f8h		;1104	30 f2		0 .
l1106h:
	inc hl			;1106	23		#
	inc hl			;1107	23		#
	dec hl			;1108	2b		+
	dec hl			;1109	2b		+
	ld a,c			;110a	79		y
	and 07fh		;110b	e6 7f		. .
	ld (0b437h),a		;110d	32 37 b4	2 7 .
	ld a,(0b036h)		;1110	3a 36 b0	: 6 .
	add a,080h		;1113	c6 80		. .
	ld (0b036h),a		;1115	32 36 b0	2 6 .
l1118h:
	ld a,(0b439h)		;1118	3a 39 b4	: 9 .
	bit 7,a			;111b	cb 7f		. .
	jr z,l1138h		;111d	28 19		( .
	ld c,a			;111f	4f		O
	ld a,(SCANLINE_READ_SOUND_COMMAND_WRITE)	;1120	3a 00 c0	: . .
	add a,c			;1123	81		.
	jr nc,l1118h		;1124	30 f2		0 .
	inc hl			;1126	23		#
	inc hl			;1127	23		#
	dec hl			;1128	2b		+
	dec hl			;1129	2b		+
	ld a,c			;112a	79		y
	and 07fh		;112b	e6 7f		. .
	ld (0b439h),a		;112d	32 39 b4	2 9 .
	ld a,(0b038h)		;1130	3a 38 b0	: 8 .
	add a,080h		;1133	c6 80		. .
	ld (0b038h),a		;1135	32 38 b0	2 8 .
l1138h:
	ld a,(0b43bh)		;1138	3a 3b b4	: ; .
	bit 7,a			;113b	cb 7f		. .
	jr z,l1158h		;113d	28 19		( .
	ld c,a			;113f	4f		O
	ld a,(SCANLINE_READ_SOUND_COMMAND_WRITE)	;1140	3a 00 c0	: . .
	add a,c			;1143	81		.
	jr nc,l1138h		;1144	30 f2		0 .
	inc hl			;1146	23		#
	inc hl			;1147	23		#
	dec hl			;1148	2b		+
	dec hl			;1149	2b		+
	ld a,c			;114a	79		y
	and 07fh		;114b	e6 7f		. .
	ld (0b43bh),a		;114d	32 3b b4	2 ; .
	ld a,(0b03ah)		;1150	3a 3a b0	: : .
	add a,080h		;1153	c6 80		. .
	ld (0b03ah),a		;1155	32 3a b0	2 : .
l1158h:
	ld a,(0b43dh)		;1158	3a 3d b4	: = .
	bit 7,a			;115b	cb 7f		. .
	jr z,l1178h		;115d	28 19		( .
	ld c,a			;115f	4f		O
	ld a,(SCANLINE_READ_SOUND_COMMAND_WRITE)	;1160	3a 00 c0	: . .
	add a,c			;1163	81		.
	jr nc,l1158h		;1164	30 f2		0 .
	inc hl			;1166	23		#
	inc hl			;1167	23		#
	dec hl			;1168	2b		+
	dec hl			;1169	2b		+
	ld a,c			;116a	79		y
	and 07fh		;116b	e6 7f		. .
	ld (0b43dh),a		;116d	32 3d b4	2 = .
	ld a,(0b03ch)		;1170	3a 3c b0	: < .
	add a,080h		;1173	c6 80		. .
	ld (0b03ch),a		;1175	32 3c b0	2 < .
l1178h:
	ld a,(0b43fh)		;1178	3a 3f b4	: ? .
	bit 7,a			;117b	cb 7f		. .
	jr z,l1198h		;117d	28 19		( .
	ld c,a			;117f	4f		O
	ld a,(SCANLINE_READ_SOUND_COMMAND_WRITE)	;1180	3a 00 c0	: . .
	add a,c			;1183	81		.
	jr nc,l1178h		;1184	30 f2		0 .
	inc hl			;1186	23		#
	inc hl			;1187	23		#
	dec hl			;1188	2b		+
	dec hl			;1189	2b		+
	ld a,c			;118a	79		y
	and 07fh		;118b	e6 7f		. .
	ld (0b43fh),a		;118d	32 3f b4	2 ? .
	ld a,(0b03eh)		;1190	3a 3e b0	: > .
	add a,080h		;1193	c6 80		. .
	ld (0b03eh),a		;1195	32 3e b0	2 > .
l1198h:
	ret			;1198	c9		.
	call sub_31b4h		;1199	cd b4 31	. . 1
	call sub_1edfh		;119c	cd df 1e	. . .
	call sub_23e3h		;119f	cd e3 23	. . #
	call l36aeh+1		;11a2	cd af 36	. . 6
	call SPRITE_RASTER_REWRITE_IF_DUE	;11a5	cd 97 0f	. . .
	call sub_47b3h		;11a8	cd b3 47	. . G
	call sub_43b7h		;11ab	cd b7 43	. . C
	call sub_28a1h		;11ae	cd a1 28	. . (
	call SPRITE_RASTER_REWRITE_IF_DUE	;11b1	cd 97 0f	. . .
	call sub_2cbch		;11b4	cd bc 2c	. . ,
	call sub_40d6h		;11b7	cd d6 40	. . @
	call SPRITE_RASTER_REWRITE_IF_DUE	;11ba	cd 97 0f	. . .
	call sub_3b5fh		;11bd	cd 5f 3b	. _ ;
	call sub_3ddah		;11c0	cd da 3d	. . =
	call sub_3e36h		;11c3	cd 36 3e	. 6 >
	call SPRITE_RASTER_REWRITE_IF_DUE	;11c6	cd 97 0f	. . .
	call sub_3feah		;11c9	cd ea 3f	. . ?
	call sub_4e4fh		;11cc	cd 4f 4e	. O N
	call sub_40b8h		;11cf	cd b8 40	. . @
	call SPRITE_RASTER_REWRITE_IF_DUE	;11d2	cd 97 0f	. . .
	call sub_4ddeh		;11d5	cd de 4d	. . M
	call sub_5205h		;11d8	cd 05 52	. . R
	call sub_4d3ah		;11db	cd 3a 4d	. : M
	call sub_0809h		;11de	cd 09 08	. . .
	call SPRITE_RASTER_REWRITE_WAIT	;11e1	cd 98 10	. . .
l11e4h:
	ld a,(WORK_RAM)		;11e4	3a 00 a8	: . .
	inc a			;11e7	3c		<
	jp z,l1271h		;11e8	ca 71 12	. q .
	dec a			;11eb	3d		=
	ret nz			;11ec	c0		.
sub_11edh:
	call sub_15b6h		;11ed	cd b6 15	. . .
	ld a,(0acc6h)		;11f0	3a c6 ac	: . .
	and a			;11f3	a7		.
	call nz,sub_2db8h	;11f4	c4 b8 2d	. . -
	call sub_5634h		;11f7	cd 34 56	. 4 V
	ld hl,0ad00h		;11fa	21 00 ad	! . .
l11fdh:
	dec (hl)		;11fd	35		5
	push af			;11fe	f5		.
	ld a,(0ad32h)		;11ff	3a 32 ad	: 2 .
	and a			;1202	a7		.
	ld de,0ad10h		;1203	11 10 ad	. . .
	jr z,l120bh		;1206	28 03		( .
	ld de,0ad20h		;1208	11 20 ad	.   .
l120bh:
	ld hl,0ad00h		;120b	21 00 ad	! . .
	ld bc,l0010h		;120e	01 10 00	. . .
	ldir			;1211	ed b0		. .
	pop af			;1213	f1		.
	jr z,l1253h		;1214	28 3d		( =
	ld a,(0ad32h)		;1216	3a 32 ad	: 2 .
	and a			;1219	a7		.
	ld hl,0ad20h		;121a	21 20 ad	!   .
l121dh:
	jr z,l1222h		;121d	28 03		( .
	ld hl,0ad10h		;121f	21 10 ad	! . .
l1222h:
	ld a,(hl)		;1222	7e		~
	and a			;1223	a7		.
	jr z,l122fh		;1224	28 09		( .
l1226h:
	ld a,(0ad32h)		;1226	3a 32 ad	: 2 .
	inc a			;1229	3c		<
	and 001h		;122a	e6 01		. .
	ld (0ad32h),a		;122c	32 32 ad	2 2 .
l122fh:
	ld a,05ah		;122f	3e 5a		> Z
	ld (0a9ebh),a		;1231	32 eb a9	2 . .
	ld a,(l4b52h)		;1234	3a 52 4b	: R K
	ld (0a9ach),a		;1237	32 ac a9	2 . .
	ret			;123a	c9		.
	jr l11e4h		;123b	18 a7		. .
	inc de			;123d	13		.
	and l			;123e	a5		.
	dec sp			;123f	3b		;
	add a,a			;1240	87		.
	pop af			;1241	f1		.
	inc (hl)		;1242	34		4
	ld c,034h		;1243	0e 34		. 4
	rst 10h			;1245	d7		.
	cp a			;1246	bf		.
	pop af			;1247	f1		.
	ld a,a			;1248	7f		.
	inc de			;1249	13		.
	inc de			;124a	13		.
	inc de			;124b	13		.
	inc de			;124c	13		.
	pop af			;124d	f1		.
	adc a,b			;124e	88		.
	call c,sub_11edh	;124f	dc ed 11	. . .
	cp c			;1252	b9		.
l1253h:
	ld a,(0ad30h)		;1253	3a 30 ad	: 0 .
	and a			;1256	a7		.
	jp z,l12fbh		;1257	ca fb 12	. . .
	ld de,00209h		;125a	11 09 02	. . .
	ld a,(0ad32h)		;125d	3a 32 ad	: 2 .
	and a			;1260	a7		.
	jr z,l1264h		;1261	28 01		( .
	inc e			;1263	1c		.
l1264h:
	rst 38h			;1264	ff		.
	ld de,l0a0bh		;1265	11 0b 0a	. . .
	rst 38h			;1268	ff		.
	ld a,0b4h		;1269	3e b4		> .
	ld (0a9ebh),a		;126b	32 eb a9	2 . .
	jp sub_0f1ah		;126e	c3 1a 0f	. . .
l1271h:
	ld a,(0ad02h)		;1271	3a 02 ad	: . .
	and a			;1274	a7		.
	ret nz			;1275	c0		.
	ld a,(0acc6h)		;1276	3a c6 ac	: . .
	and a			;1279	a7		.
	ret z			;127a	c8		.
	ld hl,0a810h		;127b	21 10 a8	! . .
	ld de,l0010h		;127e	11 10 00	. . .
	ld b,00fh		;1281	06 0f		. .
l1283h:
	ld a,(hl)		;1283	7e		~
	and a			;1284	a7		.
	ret nz			;1285	c0		.
	add hl,de		;1286	19		.
	djnz l1283h		;1287	10 fa		. .
	call sub_5634h		;1289	cd 34 56	. 4 V
	ld a,(0ad30h)		;128c	3a 30 ad	: 0 .
	and a			;128f	a7		.
	jr z,l12bbh		;1290	28 29		( )
	ld hl,0aa43h		;1292	21 43 aa	! C .
	ld b,017h		;1295	06 17		. .
	xor a			;1297	af		.
l1298h:
	ld (hl),a		;1298	77		w
	inc l			;1299	2c		,
	inc l			;129a	2c		,
	djnz l1298h		;129b	10 fb		. .
	call sub_2db8h		;129d	cd b8 2d	. . -
	ld a,(0ad32h)		;12a0	3a 32 ad	: 2 .
	and a			;12a3	a7		.
	ld de,0ad10h		;12a4	11 10 ad	. . .
l12a7h:
	jr z,l12ach		;12a7	28 03		( .
	ld de,0ad20h		;12a9	11 20 ad	.   .
l12ach:
	ld hl,0ad00h		;12ac	21 00 ad	! . .
	ld bc,l0010h		;12af	01 10 00	. . .
	ldir			;12b2	ed b0		. .
	ld a,(04a35h)		;12b4	3a 35 4a	: 5 J
	ld (0a9ach),a		;12b7	32 ac a9	2 . .
	ret			;12ba	c9		.
l12bbh:
	ld a,(007d1h)		;12bb	3a d1 07	: . .
	ld (0acc6h),a		;12be	32 c6 ac	2 . .
	call sub_15b6h		;12c1	cd b6 15	. . .
	jp l12fbh		;12c4	c3 fb 12	. . .
l12c7h:
	ld (hl),h		;12c7	74		t
	or c			;12c8	b1		.
	call z,sub_5cech	;12c9	cc ec 5c	. . \
	ld d,039h		;12cc	16 39		. 9
	ld d,b			;12ce	50		P
	ld h,a			;12cf	67		g
	ld hl,0c57ah		;12d0	21 7a c5	! z .
	rst 30h			;12d3	f7		.
	cp (hl)			;12d4	be		.
	ld d,h			;12d5	54		T
	add a,b			;12d6	80		.
	cpl			;12d7	2f		/
	ld e,a			;12d8	5f		_
	sbc a,a			;12d9	9f		.
	ld l,l			;12da	6d		m
	ld b,h			;12db	44		D
	cp b			;12dc	b8		.
	rst 20h			;12dd	e7		.
	cp l			;12de	bd		.
	adc a,c			;12df	89		.
	ld e,c			;12e0	59		Y
	ld a,(de)		;12e1	1a		.
	ld hl,0a9ebh		;12e2	21 eb a9	! . .
	dec (hl)		;12e5	35		5
	ret nz			;12e6	c0		.
l12e7h:
	ld a,(0ad32h)		;12e7	3a 32 ad	: 2 .
	and a			;12ea	a7		.
	ld hl,0ad20h		;12eb	21 20 ad	!   .
	jr z,l12f3h		;12ee	28 03		( .
	ld hl,0ad10h		;12f0	21 10 ad	! . .
l12f3h:
	ld a,(hl)		;12f3	7e		~
	and a			;12f4	a7		.
	jp nz,l1226h		;12f5	c2 26 12	. & .
	jp sub_0f1ah		;12f8	c3 1a 0f	. . .
l12fbh:
	xor a			;12fb	af		.
	ld (0ad30h),a		;12fc	32 30 ad	2 0 .
	ld (0a9ach),a		;12ff	32 ac a9	2 . .
	ld (0ad32h),a		;1302	32 32 ad	2 2 .
	ld a,(016d3h)		;1305	3a d3 16	: . .
	ld (0a9abh),a		;1308	32 ab a9	2 . .
	ld a,(l4901h)		;130b	3a 01 49	: . I
	ld hl,(l4902h)		;130e	2a 02 49	* . I
	rst 18h			;1311	df		.
	xor h			;1312	ac		.
	sub 09bh		;1313	d6 9b		. .
	ld (0a9ach),a		;1315	32 ac a9	2 . .
	ret			;1318	c9		.
sub_1319h:
	ld de,0ffe0h		;1319	11 e0 ff	. . .
	ld b,00dh		;131c	06 0d		. .
l131eh:
	ld (hl),a		;131e	77		w
	add hl,de		;131f	19		.
	djnz l131eh		;1320	10 fc		. .
	ret			;1322	c9		.
	ld a,(0a980h)		;1323	3a 80 a9	: . .
	and 002h		;1326	e6 02		. .
	ret nz			;1328	c0		.
	ld a,(0a9f0h)		;1329	3a f0 a9	: . .
	and a			;132c	a7		.
	jr nz,l1333h		;132d	20 04		  .
	call sub_1367h		;132f	cd 67 13	. g .
	ret			;1332	c9		.
l1333h:
	dec a			;1333	3d		=
	jr nz,l133dh		;1334	20 07		  .
	call sub_1367h		;1336	cd 67 13	. g .
	call sub_142ah		;1339	cd 2a 14	. * .
	ret			;133c	c9		.
l133dh:
	dec a			;133d	3d		=
	jr nz,l1347h		;133e	20 07		  .
	call sub_1393h		;1340	cd 93 13	. . .
	call sub_14c5h		;1343	cd c5 14	. . .
	ret			;1346	c9		.
l1347h:
	dec a			;1347	3d		=
	jr nz,l134eh		;1348	20 04		  .
	call sub_14c5h		;134a	cd c5 14	. . .
	ret			;134d	c9		.
l134eh:
	dec a			;134e	3d		=
	jr nz,l1355h		;134f	20 04		  .
	call sub_13cch		;1351	cd cc 13	. . .
	ret			;1354	c9		.
l1355h:
	ld a,05ah		;1355	3e 5a		> Z
	ld (0a9ebh),a		;1357	32 eb a9	2 . .
	call sub_15b6h		;135a	cd b6 15	. . .
	call sub_4c75h		;135d	cd 75 4c	. u L
	ld a,(02750h)		;1360	3a 50 27	: P '
	ld (0a9ach),a		;1363	32 ac a9	2 . .
	ret			;1366	c9		.
sub_1367h:
	ld a,(0a9f1h)		;1367	3a f1 a9	: . .
	cp 008h			;136a	fe 08		. .
	jr nz,l1376h		;136c	20 08		  .
	ld a,001h		;136e	3e 01		> .
	ld (0a9f0h),a		;1370	32 f0 a9	2 . .
	call sub_5811h		;1373	cd 11 58	. . X
l1376h:
	ld a,(0a9f1h)		;1376	3a f1 a9	: . .
	and 001h		;1379	e6 01		. .
	ld a,03eh		;137b	3e 3e		> >
	jr z,l1381h		;137d	28 02		( .
	ld a,000h		;137f	3e 00		> .
l1381h:
	ld b,a			;1381	47		G
	ld a,(0aa40h)		;1382	3a 40 aa	: @ .
	and 0c0h		;1385	e6 c0		. .
	add a,b			;1387	80		.
	ld (0aa40h),a		;1388	32 40 aa	2 @ .
	ld a,(0a9f1h)		;138b	3a f1 a9	: . .
	inc a			;138e	3c		<
	ld (0a9f1h),a		;138f	32 f1 a9	2 . .
	ret			;1392	c9		.
sub_1393h:
	ld a,(0a9f3h)		;1393	3a f3 a9	: . .
	and a			;1396	a7		.
	jr nz,l13a2h		;1397	20 09		  .
	ld a,003h		;1399	3e 03		> .
	ld (0a9f0h),a		;139b	32 f0 a9	2 . .
	ld a,03fh		;139e	3e 3f		> ?
	jr l13bah		;13a0	18 18		. .
l13a2h:
	and 004h		;13a2	e6 04		. .
	jr nz,l13aah		;13a4	20 04		  .
	ld a,03fh		;13a6	3e 3f		> ?
	jr l13bah		;13a8	18 10		. .
l13aah:
	dec a			;13aa	3d		=
	jr nz,l13b1h		;13ab	20 04		  .
	ld a,036h		;13ad	3e 36		> 6
	jr l13bah		;13af	18 09		. .
l13b1h:
	dec a			;13b1	3d		=
	jr nz,l13b8h		;13b2	20 04		  .
	ld a,03eh		;13b4	3e 3e		> >
	jr l13bah		;13b6	18 02		. .
l13b8h:
	ld a,037h		;13b8	3e 37		> 7
l13bah:
	ld b,a			;13ba	47		G
	ld a,(0aa40h)		;13bb	3a 40 aa	: @ .
	and 0c0h		;13be	e6 c0		. .
	add a,b			;13c0	80		.
	ld (0aa40h),a		;13c1	32 40 aa	2 @ .
	ld a,(0a9f3h)		;13c4	3a f3 a9	: . .
	dec a			;13c7	3d		=
	ld (0a9f3h),a		;13c8	32 f3 a9	2 . .
	ret			;13cb	c9		.
sub_13cch:
	ld a,005h		;13cc	3e 05		> .
	ld (0a9f0h),a		;13ce	32 f0 a9	2 . .
	ld a,(0ad32h)		;13d1	3a 32 ad	: 2 .
	and a			;13d4	a7		.
	ld a,(0ad1ch)		;13d5	3a 1c ad	: . .
	ld b,a			;13d8	47		G
	jr z,l13dfh		;13d9	28 04		( .
	ld a,(0ad2ch)		;13db	3a 2c ad	: , .
	ld b,a			;13de	47		G
l13dfh:
	ld a,(0a987h)		;13df	3a 87 a9	: . .
	and a			;13e2	a7		.
	ld a,b			;13e3	78		x
	jr z,l1408h		;13e4	28 22		( "
	ld hl,0a044h		;13e6	21 44 a0	! D .
	ld de,0a045h		;13e9	11 45 a0	. E .
	exx			;13ec	d9		.
	ld b,01ch		;13ed	06 1c		. .
l13efh:
	exx			;13ef	d9		.
	ld bc,l001ah		;13f0	01 1a 00	. . .
	ld (hl),a		;13f3	77		w
	ldir			;13f4	ed b0		. .
	ld de,l0006h		;13f6	11 06 00	. . .
	add hl,de		;13f9	19		.
	ld d,h			;13fa	54		T
	ld e,l			;13fb	5d		]
	inc de			;13fc	13		.
	exx			;13fd	d9		.
	djnz l13efh		;13fe	10 ef		. .
	ld a,(0a9f6h)		;1400	3a f6 a9	: . .
	dec a			;1403	3d		=
	ld (0a9f6h),a		;1404	32 f6 a9	2 . .
	ret			;1407	c9		.
l1408h:
	ld hl,0a3beh		;1408	21 be a3	! . .
	ld de,0a3bdh		;140b	11 bd a3	. . .
	exx			;140e	d9		.
	ld b,01ch		;140f	06 1c		. .
l1411h:
	exx			;1411	d9		.
	ld bc,l001ah		;1412	01 1a 00	. . .
	ld (hl),a		;1415	77		w
	lddr			;1416	ed b8		. .
	ld de,0fffah		;1418	11 fa ff	. . .
	add hl,de		;141b	19		.
	ld d,h			;141c	54		T
	ld e,l			;141d	5d		]
	dec de			;141e	1b		.
	exx			;141f	d9		.
	djnz l1411h		;1420	10 ef		. .
	ld a,(0a9f6h)		;1422	3a f6 a9	: . .
	dec a			;1425	3d		=
	ld (0a9f6h),a		;1426	32 f6 a9	2 . .
	ret			;1429	c9		.
sub_142ah:
	ld a,(0a9f2h)		;142a	3a f2 a9	: . .
	bit 0,a			;142d	cb 47		. G
	jr z,l149dh		;142f	28 6c		( l
	ld hl,(0a9f7h)		;1431	2a f7 a9	* . .
	ld a,(hl)		;1434	7e		~
	cp 0ffh			;1435	fe ff		. .
	jr nz,l144bh		;1437	20 12		  .
	ld a,000h		;1439	3e 00		> .
	ld (0a9f2h),a		;143b	32 f2 a9	2 . .
	ld a,002h		;143e	3e 02		> .
	ld (0a9f0h),a		;1440	32 f0 a9	2 . .
	ld hl,(0a9f7h)		;1443	2a f7 a9	* . .
	dec hl			;1446	2b		+
	ld (0a9f7h),hl		;1447	22 f7 a9	" . .
	ret			;144a	c9		.
l144bh:
	call sub_1563h		;144b	cd 63 15	. c .
	ld hl,(0a9f7h)		;144e	2a f7 a9	* . .
	ld a,(hl)		;1451	7e		~
	and 001h		;1452	e6 01		. .
	inc hl			;1454	23		#
	ld (0a9f7h),hl		;1455	22 f7 a9	" . .
	jr z,l1469h		;1458	28 0f		( .
	ld de,l0020h		;145a	11 20 00	.   .
	ld hl,0a5f0h		;145d	21 f0 a5	! . .
	inc (hl)		;1460	34		4
	add hl,de		;1461	19		.
	inc (hl)		;1462	34		4
	ld hl,0a5f2h		;1463	21 f2 a5	! . .
	inc (hl)		;1466	34		4
	add hl,de		;1467	19		.
	inc (hl)		;1468	34		4
l1469h:
	ld hl,(0a9f7h)		;1469	2a f7 a9	* . .
	ld a,(hl)		;146c	7e		~
	and 001h		;146d	e6 01		. .
	inc hl			;146f	23		#
	ld (0a9f7h),hl		;1470	22 f7 a9	" . .
	jr z,l147eh		;1473	28 09		( .
	ld de,l0020h		;1475	11 20 00	.   .
	ld hl,0a5f1h		;1478	21 f1 a5	! . .
	inc (hl)		;147b	34		4
	add hl,de		;147c	19		.
	inc (hl)		;147d	34		4
l147eh:
	ld c,002h		;147e	0e 02		. .
	ld de,0a5d1h		;1480	11 d1 a5	. . .
	call sub_4a9dh		;1483	cd 9d 4a	. . J
	ld hl,(0a9f7h)		;1486	2a f7 a9	* . .
	ld de,0fff3h		;1489	11 f3 ff	. . .
	add hl,de		;148c	19		.
	ld (0a9f7h),hl		;148d	22 f7 a9	" . .
	ld c,000h		;1490	0e 00		. .
	ld de,0a631h		;1492	11 31 a6	. 1 .
	call sub_4a9dh		;1495	cd 9d 4a	. . J
	call sub_158ch		;1498	cd 8c 15	. . .
	jr l14bdh		;149b	18 20		.  
l149dh:
	ld a,0f1h		;149d	3e f1		> .
	ld hl,0a7b1h		;149f	21 b1 a7	! . .
	call sub_1319h		;14a2	cd 19 13	. . .
	ld hl,0a5d1h		;14a5	21 d1 a5	! . .
	call sub_1319h		;14a8	cd 19 13	. . .
	ld hl,0a610h		;14ab	21 10 a6	! . .
	ld (hl),a		;14ae	77		w
	add hl,de		;14af	19		.
	ld (hl),a		;14b0	77		w
	ld hl,0a611h		;14b1	21 11 a6	! . .
	ld (hl),a		;14b4	77		w
	add hl,de		;14b5	19		.
	ld (hl),a		;14b6	77		w
	ld hl,0a612h		;14b7	21 12 a6	! . .
	ld (hl),a		;14ba	77		w
	add hl,de		;14bb	19		.
	ld (hl),a		;14bc	77		w
l14bdh:
	ld a,(0a9f2h)		;14bd	3a f2 a9	: . .
	dec a			;14c0	3d		=
	ld (0a9f2h),a		;14c1	32 f2 a9	2 . .
	ret			;14c4	c9		.
sub_14c5h:
	ld a,(0a9f4h)		;14c5	3a f4 a9	: . .
	bit 0,a			;14c8	cb 47		. G
	jr z,l153bh		;14ca	28 6f		( o
	ld hl,(0a9f7h)		;14cc	2a f7 a9	* . .
	ld a,(hl)		;14cf	7e		~
	and 0feh		;14d0	e6 fe		. .
	jr z,l14e9h		;14d2	28 15		( .
	ld a,000h		;14d4	3e 00		> .
	ld (0a9f4h),a		;14d6	32 f4 a9	2 . .
	ld a,004h		;14d9	3e 04		> .
	ld (0a9f0h),a		;14db	32 f0 a9	2 . .
	call sub_56e4h		;14de	cd e4 56	. . V
	ld hl,(0a9f7h)		;14e1	2a f7 a9	* . .
	inc hl			;14e4	23		#
	ld (0a9f7h),hl		;14e5	22 f7 a9	" . .
	ret			;14e8	c9		.
l14e9h:
	call sub_1563h		;14e9	cd 63 15	. c .
	ld c,001h		;14ec	0e 01		. .
	ld de,0a451h		;14ee	11 51 a4	. Q .
	call sub_4a9dh		;14f1	cd 9d 4a	. . J
	ld hl,(0a9f7h)		;14f4	2a f7 a9	* . .
	ld de,l000dh		;14f7	11 0d 00	. . .
	add hl,de		;14fa	19		.
	ld (0a9f7h),hl		;14fb	22 f7 a9	" . .
	ld c,003h		;14fe	0e 03		. .
	ld de,0a7b1h		;1500	11 b1 a7	. . .
	call sub_4a9dh		;1503	cd 9d 4a	. . J
	ld hl,(0a9f7h)		;1506	2a f7 a9	* . .
	ld a,(hl)		;1509	7e		~
	and 001h		;150a	e6 01		. .
	dec hl			;150c	2b		+
	ld (0a9f7h),hl		;150d	22 f7 a9	" . .
	jr z,l151bh		;1510	28 09		( .
	ld de,l0020h		;1512	11 20 00	.   .
	ld hl,0a5f1h		;1515	21 f1 a5	! . .
	dec (hl)		;1518	35		5
	add hl,de		;1519	19		.
	dec (hl)		;151a	35		5
l151bh:
	ld hl,(0a9f7h)		;151b	2a f7 a9	* . .
	ld a,(hl)		;151e	7e		~
	and 001h		;151f	e6 01		. .
	dec hl			;1521	2b		+
	ld (0a9f7h),hl		;1522	22 f7 a9	" . .
	jr z,l1536h		;1525	28 0f		( .
	ld de,l0020h		;1527	11 20 00	.   .
	ld hl,0a5f0h		;152a	21 f0 a5	! . .
	dec (hl)		;152d	35		5
	add hl,de		;152e	19		.
	dec (hl)		;152f	35		5
	ld hl,0a5f2h		;1530	21 f2 a5	! . .
	dec (hl)		;1533	35		5
	add hl,de		;1534	19		.
	dec (hl)		;1535	35		5
l1536h:
	call sub_158ch		;1536	cd 8c 15	. . .
	jr l155bh		;1539	18 20		.  
l153bh:
	ld a,0f1h		;153b	3e f1		> .
	ld hl,0a7b1h		;153d	21 b1 a7	! . .
	call sub_1319h		;1540	cd 19 13	. . .
	ld hl,0a5d1h		;1543	21 d1 a5	! . .
	call sub_1319h		;1546	cd 19 13	. . .
	ld hl,0a610h		;1549	21 10 a6	! . .
	ld (hl),a		;154c	77		w
	add hl,de		;154d	19		.
	ld (hl),a		;154e	77		w
	ld hl,0a611h		;154f	21 11 a6	! . .
	ld (hl),a		;1552	77		w
	add hl,de		;1553	19		.
	ld (hl),a		;1554	77		w
	ld hl,0a612h		;1555	21 12 a6	! . .
	ld (hl),a		;1558	77		w
	add hl,de		;1559	19		.
	ld (hl),a		;155a	77		w
l155bh:
	ld a,(0a9f4h)		;155b	3a f4 a9	: . .
	dec a			;155e	3d		=
	ld (0a9f4h),a		;155f	32 f4 a9	2 . .
	ret			;1562	c9		.
sub_1563h:
	ld de,VIDEO_RAM		;1563	11 00 a4	. . .
	ld hl,0a451h		;1566	21 51 a4	! Q .
	ld bc,l0020h		;1569	01 20 00	.   .
	exx			;156c	d9		.
	ld b,01ch		;156d	06 1c		. .
l156fh:
	exx			;156f	d9		.
	ld a,(de)		;1570	1a		.
	ld (hl),a		;1571	77		w
	inc de			;1572	13		.
	add hl,bc		;1573	09		.
	exx			;1574	d9		.
	djnz l156fh		;1575	10 f8		. .
	exx			;1577	d9		.
	ld hl,0a5f0h		;1578	21 f0 a5	! . .
	ld a,(de)		;157b	1a		.
	ld (hl),a		;157c	77		w
	add hl,bc		;157d	09		.
	inc de			;157e	13		.
	ld a,(de)		;157f	1a		.
	ld (hl),a		;1580	77		w
	inc de			;1581	13		.
	ld hl,0a5f2h		;1582	21 f2 a5	! . .
	ld a,(de)		;1585	1a		.
	ld (hl),a		;1586	77		w
	add hl,bc		;1587	09		.
	inc de			;1588	13		.
	ld a,(de)		;1589	1a		.
	ld (hl),a		;158a	77		w
	ret			;158b	c9		.
sub_158ch:
	ld de,VIDEO_RAM		;158c	11 00 a4	. . .
	ld hl,0a451h		;158f	21 51 a4	! Q .
	ld bc,l0020h		;1592	01 20 00	.   .
	exx			;1595	d9		.
	ld b,01ch		;1596	06 1c		. .
l1598h:
	exx			;1598	d9		.
	ld a,(hl)		;1599	7e		~
	ld (de),a		;159a	12		.
	inc de			;159b	13		.
	add hl,bc		;159c	09		.
	exx			;159d	d9		.
	djnz l1598h		;159e	10 f8		. .
	exx			;15a0	d9		.
	ld hl,0a5f0h		;15a1	21 f0 a5	! . .
	ld a,(hl)		;15a4	7e		~
	ld (de),a		;15a5	12		.
	add hl,bc		;15a6	09		.
	inc de			;15a7	13		.
	ld a,(hl)		;15a8	7e		~
	ld (de),a		;15a9	12		.
	inc de			;15aa	13		.
	ld hl,0a5f2h		;15ab	21 f2 a5	! . .
	ld a,(hl)		;15ae	7e		~
	ld (de),a		;15af	12		.
	add hl,bc		;15b0	09		.
	inc de			;15b1	13		.
	ld a,(hl)		;15b2	7e		~
	ld (de),a		;15b3	12		.
	ret			;15b4	c9		.
	ret			;15b5	c9		.
sub_15b6h:
	ld hl,0aa41h		;15b6	21 41 aa	! A .
	ld b,018h		;15b9	06 18		. .
	xor a			;15bb	af		.
l15bch:
	ld (hl),a		;15bc	77		w
	inc l			;15bd	2c		,
	inc l			;15be	2c		,
	djnz l15bch		;15bf	10 fb		. .
	ret			;15c1	c9		.
	ld a,(0a9ach)		;15c2	3a ac a9	: . .
	and 007h		;15c5	e6 07		. .
	rst 30h			;15c7	f7		.
	jp po,05f15h		;15c8	e2 15 5f	. . _
	and l			;15cb	a5		.
	inc de			;15cc	13		.
	ld (hl),a		;15cd	77		w
	rst 10h			;15ce	d7		.
	inc (hl)		;15cf	34		4
	add a,a			;15d0	87		.
	defb 0fdh,0dch,0b9h ;illegal sequence	;15d1	fd dc b9	. . .
	cp 015h			;15d4	fe 15		. .
	ld h,b			;15d6	60		`
	and (hl)		;15d7	a6		.
	inc d			;15d8	14		.
	call nz,sub_10fdh	;15d9	c4 fd 10	. . .
	defb 0edh ;next byte illegal after ed	;15dc	ed		.
	ld (hl),a		;15dd	77		w
	ld l,b			;15de	68		h
	rst 10h			;15df	d7		.
	inc (hl)		;15e0	34		4
	cp c			;15e1	b9		.
	call sub_019ah		;15e2	cd 9a 01	. . .
	ld a,(l1748h+1)		;15e5	3a 49 17	: I .
	ld (0a9ach),a		;15e8	32 ac a9	2 . .
	ld c,000h		;15eb	0e 00		. .
	ld hl,05648h		;15ed	21 48 56	! H V
	ld a,(0a9abh)		;15f0	3a ab a9	: . .
l15f3h:
	sub (hl)		;15f3	96		.
	inc hl			;15f4	23		#
	dec c			;15f5	0d		.
	jr nz,l15f3h		;15f6	20 fb		  .
	xor 04eh		;15f8	ee 4e		. N
	ld (0a9abh),a		;15fa	32 ab a9	2 . .
	ret			;15fd	c9		.
	call sub_01c2h		;15fe	cd c2 01	. . .
l1601h:
	ret nz			;1601	c0		.
	ld de,l0103h+2		;1602	11 05 01	. . .
	rst 38h			;1605	ff		.
	inc e			;1606	1c		.
	rst 38h			;1607	ff		.
	inc e			;1608	1c		.
	rst 38h			;1609	ff		.
	ld de,l0601h		;160a	11 01 06	. . .
	rst 38h			;160d	ff		.
	ld a,013h		;160e	3e 13		> .
	ld (0a701h),a		;1610	32 01 a7	2 . .
	ld (0a6e1h),a		;1613	32 e1 a6	2 . .
l1616h:
	ld hl,l163fh		;1616	21 3f 16	! ? .
	ld b,006h		;1619	06 06		. .
l161bh:
	ld e,(hl)		;161b	5e		^
	inc hl			;161c	23		#
	ld d,(hl)		;161d	56		V
	inc hl			;161e	23		#
	ld a,(hl)		;161f	7e		~
	ld (de),a		;1620	12		.
	inc de			;1621	13		.
	ex de,hl		;1622	eb		.
	ld (hl),005h		;1623	36 05		6 .
	ex de,hl		;1625	eb		.
	inc hl			;1626	23		#
	djnz l161bh		;1627	10 f2		. .
	call sub_0d6bh		;1629	cd 6b 0d	. k .
	ld a,001h		;162c	3e 01		> .
	ld (0a9abh),a		;162e	32 ab a9	2 . .
	inc a			;1631	3c		<
	ld (0a9ach),a		;1632	32 ac a9	2 . .
	ld a,(0a9c0h)		;1635	3a c0 a9	: . .
	and a			;1638	a7		.
	ret z			;1639	c8		.
	ld de,l010ch+1		;163a	11 0d 01	. . .
	rst 38h			;163d	ff		.
	ret			;163e	c9		.
l163fh:
	ei			;163f	fb		.
	xor l			;1640	ad		.
	add iy,sp		;1641	fd 39		. 9
	xor l			;1643	ad		.
	ld l,b			;1644	68		h
	ld b,e			;1645	43		C
	xor e			;1646	ab		.
	ld a,h			;1647	7c		|
	cp 0abh			;1648	fe ab		. .
	and l			;164a	a5		.
	cp (hl)			;164b	be		.
	xor h			;164c	ac		.
	jr c,l1616h		;164d	38 c7		8 .
	xor h			;164f	ac		.
	dec sp			;1650	3b		;
	ld hl,l167bh		;1651	21 7b 16	! { .
	push hl			;1654	e5		.
	ld a,(0a9ach)		;1655	3a ac a9	: . .
	rst 30h			;1658	f7		.
	ld c,e			;1659	4b		K
	rlca			;165a	07		.
	inc (hl)		;165b	34		4
	rla			;165c	17		.
	ccf			;165d	3f		?
	dec l			;165e	2d		-
	ld a,008h		;165f	3e 08		> .
	ld c,b			;1661	48		H
	rla			;1662	17		.
	ld l,d			;1663	6a		j
	rla			;1664	17		.
	adc a,h			;1665	8c		.
	rla			;1666	17		.
	cp c			;1667	b9		.
	rla			;1668	17		.
	ld d,d			;1669	52		R
	ld (l17e2h),a		;166a	32 e2 17	2 . .
	add hl,de		;166d	19		.
	ld c,e			;166e	4b		K
	ei			;166f	fb		.
	rla			;1670	17		.
	jr nc,$+41		;1671	30 27		0 '
	ld h,0a6h		;1673	26 a6		& .
l1675h:
	inc de			;1675	13		.
	adc a,b			;1676	88		.
	ld d,a			;1677	57		W
	and l			;1678	a5		.
	cp a			;1679	bf		.
	cp c			;167a	b9		.
l167bh:
	ld a,(0a986h)		;167b	3a 86 a9	: . .
	and a			;167e	a7		.
	jp nz,sub_0f11h		;167f	c2 11 0f	. . .
	ld a,(0a9c0h)		;1682	3a c0 a9	: . .
	and a			;1685	a7		.
	ret z			;1686	c8		.
	ld a,(0a9aeh)		;1687	3a ae a9	: . .
	and 018h		;168a	e6 18		. .
	ret z			;168c	c8		.
	call sub_15b6h		;168d	cd b6 15	. . .
l1690h:
	ld a,(0a9aeh)		;1690	3a ae a9	: . .
	bit 4,a			;1693	cb 67		. g
	jr nz,l169ch		;1695	20 05		  .
	bit 3,a			;1697	cb 5f		. _
	jr nz,l1719h		;1699	20 7e		  ~
	ret			;169b	c9		.
l169ch:
	ld a,0ffh		;169c	3e ff		> .
	ld (0ad30h),a		;169e	32 30 ad	2 0 .
	ld (0ad31h),a		;16a1	32 31 ad	2 1 .
	ld a,(0a9c1h)		;16a4	3a c1 a9	: . .
	ld (0ad10h),a		;16a7	32 10 ad	2 . .
	ld (0ad20h),a		;16aa	32 20 ad	2   .
	jr l172ah		;16ad	18 7b		. {
	ld b,000h		;16af	06 00		. .
	ld hl,l4d9fh		;16b1	21 9f 4d	! . M
	ld a,(0a9abh)		;16b4	3a ab a9	: . .
l16b7h:
	sub (hl)		;16b7	96		.
	inc hl			;16b8	23		#
	djnz l16b7h		;16b9	10 fc		. .
	xor 0a2h		;16bb	ee a2		. .
	ld (0a9abh),a		;16bd	32 ab a9	2 . .
	call SPRITE_RASTER_REWRITE_IF_DUE	;16c0	cd 97 0f	. . .
	call sub_1edfh		;16c3	cd df 1e	. . .
	call SPRITE_RASTER_REWRITE_IF_DUE	;16c6	cd 97 0f	. . .
	call sub_2cbch		;16c9	cd bc 2c	. . ,
	call SPRITE_RASTER_REWRITE_WAIT	;16cc	cd 98 10	. . .
	ld a,(0a980h)		;16cf	3a 80 a9	: . .
	and 001h		;16d2	e6 01		. .
	jr z,l16f2h		;16d4	28 1c		( .
	ld hl,0a9ebh		;16d6	21 eb a9	! . .
	dec (hl)		;16d9	35		5
	jr nz,l16f2h		;16da	20 16		  .
	ld de,l0309h		;16dc	11 09 03	. . .
	rst 38h			;16df	ff		.
	ld e,00eh		;16e0	1e 0e		. .
	rst 38h			;16e2	ff		.
	ld e,01ah		;16e3	1e 1a		. .
	rst 38h			;16e5	ff		.
	xor a			;16e6	af		.
	ld (0ad0eh),a		;16e7	32 0e ad	2 . .
	ld a,02ah		;16ea	3e 2a		> *
	ld (0a9ebh),a		;16ec	32 eb a9	2 . .
	jp sub_0f1ah		;16ef	c3 1a 0f	. . .
l16f2h:
	ld a,(0ad0eh)		;16f2	3a 0e ad	: . .
	and a			;16f5	a7		.
	ret z			;16f6	c8		.
	ld a,(0a980h)		;16f7	3a 80 a9	: . .
	and 00fh		;16fa	e6 0f		. .
	jr z,l1707h		;16fc	28 09		( .
	cp 005h			;16fe	fe 05		. .
	jr z,l170bh		;1700	28 09		( .
	cp 00ah			;1702	fe 0a		. .
	jr z,l170fh		;1704	28 09		( .
	ret			;1706	c9		.
l1707h:
	ld d,002h		;1707	16 02		. .
	jr l1711h		;1709	18 06		. .
l170bh:
	ld d,00ah		;170b	16 0a		. .
	jr l1711h		;170d	18 02		. .
l170fh:
	ld d,00bh		;170f	16 0b		. .
l1711h:
	ld a,(0ad04h)		;1711	3a 04 ad	: . .
	add a,01ah		;1714	c6 1a		. .
	ld e,a			;1716	5f		_
	rst 38h			;1717	ff		.
	ret			;1718	c9		.
l1719h:
	xor a			;1719	af		.
	ld (0ad31h),a		;171a	32 31 ad	2 1 .
	ld (0ad20h),a		;171d	32 20 ad	2   .
	dec a			;1720	3d		=
	ld (0ad30h),a		;1721	32 30 ad	2 0 .
	ld a,(0a9c1h)		;1724	3a c1 a9	: . .
	ld (0ad10h),a		;1727	32 10 ad	2 . .
l172ah:
	ld a,003h		;172a	3e 03		> .
	ld (0a9abh),a		;172c	32 ab a9	2 . .
	xor a			;172f	af		.
	ld (0a9ach),a		;1730	32 ac a9	2 . .
	ret			;1733	c9		.
l1734h:
	call sub_0201h		;1734	cd 01 02	. . .
	ret nz			;1737	c0		.
	ld hl,l1748h		;1738	21 48 17	! H .
	ld b,022h		;173b	06 22		. "
	xor a			;173d	af		.
l173eh:
	sub (hl)		;173e	96		.
	inc hl			;173f	23		#
	djnz l173eh		;1740	10 fc		. .
	ld (0a817h),a		;1742	32 17 a8	2 . .
	jp sub_0f1ah		;1745	c3 1a 0f	. . .
l1748h:
	call sub_0b06h		;1748	cd 06 0b	. . .
	call sub_0b39h		;174b	cd 39 0b	. 9 .
	ld hl,0a9ebh		;174e	21 eb a9	! . .
	dec (hl)		;1751	35		5
	ret nz			;1752	c0		.
	ld hl,0a63ch		;1753	21 3c a6	! < .
	ld de,0acc7h		;1756	11 c7 ac	. . .
	ld a,(hl)		;1759	7e		~
	ld (de),a		;175a	12		.
	inc de			;175b	13		.
	res 2,h			;175c	cb 94		. .
	ld a,(hl)		;175e	7e		~
	ld (de),a		;175f	12		.
	ld de,l0303h		;1760	11 03 03	. . .
	rst 38h			;1763	ff		.
	inc e			;1764	1c		.
	rst 38h			;1765	ff		.
	jp sub_0f1ah		;1766	c3 1a 0f	. . .
	ld sp,0dacdh		;1769	31 cd da	1 . .
	add hl,de		;176c	19		.
	ld a,(0a67ch)		;176d	3a 7c a6	: | .
	cp 07ch			;1770	fe 7c		. |
	jp nz,l459bh		;1772	c2 9b 45	. . E
	ld de,l0113h		;1775	11 13 01	. . .
	rst 38h			;1778	ff		.
	call sub_4bdch		;1779	cd dc 4b	. . K
	ld hl,0a5dch		;177c	21 dc a5	! . .
	ld de,0adfbh		;177f	11 fb ad	. . .
	ld a,(hl)		;1782	7e		~
	ld (de),a		;1783	12		.
	inc de			;1784	13		.
	res 2,h			;1785	cb 94		. .
	ld a,(hl)		;1787	7e		~
	ld (de),a		;1788	12		.
	jp sub_0f1ah		;1789	c3 1a 0f	. . .
l178ch:
	call sub_0b06h		;178c	cd 06 0b	. . .
	call sub_0b39h		;178f	cd 39 0b	. 9 .
	ld hl,0a9ebh		;1792	21 eb a9	! . .
l1795h:
	dec (hl)		;1795	35		5
	ret nz			;1796	c0		.
	call sub_19dah		;1797	cd da 19	. . .
	ld a,(sub_47b3h)	;179a	3a b3 47	: . G
	add a,002h		;179d	c6 02		. .
	ld l,a			;179f	6f		o
	add a,06ah		;17a0	c6 6a		. j
	ld h,a			;17a2	67		g
	ld a,(hl)		;17a3	7e		~
	cp 03bh			;17a4	fe 3b		. ;
	jp nz,015cah		;17a6	c2 ca 15	. . .
	ld hl,0a67ch		;17a9	21 7c a6	! | .
	ld de,0ab43h		;17ac	11 43 ab	. C .
	ld a,(hl)		;17af	7e		~
	ld (de),a		;17b0	12		.
	inc de			;17b1	13		.
	res 2,h			;17b2	cb 94		. .
	ld a,(hl)		;17b4	7e		~
	ld (de),a		;17b5	12		.
	jp sub_0f1ah		;17b6	c3 1a 0f	. . .
l17b9h:
	ld a,(l590dh)		;17b9	3a 0d 59	: . Y
	ld c,a			;17bc	4f		O
	ld a,(04a40h)		;17bd	3a 40 4a	: @ J
	ld hl,sub_0b06h		;17c0	21 06 0b	! . .
	ld b,033h		;17c3	06 33		. 3
l17c5h:
	add a,(hl)		;17c5	86		.
	inc hl			;17c6	23		#
	djnz l17c5h		;17c7	10 fc		. .
	cp 0efh			;17c9	fe ef		. .
	jp z,sub_0f1ah		;17cb	ca 1a 0f	. . .
	ld a,(l4c87h+2)		;17ce	3a 89 4c	: . L
	ld (LATCH_VIDEO_ENABLE),a	;17d1	32 08 c3	2 . .
	ld hl,0a65ch		;17d4	21 5c a6	! \ .
	ld de,0ad39h		;17d7	11 39 ad	. 9 .
	ld a,(hl)		;17da	7e		~
	ld (de),a		;17db	12		.
	inc de			;17dc	13		.
	res 2,h			;17dd	cb 94		. .
	ld a,(hl)		;17df	7e		~
	ld (de),a		;17e0	12		.
	ret			;17e1	c9		.
l17e2h:
	ld a,0ffh		;17e2	3e ff		> .
	ld (0aa3fh),a		;17e4	32 3f aa	2 ? .
	ld de,l17b9h		;17e7	11 b9 17	. . .
	ld c,008h		;17ea	0e 08		. .
	call sub_4bd9h		;17ec	cd d9 4b	. . K
	ld a,(027c0h)		;17ef	3a c0 27	: . '
	call sub_291eh		;17f2	cd 1e 29	. . )
	ld (0aa6fh),a		;17f5	32 6f aa	2 o .
	jp sub_0f1ah		;17f8	c3 1a 0f	. . .
	jp sub_0f1ah		;17fb	c3 1a 0f	. . .
	ld hl,l181dh		;17fe	21 1d 18	! . .
	push hl			;1801	e5		.
	ld a,(0a9ach)		;1802	3a ac a9	: . .
	rst 30h			;1805	f7		.
	ld e,018h		;1806	1e 18		. .
	in a,(02ch)		;1808	db 2c		. ,
	jr nc,l1824h		;180a	30 18		0 .
	and 007h		;180c	e6 07		. .
	adc a,d			;180e	8a		.
	jr l1883h		;180f	18 72		. r
	and (hl)		;1811	a6		.
	inc d			;1812	14		.
	ld a,l			;1813	7d		}
	and l			;1814	a5		.
	jr c,l184bh		;1815	38 34		8 4
	pop af			;1817	f1		.
	ld l,b			;1818	68		h
	ld c,034h		;1819	0e 34		. 4
	rst 10h			;181b	d7		.
	cp c			;181c	b9		.
l181dh:
	ret			;181d	c9		.
	call sub_15b6h		;181e	cd b6 15	. . .
	ld hl,0a5fch		;1821	21 fc a5	! . .
l1824h:
	ld de,0acbeh		;1824	11 be ac	. . .
	call sub_1afch		;1827	cd fc 1a	. . .
	call sub_01b5h		;182a	cd b5 01	. . .
	jp sub_0f1ah		;182d	c3 1a 0f	. . .
	call sub_0b06h		;1830	cd 06 0b	. . .
	call sub_0b39h		;1833	cd 39 0b	. 9 .
	ld de,l0101h		;1836	11 01 01	. . .
	rst 38h			;1839	ff		.
	ld e,014h		;183a	1e 14		. .
	rst 38h			;183c	ff		.
	inc e			;183d	1c		.
	rst 38h			;183e	ff		.
	ld e,00fh		;183f	1e 0f		. .
	ld a,(0a9c3h)		;1841	3a c3 a9	: . .
	and a			;1844	a7		.
	jr z,l1849h		;1845	28 02		( .
	inc e			;1847	1c		.
	inc e			;1848	1c		.
l1849h:
	rst 38h			;1849	ff		.
	inc e			;184a	1c		.
l184bh:
	rst 38h			;184b	ff		.
	ld e,016h		;184c	1e 16		. .
	rst 38h			;184e	ff		.
	ld e,000h		;184f	1e 00		. .
	rst 38h			;1851	ff		.
	ld a,(0a986h)		;1852	3a 86 a9	: . .
	cp 002h			;1855	fe 02		. .
	jr nc,l1860h		;1857	30 07		0 .
	ld de,l0117h		;1859	11 17 01	. . .
	rst 38h			;185c	ff		.
	jp sub_0f1ah		;185d	c3 1a 0f	. . .
l1860h:
	ld de,l0117h+2		;1860	11 19 01	. . .
	rst 38h			;1863	ff		.
	call sub_0f1ah		;1864	cd 1a 0f	. . .
	jp sub_0f1ah		;1867	c3 1a 0f	. . .
l186ah:
	nop			;186a	00		.
	ld (bc),a		;186b	02		.
	ld b,00dh		;186c	06 0d		. .
	nop			;186e	00		.
	inc bc			;186f	03		.
	rlca			;1870	07		.
	inc c			;1871	0c		.
	nop			;1872	00		.
	inc b			;1873	04		.
	ex af,af'		;1874	08		.
	dec bc			;1875	0b		.
	ld (bc),a		;1876	02		.
	ld b,00ah		;1877	06 0a		. .
	ld a,(bc)		;1879	0a		.
	inc b			;187a	04		.
	ex af,af'		;187b	08		.
	inc c			;187c	0c		.
	add hl,bc		;187d	09		.
	rlca			;187e	07		.
	ld a,(bc)		;187f	0a		.
	dec c			;1880	0d		.
	rlca			;1881	07		.
	dec bc			;1882	0b		.
l1883h:
	dec c			;1883	0d		.
	ld c,005h		;1884	0e 05		. .
	rrca			;1886	0f		.
	rrca			;1887	0f		.
	rrca			;1888	0f		.
	dec b			;1889	05		.
	call sub_0b06h		;188a	cd 06 0b	. . .
	call sub_0b39h		;188d	cd 39 0b	. 9 .
	ld a,(0a9aeh)		;1890	3a ae a9	: . .
	bit 4,a			;1893	cb 67		. g
	jp nz,l189eh		;1895	c2 9e 18	. . .
	bit 3,a			;1898	cb 5f		. _
	jp nz,l3215h		;189a	c2 15 32	. . 2
	ret			;189d	c9		.
l189eh:
	call sub_0b2bh		;189e	cd 2b 0b	. + .
	ld a,0ffh		;18a1	3e ff		> .
	ld (0ad30h),a		;18a3	32 30 ad	2 0 .
	ld (0ad31h),a		;18a6	32 31 ad	2 1 .
	ld a,(0a9c1h)		;18a9	3a c1 a9	: . .
	ld (0ad10h),a		;18ac	32 10 ad	2 . .
	ld (0ad20h),a		;18af	32 20 ad	2   .
	call sub_460eh		;18b2	cd 0e 46	. . F
	ld hl,0a986h		;18b5	21 86 a9	! . .
	ld a,(hl)		;18b8	7e		~
	sub 002h		;18b9	d6 02		. .
	daa			;18bb	27		'
	ld (hl),a		;18bc	77		w
	call sub_4afbh		;18bd	cd fb 4a	. . J
	jp l172ah		;18c0	c3 2a 17	. * .
	ld a,(0a980h)		;18c3	3a 80 a9	: . .
	and 001h		;18c6	e6 01		. .
	jp nz,l1984h		;18c8	c2 84 19	. . .
	call 01ed1h		;18cb	cd d1 1e	. . .
	ld hl,0a995h		;18ce	21 95 a9	! . .
	rrca			;18d1	0f		.
	rl (hl)			;18d2	cb 16		. .
	inc hl			;18d4	23		#
	rrca			;18d5	0f		.
	rl (hl)			;18d6	cb 16		. .
	inc hl			;18d8	23		#
	rrca			;18d9	0f		.
	rrca			;18da	0f		.
	rrca			;18db	0f		.
	rl (hl)			;18dc	cb 16		. .
	inc hl			;18de	23		#
	rrca			;18df	0f		.
	rl (hl)			;18e0	cb 16		. .
	ld a,(hl)		;18e2	7e		~
	and 007h		;18e3	e6 07		. .
	dec a			;18e5	3d		=
	jr z,l1923h		;18e6	28 3b		( ;
	dec hl			;18e8	2b		+
	ld a,(hl)		;18e9	7e		~
	and 007h		;18ea	e6 07		. .
	dec a			;18ec	3d		=
	jr z,l1923h		;18ed	28 34		( 4
	dec hl			;18ef	2b		+
	ld a,(hl)		;18f0	7e		~
	cp 0ffh			;18f1	fe ff		. .
	call z,sub_1980h	;18f3	cc 80 19	. . .
	and 007h		;18f6	e6 07		. .
	dec a			;18f8	3d		=
	jr z,l1916h		;18f9	28 1b		( .
	dec hl			;18fb	2b		+
	ld a,(hl)		;18fc	7e		~
	cp 07fh			;18fd	fe 7f		. .
	call z,sub_1980h	;18ff	cc 80 19	. . .
	and 007h		;1902	e6 07		. .
	dec a			;1904	3d		=
	jr z,l1909h		;1905	28 02		( .
	jr l1963h		;1907	18 5a		. Z
l1909h:
	ld hl,0a999h		;1909	21 99 a9	! . .
	dec (hl)		;190c	35		5
	ld a,(hl)		;190d	7e		~
	cp 080h			;190e	fe 80		. .
	jr c,l194eh		;1910	38 3c		8 <
	ld (hl),01ah		;1912	36 1a		6 .
	jr l194eh		;1914	18 38		. 8
l1916h:
	ld hl,0a999h		;1916	21 99 a9	! . .
	inc (hl)		;1919	34		4
	ld a,(hl)		;191a	7e		~
	cp 01bh			;191b	fe 1b		. .
	jr c,l194eh		;191d	38 2f		8 /
	ld (hl),000h		;191f	36 00		6 .
	jr l194eh		;1921	18 2b		. +
l1923h:
	ld a,(0a999h)		;1923	3a 99 a9	: . .
	ld hl,l12c7h		;1926	21 c7 12	! . .
	rst 8			;1929	cf		.
	ld hl,(0a991h)		;192a	2a 91 a9	* . .
	ld de,(0a993h)		;192d	ed 5b 93 a9	. [ . .
	ld (de),a		;1931	12		.
	ld (hl),a		;1932	77		w
	ld a,(0a990h)		;1933	3a 90 a9	: . .
	res 2,d			;1936	cb 92		. .
	ld (de),a		;1938	12		.
	set 2,d			;1939	cb d2		. .
	rst 20h			;193b	e7		.
	inc hl			;193c	23		#
	ld (0a991h),hl		;193d	22 91 a9	" . .
	ld (0a993h),de		;1940	ed 53 93 a9	. S . .
	ld hl,0a99ah		;1944	21 9a a9	! . .
	dec (hl)		;1947	35		5
	jr z,l1975h		;1948	28 2b		( +
	xor a			;194a	af		.
	ld (0a999h),a		;194b	32 99 a9	2 . .
l194eh:
	ld de,(0a993h)		;194e	ed 5b 93 a9	. [ . .
	ld a,(0a999h)		;1952	3a 99 a9	: . .
	ld hl,l12c7h		;1955	21 c7 12	! . .
	rst 8			;1958	cf		.
	ld (de),a		;1959	12		.
	res 2,d			;195a	cb 92		. .
	ld a,010h		;195c	3e 10		> .
	ld (de),a		;195e	12		.
	xor a			;195f	af		.
	ld (0a99ch),a		;1960	32 9c a9	2 . .
l1963h:
	ld a,(0a980h)		;1963	3a 80 a9	: . .
	and 007h		;1966	e6 07		. .
	jr nz,l199ah		;1968	20 30		  0
	ld hl,0a9ebh		;196a	21 eb a9	! . .
	dec (hl)		;196d	35		5
	jr nz,l199ah		;196e	20 2a		  *
	ld hl,(0a993h)		;1970	2a 93 a9	* . .
	ld (hl),0f1h		;1973	36 f1		6 .
l1975h:
	ld a,03ch		;1975	3e 3c		> <
	ld (0a9ebh),a		;1977	32 eb a9	2 . .
	call sub_5634h		;197a	cd 34 56	. 4 V
	jp sub_0f1ah		;197d	c3 1a 0f	. . .
sub_1980h:
	ld (hl),000h		;1980	36 00		6 .
	xor a			;1982	af		.
	ret			;1983	c9		.
l1984h:
	ld hl,0a99ch		;1984	21 9c a9	! . .
	inc (hl)		;1987	34		4
	ld hl,(0a993h)		;1988	2a 93 a9	* . .
	res 2,h			;198b	cb 94		. .
	ld a,(0a99ch)		;198d	3a 9c a9	: . .
	bit 4,a			;1990	cb 67		. g
	jr z,l1998h		;1992	28 04		( .
	ld (hl),014h		;1994	36 14		6 .
	jr l199ah		;1996	18 02		. .
l1998h:
	ld (hl),010h		;1998	36 10		6 .
l199ah:
	ld hl,0ad20h		;199a	21 20 ad	!   .
	ld a,(0ad10h)		;199d	3a 10 ad	: . .
	or (hl)			;19a0	b6		.
	ret nz			;19a1	c0		.
	ld a,(0a9c0h)		;19a2	3a c0 a9	: . .
	and a			;19a5	a7		.
	jr nz,l19ceh		;19a6	20 26		  &
	ld a,(0a986h)		;19a8	3a 86 a9	: . .
	cp 001h			;19ab	fe 01		. .
	ret c			;19ad	d8		.
	jr z,l19c0h		;19ae	28 10		( .
	ld a,(0a9aeh)		;19b0	3a ae a9	: . .
	and 018h		;19b3	e6 18		. .
	ret z			;19b5	c8		.
	cp 008h			;19b6	fe 08		. .
	jr z,l19c8h		;19b8	28 0e		( .
	call sub_15b6h		;19ba	cd b6 15	. . .
	jp l189eh		;19bd	c3 9e 18	. . .
l19c0h:
	ld a,(0a9aeh)		;19c0	3a ae a9	: . .
	and 018h		;19c3	e6 18		. .
	cp 008h			;19c5	fe 08		. .
	ret nz			;19c7	c0		.
l19c8h:
	call sub_15b6h		;19c8	cd b6 15	. . .
	jp l3215h		;19cb	c3 15 32	. . 2
l19ceh:
	ld a,(0a9aeh)		;19ce	3a ae a9	: . .
	and 018h		;19d1	e6 18		. .
	ret z			;19d3	c8		.
	call sub_15b6h		;19d4	cd b6 15	. . .
	jp l1690h		;19d7	c3 90 16	. . .
sub_19dah:
	ld hl,0a2bch		;19da	21 bc a2	! . .
	ld b,00dh		;19dd	06 0d		. .
l19dfh:
	ld a,(hl)		;19df	7e		~
	cp 010h			;19e0	fe 10		. .
	jr z,l19e9h		;19e2	28 05		( .
	cp 005h			;19e4	fe 05		. .
	jp nz,l49fah		;19e6	c2 fa 49	. . I
l19e9h:
	ld de,0ffe0h		;19e9	11 e0 ff	. . .
	add hl,de		;19ec	19		.
	djnz l19dfh		;19ed	10 f0		. .
	ret			;19ef	c9		.
sub_19f0h:
	ld hl,RESET_VECTOR	;19f0	21 00 00	! . .
	ld (0a808h),hl		;19f3	22 08 a8	" . .
	ld (0a80ah),hl		;19f6	22 0a a8	" . .
	ld (0ad06h),hl		;19f9	22 06 ad	" . .
	xor a			;19fc	af		.
	ld (0ad0dh),a		;19fd	32 0d ad	2 . .
l1a00h:
	ld (0a8f7h),a		;1a00	32 f7 a8	2 . .
	ld (0ad05h),a		;1a03	32 05 ad	2 . .
	ld a,(0a9d6h)		;1a06	3a d6 a9	: . .
	ld (0a9d7h),a		;1a09	32 d7 a9	2 . .
	ld a,(0ad0ah)		;1a0c	3a 0a ad	: . .
	ld (0acc0h),a		;1a0f	32 c0 ac	2 . .
	xor a			;1a12	af		.
	ld (0aa81h),a		;1a13	32 81 aa	2 . .
	ld (0acc6h),a		;1a16	32 c6 ac	2 . .
	ld a,080h		;1a19	3e 80		> .
	ld (0a802h),a		;1a1b	32 02 a8	2 . .
	xor a			;1a1e	af		.
	ld (0a801h),a		;1a1f	32 01 a8	2 . .
	ld a,0ffh		;1a22	3e ff		> .
	ld (WORK_RAM),a		;1a24	32 00 a8	2 . .
	ld a,078h		;1a27	3e 78		> x
	ld (0aa41h),a		;1a29	32 41 aa	2 A .
	ld a,084h		;1a2c	3e 84		> .
	ld (0aa10h),a		;1a2e	32 10 aa	2 . .
	call sub_20afh		;1a31	cd af 20	. .  
	call sub_2755h		;1a34	cd 55 27	. U '
	ld ix,0a8c0h		;1a37	dd 21 c0 a8	. ! . .
	ld iy,0aa28h		;1a3b	fd 21 28 aa	. ! ( .
	call sub_3c0dh		;1a3f	cd 0d 3c	. . <
	ld b,007h		;1a42	06 07		. .
	ld ix,0a850h		;1a44	dd 21 50 a8	. ! P .
	ld iy,0aa1ah		;1a48	fd 21 1a aa	. ! . .
	ld ix,0a8e0h		;1a4c	dd 21 e0 a8	. ! . .
l1a50h:
	ld iy,0aa2ch		;1a50	fd 21 2c aa	. ! , .
	call sub_3dfbh		;1a54	cd fb 3d	. . =
	ld ix,0a8f0h		;1a57	dd 21 f0 a8	. ! . .
	ld iy,0aa2eh		;1a5b	fd 21 2e aa	. ! . .
	call 048adh		;1a5f	cd ad 48	. . H
l1a62h:
	call sub_2bdeh		;1a62	cd de 2b	. . +
	ld de,l0010h		;1a65	11 10 00	. . .
	add ix,de		;1a68	dd 19		. .
	inc iy			;1a6a	fd 23		. #
	inc iy			;1a6c	fd 23		. #
	djnz l1a62h		;1a6e	10 f2		. .
	call sub_1ae4h		;1a70	cd e4 1a	. . .
	ld iy,0aa28h		;1a73	fd 21 28 aa	. ! ( .
	ld (iy+000h),000h	;1a77	fd 36 00 00	. 6 . .
	ld (iy+002h),000h	;1a7b	fd 36 02 00	. 6 . .
	ld (iy+004h),000h	;1a7f	fd 36 04 00	. 6 . .
	ld (iy+006h),000h	;1a83	fd 36 06 00	. 6 . .
	ld (iy+031h),000h	;1a87	fd 36 31 00	. 6 1 .
	ld (iy+033h),000h	;1a8b	fd 36 33 00	. 6 3 .
	ld (iy+035h),000h	;1a8f	fd 36 35 00	. 6 5 .
	ld (iy+037h),000h	;1a93	fd 36 37 00	. 6 7 .
	call sub_30a5h		;1a97	cd a5 30	. . 0
l1a9ah:
	ld a,(0ad04h)		;1a9a	3a 04 ad	: . .
	rlca			;1a9d	07		.
	rlca			;1a9e	07		.
	rlca			;1a9f	07		.
	rlca			;1aa0	07		.
	and 0f0h		;1aa1	e6 f0		. .
	ld b,a			;1aa3	47		G
	ld a,(0acc0h)		;1aa4	3a c0 ac	: . .
	add a,b			;1aa7	80		.
	ld hl,l1b04h		;1aa8	21 04 1b	! . .
	rst 10h			;1aab	d7		.
	ld a,(de)		;1aac	1a		.
	ld (0a844h),a		;1aad	32 44 a8	2 D .
	inc de			;1ab0	13		.
	ld a,(de)		;1ab1	1a		.
	ld (0a837h),a		;1ab2	32 37 a8	2 7 .
	inc de			;1ab5	13		.
	ld a,(de)		;1ab6	1a		.
	ld (0a827h),a		;1ab7	32 27 a8	2 ' .
	inc de			;1aba	13		.
	ld a,(de)		;1abb	1a		.
	ld (0a817h),a		;1abc	32 17 a8	2 . .
	ld (0a814h),a		;1abf	32 14 a8	2 . .
	inc de			;1ac2	13		.
	ld a,(de)		;1ac3	1a		.
	ld (0acc1h),a		;1ac4	32 c1 ac	2 . .
	inc de			;1ac7	13		.
	ld a,(de)		;1ac8	1a		.
	ld (0acc4h),a		;1ac9	32 c4 ac	2 . .
	inc de			;1acc	13		.
	ld a,(de)		;1acd	1a		.
	ld (0a8c6h),a		;1ace	32 c6 a8	2 . .
	inc de			;1ad1	13		.
	ld a,(de)		;1ad2	1a		.
	ld (0a8d6h),a		;1ad3	32 d6 a8	2 . .
	inc de			;1ad6	13		.
	ld a,(de)		;1ad7	1a		.
	ld (0a8e6h),a		;1ad8	32 e6 a8	2 . .
	inc de			;1adb	13		.
	ld a,(de)		;1adc	1a		.
	ld (0a8f4h),a		;1add	32 f4 a8	2 . .
	ld (0a8f6h),a		;1ae0	32 f6 a8	2 . .
	ret			;1ae3	c9		.
sub_1ae4h:
	ld ix,0a810h		;1ae4	dd 21 10 a8	. ! . .
	ld a,001h		;1ae8	3e 01		> .
	ld b,017h		;1aea	06 17		. .
	ld de,l0010h		;1aec	11 10 00	. . .
l1aefh:
	ld (ix+000h),000h	;1aef	dd 36 00 00	. 6 . .
	ld (ix+00fh),a		;1af3	dd 77 0f	. w .
	inc a			;1af6	3c		<
	add ix,de		;1af7	dd 19		. .
	djnz l1aefh		;1af9	10 f4		. .
	ret			;1afb	c9		.
sub_1afch:
	ld a,(hl)		;1afc	7e		~
	ld (de),a		;1afd	12		.
	inc de			;1afe	13		.
	res 2,h			;1aff	cb 94		. .
	ld a,(hl)		;1b01	7e		~
	ld (de),a		;1b02	12		.
	ret			;1b03	c9		.
l1b04h:
	or c			;1b04	b1		.
	dec de			;1b05	1b		.
	cp e			;1b06	bb		.
	dec de			;1b07	1b		.
	push bc			;1b08	c5		.
	dec de			;1b09	1b		.
	rst 8			;1b0a	cf		.
	dec de			;1b0b	1b		.
	exx			;1b0c	d9		.
	dec de			;1b0d	1b		.
	ex (sp),hl		;1b0e	e3		.
	dec de			;1b0f	1b		.
	defb 0edh ;next byte illegal after ed	;1b10	ed		.
	dec de			;1b11	1b		.
	rst 30h			;1b12	f7		.
	dec de			;1b13	1b		.
	ld bc,00b1ch		;1b14	01 1c 0b	. . .
	inc e			;1b17	1c		.
	dec d			;1b18	15		.
	inc e			;1b19	1c		.
	rra			;1b1a	1f		.
	inc e			;1b1b	1c		.
	add hl,hl		;1b1c	29		)
	inc e			;1b1d	1c		.
	inc sp			;1b1e	33		3
	inc e			;1b1f	1c		.
	dec a			;1b20	3d		=
	inc e			;1b21	1c		.
	ld b,a			;1b22	47		G
	inc e			;1b23	1c		.
	ld d,c			;1b24	51		Q
	inc e			;1b25	1c		.
	ld e,e			;1b26	5b		[
	inc e			;1b27	1c		.
	ld h,l			;1b28	65		e
	inc e			;1b29	1c		.
	ld l,a			;1b2a	6f		o
	inc e			;1b2b	1c		.
	ld a,c			;1b2c	79		y
	inc e			;1b2d	1c		.
	add a,e			;1b2e	83		.
	inc e			;1b2f	1c		.
	adc a,l			;1b30	8d		.
	inc e			;1b31	1c		.
	sub a			;1b32	97		.
	inc e			;1b33	1c		.
	and c			;1b34	a1		.
	inc e			;1b35	1c		.
	xor e			;1b36	ab		.
	inc e			;1b37	1c		.
	or l			;1b38	b5		.
	inc e			;1b39	1c		.
	cp a			;1b3a	bf		.
	inc e			;1b3b	1c		.
	ret			;1b3c	c9		.
	inc e			;1b3d	1c		.
	out (01ch),a		;1b3e	d3 1c		. .
	defb 0ddh,01ch,0e7h ;illegal sequence	;1b40	dd 1c e7	. . .
	inc e			;1b43	1c		.
	pop af			;1b44	f1		.
	inc e			;1b45	1c		.
	ei			;1b46	fb		.
	inc e			;1b47	1c		.
	dec b			;1b48	05		.
	dec e			;1b49	1d		.
	rrca			;1b4a	0f		.
	dec e			;1b4b	1d		.
	add hl,de		;1b4c	19		.
	dec e			;1b4d	1d		.
	inc hl			;1b4e	23		#
	dec e			;1b4f	1d		.
	dec l			;1b50	2d		-
	dec e			;1b51	1d		.
	scf			;1b52	37		7
	dec e			;1b53	1d		.
	ld b,c			;1b54	41		A
	dec e			;1b55	1d		.
	ld c,e			;1b56	4b		K
	dec e			;1b57	1d		.
	ld d,l			;1b58	55		U
	dec e			;1b59	1d		.
	ld e,a			;1b5a	5f		_
	dec e			;1b5b	1d		.
	ld l,c			;1b5c	69		i
	dec e			;1b5d	1d		.
	ld (hl),e		;1b5e	73		s
	dec e			;1b5f	1d		.
	ld a,l			;1b60	7d		}
	dec e			;1b61	1d		.
	add a,a			;1b62	87		.
	dec e			;1b63	1d		.
	sub c			;1b64	91		.
	dec e			;1b65	1d		.
	sbc a,e			;1b66	9b		.
	dec e			;1b67	1d		.
	and l			;1b68	a5		.
	dec e			;1b69	1d		.
	xor a			;1b6a	af		.
	dec e			;1b6b	1d		.
	cp c			;1b6c	b9		.
	dec e			;1b6d	1d		.
	jp 0cd1dh		;1b6e	c3 1d cd	. . .
	dec e			;1b71	1d		.
	rst 10h			;1b72	d7		.
	dec e			;1b73	1d		.
	pop hl			;1b74	e1		.
	dec e			;1b75	1d		.
	ex de,hl		;1b76	eb		.
	dec e			;1b77	1d		.
	push af			;1b78	f5		.
	dec e			;1b79	1d		.
	rst 38h			;1b7a	ff		.
	dec e			;1b7b	1d		.
	add hl,bc		;1b7c	09		.
	ld e,013h		;1b7d	1e 13		. .
	ld e,01dh		;1b7f	1e 1d		. .
	ld e,027h		;1b81	1e 27		. '
	ld e,031h		;1b83	1e 31		. 1
	ld e,03bh		;1b85	1e 3b		. ;
	ld e,045h		;1b87	1e 45		. E
	ld e,04fh		;1b89	1e 4f		. O
	ld e,059h		;1b8b	1e 59		. Y
	ld e,063h		;1b8d	1e 63		. c
	ld e,06dh		;1b8f	1e 6d		. m
	ld e,077h		;1b91	1e 77		. w
	ld e,081h		;1b93	1e 81		. .
	ld e,08bh		;1b95	1e 8b		. .
	ld e,095h		;1b97	1e 95		. .
	ld e,09fh		;1b99	1e 9f		. .
	ld e,0a9h		;1b9b	1e a9		. .
	ld e,0b3h		;1b9d	1e b3		. .
	ld e,0bdh		;1b9f	1e bd		. .
	ld e,0c7h		;1ba1	1e c7		. .
	ld e,05fh		;1ba3	1e 5f		. _
	and l			;1ba5	a5		.
	inc de			;1ba6	13		.
	nop			;1ba7	00		.
	rst 10h			;1ba8	d7		.
	inc (hl)		;1ba9	34		4
	inc (hl)		;1baa	34		4
	pop af			;1bab	f1		.
	adc a,b			;1bac	88		.
	ld d,a			;1bad	57		W
	and l			;1bae	a5		.
	cp a			;1baf	bf		.
	cp c			;1bb0	b9		.
	nop			;1bb1	00		.
	jr nz,l1c04h		;1bb2	20 50		  P
	inc a			;1bb4	3c		<
	inc b			;1bb5	04		.
	ld d,b			;1bb6	50		P
	nop			;1bb7	00		.
	ld d,b			;1bb8	50		P
	jr l1c15h		;1bb9	18 5a		. Z
	ld bc,04e20h		;1bbb	01 20 4e	.   N
	inc a			;1bbe	3c		<
	inc b			;1bbf	04		.
	ld d,b			;1bc0	50		P
	nop			;1bc1	00		.
	ld c,(hl)		;1bc2	4e		N
	jr $+86			;1bc3	18 54		. T
	ld bc,l4c28h		;1bc5	01 28 4c	. ( L
	ld (06005h),a		;1bc8	32 05 60	2 . `
	ld bc,l1c4ch		;1bcb	01 4c 1c	. L .
	ld c,(hl)		;1bce	4e		N
	ld (bc),a		;1bcf	02		.
	jr z,l1c1ah		;1bd0	28 48		( H
	jr z,l1bd9h		;1bd2	28 05		( .
	ld h,b			;1bd4	60		`
	ld bc,l1c48h		;1bd5	01 48 1c	. H .
	ld c,b			;1bd8	48		H
l1bd9h:
	ld (bc),a		;1bd9	02		.
	jr nc,l1c22h		;1bda	30 46		0 F
	ld e,006h		;1bdc	1e 06		. .
	ld (hl),b		;1bde	70		p
	ld bc,01c46h		;1bdf	01 46 1c	. F .
	ld b,d			;1be2	42		B
	inc bc			;1be3	03		.
	jr nc,l1c2ah		;1be4	30 44		0 D
	ld e,006h		;1be6	1e 06		. .
	ld (hl),b		;1be8	70		p
	ld (bc),a		;1be9	02		.
	ld b,h			;1bea	44		D
	jr nz,l1c29h		;1beb	20 3c		  <
	inc bc			;1bed	03		.
	jr c,$+68		;1bee	38 42		8 B
	ld e,006h		;1bf0	1e 06		. .
	add a,b			;1bf2	80		.
	ld (bc),a		;1bf3	02		.
	ld b,d			;1bf4	42		B
	jr nz,$+56		;1bf5	20 36		  6
	inc bc			;1bf7	03		.
	jr c,l1c3ah		;1bf8	38 40		8 @
	ld e,006h		;1bfa	1e 06		. .
	add a,b			;1bfc	80		.
	ld (bc),a		;1bfd	02		.
	ld b,b			;1bfe	40		@
	jr nz,l1c31h		;1bff	20 30		  0
	inc b			;1c01	04		.
	ld b,b			;1c02	40		@
	ccf			;1c03	3f		?
l1c04h:
	ld e,007h		;1c04	1e 07		. .
	sub b			;1c06	90		.
	inc bc			;1c07	03		.
	ccf			;1c08	3f		?
	inc h			;1c09	24		$
	ld hl,(04004h)		;1c0a	2a 04 40	* . @
	ld a,01eh		;1c0d	3e 1e		> .
	rlca			;1c0f	07		.
	sub b			;1c10	90		.
	inc bc			;1c11	03		.
	ld a,024h		;1c12	3e 24		> $
	inc h			;1c14	24		$
l1c15h:
	inc b			;1c15	04		.
	ld b,b			;1c16	40		@
	dec a			;1c17	3d		=
	ld e,007h		;1c18	1e 07		. .
l1c1ah:
	and b			;1c1a	a0		.
	inc bc			;1c1b	03		.
	dec a			;1c1c	3d		=
	inc h			;1c1d	24		$
	ld e,004h		;1c1e	1e 04		. .
	ld b,b			;1c20	40		@
	inc a			;1c21	3c		<
l1c22h:
	ld e,007h		;1c22	1e 07		. .
	or b			;1c24	b0		.
	inc bc			;1c25	03		.
	inc a			;1c26	3c		<
	jr z,l1c47h		;1c27	28 1e		( .
l1c29h:
	inc b			;1c29	04		.
l1c2ah:
	ld c,b			;1c2a	48		H
	dec sp			;1c2b	3b		;
	ld e,007h		;1c2c	1e 07		. .
	ret nz			;1c2e	c0		.
	inc bc			;1c2f	03		.
	dec sp			;1c30	3b		;
l1c31h:
	jr z,l1c51h		;1c31	28 1e		( .
	inc b			;1c33	04		.
	ld c,b			;1c34	48		H
	ld a,(0071eh)		;1c35	3a 1e 07	: . .
	ret nc			;1c38	d0		.
	inc bc			;1c39	03		.
l1c3ah:
	ld a,(l1e2bh+1)		;1c3a	3a 2c 1e	: , .
	inc b			;1c3d	04		.
	ld c,b			;1c3e	48		H
	add hl,sp		;1c3f	39		9
	ld e,007h		;1c40	1e 07		. .
	ret po			;1c42	e0		.
	inc bc			;1c43	03		.
	add hl,sp		;1c44	39		9
	jr nc,$+32		;1c45	30 1e		0 .
l1c47h:
	inc b			;1c47	04		.
l1c48h:
	ld c,b			;1c48	48		H
	jr c,l1c64h		;1c49	38 19		8 .
	rlca			;1c4b	07		.
l1c4ch:
	ret p			;1c4c	f0		.
	inc bc			;1c4d	03		.
	jr c,l1c80h		;1c4e	38 30		8 0
	add hl,de		;1c50	19		.
l1c51h:
	ld bc,l4828h		;1c51	01 28 48	. ( H
	ld (l5003h+2),a		;1c54	32 05 50	2 . P
	ld bc,l005ch		;1c57	01 5c 00	. \ .
	ld e,001h		;1c5a	1e 01		. .
	jr z,l1ca6h		;1c5c	28 48		( H
	jr z,$+7		;1c5e	28 05		( .
	ld d,b			;1c60	50		P
	ld bc,l005ah		;1c61	01 5a 00	. Z .
l1c64h:
	ld e,002h		;1c64	1e 02		. .
	jr nc,l1cb0h		;1c66	30 48		0 H
	ld e,005h		;1c68	1e 05		. .
	ld h,b			;1c6a	60		`
	ld bc,l0058h		;1c6b	01 58 00	. X .
	ld e,002h		;1c6e	1e 02		. .
	jr nc,l1cbah		;1c70	30 48		0 H
	ld e,006h		;1c72	1e 06		. .
	ld h,b			;1c74	60		`
	ld bc,l0056h		;1c75	01 56 00	. V .
	ld e,002h		;1c78	1e 02		. .
	jr nc,l1cc4h		;1c7a	30 48		0 H
	ld e,006h		;1c7c	1e 06		. .
	ld (hl),b		;1c7e	70		p
	ld (bc),a		;1c7f	02		.
l1c80h:
	ld d,h			;1c80	54		T
	nop			;1c81	00		.
	ld e,003h		;1c82	1e 03		. .
	jr c,l1cc6h		;1c84	38 40		8 @
	ld e,006h		;1c86	1e 06		. .
	ld (hl),b		;1c88	70		p
	ld (bc),a		;1c89	02		.
	ld d,d			;1c8a	52		R
	nop			;1c8b	00		.
	ld e,003h		;1c8c	1e 03		. .
	jr c,l1cd0h		;1c8e	38 40		8 @
	ld e,006h		;1c90	1e 06		. .
	add a,b			;1c92	80		.
	ld (bc),a		;1c93	02		.
	ld d,b			;1c94	50		P
	nop			;1c95	00		.
	ld e,003h		;1c96	1e 03		. .
	jr c,l1cdah		;1c98	38 40		8 @
	ld e,006h		;1c9a	1e 06		. .
	add a,b			;1c9c	80		.
	ld (bc),a		;1c9d	02		.
	ld c,h			;1c9e	4c		L
	nop			;1c9f	00		.
	ld e,004h		;1ca0	1e 04		. .
	ld b,b			;1ca2	40		@
	ld b,b			;1ca3	40		@
	ld e,007h		;1ca4	1e 07		. .
l1ca6h:
	sub b			;1ca6	90		.
	ld (bc),a		;1ca7	02		.
	ld c,h			;1ca8	4c		L
	nop			;1ca9	00		.
	ld e,004h		;1caa	1e 04		. .
	ld b,b			;1cac	40		@
	ld b,b			;1cad	40		@
	ld e,007h		;1cae	1e 07		. .
l1cb0h:
	sub b			;1cb0	90		.
	ld (bc),a		;1cb1	02		.
	ld c,b			;1cb2	48		H
	nop			;1cb3	00		.
	ld e,004h		;1cb4	1e 04		. .
	ld c,b			;1cb6	48		H
	jr c,l1cd7h		;1cb7	38 1e		8 .
	rlca			;1cb9	07		.
l1cbah:
	and b			;1cba	a0		.
	ld (bc),a		;1cbb	02		.
	ld c,b			;1cbc	48		H
	nop			;1cbd	00		.
	ld e,004h		;1cbe	1e 04		. .
	ld c,b			;1cc0	48		H
	jr c,l1ce1h		;1cc1	38 1e		8 .
	rlca			;1cc3	07		.
l1cc4h:
	or b			;1cc4	b0		.
	ld (bc),a		;1cc5	02		.
l1cc6h:
	ld c,b			;1cc6	48		H
	nop			;1cc7	00		.
	ld e,004h		;1cc8	1e 04		. .
	ld c,b			;1cca	48		H
	jr c,l1cebh		;1ccb	38 1e		8 .
	rlca			;1ccd	07		.
	ret nz			;1cce	c0		.
	ld (bc),a		;1ccf	02		.
l1cd0h:
	ld c,b			;1cd0	48		H
	nop			;1cd1	00		.
	ld e,004h		;1cd2	1e 04		. .
	ld c,b			;1cd4	48		H
	jr c,$+32		;1cd5	38 1e		8 .
l1cd7h:
	rlca			;1cd7	07		.
	ret nc			;1cd8	d0		.
	ld (bc),a		;1cd9	02		.
l1cdah:
	ld c,b			;1cda	48		H
	nop			;1cdb	00		.
	ld e,004h		;1cdc	1e 04		. .
	ld d,b			;1cde	50		P
	jr c,$+32		;1cdf	38 1e		8 .
l1ce1h:
	rlca			;1ce1	07		.
	ret po			;1ce2	e0		.
	ld (bc),a		;1ce3	02		.
	ld c,b			;1ce4	48		H
	nop			;1ce5	00		.
	ld e,004h		;1ce6	1e 04		. .
	ld e,b			;1ce8	58		X
	jr nc,l1d04h		;1ce9	30 19		0 .
l1cebh:
	rlca			;1ceb	07		.
	ret p			;1cec	f0		.
	ld (bc),a		;1ced	02		.
	ld c,b			;1cee	48		H
	nop			;1cef	00		.
	add hl,de		;1cf0	19		.
	ld bc,05020h		;1cf1	01 20 50	.   P
	ld (l5003h),a		;1cf4	32 03 50	2 . P
	ld bc,l0850h		;1cf7	01 50 08	. P .
	ld e,001h		;1cfa	1e 01		. .
	jr nz,l1d4eh		;1cfc	20 50		  P
	jr z,l1d04h		;1cfe	28 04		( .
	ld d,b			;1d00	50		P
	ld bc,l0850h		;1d01	01 50 08	. P .
l1d04h:
	ld e,001h		;1d04	1e 01		. .
	jr nz,l1d58h		;1d06	20 50		  P
	ld e,004h		;1d08	1e 04		. .
	ld h,b			;1d0a	60		`
	ld bc,l0c50h		;1d0b	01 50 0c	. P .
	ld e,001h		;1d0e	1e 01		. .
	jr z,l1d62h		;1d10	28 50		( P
	ld e,004h		;1d12	1e 04		. .
	ld h,b			;1d14	60		`
	ld (bc),a		;1d15	02		.
	ld d,b			;1d16	50		P
	inc c			;1d17	0c		.
	ld e,001h		;1d18	1e 01		. .
	jr z,l1d64h		;1d1a	28 48		( H
	ld e,005h		;1d1c	1e 05		. .
	ld (hl),b		;1d1e	70		p
	ld (bc),a		;1d1f	02		.
	ld c,b			;1d20	48		H
	djnz $+32		;1d21	10 1e		. .
	ld bc,l4828h		;1d23	01 28 48	. ( H
	ld e,005h		;1d26	1e 05		. .
	add a,b			;1d28	80		.
	ld (bc),a		;1d29	02		.
	ld c,b			;1d2a	48		H
	djnz l1d4bh		;1d2b	10 1e		. .
	ld bc,04830h		;1d2d	01 30 48	. 0 H
	ld e,005h		;1d30	1e 05		. .
	sub b			;1d32	90		.
	inc bc			;1d33	03		.
	ld c,b			;1d34	48		H
	inc d			;1d35	14		.
	ld e,001h		;1d36	1e 01		. .
	jr nc,$+74		;1d38	30 48		0 H
	ld e,006h		;1d3a	1e 06		. .
	and b			;1d3c	a0		.
	inc bc			;1d3d	03		.
	ld c,b			;1d3e	48		H
	inc d			;1d3f	14		.
	ld e,002h		;1d40	1e 02		. .
	jr nc,l1d84h		;1d42	30 40		0 @
	ld e,006h		;1d44	1e 06		. .
	or b			;1d46	b0		.
	inc bc			;1d47	03		.
	ld b,b			;1d48	40		@
	jr l1d69h		;1d49	18 1e		. .
l1d4bh:
	ld (bc),a		;1d4b	02		.
	jr c,l1d8eh		;1d4c	38 40		8 @
l1d4eh:
	ld e,006h		;1d4e	1e 06		. .
	ret nz			;1d50	c0		.
	inc bc			;1d51	03		.
	ld b,b			;1d52	40		@
	jr $+32			;1d53	18 1e		. .
	ld (bc),a		;1d55	02		.
	jr c,$+66		;1d56	38 40		8 @
l1d58h:
	ld e,006h		;1d58	1e 06		. .
	ret nc			;1d5a	d0		.
	inc bc			;1d5b	03		.
	ld b,b			;1d5c	40		@
	jr $+32			;1d5d	18 1e		. .
	ld (bc),a		;1d5f	02		.
	jr c,$+66		;1d60	38 40		8 @
l1d62h:
	ld e,006h		;1d62	1e 06		. .
l1d64h:
	ret nc			;1d64	d0		.
	inc bc			;1d65	03		.
	ld b,b			;1d66	40		@
	jr $+32			;1d67	18 1e		. .
l1d69h:
	ld (bc),a		;1d69	02		.
	ld b,b			;1d6a	40		@
	jr c,l1d8bh		;1d6b	38 1e		8 .
	ld b,0e0h		;1d6d	06 e0		. .
	inc bc			;1d6f	03		.
	jr c,$+26		;1d70	38 18		8 .
	ld e,002h		;1d72	1e 02		. .
	ld c,b			;1d74	48		H
	jr c,$+32		;1d75	38 1e		8 .
	ld b,0e0h		;1d77	06 e0		. .
	inc bc			;1d79	03		.
	jr c,l1d94h		;1d7a	38 18		8 .
	ld e,002h		;1d7c	1e 02		. .
	ld d,b			;1d7e	50		P
	jr c,$+32		;1d7f	38 1e		8 .
	ld b,0f0h		;1d81	06 f0		. .
	inc bc			;1d83	03		.
l1d84h:
	jr c,l1d9eh		;1d84	38 18		8 .
	ld e,003h		;1d86	1e 03		. .
	ld e,b			;1d88	58		X
	jr nc,l1da4h		;1d89	30 19		0 .
l1d8bh:
	rlca			;1d8b	07		.
	ret p			;1d8c	f0		.
	inc bc			;1d8d	03		.
l1d8eh:
	jr nc,l1da8h		;1d8e	30 18		0 .
	add hl,de		;1d90	19		.
	ld bc,05020h		;1d91	01 20 50	.   P
l1d94h:
	ld e,004h		;1d94	1e 04		. .
	ld h,b			;1d96	60		`
	ld bc,l0050h		;1d97	01 50 00	. P .
	ld e,001h		;1d9a	1e 01		. .
	jr nz,l1deeh		;1d9c	20 50		  P
l1d9eh:
	ld e,004h		;1d9e	1e 04		. .
	ld (hl),b		;1da0	70		p
	ld bc,l0050h		;1da1	01 50 00	. P .
l1da4h:
	ld e,001h		;1da4	1e 01		. .
	jr z,l1df8h		;1da6	28 50		( P
l1da8h:
	ld e,004h		;1da8	1e 04		. .
	add a,b			;1daa	80		.
	ld bc,l0050h		;1dab	01 50 00	. P .
	ld e,001h		;1dae	1e 01		. .
	jr z,l1e02h		;1db0	28 50		( P
	ld e,005h		;1db2	1e 05		. .
	sub b			;1db4	90		.
	ld (bc),a		;1db5	02		.
	ld d,b			;1db6	50		P
	nop			;1db7	00		.
	ld e,001h		;1db8	1e 01		. .
	jr nc,l1e04h		;1dba	30 48		0 H
	ld e,005h		;1dbc	1e 05		. .
	and b			;1dbe	a0		.
	ld (bc),a		;1dbf	02		.
	ld c,b			;1dc0	48		H
	nop			;1dc1	00		.
	ld e,001h		;1dc2	1e 01		. .
	jr nc,$+74		;1dc4	30 48		0 H
	ld e,005h		;1dc6	1e 05		. .
	or b			;1dc8	b0		.
	ld (bc),a		;1dc9	02		.
	ld c,b			;1dca	48		H
	nop			;1dcb	00		.
	ld e,001h		;1dcc	1e 01		. .
	jr c,$+74		;1dce	38 48		8 H
	ld e,005h		;1dd0	1e 05		. .
	ret nz			;1dd2	c0		.
	inc bc			;1dd3	03		.
	ld c,b			;1dd4	48		H
	nop			;1dd5	00		.
	ld e,001h		;1dd6	1e 01		. .
	jr c,$+74		;1dd8	38 48		8 H
	ld e,006h		;1dda	1e 06		. .
	ret nc			;1ddc	d0		.
	inc bc			;1ddd	03		.
	ld c,b			;1dde	48		H
	nop			;1ddf	00		.
	ld e,001h		;1de0	1e 01		. .
	ld b,b			;1de2	40		@
	ld b,b			;1de3	40		@
	ld e,006h		;1de4	1e 06		. .
	ret po			;1de6	e0		.
	inc bc			;1de7	03		.
	ld b,b			;1de8	40		@
	nop			;1de9	00		.
	ld e,001h		;1dea	1e 01		. .
	ld b,b			;1dec	40		@
	ld b,b			;1ded	40		@
l1deeh:
	ld e,006h		;1dee	1e 06		. .
	ret p			;1df0	f0		.
	inc bc			;1df1	03		.
	ld b,b			;1df2	40		@
	nop			;1df3	00		.
	ld e,001h		;1df4	1e 01		. .
	ld c,b			;1df6	48		H
	ld b,b			;1df7	40		@
l1df8h:
	ld e,006h		;1df8	1e 06		. .
	ret p			;1dfa	f0		.
	inc bc			;1dfb	03		.
	ld b,b			;1dfc	40		@
	nop			;1dfd	00		.
	ld e,001h		;1dfe	1e 01		. .
	ld c,b			;1e00	48		H
l1e01h:
	ld b,b			;1e01	40		@
l1e02h:
	ld e,006h		;1e02	1e 06		. .
l1e04h:
	ret p			;1e04	f0		.
	inc bc			;1e05	03		.
	ld b,b			;1e06	40		@
	nop			;1e07	00		.
	ld e,001h		;1e08	1e 01		. .
	ld d,b			;1e0a	50		P
	jr c,l1e2bh		;1e0b	38 1e		8 .
	ld b,0f0h		;1e0d	06 f0		. .
	inc bc			;1e0f	03		.
	jr c,l1e12h		;1e10	38 00		8 .
l1e12h:
	ld e,001h		;1e12	1e 01		. .
	ld d,b			;1e14	50		P
	jr c,l1e35h		;1e15	38 1e		8 .
	ld b,0f0h		;1e17	06 f0		. .
	inc bc			;1e19	03		.
	jr c,l1e1ch		;1e1a	38 00		8 .
l1e1ch:
	ld e,001h		;1e1c	1e 01		. .
	ld e,b			;1e1e	58		X
	jr c,l1e3fh		;1e1f	38 1e		8 .
	ld b,0f0h		;1e21	06 f0		. .
	inc bc			;1e23	03		.
	jr c,l1e26h		;1e24	38 00		8 .
l1e26h:
	ld e,001h		;1e26	1e 01		. .
	ld e,b			;1e28	58		X
	jr nc,l1e44h		;1e29	30 19		0 .
l1e2bh:
	ld b,0f0h		;1e2b	06 f0		. .
	inc bc			;1e2d	03		.
	jr nc,l1e30h		;1e2e	30 00		0 .
l1e30h:
	add hl,de		;1e30	19		.
	ld bc,05020h		;1e31	01 20 50	.   P
	ld e,d			;1e34	5a		Z
l1e35h:
	inc bc			;1e35	03		.
	nop			;1e36	00		.
	ld bc,03c58h		;1e37	01 58 3c	. X <
	ld h,h			;1e3a	64		d
	ld bc,05020h		;1e3b	01 20 50	.   P
	ld e,d			;1e3e	5a		Z
l1e3fh:
	inc bc			;1e3f	03		.
	djnz l1e43h		;1e40	10 01		. .
	ld d,h			;1e42	54		T
l1e43h:
	ld b,(hl)		;1e43	46		F
l1e44h:
	ld e,d			;1e44	5a		Z
	ld bc,l5028h		;1e45	01 28 50	. ( P
	ld d,b			;1e48	50		P
	inc b			;1e49	04		.
	jr nz,l1e4dh		;1e4a	20 01		  .
	ld d,d			;1e4c	52		R
l1e4dh:
	ld d,b			;1e4d	50		P
	ld d,b			;1e4e	50		P
	ld bc,l5028h		;1e4f	01 28 50	. ( P
	ld b,(hl)		;1e52	46		F
	inc b			;1e53	04		.
	jr nc,l1e58h		;1e54	30 02		0 .
	ld d,b			;1e56	50		P
	ld e,d			;1e57	5a		Z
l1e58h:
	ld b,(hl)		;1e58	46		F
	ld bc,04830h		;1e59	01 30 48	. 0 H
	ld b,(hl)		;1e5c	46		F
	inc b			;1e5d	04		.
	ld b,b			;1e5e	40		@
	ld (bc),a		;1e5f	02		.
	ld c,(hl)		;1e60	4e		N
	ld h,h			;1e61	64		d
	ld b,(hl)		;1e62	46		F
	ld bc,04830h		;1e63	01 30 48	. 0 H
	inc a			;1e66	3c		<
	dec b			;1e67	05		.
	ld d,b			;1e68	50		P
	ld (bc),a		;1e69	02		.
	ld c,e			;1e6a	4b		K
	ld l,(hl)		;1e6b	6e		n
	inc a			;1e6c	3c		<
	ld bc,04838h		;1e6d	01 38 48	. 8 H
	inc a			;1e70	3c		<
	dec b			;1e71	05		.
	ld h,b			;1e72	60		`
	inc bc			;1e73	03		.
	ld c,b			;1e74	48		H
	ld a,b			;1e75	78		x
	inc a			;1e76	3c		<
	ld bc,04038h		;1e77	01 38 40	. 8 @
	ld (07005h),a		;1e7a	32 05 70	2 . p
	inc bc			;1e7d	03		.
	ld b,(hl)		;1e7e	46		F
	add a,d			;1e7f	82		.
	inc a			;1e80	3c		<
	ld bc,l4040h		;1e81	01 40 40	. @ @
	ld (08005h),a		;1e84	32 05 80	2 . .
	inc bc			;1e87	03		.
	ld b,h			;1e88	44		D
	adc a,h			;1e89	8c		.
	ld (l4001h),a		;1e8a	32 01 40	2 . @
	ld b,b			;1e8d	40		@
l1e8eh:
	jr z,$+7		;1e8e	28 05		( .
	sub b			;1e90	90		.
	inc bc			;1e91	03		.
	ld b,h			;1e92	44		D
	sub (hl)		;1e93	96		.
	ld (04801h),a		;1e94	32 01 48	2 . H
	ld b,b			;1e97	40		@
	jr z,$+7		;1e98	28 05		( .
	and b			;1e9a	a0		.
	inc bc			;1e9b	03		.
	ld b,d			;1e9c	42		B
	and b			;1e9d	a0		.
	ld (04801h),a		;1e9e	32 01 48	2 . H
	inc a			;1ea1	3c		<
	ld e,005h		;1ea2	1e 05		. .
	or b			;1ea4	b0		.
	inc bc			;1ea5	03		.
	ld b,d			;1ea6	42		B
	xor d			;1ea7	aa		.
	jr z,l1eabh		;1ea8	28 01		( .
	ld d,b			;1eaa	50		P
l1eabh:
	inc a			;1eab	3c		<
	ld e,005h		;1eac	1e 05		. .
	ret nz			;1eae	c0		.
	inc bc			;1eaf	03		.
	ld b,b			;1eb0	40		@
	or h			;1eb1	b4		.
	jr z,l1eb5h		;1eb2	28 01		( .
	ld d,b			;1eb4	50		P
l1eb5h:
	inc a			;1eb5	3c		<
	ld e,005h		;1eb6	1e 05		. .
	ret nc			;1eb8	d0		.
	inc bc			;1eb9	03		.
	inc a			;1eba	3c		<
	cp (hl)			;1ebb	be		.
	jr z,l1ebfh		;1ebc	28 01		( .
	ld e,b			;1ebe	58		X
l1ebfh:
	jr c,sub_1edfh		;1ebf	38 1e		8 .
	dec b			;1ec1	05		.
	ret po			;1ec2	e0		.
	inc bc			;1ec3	03		.
	jr c,l1e8eh		;1ec4	38 c8		8 .
	ld e,001h		;1ec6	1e 01		. .
	ld e,b			;1ec8	58		X
	jr nc,$+27		;1ec9	30 19		0 .
	dec b			;1ecb	05		.
	ret p			;1ecc	f0		.
	inc bc			;1ecd	03		.
	inc (hl)		;1ece	34		4
	jp nc,03a19h		;1ecf	d2 19 3a	. . :
	add a,a			;1ed2	87		.
	xor c			;1ed3	a9		.
	and a			;1ed4	a7		.
	ld hl,0a9afh		;1ed5	21 af a9	! . .
	jr nz,l1eddh		;1ed8	20 03		  .
	ld hl,0a9b0h		;1eda	21 b0 a9	! . .
l1eddh:
	ld a,(hl)		;1edd	7e		~
	ret			;1ede	c9		.
sub_1edfh:
	ld ix,WORK_RAM		;1edf	dd 21 00 a8	. ! . .
	ld iy,0aa10h		;1ee3	fd 21 10 aa	. ! . .
	ld a,(WORK_RAM)		;1ee7	3a 00 a8	: . .
	and a			;1eea	a7		.
	ret z			;1eeb	c8		.
	inc a			;1eec	3c		<
	jp nz,l2010h		;1eed	c2 10 20	. .  
	ld a,(0ad30h)		;1ef0	3a 30 ad	: 0 .
	and a			;1ef3	a7		.
	jp z,l214bh		;1ef4	ca 4b 21	. K !
	call 01ed1h		;1ef7	cd d1 1e	. . .
	and 00fh		;1efa	e6 0f		. .
	jr nz,l1f01h		;1efc	20 03		  .
	jp l1f42h		;1efe	c3 42 1f	. B .
l1f01h:
	ld hl,l1f2eh		;1f01	21 2e 1f	! . .
	rst 8			;1f04	cf		.
	ld b,a			;1f05	47		G
	ld a,(0a802h)		;1f06	3a 02 a8	: . .
	sub b			;1f09	90		.
	jp z,l1f42h		;1f0a	ca 42 1f	. B .
	ld c,a			;1f0d	4f		O
	ld a,(0ad04h)		;1f0e	3a 04 ad	: . .
	and 00fh		;1f11	e6 0f		. .
	cp 003h			;1f13	fe 03		. .
	jr nc,l1f1bh		;1f15	30 04		0 .
	ld d,003h		;1f17	16 03		. .
	jr l1f1dh		;1f19	18 02		. .
l1f1bh:
	ld d,004h		;1f1b	16 04		. .
l1f1dh:
	ld a,c			;1f1d	79		y
	add a,001h		;1f1e	c6 01		. .
	cp 003h			;1f20	fe 03		. .
	jp c,l1f3eh		;1f22	da 3e 1f	. > .
	ld a,c			;1f25	79		y
	cp 080h			;1f26	fe 80		. .
	jp nc,l1f6fh		;1f28	d2 6f 1f	. o .
	jp l1f68h		;1f2b	c3 68 1f	. h .
l1f2eh:
	nop			;1f2e	00		.
	nop			;1f2f	00		.
	add a,b			;1f30	80		.
	nop			;1f31	00		.
	ret nz			;1f32	c0		.
	ret po			;1f33	e0		.
	and b			;1f34	a0		.
	nop			;1f35	00		.
	ld b,b			;1f36	40		@
	jr nz,l1f99h		;1f37	20 60		  `
	nop			;1f39	00		.
	nop			;1f3a	00		.
	nop			;1f3b	00		.
	nop			;1f3c	00		.
	nop			;1f3d	00		.
l1f3eh:
	ld a,b			;1f3e	78		x
	ld (0a802h),a		;1f3f	32 02 a8	2 . .
l1f42h:
	ld hl,l1f55h		;1f42	21 55 1f	! U .
	push hl			;1f45	e5		.
	ld a,(0ad04h)		;1f46	3a 04 ad	: . .
	and a			;1f49	a7		.
	jp z,l594eh		;1f4a	ca 4e 59	. N Y
	cp 003h			;1f4d	fe 03		. .
	jp c,l5965h		;1f4f	da 65 59	. e Y
	jp l596bh		;1f52	c3 6b 59	. k Y
l1f55h:
	xor a			;1f55	af		.
	ld h,a			;1f56	67		g
	ld l,a			;1f57	6f		o
	sbc hl,de		;1f58	ed 52		. R
	ld (0a808h),hl		;1f5a	22 08 a8	" . .
	xor a			;1f5d	af		.
	ld h,a			;1f5e	67		g
	ld l,a			;1f5f	6f		o
	sbc hl,bc		;1f60	ed 42		. B
	ld (0a80ah),hl		;1f62	22 0a a8	" . .
	jp sub_20afh		;1f65	c3 af 20	. .  
l1f68h:
	sub d			;1f68	92		.
	add a,b			;1f69	80		.
	ld (0a802h),a		;1f6a	32 02 a8	2 . .
	jr l1f42h		;1f6d	18 d3		. .
l1f6fh:
	add a,d			;1f6f	82		.
	add a,b			;1f70	80		.
	ld (0a802h),a		;1f71	32 02 a8	2 . .
	jr l1f42h		;1f74	18 cc		. .
l1f76h:
	pop af			;1f76	f1		.
	pop af			;1f77	f1		.
	pop af			;1f78	f1		.
	pop af			;1f79	f1		.
	pop af			;1f7a	f1		.
	pop af			;1f7b	f1		.
	pop af			;1f7c	f1		.
	defb 0ddh,0f1h,0f1h ;illegal sequence	;1f7d	dd f1 f1	. . .
	pop af			;1f80	f1		.
	pop af			;1f81	f1		.
	ret p			;1f82	f0		.
	pop af			;1f83	f1		.
	pop af			;1f84	f1		.
	pop af			;1f85	f1		.
	pop af			;1f86	f1		.
	jp 0f1f1h		;1f87	c3 f1 f1	. . .
	pop af			;1f8a	f1		.
	pop af			;1f8b	f1		.
	jp pe,0f1f1h		;1f8c	ea f1 f1	. . .
	pop af			;1f8f	f1		.
	pop af			;1f90	f1		.
	pop af			;1f91	f1		.
	pop af			;1f92	f1		.
	pop af			;1f93	f1		.
l1f94h:
	pop af			;1f94	f1		.
	pop af			;1f95	f1		.
	or a			;1f96	b7		.
	pop af			;1f97	f1		.
	pop af			;1f98	f1		.
l1f99h:
	pop af			;1f99	f1		.
	pop af			;1f9a	f1		.
	ld c,l			;1f9b	4d		M
	pop af			;1f9c	f1		.
	pop af			;1f9d	f1		.
	pop af			;1f9e	f1		.
	push hl			;1f9f	e5		.
	dec l			;1fa0	2d		-
	ld l,(hl)		;1fa1	6e		n
	pop af			;1fa2	f1		.
	pop af			;1fa3	f1		.
	ld e,(hl)		;1fa4	5e		^
	ld h,c			;1fa5	61		a
	and 0f1h		;1fa6	e6 f1		. .
	pop af			;1fa8	f1		.
	pop af			;1fa9	f1		.
	or d			;1faa	b2		.
	pop af			;1fab	f1		.
	pop af			;1fac	f1		.
	pop af			;1fad	f1		.
	pop af			;1fae	f1		.
	ld d,e			;1faf	53		S
	pop af			;1fb0	f1		.
	pop af			;1fb1	f1		.
l1fb2h:
	pop af			;1fb2	f1		.
	pop af			;1fb3	f1		.
	sub l			;1fb4	95		.
	pop af			;1fb5	f1		.
	pop af			;1fb6	f1		.
	pop af			;1fb7	f1		.
	ld b,l			;1fb8	45		E
	jp z,0f1f1h		;1fb9	ca f1 f1	. . .
	pop af			;1fbc	f1		.
	add a,02ch		;1fbd	c6 2c		. ,
	sub a			;1fbf	97		.
	pop af			;1fc0	f1		.
	pop af			;1fc1	f1		.
	add a,c			;1fc2	81		.
	ld l,c			;1fc3	69		i
	ld e,0f1h		;1fc4	1e f1		. .
	pop af			;1fc6	f1		.
	cp h			;1fc7	bc		.
	and c			;1fc8	a1		.
	ld h,b			;1fc9	60		`
	pop af			;1fca	f1		.
	pop af			;1fcb	f1		.
	call p,0f1ebh		;1fcc	f4 eb f1	. . .
	pop af			;1fcf	f1		.
l1fd0h:
	pop af			;1fd0	f1		.
	pop af			;1fd1	f1		.
	ld c,b			;1fd2	48		H
	pop af			;1fd3	f1		.
	pop af			;1fd4	f1		.
	pop af			;1fd5	f1		.
	ret po			;1fd6	e0		.
	ld h,e			;1fd7	63		c
	dec (hl)		;1fd8	35		5
	pop af			;1fd9	f1		.
	pop af			;1fda	f1		.
	xor d			;1fdb	aa		.
	or h			;1fdc	b4		.
	adc a,d			;1fdd	8a		.
	pop af			;1fde	f1		.
	pop af			;1fdf	f1		.
	ld d,c			;1fe0	51		Q
	jp (hl)			;1fe1	e9		.
	or 0f1h			;1fe2	f6 f1		. .
	pop af			;1fe4	f1		.
	add a,d			;1fe5	82		.
	sub d			;1fe6	92		.
	sbc a,b			;1fe7	98		.
	pop af			;1fe8	f1		.
	pop af			;1fe9	f1		.
	pop af			;1fea	f1		.
	ld b,(hl)		;1feb	46		F
	pop af			;1fec	f1		.
	pop af			;1fed	f1		.
l1feeh:
	pop af			;1fee	f1		.
	pop af			;1fef	f1		.
	pop af			;1ff0	f1		.
	pop af			;1ff1	f1		.
	pop af			;1ff2	f1		.
	pop af			;1ff3	f1		.
	pop af			;1ff4	f1		.
	pop af			;1ff5	f1		.
	pop af			;1ff6	f1		.
	pop af			;1ff7	f1		.
	pop af			;1ff8	f1		.
	pop af			;1ff9	f1		.
	pop af			;1ffa	f1		.
	pop af			;1ffb	f1		.
	pop af			;1ffc	f1		.
	pop af			;1ffd	f1		.
	pop af			;1ffe	f1		.
l1fffh:
	pop af			;1fff	f1		.
	pop af			;2000	f1		.
l2001h:
	pop af			;2001	f1		.
	pop af			;2002	f1		.
	pop af			;2003	f1		.
	pop af			;2004	f1		.
	pop af			;2005	f1		.
	pop af			;2006	f1		.
	pop af			;2007	f1		.
	pop af			;2008	f1		.
	pop af			;2009	f1		.
	pop af			;200a	f1		.
	pop af			;200b	f1		.
sub_200ch:
	add hl,de		;200c	19		.
	rst 18h			;200d	df		.
	ld a,b			;200e	78		x
	ret			;200f	c9		.
l2010h:
	ld a,(ix+000h)		;2010	dd 7e 00	. ~ .
	cp 0b4h			;2013	fe b4		. .
	jr c,l2040h		;2015	38 29		8 )
	ld (ix+000h),0b4h	;2017	dd 36 00 b4	. 6 . .
	ld (iy+001h),0ffh	;201b	fd 36 01 ff	. 6 . .
	ld a,(0ad04h)		;201f	3a 04 ad	: . .
	cp 002h			;2022	fe 02		. .
	call nc,sub_5679h	;2024	d4 79 56	. y V
	call sub_56d2h		;2027	cd d2 56	. . V
	ld a,(0abfeh)		;202a	3a fe ab	: . .
	cp 0a5h			;202d	fe a5		. .
	jp nz,l2063h		;202f	c2 63 20	. c  
	ld de,0abffh		;2032	11 ff ab	. . .
	ld a,(de)		;2035	1a		.
	cp 005h			;2036	fe 05		. .
	jp z,l2040h		;2038	ca 40 20	. @  
	cp 010h			;203b	fe 10		. .
	jp nz,l2063h		;203d	c2 63 20	. c  
l2040h:
	dec (ix+000h)		;2040	dd 35 00	. 5 .
	ld a,(ix+000h)		;2043	dd 7e 00	. ~ .
	cp 0b3h			;2046	fe b3		. .
	jr z,l2066h		;2048	28 1c		( .
	cp 0abh			;204a	fe ab		. .
	jr z,l206bh		;204c	28 1d		( .
	cp 0a3h			;204e	fe a3		. .
	jr z,l2070h		;2050	28 1e		( .
	cp 09bh			;2052	fe 9b		. .
	jr z,l2075h		;2054	28 1f		( .
	cp 093h			;2056	fe 93		. .
	jr z,l207ah		;2058	28 20		(  
	cp 08bh			;205a	fe 8b		. .
	jr z,l207fh		;205c	28 21		( !
	cp 083h			;205e	fe 83		. .
	jr z,l2084h		;2060	28 22		( "
	ret			;2062	c9		.
l2063h:
	jp l1f2eh		;2063	c3 2e 1f	. . .
l2066h:
	ld de,l1f76h		;2066	11 76 1f	. v .
	jr l2089h		;2069	18 1e		. .
l206bh:
	ld de,l1f94h		;206b	11 94 1f	. . .
	jr l2089h		;206e	18 19		. .
l2070h:
	ld de,l1fb2h		;2070	11 b2 1f	. . .
	jr l2089h		;2073	18 14		. .
l2075h:
	ld de,l1fd0h		;2075	11 d0 1f	. . .
	jr l2089h		;2078	18 0f		. .
l207ah:
	ld de,l1fd0h		;207a	11 d0 1f	. . .
	jr l2089h		;207d	18 0a		. .
l207fh:
	ld de,l1fb2h		;207f	11 b2 1f	. . .
	jr l2089h		;2082	18 05		. .
l2084h:
	ld de,l1feeh		;2084	11 ee 1f	. . .
	jr l2089h		;2087	18 00		. .
l2089h:
	ld hl,0a5afh		;2089	21 af a5	! . .
	ld b,0c1h		;208c	06 c1		. .
	ld a,(0ad04h)		;208e	3a 04 ad	: . .
	add a,b			;2091	80		.
	ld c,a			;2092	4f		O
	exx			;2093	d9		.
	ld a,(0337ah)		;2094	3a 7a 33	: z 3
	ld b,a			;2097	47		G
l2098h:
	exx			;2098	d9		.
	ld a,(l4902h)		;2099	3a 02 49	: . I
	ld b,a			;209c	47		G
l209dh:
	ld a,(de)		;209d	1a		.
	ld (hl),a		;209e	77		w
	res 2,h			;209f	cb 94		. .
	ld (hl),c		;20a1	71		q
	set 2,h			;20a2	cb d4		. .
	inc hl			;20a4	23		#
	inc de			;20a5	13		.
	djnz l209dh		;20a6	10 f5		. .
	ld a,01bh		;20a8	3e 1b		> .
	rst 18h			;20aa	df		.
	exx			;20ab	d9		.
	djnz l2098h		;20ac	10 ea		. .
	ret			;20ae	c9		.
sub_20afh:
	ld ix,WORK_RAM		;20af	dd 21 00 a8	. ! . .
	ld de,l0020h		;20b3	11 20 00	.   .
	ld a,(0a802h)		;20b6	3a 02 a8	: . .
	add a,004h		;20b9	c6 04		. .
	rrca			;20bb	0f		.
	rrca			;20bc	0f		.
	rrca			;20bd	0f		.
	and 01fh		;20be	e6 1f		. .
	ld hl,l20ceh		;20c0	21 ce 20	! .  
	rst 18h			;20c3	df		.
	ld a,(hl)		;20c4	7e		~
	ld (0aa11h),a		;20c5	32 11 aa	2 . .
	add hl,de		;20c8	19		.
	ld a,(hl)		;20c9	7e		~
	ld (0aa40h),a		;20ca	32 40 aa	2 @ .
	ret			;20cd	c9		.
l20ceh:
	ret p			;20ce	f0		.
	pop af			;20cf	f1		.
	jp p,0f4f3h		;20d0	f2 f3 f4	. . .
	push af			;20d3	f5		.
	or 0f7h			;20d4	f6 f7		. .
	ret pe			;20d6	e8		.
	rst 30h			;20d7	f7		.
	or 0f5h			;20d8	f6 f5		. .
	call p,0f2f3h		;20da	f4 f3 f2	. . .
	pop af			;20dd	f1		.
	ret p			;20de	f0		.
	rst 28h			;20df	ef		.
	xor 0edh		;20e0	ee ed		. .
	call pe,0eaebh		;20e2	ec eb ea	. . .
	jp (hl)			;20e5	e9		.
	ret pe			;20e6	e8		.
	jp (hl)			;20e7	e9		.
	jp pe,0ecebh		;20e8	ea eb ec	. . .
	defb 0edh ;next byte illegal after ed	;20eb	ed		.
	xor 0efh		;20ec	ee ef		. .
	ld b,b			;20ee	40		@
	ld b,b			;20ef	40		@
	ld b,b			;20f0	40		@
	ld b,b			;20f1	40		@
	ld b,b			;20f2	40		@
	ld b,b			;20f3	40		@
	ld b,b			;20f4	40		@
	ld b,b			;20f5	40		@
	add a,b			;20f6	80		.
	ret nz			;20f7	c0		.
	ret nz			;20f8	c0		.
	ret nz			;20f9	c0		.
	ret nz			;20fa	c0		.
	ret nz			;20fb	c0		.
	ret nz			;20fc	c0		.
	ret nz			;20fd	c0		.
	ret nz			;20fe	c0		.
l20ffh:
	ret nz			;20ff	c0		.
	ret nz			;2100	c0		.
	ret nz			;2101	c0		.
l2102h:
	ret nz			;2102	c0		.
l2103h:
	ret nz			;2103	c0		.
	ret nz			;2104	c0		.
	ret nz			;2105	c0		.
	ld b,b			;2106	40		@
	ld b,b			;2107	40		@
	ld b,b			;2108	40		@
	ld b,b			;2109	40		@
	ld b,b			;210a	40		@
sub_210bh:
	ld b,b			;210b	40		@
	ld b,b			;210c	40		@
	ld b,b			;210d	40		@
sub_210eh:
	ld hl,0adf3h		;210e	21 f3 ad	! . .
	ex de,hl		;2111	eb		.
	ld a,(0ad14h)		;2112	3a 14 ad	: . .
	and a			;2115	a7		.
	jr z,l2140h		;2116	28 28		( (
	cp 003h			;2118	fe 03		. .
	jr z,l2140h		;211a	28 24		( $
	cp 001h			;211c	fe 01		. .
	jr z,l2145h		;211e	28 25		( %
	ld hl,l22fah		;2120	21 fa 22	! . "
l2123h:
	ld a,(hl)		;2123	7e		~
	inc a			;2124	3c		<
	ld (0adf2h),a		;2125	32 f2 ad	2 . .
	ex de,hl		;2128	eb		.
	ld (hl),e		;2129	73		s
	inc l			;212a	2c		,
	ld (hl),d		;212b	72		r
	ld hl,0adfbh		;212c	21 fb ad	! . .
	ld a,(hl)		;212f	7e		~
	cp 0fdh			;2130	fe fd		. .
	jp nz,l213dh		;2132	c2 3d 21	. = !
	inc hl			;2135	23		#
	ld a,(hl)		;2136	7e		~
	cp 010h			;2137	fe 10		. .
	ret z			;2139	c8		.
	cp 005h			;213a	fe 05		. .
	ret z			;213c	c8		.
l213dh:
	jp l2251h		;213d	c3 51 22	. Q "
l2140h:
	ld hl,l218ch		;2140	21 8c 21	! . !
	jr l2123h		;2143	18 de		. .
l2145h:
	ld hl,l2251h		;2145	21 51 22	! Q "
	jr l2123h		;2148	18 d9		. .
	ret			;214a	c9		.
l214bh:
	ld hl,0adf2h		;214b	21 f2 ad	! . .
	ld a,(hl)		;214e	7e		~
	ld b,a			;214f	47		G
	and 03fh		;2150	e6 3f		. ?
	jr z,l215bh		;2152	28 07		( .
	dec a			;2154	3d		=
	jr z,l215bh		;2155	28 04		( .
	dec b			;2157	05		.
	ld (hl),b		;2158	70		p
	jr l216ah		;2159	18 0f		. .
l215bh:
	inc hl			;215b	23		#
	ld e,(hl)		;215c	5e		^
	inc hl			;215d	23		#
	ld d,(hl)		;215e	56		V
	inc de			;215f	13		.
	ld (hl),d		;2160	72		r
	dec hl			;2161	2b		+
	ld (hl),e		;2162	73		s
	ex de,hl		;2163	eb		.
	ld a,(hl)		;2164	7e		~
	dec de			;2165	1b		.
	inc a			;2166	3c		<
	ld (de),a		;2167	12		.
	jr l214bh		;2168	18 e1		. .
l216ah:
	ld a,b			;216a	78		x
	exx			;216b	d9		.
	rlca			;216c	07		.
	rlca			;216d	07		.
	and 003h		;216e	e6 03		. .
	jp z,l1f42h		;2170	ca 42 1f	. B .
	dec a			;2173	3d		=
	jr z,l2181h		;2174	28 0b		( .
	ld a,(0a802h)		;2176	3a 02 a8	: . .
	add a,003h		;2179	c6 03		. .
	ld (0a802h),a		;217b	32 02 a8	2 . .
	jp l1f42h		;217e	c3 42 1f	. B .
l2181h:
	ld a,(0a802h)		;2181	3a 02 a8	: . .
	sub 003h		;2184	d6 03		. .
	ld (0a802h),a		;2186	32 02 a8	2 . .
	jp l1f42h		;2189	c3 42 1f	. B .
l218ch:
	inc a			;218c	3c		<
	inc a			;218d	3c		<
	inc a			;218e	3c		<
	inc a			;218f	3c		<
	dec bc			;2190	0b		.
	sub l			;2191	95		.
	inc bc			;2192	03		.
	ld h,(hl)		;2193	66		f
	sub l			;2194	95		.
	ld a,h			;2195	7c		|
	ld e,c			;2196	59		Y
	adc a,l			;2197	8d		.
	ld c,e			;2198	4b		K
	adc a,(hl)		;2199	8e		.
	ld c,d			;219a	4a		J
	ld (bc),a		;219b	02		.
	adc a,e			;219c	8b		.
	ld a,(de)		;219d	1a		.
	ld d,l			;219e	55		U
	ld c,08ah		;219f	0e 8a		. .
	ld a,h			;21a1	7c		|
	ld c,(hl)		;21a2	4e		N
	dec b			;21a3	05		.
	adc a,d			;21a4	8a		.
	dec bc			;21a5	0b		.
	add a,(hl)		;21a6	86		.
	ld b,(hl)		;21a7	46		F
	inc bc			;21a8	03		.
	ld c,d			;21a9	4a		J
	dec c			;21aa	0d		.
	ld a,h			;21ab	7c		|
	ld e,d			;21ac	5a		Z
	ld (hl),0abh		;21ad	36 ab		6 .
	ex af,af'		;21af	08		.
	ld d,l			;21b0	55		U
	ex af,af'		;21b1	08		.
	ld d,(hl)		;21b2	56		V
	ld bc,0054ah		;21b3	01 4a 05	. J .
	ld d,(hl)		;21b6	56		V
	inc bc			;21b7	03		.
	ld a,h			;21b8	7c		|
	ld c,l			;21b9	4d		M
	cp h			;21ba	bc		.
	add a,e			;21bb	83		.
	ld a,(bc)		;21bc	0a		.
	ld c,e			;21bd	4b		K
	rlca			;21be	07		.
	cp h			;21bf	bc		.
	add a,c			;21c0	81		.
	ld (hl),d		;21c1	72		r
	ld (bc),a		;21c2	02		.
	ld d,(hl)		;21c3	56		V
sub_21c4h:
	ld (bc),a		;21c4	02		.
	ld l,d			;21c5	6a		j
	ld bc,l3b95h		;21c6	01 95 3b	. . ;
	adc a,b			;21c9	88		.
	ld d,e			;21ca	53		S
	inc bc			;21cb	03		.
	cp h			;21cc	bc		.
	sub l			;21cd	95		.
	ld b,(hl)		;21ce	46		F
	dec bc			;21cf	0b		.
	sub l			;21d0	95		.
	inc b			;21d1	04		.
	and b			;21d2	a0		.
	inc c			;21d3	0c		.
	ld c,d			;21d4	4a		J
	ld (bc),a		;21d5	02		.
	ld d,(hl)		;21d6	56		V
	inc bc			;21d7	03		.
	ld d,l			;21d8	55		U
	ld bc,l0395h		;21d9	01 95 03	. . .
	ld c,d			;21dc	4a		J
	inc b			;21dd	04		.
	adc a,d			;21de	8a		.
	ld (bc),a		;21df	02		.
	ld c,d			;21e0	4a		J
	ld (bc),a		;21e1	02		.
	adc a,d			;21e2	8a		.
	add hl,hl		;21e3	29		)
	adc a,e			;21e4	8b		.
	ld b,04bh		;21e5	06 4b		. K
	ld d,04ah		;21e7	16 4a		. J
	ld bc,00d95h		;21e9	01 95 0d	. . .
	adc a,b			;21ec	88		.
	ld d,e			;21ed	53		S
	ld bc,l0f6ah		;21ee	01 6a 0f	. j .
	adc a,d			;21f1	8a		.
	ex af,af'		;21f2	08		.
	adc a,e			;21f3	8b		.
	dec c			;21f4	0d		.
	ld c,e			;21f5	4b		K
	ex af,af'		;21f6	08		.
	adc a,e			;21f7	8b		.
	rlca			;21f8	07		.
	ld d,l			;21f9	55		U
	ld (bc),a		;21fa	02		.
l21fbh:
	ld l,c			;21fb	69		i
	adc a,c			;21fc	89		.
l21fdh:
	inc bc			;21fd	03		.
	ld c,e			;21fe	4b		K
l21ffh:
	ld bc,06f7ch		;21ff	01 7c 6f	. | o
	dec b			;2202	05		.
	adc a,e			;2203	8b		.
	ld c,e			;2204	4b		K
	dec c			;2205	0d		.
	adc a,e			;2206	8b		.
	ld bc,0834eh		;2207	01 4e 83	. N .
	ld bc,00f8bh		;220a	01 8b 0f	. . .
	ld d,l			;220d	55		U
	dec b			;220e	05		.
	and d			;220f	a2		.
	ld b,d			;2210	42		B
	djnz l2273h		;2211	10 60		. `
	ld h,04bh		;2213	26 4b		& K
	ld (bc),a		;2215	02		.
	adc a,e			;2216	8b		.
	ex af,af'		;2217	08		.
	ld c,e			;2218	4b		K
	dec b			;2219	05		.
	adc a,a			;221a	8f		.
	ld c,a			;221b	4f		O
	ld bc,l1795h		;221c	01 95 17	. . .
	ld c,d			;221f	4a		J
	ld c,08ah		;2220	0e 8a		. .
	inc b			;2222	04		.
	and b			;2223	a0		.
	dec de			;2224	1b		.
	adc a,e			;2225	8b		.
	ld de,l0a4bh		;2226	11 4b 0a	. K .
	ld d,d			;2229	52		R
	sub a			;222a	97		.
	ld c,l			;222b	4d		M
	adc a,a			;222c	8f		.
	ld b,a			;222d	47		G
	ld b,08bh		;222e	06 8b		. .
	ld (bc),a		;2230	02		.
	ld d,l			;2231	55		U
	inc bc			;2232	03		.
	sbc a,l			;2233	9d		.
	ld h,a			;2234	67		g
	adc a,d			;2235	8a		.
	ld a,(bc)		;2236	0a		.
	ld d,(hl)		;2237	56		V
	dec b			;2238	05		.
	adc a,e			;2239	8b		.
	ld (bc),a		;223a	02		.
	ld c,b			;223b	48		H
	adc a,b			;223c	88		.
	inc bc			;223d	03		.
	ld d,l			;223e	55		U
	add hl,bc		;223f	09		.
	ld h,b			;2240	60		`
	inc bc			;2241	03		.
	halt			;2242	76		v
	inc de			;2243	13		.
	adc a,e			;2244	8b		.
	inc h			;2245	24		$
	ld c,e			;2246	4b		K
	cpl			;2247	2f		/
	adc a,e			;2248	8b		.
	dec b			;2249	05		.
l224ah:
	adc a,e			;224a	8b		.
	ex af,af'		;224b	08		.
	adc a,d			;224c	8a		.
	dec d			;224d	15		.
	sub (hl)		;224e	96		.
	inc a			;224f	3c		<
	inc a			;2250	3c		<
l2251h:
	inc a			;2251	3c		<
	inc a			;2252	3c		<
	inc a			;2253	3c		<
	inc a			;2254	3c		<
	ld a,(bc)		;2255	0a		.
	sub l			;2256	95		.
	ld h,b			;2257	60		`
	inc b			;2258	04		.
	sbc a,(hl)		;2259	9e		.
	ld d,e			;225a	53		S
	dec c			;225b	0d		.
	adc a,e			;225c	8b		.
	ld (bc),a		;225d	02		.
	ld c,e			;225e	4b		K
	rrca			;225f	0f		.
	sub e			;2260	93		.
	ld d,e			;2261	53		S
	rlca			;2262	07		.
	xor c			;2263	a9		.
	ld d,h			;2264	54		T
	ld a,(bc)		;2265	0a		.
	sub (hl)		;2266	96		.
	inc bc			;2267	03		.
	ld h,b			;2268	60		`
	rrca			;2269	0f		.
	adc a,d			;226a	8a		.
	inc hl			;226b	23		#
	ld c,b			;226c	48		H
	cp c			;226d	b9		.
	ld (bc),a		;226e	02		.
	add a,d			;226f	82		.
	ld e,c			;2270	59		Y
	sbc a,a			;2271	9f		.
	ld e,c			;2272	59		Y
l2273h:
	ld bc,l228bh		;2273	01 8b 22	. . "
	xor e			;2276	ab		.
	ld (bc),a		;2277	02		.
	ld c,e			;2278	4b		K
	ld (bc),a		;2279	02		.
	adc a,e			;227a	8b		.
	rlca			;227b	07		.
	ld d,l			;227c	55		U
	xor h			;227d	ac		.
	ld b,d			;227e	42		B
	ld bc,09050h		;227f	01 50 90	. P .
	ld (bc),a		;2282	02		.
	ld d,l			;2283	55		U
	dec (hl)		;2284	35		5
	sub b			;2285	90		.
	ld d,b			;2286	50		P
	inc b			;2287	04		.
	sub d			;2288	92		.
	ld e,e			;2289	5b		[
	adc a,c			;228a	89		.
l228bh:
	rra			;228b	1f		.
	ld c,b			;228c	48		H
	adc a,b			;228d	88		.
	dec b			;228e	05		.
	adc a,h			;228f	8c		.
	ld b,d			;2290	42		B
	dec b			;2291	05		.
	ld c,d			;2292	4a		J
	inc a			;2293	3c		<
	inc c			;2294	0c		.
	ld b,(hl)		;2295	46		F
	add a,(hl)		;2296	86		.
	inc a			;2297	3c		<
	inc b			;2298	04		.
	sub e			;2299	93		.
	ld e,(hl)		;229a	5e		^
	ld b,04bh		;229b	06 4b		. K
	add hl,bc		;229d	09		.
	ld c,d			;229e	4a		J
	ld a,(bc)		;229f	0a		.
	ld a,h			;22a0	7c		|
	ld a,h			;22a1	7c		|
	ld l,a			;22a2	6f		o
	cp h			;22a3	bc		.
	ld bc,0078bh		;22a4	01 8b 07	. . .
	sub d			;22a7	92		.
	ld c,b			;22a8	48		H
	rlca			;22a9	07		.
	adc a,b			;22aa	88		.
	ld a,h			;22ab	7c		|
	ld a,h			;22ac	7c		|
	ld b,l			;22ad	45		E
	ld de,05090h		;22ae	11 90 50	. . P
	ld bc,0078bh		;22b1	01 8b 07	. . .
	ld c,e			;22b4	4b		K
	inc c			;22b5	0c		.
	adc a,e			;22b6	8b		.
	ld a,(bc)		;22b7	0a		.
	halt			;22b8	76		v
	xor e			;22b9	ab		.
	ld (de),a		;22ba	12		.
	add a,a			;22bb	87		.
	ld b,a			;22bc	47		G
	jr l224ah		;22bd	18 8b		. .
	inc bc			;22bf	03		.
	adc a,d			;22c0	8a		.
	ld (bc),a		;22c1	02		.
	sub (hl)		;22c2	96		.
	ex af,af'		;22c3	08		.
	ld c,e			;22c4	4b		K
	ld (bc),a		;22c5	02		.
	adc a,e			;22c6	8b		.
	rlca			;22c7	07		.
	sub l			;22c8	95		.
	inc a			;22c9	3c		<
	inc a			;22ca	3c		<
	rla			;22cb	17		.
	ld d,l			;22cc	55		U
	inc a			;22cd	3c		<
	dec b			;22ce	05		.
	ld d,(hl)		;22cf	56		V
	jr nz,l234eh		;22d0	20 7c		  |
	ld b,h			;22d2	44		D
	ld b,067h		;22d3	06 67		. g
	cp h			;22d5	bc		.
	ld c,l			;22d6	4d		M
	adc a,(hl)		;22d7	8e		.
	inc c			;22d8	0c		.
	ld d,(hl)		;22d9	56		V
	ld (bc),a		;22da	02		.
	ld c,d			;22db	4a		J
	ld a,(de)		;22dc	1a		.
	ld c,e			;22dd	4b		K
	add hl,sp		;22de	39		9
	ld d,l			;22df	55		U
	dec h			;22e0	25		%
	ld d,(hl)		;22e1	56		V
	jr nz,$+87		;22e2	20 55		  U
	dec bc			;22e4	0b		.
	ld c,e			;22e5	4b		K
	inc bc			;22e6	03		.
	ld h,b			;22e7	60		`
	ld b,04ah		;22e8	06 4a		. J
	inc bc			;22ea	03		.
	ld b,c			;22eb	41		A
	ld bc,09fbch		;22ec	01 bc 9f	. . .
	ld d,b			;22ef	50		P
	inc b			;22f0	04		.
	sub (hl)		;22f1	96		.
	rrca			;22f2	0f		.
	ld c,e			;22f3	4b		K
	rlca			;22f4	07		.
	adc a,e			;22f5	8b		.
	inc a			;22f6	3c		<
	inc a			;22f7	3c		<
	inc a			;22f8	3c		<
	inc a			;22f9	3c		<
l22fah:
	inc a			;22fa	3c		<
	inc a			;22fb	3c		<
	inc a			;22fc	3c		<
	inc a			;22fd	3c		<
	ld (bc),a		;22fe	02		.
	sub b			;22ff	90		.
	ld b,l			;2300	45		E
	ld (bc),a		;2301	02		.
	ld c,e			;2302	4b		K
	ld (bc),a		;2303	02		.
	ld c,b			;2304	48		H
	adc a,b			;2305	88		.
	rlca			;2306	07		.
	adc a,d			;2307	8a		.
	ld d,l			;2308	55		U
	ld bc,l014ah		;2309	01 4a 01	. J .
	ld e,b			;230c	58		X
	add a,d			;230d	82		.
	inc bc			;230e	03		.
	adc a,d			;230f	8a		.
	ld e,a			;2310	5f		_
	ld bc,l0760h		;2311	01 60 07	. ` .
	or d			;2314	b2		.
	ld d,d			;2315	52		R
	inc bc			;2316	03		.
	ld b,(hl)		;2317	46		F
	add a,(hl)		;2318	86		.
	ld e,049h		;2319	1e 49		. I
	adc a,c			;231b	89		.
	ex af,af'		;231c	08		.
	ld c,e			;231d	4b		K
	ld bc,04994h		;231e	01 94 49	. . I
	dec b			;2321	05		.
l2322h:
	adc a,d			;2322	8a		.
	ld c,d			;2323	4a		J
	inc a			;2324	3c		<
	inc a			;2325	3c		<
	ld a,(bc)		;2326	0a		.
	cp h			;2327	bc		.
	add a,h			;2328	84		.
	ld de,08853h		;2329	11 53 88	. S .
	ld bc,00b4ah		;232c	01 4a 0b	. J .
	ld l,e			;232f	6b		k
	ld b,04bh		;2330	06 4b		. K
	inc h			;2332	24		$
	ld c,d			;2333	4a		J
	ld de,l0856h		;2334	11 56 08	. V .
	ld c,d			;2337	4a		J
	ld c,04bh		;2338	0e 4b		. K
	rlca			;233a	07		.
	ld d,l			;233b	55		U
	rlca			;233c	07		.
	ld c,e			;233d	4b		K
	rlca			;233e	07		.
	ld a,h			;233f	7c		|
	ld (hl),d		;2340	72		r
	adc a,(hl)		;2341	8e		.
	ld bc,044afh		;2342	01 af 44	. . D
	ld (bc),a		;2345	02		.
	ld d,(hl)		;2346	56		V
	adc a,e			;2347	8b		.
	inc b			;2348	04		.
	ld e,d			;2349	5a		Z
	add a,l			;234a	85		.
	ld (bc),a		;234b	02		.
	adc a,d			;234c	8a		.
	ld (bc),a		;234d	02		.
l234eh:
	sub b			;234e	90		.
	ld b,l			;234f	45		E
	add hl,bc		;2350	09		.
	adc a,e			;2351	8b		.
	ld bc,08948h		;2352	01 48 89	. H .
	ld b,c			;2355	41		A
	ld (bc),a		;2356	02		.
	ld c,e			;2357	4b		K
	dec b			;2358	05		.
	or l			;2359	b5		.
	djnz l23a9h		;235a	10 4d		. M
	add a,e			;235c	83		.
	inc bc			;235d	03		.
	or l			;235e	b5		.
	ld c,e			;235f	4b		K
	inc bc			;2360	03		.
	and b			;2361	a0		.
	rlca			;2362	07		.
	ld (hl),d		;2363	72		r
	adc a,b			;2364	88		.
	ex af,af'		;2365	08		.
	ld c,e			;2366	4b		K
	ld bc,08550h		;2367	01 50 85	. P .
	inc bc			;236a	03		.
	adc a,e			;236b	8b		.
	ld (bc),a		;236c	02		.
	ld d,l			;236d	55		U
	dec b			;236e	05		.
	sub l			;236f	95		.
	ld b,060h		;2370	06 60		. `
	ld b,055h		;2372	06 55		. U
	ld bc,0094bh		;2374	01 4b 09	. K .
	ld c,b			;2377	48		H
	adc a,a			;2378	8f		.
	ld b,a			;2379	47		G
	inc bc			;237a	03		.
	ld c,e			;237b	4b		K
	ld bc,00796h		;237c	01 96 07	. . .
	adc a,d			;237f	8a		.
	dec b			;2380	05		.
	ld l,d			;2381	6a		j
	jr l23cfh		;2382	18 4b		. K
	ld a,(bc)		;2384	0a		.
	adc a,e			;2385	8b		.
	ld b,08ah		;2386	06 8a		. .
	ld (bc),a		;2388	02		.
	ld b,h			;2389	44		D
	add a,h			;238a	84		.
	ld b,08bh		;238b	06 8b		. .
	ex af,af'		;238d	08		.
	adc a,e			;238e	8b		.
	inc d			;238f	14		.
	cp h			;2390	bc		.
	add a,h			;2391	84		.
	inc bc			;2392	03		.
	ld e,c			;2393	59		Y
	add a,e			;2394	83		.
	ld (bc),a		;2395	02		.
	adc a,e			;2396	8b		.
	inc bc			;2397	03		.
	ld h,b			;2398	60		`
	ex af,af'		;2399	08		.
	adc a,e			;239a	8b		.
	dec b			;239b	05		.
	ld a,h			;239c	7c		|
	ld e,d			;239d	5a		Z
	ld bc,l0ab6h		;239e	01 b6 0a	. . .
	ld c,b			;23a1	48		H
	sub l			;23a2	95		.
	ld c,l			;23a3	4d		M
	ld bc,l098ah		;23a4	01 8a 09	. . .
	ld d,c			;23a7	51		Q
	cp h			;23a8	bc		.
l23a9h:
	add a,l			;23a9	85		.
	ld h,l			;23aa	65		e
	dec l			;23ab	2d		-
	ld l,e			;23ac	6b		k
	ld bc,l4d94h+1		;23ad	01 95 4d	. . M
	add a,e			;23b0	83		.
	ld (bc),a		;23b1	02		.
	adc a,d			;23b2	8a		.
	ld c,d			;23b3	4a		J
	ld bc,0028bh		;23b4	01 8b 02	. . .
	ld (hl),d		;23b7	72		r
	add a,l			;23b8	85		.
	ld d,e			;23b9	53		S
	ld bc,l0295h		;23ba	01 95 02	. . .
	adc a,e			;23bd	8b		.
	ld b,095h		;23be	06 95		. .
	inc bc			;23c0	03		.
	adc a,e			;23c1	8b		.
	ld bc,l018ah		;23c2	01 8a 01	. . .
	ld c,d			;23c5	4a		J
	rlca			;23c6	07		.
	sub l			;23c7	95		.
	ld bc,l036bh		;23c8	01 6b 03	. k .
	sub a			;23cb	97		.
	ld b,c			;23cc	41		A
	dec b			;23cd	05		.
	ld c,e			;23ce	4b		K
l23cfh:
	dec bc			;23cf	0b		.
	ld c,b			;23d0	48		H
	adc a,b			;23d1	88		.
	dec b			;23d2	05		.
	ld h,b			;23d3	60		`
	inc a			;23d4	3c		<
	inc a			;23d5	3c		<
	inc a			;23d6	3c		<
	inc a			;23d7	3c		<
	ld (hl),e		;23d8	73		s
	and (hl)		;23d9	a6		.
	inc d			;23da	14		.
	ld a,(hl)		;23db	7e		~
	add hl,hl		;23dc	29		)
	ret m			;23dd	f8		.
	sbc a,e			;23de	9b		.
	inc de			;23df	13		.
	inc de			;23e0	13		.
	sub (hl)		;23e1	96		.
	cp c			;23e2	b9		.
sub_23e3h:
	ld a,(WORK_RAM)		;23e3	3a 00 a8	: . .
	inc a			;23e6	3c		<
	jp nz,l2496h		;23e7	c2 96 24	. . $
	ld a,(0acc6h)		;23ea	3a c6 ac	: . .
	and a			;23ed	a7		.
	jp nz,l2496h		;23ee	c2 96 24	. . $
	call 01ed1h		;23f1	cd d1 1e	. . .
	rlca			;23f4	07		.
	rlca			;23f5	07		.
	rlca			;23f6	07		.
	rlca			;23f7	07		.
	ld hl,0a98eh		;23f8	21 8e a9	! . .
	rl (hl)			;23fb	cb 16		. .
	ld a,(hl)		;23fd	7e		~
	and 003h		;23fe	e6 03		. .
	cp 001h			;2400	fe 01		. .
	ld hl,0aa81h		;2402	21 81 aa	! . .
	jr nz,l2409h		;2405	20 02		  .
	ld (hl),003h		;2407	36 03		6 .
l2409h:
	ld a,(0ad30h)		;2409	3a 30 ad	: 0 .
	and a			;240c	a7		.
	jr z,l2414h		;240d	28 05		( .
	ld a,(hl)		;240f	7e		~
	and a			;2410	a7		.
	jp z,l2496h		;2411	ca 96 24	. . $
l2414h:
	inc hl			;2414	23		#
	ld a,(hl)		;2415	7e		~
	and a			;2416	a7		.
	jp nz,l2496h		;2417	c2 96 24	. . $
	ld ix,0aa80h		;241a	dd 21 80 aa	. ! . .
	ld b,006h		;241e	06 06		. .
l2420h:
	ld a,(ix+000h)		;2420	dd 7e 00	. ~ .
	and a			;2423	a7		.
	jr z,l2449h		;2424	28 23		( #
	ld de,(l0d46h)		;2426	ed 5b 46 0d	. [ F .
	add ix,de		;242a	dd 19		. .
	djnz l2420h		;242c	10 f2		. .
	jp l2496h		;242e	c3 96 24	. . $
	ld d,0a7h		;2431	16 a7		. .
	inc de			;2433	13		.
	sub (hl)		;2434	96		.
	defb 0edh ;next byte illegal after ed	;2435	ed		.
	call c,08cf1h		;2436	dc f1 8c	. . .
	ld l,b			;2439	68		h
	dec sp			;243a	3b		;
	dec c			;243b	0d		.
	defb 0edh ;next byte illegal after ed	;243c	ed		.
	pop af			;243d	f1		.
	sub (hl)		;243e	96		.
	inc de			;243f	13		.
	inc de			;2440	13		.
	inc de			;2441	13		.
	inc de			;2442	13		.
	pop af			;2443	f1		.
	adc a,b			;2444	88		.
	call c,sub_11edh	;2445	dc ed 11	. . .
	cp c			;2448	b9		.
l2449h:
	call sub_567eh		;2449	cd 7e 56	. ~ V
	xor a			;244c	af		.
	ld h,a			;244d	67		g
	ld l,a			;244e	6f		o
	ld bc,(0a808h)		;244f	ed 4b 08 a8	. K . .
	sbc hl,bc		;2453	ed 42		. B
	add hl,hl		;2455	29		)
	add hl,hl		;2456	29		)
	ld (ix+00ah),l		;2457	dd 75 0a	. u .
	ld (ix+00bh),h		;245a	dd 74 0b	. t .
	xor a			;245d	af		.
	ld h,a			;245e	67		g
	ld l,a			;245f	6f		o
	ld bc,(0a80ah)		;2460	ed 4b 0a a8	. K . .
	sbc hl,bc		;2464	ed 42		. B
	add hl,hl		;2466	29		)
	add hl,hl		;2467	29		)
	ld (ix+00ch),l		;2468	dd 75 0c	. u .
	ld (ix+00dh),h		;246b	dd 74 0d	. t .
	ld a,(0a802h)		;246e	3a 02 a8	: . .
	add a,004h		;2471	c6 04		. .
	rrca			;2473	0f		.
	rrca			;2474	0f		.
	rrca			;2475	0f		.
	and 01fh		;2476	e6 1f		. .
	ld hl,l2771h		;2478	21 71 27	! q '
	call sub_018ch		;247b	cd 8c 01	. . .
	dec (ix+000h)		;247e	dd 35 00	. 5 .
	ld (ix+003h),000h	;2481	dd 36 03 00	. 6 . .
	ld (ix+004h),e		;2485	dd 73 04	. s .
	ld (ix+005h),000h	;2488	dd 36 05 00	. 6 . .
	ld (ix+006h),d		;248c	dd 72 06	. r .
	ld hl,0aa81h		;248f	21 81 aa	! . .
	dec (hl)		;2492	35		5
	inc hl			;2493	23		#
	ld (hl),006h		;2494	36 06		6 .
l2496h:
	ld a,(0aa82h)		;2496	3a 82 aa	: . .
	and a			;2499	a7		.
	jr z,l24a0h		;249a	28 04		( .
	dec a			;249c	3d		=
	ld (0aa82h),a		;249d	32 82 aa	2 . .
l24a0h:
	ld ix,0aa80h		;24a0	dd 21 80 aa	. ! . .
	ld b,006h		;24a4	06 06		. .
l24a6h:
	exx			;24a6	d9		.
	ld a,(ix+000h)		;24a7	dd 7e 00	. ~ .
	and a			;24aa	a7		.
	jr z,l24f3h		;24ab	28 46		( F
	inc a			;24ad	3c		<
	jr nz,l24fch		;24ae	20 4c		  L
	ld l,(ix+00ah)		;24b0	dd 6e 0a	. n .
	ld h,(ix+00bh)		;24b3	dd 66 0b	. f .
	ld de,(0a808h)		;24b6	ed 5b 08 a8	. [ . .
	add hl,de		;24ba	19		.
	ld d,(ix+004h)		;24bb	dd 56 04	. V .
	ld e,(ix+003h)		;24be	dd 5e 03	. ^ .
	add hl,de		;24c1	19		.
	ld a,h			;24c2	7c		|
	add a,010h		;24c3	c6 10		. .
	cp 010h			;24c5	fe 10		. .
	jp c,l24fch		;24c7	da fc 24	. . $
	ld (ix+004h),h		;24ca	dd 74 04	. t .
	ld (ix+003h),l		;24cd	dd 75 03	. u .
	ld l,(ix+00ch)		;24d0	dd 6e 0c	. n .
	ld h,(ix+00dh)		;24d3	dd 66 0d	. f .
	ld de,(0a80ah)		;24d6	ed 5b 0a a8	. [ . .
	add hl,de		;24da	19		.
	ld d,(ix+006h)		;24db	dd 56 06	. V .
	ld e,(ix+005h)		;24de	dd 5e 05	. ^ .
	add hl,de		;24e1	19		.
	ld a,h			;24e2	7c		|
	add a,008h		;24e3	c6 08		. .
	cp 018h			;24e5	fe 18		. .
	jp c,l24fch		;24e7	da fc 24	. . $
	ld (ix+006h),h		;24ea	dd 74 06	. t .
	ld (ix+005h),l		;24ed	dd 75 05	. u .
	call sub_5337h		;24f0	cd 37 53	. 7 S
l24f3h:
	ld de,l0010h		;24f3	11 10 00	. . .
	add ix,de		;24f6	dd 19		. .
	exx			;24f8	d9		.
	djnz l24a6h		;24f9	10 ab		. .
	ret			;24fb	c9		.
l24fch:
	xor a			;24fc	af		.
	ld (ix+000h),a		;24fd	dd 77 00	. w .
	ld (ix+004h),a		;2500	dd 77 04	. w .
	ld (ix+006h),a		;2503	dd 77 06	. w .
	jp l24f3h		;2506	c3 f3 24	. . $
l2509h:
	ret po			;2509	e0		.
	and h			;250a	a4		.
	inc d			;250b	14		.
	sbc a,e			;250c	9b		.
	djnz $+15		;250d	10 0d		. .
	adc a,b			;250f	88		.
	cp c			;2510	b9		.
l2511h:
	ld hl,0ac00h		;2511	21 00 ac	! . .
	ld b,040h		;2514	06 40		. @
l2516h:
	ld (hl),0ffh		;2516	36 ff		6 .
	inc hl			;2518	23		#
	djnz l2516h		;2519	10 fb		. .
	call sub_4b67h		;251b	cd 67 4b	. g K
	ld (DSW2_READ_WATCHDOG_WRITE),a	;251e	32 00 c2	2 . .
	call l4ba5h		;2521	cd a5 4b	. . K
	ld (DSW2_READ_WATCHDOG_WRITE),a	;2524	32 00 c2	2 . .
	call sub_526ah		;2527	cd 6a 52	. j R
	ld (DSW2_READ_WATCHDOG_WRITE),a	;252a	32 00 c2	2 . .
	jp l52aah		;252d	c3 aa 52	. . R
l2530h:
	add hl,de		;2530	19		.
	ld bc,l0117h+1		;2531	01 18 01	. . .
	rla			;2534	17		.
	ld bc,l0116h		;2535	01 16 01	. . .
	dec d			;2538	15		.
	ld bc,l0113h+1		;2539	01 14 01	. . .
	inc de			;253c	13		.
	ld bc,l0110h		;253d	01 10 01	. . .
	ld c,001h		;2540	0e 01		. .
	inc c			;2542	0c		.
	ld bc,l0109h+1		;2543	01 0a 01	. . .
	ex af,af'		;2546	08		.
	ld bc,l0103h+1		;2547	01 04 01	. . .
	ld bc,0ff01h		;254a	01 01 ff	. . .
	nop			;254d	00		.
	ei			;254e	fb		.
	nop			;254f	00		.
	ret m			;2550	f8		.
	nop			;2551	00		.
	push af			;2552	f5		.
	nop			;2553	00		.
	jp p,0ee00h		;2554	f2 00 ee	. . .
	nop			;2557	00		.
	ex de,hl		;2558	eb		.
	nop			;2559	00		.
	ret pe			;255a	e8		.
	nop			;255b	00		.
	call po,0e100h		;255c	e4 00 e1	. . .
	nop			;255f	00		.
	sbc a,000h		;2560	de 00		. .
	jp c,0d700h		;2562	da 00 d7	. . .
	nop			;2565	00		.
	call nc,0d100h		;2566	d4 00 d1	. . .
	nop			;2569	00		.
	call 0ca00h		;256a	cd 00 ca	. . .
	nop			;256d	00		.
	rst 0			;256e	c7		.
	nop			;256f	00		.
	jp SCANLINE_READ_SOUND_COMMAND_WRITE	;2570	c3 00 c0	. . .
	nop			;2573	00		.
	cp h			;2574	bc		.
	nop			;2575	00		.
	cp b			;2576	b8		.
	nop			;2577	00		.
	or l			;2578	b5		.
	nop			;2579	00		.
	or c			;257a	b1		.
	nop			;257b	00		.
	xor h			;257c	ac		.
	nop			;257d	00		.
	xor b			;257e	a8		.
	nop			;257f	00		.
	and l			;2580	a5		.
l2581h:
	nop			;2581	00		.
	and b			;2582	a0		.
	nop			;2583	00		.
	sbc a,d			;2584	9a		.
	nop			;2585	00		.
	sub h			;2586	94		.
	nop			;2587	00		.
	adc a,a			;2588	8f		.
	nop			;2589	00		.
	add a,a			;258a	87		.
	nop			;258b	00		.
	add a,h			;258c	84		.
	nop			;258d	00		.
	ld a,l			;258e	7d		}
	nop			;258f	00		.
	halt			;2590	76		v
	nop			;2591	00		.
	ld (hl),b		;2592	70		p
	nop			;2593	00		.
	ld l,c			;2594	69		i
	nop			;2595	00		.
	ld h,c			;2596	61		a
	nop			;2597	00		.
	ld e,e			;2598	5b		[
	nop			;2599	00		.
	ld d,e			;259a	53		S
	nop			;259b	00		.
	ld c,e			;259c	4b		K
	nop			;259d	00		.
	ld b,h			;259e	44		D
	nop			;259f	00		.
	dec sp			;25a0	3b		;
	nop			;25a1	00		.
	inc sp			;25a2	33		3
	nop			;25a3	00		.
	inc l			;25a4	2c		,
	nop			;25a5	00		.
	inc hl			;25a6	23		#
	nop			;25a7	00		.
	ld a,(de)		;25a8	1a		.
	nop			;25a9	00		.
	ld de,l0800h		;25aa	11 00 08	. . .
	nop			;25ad	00		.
	nop			;25ae	00		.
	nop			;25af	00		.
	nop			;25b0	00		.
	nop			;25b1	00		.
	ret m			;25b2	f8		.
	rst 38h			;25b3	ff		.
	rst 28h			;25b4	ef		.
	rst 38h			;25b5	ff		.
	nop			;25b6	00		.
	nop			;25b7	00		.
	defb 0ddh,0ffh,0d4h ;illegal sequence	;25b8	dd ff d4	. . .
	rst 38h			;25bb	ff		.
	call 0c5ffh		;25bc	cd ff c5	. . .
	rst 38h			;25bf	ff		.
	cp h			;25c0	bc		.
	rst 38h			;25c1	ff		.
	or l			;25c2	b5		.
	rst 38h			;25c3	ff		.
	xor l			;25c4	ad		.
	rst 38h			;25c5	ff		.
	and l			;25c6	a5		.
	rst 38h			;25c7	ff		.
	sbc a,a			;25c8	9f		.
	rst 38h			;25c9	ff		.
	sub a			;25ca	97		.
	rst 38h			;25cb	ff		.
	sub b			;25cc	90		.
	rst 38h			;25cd	ff		.
	adc a,d			;25ce	8a		.
	rst 38h			;25cf	ff		.
	add a,e			;25d0	83		.
	rst 38h			;25d1	ff		.
	ld a,h			;25d2	7c		|
	rst 38h			;25d3	ff		.
	ld a,c			;25d4	79		y
	rst 38h			;25d5	ff		.
	ld a,h			;25d6	7c		|
	rst 38h			;25d7	ff		.
	ld l,h			;25d8	6c		l
	rst 38h			;25d9	ff		.
	ld h,(hl)		;25da	66		f
	rst 38h			;25db	ff		.
	ld h,b			;25dc	60		`
	rst 38h			;25dd	ff		.
	ld e,e			;25de	5b		[
	rst 38h			;25df	ff		.
	ld e,b			;25e0	58		X
	rst 38h			;25e1	ff		.
	ld d,h			;25e2	54		T
	rst 38h			;25e3	ff		.
	ld c,a			;25e4	4f		O
	rst 38h			;25e5	ff		.
	ld c,e			;25e6	4b		K
	rst 38h			;25e7	ff		.
	ld c,b			;25e8	48		H
	rst 38h			;25e9	ff		.
	ld b,h			;25ea	44		D
	rst 38h			;25eb	ff		.
	ld b,b			;25ec	40		@
	rst 38h			;25ed	ff		.
	dec a			;25ee	3d		=
	rst 38h			;25ef	ff		.
	add hl,sp		;25f0	39		9
	rst 38h			;25f1	ff		.
	ld (hl),0ffh		;25f2	36 ff		6 .
	inc sp			;25f4	33		3
	rst 38h			;25f5	ff		.
	inc sp			;25f6	33		3
	rst 38h			;25f7	ff		.
	inc l			;25f8	2c		,
	rst 38h			;25f9	ff		.
	add hl,hl		;25fa	29		)
	rst 38h			;25fb	ff		.
	ld h,0ffh		;25fc	26 ff		& .
	ld (l1fffh),hl		;25fe	22 ff 1f	" . .
	rst 38h			;2601	ff		.
	inc e			;2602	1c		.
	rst 38h			;2603	ff		.
	jr $+1			;2604	18 ff		. .
	dec d			;2606	15		.
	rst 38h			;2607	ff		.
	ld (de),a		;2608	12		.
	rst 38h			;2609	ff		.
	ld c,0ffh		;260a	0e ff		. .
	dec bc			;260c	0b		.
	rst 38h			;260d	ff		.
	ex af,af'		;260e	08		.
	rst 38h			;260f	ff		.
	dec b			;2610	05		.
	rst 38h			;2611	ff		.
	ld bc,0ffffh		;2612	01 ff ff	. . .
	cp 0fch			;2615	fe fc		. .
	cp 0f8h			;2617	fe f8		. .
	cp 0f6h			;2619	fe f6		. .
	cp 0f4h			;261b	fe f4		. .
	cp 0f2h			;261d	fe f2		. .
	cp 0f0h			;261f	fe f0		. .
	cp 0edh			;2621	fe ed		. .
	cp 0ech			;2623	fe ec		. .
	cp 0ebh			;2625	fe eb		. .
	cp 0eah			;2627	fe ea		. .
	cp 0e9h			;2629	fe e9		. .
	cp 0e8h			;262b	fe e8		. .
	cp 0e7h			;262d	fe e7		. .
	cp 0e7h			;262f	fe e7		. .
	cp 0e8h			;2631	fe e8		. .
	cp 0e9h			;2633	fe e9		. .
	cp 0eah			;2635	fe ea		. .
	cp 0ebh			;2637	fe eb		. .
	cp 0ech			;2639	fe ec		. .
	cp 0edh			;263b	fe ed		. .
	cp 0f0h			;263d	fe f0		. .
	cp 0f2h			;263f	fe f2		. .
	cp 0f4h			;2641	fe f4		. .
	cp 0f6h			;2643	fe f6		. .
	cp 0f8h			;2645	fe f8		. .
	cp 0fch			;2647	fe fc		. .
	cp 0ffh			;2649	fe ff		. .
	cp 001h			;264b	fe 01		. .
	rst 38h			;264d	ff		.
	dec b			;264e	05		.
	rst 38h			;264f	ff		.
	ex af,af'		;2650	08		.
	rst 38h			;2651	ff		.
	dec bc			;2652	0b		.
	rst 38h			;2653	ff		.
	ld c,0ffh		;2654	0e ff		. .
	ld (de),a		;2656	12		.
	rst 38h			;2657	ff		.
	dec d			;2658	15		.
	rst 38h			;2659	ff		.
	jr $+1			;265a	18 ff		. .
	inc e			;265c	1c		.
	rst 38h			;265d	ff		.
	rra			;265e	1f		.
	rst 38h			;265f	ff		.
	ld (l26ffh),hl		;2660	22 ff 26	" . &
	rst 38h			;2663	ff		.
	add hl,hl		;2664	29		)
	rst 38h			;2665	ff		.
	inc l			;2666	2c		,
	rst 38h			;2667	ff		.
	cpl			;2668	2f		/
	rst 38h			;2669	ff		.
	inc sp			;266a	33		3
	rst 38h			;266b	ff		.
	ld (hl),0ffh		;266c	36 ff		6 .
	add hl,sp		;266e	39		9
	rst 38h			;266f	ff		.
	dec a			;2670	3d		=
	rst 38h			;2671	ff		.
	ld b,b			;2672	40		@
	rst 38h			;2673	ff		.
	ld b,h			;2674	44		D
	rst 38h			;2675	ff		.
	ld c,b			;2676	48		H
	rst 38h			;2677	ff		.
	ld c,e			;2678	4b		K
	rst 38h			;2679	ff		.
	ld c,a			;267a	4f		O
	rst 38h			;267b	ff		.
	ld d,h			;267c	54		T
	rst 38h			;267d	ff		.
	ld e,b			;267e	58		X
	rst 38h			;267f	ff		.
	ld e,e			;2680	5b		[
	rst 38h			;2681	ff		.
	ld h,b			;2682	60		`
	rst 38h			;2683	ff		.
	ld h,(hl)		;2684	66		f
	rst 38h			;2685	ff		.
	ld l,h			;2686	6c		l
	rst 38h			;2687	ff		.
	ld (hl),c		;2688	71		q
	rst 38h			;2689	ff		.
	ld a,c			;268a	79		y
	rst 38h			;268b	ff		.
	ld a,h			;268c	7c		|
	rst 38h			;268d	ff		.
	add a,e			;268e	83		.
	rst 38h			;268f	ff		.
	adc a,d			;2690	8a		.
	rst 38h			;2691	ff		.
	sub b			;2692	90		.
	rst 38h			;2693	ff		.
	sub a			;2694	97		.
	rst 38h			;2695	ff		.
	sbc a,a			;2696	9f		.
	rst 38h			;2697	ff		.
	and l			;2698	a5		.
	rst 38h			;2699	ff		.
	xor l			;269a	ad		.
	rst 38h			;269b	ff		.
	or l			;269c	b5		.
	rst 38h			;269d	ff		.
	cp h			;269e	bc		.
	rst 38h			;269f	ff		.
	push bc			;26a0	c5		.
	rst 38h			;26a1	ff		.
	call 0d4ffh		;26a2	cd ff d4	. . .
	rst 38h			;26a5	ff		.
	defb 0ddh,0ffh,0e6h ;illegal sequence	;26a6	dd ff e6	. . .
	rst 38h			;26a9	ff		.
	rst 28h			;26aa	ef		.
	rst 38h			;26ab	ff		.
	ret m			;26ac	f8		.
	rst 38h			;26ad	ff		.
	nop			;26ae	00		.
	nop			;26af	00		.
	nop			;26b0	00		.
	nop			;26b1	00		.
	ex af,af'		;26b2	08		.
	nop			;26b3	00		.
	ld de,l1a00h		;26b4	11 00 1a	. . .
	nop			;26b7	00		.
	inc hl			;26b8	23		#
	nop			;26b9	00		.
	inc l			;26ba	2c		,
	nop			;26bb	00		.
	inc sp			;26bc	33		3
	nop			;26bd	00		.
	dec sp			;26be	3b		;
	nop			;26bf	00		.
	ld b,h			;26c0	44		D
	nop			;26c1	00		.
	ld c,e			;26c2	4b		K
	nop			;26c3	00		.
	ld d,e			;26c4	53		S
	nop			;26c5	00		.
	ld e,e			;26c6	5b		[
	nop			;26c7	00		.
	ld h,c			;26c8	61		a
	nop			;26c9	00		.
	ld l,c			;26ca	69		i
	nop			;26cb	00		.
	ld (hl),b		;26cc	70		p
	nop			;26cd	00		.
	halt			;26ce	76		v
	nop			;26cf	00		.
	ld a,l			;26d0	7d		}
	nop			;26d1	00		.
	add a,h			;26d2	84		.
	nop			;26d3	00		.
	add a,a			;26d4	87		.
	nop			;26d5	00		.
	add a,a			;26d6	87		.
	nop			;26d7	00		.
	sub h			;26d8	94		.
	nop			;26d9	00		.
	sbc a,d			;26da	9a		.
	nop			;26db	00		.
	and b			;26dc	a0		.
	nop			;26dd	00		.
	and l			;26de	a5		.
	nop			;26df	00		.
	xor b			;26e0	a8		.
	nop			;26e1	00		.
	xor h			;26e2	ac		.
	nop			;26e3	00		.
	or c			;26e4	b1		.
	nop			;26e5	00		.
	or l			;26e6	b5		.
	nop			;26e7	00		.
	cp b			;26e8	b8		.
	nop			;26e9	00		.
	cp h			;26ea	bc		.
	nop			;26eb	00		.
	ret nz			;26ec	c0		.
	nop			;26ed	00		.
	jp 0c700h		;26ee	c3 00 c7	. . .
	nop			;26f1	00		.
	jp z,0cd00h		;26f2	ca 00 cd	. . .
	nop			;26f5	00		.
	jp z,0d400h		;26f6	ca 00 d4	. . .
	nop			;26f9	00		.
	rst 10h			;26fa	d7		.
	nop			;26fb	00		.
	jp c,0de00h		;26fc	da 00 de	. . .
l26ffh:
	nop			;26ff	00		.
	pop hl			;2700	e1		.
	nop			;2701	00		.
	call po,0e800h		;2702	e4 00 e8	. . .
	nop			;2705	00		.
	ex de,hl		;2706	eb		.
	nop			;2707	00		.
	xor 000h		;2708	ee 00		. .
	jp p,0f500h		;270a	f2 00 f5	. . .
	nop			;270d	00		.
	ret m			;270e	f8		.
	nop			;270f	00		.
	ei			;2710	fb		.
	nop			;2711	00		.
	rst 38h			;2712	ff		.
	nop			;2713	00		.
	ld bc,0fb01h		;2714	01 01 fb	. . .
	nop			;2717	00		.
	ex af,af'		;2718	08		.
	ld bc,l0109h+1		;2719	01 0a 01	. . .
	inc c			;271c	0c		.
	ld bc,l010ch+2		;271d	01 0e 01	. . .
	djnz l2723h		;2720	10 01		. .
	inc de			;2722	13		.
l2723h:
	ld bc,l0113h+1		;2723	01 14 01	. . .
	dec d			;2726	15		.
	ld bc,l0116h		;2727	01 16 01	. . .
	rla			;272a	17		.
	ld bc,l0117h+1		;272b	01 18 01	. . .
	add hl,de		;272e	19		.
	ld bc,06f3ah		;272f	01 3a 6f	. : o
	xor d			;2732	aa		.
	cp 076h			;2733	fe 76		. v
	jp nz,l2530h		;2735	c2 30 25	. 0 %
	call sub_0b2bh		;2738	cd 2b 0b	. + .
	call sub_210eh		;273b	cd 0e 21	. . !
	xor a			;273e	af		.
	ld (0ad31h),a		;273f	32 31 ad	2 1 .
	ld (0ad20h),a		;2742	32 20 ad	2   .
	ld (0ad30h),a		;2745	32 30 ad	2 0 .
	ld (0a9ach),a		;2748	32 ac a9	2 . .
	inc a			;274b	3c		<
	ld (0ad10h),a		;274c	32 10 ad	2 . .
	ld a,003h		;274f	3e 03		> .
	ld (0a9abh),a		;2751	32 ab a9	2 . .
	ret			;2754	c9		.
sub_2755h:
	ld ix,0aa80h		;2755	dd 21 80 aa	. ! . .
	ld hl,l276eh		;2759	21 6e 27	! n '
	ld a,(l0861h)		;275c	3a 61 08	: a .
	ld e,a			;275f	5f		_
	ld a,(l5c01h)		;2760	3a 01 5c	: . \
	ld d,a			;2763	57		W
	ld b,006h		;2764	06 06		. .
l2766h:
	ld (ix+000h),a		;2766	dd 77 00	. w .
	ld (ix+004h),a		;2769	dd 77 04	. w .
	add ix,de		;276c	dd 19		. .
l276eh:
	djnz l2766h		;276e	10 f6		. .
	ret			;2770	c9		.
l2771h:
	ld a,(hl)		;2771	7e		~
	add a,h			;2772	84		.
	ld a,(hl)		;2773	7e		~
	add a,l			;2774	85		.
	ld a,(hl)		;2775	7e		~
	add a,(hl)		;2776	86		.
	ld a,l			;2777	7d		}
	add a,a			;2778	87		.
	ld a,h			;2779	7c		|
	adc a,b			;277a	88		.
	ld a,e			;277b	7b		{
	adc a,c			;277c	89		.
	ld a,d			;277d	7a		z
	adc a,d			;277e	8a		.
	ld a,c			;277f	79		y
	adc a,d			;2780	8a		.
	ld a,b			;2781	78		x
	adc a,d			;2782	8a		.
	ld (hl),a		;2783	77		w
	adc a,d			;2784	8a		.
	halt			;2785	76		v
	adc a,d			;2786	8a		.
	ld (hl),l		;2787	75		u
	adc a,c			;2788	89		.
	ld (hl),h		;2789	74		t
	adc a,b			;278a	88		.
	ld (hl),e		;278b	73		s
	add a,a			;278c	87		.
	ld (hl),d		;278d	72		r
	add a,(hl)		;278e	86		.
	ld (hl),d		;278f	72		r
	add a,l			;2790	85		.
	ld (hl),d		;2791	72		r
	add a,h			;2792	84		.
	ld (hl),d		;2793	72		r
	add a,e			;2794	83		.
	ld (hl),d		;2795	72		r
	add a,d			;2796	82		.
	ld (hl),e		;2797	73		s
	add a,c			;2798	81		.
	ld (hl),h		;2799	74		t
	add a,b			;279a	80		.
	ld (hl),l		;279b	75		u
	ld a,a			;279c	7f		.
	halt			;279d	76		v
	ld a,(hl)		;279e	7e		~
	ld (hl),a		;279f	77		w
	ld a,(hl)		;27a0	7e		~
	ld a,b			;27a1	78		x
	ld a,(hl)		;27a2	7e		~
	ld a,c			;27a3	79		y
	ld a,(hl)		;27a4	7e		~
	ld a,d			;27a5	7a		z
	ld a,(hl)		;27a6	7e		~
	ld a,e			;27a7	7b		{
	ld a,a			;27a8	7f		.
	ld a,h			;27a9	7c		|
	add a,b			;27aa	80		.
	ld a,l			;27ab	7d		}
	add a,c			;27ac	81		.
	ld a,(hl)		;27ad	7e		~
	add a,d			;27ae	82		.
	ld a,(hl)		;27af	7e		~
	add a,e			;27b0	83		.
	call sub_5834h		;27b1	cd 34 58	. 4 X
	ld a,078h		;27b4	3e 78		> x
	ld (0ac64h),a		;27b6	32 64 ac	2 d .
	ld a,084h		;27b9	3e 84		> .
	ld (0ac65h),a		;27bb	32 65 ac	2 e .
	ld hl,RESET_VECTOR	;27be	21 00 00	! . .
	ld (0ad16h),hl		;27c1	22 16 ad	" . .
	ld (0ad26h),hl		;27c4	22 26 ad	" & .
	ld a,(0a9cdh)		;27c7	3a cd a9	: . .
	ld (0ad12h),a		;27ca	32 12 ad	2 . .
	ld (0ad22h),a		;27cd	32 22 ad	2 " .
	xor a			;27d0	af		.
	ld (0ad14h),a		;27d1	32 14 ad	2 . .
	ld (0ad24h),a		;27d4	32 24 ad	2 $ .
	ld (0ad32h),a		;27d7	32 32 ad	2 2 .
	ld (0ad13h),a		;27da	32 13 ad	2 . .
	ld (0ad23h),a		;27dd	32 23 ad	2 # .
	ld (0ad1dh),a		;27e0	32 1d ad	2 . .
	ld (0ad2dh),a		;27e3	32 2d ad	2 - .
	ld (0ad0ch),a		;27e6	32 0c ad	2 . .
	inc a			;27e9	3c		<
	ld (0ad11h),a		;27ea	32 11 ad	2 . .
	ld (0ad21h),a		;27ed	32 21 ad	2 ! .
	ld (0ad1eh),a		;27f0	32 1e ad	2 . .
	ld (0ad2eh),a		;27f3	32 2e ad	2 . .
	ld a,(0ad30h)		;27f6	3a 30 ad	: 0 .
	and a			;27f9	a7		.
	jr z,l2835h		;27fa	28 39		( 9
	xor a			;27fc	af		.
	ld h,a			;27fd	67		g
	ld l,a			;27fe	6f		o
l27ffh:
	ld (0ad33h),a		;27ff	32 33 ad	2 3 .
	ld (0ad34h),hl		;2802	22 34 ad	" 4 .
	ld (0ad36h),a		;2805	32 36 ad	2 6 .
	ld (0ad37h),hl		;2808	22 37 ad	" 7 .
	ld de,00400h		;280b	11 00 04	. . .
	rst 38h			;280e	ff		.
	ld a,(0a9c4h)		;280f	3a c4 a9	: . .
	call sub_0f7bh		;2812	cd 7b 0f	. { .
	ld b,000h		;2815	06 00		. .
	ld hl,01550h		;2817	21 50 15	! P .
	sub a			;281a	97		.
l281bh:
	xor (hl)		;281b	ae		.
	inc hl			;281c	23		#
	djnz l281bh		;281d	10 fc		. .
	add a,001h		;281f	c6 01		. .
	ld (LATCH_VIDEO_ENABLE),a	;2821	32 08 c3	2 . .
l2824h:
	ld a,(0a9d3h)		;2824	3a d3 a9	: . .
	ld (0ad1ah),a		;2827	32 1a ad	2 . .
	ld (0ad2ah),a		;282a	32 2a ad	2 * .
	ld a,096h		;282d	3e 96		> .
	ld (0a9ebh),a		;282f	32 eb a9	2 . .
	jp sub_0f1ah		;2832	c3 1a 0f	. . .
l2835h:
	ld hl,0a9d0h		;2835	21 d0 a9	! . .
	ld a,(hl)		;2838	7e		~
	inc a			;2839	3c		<
	cp 004h			;283a	fe 04		. .
	jr c,l2840h		;283c	38 02		8 .
	ld a,001h		;283e	3e 01		> .
l2840h:
	ld (hl),a		;2840	77		w
	ld (0ad14h),a		;2841	32 14 ad	2 . .
	inc a			;2844	3c		<
	ld (0ad11h),a		;2845	32 11 ad	2 . .
	xor a			;2848	af		.
	ld (0a980h),a		;2849	32 80 a9	2 . .
	ld (0a9ceh),a		;284c	32 ce a9	2 . .
	ld (0a9cfh),a		;284f	32 cf a9	2 . .
	call sub_4b67h		;2852	cd 67 4b	. g K
	ld hl,0aa80h		;2855	21 80 aa	! . .
	ld de,0aa81h		;2858	11 81 aa	. . .
	ld (hl),000h		;285b	36 00		6 .
	ld bc,l005fh		;285d	01 5f 00	. _ .
	ldir			;2860	ed b0		. .
	ld hl,WORK_RAM		;2862	21 00 a8	! . .
	ld de,0a801h		;2865	11 01 a8	. . .
	ld (hl),000h		;2868	36 00		6 .
	ld bc,l017fh		;286a	01 7f 01	. . .
	ldir			;286d	ed b0		. .
	ld a,002h		;286f	3e 02		> .
	call sub_0f7bh		;2871	cd 7b 0f	. { .
	ld a,(0a9d3h)		;2874	3a d3 a9	: . .
	ld (0ad1ah),a		;2877	32 1a ad	2 . .
	ld (0ad2ah),a		;287a	32 2a ad	2 * .
	ld c,000h		;287d	0e 00		. .
	ld hl,l3310h		;287f	21 10 33	! . 3
	ld a,(0a9abh)		;2882	3a ab a9	: . .
l2885h:
	sub (hl)		;2885	96		.
	inc hl			;2886	23		#
	dec c			;2887	0d		.
	jr nz,l2885h		;2888	20 fb		  .
	xor 090h		;288a	ee 90		. .
	ld (0a9abh),a		;288c	32 ab a9	2 . .
	ld hl,0ac74h		;288f	21 74 ac	! t .
	ld b,010h		;2892	06 10		. .
l2894h:
	ld (hl),080h		;2894	36 80		6 .
	inc hl			;2896	23		#
	djnz l2894h		;2897	10 fb		. .
	ld a,05ah		;2899	3e 5a		> Z
	ld (0a9ebh),a		;289b	32 eb a9	2 . .
	jp sub_0f1ah		;289e	c3 1a 0f	. . .
sub_28a1h:
	call sub_28b7h		;28a1	cd b7 28	. . (
	call sub_28c2h		;28a4	cd c2 28	. . (
	call sub_28cdh		;28a7	cd cd 28	. . (
	call sub_28d8h		;28aa	cd d8 28	. . (
	call sub_28e3h		;28ad	cd e3 28	. . (
	call sub_28eeh		;28b0	cd ee 28	. . (
	call sub_28feh		;28b3	cd fe 28	. . (
	ret			;28b6	c9		.
sub_28b7h:
	ld ix,0a850h		;28b7	dd 21 50 a8	. ! P .
	ld iy,0aa1ah		;28bb	fd 21 1a aa	. ! . .
	jp l290eh		;28bf	c3 0e 29	. . )
sub_28c2h:
	ld ix,0a860h		;28c2	dd 21 60 a8	. ! ` .
	ld iy,0aa1ch		;28c6	fd 21 1c aa	. ! . .
	jp l290eh		;28ca	c3 0e 29	. . )
sub_28cdh:
	ld ix,0a870h		;28cd	dd 21 70 a8	. ! p .
	ld iy,0aa1eh		;28d1	fd 21 1e aa	. ! . .
	jp l290eh		;28d5	c3 0e 29	. . )
sub_28d8h:
	ld ix,0a880h		;28d8	dd 21 80 a8	. ! . .
	ld iy,0aa20h		;28dc	fd 21 20 aa	. !   .
	jp l290eh		;28e0	c3 0e 29	. . )
sub_28e3h:
	ld ix,0a890h		;28e3	dd 21 90 a8	. ! . .
	ld iy,0aa22h		;28e7	fd 21 22 aa	. ! " .
	jp l290eh		;28eb	c3 0e 29	. . )
sub_28eeh:
	ld a,(0ad0dh)		;28ee	3a 0d ad	: . .
	and a			;28f1	a7		.
	ret nz			;28f2	c0		.
	ld ix,0a8a0h		;28f3	dd 21 a0 a8	. ! . .
	ld iy,0aa24h		;28f7	fd 21 24 aa	. ! $ .
	jp l290eh		;28fb	c3 0e 29	. . )
sub_28feh:
	ld a,(0ad0dh)		;28fe	3a 0d ad	: . .
	and a			;2901	a7		.
	ret nz			;2902	c0		.
	ld ix,0a8b0h		;2903	dd 21 b0 a8	. ! . .
	ld iy,0aa26h		;2907	fd 21 26 aa	. ! & .
	jp l290eh		;290b	c3 0e 29	. . )
l290eh:
	ld a,(0ad04h)		;290e	3a 04 ad	: . .
	and 007h		;2911	e6 07		. .
	rst 30h			;2913	f7		.
	daa			;2914	27		'
	add hl,hl		;2915	29		)
	ld c,h			;2916	4c		L
	add hl,hl		;2917	29		)
	add a,h			;2918	84		.
	add hl,hl		;2919	29		)
	or b			;291a	b0		.
	add hl,hl		;291b	29		)
	push de			;291c	d5		.
	add hl,hl		;291d	29		)
sub_291eh:
	add a,(hl)		;291e	86		.
	ex de,hl		;291f	eb		.
	ld c,(hl)		;2920	4e		N
	ex de,hl		;2921	eb		.
	inc hl			;2922	23		#
	inc de			;2923	13		.
	djnz sub_291eh		;2924	10 f8		. .
	ret			;2926	c9		.
	ld a,(ix+000h)		;2927	dd 7e 00	. ~ .
	and a			;292a	a7		.
	ret z			;292b	c8		.
	inc a			;292c	3c		<
	jr z,l2936h		;292d	28 07		( .
	inc a			;292f	3c		<
	jp z,l2b52h		;2930	ca 52 2b	. R +
	jp l2b93h		;2933	c3 93 2b	. . +
l2936h:
	call sub_2befh		;2936	cd ef 2b	. . +
	call sub_5840h		;2939	cd 40 58	. @ X
	call sub_2b83h		;293c	cd 83 2b	. . +
	jp c,sub_2bdeh		;293f	da de 2b	. . +
	call sub_3ed6h		;2942	cd d6 3e	. . >
	call sub_2a3ch		;2945	cd 3c 2a	. < *
	call sub_4243h		;2948	cd 43 42	. C B
	ret			;294b	c9		.
	ld a,(ix+000h)		;294c	dd 7e 00	. ~ .
	and a			;294f	a7		.
	ret z			;2950	c8		.
	inc a			;2951	3c		<
	jr z,l295bh		;2952	28 07		( .
	inc a			;2954	3c		<
	jp z,l2b52h		;2955	ca 52 2b	. R +
	jp l2b93h		;2958	c3 93 2b	. . +
l295bh:
	call sub_2befh		;295b	cd ef 2b	. . +
	call sub_5854h		;295e	cd 54 58	. T X
	call sub_2b83h		;2961	cd 83 2b	. . +
	jp c,sub_2bdeh		;2964	da de 2b	. . +
	call sub_3ed6h		;2967	cd d6 3e	. . >
	call sub_2a47h		;296a	cd 47 2a	. G *
	ret			;296d	c9		.
l296eh:
	add hl,bc		;296e	09		.
	and a			;296f	a7		.
	ld (06e82h),a		;2970	32 82 6e	2 . n
	ld e,b			;2973	58		X
	or l			;2974	b5		.
	ld (hl),a		;2975	77		w
	call po,0ece8h		;2976	e4 e8 ec	. . .
	sbc a,l			;2979	9d		.
	bit 1,a			;297a	cb 4f		. O
	ld d,l			;297c	55		U
	cp 0a3h			;297d	fe a3		. .
	ld sp,l5b81h		;297f	31 81 5b	1 . [
	sbc a,d			;2982	9a		.
	cp c			;2983	b9		.
	ld a,(ix+000h)		;2984	dd 7e 00	. ~ .
	and a			;2987	a7		.
	ret z			;2988	c8		.
	inc a			;2989	3c		<
	jr z,l2993h		;298a	28 07		( .
	inc a			;298c	3c		<
	jp z,l2b52h		;298d	ca 52 2b	. R +
	jp l2b93h		;2990	c3 93 2b	. . +
l2993h:
	ld a,(0a980h)		;2993	3a 80 a9	: . .
	and 003h		;2996	e6 03		. .
	cp 003h			;2998	fe 03		. .
	call c,sub_2befh	;299a	dc ef 2b	. . +
	call sub_5840h		;299d	cd 40 58	. @ X
	call sub_2b83h		;29a0	cd 83 2b	. . +
	jp c,sub_2bdeh		;29a3	da de 2b	. . +
	call sub_3ed6h		;29a6	cd d6 3e	. . >
	call sub_2a97h		;29a9	cd 97 2a	. . *
	call sub_4243h		;29ac	cd 43 42	. C B
	ret			;29af	c9		.
	ld a,(ix+000h)		;29b0	dd 7e 00	. ~ .
	and a			;29b3	a7		.
	ret z			;29b4	c8		.
	inc a			;29b5	3c		<
	jr z,l29bfh		;29b6	28 07		( .
	inc a			;29b8	3c		<
	jp z,l2b52h		;29b9	ca 52 2b	. R +
	jp l2b93h		;29bc	c3 93 2b	. . +
l29bfh:
	call sub_2befh		;29bf	cd ef 2b	. . +
	call sub_58a4h		;29c2	cd a4 58	. . X
	call sub_2b83h		;29c5	cd 83 2b	. . +
	jp c,sub_2bdeh		;29c8	da de 2b	. . +
	call sub_3ed6h		;29cb	cd d6 3e	. . >
	call sub_2afch		;29ce	cd fc 2a	. . *
	call sub_4243h		;29d1	cd 43 42	. C B
	ret			;29d4	c9		.
	ld a,(ix+000h)		;29d5	dd 7e 00	. ~ .
	and a			;29d8	a7		.
	ret z			;29d9	c8		.
	inc a			;29da	3c		<
	jr z,l29e4h		;29db	28 07		( .
	inc a			;29dd	3c		<
	jp z,l2b52h		;29de	ca 52 2b	. R +
	jp l2b93h		;29e1	c3 93 2b	. . +
l29e4h:
	call sub_29f7h		;29e4	cd f7 29	. . )
	call sub_2b83h		;29e7	cd 83 2b	. . +
	jp c,sub_2bdeh		;29ea	da de 2b	. . +
	call sub_2b38h		;29ed	cd 38 2b	. 8 +
	call sub_3ed6h		;29f0	cd d6 3e	. . >
	call sub_4243h		;29f3	cd 43 42	. C B
	ret			;29f6	c9		.
sub_29f7h:
	ld a,078h		;29f7	3e 78		> x
	sub (iy+031h)		;29f9	fd 96 31	. . 1
	add a,048h		;29fc	c6 48		. H
	cp 090h			;29fe	fe 90		. .
	jr c,l2a1ch		;2a00	38 1a		8 .
	ld a,084h		;2a02	3e 84		> .
	sub (iy+031h)		;2a04	fd 96 31	. . 1
	add a,048h		;2a07	c6 48		. H
	cp 090h			;2a09	fe 90		. .
	jr c,l2a1ch		;2a0b	38 0f		8 .
	call sub_2befh		;2a0d	cd ef 2b	. . +
l2a10h:
	ld a,(0a980h)		;2a10	3a 80 a9	: . .
	rrca			;2a13	0f		.
	and 001h		;2a14	e6 01		. .
	jp z,l58aah		;2a16	ca aa 58	. . X
	jp l5860h		;2a19	c3 60 58	. ` X
l2a1ch:
	xor a			;2a1c	af		.
	ld (0ad04h),a		;2a1d	32 04 ad	2 . .
	call sub_2befh		;2a20	cd ef 2b	. . +
	ld a,004h		;2a23	3e 04		> .
	ld (0ad04h),a		;2a25	32 04 ad	2 . .
	jr l2a10h		;2a28	18 e6		. .
	ld a,(ix+004h)		;2a2a	dd 7e 04	. ~ .
	dec a			;2a2d	3d		=
	jp z,l2b93h		;2a2e	ca 93 2b	. . +
	ld (ix+004h),a		;2a31	dd 77 04	. w .
	ld (ix+000h),0ffh	;2a34	dd 36 00 ff	. 6 . .
	call sub_2bbah		;2a38	cd ba 2b	. . +
	ret			;2a3b	c9		.
sub_2a3ch:
	call sub_2a57h		;2a3c	cd 57 2a	. W *
	ld (iy+030h),c		;2a3f	fd 71 30	. q 0
	ld a,b			;2a42	78		x
	ld (iy+001h),a		;2a43	fd 77 01	. w .
	ret			;2a46	c9		.
sub_2a47h:
	call sub_2a57h		;2a47	cd 57 2a	. W *
	ld a,c			;2a4a	79		y
	add a,035h		;2a4b	c6 35		. 5
	ld (iy+030h),a		;2a4d	fd 77 30	. w 0
	ld a,b			;2a50	78		x
	add a,010h		;2a51	c6 10		. .
	ld (iy+001h),a		;2a53	fd 77 01	. w .
	ret			;2a56	c9		.
sub_2a57h:
	ld de,l0010h		;2a57	11 10 00	. . .
	ld a,(ix+002h)		;2a5a	dd 7e 02	. ~ .
	add a,008h		;2a5d	c6 08		. .
	rrca			;2a5f	0f		.
	rrca			;2a60	0f		.
	rrca			;2a61	0f		.
	rrca			;2a62	0f		.
	and 00fh		;2a63	e6 0f		. .
	ld hl,l2a77h		;2a65	21 77 2a	! w *
	rst 18h			;2a68	df		.
	ld b,(hl)		;2a69	46		F
	add hl,de		;2a6a	19		.
	ld c,(hl)		;2a6b	4e		N
	ld a,(0a980h)		;2a6c	3a 80 a9	: . .
	bit 1,a			;2a6f	cb 4f		. O
	ret z			;2a71	c8		.
	ld a,b			;2a72	78		x
	add a,008h		;2a73	c6 08		. .
	ld b,a			;2a75	47		G
	ret			;2a76	c9		.
l2a77h:
	inc c			;2a77	0c		.
	dec c			;2a78	0d		.
	ld c,00fh		;2a79	0e 0f		. .
	ex af,af'		;2a7b	08		.
	rrca			;2a7c	0f		.
	ld c,00dh		;2a7d	0e 0d		. .
	inc c			;2a7f	0c		.
	dec bc			;2a80	0b		.
	ld a,(bc)		;2a81	0a		.
	add hl,bc		;2a82	09		.
	ex af,af'		;2a83	08		.
	add hl,bc		;2a84	09		.
	ld a,(bc)		;2a85	0a		.
	dec bc			;2a86	0b		.
	ld b,c			;2a87	41		A
	ld b,c			;2a88	41		A
	ld b,c			;2a89	41		A
	ld b,c			;2a8a	41		A
	add a,c			;2a8b	81		.
	pop bc			;2a8c	c1		.
	pop bc			;2a8d	c1		.
	pop bc			;2a8e	c1		.
	pop bc			;2a8f	c1		.
	pop bc			;2a90	c1		.
	pop bc			;2a91	c1		.
	pop bc			;2a92	c1		.
	ld b,c			;2a93	41		A
	ld b,c			;2a94	41		A
	ld b,c			;2a95	41		A
	ld b,c			;2a96	41		A
sub_2a97h:
	ld a,(ix+002h)		;2a97	dd 7e 02	. ~ .
	add a,004h		;2a9a	c6 04		. .
	and 0f8h		;2a9c	e6 f8		. .
	rrca			;2a9e	0f		.
	rrca			;2a9f	0f		.
	and 03fh		;2aa0	e6 3f		. ?
	ld hl,l2abch		;2aa2	21 bc 2a	! . *
	rst 18h			;2aa5	df		.
	ld b,(hl)		;2aa6	46		F
	ld a,(0a980h)		;2aa7	3a 80 a9	: . .
	and 002h		;2aaa	e6 02		. .
	jr nz,l2ab8h		;2aac	20 0a		  .
l2aaeh:
	add a,b			;2aae	80		.
	ld (iy+001h),a		;2aaf	fd 77 01	. w .
	inc hl			;2ab2	23		#
	ld a,(hl)		;2ab3	7e		~
	ld (iy+030h),a		;2ab4	fd 77 30	. w 0
	ret			;2ab7	c9		.
l2ab8h:
	ld a,008h		;2ab8	3e 08		> .
	jr l2aaeh		;2aba	18 f2		. .
l2abch:
	add a,b			;2abc	80		.
	call c,0dc80h		;2abd	dc 80 dc	. . .
	add a,b			;2ac0	80		.
	call c,0dc80h		;2ac1	dc 80 dc	. . .
	add a,c			;2ac4	81		.
	call c,0dc81h		;2ac5	dc 81 dc	. . .
	add a,d			;2ac8	82		.
	call c,0dc83h		;2ac9	dc 83 dc	. . .
	add a,h			;2acc	84		.
	ld e,h			;2acd	5c		\
	add a,h			;2ace	84		.
	ld e,h			;2acf	5c		\
	add a,e			;2ad0	83		.
	ld e,h			;2ad1	5c		\
	add a,d			;2ad2	82		.
	ld e,h			;2ad3	5c		\
	add a,c			;2ad4	81		.
	ld e,h			;2ad5	5c		\
	add a,c			;2ad6	81		.
	ld e,h			;2ad7	5c		\
	add a,b			;2ad8	80		.
	ld e,h			;2ad9	5c		\
	add a,b			;2ada	80		.
	ld e,h			;2adb	5c		\
	add a,b			;2adc	80		.
	ld e,h			;2add	5c		\
	add a,b			;2ade	80		.
	ld e,h			;2adf	5c		\
	add a,b			;2ae0	80		.
	ld e,h			;2ae1	5c		\
	add a,b			;2ae2	80		.
	ld e,h			;2ae3	5c		\
	add a,c			;2ae4	81		.
	ld e,h			;2ae5	5c		\
	add a,c			;2ae6	81		.
	ld e,h			;2ae7	5c		\
	add a,d			;2ae8	82		.
	ld e,h			;2ae9	5c		\
	add a,e			;2aea	83		.
	ld e,h			;2aeb	5c		\
	add a,h			;2aec	84		.
	call c,0dc84h		;2aed	dc 84 dc	. . .
	add a,e			;2af0	83		.
	call c,0dc82h		;2af1	dc 82 dc	. . .
	add a,c			;2af4	81		.
	call c,0dc81h		;2af5	dc 81 dc	. . .
	add a,b			;2af8	80		.
	call c,0dc80h		;2af9	dc 80 dc	. . .
sub_2afch:
	ld de,l0010h		;2afc	11 10 00	. . .
	ld a,(ix+002h)		;2aff	dd 7e 02	. ~ .
	add a,008h		;2b02	c6 08		. .
	rrca			;2b04	0f		.
	rrca			;2b05	0f		.
	rrca			;2b06	0f		.
	rrca			;2b07	0f		.
	and 00fh		;2b08	e6 0f		. .
	ld hl,l2b18h		;2b0a	21 18 2b	! . +
	rst 18h			;2b0d	df		.
	ld a,(hl)		;2b0e	7e		~
	ld (iy+001h),a		;2b0f	fd 77 01	. w .
	add hl,de		;2b12	19		.
	ld a,(hl)		;2b13	7e		~
	ld (iy+030h),a		;2b14	fd 77 30	. w 0
	ret			;2b17	c9		.
l2b18h:
	inc l			;2b18	2c		,
	dec l			;2b19	2d		-
	ld l,02fh		;2b1a	2e 2f		. /
	jr z,l2b4dh		;2b1c	28 2f		( /
	ld l,02dh		;2b1e	2e 2d		. -
	inc l			;2b20	2c		,
	dec hl			;2b21	2b		+
	ld hl,(02829h)		;2b22	2a 29 28	* ) (
	add hl,hl		;2b25	29		)
	ld hl,(l5b2bh)		;2b26	2a 2b 5b	* + [
	ld e,e			;2b29	5b		[
	ld e,e			;2b2a	5b		[
	ld e,e			;2b2b	5b		[
	sbc a,e			;2b2c	9b		.
	in a,(0dbh)		;2b2d	db db		. .
	in a,(0dbh)		;2b2f	db db		. .
	in a,(0dbh)		;2b31	db db		. .
	in a,(05bh)		;2b33	db 5b		. [
	ld e,e			;2b35	5b		[
	ld e,e			;2b36	5b		[
	ld e,e			;2b37	5b		[
sub_2b38h:
	ld a,(0a980h)		;2b38	3a 80 a9	: . .
	rrca			;2b3b	0f		.
	rrca			;2b3c	0f		.
	and 003h		;2b3d	e6 03		. .
	add a,0d8h		;2b3f	c6 d8		. .
	ld b,a			;2b41	47		G
	ld a,(ix+004h)		;2b42	dd 7e 04	. ~ .
	sub 001h		;2b45	d6 01		. .
	add a,a			;2b47	87		.
	add a,a			;2b48	87		.
	add a,b			;2b49	80		.
	ld (iy+001h),a		;2b4a	fd 77 01	. w .
l2b4dh:
	ld (iy+030h),061h	;2b4d	fd 36 30 61	. 6 0 a
	ret			;2b51	c9		.
l2b52h:
	dec (ix+00eh)		;2b52	dd 35 0e	. 5 .
	jr z,l2b58h		;2b55	28 01		( .
	ret			;2b57	c9		.
l2b58h:
	inc (ix+000h)		;2b58	dd 34 00	. 4 .
	ld (ix+00eh),080h	;2b5b	dd 36 0e 80	. 6 . .
	ret			;2b5f	c9		.
l2b60h:
	ld h,(iy+031h)		;2b60	fd 66 31	. f 1
	ld l,(ix+003h)		;2b63	dd 6e 03	. n .
	ld de,(0a808h)		;2b66	ed 5b 08 a8	. [ . .
	add hl,de		;2b6a	19		.
	ld (iy+031h),h		;2b6b	fd 74 31	. t 1
	ld (ix+003h),l		;2b6e	dd 75 03	. u .
	ld h,(iy+000h)		;2b71	fd 66 00	. f .
	ld l,(ix+005h)		;2b74	dd 6e 05	. n .
	ld de,(0a80ah)		;2b77	ed 5b 0a a8	. [ . .
	add hl,de		;2b7b	19		.
	ld (iy+000h),h		;2b7c	fd 74 00	. t .
	ld (ix+005h),l		;2b7f	dd 75 05	. u .
	ret			;2b82	c9		.
sub_2b83h:
	ld a,(iy+031h)		;2b83	fd 7e 31	. ~ 1
	add a,009h		;2b86	c6 09		. .
	cp 003h			;2b88	fe 03		. .
	ret c			;2b8a	d8		.
	ld a,(iy+000h)		;2b8b	fd 7e 00	. ~ .
	sub 003h		;2b8e	d6 03		. .
	cp 003h			;2b90	fe 03		. .
	ret			;2b92	c9		.
l2b93h:
	ld a,(ix+000h)		;2b93	dd 7e 00	. ~ .
	cp 0f0h			;2b96	fe f0		. .
	jp z,l2bach		;2b98	ca ac 2b	. . +
	cp 03ch			;2b9b	fe 3c		. <
	call z,sub_2bbah	;2b9d	cc ba 2b	. . +
	jp nc,l2bb4h		;2ba0	d2 b4 2b	. . +
	dec (ix+000h)		;2ba3	dd 35 00	. 5 .
	jr z,sub_2bdeh		;2ba6	28 36		( 6
	call sub_2c22h		;2ba8	cd 22 2c	. " ,
	ret			;2bab	c9		.
l2bach:
	ld (ix+000h),03bh	;2bac	dd 36 00 3b	. 6 . ;
	call sub_2bbah		;2bb0	cd ba 2b	. . +
	ret			;2bb3	c9		.
l2bb4h:
	dec (ix+000h)		;2bb4	dd 35 00	. 5 .
	jp sub_5840h		;2bb7	c3 40 58	. @ X
sub_2bbah:
	call sub_5683h		;2bba	cd 83 56	. . V
	ld hl,0ad02h		;2bbd	21 02 ad	! . .
	ld a,(hl)		;2bc0	7e		~
	and a			;2bc1	a7		.
	jr z,l2bc5h		;2bc2	28 01		( .
	dec (hl)		;2bc4	35		5
l2bc5h:
	ld a,(ix+00eh)		;2bc5	dd 7e 0e	. ~ .
	bit 7,a			;2bc8	cb 7f		. .
	ret z			;2bca	c8		.
	ld a,(0a812h)		;2bcb	3a 12 a8	: . .
	and a			;2bce	a7		.
	ret z			;2bcf	c8		.
	ld hl,0a811h		;2bd0	21 11 a8	! . .
	dec (hl)		;2bd3	35		5
	ret nz			;2bd4	c0		.
	ld a,(ix+00fh)		;2bd5	dd 7e 0f	. ~ .
	add a,080h		;2bd8	c6 80		. .
	ld (0a821h),a		;2bda	32 21 a8	2 ! .
	ret			;2bdd	c9		.
sub_2bdeh:
	xor a			;2bde	af		.
	ld (ix+000h),a		;2bdf	dd 77 00	. w .
	ld (ix+003h),a		;2be2	dd 77 03	. w .
	ld (ix+005h),a		;2be5	dd 77 05	. w .
	ld (iy+000h),a		;2be8	fd 77 00	. w .
	ld (iy+031h),a		;2beb	fd 77 31	. w 1
	ret			;2bee	c9		.
sub_2befh:
	ld a,(ix+001h)		;2bef	dd 7e 01	. ~ .
	sub (ix+002h)		;2bf2	dd 96 02	. . .
	ld c,a			;2bf5	4f		O
	add a,002h		;2bf6	c6 02		. .
	cp 004h			;2bf8	fe 04		. .
	ret c			;2bfa	d8		.
	ld b,(ix+002h)		;2bfb	dd 46 02	. F .
	ld a,c			;2bfe	79		y
	cp 080h			;2bff	fe 80		. .
	jr nc,l2c0fh		;2c01	30 0c		0 .
	ld hl,l2c1dh		;2c03	21 1d 2c	! . ,
	ld a,(0ad04h)		;2c06	3a 04 ad	: . .
	rst 8			;2c09	cf		.
	add a,b			;2c0a	80		.
	ld (ix+002h),a		;2c0b	dd 77 02	. w .
	ret			;2c0e	c9		.
l2c0fh:
	ld hl,l2c1dh		;2c0f	21 1d 2c	! . ,
	ld a,(0ad04h)		;2c12	3a 04 ad	: . .
	rst 8			;2c15	cf		.
	sub b			;2c16	90		.
	neg			;2c17	ed 44		. D
	ld (ix+002h),a		;2c19	dd 77 02	. w .
	ret			;2c1c	c9		.
l2c1dh:
	ld bc,sub_0201h		;2c1d	01 01 02	. . .
	ld (bc),a		;2c20	02		.
	dec b			;2c21	05		.
sub_2c22h:
	ld hl,l2c31h		;2c22	21 31 2c	! 1 ,
	push hl			;2c25	e5		.
	ld a,(ix+000h)		;2c26	dd 7e 00	. ~ .
	cp 020h			;2c29	fe 20		.  
l2c2bh:
	jp nc,l2bb4h		;2c2b	d2 b4 2b	. . +
	jp l2b60h		;2c2e	c3 60 2b	. ` +
l2c31h:
	ld a,(ix+000h)		;2c31	dd 7e 00	. ~ .
	cp 02ah			;2c34	fe 2a		. *
	jp nc,l2c71h		;2c36	d2 71 2c	. q ,
	cp 00ah			;2c39	fe 0a		. .
	jr nc,l2c82h		;2c3b	30 45		0 E
	ld a,(0a821h)		;2c3d	3a 21 a8	: ! .
	bit 7,a			;2c40	cb 7f		. .
	jp z,sub_2bdeh		;2c42	ca de 2b	. . +
	ld a,(0a821h)		;2c45	3a 21 a8	: ! .
	res 7,a			;2c48	cb bf		. .
	cp (ix+00fh)		;2c4a	dd be 0f	. . .
l2c4dh:
	jp nz,sub_2bdeh		;2c4d	c2 de 2b	. . +
	ld a,(0a980h)		;2c50	3a 80 a9	: . .
	and 007h		;2c53	e6 07		. .
	jr z,l2c5ah		;2c55	28 03		( .
	inc (ix+000h)		;2c57	dd 34 00	. 4 .
l2c5ah:
	ld (iy+001h),0fch	;2c5a	fd 36 01 fc	. 6 . .
	ld (iy+030h),06ch	;2c5e	fd 36 30 6c	. 6 0 l
	ld a,(ix+000h)		;2c62	dd 7e 00	. ~ .
	cp 001h			;2c65	fe 01		. .
	ret nz			;2c67	c0		.
	ld de,l040ch		;2c68	11 0c 04	. . .
	rst 38h			;2c6b	ff		.
	xor a			;2c6c	af		.
	ld (0a821h),a		;2c6d	32 21 a8	2 ! .
	ret			;2c70	c9		.
l2c71h:
	ld a,(iy+030h)		;2c71	fd 7e 30	. ~ 0
	ld c,a			;2c74	4f		O
	and 0c0h		;2c75	e6 c0		. .
	ld b,a			;2c77	47		G
	ld a,(0a980h)		;2c78	3a 80 a9	: . .
	and 00fh		;2c7b	e6 0f		. .
	add a,b			;2c7d	80		.
	ld (iy+030h),a		;2c7e	fd 77 30	. w 0
	ret			;2c81	c9		.
l2c82h:
	sub 00ah		;2c82	d6 0a		. .
	rrca			;2c84	0f		.
	and 00fh		;2c85	e6 0f		. .
	ld b,a			;2c87	47		G
	ld hl,l2c94h		;2c88	21 94 2c	! . ,
	rst 8			;2c8b	cf		.
	ld (iy+001h),a		;2c8c	fd 77 01	. w .
	ld (iy+030h),03ch	;2c8f	fd 36 30 3c	. 6 0 <
	ret			;2c93	c9		.
l2c94h:
	rst 38h			;2c94	ff		.
	rst 38h			;2c95	ff		.
	ld a,l			;2c96	7d		}
	ld a,l			;2c97	7d		}
	ld a,(hl)		;2c98	7e		~
	ld a,(hl)		;2c99	7e		~
	ld a,l			;2c9a	7d		}
	ld a,l			;2c9b	7d		}
	ld e,e			;2c9c	5b		[
	ld e,e			;2c9d	5b		[
	ld e,d			;2c9e	5a		Z
	ld e,d			;2c9f	5a		Z
	ld e,c			;2ca0	59		Y
	ld e,c			;2ca1	59		Y
	ld e,b			;2ca2	58		X
	ld e,b			;2ca3	58		X
	jr l2c4dh		;2ca4	18 a7		. .
	inc de			;2ca6	13		.
	and l			;2ca7	a5		.
	dec sp			;2ca8	3b		;
	add a,a			;2ca9	87		.
	pop af			;2caa	f1		.
	inc (hl)		;2cab	34		4
	ld c,034h		;2cac	0e 34		. 4
	rst 10h			;2cae	d7		.
	cp a			;2caf	bf		.
	pop af			;2cb0	f1		.
	ld h,l			;2cb1	65		e
	inc de			;2cb2	13		.
	inc de			;2cb3	13		.
	inc de			;2cb4	13		.
	inc de			;2cb5	13		.
	pop af			;2cb6	f1		.
	adc a,b			;2cb7	88		.
	call c,sub_11edh	;2cb8	dc ed 11	. . .
	cp c			;2cbb	b9		.
sub_2cbch:
	ld ix,0a900h		;2cbc	dd 21 00 a9	. ! . .
	ld iy,0aa30h		;2cc0	fd 21 30 aa	. ! 0 .
	ld a,(0ad04h)		;2cc4	3a 04 ad	: . .
	and a			;2cc7	a7		.
	jr z,l2cf5h		;2cc8	28 2b		( +
	cp 004h			;2cca	fe 04		. .
	jr z,l2d02h		;2ccc	28 34		( 4
	call sub_2d21h		;2cce	cd 21 2d	. ! -
	call sub_2d36h		;2cd1	cd 36 2d	. 6 -
	call sub_2d36h		;2cd4	cd 36 2d	. 6 -
	call sub_2d68h		;2cd7	cd 68 2d	. h -
	ret			;2cda	c9		.
	call sub_01c2h		;2cdb	cd c2 01	. . .
	ret nz			;2cde	c0		.
	ld bc,l0004h		;2cdf	01 04 00	. . .
	ld hl,04980h		;2ce2	21 80 49	! . I
	sub a			;2ce5	97		.
l2ce6h:
	xor (hl)		;2ce6	ae		.
	inc hl			;2ce7	23		#
	djnz l2ce6h		;2ce8	10 fc		. .
	dec c			;2cea	0d		.
	jr nz,l2ce6h		;2ceb	20 f9		  .
	add a,0bdh		;2ced	c6 bd		. .
	jp nz,sub_0f11h		;2cef	c2 11 0f	. . .
	jp sub_0f1ah		;2cf2	c3 1a 0f	. . .
l2cf5h:
	call sub_2d15h		;2cf5	cd 15 2d	. . -
	call sub_2d36h		;2cf8	cd 36 2d	. 6 -
	call sub_2d36h		;2cfb	cd 36 2d	. 6 -
	call sub_2d68h		;2cfe	cd 68 2d	. h -
	ret			;2d01	c9		.
l2d02h:
	call sub_2d2dh		;2d02	cd 2d 2d	. - -
	call sub_2d2dh		;2d05	cd 2d 2d	. - -
	call sub_2d62h		;2d08	cd 62 2d	. b -
	call sub_2d62h		;2d0b	cd 62 2d	. b -
	call sub_2d68h		;2d0e	cd 68 2d	. h -
	call sub_2d68h		;2d11	cd 68 2d	. h -
	ret			;2d14	c9		.
sub_2d15h:
	call sub_2d6eh		;2d15	cd 6e 2d	. n -
	call sub_3058h		;2d18	cd 58 30	. X 0
	call sub_3058h		;2d1b	cd 58 30	. X 0
	jp l309bh		;2d1e	c3 9b 30	. . 0
sub_2d21h:
	call sub_2d6eh		;2d21	cd 6e 2d	. n -
	call sub_3058h		;2d24	cd 58 30	. X 0
	call sub_308ah		;2d27	cd 8a 30	. . 0
	jp l309bh		;2d2a	c3 9b 30	. . 0
sub_2d2dh:
	call sub_2d6eh		;2d2d	cd 6e 2d	. n -
	call sub_3058h		;2d30	cd 58 30	. X 0
	jp l309bh		;2d33	c3 9b 30	. . 0
sub_2d36h:
	call sub_2d93h		;2d36	cd 93 2d	. . -
	call sub_3058h		;2d39	cd 58 30	. X 0
	jp l309bh		;2d3c	c3 9b 30	. . 0
	ld a,(0a9c0h)		;2d3f	3a c0 a9	: . .
	and a			;2d42	a7		.
	jp nz,sub_0f1ah		;2d43	c2 1a 0f	. . .
	call sub_4afbh		;2d46	cd fb 4a	. . J
	ld de,l0106h+2		;2d49	11 08 01	. . .
	rst 38h			;2d4c	ff		.
	ld a,(0a817h)		;2d4d	3a 17 a8	: . .
	and a			;2d50	a7		.
	jp nz,l2e3eh		;2d51	c2 3e 2e	. > .
	call sub_0b06h		;2d54	cd 06 0b	. . .
	call sub_0b39h		;2d57	cd 39 0b	. 9 .
	ld hl,l086bh		;2d5a	21 6b 08	! k .
	ld b,014h		;2d5d	06 14		. .
	jp l43e8h		;2d5f	c3 e8 43	. . C
sub_2d62h:
	call sub_2d93h		;2d62	cd 93 2d	. . -
	jp l309bh		;2d65	c3 9b 30	. . 0
sub_2d68h:
	call sub_2df4h		;2d68	cd f4 2d	. . -
	jp l309bh		;2d6b	c3 9b 30	. . 0
sub_2d6eh:
	ld d,(iy+031h)		;2d6e	fd 56 31	. V 1
	ld e,(ix+003h)		;2d71	dd 5e 03	. ^ .
	ld hl,(0a808h)		;2d74	2a 08 a8	* . .
	call sub_2e31h		;2d77	cd 31 2e	. 1 .
	ld (iy+031h),h		;2d7a	fd 74 31	. t 1
	ld (ix+003h),l		;2d7d	dd 75 03	. u .
	ld d,(iy+000h)		;2d80	fd 56 00	. V .
	ld e,(ix+005h)		;2d83	dd 5e 05	. ^ .
	ld hl,(0a80ah)		;2d86	2a 0a a8	* . .
	call sub_2e31h		;2d89	cd 31 2e	. 1 .
	ld (iy+000h),h		;2d8c	fd 74 00	. t .
	ld (ix+005h),l		;2d8f	dd 75 05	. u .
	ret			;2d92	c9		.
sub_2d93h:
	ld d,(iy+031h)		;2d93	fd 56 31	. V 1
	ld e,(ix+003h)		;2d96	dd 5e 03	. ^ .
	ld hl,(0a808h)		;2d99	2a 08 a8	* . .
	call 0303eh		;2d9c	cd 3e 30	. > 0
	ld (iy+031h),h		;2d9f	fd 74 31	. t 1
	ld (ix+003h),l		;2da2	dd 75 03	. u .
	ld d,(iy+000h)		;2da5	fd 56 00	. V .
	ld e,(ix+005h)		;2da8	dd 5e 05	. ^ .
	ld hl,(0a80ah)		;2dab	2a 0a a8	* . .
	call 0303eh		;2dae	cd 3e 30	. > 0
	ld (iy+000h),h		;2db1	fd 74 00	. t .
	ld (ix+005h),l		;2db4	dd 75 05	. u .
	ret			;2db7	c9		.
sub_2db8h:
	ld hl,0ad01h		;2db8	21 01 ad	! . .
	inc (hl)		;2dbb	34		4
	ld hl,0ad04h		;2dbc	21 04 ad	! . .
	ld a,(hl)		;2dbf	7e		~
	inc a			;2dc0	3c		<
	cp 005h			;2dc1	fe 05		. .
	jr c,l2dc6h		;2dc3	38 01		8 .
	xor a			;2dc5	af		.
l2dc6h:
	ld (hl),a		;2dc6	77		w
	ld a,(0ad01h)		;2dc7	3a 01 ad	: . .
	cp 006h			;2dca	fe 06		. .
	jr c,l2dd7h		;2dcc	38 09		8 .
	cp 00bh			;2dce	fe 0b		. .
	jr c,l2ddch		;2dd0	38 0a		8 .
	ld a,(0a9d5h)		;2dd2	3a d5 a9	: . .
	jr l2ddfh		;2dd5	18 08		. .
l2dd7h:
	ld a,(0a9d3h)		;2dd7	3a d3 a9	: . .
	jr l2ddfh		;2dda	18 03		. .
l2ddch:
	ld a,(0a9d4h)		;2ddc	3a d4 a9	: . .
l2ddfh:
	ld (0ad0ah),a		;2ddf	32 0a ad	2 . .
	ld a,(0a9cdh)		;2de2	3a cd a9	: . .
	ld (0ad02h),a		;2de5	32 02 ad	2 . .
	xor a			;2de8	af		.
	ld (0ad0dh),a		;2de9	32 0d ad	2 . .
	ld (0acc6h),a		;2dec	32 c6 ac	2 . .
	dec a			;2def	3d		=
	ld (0ad0eh),a		;2df0	32 0e ad	2 . .
	ret			;2df3	c9		.
sub_2df4h:
	ld d,(iy+031h)		;2df4	fd 56 31	. V 1
	ld e,(ix+003h)		;2df7	dd 5e 03	. ^ .
	ld hl,(0a808h)		;2dfa	2a 08 a8	* . .
	call sub_304dh		;2dfd	cd 4d 30	. M 0
	ld (iy+031h),h		;2e00	fd 74 31	. t 1
	ld (ix+003h),l		;2e03	dd 75 03	. u .
	ld d,(iy+000h)		;2e06	fd 56 00	. V .
	ld e,(ix+005h)		;2e09	dd 5e 05	. ^ .
	ld hl,(0a80ah)		;2e0c	2a 0a a8	* . .
	call sub_304dh		;2e0f	cd 4d 30	. M 0
	ld (iy+000h),h		;2e12	fd 74 00	. t .
	ld (ix+005h),l		;2e15	dd 75 05	. u .
	ret			;2e18	c9		.
l2e19h:
	ld (0a9c1h),a		;2e19	32 c1 a9	2 . .
	ld a,c			;2e1c	79		y
	rrca			;2e1d	0f		.
	rrca			;2e1e	0f		.
	ld c,a			;2e1f	4f		O
	and 001h		;2e20	e6 01		. .
	ld (0a9c2h),a		;2e22	32 c2 a9	2 . .
	ld a,c			;2e25	79		y
	rrca			;2e26	0f		.
	ld c,a			;2e27	4f		O
	and 001h		;2e28	e6 01		. .
	ld (0a9c3h),a		;2e2a	32 c3 a9	2 . .
	ld a,c			;2e2d	79		y
	jp l49a8h		;2e2e	c3 a8 49	. . I
sub_2e31h:
	ld b,h			;2e31	44		D
	ld c,l			;2e32	4d		M
	sra b			;2e33	cb 28		. (
	rr c			;2e35	cb 19		. .
	sra b			;2e37	cb 28		. (
	rr c			;2e39	cb 19		. .
	add hl,bc		;2e3b	09		.
	add hl,de		;2e3c	19		.
	ret			;2e3d	c9		.
l2e3eh:
	ld (l3101h),a		;2e3e	32 01 31	2 . 1
	ld bc,l012fh+1		;2e41	01 30 01	. 0 .
	cpl			;2e44	2f		/
	ld bc,l012ch+2		;2e45	01 2e 01	. . .
	dec l			;2e48	2d		-
	ld bc,l012ch		;2e49	01 2c 01	. , .
	jr z,$+3		;2e4c	28 01		( .
	ld h,001h		;2e4e	26 01		& .
	inc h			;2e50	24		$
	ld bc,00122h		;2e51	01 22 01	. " .
	jr nz,l2e57h		;2e54	20 01		  .
	dec de			;2e56	1b		.
l2e57h:
	ld bc,l0117h+1		;2e57	01 18 01	. . .
	ld d,001h		;2e5a	16 01		. .
	ld de,l0e00h+1		;2e5c	11 01 0e	. . .
	ld bc,l0109h+2		;2e5f	01 0b 01	. . .
	ex af,af'		;2e62	08		.
	ld bc,l0103h		;2e63	01 03 01	. . .
	nop			;2e66	00		.
	ld bc,l00fdh		;2e67	01 fd 00	. . .
	ret m			;2e6a	f8		.
	nop			;2e6b	00		.
	push af			;2e6c	f5		.
	nop			;2e6d	00		.
	jp p,0ed00h		;2e6e	f2 00 ed	. . .
	nop			;2e71	00		.
	jp pe,0e700h		;2e72	ea 00 e7	. . .
	nop			;2e75	00		.
	call po,0df00h		;2e76	e4 00 df	. . .
	nop			;2e79	00		.
	call c,0d900h		;2e7a	dc 00 d9	. . .
	nop			;2e7d	00		.
	call nc,0d100h		;2e7e	d4 00 d1	. . .
	nop			;2e81	00		.
	call 0c800h		;2e82	cd 00 c8	. . .
	nop			;2e85	00		.
	push bc			;2e86	c5		.
	nop			;2e87	00		.
	pop bc			;2e88	c1		.
	nop			;2e89	00		.
	cp e			;2e8a	bb		.
	nop			;2e8b	00		.
	or a			;2e8c	b7		.
	nop			;2e8d	00		.
	or h			;2e8e	b4		.
	nop			;2e8f	00		.
	xor (hl)		;2e90	ae		.
	nop			;2e91	00		.
	xor b			;2e92	a8		.
	nop			;2e93	00		.
	and c			;2e94	a1		.
	nop			;2e95	00		.
	sbc a,h			;2e96	9c		.
	nop			;2e97	00		.
	sub e			;2e98	93		.
	nop			;2e99	00		.
	sub b			;2e9a	90		.
	nop			;2e9b	00		.
	adc a,b			;2e9c	88		.
	nop			;2e9d	00		.
	add a,b			;2e9e	80		.
	nop			;2e9f	00		.
	ld a,d			;2ea0	7a		z
	nop			;2ea1	00		.
	ld (hl),d		;2ea2	72		r
	nop			;2ea3	00		.
	ld l,c			;2ea4	69		i
	nop			;2ea5	00		.
	ld h,e			;2ea6	63		c
	nop			;2ea7	00		.
	ld e,d			;2ea8	5a		Z
	nop			;2ea9	00		.
	ld d,c			;2eaa	51		Q
	nop			;2eab	00		.
	ld c,d			;2eac	4a		J
	nop			;2ead	00		.
	ld b,b			;2eae	40		@
	nop			;2eaf	00		.
	scf			;2eb0	37		7
	nop			;2eb1	00		.
	jr nc,l2eb4h		;2eb2	30 00		0 .
l2eb4h:
	ld h,000h		;2eb4	26 00		& .
	inc e			;2eb6	1c		.
	nop			;2eb7	00		.
	ld (de),a		;2eb8	12		.
	nop			;2eb9	00		.
	ex af,af'		;2eba	08		.
	nop			;2ebb	00		.
	nop			;2ebc	00		.
	nop			;2ebd	00		.
	nop			;2ebe	00		.
	nop			;2ebf	00		.
	ret m			;2ec0	f8		.
	rst 38h			;2ec1	ff		.
	xor 0ffh		;2ec2	ee ff		. .
	nop			;2ec4	00		.
	nop			;2ec5	00		.
	jp c,0d0ffh		;2ec6	da ff d0	. . .
	rst 38h			;2ec9	ff		.
	ret			;2eca	c9		.
	rst 38h			;2ecb	ff		.
	ret nz			;2ecc	c0		.
	rst 38h			;2ecd	ff		.
	or (hl)			;2ece	b6		.
	rst 38h			;2ecf	ff		.
	xor a			;2ed0	af		.
	rst 38h			;2ed1	ff		.
	and (hl)		;2ed2	a6		.
	rst 38h			;2ed3	ff		.
	sbc a,l			;2ed4	9d		.
	rst 38h			;2ed5	ff		.
	sub a			;2ed6	97		.
	rst 38h			;2ed7	ff		.
	adc a,(hl)		;2ed8	8e		.
	rst 38h			;2ed9	ff		.
	add a,(hl)		;2eda	86		.
	rst 38h			;2edb	ff		.
	add a,b			;2edc	80		.
	rst 38h			;2edd	ff		.
	ld a,b			;2ede	78		x
	rst 38h			;2edf	ff		.
	ld (hl),b		;2ee0	70		p
	rst 38h			;2ee1	ff		.
	ld l,l			;2ee2	6d		m
	rst 38h			;2ee3	ff		.
	ld (hl),b		;2ee4	70		p
	rst 38h			;2ee5	ff		.
	ld e,a			;2ee6	5f		_
	rst 38h			;2ee7	ff		.
	ld e,b			;2ee8	58		X
	rst 38h			;2ee9	ff		.
	ld d,d			;2eea	52		R
	rst 38h			;2eeb	ff		.
	ld c,h			;2eec	4c		L
	rst 38h			;2eed	ff		.
	ld c,c			;2eee	49		I
	rst 38h			;2eef	ff		.
	ld b,l			;2ef0	45		E
	rst 38h			;2ef1	ff		.
	ccf			;2ef2	3f		?
	rst 38h			;2ef3	ff		.
	dec sp			;2ef4	3b		;
	rst 38h			;2ef5	ff		.
	jr c,$+1		;2ef6	38 ff		8 .
	inc sp			;2ef8	33		3
	rst 38h			;2ef9	ff		.
	cpl			;2efa	2f		/
	rst 38h			;2efb	ff		.
	inc l			;2efc	2c		,
	rst 38h			;2efd	ff		.
	daa			;2efe	27		'
	rst 38h			;2eff	ff		.
	inc h			;2f00	24		$
l2f01h:
	rst 38h			;2f01	ff		.
	ld hl,l21ffh		;2f02	21 ff 21	! . !
	rst 38h			;2f05	ff		.
	add hl,de		;2f06	19		.
	rst 38h			;2f07	ff		.
	ld d,0ffh		;2f08	16 ff		. .
	inc de			;2f0a	13		.
	rst 38h			;2f0b	ff		.
	ld c,0ffh		;2f0c	0e ff		. .
	dec bc			;2f0e	0b		.
	rst 38h			;2f0f	ff		.
	ex af,af'		;2f10	08		.
	rst 38h			;2f11	ff		.
	inc bc			;2f12	03		.
	rst 38h			;2f13	ff		.
	nop			;2f14	00		.
	rst 38h			;2f15	ff		.
	defb 0fdh,0feh,0f8h ;illegal sequence	;2f16	fd fe f8	. . .
	cp 0f5h			;2f19	fe f5		. .
	cp 0f2h			;2f1b	fe f2		. .
	cp 0efh			;2f1d	fe ef		. .
	cp 0eah			;2f1f	fe ea		. .
	cp 0e8h			;2f21	fe e8		. .
	cp 0e5h			;2f23	fe e5		. .
	cp 0e0h			;2f25	fe e0		. .
	cp 0deh			;2f27	fe de		. .
	cp 0dch			;2f29	fe dc		. .
	cp 0dah			;2f2b	fe da		. .
	cp 0d8h			;2f2d	fe d8		. .
	cp 0d4h			;2f2f	fe d4		. .
	cp 0d3h			;2f31	fe d3		. .
	cp 0d2h			;2f33	fe d2		. .
	cp 0d1h			;2f35	fe d1		. .
	cp 0d0h			;2f37	fe d0		. .
	cp 0cfh			;2f39	fe cf		. .
	cp 0ceh			;2f3b	fe ce		. .
	cp 0ceh			;2f3d	fe ce		. .
	cp 0cfh			;2f3f	fe cf		. .
	cp 0d0h			;2f41	fe d0		. .
	cp 0d1h			;2f43	fe d1		. .
	cp 0d2h			;2f45	fe d2		. .
	cp 0d3h			;2f47	fe d3		. .
	cp 0d4h			;2f49	fe d4		. .
	cp 0d8h			;2f4b	fe d8		. .
	cp 0dah			;2f4d	fe da		. .
	cp 0dch			;2f4f	fe dc		. .
	cp 0deh			;2f51	fe de		. .
	cp 0e0h			;2f53	fe e0		. .
	cp 0e5h			;2f55	fe e5		. .
	cp 0e8h			;2f57	fe e8		. .
	cp 0eah			;2f59	fe ea		. .
	cp 0efh			;2f5b	fe ef		. .
	cp 0f2h			;2f5d	fe f2		. .
	cp 0f5h			;2f5f	fe f5		. .
	cp 0f8h			;2f61	fe f8		. .
	cp 0fdh			;2f63	fe fd		. .
	cp 000h			;2f65	fe 00		. .
	rst 38h			;2f67	ff		.
	inc bc			;2f68	03		.
	rst 38h			;2f69	ff		.
	ex af,af'		;2f6a	08		.
	rst 38h			;2f6b	ff		.
	dec bc			;2f6c	0b		.
	rst 38h			;2f6d	ff		.
	ld c,0ffh		;2f6e	0e ff		. .
	inc de			;2f70	13		.
	rst 38h			;2f71	ff		.
	ld d,0ffh		;2f72	16 ff		. .
	add hl,de		;2f74	19		.
	rst 38h			;2f75	ff		.
	inc e			;2f76	1c		.
	rst 38h			;2f77	ff		.
	ld hl,024ffh		;2f78	21 ff 24	! . $
	rst 38h			;2f7b	ff		.
	daa			;2f7c	27		'
	rst 38h			;2f7d	ff		.
	inc l			;2f7e	2c		,
	rst 38h			;2f7f	ff		.
	cpl			;2f80	2f		/
	rst 38h			;2f81	ff		.
	inc sp			;2f82	33		3
	rst 38h			;2f83	ff		.
	jr c,$+1		;2f84	38 ff		8 .
	dec sp			;2f86	3b		;
	rst 38h			;2f87	ff		.
	ccf			;2f88	3f		?
	rst 38h			;2f89	ff		.
	ld b,l			;2f8a	45		E
	rst 38h			;2f8b	ff		.
	ld c,c			;2f8c	49		I
	rst 38h			;2f8d	ff		.
	ld c,h			;2f8e	4c		L
	rst 38h			;2f8f	ff		.
	ld d,d			;2f90	52		R
	rst 38h			;2f91	ff		.
	ld e,b			;2f92	58		X
	rst 38h			;2f93	ff		.
	ld e,a			;2f94	5f		_
	rst 38h			;2f95	ff		.
	ld h,h			;2f96	64		d
	rst 38h			;2f97	ff		.
	ld l,l			;2f98	6d		m
	rst 38h			;2f99	ff		.
	ld (hl),b		;2f9a	70		p
	rst 38h			;2f9b	ff		.
	ld a,b			;2f9c	78		x
	rst 38h			;2f9d	ff		.
	add a,b			;2f9e	80		.
	rst 38h			;2f9f	ff		.
	add a,(hl)		;2fa0	86		.
	rst 38h			;2fa1	ff		.
	adc a,(hl)		;2fa2	8e		.
	rst 38h			;2fa3	ff		.
	sub a			;2fa4	97		.
	rst 38h			;2fa5	ff		.
	sbc a,l			;2fa6	9d		.
	rst 38h			;2fa7	ff		.
	and (hl)		;2fa8	a6		.
	rst 38h			;2fa9	ff		.
	xor a			;2faa	af		.
	rst 38h			;2fab	ff		.
	or (hl)			;2fac	b6		.
	rst 38h			;2fad	ff		.
	ret nz			;2fae	c0		.
	rst 38h			;2faf	ff		.
	ret			;2fb0	c9		.
	rst 38h			;2fb1	ff		.
	ret nc			;2fb2	d0		.
	rst 38h			;2fb3	ff		.
	jp c,0e4ffh		;2fb4	da ff e4	. . .
	rst 38h			;2fb7	ff		.
	xor 0ffh		;2fb8	ee ff		. .
	ret m			;2fba	f8		.
	rst 38h			;2fbb	ff		.
	nop			;2fbc	00		.
	nop			;2fbd	00		.
	nop			;2fbe	00		.
	nop			;2fbf	00		.
	ex af,af'		;2fc0	08		.
	nop			;2fc1	00		.
	ld (de),a		;2fc2	12		.
	nop			;2fc3	00		.
	inc e			;2fc4	1c		.
	nop			;2fc5	00		.
	ld h,000h		;2fc6	26 00		& .
	jr nc,l2fcah		;2fc8	30 00		0 .
l2fcah:
	scf			;2fca	37		7
	nop			;2fcb	00		.
	ld b,b			;2fcc	40		@
	nop			;2fcd	00		.
	ld c,d			;2fce	4a		J
	nop			;2fcf	00		.
	ld d,c			;2fd0	51		Q
	nop			;2fd1	00		.
	ld e,d			;2fd2	5a		Z
	nop			;2fd3	00		.
	ld h,e			;2fd4	63		c
	nop			;2fd5	00		.
	ld l,c			;2fd6	69		i
	nop			;2fd7	00		.
	ld (hl),d		;2fd8	72		r
	nop			;2fd9	00		.
	ld a,d			;2fda	7a		z
	nop			;2fdb	00		.
	add a,b			;2fdc	80		.
	nop			;2fdd	00		.
	adc a,b			;2fde	88		.
	nop			;2fdf	00		.
	sub b			;2fe0	90		.
	nop			;2fe1	00		.
	sub e			;2fe2	93		.
	nop			;2fe3	00		.
	sub e			;2fe4	93		.
	nop			;2fe5	00		.
	and c			;2fe6	a1		.
	nop			;2fe7	00		.
	xor b			;2fe8	a8		.
	nop			;2fe9	00		.
	xor (hl)		;2fea	ae		.
	nop			;2feb	00		.
	or h			;2fec	b4		.
	nop			;2fed	00		.
	or a			;2fee	b7		.
	nop			;2fef	00		.
	cp e			;2ff0	bb		.
	nop			;2ff1	00		.
	pop bc			;2ff2	c1		.
	nop			;2ff3	00		.
	push bc			;2ff4	c5		.
	nop			;2ff5	00		.
	ret z			;2ff6	c8		.
	nop			;2ff7	00		.
	call 0d100h		;2ff8	cd 00 d1	. . .
	nop			;2ffb	00		.
	call nc,0d900h		;2ffc	d4 00 d9	. . .
l2fffh:
	nop			;2fff	00		.
	call c,0df00h		;3000	dc 00 df	. . .
	nop			;3003	00		.
	call c,0e700h		;3004	dc 00 e7	. . .
	nop			;3007	00		.
	jp pe,0ed00h		;3008	ea 00 ed	. . .
	nop			;300b	00		.
	jp p,0f500h		;300c	f2 00 f5	. . .
	nop			;300f	00		.
	ret m			;3010	f8		.
	nop			;3011	00		.
	defb 0fdh,000h,000h ;illegal sequence	;3012	fd 00 00	. . .
	ld bc,l0103h		;3015	01 03 01	. . .
	ex af,af'		;3018	08		.
	ld bc,l0109h+2		;3019	01 0b 01	. . .
	ld c,001h		;301c	0e 01		. .
	ld de,l1601h		;301e	11 01 16	. . .
	ld bc,l0117h+1		;3021	01 18 01	. . .
	ld de,l2001h		;3024	11 01 20	. .  
	ld bc,00122h		;3027	01 22 01	. " .
	inc h			;302a	24		$
	ld bc,00126h		;302b	01 26 01	. & .
	jr z,l3031h		;302e	28 01		( .
	inc l			;3030	2c		,
l3031h:
	ld bc,l012ch+1		;3031	01 2d 01	. - .
	ld l,001h		;3034	2e 01		. .
	cpl			;3036	2f		/
	ld bc,l012fh+1		;3037	01 30 01	. 0 .
	ld sp,l3201h		;303a	31 01 32	1 . 2
	ld bc,04d44h		;303d	01 44 4d	. D M
	sra b			;3040	cb 28		. (
	rr c			;3042	cb 19		. .
	sra b			;3044	cb 28		. (
	rr c			;3046	cb 19		. .
	and a			;3048	a7		.
	sbc hl,bc		;3049	ed 42		. B
	add hl,de		;304b	19		.
	ret			;304c	c9		.
sub_304dh:
	ld b,h			;304d	44		D
	ld c,l			;304e	4d		M
	sra b			;304f	cb 28		. (
	rr c			;3051	cb 19		. .
	and a			;3053	a7		.
	sbc hl,bc		;3054	ed 42		. B
	add hl,de		;3056	19		.
	ret			;3057	c9		.
sub_3058h:
	ld b,(iy+031h)		;3058	fd 46 31	. F 1
	ld c,(iy+000h)		;305b	fd 4e 00	. N .
	ld a,010h		;305e	3e 10		> .
	add a,b			;3060	80		.
	ld (iy+033h),a		;3061	fd 77 33	. w 3
	ld (iy+002h),c		;3064	fd 71 02	. q .
	jp l309bh		;3067	c3 9b 30	. . 0
	ld b,(iy+031h)		;306a	fd 46 31	. F 1
	ld c,(iy+000h)		;306d	fd 4e 00	. N .
	ld h,008h		;3070	26 08		& .
	ld l,06eh		;3072	2e 6e		. n
l3074h:
	ld a,(hl)		;3074	7e		~
	add a,c			;3075	81		.
	ld (iy+033h),b		;3076	fd 70 33	. p 3
	ld (iy+002h),a		;3079	fd 77 02	. w .
	jp l309bh		;307c	c3 9b 30	. . 0
l307fh:
	ld (hl),e		;307f	73		s
	and (hl)		;3080	a6		.
	djnz l3074h		;3081	10 f1		. .
	rst 10h			;3083	d7		.
	inc (hl)		;3084	34		4
	and l			;3085	a5		.
	add a,a			;3086	87		.
	cp a			;3087	bf		.
	pop af			;3088	f1		.
	cp c			;3089	b9		.
sub_308ah:
	ld b,(iy+031h)		;308a	fd 46 31	. F 1
	ld c,(iy+000h)		;308d	fd 4e 00	. N .
	ld h,0f0h		;3090	26 f0		& .
	ld l,010h		;3092	2e 10		. .
	add hl,bc		;3094	09		.
	ld (iy+033h),h		;3095	fd 74 33	. t 3
	ld (iy+002h),l		;3098	fd 75 02	. u .
l309bh:
	ld de,l0010h		;309b	11 10 00	. . .
	add ix,de		;309e	dd 19		. .
	inc iy			;30a0	fd 23		. #
	inc iy			;30a2	fd 23		. #
	ret			;30a4	c9		.
sub_30a5h:
	ld hl,l086bh		;30a5	21 6b 08	! k .
	ld c,022h		;30a8	0e 22		. "
	ld b,010h		;30aa	06 10		. .
	call sub_0b4ch		;30ac	cd 4c 0b	. L .
	ld a,(0ad04h)		;30af	3a 04 ad	: . .
	add a,a			;30b2	87		.
	add a,a			;30b3	87		.
	add a,a			;30b4	87		.
	ld c,a			;30b5	4f		O
	ld hl,l3176h		;30b6	21 76 31	! v 1
	rst 18h			;30b9	df		.
	ld de,0aa31h		;30ba	11 31 aa	. 1 .
	ld b,008h		;30bd	06 08		. .
l30bfh:
	ld a,(hl)		;30bf	7e		~
	ld (de),a		;30c0	12		.
	inc hl			;30c1	23		#
	inc de			;30c2	13		.
	inc de			;30c3	13		.
	djnz l30bfh		;30c4	10 f9		. .
	ld a,(0ad04h)		;30c6	3a 04 ad	: . .
	cp 004h			;30c9	fe 04		. .
	ld c,a			;30cb	4f		O
	jp z,l3156h		;30cc	ca 56 31	. V 1
	ld a,0cch		;30cf	3e cc		> .
l30d1h:
	ld hl,0aa60h		;30d1	21 60 aa	! ` .
	ld de,RESET_VECTOR+2	;30d4	11 02 00	. . .
	ld b,008h		;30d7	06 08		. .
l30d9h:
	ld (hl),a		;30d9	77		w
	add hl,de		;30da	19		.
	djnz l30d9h		;30db	10 fc		. .
	ld a,c			;30dd	79		y
	cp 004h			;30de	fe 04		. .
	jp c,l3117h		;30e0	da 17 31	. . 1
	ld hl,0acc7h		;30e3	21 c7 ac	! . .
	ld a,(hl)		;30e6	7e		~
	cp 03bh			;30e7	fe 3b		. ;
	jp nz,l315bh		;30e9	c2 5b 31	. [ 1
	inc hl			;30ec	23		#
	ld a,(hl)		;30ed	7e		~
	cp 005h			;30ee	fe 05		. .
	jp z,l30f8h		;30f0	ca f8 30	. . 0
	cp 010h			;30f3	fe 10		. .
	jp nz,l315bh		;30f5	c2 5b 31	. [ 1
l30f8h:
	ld b,008h		;30f8	06 08		. .
	ld iy,0aa30h		;30fa	fd 21 30 aa	. ! 0 .
	ld hl,l315eh		;30fe	21 5e 31	! ^ 1
l3101h:
	ld a,(hl)		;3101	7e		~
	ld (iy+031h),a		;3102	fd 77 31	. w 1
	inc hl			;3105	23		#
	ld a,(hl)		;3106	7e		~
	ld (iy+000h),a		;3107	fd 77 00	. w .
l310ah:
	inc hl			;310a	23		#
	inc iy			;310b	fd 23		. #
	inc iy			;310d	fd 23		. #
	djnz l3101h		;310f	10 f0		. .
	jp sub_2cbch		;3111	c3 bc 2c	. . ,
l3114h:
	jp l307fh		;3114	c3 7f 30	. . 0
l3117h:
	ld hl,0ad39h		;3117	21 39 ad	! 9 .
	ld a,(hl)		;311a	7e		~
	cp 068h			;311b	fe 68		. h
	jp nz,l3114h		;311d	c2 14 31	. . 1
	inc hl			;3120	23		#
	ld a,(hl)		;3121	7e		~
	cp 010h			;3122	fe 10		. .
	jp z,l312ch		;3124	ca 2c 31	. , 1
	cp 005h			;3127	fe 05		. .
	jp nz,l3114h		;3129	c2 14 31	. . 1
l312ch:
	ld hl,l316eh		;312c	21 6e 31	! n 1
	ld b,004h		;312f	06 04		. .
	ld iy,0aa30h		;3131	fd 21 30 aa	. ! 0 .
l3135h:
	ld a,(hl)		;3135	7e		~
	ld (iy+031h),a		;3136	fd 77 31	. w 1
	add a,010h		;3139	c6 10		. .
	ld (iy+033h),a		;313b	fd 77 33	. w 3
	inc hl			;313e	23		#
	ld a,(hl)		;313f	7e		~
l3140h:
	ld (iy+000h),a		;3140	fd 77 00	. w .
	ld (iy+002h),a		;3143	fd 77 02	. w .
	inc hl			;3146	23		#
	ld de,l0010h		;3147	11 10 00	. . .
	add ix,de		;314a	dd 19		. .
	ld de,l0004h		;314c	11 04 00	. . .
	add iy,de		;314f	fd 19		. .
	djnz l3135h		;3151	10 e2		. .
	jp sub_2cbch		;3153	c3 bc 2c	. . ,
l3156h:
	ld a,028h		;3156	3e 28		> (
	jp l30d1h		;3158	c3 d1 30	. . 0
l315bh:
	jp l3176h		;315b	c3 76 31	. v 1
l315eh:
	ld b,b			;315e	40		@
	ld l,b			;315f	68		h
	jr c,l31c4h		;3160	38 62		8 b
	ld h,b			;3162	60		`
	ld (hl),b		;3163	70		p
	ld l,b			;3164	68		h
	ret c			;3165	d8		.
	adc a,b			;3166	88		.
	ld e,b			;3167	58		X
	sbc a,c			;3168	99		.
	or b			;3169	b0		.
	scf			;316a	37		7
	ld b,e			;316b	43		C
	rst 8			;316c	cf		.
	ld a,b			;316d	78		x
l316eh:
	jr nz,l3140h		;316e	20 d0		  .
	ld d,b			;3170	50		P
	ld h,b			;3171	60		`
	and b			;3172	a0		.
	and b			;3173	a0		.
	ret nc			;3174	d0		.
	ld h,b			;3175	60		`
l3176h:
	ld h,b			;3176	60		`
	ld l,b			;3177	68		h
	ld h,c			;3178	61		a
	ld h,b			;3179	60		`
	ld h,c			;317a	61		a
	ld h,d			;317b	62		b
	ld h,e			;317c	63		c
	ld e,h			;317d	5c		\
	ld (hl),h		;317e	74		t
	ld (hl),l		;317f	75		u
	halt			;3180	76		v
	ld h,b			;3181	60		`
	ld h,c			;3182	61		a
	ld h,h			;3183	64		d
	ld h,l			;3184	65		e
	ld e,l			;3185	5d		]
	ld (hl),a		;3186	77		w
	ld a,b			;3187	78		x
	ld a,c			;3188	79		y
	ld h,(hl)		;3189	66		f
	ld h,a			;318a	67		g
	ld h,h			;318b	64		d
	ld h,l			;318c	65		e
	ld e,(hl)		;318d	5e		^
	ld a,d			;318e	7a		z
	ld a,e			;318f	7b		{
	ld a,h			;3190	7c		|
	ld h,b			;3191	60		`
	ld h,c			;3192	61		a
	ld h,d			;3193	62		b
	ld h,e			;3194	63		c
	ld e,a			;3195	5f		_
	ld sp,l3330h		;3196	31 30 33	1 0 3
	ld (08685h),a		;3199	32 85 86	2 . .
	add a,a			;319c	87		.
	add a,l			;319d	85		.
	ex af,af'		;319e	08		.
	and a			;319f	a7		.
	ld (07ecah),a		;31a0	32 ca 7e	2 . ~
	ret z			;31a3	c8		.
	rst 38h			;31a4	ff		.
	ld e,a			;31a5	5f		_
	sub e			;31a6	93		.
	ei			;31a7	fb		.
	call nz,0d8afh		;31a8	c4 af d8	. . .
	ld hl,(0e16ch)		;31ab	2a 6c e1	* l .
	ld a,d			;31ae	7a		z
	ld b,d			;31af	42		B
	cp l			;31b0	bd		.
	or b			;31b1	b0		.
	ld e,d			;31b2	5a		Z
	cp c			;31b3	b9		.
sub_31b4h:
	ld a,(0ad05h)		;31b4	3a 05 ad	: . .
	ld c,a			;31b7	4f		O
	and 0f0h		;31b8	e6 f0		. .
	jr z,l31c9h		;31ba	28 0d		( .
	cp 030h			;31bc	fe 30		. 0
	jp nz,l326ch		;31be	c2 6c 32	. l 2
	ld a,(l4903h)		;31c1	3a 03 49	: . I
l31c4h:
	cp 030h			;31c4	fe 30		. 0
	jp nz,l31c9h		;31c6	c2 c9 31	. . 1
l31c9h:
	ld a,c			;31c9	79		y
	and 00fh		;31ca	e6 0f		. .
	cp 007h			;31cc	fe 07		. .
	ret nc			;31ce	d0		.
	ld ix,0a850h		;31cf	dd 21 50 a8	. ! P .
	ld iy,0aa1ah		;31d3	fd 21 1a aa	. ! . .
	add a,a			;31d7	87		.
	ld c,a			;31d8	4f		O
	ld b,000h		;31d9	06 00		. .
	add iy,bc		;31db	fd 09		. .
	add a,a			;31dd	87		.
	add a,a			;31de	87		.
	add a,a			;31df	87		.
	ld c,a			;31e0	4f		O
	add ix,bc		;31e1	dd 09		. .
	ld a,(ix+000h)		;31e3	dd 7e 00	. ~ .
	inc a			;31e6	3c		<
	ret nz			;31e7	c0		.
	call sub_323ah		;31e8	cd 3a 32	. : 2
	ld a,(ix+008h)		;31eb	dd 7e 08	. ~ .
	cp 010h			;31ee	fe 10		. .
	ret z			;31f0	c8		.
	cp 011h			;31f1	fe 11		. .
	jr z,l3201h		;31f3	28 0c		( .
	add a,a			;31f5	87		.
	ld hl,0ac65h		;31f6	21 65 ac	! e .
	rst 18h			;31f9	df		.
	call sub_33b8h		;31fa	cd b8 33	. . 3
l31fdh:
	ld (ix+001h),a		;31fd	dd 77 01	. w .
	ret			;3200	c9		.
l3201h:
	ld hl,0ac65h		;3201	21 65 ac	! e .
	call sub_33b8h		;3204	cd b8 33	. . 3
	add a,080h		;3207	c6 80		. .
	ld (ix+001h),a		;3209	dd 77 01	. w .
	ld (ix+008h),010h	;320c	dd 36 08 10	. 6 . .
	ld (ix+009h),000h	;3210	dd 36 09 00	. 6 . .
	ret			;3214	c9		.
l3215h:
	call sub_0b2bh		;3215	cd 2b 0b	. + .
	xor a			;3218	af		.
	ld (0ad31h),a		;3219	32 31 ad	2 1 .
	ld (0ad20h),a		;321c	32 20 ad	2   .
	dec a			;321f	3d		=
	ld (0ad30h),a		;3220	32 30 ad	2 0 .
	ld a,(0a9c1h)		;3223	3a c1 a9	: . .
	ld (0ad10h),a		;3226	32 10 ad	2 . .
	ld hl,0a986h		;3229	21 86 a9	! . .
	ld a,(hl)		;322c	7e		~
	sub 001h		;322d	d6 01		. .
	daa			;322f	27		'
	ld (hl),a		;3230	77		w
	call sub_4afbh		;3231	cd fb 4a	. . J
	call sub_4b30h		;3234	cd 30 4b	. 0 K
	jp l172ah		;3237	c3 2a 17	. * .
sub_323ah:
	ld a,(ix+009h)		;323a	dd 7e 09	. ~ .
	and a			;323d	a7		.
	ret z			;323e	c8		.
	dec a			;323f	3d		=
	ld (ix+009h),a		;3240	dd 77 09	. w .
	ld c,a			;3243	4f		O
	ld a,(ix+00ah)		;3244	dd 7e 0a	. ~ .
	ld hl,l3438h		;3247	21 38 34	! 8 4
	rst 10h			;324a	d7		.
	ex de,hl		;324b	eb		.
	ld a,c			;324c	79		y
	rst 8			;324d	cf		.
	ld (ix+008h),a		;324e	dd 77 08	. w .
	ret			;3251	c9		.
	ld bc,l02ffh+1		;3252	01 00 03	. . .
	ld hl,l0008h		;3255	21 08 00	! . .
	ld e,000h		;3258	1e 00		. .
l325ah:
	ld a,e			;325a	7b		{
	xor (hl)		;325b	ae		.
	inc hl			;325c	23		#
	dec bc			;325d	0b		.
	ld e,a			;325e	5f		_
	ld a,c			;325f	79		y
	or b			;3260	b0		.
	jr nz,l325ah		;3261	20 f7		  .
	ld a,052h		;3263	3e 52		> R
	add a,e			;3265	83		.
	jp nz,sub_0f11h		;3266	c2 11 0f	. . .
	jp sub_0f1ah		;3269	c3 1a 0f	. . .
l326ch:
	ld a,c			;326c	79		y
	and 00fh		;326d	e6 0f		. .
	cp 007h			;326f	fe 07		. .
	ret nz			;3271	c0		.
	ld ix,0ac64h		;3272	dd 21 64 ac	. ! d .
	ld a,(0a802h)		;3276	3a 02 a8	: . .
	add a,040h		;3279	c6 40		. @
	call sub_59d1h		;327b	cd d1 59	. . Y
	ex de,hl		;327e	eb		.
	add hl,hl		;327f	29		)
	add hl,hl		;3280	29		)
	add hl,hl		;3281	29		)
	ld a,h			;3282	7c		|
	add a,078h		;3283	c6 78		. x
	ld (ix+010h),a		;3285	dd 77 10	. w .
	ld a,h			;3288	7c		|
	neg			;3289	ed 44		. D
	add a,078h		;328b	c6 78		. x
	ld (ix+014h),a		;328d	dd 77 14	. w .
	add hl,hl		;3290	29		)
	ld a,h			;3291	7c		|
	add a,078h		;3292	c6 78		. x
	ld (ix+012h),a		;3294	dd 77 12	. w .
	ld a,h			;3297	7c		|
	neg			;3298	ed 44		. D
	add a,078h		;329a	c6 78		. x
	ld (ix+016h),a		;329c	dd 77 16	. w .
	ld h,b			;329f	60		`
	ld l,c			;32a0	69		i
	add hl,hl		;32a1	29		)
	add hl,hl		;32a2	29		)
	add hl,hl		;32a3	29		)
	ld a,h			;32a4	7c		|
	add a,084h		;32a5	c6 84		. .
	ld (ix+011h),a		;32a7	dd 77 11	. w .
	ld a,h			;32aa	7c		|
	neg			;32ab	ed 44		. D
	add a,084h		;32ad	c6 84		. .
	ld (ix+015h),a		;32af	dd 77 15	. w .
	add hl,hl		;32b2	29		)
	ld a,h			;32b3	7c		|
	add a,084h		;32b4	c6 84		. .
	ld (ix+013h),a		;32b6	dd 77 13	. w .
	ld a,h			;32b9	7c		|
	neg			;32ba	ed 44		. D
	add a,084h		;32bc	c6 84		. .
	ld (ix+017h),a		;32be	dd 77 17	. w .
	ld a,(0a802h)		;32c1	3a 02 a8	: . .
	call sub_59d1h		;32c4	cd d1 59	. . Y
	ex de,hl		;32c7	eb		.
	add hl,hl		;32c8	29		)
	add hl,hl		;32c9	29		)
	add hl,hl		;32ca	29		)
	ld a,h			;32cb	7c		|
	add a,078h		;32cc	c6 78		. x
	ld (ix+018h),a		;32ce	dd 77 18	. w .
	add hl,hl		;32d1	29		)
	ld a,h			;32d2	7c		|
	add a,078h		;32d3	c6 78		. x
	ld (ix+01ah),a		;32d5	dd 77 1a	. w .
	ld h,b			;32d8	60		`
	ld l,c			;32d9	69		i
	add hl,hl		;32da	29		)
	add hl,hl		;32db	29		)
	add hl,hl		;32dc	29		)
	ld a,h			;32dd	7c		|
	add a,084h		;32de	c6 84		. .
	ld (ix+019h),a		;32e0	dd 77 19	. w .
	add hl,hl		;32e3	29		)
	ld a,h			;32e4	7c		|
	add a,084h		;32e5	c6 84		. .
	ld (ix+01bh),a		;32e7	dd 77 1b	. w .
	ret			;32ea	c9		.
l32ebh:
	ld (DSW2_READ_WATCHDOG_WRITE),a	;32eb	32 00 c2	2 . .
	ld hl,0a9ebh		;32ee	21 eb a9	! . .
	ld (hl),00ch		;32f1	36 0c		6 .
l32f3h:
	ld bc,RESET_VECTOR	;32f3	01 00 00	. . .
l32f6h:
	djnz l32f6h		;32f6	10 fe		. .
	ld (DSW2_READ_WATCHDOG_WRITE),a	;32f8	32 00 c2	2 . .
	dec c			;32fb	0d		.
	jr nz,l32f6h		;32fc	20 f8		  .
	dec (hl)		;32fe	35		5
l32ffh:
	jr nz,l32f3h		;32ff	20 f2		  .
	xor a			;3301	af		.
	call sub_55f8h		;3302	cd f8 55	. . U
	ld a,(l4c87h)		;3305	3a 87 4c	: . L
	jp l00a8h		;3308	c3 a8 00	. . .
l330bh:
	ld hl,0a9ebh		;330b	21 eb a9	! . .
	dec (hl)		;330e	35		5
	ret nz			;330f	c0		.
l3310h:
	call 04cc3h		;3310	cd c3 4c	. . L
	jp nc,l3326h		;3313	d2 26 33	. & 3
	ld de,l0309h		;3316	11 09 03	. . .
	rst 38h			;3319	ff		.
	ld e,00bh		;331a	1e 0b		. .
	rst 38h			;331c	ff		.
	ld a,(00843h)		;331d	3a 43 08	: C .
	ld (0a9ach),a		;3320	32 ac a9	2 . .
	jp l12e7h		;3323	c3 e7 12	. . .
l3326h:
	call sub_583ah		;3326	cd 3a 58	. : X
	ld a,000h		;3329	3e 00		> .
	ld (0ad0ch),a		;332b	32 0c ad	2 . .
	ld a,0f1h		;332e	3e f1		> .
l3330h:
	ld (0ad0bh),a		;3330	32 0b ad	2 . .
	call sub_01e1h		;3333	cd e1 01	. . .
	ld b,000h		;3336	06 00		. .
	ld hl,l01f1h		;3338	21 f1 01	! . .
	xor a			;333b	af		.
l333ch:
	add a,(hl)		;333c	86		.
	inc hl			;333d	23		#
	djnz l333ch		;333e	10 fc		. .
	sub 019h		;3340	d6 19		. .
	call nz,sub_0f11h	;3342	c4 11 0f	. . .
	jp sub_0f1ah		;3345	c3 1a 0f	. . .
	ld de,013a7h		;3348	11 a7 13	. . .
	ld l,b			;334b	68		h
	dec sp			;334c	3b		;
	inc (hl)		;334d	34		4
	pop af			;334e	f1		.
	ld l,b			;334f	68		h
	rst 10h			;3350	d7		.
	pop af			;3351	f1		.
	call c,0680fh		;3352	dc 0f 68	. . h
	pop af			;3355	f1		.
	adc a,b			;3356	88		.
	ld d,a			;3357	57		W
	and l			;3358	a5		.
	cp a			;3359	bf		.
	inc (hl)		;335a	34		4
	rst 10h			;335b	d7		.
	cpdr			;335c	ed b9		. .
	ld a,(0a9abh)		;335e	3a ab a9	: . .
	ld hl,l178ch		;3361	21 8c 17	! . .
	ld b,01eh		;3364	06 1e		. .
l3366h:
	add a,(hl)		;3366	86		.
	inc hl			;3367	23		#
	djnz l3366h		;3368	10 fc		. .
	add a,02ch		;336a	c6 2c		. ,
	ld (0a9abh),a		;336c	32 ab a9	2 . .
	ld a,(0ad32h)		;336f	3a 32 ad	: 2 .
	and a			;3372	a7		.
	ld de,0ad1bh		;3373	11 1b ad	. . .
	ld a,(0ad14h)		;3376	3a 14 ad	: . .
	jr z,l3381h		;3379	28 06		( .
	ld de,0ad2bh		;337b	11 2b ad	. + .
	ld a,(0ad24h)		;337e	3a 24 ad	: $ .
l3381h:
	add a,a			;3381	87		.
	ld hl,l0f8dh		;3382	21 8d 0f	! . .
	rst 8			;3385	cf		.
	ld (de),a		;3386	12		.
	ld (0ad0bh),a		;3387	32 0b ad	2 . .
	inc hl			;338a	23		#
	inc de			;338b	13		.
	ld a,(hl)		;338c	7e		~
	ld (de),a		;338d	12		.
	ld hl,0ad0ch		;338e	21 0c ad	! . .
	cp (hl)			;3391	be		.
	ld (hl),a		;3392	77		w
	call z,sub_0f1ah	;3393	cc 1a 0f	. . .
	call sub_01e1h		;3396	cd e1 01	. . .
	jp sub_0f1ah		;3399	c3 1a 0f	. . .
sub_339ch:
	ld a,(0ad32h)		;339c	3a 32 ad	: 2 .
	and a			;339f	a7		.
l33a0h:
	ld de,0ad1bh		;33a0	11 1b ad	. . .
	ld a,(0ad14h)		;33a3	3a 14 ad	: . .
	jr z,l33aeh		;33a6	28 06		( .
	ld de,0ad2bh		;33a8	11 2b ad	. + .
	ld a,(0ad24h)		;33ab	3a 24 ad	: $ .
l33aeh:
	add a,a			;33ae	87		.
	ld hl,l0f8dh		;33af	21 8d 0f	! . .
	rst 18h			;33b2	df		.
	ldi			;33b3	ed a0		. .
	ldi			;33b5	ed a0		. .
	ret			;33b7	c9		.
sub_33b8h:
	ld c,000h		;33b8	0e 00		. .
	ld b,(iy+031h)		;33ba	fd 46 31	. F 1
	ld e,(hl)		;33bd	5e		^
	dec l			;33be	2d		-
	ld a,(hl)		;33bf	7e		~
	sub b			;33c0	90		.
	jr nc,l33c7h		;33c1	30 04		0 .
	neg			;33c3	ed 44		. D
	set 0,c			;33c5	cb c1		. .
l33c7h:
	ld d,a			;33c7	57		W
	ld b,(iy+000h)		;33c8	fd 46 00	. F .
	ld a,e			;33cb	7b		{
	sub b			;33cc	90		.
	jr nc,l33d3h		;33cd	30 04		0 .
	neg			;33cf	ed 44		. D
	set 1,c			;33d1	cb c9		. .
l33d3h:
	ld e,a			;33d3	5f		_
	ex af,af'		;33d4	08		.
	ld a,e			;33d5	7b		{
	ex af,af'		;33d6	08		.
	sub d			;33d7	92		.
	jr z,l340fh		;33d8	28 35		( 5
	jr nc,l33deh		;33da	30 02		0 .
	set 2,c			;33dc	cb d1		. .
l33deh:
	ld l,000h		;33de	2e 00		. .
	bit 2,c			;33e0	cb 51		. Q
	jr nz,l33e7h		;33e2	20 03		  .
	ld h,d			;33e4	62		b
	jr l33e9h		;33e5	18 02		. .
l33e7h:
	ld h,e			;33e7	63		c
	ld e,d			;33e8	5a		Z
l33e9h:
	ld b,008h		;33e9	06 08		. .
	xor a			;33eb	af		.
l33ech:
	adc hl,hl		;33ec	ed 6a		. j
	ld a,h			;33ee	7c		|
	jr c,l33f4h		;33ef	38 03		8 .
	cp e			;33f1	bb		.
	jr c,l33f7h		;33f2	38 03		8 .
l33f4h:
	sub e			;33f4	93		.
	ld h,a			;33f5	67		g
	xor a			;33f6	af		.
l33f7h:
	ccf			;33f7	3f		?
	djnz l33ech		;33f8	10 f2		. .
	ld b,l			;33fa	45		E
	ld a,c			;33fb	79		y
	ld hl,l3415h		;33fc	21 15 34	! . 4
	rst 18h			;33ff	df		.
	ld a,b			;3400	78		x
	rrca			;3401	0f		.
	rrca			;3402	0f		.
	and 01fh		;3403	e6 1f		. .
	bit 5,(hl)		;3405	cb 6e		. n
	jr z,l340dh		;3407	28 04		( .
	ld b,a			;3409	47		G
	ld a,01fh		;340a	3e 1f		> .
	sub b			;340c	90		.
l340dh:
	add a,(hl)		;340d	86		.
	ret			;340e	c9		.
l340fh:
	ld hl,l341dh		;340f	21 1d 34	! . 4
	ld a,c			;3412	79		y
	rst 8			;3413	cf		.
	ret			;3414	c9		.
l3415h:
	jr nz,l3457h		;3415	20 40		  @
	ret nz			;3417	c0		.
	and b			;3418	a0		.
	nop			;3419	00		.
	ld h,b			;341a	60		`
	ret po			;341b	e0		.
	add a,b			;341c	80		.
l341dh:
	jr nz,l347fh		;341d	20 60		  `
	ret po			;341f	e0		.
	and b			;3420	a0		.
	ld hl,l0c50h		;3421	21 50 0c	! P .
	call sub_018ch		;3424	cd 8c 01	. . .
	ex de,hl		;3427	eb		.
	ld e,(hl)		;3428	5e		^
	inc hl			;3429	23		#
	ld d,(hl)		;342a	56		V
	inc hl			;342b	23		#
	inc hl			;342c	23		#
	ld a,(0ad0ch)		;342d	3a 0c ad	: . .
	add a,005h		;3430	c6 05		. .
	and 00fh		;3432	e6 0f		. .
	ld c,a			;3434	4f		O
	jp l0bffh		;3435	c3 ff 0b	. . .
l3438h:
	ld l,a			;3438	6f		o
	inc (hl)		;3439	34		4
	adc a,a			;343a	8f		.
	inc (hl)		;343b	34		4
	xor a			;343c	af		.
	inc (hl)		;343d	34		4
	rst 8			;343e	cf		.
	inc (hl)		;343f	34		4
	rst 28h			;3440	ef		.
	inc (hl)		;3441	34		4
	rrca			;3442	0f		.
	dec (hl)		;3443	35		5
	cpl			;3444	2f		/
	dec (hl)		;3445	35		5
	ld c,a			;3446	4f		O
	dec (hl)		;3447	35		5
	ld l,a			;3448	6f		o
	dec (hl)		;3449	35		5
	adc a,a			;344a	8f		.
	dec (hl)		;344b	35		5
	xor a			;344c	af		.
	dec (hl)		;344d	35		5
	rst 8			;344e	cf		.
	dec (hl)		;344f	35		5
	rst 28h			;3450	ef		.
	dec (hl)		;3451	35		5
	rrca			;3452	0f		.
	ld (hl),02fh		;3453	36 2f		6 /
	ld (hl),04fh		;3455	36 4f		6 O
l3457h:
	ld (hl),06fh		;3457	36 6f		6 o
	ld (hl),08fh		;3459	36 8f		6 .
	ld (hl),011h		;345b	36 11		6 .
	and a			;345d	a7		.
	inc de			;345e	13		.
	ld l,b			;345f	68		h
	dec sp			;3460	3b		;
	inc (hl)		;3461	34		4
	pop af			;3462	f1		.
	adc a,b			;3463	88		.
	ld d,a			;3464	57		W
	and l			;3465	a5		.
	cp a			;3466	bf		.
	inc (hl)		;3467	34		4
	rst 10h			;3468	d7		.
	pop af			;3469	f1		.
	ld l,b			;346a	68		h
	dec sp			;346b	3b		;
	ld d,a			;346c	57		W
	cp a			;346d	bf		.
	cp c			;346e	b9		.
	ld de,00909h		;346f	11 09 09	. . .
	add hl,bc		;3472	09		.
	add hl,bc		;3473	09		.
	add hl,bc		;3474	09		.
	add hl,bc		;3475	09		.
	add hl,bc		;3476	09		.
	add hl,bc		;3477	09		.
	add hl,bc		;3478	09		.
	add hl,bc		;3479	09		.
	add hl,bc		;347a	09		.
	add hl,bc		;347b	09		.
	add hl,bc		;347c	09		.
	add hl,bc		;347d	09		.
	add hl,bc		;347e	09		.
l347fh:
	add hl,bc		;347f	09		.
	add hl,bc		;3480	09		.
	add hl,bc		;3481	09		.
	add hl,bc		;3482	09		.
	add hl,bc		;3483	09		.
	add hl,bc		;3484	09		.
	add hl,bc		;3485	09		.
	add hl,bc		;3486	09		.
	add hl,bc		;3487	09		.
	add hl,bc		;3488	09		.
	add hl,bc		;3489	09		.
	add hl,bc		;348a	09		.
	add hl,bc		;348b	09		.
	add hl,bc		;348c	09		.
	add hl,bc		;348d	09		.
	add hl,bc		;348e	09		.
	ld de,00808h		;348f	11 08 08	. . .
	ex af,af'		;3492	08		.
	ex af,af'		;3493	08		.
	ex af,af'		;3494	08		.
	ex af,af'		;3495	08		.
	ex af,af'		;3496	08		.
	ex af,af'		;3497	08		.
	ex af,af'		;3498	08		.
	ex af,af'		;3499	08		.
	ex af,af'		;349a	08		.
	ex af,af'		;349b	08		.
	ex af,af'		;349c	08		.
	ex af,af'		;349d	08		.
	ex af,af'		;349e	08		.
	add hl,bc		;349f	09		.
	ex af,af'		;34a0	08		.
	ex af,af'		;34a1	08		.
	ex af,af'		;34a2	08		.
	ex af,af'		;34a3	08		.
	ex af,af'		;34a4	08		.
	ex af,af'		;34a5	08		.
	ex af,af'		;34a6	08		.
	ex af,af'		;34a7	08		.
	ex af,af'		;34a8	08		.
	ex af,af'		;34a9	08		.
	ex af,af'		;34aa	08		.
	ex af,af'		;34ab	08		.
	ex af,af'		;34ac	08		.
	ex af,af'		;34ad	08		.
	ex af,af'		;34ae	08		.
	ld de,RESET_VECTOR	;34af	11 00 00	. . .
	nop			;34b2	00		.
	nop			;34b3	00		.
	nop			;34b4	00		.
	nop			;34b5	00		.
	nop			;34b6	00		.
	nop			;34b7	00		.
	nop			;34b8	00		.
	nop			;34b9	00		.
	nop			;34ba	00		.
	nop			;34bb	00		.
	nop			;34bc	00		.
	nop			;34bd	00		.
	nop			;34be	00		.
	nop			;34bf	00		.
	nop			;34c0	00		.
	nop			;34c1	00		.
	nop			;34c2	00		.
	nop			;34c3	00		.
	nop			;34c4	00		.
	nop			;34c5	00		.
	nop			;34c6	00		.
	nop			;34c7	00		.
	nop			;34c8	00		.
	nop			;34c9	00		.
	nop			;34ca	00		.
	nop			;34cb	00		.
	nop			;34cc	00		.
	nop			;34cd	00		.
	nop			;34ce	00		.
	ld de,00a0ah		;34cf	11 0a 0a	. . .
	ld a,(bc)		;34d2	0a		.
	ld a,(bc)		;34d3	0a		.
	ld a,(bc)		;34d4	0a		.
	ld a,(bc)		;34d5	0a		.
	ld a,(bc)		;34d6	0a		.
	ld a,(bc)		;34d7	0a		.
	ld a,(bc)		;34d8	0a		.
	ld a,(bc)		;34d9	0a		.
	ld a,(bc)		;34da	0a		.
	ld a,(bc)		;34db	0a		.
	ld a,(bc)		;34dc	0a		.
	ld a,(bc)		;34dd	0a		.
	ld a,(bc)		;34de	0a		.
	ld a,(bc)		;34df	0a		.
	ld a,(bc)		;34e0	0a		.
	ld a,(bc)		;34e1	0a		.
	ld a,(bc)		;34e2	0a		.
	ld a,(bc)		;34e3	0a		.
	ld a,(bc)		;34e4	0a		.
	ld a,(bc)		;34e5	0a		.
	ld a,(bc)		;34e6	0a		.
	ld a,(bc)		;34e7	0a		.
	ld a,(bc)		;34e8	0a		.
	ld a,(bc)		;34e9	0a		.
	ld a,(bc)		;34ea	0a		.
	ld a,(bc)		;34eb	0a		.
	ld a,(bc)		;34ec	0a		.
	ld a,(bc)		;34ed	0a		.
	ld a,(bc)		;34ee	0a		.
	ld de,00b0bh		;34ef	11 0b 0b	. . .
	dec bc			;34f2	0b		.
	dec bc			;34f3	0b		.
	dec bc			;34f4	0b		.
	dec bc			;34f5	0b		.
	dec bc			;34f6	0b		.
	dec bc			;34f7	0b		.
	dec bc			;34f8	0b		.
	dec bc			;34f9	0b		.
	dec bc			;34fa	0b		.
	dec bc			;34fb	0b		.
	dec bc			;34fc	0b		.
	dec bc			;34fd	0b		.
	dec bc			;34fe	0b		.
l34ffh:
	dec bc			;34ff	0b		.
	dec bc			;3500	0b		.
	dec bc			;3501	0b		.
	dec bc			;3502	0b		.
	dec bc			;3503	0b		.
	dec bc			;3504	0b		.
	dec bc			;3505	0b		.
	dec bc			;3506	0b		.
	dec bc			;3507	0b		.
	dec bc			;3508	0b		.
	dec bc			;3509	0b		.
	dec bc			;350a	0b		.
	dec bc			;350b	0b		.
	dec bc			;350c	0b		.
	dec bc			;350d	0b		.
	dec bc			;350e	0b		.
	ld de,01010h		;350f	11 10 10	. . .
	djnz l3524h		;3512	10 10		. .
	djnz l3526h		;3514	10 10		. .
	djnz l3528h		;3516	10 10		. .
	djnz l352ah		;3518	10 10		. .
	djnz l352ch		;351a	10 10		. .
	djnz l352eh		;351c	10 10		. .
	djnz l3530h		;351e	10 10		. .
	djnz l3532h		;3520	10 10		. .
	djnz l3534h		;3522	10 10		. .
l3524h:
	djnz l3536h		;3524	10 10		. .
l3526h:
	djnz l3538h		;3526	10 10		. .
l3528h:
	djnz l353ah		;3528	10 10		. .
l352ah:
	djnz l353ch		;352a	10 10		. .
l352ch:
	djnz l353eh		;352c	10 10		. .
l352eh:
	djnz $+19		;352e	10 11		. .
l3530h:
	djnz l3542h		;3530	10 10		. .
l3532h:
	djnz l3544h		;3532	10 10		. .
l3534h:
	djnz l3546h		;3534	10 10		. .
l3536h:
	djnz l3548h		;3536	10 10		. .
l3538h:
	djnz l354ah		;3538	10 10		. .
l353ah:
	djnz l354ch		;353a	10 10		. .
l353ch:
	djnz l354eh		;353c	10 10		. .
l353eh:
	djnz $+18		;353e	10 10		. .
	djnz l3552h		;3540	10 10		. .
l3542h:
	djnz l3554h		;3542	10 10		. .
l3544h:
	djnz l3556h		;3544	10 10		. .
l3546h:
	djnz l3558h		;3546	10 10		. .
l3548h:
	djnz l355ah		;3548	10 10		. .
l354ah:
	djnz l355ch		;354a	10 10		. .
l354ch:
	djnz l355eh		;354c	10 10		. .
l354eh:
	dec c			;354e	0d		.
	ld de,01010h		;354f	11 10 10	. . .
l3552h:
	djnz l3564h		;3552	10 10		. .
l3554h:
	djnz l3566h		;3554	10 10		. .
l3556h:
	djnz l3568h		;3556	10 10		. .
l3558h:
	djnz l356ah		;3558	10 10		. .
l355ah:
	djnz l356ch		;355a	10 10		. .
l355ch:
	djnz l356eh		;355c	10 10		. .
l355eh:
	djnz $+18		;355e	10 10		. .
	djnz l3572h		;3560	10 10		. .
	djnz l3574h		;3562	10 10		. .
l3564h:
	djnz l3576h		;3564	10 10		. .
l3566h:
	djnz l3578h		;3566	10 10		. .
l3568h:
	djnz l357ah		;3568	10 10		. .
l356ah:
	djnz l357ch		;356a	10 10		. .
l356ch:
	djnz l357ah		;356c	10 0c		. .
l356eh:
	dec c			;356e	0d		.
	ld de,01010h		;356f	11 10 10	. . .
l3572h:
	djnz l3584h		;3572	10 10		. .
l3574h:
	djnz l3586h		;3574	10 10		. .
l3576h:
	djnz l3588h		;3576	10 10		. .
l3578h:
	djnz l358ah		;3578	10 10		. .
l357ah:
	djnz l358ch		;357a	10 10		. .
l357ch:
	djnz l358eh		;357c	10 10		. .
	djnz $+18		;357e	10 10		. .
	djnz l3592h		;3580	10 10		. .
	djnz l3594h		;3582	10 10		. .
l3584h:
	djnz l3596h		;3584	10 10		. .
l3586h:
	djnz l3598h		;3586	10 10		. .
l3588h:
	djnz l359ah		;3588	10 10		. .
l358ah:
	djnz l359ch		;358a	10 10		. .
l358ch:
	inc c			;358c	0c		.
	dec c			;358d	0d		.
l358eh:
	dec c			;358e	0d		.
	ld de,00909h		;358f	11 09 09	. . .
l3592h:
	add hl,bc		;3592	09		.
	add hl,bc		;3593	09		.
l3594h:
	add hl,bc		;3594	09		.
	add hl,bc		;3595	09		.
l3596h:
	add hl,bc		;3596	09		.
	add hl,bc		;3597	09		.
l3598h:
	add hl,bc		;3598	09		.
	add hl,bc		;3599	09		.
l359ah:
	add hl,bc		;359a	09		.
	add hl,bc		;359b	09		.
l359ch:
	add hl,bc		;359c	09		.
	add hl,bc		;359d	09		.
	add hl,bc		;359e	09		.
	add hl,bc		;359f	09		.
	add hl,bc		;35a0	09		.
	add hl,bc		;35a1	09		.
	add hl,bc		;35a2	09		.
	add hl,bc		;35a3	09		.
	add hl,bc		;35a4	09		.
	add hl,bc		;35a5	09		.
	add hl,bc		;35a6	09		.
	add hl,bc		;35a7	09		.
	add hl,bc		;35a8	09		.
	add hl,bc		;35a9	09		.
	add hl,bc		;35aa	09		.
	add hl,bc		;35ab	09		.
	djnz l35beh		;35ac	10 10		. .
	djnz l35c1h		;35ae	10 11		. .
	ex af,af'		;35b0	08		.
	ex af,af'		;35b1	08		.
	ex af,af'		;35b2	08		.
	ex af,af'		;35b3	08		.
	ex af,af'		;35b4	08		.
	ex af,af'		;35b5	08		.
	ex af,af'		;35b6	08		.
	ex af,af'		;35b7	08		.
	ex af,af'		;35b8	08		.
	ex af,af'		;35b9	08		.
	ex af,af'		;35ba	08		.
	ex af,af'		;35bb	08		.
	ex af,af'		;35bc	08		.
	ex af,af'		;35bd	08		.
l35beh:
	ex af,af'		;35be	08		.
	ex af,af'		;35bf	08		.
	ex af,af'		;35c0	08		.
l35c1h:
	ex af,af'		;35c1	08		.
	ex af,af'		;35c2	08		.
	ex af,af'		;35c3	08		.
	ex af,af'		;35c4	08		.
	ex af,af'		;35c5	08		.
	ex af,af'		;35c6	08		.
	ex af,af'		;35c7	08		.
	ex af,af'		;35c8	08		.
	ex af,af'		;35c9	08		.
	ex af,af'		;35ca	08		.
	ex af,af'		;35cb	08		.
	djnz l35deh		;35cc	10 10		. .
	djnz l35e1h		;35ce	10 11		. .
	nop			;35d0	00		.
	nop			;35d1	00		.
	nop			;35d2	00		.
	nop			;35d3	00		.
	nop			;35d4	00		.
	nop			;35d5	00		.
	nop			;35d6	00		.
	nop			;35d7	00		.
	nop			;35d8	00		.
	nop			;35d9	00		.
	nop			;35da	00		.
	nop			;35db	00		.
	nop			;35dc	00		.
	nop			;35dd	00		.
l35deh:
	nop			;35de	00		.
	nop			;35df	00		.
	nop			;35e0	00		.
l35e1h:
	nop			;35e1	00		.
	nop			;35e2	00		.
	nop			;35e3	00		.
	nop			;35e4	00		.
	nop			;35e5	00		.
	nop			;35e6	00		.
	nop			;35e7	00		.
	nop			;35e8	00		.
	nop			;35e9	00		.
	nop			;35ea	00		.
	nop			;35eb	00		.
	djnz l35feh		;35ec	10 10		. .
	djnz l3601h		;35ee	10 11		. .
	ld a,(bc)		;35f0	0a		.
	ld a,(bc)		;35f1	0a		.
	ld a,(bc)		;35f2	0a		.
	ld a,(bc)		;35f3	0a		.
	ld a,(bc)		;35f4	0a		.
	ld a,(bc)		;35f5	0a		.
	ld a,(bc)		;35f6	0a		.
	ld a,(bc)		;35f7	0a		.
	ld a,(bc)		;35f8	0a		.
	ld a,(bc)		;35f9	0a		.
	ld a,(bc)		;35fa	0a		.
	ld a,(bc)		;35fb	0a		.
	ld a,(bc)		;35fc	0a		.
	ld a,(bc)		;35fd	0a		.
l35feh:
	ld a,(bc)		;35fe	0a		.
	ld a,(bc)		;35ff	0a		.
	ld a,(bc)		;3600	0a		.
l3601h:
	ld a,(bc)		;3601	0a		.
	ld a,(bc)		;3602	0a		.
	ld a,(bc)		;3603	0a		.
	ld a,(bc)		;3604	0a		.
	ld a,(bc)		;3605	0a		.
	ld a,(bc)		;3606	0a		.
	ld a,(bc)		;3607	0a		.
	ld a,(bc)		;3608	0a		.
	ld a,(bc)		;3609	0a		.
	ld a,(bc)		;360a	0a		.
	ld a,(bc)		;360b	0a		.
	djnz l361eh		;360c	10 10		. .
	djnz l3621h		;360e	10 11		. .
	dec bc			;3610	0b		.
	dec bc			;3611	0b		.
	dec bc			;3612	0b		.
	dec bc			;3613	0b		.
	dec bc			;3614	0b		.
	dec bc			;3615	0b		.
	dec bc			;3616	0b		.
	dec bc			;3617	0b		.
	dec bc			;3618	0b		.
	dec bc			;3619	0b		.
	dec bc			;361a	0b		.
	dec bc			;361b	0b		.
	dec bc			;361c	0b		.
	dec bc			;361d	0b		.
l361eh:
	dec bc			;361e	0b		.
	dec bc			;361f	0b		.
	dec bc			;3620	0b		.
l3621h:
	dec bc			;3621	0b		.
	dec bc			;3622	0b		.
	dec bc			;3623	0b		.
	dec bc			;3624	0b		.
	dec bc			;3625	0b		.
	dec bc			;3626	0b		.
	dec bc			;3627	0b		.
	dec bc			;3628	0b		.
	dec bc			;3629	0b		.
	dec bc			;362a	0b		.
	dec bc			;362b	0b		.
	djnz l363eh		;362c	10 10		. .
	djnz $+19		;362e	10 11		. .
	djnz l3642h		;3630	10 10		. .
	djnz l3644h		;3632	10 10		. .
	djnz l3646h		;3634	10 10		. .
	djnz l3648h		;3636	10 10		. .
	djnz l364ah		;3638	10 10		. .
	djnz l364ch		;363a	10 10		. .
	djnz l364eh		;363c	10 10		. .
l363eh:
	djnz l3650h		;363e	10 10		. .
	djnz l3652h		;3640	10 10		. .
l3642h:
	djnz l3654h		;3642	10 10		. .
l3644h:
	djnz l3656h		;3644	10 10		. .
l3646h:
	djnz l3658h		;3646	10 10		. .
l3648h:
	djnz l365ah		;3648	10 10		. .
l364ah:
	djnz l365ch		;364a	10 10		. .
l364ch:
	djnz l365eh		;364c	10 10		. .
l364eh:
	djnz $+19		;364e	10 11		. .
l3650h:
	djnz l3662h		;3650	10 10		. .
l3652h:
	djnz l3664h		;3652	10 10		. .
l3654h:
	djnz l3666h		;3654	10 10		. .
l3656h:
	djnz l3668h		;3656	10 10		. .
l3658h:
	djnz l366ah		;3658	10 10		. .
l365ah:
	djnz l366ch		;365a	10 10		. .
l365ch:
	djnz l366eh		;365c	10 10		. .
l365eh:
	djnz l3670h		;365e	10 10		. .
	djnz l3672h		;3660	10 10		. .
l3662h:
	djnz l3674h		;3662	10 10		. .
l3664h:
	djnz l3676h		;3664	10 10		. .
l3666h:
	djnz l3678h		;3666	10 10		. .
l3668h:
	djnz l367ah		;3668	10 10		. .
l366ah:
	djnz $+15		;366a	10 0d		. .
l366ch:
	djnz l367eh		;366c	10 10		. .
l366eh:
	djnz $+19		;366e	10 11		. .
l3670h:
	djnz l3682h		;3670	10 10		. .
l3672h:
	djnz l3684h		;3672	10 10		. .
l3674h:
	djnz l3686h		;3674	10 10		. .
l3676h:
	djnz l3688h		;3676	10 10		. .
l3678h:
	djnz l368ah		;3678	10 10		. .
l367ah:
	djnz l368ch		;367a	10 10		. .
	djnz l368eh		;367c	10 10		. .
l367eh:
	djnz l3690h		;367e	10 10		. .
	djnz l3692h		;3680	10 10		. .
l3682h:
	djnz l3694h		;3682	10 10		. .
l3684h:
	djnz l3696h		;3684	10 10		. .
l3686h:
	djnz l3698h		;3686	10 10		. .
l3688h:
	djnz l369ah		;3688	10 10		. .
l368ah:
	djnz l369ch		;368a	10 10		. .
l368ch:
	djnz l369eh		;368c	10 10		. .
l368eh:
	djnz $+19		;368e	10 11		. .
l3690h:
	djnz l36a2h		;3690	10 10		. .
l3692h:
	djnz l36a4h		;3692	10 10		. .
l3694h:
	djnz l36a6h		;3694	10 10		. .
l3696h:
	djnz l36a8h		;3696	10 10		. .
l3698h:
	djnz l36aah		;3698	10 10		. .
l369ah:
	djnz l36ach		;369a	10 10		. .
l369ch:
	djnz l36aeh		;369c	10 10		. .
l369eh:
	djnz l36b0h		;369e	10 10		. .
	djnz l36b2h		;36a0	10 10		. .
l36a2h:
	djnz l36b4h		;36a2	10 10		. .
l36a4h:
	djnz $+18		;36a4	10 10		. .
l36a6h:
	djnz $+18		;36a6	10 10		. .
l36a8h:
	djnz $+18		;36a8	10 10		. .
l36aah:
	djnz l36b9h		;36aa	10 0d		. .
l36ach:
	djnz $+18		;36ac	10 10		. .
l36aeh:
	djnz l36eah		;36ae	10 3a		. :
l36b0h:
	add a,0ach		;36b0	c6 ac		. .
l36b2h:
	and a			;36b2	a7		.
	ret nz			;36b3	c0		.
l36b4h:
	ld a,(0ad04h)		;36b4	3a 04 ad	: . .
	cp 004h			;36b7	fe 04		. .
l36b9h:
	jp z,l386eh		;36b9	ca 6e 38	. n 8
	ld hl,0ad05h		;36bc	21 05 ad	! . .
	ld a,(0ad06h)		;36bf	3a 06 ad	: . .
	and 00fh		;36c2	e6 0f		. .
	cp 007h			;36c4	fe 07		. .
	jp z,l3855h		;36c6	ca 55 38	. U 8
	jp c,l37bdh		;36c9	da bd 37	. . 7
	cp 009h			;36cc	fe 09		. .
	jp c,l379fh		;36ce	da 9f 37	. . 7
	ld a,(hl)		;36d1	7e		~
	and a			;36d2	a7		.
	ret nz			;36d3	c0		.
	call sub_4b4bh		;36d4	cd 4b 4b	. K K
	rrca			;36d7	0f		.
	ld a,(0ad04h)		;36d8	3a 04 ad	: . .
	adc a,a			;36db	8f		.
	ld hl,0acc2h		;36dc	21 c2 ac	! . .
	ld (hl),0ffh		;36df	36 ff		6 .
	inc hl			;36e1	23		#
	ld (hl),a		;36e2	77		w
	ld a,(0a802h)		;36e3	3a 02 a8	: . .
	add a,008h		;36e6	c6 08		. .
	rrca			;36e8	0f		.
	rrca			;36e9	0f		.
l36eah:
	rrca			;36ea	0f		.
	rrca			;36eb	0f		.
	and 00fh		;36ec	e6 0f		. .
	ld hl,l38d9h		;36ee	21 d9 38	! . 8
	rst 18h			;36f1	df		.
	ld c,(hl)		;36f2	4e		N
	ld a,(0acc3h)		;36f3	3a c3 ac	: . .
	add a,a			;36f6	87		.
	add a,a			;36f7	87		.
	add a,a			;36f8	87		.
	add a,a			;36f9	87		.
	ld hl,l397bh		;36fa	21 7b 39	! { 9
	rst 18h			;36fd	df		.
	ex de,hl		;36fe	eb		.
l36ffh:
	ld a,(0acc1h)		;36ff	3a c1 ac	: . .
	ld b,a			;3702	47		G
	ld a,(0ad02h)		;3703	3a 02 ad	: . .
	and a			;3706	a7		.
	jr nz,l370bh		;3707	20 02		  .
	ld b,005h		;3709	06 05		. .
l370bh:
	xor a			;370b	af		.
	ld (0a811h),a		;370c	32 11 a8	2 . .
	ld ix,0a850h		;370f	dd 21 50 a8	. ! P .
	ld iy,0aa1ah		;3713	fd 21 1a aa	. ! . .
l3717h:
	ld a,(ix+000h)		;3717	dd 7e 00	. ~ .
	and a			;371a	a7		.
	jp nz,l3768h		;371b	c2 68 37	. h 7
	ld a,(de)		;371e	1a		.
	add a,c			;371f	81		.
	add a,a			;3720	87		.
	ld hl,038e9h		;3721	21 e9 38	! . 8
	rst 8			;3724	cf		.
	ld (iy+031h),a		;3725	fd 77 31	. w 1
	inc hl			;3728	23		#
	ld a,(hl)		;3729	7e		~
	ld (iy+000h),a		;372a	fd 77 00	. w .
	ld a,(0a802h)		;372d	3a 02 a8	: . .
	add a,080h		;3730	c6 80		. .
	ld (ix+001h),a		;3732	dd 77 01	. w .
	ld (ix+002h),a		;3735	dd 77 02	. w .
	call sub_382dh		;3738	cd 2d 38	. - 8
	add a,009h		;373b	c6 09		. .
	ld (ix+00ah),a		;373d	dd 77 0a	. w .
	inc de			;3740	13		.
	ld a,(de)		;3741	1a		.
	ld (ix+00eh),a		;3742	dd 77 0e	. w .
	inc de			;3745	13		.
	ld (ix+003h),000h	;3746	dd 36 03 00	. 6 . .
	ld (ix+005h),000h	;374a	dd 36 05 00	. 6 . .
	ld (ix+009h),020h	;374e	dd 36 09 20	. 6 .  
	exx			;3752	d9		.
	call sub_323ah		;3753	cd 3a 32	. : 2
	exx			;3756	d9		.
	ld (ix+000h),0feh	;3757	dd 36 00 fe	. 6 . .
	ld a,(ix+00eh)		;375b	dd 7e 0e	. ~ .
	and a			;375e	a7		.
	jr nz,l3764h		;375f	20 03		  .
	inc (ix+000h)		;3761	dd 34 00	. 4 .
l3764h:
	ld hl,0a811h		;3764	21 11 a8	! . .
	inc (hl)		;3767	34		4
l3768h:
	ex de,hl		;3768	eb		.
	ld de,l0010h		;3769	11 10 00	. . .
	add ix,de		;376c	dd 19		. .
	inc iy			;376e	fd 23		. #
	inc iy			;3770	fd 23		. #
	ex de,hl		;3772	eb		.
	djnz l3717h		;3773	10 a2		. .
	xor a			;3775	af		.
	ld (0acc2h),a		;3776	32 c2 ac	2 . .
	ld a,0e4h		;3779	3e e4		> .
	ld (0a812h),a		;377b	32 12 a8	2 . .
	ld hl,0a811h		;377e	21 11 a8	! . .
	ld a,(hl)		;3781	7e		~
	cp 005h			;3782	fe 05		. .
	jp nc,l5817h		;3784	d2 17 58	. . X
	ld hl,0acc1h		;3787	21 c1 ac	! . .
	cp (hl)			;378a	be		.
	ld a,(hl)		;378b	7e		~
	ld (0a811h),a		;378c	32 11 a8	2 . .
	jp nc,l5817h		;378f	d2 17 58	. . X
	ret			;3792	c9		.
l3793h:
	ld b,005h		;3793	06 05		. .
	ld ix,0a890h		;3795	dd 21 90 a8	. ! . .
	ld iy,0aa22h		;3799	fd 21 22 aa	. ! " .
	jr l37d6h		;379d	18 37		. 7
l379fh:
	ld a,(hl)		;379f	7e		~
	and a			;37a0	a7		.
	jr z,l37a6h		;37a1	28 03		( .
	cp 030h			;37a3	fe 30		. 0
	ret nz			;37a5	c0		.
l37a6h:
	ld hl,0a850h		;37a6	21 50 a8	! P .
	ld de,l0010h		;37a9	11 10 00	. . .
	ld bc,l0700h		;37ac	01 00 07	. . .
l37afh:
	ld a,(hl)		;37af	7e		~
	and a			;37b0	a7		.
	jr z,l37b4h		;37b1	28 01		( .
	inc c			;37b3	0c		.
l37b4h:
	add hl,de		;37b4	19		.
	djnz l37afh		;37b5	10 f8		. .
	ld a,c			;37b7	79		y
	cp 002h			;37b8	fe 02		. .
	ret nc			;37ba	d0		.
	jr l37c4h		;37bb	18 07		. .
l37bdh:
	ld a,(hl)		;37bd	7e		~
	and a			;37be	a7		.
	jr z,l37c4h		;37bf	28 03		( .
	cp 030h			;37c1	fe 30		. 0
	ret nz			;37c3	c0		.
l37c4h:
	ld a,(0ad02h)		;37c4	3a 02 ad	: . .
	and a			;37c7	a7		.
	jr z,l3793h		;37c8	28 c9		( .
	ld a,(0acc1h)		;37ca	3a c1 ac	: . .
	ld b,a			;37cd	47		G
	ld ix,0a8b0h		;37ce	dd 21 b0 a8	. ! . .
	ld iy,0aa26h		;37d2	fd 21 26 aa	. ! & .
l37d6h:
	ld a,(ix+000h)		;37d6	dd 7e 00	. ~ .
	and a			;37d9	a7		.
	jp nz,l3847h		;37da	c2 47 38	. G 8
	dec (ix+000h)		;37dd	dd 35 00	. 5 .
	ld a,(0a802h)		;37e0	3a 02 a8	: . .
	rrca			;37e3	0f		.
	rrca			;37e4	0f		.
	and 03fh		;37e5	e6 3f		. ?
	ld c,a			;37e7	4f		O
	call sub_4b4bh		;37e8	cd 4b 4b	. K K
	and 00fh		;37eb	e6 0f		. .
	sub 008h		;37ed	d6 08		. .
	add a,c			;37ef	81		.
	and 03fh		;37f0	e6 3f		. ?
	ld hl,l39fbh		;37f2	21 fb 39	! . 9
	rst 8			;37f5	cf		.
	add a,a			;37f6	87		.
	add a,a			;37f7	87		.
	ld hl,l3a3bh		;37f8	21 3b 3a	! ; :
l37fbh:
	rst 8			;37fb	cf		.
	ld (iy+031h),a		;37fc	fd 77 31	. w 1
l37ffh:
	inc hl			;37ff	23		#
l3800h:
	ld a,(hl)		;3800	7e		~
	ld (iy+000h),a		;3801	fd 77 00	. w .
	ld a,(0a802h)		;3804	3a 02 a8	: . .
	add a,080h		;3807	c6 80		. .
	ld (ix+001h),a		;3809	dd 77 01	. w .
	ld (ix+002h),a		;380c	dd 77 02	. w .
	call sub_382dh		;380f	cd 2d 38	. - 8
	ld (ix+00ah),a		;3812	dd 77 0a	. w .
	xor a			;3815	af		.
	ld (0acc5h),a		;3816	32 c5 ac	2 . .
	ld (ix+003h),000h	;3819	dd 36 03 00	. 6 . .
	ld (ix+005h),000h	;381d	dd 36 05 00	. 6 . .
	ld (ix+009h),020h	;3821	dd 36 09 20	. 6 .  
	call sub_323ah		;3825	cd 3a 32	. : 2
	ld (ix+00eh),000h	;3828	dd 36 0e 00	. 6 . .
	ret			;382c	c9		.
sub_382dh:
	call sub_4b4bh		;382d	cd 4b 4b	. K K
	ld hl,0acc4h		;3830	21 c4 ac	! . .
	cp (hl)			;3833	be		.
	jr nc,l3842h		;3834	30 0c		0 .
	ld hl,0a9cfh		;3836	21 cf a9	! . .
	ld a,(hl)		;3839	7e		~
	inc a			;383a	3c		<
	cp 005h			;383b	fe 05		. .
	jr c,l3840h		;383d	38 01		8 .
	xor a			;383f	af		.
l3840h:
	ld (hl),a		;3840	77		w
	ret			;3841	c9		.
l3842h:
	and 003h		;3842	e6 03		. .
	add a,005h		;3844	c6 05		. .
	ret			;3846	c9		.
l3847h:
	ld de,0fff0h		;3847	11 f0 ff	. . .
	add ix,de		;384a	dd 19		. .
	dec iy			;384c	fd 2b		. +
	dec iy			;384e	fd 2b		. +
	dec b			;3850	05		.
	jp nz,l37d6h		;3851	c2 d6 37	. . 7
	ret			;3854	c9		.
l3855h:
	ld a,(hl)		;3855	7e		~
	and a			;3856	a7		.
	ret nz			;3857	c0		.
	ld ix,0a850h		;3858	dd 21 50 a8	. ! P .
	ld de,l0010h		;385c	11 10 00	. . .
	ld b,005h		;385f	06 05		. .
l3861h:
	ld (ix+008h),011h	;3861	dd 36 08 11	. 6 . .
	ld (ix+009h),000h	;3865	dd 36 09 00	. 6 . .
	add ix,de		;3869	dd 19		. .
	djnz l3861h		;386b	10 f4		. .
	ret			;386d	c9		.
l386eh:
	ld ix,0a850h		;386e	dd 21 50 a8	. ! P .
	ld iy,0aa1ah		;3872	fd 21 1a aa	. ! . .
	ld a,(0acc1h)		;3876	3a c1 ac	: . .
	ld b,a			;3879	47		G
	ld a,(0ad0dh)		;387a	3a 0d ad	: . .
	and a			;387d	a7		.
	jr z,l3882h		;387e	28 02		( .
	ld b,005h		;3880	06 05		. .
l3882h:
	push bc			;3882	c5		.
	ld a,(ix+000h)		;3883	dd 7e 00	. ~ .
	and a			;3886	a7		.
	jp nz,l38c0h		;3887	c2 c0 38	. . 8
	call sub_4b4bh		;388a	cd 4b 4b	. K K
	and 0fch		;388d	e6 fc		. .
	ld hl,l3a3bh		;388f	21 3b 3a	! ; :
	rst 8			;3892	cf		.
	ld (iy+031h),a		;3893	fd 77 31	. w 1
	inc hl			;3896	23		#
	ld a,(hl)		;3897	7e		~
	ld (iy+000h),a		;3898	fd 77 00	. w .
	inc hl			;389b	23		#
	ld a,(hl)		;389c	7e		~
	ld (ix+001h),a		;389d	dd 77 01	. w .
	ld (ix+002h),a		;38a0	dd 77 02	. w .
	ld a,(0acc1h)		;38a3	3a c1 ac	: . .
	sub b			;38a6	90		.
	ld hl,l38d2h		;38a7	21 d2 38	! . 8
	rst 8			;38aa	cf		.
	ld (ix+00ah),a		;38ab	dd 77 0a	. w .
	ld (ix+009h),020h	;38ae	dd 36 09 20	. 6 .  
	call sub_323ah		;38b2	cd 3a 32	. : 2
	ld (ix+004h),001h	;38b5	dd 36 04 01	. 6 . .
	ld (ix+00eh),000h	;38b9	dd 36 0e 00	. 6 . .
	dec (ix+000h)		;38bd	dd 35 00	. 5 .
l38c0h:
	ld de,l0010h		;38c0	11 10 00	. . .
	add ix,de		;38c3	dd 19		. .
	inc iy			;38c5	fd 23		. #
	inc iy			;38c7	fd 23		. #
	pop bc			;38c9	c1		.
	djnz l3882h		;38ca	10 b6		. .
	ld a,0e4h		;38cc	3e e4		> .
	ld (0a812h),a		;38ce	32 12 a8	2 . .
	ret			;38d1	c9		.
l38d2h:
	ld a,(bc)		;38d2	0a		.
	dec bc			;38d3	0b		.
	dec c			;38d4	0d		.
	ld c,00fh		;38d5	0e 0f		. .
	add hl,bc		;38d7	09		.
	inc c			;38d8	0c		.
l38d9h:
	ex af,af'		;38d9	08		.
	inc c			;38da	0c		.
	rrca			;38db	0f		.
l38dch:
	inc de			;38dc	13		.
	ld d,01ah		;38dd	16 1a		. .
	dec e			;38df	1d		.
l38e0h:
	ld hl,l2824h		;38e0	21 24 28	! $ (
	dec hl			;38e3	2b		+
	cpl			;38e4	2f		/
	inc sp			;38e5	33		3
	scf			;38e6	37		7
	ld a,(0f03dh)		;38e7	3a 3d f0	: = .
	djnz l38dch		;38ea	10 f0		. .
	jr nz,$-14		;38ec	20 f0		  .
	jr nc,l38e0h		;38ee	30 f0		0 .
	ld b,b			;38f0	40		@
	ret p			;38f1	f0		.
	ld d,b			;38f2	50		P
	ret p			;38f3	f0		.
l38f4h:
	ld h,b			;38f4	60		`
	ret p			;38f5	f0		.
	ld (hl),b		;38f6	70		p
	ret p			;38f7	f0		.
	add a,b			;38f8	80		.
	ret p			;38f9	f0		.
	sub b			;38fa	90		.
	ret p			;38fb	f0		.
	and b			;38fc	a0		.
	ret p			;38fd	f0		.
	or b			;38fe	b0		.
l38ffh:
	ret p			;38ff	f0		.
l3900h:
	ret nz			;3900	c0		.
	ret p			;3901	f0		.
	ret nc			;3902	d0		.
	ret p			;3903	f0		.
	ret po			;3904	e0		.
	ret p			;3905	f0		.
l3906h:
	ret p			;3906	f0		.
	ret po			;3907	e0		.
	ret m			;3908	f8		.
	ret nc			;3909	d0		.
	ret m			;390a	f8		.
	ret nz			;390b	c0		.
	ret m			;390c	f8		.
	or b			;390d	b0		.
	ret m			;390e	f8		.
	and b			;390f	a0		.
	ret m			;3910	f8		.
	sub b			;3911	90		.
	ret m			;3912	f8		.
	add a,b			;3913	80		.
	ret m			;3914	f8		.
	ld (hl),b		;3915	70		p
	ret m			;3916	f8		.
l3917h:
	ld h,b			;3917	60		`
l3918h:
	ret m			;3918	f8		.
l3919h:
	ld d,b			;3919	50		P
	ret m			;391a	f8		.
l391bh:
	ld b,b			;391b	40		@
	ret m			;391c	f8		.
	jr nc,l3917h		;391d	30 f8		0 .
	jr nz,l3919h		;391f	20 f8		  .
	djnz l391bh		;3921	10 f8		. .
	nop			;3923	00		.
	ret p			;3924	f0		.
	nop			;3925	00		.
	ret po			;3926	e0		.
	nop			;3927	00		.
	ret nc			;3928	d0		.
	nop			;3929	00		.
l392ah:
	ret nz			;392a	c0		.
	nop			;392b	00		.
	or b			;392c	b0		.
	nop			;392d	00		.
	and b			;392e	a0		.
	nop			;392f	00		.
	sub b			;3930	90		.
	nop			;3931	00		.
	add a,b			;3932	80		.
	nop			;3933	00		.
	ld (hl),b		;3934	70		p
	nop			;3935	00		.
	ld h,b			;3936	60		`
	nop			;3937	00		.
	ld d,b			;3938	50		P
	nop			;3939	00		.
	ld b,b			;393a	40		@
	nop			;393b	00		.
l393ch:
	jr nc,l393eh		;393c	30 00		0 .
l393eh:
	jr nz,l3940h		;393e	20 00		  .
l3940h:
	djnz l3952h		;3940	10 10		. .
	djnz l3964h		;3942	10 20		.  
	djnz l3976h		;3944	10 30		. 0
	djnz $+66		;3946	10 40		. @
	djnz l399ah		;3948	10 50		. P
	djnz l39ach		;394a	10 60		. `
	djnz $+114		;394c	10 70		. p
l394eh:
	djnz $-126		;394e	10 80		. .
l3950h:
	djnz $-110		;3950	10 90		. .
l3952h:
	djnz l38f4h		;3952	10 a0		. .
l3954h:
	djnz l3906h		;3954	10 b0		. .
	djnz l3918h		;3956	10 c0		. .
	djnz l392ah		;3958	10 d0		. .
	djnz l393ch		;395a	10 e0		. .
	djnz l394eh		;395c	10 f0		. .
	djnz l3950h		;395e	10 f0		. .
	jr nz,l3952h		;3960	20 f0		  .
	jr nc,l3954h		;3962	30 f0		0 .
l3964h:
	ld b,b			;3964	40		@
	ret p			;3965	f0		.
	ld d,b			;3966	50		P
	ret p			;3967	f0		.
	ld h,b			;3968	60		`
	ret p			;3969	f0		.
	ld (hl),b		;396a	70		p
	ret p			;396b	f0		.
	add a,b			;396c	80		.
	ret p			;396d	f0		.
	sub b			;396e	90		.
	ret p			;396f	f0		.
	and b			;3970	a0		.
	ret p			;3971	f0		.
	or b			;3972	b0		.
	ret p			;3973	f0		.
	ret nz			;3974	c0		.
	ret p			;3975	f0		.
l3976h:
	ret nc			;3976	d0		.
	ret p			;3977	f0		.
	ret po			;3978	e0		.
	ret p			;3979	f0		.
	ret p			;397a	f0		.
l397bh:
	nop			;397b	00		.
	ld bc,01101h		;397c	01 01 11	. . .
	rst 38h			;397f	ff		.
	ld de,l2102h		;3980	11 02 21	. . !
	cp 021h			;3983	fe 21		. !
	inc bc			;3985	03		.
	ld sp,l31fdh		;3986	31 fd 31	1 . 1
	nop			;3989	00		.
	nop			;398a	00		.
	nop			;398b	00		.
	ld de,l0101h		;398c	11 01 01	. . .
	rst 38h			;398f	ff		.
	ld bc,01102h		;3990	01 02 11	. . .
	cp 011h			;3993	fe 11		. .
	inc bc			;3995	03		.
	ld hl,l21fdh		;3996	21 fd 21	! . !
	nop			;3999	00		.
l399ah:
	nop			;399a	00		.
	nop			;399b	00		.
	ld bc,01102h		;399c	01 02 11	. . .
	cp 011h			;399f	fe 11		. .
	inc bc			;39a1	03		.
	ld hl,l21fdh		;39a2	21 fd 21	! . !
	inc b			;39a5	04		.
	ld sp,031fch		;39a6	31 fc 31	1 . 1
	nop			;39a9	00		.
	nop			;39aa	00		.
	nop			;39ab	00		.
l39ach:
	ld sp,l0103h		;39ac	31 03 01	1 . .
	defb 0fdh,001h,004h ;illegal sequence	;39af	fd 01 04	. . .
	ld de,011fch		;39b2	11 fc 11	. . .
	inc bc			;39b5	03		.
	ld de,l11fdh		;39b6	11 fd 11	. . .
	nop			;39b9	00		.
	nop			;39ba	00		.
	nop			;39bb	00		.
	ld bc,l0103h		;39bc	01 03 01	. . .
	defb 0fdh,001h,004h ;illegal sequence	;39bf	fd 01 04	. . .
l39c2h:
	ld de,011fch		;39c2	11 fc 11	. . .
	dec b			;39c5	05		.
l39c6h:
	ld hl,l21fbh		;39c6	21 fb 21	! . !
	nop			;39c9	00		.
	nop			;39ca	00		.
	nop			;39cb	00		.
	ld bc,l1103h		;39cc	01 03 11	. . .
	defb 0fdh,011h,000h ;illegal sequence	;39cf	fd 11 00	. . .
	ld hl,l2103h		;39d2	21 03 21	! . !
	ld iy,03100h		;39d5	fd 21 00 31	. ! . 1
	nop			;39d9	00		.
	nop			;39da	00		.
	inc bc			;39db	03		.
	ld bc,l01fdh		;39dc	01 fd 01	. . .
	inc bc			;39df	03		.
	ld de,l11fdh		;39e0	11 fd 11	. . .
	dec b			;39e3	05		.
	ld de,011fbh		;39e4	11 fb 11	. . .
	nop			;39e7	00		.
	add hl,hl		;39e8	29		)
	nop			;39e9	00		.
	nop			;39ea	00		.
	nop			;39eb	00		.
	ld bc,l1103h		;39ec	01 03 11	. . .
	defb 0fdh,011h,005h ;illegal sequence	;39ef	fd 11 05	. . .
	ld hl,l21fbh		;39f2	21 fb 21	! . !
	inc bc			;39f5	03		.
	ld sp,l31fdh		;39f6	31 fd 31	1 . 1
	nop			;39f9	00		.
	nop			;39fa	00		.
l39fbh:
	ex af,af'		;39fb	08		.
	add hl,bc		;39fc	09		.
	ld a,(bc)		;39fd	0a		.
	dec bc			;39fe	0b		.
	inc c			;39ff	0c		.
	dec c			;3a00	0d		.
	dec c			;3a01	0d		.
	ld c,00fh		;3a02	0e 0f		. .
	djnz $+19		;3a04	10 11		. .
	ld (de),a		;3a06	12		.
	inc de			;3a07	13		.
	inc d			;3a08	14		.
	inc d			;3a09	14		.
	dec d			;3a0a	15		.
	ld d,017h		;3a0b	16 17		. .
	jr l3a28h		;3a0d	18 19		. .
	ld a,(de)		;3a0f	1a		.
	dec de			;3a10	1b		.
	dec de			;3a11	1b		.
	inc e			;3a12	1c		.
	dec e			;3a13	1d		.
	ld e,01fh		;3a14	1e 1f		. .
	jr nz,l3a39h		;3a16	20 21		  !
	ld (l2322h),hl		;3a18	22 22 23	" " #
	inc h			;3a1b	24		$
	dec h			;3a1c	25		%
	ld h,027h		;3a1d	26 27		& '
	jr z,l3a4ah		;3a1f	28 29		( )
	add hl,hl		;3a21	29		)
	ld hl,(l2c2bh)		;3a22	2a 2b 2c	* + ,
	dec l			;3a25	2d		-
	ld l,02fh		;3a26	2e 2f		. /
l3a28h:
	jr nc,l3a5bh		;3a28	30 31		0 1
	ld (03433h),a		;3a2a	32 33 34	2 3 4
	dec (hl)		;3a2d	35		5
	ld (hl),037h		;3a2e	36 37		6 7
	jr c,l3a6ah		;3a30	38 38		8 8
	add hl,sp		;3a32	39		9
	nop			;3a33	00		.
	ld bc,00302h		;3a34	01 02 03	. . .
	inc b			;3a37	04		.
	dec b			;3a38	05		.
l3a39h:
	ld b,007h		;3a39	06 07		. .
l3a3bh:
	ret p			;3a3b	f0		.
	djnz l3a9eh		;3a3c	10 60		. `
	nop			;3a3e	00		.
	ret p			;3a3f	f0		.
	jr nz,l39c2h		;3a40	20 80		  .
	nop			;3a42	00		.
	ret p			;3a43	f0		.
	jr nc,l39c6h		;3a44	30 80		0 .
	nop			;3a46	00		.
	ret p			;3a47	f0		.
	ld b,b			;3a48	40		@
	add a,b			;3a49	80		.
l3a4ah:
	nop			;3a4a	00		.
	ret p			;3a4b	f0		.
	ld d,b			;3a4c	50		P
	add a,b			;3a4d	80		.
	nop			;3a4e	00		.
	ret p			;3a4f	f0		.
	ld h,b			;3a50	60		`
	add a,b			;3a51	80		.
	nop			;3a52	00		.
	ret p			;3a53	f0		.
	ld (hl),b		;3a54	70		p
	add a,b			;3a55	80		.
	nop			;3a56	00		.
	ret p			;3a57	f0		.
	add a,b			;3a58	80		.
	add a,b			;3a59	80		.
	nop			;3a5a	00		.
l3a5bh:
	ret p			;3a5b	f0		.
	sub b			;3a5c	90		.
	add a,b			;3a5d	80		.
	nop			;3a5e	00		.
	ret p			;3a5f	f0		.
	and b			;3a60	a0		.
	add a,b			;3a61	80		.
	nop			;3a62	00		.
	ret p			;3a63	f0		.
	or b			;3a64	b0		.
	add a,b			;3a65	80		.
	nop			;3a66	00		.
	ret p			;3a67	f0		.
	ret nz			;3a68	c0		.
	add a,b			;3a69	80		.
l3a6ah:
	nop			;3a6a	00		.
	ret p			;3a6b	f0		.
	ret nc			;3a6c	d0		.
	add a,b			;3a6d	80		.
	nop			;3a6e	00		.
	ret p			;3a6f	f0		.
	ret po			;3a70	e0		.
	add a,b			;3a71	80		.
	nop			;3a72	00		.
	ret p			;3a73	f0		.
	ret p			;3a74	f0		.
	and b			;3a75	a0		.
	nop			;3a76	00		.
	ret po			;3a77	e0		.
	ret m			;3a78	f8		.
	ret nz			;3a79	c0		.
	nop			;3a7a	00		.
	ret nc			;3a7b	d0		.
	ret m			;3a7c	f8		.
	ret nz			;3a7d	c0		.
	nop			;3a7e	00		.
	ret nz			;3a7f	c0		.
	ret m			;3a80	f8		.
	ret nz			;3a81	c0		.
	nop			;3a82	00		.
	or b			;3a83	b0		.
	ret m			;3a84	f8		.
	ret nz			;3a85	c0		.
	nop			;3a86	00		.
	and b			;3a87	a0		.
	ret m			;3a88	f8		.
	ret nz			;3a89	c0		.
	nop			;3a8a	00		.
	sub b			;3a8b	90		.
	ret m			;3a8c	f8		.
	ret nz			;3a8d	c0		.
	nop			;3a8e	00		.
	add a,b			;3a8f	80		.
	ret m			;3a90	f8		.
	ret nz			;3a91	c0		.
	nop			;3a92	00		.
	ld (hl),b		;3a93	70		p
	ret m			;3a94	f8		.
	ret nz			;3a95	c0		.
	nop			;3a96	00		.
	ld h,b			;3a97	60		`
	ret m			;3a98	f8		.
	ret nz			;3a99	c0		.
	nop			;3a9a	00		.
	ld d,b			;3a9b	50		P
	ret m			;3a9c	f8		.
l3a9dh:
	ret nz			;3a9d	c0		.
l3a9eh:
	nop			;3a9e	00		.
	ld b,b			;3a9f	40		@
	ret m			;3aa0	f8		.
l3aa1h:
	ret nz			;3aa1	c0		.
	nop			;3aa2	00		.
	jr nc,l3a9dh		;3aa3	30 f8		0 .
l3aa5h:
	ret nz			;3aa5	c0		.
	nop			;3aa6	00		.
	jr nz,l3aa1h		;3aa7	20 f8		  .
	ret nz			;3aa9	c0		.
l3aaah:
	nop			;3aaa	00		.
	djnz l3aa5h		;3aab	10 f8		. .
	ret nz			;3aad	c0		.
l3aaeh:
	nop			;3aae	00		.
	nop			;3aaf	00		.
	ret p			;3ab0	f0		.
	ret po			;3ab1	e0		.
	nop			;3ab2	00		.
	nop			;3ab3	00		.
	ret po			;3ab4	e0		.
	nop			;3ab5	00		.
	nop			;3ab6	00		.
	nop			;3ab7	00		.
	ret nc			;3ab8	d0		.
	nop			;3ab9	00		.
	nop			;3aba	00		.
	nop			;3abb	00		.
	ret nz			;3abc	c0		.
	nop			;3abd	00		.
	nop			;3abe	00		.
	nop			;3abf	00		.
	or b			;3ac0	b0		.
	nop			;3ac1	00		.
	nop			;3ac2	00		.
	nop			;3ac3	00		.
	and b			;3ac4	a0		.
	nop			;3ac5	00		.
	nop			;3ac6	00		.
	nop			;3ac7	00		.
	sub b			;3ac8	90		.
	nop			;3ac9	00		.
	nop			;3aca	00		.
	nop			;3acb	00		.
	add a,b			;3acc	80		.
	nop			;3acd	00		.
	nop			;3ace	00		.
	nop			;3acf	00		.
	ld (hl),b		;3ad0	70		p
	nop			;3ad1	00		.
	nop			;3ad2	00		.
	nop			;3ad3	00		.
	ld h,b			;3ad4	60		`
	nop			;3ad5	00		.
	nop			;3ad6	00		.
	nop			;3ad7	00		.
	ld d,b			;3ad8	50		P
	nop			;3ad9	00		.
	nop			;3ada	00		.
	nop			;3adb	00		.
	ld b,b			;3adc	40		@
	nop			;3add	00		.
	nop			;3ade	00		.
	nop			;3adf	00		.
	jr nc,l3ae2h		;3ae0	30 00		0 .
l3ae2h:
	nop			;3ae2	00		.
	nop			;3ae3	00		.
	jr nz,l3ae6h		;3ae4	20 00		  .
l3ae6h:
	nop			;3ae6	00		.
	nop			;3ae7	00		.
	djnz l3b0ah		;3ae8	10 20		.  
	nop			;3aea	00		.
	djnz $+18		;3aeb	10 10		. .
	ld b,b			;3aed	40		@
	nop			;3aee	00		.
	jr nz,$+18		;3aef	20 10		  .
	ld b,b			;3af1	40		@
	nop			;3af2	00		.
	jr nc,$+18		;3af3	30 10		0 .
	ld b,b			;3af5	40		@
	nop			;3af6	00		.
	ld b,b			;3af7	40		@
	djnz l3b3ah		;3af8	10 40		. @
	nop			;3afa	00		.
	ld d,b			;3afb	50		P
	djnz l3b3eh		;3afc	10 40		. @
	nop			;3afe	00		.
	ld h,b			;3aff	60		`
	djnz l3b42h		;3b00	10 40		. @
	nop			;3b02	00		.
	ld (hl),b		;3b03	70		p
	djnz l3b46h		;3b04	10 40		. @
	nop			;3b06	00		.
	add a,b			;3b07	80		.
	djnz l3b4ah		;3b08	10 40		. @
l3b0ah:
	nop			;3b0a	00		.
	sub b			;3b0b	90		.
	djnz l3b4eh		;3b0c	10 40		. @
	nop			;3b0e	00		.
	and b			;3b0f	a0		.
	djnz l3b52h		;3b10	10 40		. @
	nop			;3b12	00		.
	or b			;3b13	b0		.
	djnz l3b56h		;3b14	10 40		. @
	nop			;3b16	00		.
	ret nz			;3b17	c0		.
	djnz l3b5ah		;3b18	10 40		. @
	nop			;3b1a	00		.
	ret nc			;3b1b	d0		.
	djnz l3b5eh		;3b1c	10 40		. @
	nop			;3b1e	00		.
	ret po			;3b1f	e0		.
	djnz l3b62h		;3b20	10 40		. @
	nop			;3b22	00		.
	ret p			;3b23	f0		.
	djnz $+98		;3b24	10 60		. `
	nop			;3b26	00		.
	ret p			;3b27	f0		.
	jr nz,l3aaah		;3b28	20 80		  .
	nop			;3b2a	00		.
	ret p			;3b2b	f0		.
	jr nc,l3aaeh		;3b2c	30 80		0 .
	nop			;3b2e	00		.
	ret p			;3b2f	f0		.
	ld b,b			;3b30	40		@
	add a,b			;3b31	80		.
	nop			;3b32	00		.
	ret p			;3b33	f0		.
	ld d,b			;3b34	50		P
	add a,b			;3b35	80		.
	nop			;3b36	00		.
	ret p			;3b37	f0		.
	ld h,b			;3b38	60		`
	add a,b			;3b39	80		.
l3b3ah:
	nop			;3b3a	00		.
	ret p			;3b3b	f0		.
	ld (hl),b		;3b3c	70		p
	add a,b			;3b3d	80		.
l3b3eh:
	nop			;3b3e	00		.
	ret p			;3b3f	f0		.
	add a,b			;3b40	80		.
	add a,b			;3b41	80		.
l3b42h:
	nop			;3b42	00		.
	ret p			;3b43	f0		.
	sub b			;3b44	90		.
	add a,b			;3b45	80		.
l3b46h:
	nop			;3b46	00		.
	ret p			;3b47	f0		.
	and b			;3b48	a0		.
	add a,b			;3b49	80		.
l3b4ah:
	nop			;3b4a	00		.
	ret p			;3b4b	f0		.
	or b			;3b4c	b0		.
	add a,b			;3b4d	80		.
l3b4eh:
	nop			;3b4e	00		.
	ret p			;3b4f	f0		.
	ret nz			;3b50	c0		.
	add a,b			;3b51	80		.
l3b52h:
	nop			;3b52	00		.
	ret p			;3b53	f0		.
	ret nc			;3b54	d0		.
	add a,b			;3b55	80		.
l3b56h:
	nop			;3b56	00		.
	ret p			;3b57	f0		.
	ret po			;3b58	e0		.
	add a,b			;3b59	80		.
l3b5ah:
	nop			;3b5a	00		.
	ret p			;3b5b	f0		.
	ret p			;3b5c	f0		.
	and b			;3b5d	a0		.
l3b5eh:
	nop			;3b5e	00		.
sub_3b5fh:
	ld a,(0ad04h)		;3b5f	3a 04 ad	: . .
l3b62h:
	dec a			;3b62	3d		=
	ret nz			;3b63	c0		.
	ld ix,0a8c0h		;3b64	dd 21 c0 a8	. ! . .
	ld iy,0aa28h		;3b68	fd 21 28 aa	. ! ( .
	ld a,(ix+000h)		;3b6c	dd 7e 00	. ~ .
	and a			;3b6f	a7		.
	jp z,l3c25h		;3b70	ca 25 3c	. % <
	inc a			;3b73	3c		<
	jp nz,l3b94h		;3b74	c2 94 3b	. . ;
l3b77h:
	call sub_3e05h		;3b77	cd 05 3e	. . >
	ld a,(iy+031h)		;3b7a	fd 7e 31	. ~ 1
	add a,010h		;3b7d	c6 10		. .
	ld (iy+033h),a		;3b7f	fd 77 33	. w 3
	ld a,(iy+000h)		;3b82	fd 7e 00	. ~ .
	ld (iy+002h),a		;3b85	fd 77 02	. w .
	call sub_3cc4h		;3b88	cd c4 3c	. . <
	jp c,sub_3c0dh		;3b8b	da 0d 3c	. . <
	call sub_3ce9h		;3b8e	cd e9 3c	. . <
	jp l3d25h		;3b91	c3 25 3d	. % =
l3b94h:
	dec a			;3b94	3d		=
l3b95h:
	ld c,a			;3b95	4f		O
	ld hl,0a8dch		;3b96	21 dc a8	! . .
	ld a,(hl)		;3b99	7e		~
	and a			;3b9a	a7		.
sub_3b9bh:
	jp z,l3ba9h		;3b9b	ca a9 3b	. . ;
	dec (hl)		;3b9e	35		5
	ld (ix+000h),0ffh	;3b9f	dd 36 00 ff	. 6 . .
	call sub_5683h		;3ba3	cd 83 56	. . V
	jp l3b77h		;3ba6	c3 77 3b	. w ;
l3ba9h:
	ld a,c			;3ba9	79		y
	cp 061h			;3baa	fe 61		. a
	jr c,l3bbdh		;3bac	38 0f		8 .
	ld (ix+000h),061h	;3bae	dd 36 00 61	. 6 . a
	call sub_5683h		;3bb2	cd 83 56	. . V
	ld (iy+030h),03dh	;3bb5	fd 36 30 3d	. 6 0 =
	ld (iy+032h),03dh	;3bb9	fd 36 32 3d	. 6 2 =
l3bbdh:
	dec (ix+000h)		;3bbd	dd 35 00	. 5 .
	jr z,sub_3c0dh		;3bc0	28 4b		( K
	call l2b60h		;3bc2	cd 60 2b	. ` +
	ld a,(iy+031h)		;3bc5	fd 7e 31	. ~ 1
	add a,010h		;3bc8	c6 10		. .
	ld (iy+033h),a		;3bca	fd 77 33	. w 3
	ld a,(iy+000h)		;3bcd	fd 7e 00	. ~ .
	ld (iy+002h),a		;3bd0	fd 77 02	. w .
	ld a,(ix+000h)		;3bd3	dd 7e 00	. ~ .
	sub 040h		;3bd6	d6 40		. @
	jp z,l3bf1h		;3bd8	ca f1 3b	. . ;
	ret c			;3bdb	d8		.
	ld c,a			;3bdc	4f		O
	and 007h		;3bdd	e6 07		. .
	ret nz			;3bdf	c0		.
	ld a,c			;3be0	79		y
	rrca			;3be1	0f		.
	rrca			;3be2	0f		.
	rrca			;3be3	0f		.
	dec a			;3be4	3d		=
	ld hl,l3c09h		;3be5	21 09 3c	! . <
	rst 8			;3be8	cf		.
	ld (iy+003h),a		;3be9	fd 77 03	. w .
	inc a			;3bec	3c		<
	ld (iy+001h),a		;3bed	fd 77 01	. w .
	ret			;3bf0	c9		.
l3bf1h:
	ld de,l040bh		;3bf1	11 0b 04	. . .
	rst 38h			;3bf4	ff		.
	ld (iy+003h),0fah	;3bf5	fd 36 03 fa	. 6 . .
	ld (iy+001h),0fbh	;3bf9	fd 36 01 fb	. 6 . .
	ld (iy+030h),06ch	;3bfd	fd 36 30 6c	. 6 0 l
l3c01h:
	ld (iy+032h),06ch	;3c01	fd 36 32 6c	. 6 2 l
	dec (ix+000h)		;3c05	dd 35 00	. 5 .
	ret			;3c08	c9		.
l3c09h:
	sub (hl)		;3c09	96		.
	sub h			;3c0a	94		.
	sub d			;3c0b	92		.
	sub b			;3c0c	90		.
sub_3c0dh:
	xor a			;3c0d	af		.
	ld (ix+000h),a		;3c0e	dd 77 00	. w .
	ld (ix+010h),a		;3c11	dd 77 10	. w .
	ld (iy+000h),a		;3c14	fd 77 00	. w .
	ld (iy+031h),a		;3c17	fd 77 31	. w 1
	ld (0aa5bh),a		;3c1a	32 5b aa	2 [ .
	ld (0aa2ah),a		;3c1d	32 2a aa	2 * .
	ld (ix+00eh),080h	;3c20	dd 36 0e 80	. 6 . .
	ret			;3c24	c9		.
l3c25h:
	ld a,(0a980h)		;3c25	3a 80 a9	: . .
	and 001h		;3c28	e6 01		. .
	ret nz			;3c2a	c0		.
	dec (ix+00eh)		;3c2b	dd 35 0e	. 5 .
	jp z,l3c32h		;3c2e	ca 32 3c	. 2 <
	ret			;3c31	c9		.
l3c32h:
	ld a,(0ad0dh)		;3c32	3a 0d ad	: . .
	and a			;3c35	a7		.
	ret nz			;3c36	c0		.
	ld a,(0a802h)		;3c37	3a 02 a8	: . .
	ld b,a			;3c3a	47		G
	add a,008h		;3c3b	c6 08		. .
l3c3dh:
	and 07fh		;3c3d	e6 7f		. .
	cp 010h			;3c3f	fe 10		. .
	jr c,l3c75h		;3c41	38 32		8 2
	ld a,b			;3c43	78		x
l3c44h:
	rrca			;3c44	0f		.
	rrca			;3c45	0f		.
	and 03eh		;3c46	e6 3e		. >
	ld hl,l3c84h		;3c48	21 84 3c	! . <
	rst 8			;3c4b	cf		.
	ld (iy+031h),a		;3c4c	fd 77 31	. w 1
	inc hl			;3c4f	23		#
	ld a,(hl)		;3c50	7e		~
	ld (iy+000h),a		;3c51	fd 77 00	. w .
	ld a,b			;3c54	78		x
	add a,0c0h		;3c55	c6 c0		. .
	and 080h		;3c57	e6 80		. .
	ld (ix+002h),a		;3c59	dd 77 02	. w .
	call sub_5942h		;3c5c	cd 42 59	. B Y
	ld (ix+00ah),e		;3c5f	dd 73 0a	. s .
	ld (ix+00bh),d		;3c62	dd 72 0b	. r .
	ld (ix+00ch),c		;3c65	dd 71 0c	. q .
	ld (ix+00dh),b		;3c68	dd 70 0d	. p .
	ld a,003h		;3c6b	3e 03		> .
	ld (0a8dch),a		;3c6d	32 dc a8	2 . .
	ld (ix+000h),0ffh	;3c70	dd 36 00 ff	. 6 . .
	ret			;3c74	c9		.
l3c75h:
	ld a,(0a980h)		;3c75	3a 80 a9	: . .
	ld c,a			;3c78	4f		O
	ld a,010h		;3c79	3e 10		> .
	bit 3,c			;3c7b	cb 59		. Y
	jr nz,l3c81h		;3c7d	20 02		  .
	neg			;3c7f	ed 44		. D
l3c81h:
	add a,b			;3c81	80		.
	jr l3c44h		;3c82	18 c0		. .
l3c84h:
	call pe,0ec80h		;3c84	ec 80 ec	. . .
	adc a,b			;3c87	88		.
	call pe,0ec90h		;3c88	ec 90 ec	. . .
	and b			;3c8b	a0		.
	call pe,0ecb0h		;3c8c	ec b0 ec	. . .
	ret nz			;3c8f	c0		.
	call pe,0ecd0h		;3c90	ec d0 ec	. . .
	ret po			;3c93	e0		.
	ret p			;3c94	f0		.
	call pe,0ecf0h		;3c95	ec f0 ec	. . .
	ret p			;3c98	f0		.
	ret po			;3c99	e0		.
	ret p			;3c9a	f0		.
	ret nc			;3c9b	d0		.
	ret p			;3c9c	f0		.
	ret nz			;3c9d	c0		.
	ret p			;3c9e	f0		.
	or b			;3c9f	b0		.
	ret p			;3ca0	f0		.
	and b			;3ca1	a0		.
	ret p			;3ca2	f0		.
l3ca3h:
	sub b			;3ca3	90		.
	ret p			;3ca4	f0		.
l3ca5h:
	add a,b			;3ca5	80		.
	ret p			;3ca6	f0		.
l3ca7h:
	ld a,b			;3ca7	78		x
	ret p			;3ca8	f0		.
	ld (hl),b		;3ca9	70		p
	ret p			;3caa	f0		.
	ld h,b			;3cab	60		`
	ret p			;3cac	f0		.
	ld d,b			;3cad	50		P
	ret p			;3cae	f0		.
	ld b,b			;3caf	40		@
	ret p			;3cb0	f0		.
	jr nc,l3ca3h		;3cb1	30 f0		0 .
	jr z,l3ca5h		;3cb3	28 f0		( .
	jr nz,l3ca3h		;3cb5	20 ec		  .
	jr nz,l3ca5h		;3cb7	20 ec		  .
	jr nc,l3ca7h		;3cb9	30 ec		0 .
	ld b,b			;3cbb	40		@
	call pe,0ec50h		;3cbc	ec 50 ec	. P .
	ld h,b			;3cbf	60		`
	call pe,0ec70h		;3cc0	ec 70 ec	. p .
	ld a,b			;3cc3	78		x
sub_3cc4h:
	ld a,(ix+002h)		;3cc4	dd 7e 02	. ~ .
	add a,040h		;3cc7	c6 40		. @
	bit 7,a			;3cc9	cb 7f		. .
	jp nz,l3cd9h		;3ccb	c2 d9 3c	. . <
	ld a,(iy+031h)		;3cce	fd 7e 31	. ~ 1
	add a,013h		;3cd1	c6 13		. .
	cp 003h			;3cd3	fe 03		. .
	ret c			;3cd5	d8		.
	jp l3ce1h		;3cd6	c3 e1 3c	. . <
l3cd9h:
	ld a,(iy+031h)		;3cd9	fd 7e 31	. ~ 1
	add a,010h		;3cdc	c6 10		. .
	cp 003h			;3cde	fe 03		. .
	ret c			;3ce0	d8		.
l3ce1h:
	ld a,(iy+000h)		;3ce1	fd 7e 00	. ~ .
	add a,002h		;3ce4	c6 02		. .
	cp 004h			;3ce6	fe 04		. .
	ret			;3ce8	c9		.
sub_3ce9h:
	ld a,(0a980h)		;3ce9	3a 80 a9	: . .
	and 002h		;3cec	e6 02		. .
	ld b,a			;3cee	47		G
	ld a,(0a8dch)		;3cef	3a dc a8	: . .
	ld c,a			;3cf2	4f		O
	ld a,003h		;3cf3	3e 03		> .
	sub c			;3cf5	91		.
	add a,a			;3cf6	87		.
	add a,a			;3cf7	87		.
	add a,0a0h		;3cf8	c6 a0		. .
	add a,b			;3cfa	80		.
	ld c,a			;3cfb	4f		O
	ld a,(ix+002h)		;3cfc	dd 7e 02	. ~ .
l3cffh:
	add a,040h		;3cff	c6 40		. @
	cp 080h			;3d01	fe 80		. .
	jr c,l3d15h		;3d03	38 10		8 .
	ld (iy+001h),c		;3d05	fd 71 01	. q .
	inc c			;3d08	0c		.
	ld (iy+003h),c		;3d09	fd 71 03	. q .
	ld (iy+030h),0edh	;3d0c	fd 36 30 ed	. 6 0 .
	ld (iy+032h),0edh	;3d10	fd 36 32 ed	. 6 2 .
	ret			;3d14	c9		.
l3d15h:
	ld (iy+003h),c		;3d15	fd 71 03	. q .
	inc c			;3d18	0c		.
	ld (iy+001h),c		;3d19	fd 71 01	. q .
	ld (iy+030h),06dh	;3d1c	fd 36 30 6d	. 6 0 m
	ld (iy+032h),06dh	;3d20	fd 36 32 6d	. 6 2 m
	ret			;3d24	c9		.
l3d25h:
	ld a,(ix+000h)		;3d25	dd 7e 00	. ~ .
	inc a			;3d28	3c		<
	ret nz			;3d29	c0		.
	ld a,(0a8f4h)		;3d2a	3a f4 a8	: . .
	and a			;3d2d	a7		.
	ret nz			;3d2e	c0		.
	ld a,(0a8c6h)		;3d2f	3a c6 a8	: . .
	and a			;3d32	a7		.
	ret z			;3d33	c8		.
	cp 001h			;3d34	fe 01		. .
	jp z,l3d40h		;3d36	ca 40 3d	. @ =
	ld a,(0a8e0h)		;3d39	3a e0 a8	: . .
	and a			;3d3c	a7		.
	jp z,l3d45h		;3d3d	ca 45 3d	. E =
l3d40h:
	ld a,(0a840h)		;3d40	3a 40 a8	: @ .
	and a			;3d43	a7		.
	ret nz			;3d44	c0		.
l3d45h:
	ld b,002h		;3d45	06 02		. .
	ld a,(0a8d6h)		;3d47	3a d6 a8	: . .
	ld d,a			;3d4a	57		W
	add a,a			;3d4b	87		.
	ld e,a			;3d4c	5f		_
l3d4dh:
	ld a,084h		;3d4d	3e 84		> .
	sub (iy+000h)		;3d4f	fd 96 00	. . .
	add a,d			;3d52	82		.
	cp e			;3d53	bb		.
	jp nc,l3d6fh		;3d54	d2 6f 3d	. o =
	ld a,078h		;3d57	3e 78		> x
	sub (iy+031h)		;3d59	fd 96 31	. . 1
	add a,d			;3d5c	82		.
	cp e			;3d5d	bb		.
	jp nc,l3d6fh		;3d5e	d2 6f 3d	. o =
	exx			;3d61	d9		.
	ld de,l0010h		;3d62	11 10 00	. . .
	add ix,de		;3d65	dd 19		. .
	inc iy			;3d67	fd 23		. #
	inc iy			;3d69	fd 23		. #
	exx			;3d6b	d9		.
	djnz l3d4dh		;3d6c	10 df		. .
	ret			;3d6e	c9		.
l3d6fh:
	call sub_565fh		;3d6f	cd 5f 56	. _ V
	ld hl,0ac7fh		;3d72	21 7f ac	! . .
	call sub_33b8h		;3d75	cd b8 33	. . 3
	ld h,a			;3d78	67		g
	ld a,018h		;3d79	3e 18		> .
	ex de,hl		;3d7b	eb		.
	ld hl,0a8d4h		;3d7c	21 d4 a8	! . .
	inc (hl)		;3d7f	34		4
	ld b,(hl)		;3d80	46		F
	bit 0,b			;3d81	cb 40		. @
	jr nz,l3d87h		;3d83	20 02		  .
	neg			;3d85	ed 44		. D
l3d87h:
	ex de,hl		;3d87	eb		.
	add a,h			;3d88	84		.
	ex af,af'		;3d89	08		.
	ld b,(iy+031h)		;3d8a	fd 46 31	. F 1
	ld c,(iy+000h)		;3d8d	fd 4e 00	. N .
	ld a,(0a8c6h)		;3d90	3a c6 a8	: . .
	cp 001h			;3d93	fe 01		. .
	jp z,l3d9fh		;3d95	ca 9f 3d	. . =
	ld a,(0a8e0h)		;3d98	3a e0 a8	: . .
	and a			;3d9b	a7		.
	jp z,l3dcfh		;3d9c	ca cf 3d	. . =
l3d9fh:
	ld ix,0a840h		;3d9f	dd 21 40 a8	. ! @ .
	ld iy,0aa18h		;3da3	fd 21 18 aa	. ! . .
l3da7h:
	ld (iy+031h),b		;3da7	fd 70 31	. p 1
	ld (iy+000h),c		;3daa	fd 71 00	. q .
	ex af,af'		;3dad	08		.
	call sub_59c5h		;3dae	cd c5 59	. . Y
	ld (ix+00ah),e		;3db1	dd 73 0a	. s .
	ld (ix+00bh),d		;3db4	dd 72 0b	. r .
	ld (ix+00ch),c		;3db7	dd 71 0c	. q .
	ld (ix+00dh),b		;3dba	dd 70 0d	. p .
	ld (iy+001h),04dh	;3dbd	fd 36 01 4d	. 6 . M
	ld (iy+030h),062h	;3dc1	fd 36 30 62	. 6 0 b
	dec (ix+000h)		;3dc5	dd 35 00	. 5 .
	ld a,(0a8f6h)		;3dc8	3a f6 a8	: . .
	ld (0a8f4h),a		;3dcb	32 f4 a8	2 . .
	ret			;3dce	c9		.
l3dcfh:
	ld ix,0a8e0h		;3dcf	dd 21 e0 a8	. ! . .
	ld iy,0aa2ch		;3dd3	fd 21 2c aa	. ! , .
	jp l3da7h		;3dd7	c3 a7 3d	. . =
sub_3ddah:
	ld a,(0ad04h)		;3dda	3a 04 ad	: . .
	dec a			;3ddd	3d		=
	ret nz			;3dde	c0		.
	ld ix,0a8e0h		;3ddf	dd 21 e0 a8	. ! . .
	ld iy,0aa2ch		;3de3	fd 21 2c aa	. ! , .
	call sub_3debh		;3de7	cd eb 3d	. . =
	ret			;3dea	c9		.
sub_3debh:
	ld a,(ix+000h)		;3deb	dd 7e 00	. ~ .
	and a			;3dee	a7		.
	ret z			;3def	c8		.
	inc a			;3df0	3c		<
	jp nz,sub_3dfbh		;3df1	c2 fb 3d	. . =
	call sub_3e05h		;3df4	cd 05 3e	. . >
	call sub_2b83h		;3df7	cd 83 2b	. . +
	ret nc			;3dfa	d0		.
sub_3dfbh:
	call sub_40abh		;3dfb	cd ab 40	. . @
	ld a,(0a8f6h)		;3dfe	3a f6 a8	: . .
	ld (ix+00eh),a		;3e01	dd 77 0e	. w .
	ret			;3e04	c9		.
sub_3e05h:
	ld h,(ix+00bh)		;3e05	dd 66 0b	. f .
	ld l,(ix+00ah)		;3e08	dd 6e 0a	. n .
	ld de,(0a808h)		;3e0b	ed 5b 08 a8	. [ . .
	add hl,de		;3e0f	19		.
	ld d,(iy+031h)		;3e10	fd 56 31	. V 1
	ld e,(ix+003h)		;3e13	dd 5e 03	. ^ .
	add hl,de		;3e16	19		.
	ld (iy+031h),h		;3e17	fd 74 31	. t 1
	ld (ix+003h),l		;3e1a	dd 75 03	. u .
	ld h,(ix+00dh)		;3e1d	dd 66 0d	. f .
	ld l,(ix+00ch)		;3e20	dd 6e 0c	. n .
	ld de,(0a80ah)		;3e23	ed 5b 0a a8	. [ . .
	add hl,de		;3e27	19		.
	ld d,(iy+000h)		;3e28	fd 56 00	. V .
	ld e,(ix+005h)		;3e2b	dd 5e 05	. ^ .
	add hl,de		;3e2e	19		.
	ld (iy+000h),h		;3e2f	fd 74 00	. t .
	ld (ix+005h),l		;3e32	dd 75 05	. u .
	ret			;3e35	c9		.
sub_3e36h:
	ld ix,0a810h		;3e36	dd 21 10 a8	. ! . .
	ld iy,0aa12h		;3e3a	fd 21 12 aa	. ! . .
	call sub_3e63h		;3e3e	cd 63 3e	. c >
	ld ix,0a820h		;3e41	dd 21 20 a8	. !   .
	ld iy,0aa14h		;3e45	fd 21 14 aa	. ! . .
	call sub_3e63h		;3e49	cd 63 3e	. c >
	ld ix,0a830h		;3e4c	dd 21 30 a8	. ! 0 .
	ld iy,0aa16h		;3e50	fd 21 16 aa	. ! . .
	call sub_3e63h		;3e54	cd 63 3e	. c >
	ld ix,0a840h		;3e57	dd 21 40 a8	. ! @ .
	ld iy,0aa18h		;3e5b	fd 21 18 aa	. ! . .
	call sub_3e63h		;3e5f	cd 63 3e	. c >
	ret			;3e62	c9		.
sub_3e63h:
	ld a,(ix+000h)		;3e63	dd 7e 00	. ~ .
	and a			;3e66	a7		.
	ret z			;3e67	c8		.
	inc a			;3e68	3c		<
	jp nz,l3e8eh		;3e69	c2 8e 3e	. . >
sub_3e6ch:
	ld a,(0ad04h)		;3e6c	3a 04 ad	: . .
	cp 004h			;3e6f	fe 04		. .
	call z,sub_3e7eh	;3e71	cc 7e 3e	. ~ >
	call sub_3e05h		;3e74	cd 05 3e	. . >
	call sub_2b83h		;3e77	cd 83 2b	. . +
	ret nc			;3e7a	d0		.
	jp sub_40abh		;3e7b	c3 ab 40	. . @
sub_3e7eh:
	ld a,(0a980h)		;3e7e	3a 80 a9	: . .
	rrca			;3e81	0f		.
	and 007h		;3e82	e6 07		. .
	add a,040h		;3e84	c6 40		. @
	ld (iy+001h),a		;3e86	fd 77 01	. w .
	ld (iy+030h),044h	;3e89	fd 36 30 44	. 6 0 D
	ret			;3e8d	c9		.
l3e8eh:
	ld a,(0ad04h)		;3e8e	3a 04 ad	: . .
	cp 004h			;3e91	fe 04		. .
	jr z,l3e98h		;3e93	28 03		( .
	jp sub_40abh		;3e95	c3 ab 40	. . @
l3e98h:
	ld a,(ix+000h)		;3e98	dd 7e 00	. ~ .
	cp 001h			;3e9b	fe 01		. .
	jp z,sub_40abh		;3e9d	ca ab 40	. . @
	dec (ix+000h)		;3ea0	dd 35 00	. 5 .
	cp 03ch			;3ea3	fe 3c		. <
	call nc,03ecbh		;3ea5	d4 cb 3e	. . >
	call l2b60h		;3ea8	cd 60 2b	. ` +
	ld a,(ix+000h)		;3eab	dd 7e 00	. ~ .
	cp 01ch			;3eae	fe 1c		. .
	ret c			;3eb0	d8		.
	sub 01ch		;3eb1	d6 1c		. .
	rrca			;3eb3	0f		.
	rrca			;3eb4	0f		.
	and 007h		;3eb5	e6 07		. .
	ld hl,l3ec3h		;3eb7	21 c3 3e	! . >
	rst 8			;3eba	cf		.
	ld (iy+001h),a		;3ebb	fd 77 01	. w .
	ld (iy+030h),003h	;3ebe	fd 36 30 03	. 6 0 .
	ret			;3ec2	c9		.
l3ec3h:
	rst 38h			;3ec3	ff		.
	and 0e7h		;3ec4	e6 e7		. .
	rst 20h			;3ec6	e7		.
	and 0e6h		;3ec7	e6 e6		. .
	push hl			;3ec9	e5		.
	call po,036ddh		;3eca	e4 dd 36	. . 6
	nop			;3ecd	00		.
	dec sp			;3ece	3b		;
	jp sub_5683h		;3ecf	c3 83 56	. . V
	sub d			;3ed2	92		.
	and (hl)		;3ed3	a6		.
	inc d			;3ed4	14		.
	cp c			;3ed5	b9		.
sub_3ed6h:
	ld a,(0a980h)		;3ed6	3a 80 a9	: . .
	and 007h		;3ed9	e6 07		. .
	add a,005h		;3edb	c6 05		. .
	cp (ix+00fh)		;3edd	dd be 0f	. . .
	ret nz			;3ee0	c0		.
	ld a,(0a817h)		;3ee1	3a 17 a8	: . .
	and a			;3ee4	a7		.
	ret nz			;3ee5	c0		.
	ld hl,0a810h		;3ee6	21 10 a8	! . .
	ld de,0aa12h		;3ee9	11 12 aa	. . .
	ld a,(0a844h)		;3eec	3a 44 a8	: D .
	and a			;3eef	a7		.
	ret z			;3ef0	c8		.
	ld b,a			;3ef1	47		G
l3ef2h:
	ld a,(hl)		;3ef2	7e		~
	and a			;3ef3	a7		.
	jr z,l3effh		;3ef4	28 09		( .
	ld a,l			;3ef6	7d		}
	add a,010h		;3ef7	c6 10		. .
	ld l,a			;3ef9	6f		o
	inc e			;3efa	1c		.
	inc e			;3efb	1c		.
	djnz l3ef2h		;3efc	10 f4		. .
	ret			;3efe	c9		.
l3effh:
	ld (0a991h),hl		;3eff	22 91 a9	" . .
	ld (0a993h),de		;3f02	ed 53 93 a9	. S . .
	ld a,(0a827h)		;3f06	3a 27 a8	: ' .
	ld b,a			;3f09	47		G
	add a,a			;3f0a	87		.
	ld c,a			;3f0b	4f		O
	ld a,078h		;3f0c	3e 78		> x
	sub (iy+031h)		;3f0e	fd 96 31	. . 1
	add a,b			;3f11	80		.
	cp c			;3f12	b9		.
	jr nc,l3f1dh		;3f13	30 08		0 .
	ld a,084h		;3f15	3e 84		> .
	sub (iy+000h)		;3f17	fd 96 00	. . .
	add a,b			;3f1a	80		.
	cp c			;3f1b	b9		.
	ret c			;3f1c	d8		.
l3f1dh:
	ld a,(0a837h)		;3f1d	3a 37 a8	: 7 .
	ld b,a			;3f20	47		G
	add a,a			;3f21	87		.
	ld c,a			;3f22	4f		O
	ld a,(0a802h)		;3f23	3a 02 a8	: . .
	sub (ix+002h)		;3f26	dd 96 02	. . .
	add a,b			;3f29	80		.
	cp c			;3f2a	b9		.
	ret nc			;3f2b	d0		.
	ld a,d			;3f2c	7a		z
	cp 002h			;3f2d	fe 02		. .
	jp z,l3f9eh		;3f2f	ca 9e 3f	. . ?
l3f32h:
	ld hl,0ac7fh		;3f32	21 7f ac	! . .
	call sub_33b8h		;3f35	cd b8 33	. . 3
	ld c,a			;3f38	4f		O
	sub (ix+002h)		;3f39	dd 96 02	. . .
	add a,010h		;3f3c	c6 10		. .
	cp 020h			;3f3e	fe 20		.  
	ret nc			;3f40	d0		.
	call sub_3f93h		;3f41	cd 93 3f	. . ?
	push ix			;3f44	dd e5		. .
	push iy			;3f46	fd e5		. .
	ld d,(iy+031h)		;3f48	fd 56 31	. V 1
	ld e,(iy+000h)		;3f4b	fd 5e 00	. ^ .
	ld ix,(0a991h)		;3f4e	dd 2a 91 a9	. * . .
	ld iy,(0a993h)		;3f52	fd 2a 93 a9	. * . .
	ld (iy+031h),d		;3f56	fd 72 31	. r 1
	ld (iy+000h),e		;3f59	fd 73 00	. s .
	ld a,(0ad04h)		;3f5c	3a 04 ad	: . .
	and a			;3f5f	a7		.
	ld a,c			;3f60	79		y
	jr nz,l3f68h		;3f61	20 05		  .
	call sub_59cbh		;3f63	cd cb 59	. . Y
	jr l3f6bh		;3f66	18 03		. .
l3f68h:
	call sub_59d1h		;3f68	cd d1 59	. . Y
l3f6bh:
	ld (ix+00ah),e		;3f6b	dd 73 0a	. s .
	ld (ix+00bh),d		;3f6e	dd 72 0b	. r .
	ld (ix+00ch),c		;3f71	dd 71 0c	. q .
	ld (ix+00dh),b		;3f74	dd 70 0d	. p .
	ld a,(iy+031h)		;3f77	fd 7e 31	. ~ 1
	ld a,(iy+000h)		;3f7a	fd 7e 00	. ~ .
	ld (iy+001h),04dh	;3f7d	fd 36 01 4d	. 6 . M
	ld (iy+030h),062h	;3f81	fd 36 30 62	. 6 0 b
	ld a,(0a814h)		;3f85	3a 14 a8	: . .
	ld (0a817h),a		;3f88	32 17 a8	2 . .
	dec (ix+000h)		;3f8b	dd 35 00	. 5 .
	pop iy			;3f8e	fd e1		. .
	pop ix			;3f90	dd e1		. .
	ret			;3f92	c9		.
sub_3f93h:
	ld a,(0ad04h)		;3f93	3a 04 ad	: . .
	cp 003h			;3f96	fe 03		. .
	jp c,sub_565fh		;3f98	da 5f 56	. _ V
	jp l5669h		;3f9b	c3 69 56	. i V
l3f9eh:
	ld a,(0a8e6h)		;3f9e	3a e6 a8	: . .
	ld b,a			;3fa1	47		G
	add a,a			;3fa2	87		.
	ld c,a			;3fa3	4f		O
	ld a,084h		;3fa4	3e 84		> .
	sub (iy+000h)		;3fa6	fd 96 00	. . .
	add a,b			;3fa9	80		.
	cp c			;3faa	b9		.
	ret nc			;3fab	d0		.
	jp l3f32h		;3fac	c3 32 3f	. 2 ?
sub_3fafh:
	ld a,(ix+002h)		;3faf	dd 7e 02	. ~ .
	add a,008h		;3fb2	c6 08		. .
	rrca			;3fb4	0f		.
	rrca			;3fb5	0f		.
	rrca			;3fb6	0f		.
	rrca			;3fb7	0f		.
	and 00fh		;3fb8	e6 0f		. .
	ld hl,l3fcah		;3fba	21 ca 3f	! . ?
	rst 8			;3fbd	cf		.
	ld (iy+001h),a		;3fbe	fd 77 01	. w .
	ld de,l0010h		;3fc1	11 10 00	. . .
	add hl,de		;3fc4	19		.
	ld a,(hl)		;3fc5	7e		~
	ld (iy+030h),a		;3fc6	fd 77 30	. w 0
	ret			;3fc9	c9		.
l3fcah:
	ld c,b			;3fca	48		H
	ld c,c			;3fcb	49		I
	ld c,d			;3fcc	4a		J
	ld c,e			;3fcd	4b		K
	ld c,h			;3fce	4c		L
	ld c,e			;3fcf	4b		K
	ld c,d			;3fd0	4a		J
	ld c,c			;3fd1	49		I
	ld c,b			;3fd2	48		H
	ld c,c			;3fd3	49		I
	ld c,d			;3fd4	4a		J
	ld c,e			;3fd5	4b		K
	ld c,h			;3fd6	4c		L
	ld c,e			;3fd7	4b		K
	ld c,d			;3fd8	4a		J
	ld c,c			;3fd9	49		I
	call p,0b4b4h		;3fda	f4 b4 b4	. . .
	or h			;3fdd	b4		.
	or h			;3fde	b4		.
	inc (hl)		;3fdf	34		4
	inc (hl)		;3fe0	34		4
	inc (hl)		;3fe1	34		4
	inc (hl)		;3fe2	34		4
	ld (hl),h		;3fe3	74		t
	ld (hl),h		;3fe4	74		t
	ld (hl),h		;3fe5	74		t
	ld (hl),h		;3fe6	74		t
	call p,0f4f4h		;3fe7	f4 f4 f4	. . .
sub_3feah:
	ld a,(0ad04h)		;3fea	3a 04 ad	: . .
	and a			;3fed	a7		.
	ret nz			;3fee	c0		.
	ld ix,0a8c0h		;3fef	dd 21 c0 a8	. ! . .
	ld iy,0aa28h		;3ff3	fd 21 28 aa	. ! ( .
	ld b,003h		;3ff7	06 03		. .
l3ff9h:
	ld a,(ix+000h)		;3ff9	dd 7e 00	. ~ .
	and a			;3ffc	a7		.
	jp z,l400bh		;3ffd	ca 0b 40	. . @
	inc a			;4000	3c		<
l4001h:
	jr nz,l4008h		;4001	20 05		  .
	call sub_4017h		;4003	cd 17 40	. . @
	jr l400bh		;4006	18 03		. .
l4008h:
	call sub_406ch		;4008	cd 6c 40	. l @
l400bh:
	ld de,l0010h		;400b	11 10 00	. . .
	add ix,de		;400e	dd 19		. .
	inc iy			;4010	fd 23		. #
	inc iy			;4012	fd 23		. #
	djnz l3ff9h		;4014	10 e3		. .
	ret			;4016	c9		.
sub_4017h:
	ld d,(iy+031h)		;4017	fd 56 31	. V 1
	ld e,(ix+003h)		;401a	dd 5e 03	. ^ .
	ld a,(ix+001h)		;401d	dd 7e 01	. ~ .
	and a			;4020	a7		.
	jr z,l4028h		;4021	28 05		( .
	ld hl,0fe80h		;4023	21 80 fe	! . .
	jr l402bh		;4026	18 03		. .
l4028h:
	ld hl,l0180h		;4028	21 80 01	! . .
l402bh:
	add hl,de		;402b	19		.
	ld de,(0a808h)		;402c	ed 5b 08 a8	. [ . .
	add hl,de		;4030	19		.
	ld (iy+031h),h		;4031	fd 74 31	. t 1
	ld (ix+003h),l		;4034	dd 75 03	. u .
	ld l,(ix+007h)		;4037	dd 6e 07	. n .
	ld h,(ix+008h)		;403a	dd 66 08	. f .
	ld de,l0009h		;403d	11 09 00	. . .
l4040h:
	add hl,de		;4040	19		.
	ld (ix+007h),l		;4041	dd 75 07	. u .
	ld (ix+008h),h		;4044	dd 74 08	. t .
	ld d,(iy+000h)		;4047	fd 56 00	. V .
	ld e,(ix+005h)		;404a	dd 5e 05	. ^ .
	add hl,de		;404d	19		.
	ld de,(0a80ah)		;404e	ed 5b 0a a8	. [ . .
	add hl,de		;4052	19		.
	ld (iy+000h),h		;4053	fd 74 00	. t .
	ld (ix+005h),l		;4056	dd 75 05	. u .
	ld a,(iy+031h)		;4059	fd 7e 31	. ~ 1
	add a,010h		;405c	c6 10		. .
	cp 020h			;405e	fe 20		.  
	jp c,sub_40abh		;4060	da ab 40	. . @
	ld a,(iy+000h)		;4063	fd 7e 00	. ~ .
	cp 0f8h			;4066	fe f8		. .
	jp nc,sub_40abh		;4068	d2 ab 40	. . @
	ret			;406b	c9		.
sub_406ch:
	ld a,(ix+000h)		;406c	dd 7e 00	. ~ .
	cp 03ch			;406f	fe 3c		. <
	call nc,sub_409dh	;4071	d4 9d 40	. . @
	dec (ix+000h)		;4074	dd 35 00	. 5 .
	jr z,sub_40abh		;4077	28 32		( 2
	call l2b60h		;4079	cd 60 2b	. ` +
	ld a,(ix+000h)		;407c	dd 7e 00	. ~ .
	cp 01ch			;407f	fe 1c		. .
	ret c			;4081	d8		.
	sub 01ch		;4082	d6 1c		. .
	rrca			;4084	0f		.
	rrca			;4085	0f		.
	and 00fh		;4086	e6 0f		. .
	ld hl,l4094h		;4088	21 94 40	! . @
	rst 8			;408b	cf		.
	ld (iy+001h),a		;408c	fd 77 01	. w .
	ld (iy+030h),00eh	;408f	fd 36 30 0e	. 6 0 .
	ret			;4093	c9		.
l4094h:
	rst 38h			;4094	ff		.
	sbc a,d			;4095	9a		.
	sbc a,c			;4096	99		.
	sbc a,b			;4097	98		.
	sbc a,b			;4098	98		.
	sbc a,c			;4099	99		.
	sbc a,c			;409a	99		.
	sbc a,d			;409b	9a		.
	sbc a,e			;409c	9b		.
sub_409dh:
	ld (ix+000h),03bh	;409d	dd 36 00 3b	. 6 . ;
	ld a,(0ad04h)		;40a1	3a 04 ad	: . .
	and a			;40a4	a7		.
	jp z,l568eh		;40a5	ca 8e 56	. . V
	jp l568eh		;40a8	c3 8e 56	. . V
sub_40abh:
	ld (ix+000h),000h	;40ab	dd 36 00 00	. 6 . .
	ld (iy+000h),000h	;40af	fd 36 00 00	. 6 . .
	ld (iy+031h),000h	;40b3	fd 36 31 00	. 6 1 .
	ret			;40b7	c9		.
sub_40b8h:
	ld a,(0ad04h)		;40b8	3a 04 ad	: . .
	cp 002h			;40bb	fe 02		. .
	ret c			;40bd	d8		.
	ld a,(0a980h)		;40be	3a 80 a9	: . .
	and 01fh		;40c1	e6 1f		. .
	ret nz			;40c3	c0		.
	ld a,(0a8c0h)		;40c4	3a c0 a8	: . .
	inc a			;40c7	3c		<
	ret z			;40c8	c8		.
	ld a,(0a8d0h)		;40c9	3a d0 a8	: . .
	inc a			;40cc	3c		<
	ret z			;40cd	c8		.
	ld a,(0a8e0h)		;40ce	3a e0 a8	: . .
	inc a			;40d1	3c		<
	ret z			;40d2	c8		.
	jp sub_5679h		;40d3	c3 79 56	. y V
sub_40d6h:
	ld a,(0ad04h)		;40d6	3a 04 ad	: . .
	cp 002h			;40d9	fe 02		. .
	ret c			;40db	d8		.
	ld ix,0a8c0h		;40dc	dd 21 c0 a8	. ! . .
	ld iy,0aa28h		;40e0	fd 21 28 aa	. ! ( .
	ld a,(0a8c6h)		;40e4	3a c6 a8	: . .
	and a			;40e7	a7		.
	ret z			;40e8	c8		.
	ld b,a			;40e9	47		G
l40eah:
	ld a,(ix+000h)		;40ea	dd 7e 00	. ~ .
	and a			;40ed	a7		.
	jp z,l410bh		;40ee	ca 0b 41	. . A
	inc a			;40f1	3c		<
	jr nz,l4108h		;40f2	20 14		  .
	ld a,(0ad04h)		;40f4	3a 04 ad	: . .
	cp 004h			;40f7	fe 04		. .
	jp z,l4194h		;40f9	ca 94 41	. . A
	ld a,(ix+00eh)		;40fc	dd 7e 0e	. ~ .
	and a			;40ff	a7		.
	jp nz,l418bh		;4100	c2 8b 41	. . A
	call sub_4117h		;4103	cd 17 41	. . A
	jr l410bh		;4106	18 03		. .
l4108h:
	call sub_413ch		;4108	cd 3c 41	. < A
l410bh:
	ld de,l0010h		;410b	11 10 00	. . .
	add ix,de		;410e	dd 19		. .
	inc iy			;4110	fd 23		. #
	inc iy			;4112	fd 23		. #
	djnz l40eah		;4114	10 d4		. .
	ret			;4116	c9		.
sub_4117h:
	push bc			;4117	c5		.
	ld a,(0a980h)		;4118	3a 80 a9	: . .
	and 00fh		;411b	e6 0f		. .
	cp (ix+00fh)		;411d	dd be 0f	. . .
	jr nz,l412bh		;4120	20 09		  .
	ld hl,0ac7fh		;4122	21 7f ac	! . .
	call sub_33b8h		;4125	cd b8 33	. . 3
	ld (ix+001h),a		;4128	dd 77 01	. w .
l412bh:
	call sub_4201h		;412b	cd 01 42	. . B
	call l58aah		;412e	cd aa 58	. . X
	call sub_3fafh		;4131	cd af 3f	. . ?
	pop bc			;4134	c1		.
	call sub_2b83h		;4135	cd 83 2b	. . +
	ret nc			;4138	d0		.
	jp sub_40abh		;4139	c3 ab 40	. . @
sub_413ch:
	ld a,(ix+000h)		;413c	dd 7e 00	. ~ .
	cp 03ch			;413f	fe 3c		. <
	call nc,sub_409dh	;4141	d4 9d 40	. . @
	call l2b60h		;4144	cd 60 2b	. ` +
	dec (ix+000h)		;4147	dd 35 00	. 5 .
	jp z,sub_40abh		;414a	ca ab 40	. . @
	ld a,(ix+000h)		;414d	dd 7e 00	. ~ .
	cp 01ch			;4150	fe 1c		. .
	ret c			;4152	d8		.
	sub 01ch		;4153	d6 1c		. .
	rrca			;4155	0f		.
	rrca			;4156	0f		.
	and 007h		;4157	e6 07		. .
	ld d,a			;4159	57		W
	ld a,(0ad04h)		;415a	3a 04 ad	: . .
	cp 004h			;415d	fe 04		. .
	jr nc,l4176h		;415f	30 15		0 .
	ld hl,l416eh		;4161	21 6e 41	! n A
	ld a,d			;4164	7a		z
	rst 8			;4165	cf		.
	ld (iy+001h),a		;4166	fd 77 01	. w .
	ld (iy+030h),00dh	;4169	fd 36 30 0d	. 6 0 .
	ret			;416d	c9		.
l416eh:
	rst 38h			;416e	ff		.
	sbc a,(hl)		;416f	9e		.
	sbc a,a			;4170	9f		.
	sbc a,a			;4171	9f		.
	sbc a,(hl)		;4172	9e		.
	sbc a,(hl)		;4173	9e		.
	sbc a,l			;4174	9d		.
	sbc a,h			;4175	9c		.
l4176h:
	ld hl,l4183h		;4176	21 83 41	! . A
	ld a,d			;4179	7a		z
	rst 8			;417a	cf		.
	ld (iy+001h),a		;417b	fd 77 01	. w .
	ld (iy+030h),002h	;417e	fd 36 30 02	. 6 0 .
	ret			;4182	c9		.
l4183h:
	rst 38h			;4183	ff		.
	jp po,0e3e3h		;4184	e2 e3 e3	. . .
	jp po,0e1e2h		;4187	e2 e2 e1	. . .
	ret po			;418a	e0		.
l418bh:
	call sub_3e6ch		;418b	cd 6c 3e	. l >
	dec (ix+00eh)		;418e	dd 35 0e	. 5 .
	jp l410bh		;4191	c3 0b 41	. . A
l4194h:
	ld a,(ix+004h)		;4194	dd 7e 04	. ~ .
	and a			;4197	a7		.
	jp z,l41a4h		;4198	ca a4 41	. . A
	dec (ix+004h)		;419b	dd 35 04	. 5 .
	call sub_41b8h		;419e	cd b8 41	. . A
	jp l410bh		;41a1	c3 0b 41	. . A
l41a4h:
	push bc			;41a4	c5		.
	call sub_58b6h		;41a5	cd b6 58	. . X
	call sub_41f1h		;41a8	cd f1 41	. . A
	call sub_2b83h		;41ab	cd 83 2b	. . +
	pop bc			;41ae	c1		.
	jp nc,l410bh		;41af	d2 0b 41	. . A
	call sub_40abh		;41b2	cd ab 40	. . @
	jp l410bh		;41b5	c3 0b 41	. . A
sub_41b8h:
	push bc			;41b8	c5		.
	ld a,(0a980h)		;41b9	3a 80 a9	: . .
	and 00fh		;41bc	e6 0f		. .
	jr nz,l41dfh		;41be	20 1f		  .
	ld hl,0ac75h		;41c0	21 75 ac	! u .
	bit 0,(ix+00fh)		;41c3	dd cb 0f 46	. . . F
	jr nz,l41cch		;41c7	20 03		  .
	ld hl,0ac79h		;41c9	21 79 ac	! y .
l41cch:
	call sub_33b8h		;41cc	cd b8 33	. . 3
	ld b,a			;41cf	47		G
	ld a,d			;41d0	7a		z
	cp 010h			;41d1	fe 10		. .
	jr nc,l41dch		;41d3	30 07		0 .
	ex af,af'		;41d5	08		.
	cp 010h			;41d6	fe 10		. .
	call c,sub_41ech	;41d8	dc ec 41	. . A
	ex af,af'		;41db	08		.
l41dch:
	ld (ix+001h),b		;41dc	dd 70 01	. p .
l41dfh:
	call sub_421fh		;41df	cd 1f 42	. . B
	call sub_58b6h		;41e2	cd b6 58	. . X
	call sub_41f1h		;41e5	cd f1 41	. . A
	pop bc			;41e8	c1		.
	jp sub_2b83h		;41e9	c3 83 2b	. . +
sub_41ech:
	ld (ix+004h),000h	;41ec	dd 36 04 00	. 6 . .
	ret			;41f0	c9		.
sub_41f1h:
	ld a,(0a980h)		;41f1	3a 80 a9	: . .
	rrca			;41f4	0f		.
	and 007h		;41f5	e6 07		. .
	add a,050h		;41f7	c6 50		. P
	ld (iy+001h),a		;41f9	fd 77 01	. w .
	ld (iy+030h),00ah	;41fc	fd 36 30 0a	. 6 0 .
	ret			;4200	c9		.
sub_4201h:
	ld a,(ix+001h)		;4201	dd 7e 01	. ~ .
	sub (ix+002h)		;4204	dd 96 02	. . .
	add a,001h		;4207	c6 01		. .
	cp 002h			;4209	fe 02		. .
	ret c			;420b	d8		.
	cp 080h			;420c	fe 80		. .
	ld a,(ix+002h)		;420e	dd 7e 02	. ~ .
	jr nc,l4219h		;4211	30 06		0 .
	add a,001h		;4213	c6 01		. .
	ld (ix+002h),a		;4215	dd 77 02	. w .
	ret			;4218	c9		.
l4219h:
	sub 001h		;4219	d6 01		. .
	ld (ix+002h),a		;421b	dd 77 02	. w .
	ret			;421e	c9		.
sub_421fh:
	ld a,(0a980h)		;421f	3a 80 a9	: . .
	and 003h		;4222	e6 03		. .
	ret z			;4224	c8		.
	ld a,(ix+001h)		;4225	dd 7e 01	. ~ .
	sub (ix+002h)		;4228	dd 96 02	. . .
	add a,001h		;422b	c6 01		. .
	cp 002h			;422d	fe 02		. .
	ret c			;422f	d8		.
	cp 080h			;4230	fe 80		. .
	ld a,(ix+002h)		;4232	dd 7e 02	. ~ .
	jr nc,l423dh		;4235	30 06		0 .
	add a,002h		;4237	c6 02		. .
	ld (ix+002h),a		;4239	dd 77 02	. w .
	ret			;423c	c9		.
l423dh:
	sub 002h		;423d	d6 02		. .
	ld (ix+002h),a		;423f	dd 77 02	. w .
	ret			;4242	c9		.
sub_4243h:
	ld a,(0a980h)		;4243	3a 80 a9	: . .
	and 007h		;4246	e6 07		. .
	add a,005h		;4248	c6 05		. .
	cp (ix+00fh)		;424a	dd be 0f	. . .
	ret nz			;424d	c0		.
	ld hl,0a8f4h		;424e	21 f4 a8	! . .
	ld a,(hl)		;4251	7e		~
	and a			;4252	a7		.
	jr z,l4257h		;4253	28 02		( .
	dec (hl)		;4255	35		5
	ret			;4256	c9		.
l4257h:
	ld hl,0a8c0h		;4257	21 c0 a8	! . .
	ld de,0aa28h		;425a	11 28 aa	. ( .
	ld a,(0a8c6h)		;425d	3a c6 a8	: . .
	and a			;4260	a7		.
	ret z			;4261	c8		.
	ld b,a			;4262	47		G
l4263h:
	ld a,(hl)		;4263	7e		~
	and a			;4264	a7		.
	jp z,l4271h		;4265	ca 71 42	. q B
	ld a,l			;4268	7d		}
	add a,010h		;4269	c6 10		. .
	ld l,a			;426b	6f		o
	inc de			;426c	13		.
	inc de			;426d	13		.
	djnz l4263h		;426e	10 f3		. .
	ret			;4270	c9		.
l4271h:
	ld (0a991h),hl		;4271	22 91 a9	" . .
	ld (0a993h),de		;4274	ed 53 93 a9	. S . .
	ld a,(0a8d6h)		;4278	3a d6 a8	: . .
	ld d,a			;427b	57		W
	add a,a			;427c	87		.
	ld c,a			;427d	4f		O
	ld a,078h		;427e	3e 78		> x
	sub (iy+031h)		;4280	fd 96 31	. . 1
	add a,d			;4283	82		.
	cp c			;4284	b9		.
	jr nc,l428fh		;4285	30 08		0 .
	ld a,084h		;4287	3e 84		> .
	sub (iy+000h)		;4289	fd 96 00	. . .
	add a,d			;428c	82		.
	cp c			;428d	b9		.
	ret c			;428e	d8		.
l428fh:
	ld c,(ix+002h)		;428f	dd 4e 02	. N .
	ld a,(0ad04h)		;4292	3a 04 ad	: . .
	and a			;4295	a7		.
	jp z,l429ch		;4296	ca 9c 42	. . B
	jp l42b7h		;4299	c3 b7 42	. . B
l429ch:
	ld a,(0a8e6h)		;429c	3a e6 a8	: . .
	ld d,a			;429f	57		W
	add a,a			;42a0	87		.
	ld c,a			;42a1	4f		O
	ld a,084h		;42a2	3e 84		> .
	sub (iy+000h)		;42a4	fd 96 00	. . .
	add a,d			;42a7	82		.
	cp c			;42a8	b9		.
	ret nc			;42a9	d0		.
	ld a,078h		;42aa	3e 78		> x
	sub (iy+031h)		;42ac	fd 96 31	. . 1
	jr c,l42b5h		;42af	38 04		8 .
	ld c,000h		;42b1	0e 00		. .
	jr l42b7h		;42b3	18 02		. .
l42b5h:
	ld c,001h		;42b5	0e 01		. .
l42b7h:
	ld d,(iy+031h)		;42b7	fd 56 31	. V 1
	ld e,(ix+003h)		;42ba	dd 5e 03	. ^ .
	ld h,(iy+000h)		;42bd	fd 66 00	. f .
	ld l,(ix+005h)		;42c0	dd 6e 05	. n .
	exx			;42c3	d9		.
	push ix			;42c4	dd e5		. .
	push iy			;42c6	fd e5		. .
	ld ix,(0a991h)		;42c8	dd 2a 91 a9	. * . .
	ld iy,(0a993h)		;42cc	fd 2a 93 a9	. * . .
	exx			;42d0	d9		.
	ld (ix+003h),e		;42d1	dd 73 03	. s .
	ld (iy+031h),d		;42d4	fd 72 31	. r 1
	ld (ix+005h),l		;42d7	dd 75 05	. u .
	ld (iy+000h),h		;42da	fd 74 00	. t .
	ld (ix+001h),c		;42dd	dd 71 01	. q .
	ld a,(0ad04h)		;42e0	3a 04 ad	: . .
	cp 004h			;42e3	fe 04		. .
	jp z,l43aeh		;42e5	ca ae 43	. . C
	and a			;42e8	a7		.
	jp nz,l4313h		;42e9	c2 13 43	. . C
	ld (iy+001h),04fh	;42ec	fd 36 01 4f	. 6 . O
	ld a,c			;42f0	79		y
	rrca			;42f1	0f		.
	sra a			;42f2	cb 2f		. /
	and 0c0h		;42f4	e6 c0		. .
	add a,00bh		;42f6	c6 0b		. .
	ld (iy+030h),a		;42f8	fd 77 30	. w 0
	ld (ix+007h),000h	;42fb	dd 36 07 00	. 6 . .
	ld (ix+008h),0ffh	;42ff	dd 36 08 ff	. 6 . .
	dec (ix+000h)		;4303	dd 35 00	. 5 .
	ld a,(0a8f6h)		;4306	3a f6 a8	: . .
	ld (0a8f4h),a		;4309	32 f4 a8	2 . .
	pop iy			;430c	fd e1		. .
	pop ix			;430e	dd e1		. .
	jp l5664h		;4310	c3 64 56	. d V
l4313h:
	ld a,(0ad04h)		;4313	3a 04 ad	: . .
	cp 003h			;4316	fe 03		. .
	jp z,l436fh		;4318	ca 6f 43	. o C
	jp nc,l434ch		;431b	d2 4c 43	. L C
	ld hl,0ac7fh		;431e	21 7f ac	! . .
	call sub_33b8h		;4321	cd b8 33	. . 3
	ld (ix+001h),a		;4324	dd 77 01	. w .
	ld a,(ix+00fh)		;4327	dd 7e 0f	. ~ .
	rrca			;432a	0f		.
	and 080h		;432b	e6 80		. .
	add a,040h		;432d	c6 40		. @
	add a,(ix+001h)		;432f	dd 86 01	. . .
	ld (ix+002h),a		;4332	dd 77 02	. w .
	call sub_3fafh		;4335	cd af 3f	. . ?
	dec (ix+000h)		;4338	dd 35 00	. 5 .
	ld a,(0a8f6h)		;433b	3a f6 a8	: . .
	ld (0a8f4h),a		;433e	32 f4 a8	2 . .
	ld (ix+00eh),000h	;4341	dd 36 0e 00	. 6 . .
	pop iy			;4345	fd e1		. .
	pop ix			;4347	dd e1		. .
	jp l566eh		;4349	c3 6e 56	. n V
l434ch:
	ld hl,0ac7fh		;434c	21 7f ac	! . .
	call sub_33b8h		;434f	cd b8 33	. . 3
	ld (ix+001h),a		;4352	dd 77 01	. w .
	ld (ix+002h),a		;4355	dd 77 02	. w .
	call sub_3fafh		;4358	cd af 3f	. . ?
	dec (ix+000h)		;435b	dd 35 00	. 5 .
	ld a,(0a8f6h)		;435e	3a f6 a8	: . .
	ld (0a8f4h),a		;4361	32 f4 a8	2 . .
	ld (ix+00eh),000h	;4364	dd 36 0e 00	. 6 . .
	pop iy			;4368	fd e1		. .
	pop ix			;436a	dd e1		. .
	jp l5674h		;436c	c3 74 56	. t V
l436fh:
	push bc			;436f	c5		.
	ld a,c			;4370	79		y
	add a,040h		;4371	c6 40		. @
	and 080h		;4373	e6 80		. .
	ld a,c			;4375	79		y
	jr nz,l437fh		;4376	20 07		  .
	add a,01ah		;4378	c6 1a		. .
	ld (ix+002h),a		;437a	dd 77 02	. w .
	jr l4384h		;437d	18 05		. .
l437fh:
	sub 01ah		;437f	d6 1a		. .
	ld (ix+002h),a		;4381	dd 77 02	. w .
l4384h:
	call sub_598eh		;4384	cd 8e 59	. . Y
	ld (ix+00ah),e		;4387	dd 73 0a	. s .
	ld (ix+00bh),d		;438a	dd 72 0b	. r .
	ld (ix+00ch),c		;438d	dd 71 0c	. q .
	ld (ix+00dh),b		;4390	dd 70 0d	. p .
	pop bc			;4393	c1		.
	ld (ix+002h),c		;4394	dd 71 02	. q .
	call sub_3fafh		;4397	cd af 3f	. . ?
	ld (ix+00eh),020h	;439a	dd 36 0e 20	. 6 .  
	dec (ix+000h)		;439e	dd 35 00	. 5 .
	ld a,(0a8f6h)		;43a1	3a f6 a8	: . .
	ld (0a8f4h),a		;43a4	32 f4 a8	2 . .
	pop iy			;43a7	fd e1		. .
	pop ix			;43a9	dd e1		. .
	jp l566eh		;43ab	c3 6e 56	. n V
l43aeh:
	ld a,(0a8e6h)		;43ae	3a e6 a8	: . .
	ld (ix+004h),a		;43b1	dd 77 04	. w .
	jp l4313h		;43b4	c3 13 43	. . C
sub_43b7h:
	ld a,(0acc6h)		;43b7	3a c6 ac	: . .
	inc a			;43ba	3c		<
	ret z			;43bb	c8		.
	ld a,(0ad0dh)		;43bc	3a 0d ad	: . .
	and a			;43bf	a7		.
	jr nz,l43f0h		;43c0	20 2e		  .
	ld a,(0a980h)		;43c2	3a 80 a9	: . .
	and 007h		;43c5	e6 07		. .
	cp 005h			;43c7	fe 05		. .
	ret nz			;43c9	c0		.
	ld ix,0a8a0h		;43ca	dd 21 a0 a8	. ! . .
	ld iy,0aa24h		;43ce	fd 21 24 aa	. ! $ .
	ld a,(0ad02h)		;43d2	3a 02 ad	: . .
	or (ix+000h)		;43d5	dd b6 00	. . .
	or (ix+010h)		;43d8	dd b6 10	. . .
	ret nz			;43db	c0		.
	ld a,0ffh		;43dc	3e ff		> .
	ld (0ad0dh),a		;43de	32 0d ad	2 . .
	ld (ix+004h),007h	;43e1	dd 36 04 07	. 6 . .
	jp l46dbh		;43e5	c3 db 46	. . F
l43e8h:
	xor a			;43e8	af		.
l43e9h:
	add a,(hl)		;43e9	86		.
	inc hl			;43ea	23		#
	djnz l43e9h		;43eb	10 fc		. .
	jp l07adh		;43ed	c3 ad 07	. . .
l43f0h:
	ld ix,0a8a0h		;43f0	dd 21 a0 a8	. ! . .
	ld iy,0aa24h		;43f4	fd 21 24 aa	. ! $ .
	ld a,(ix+000h)		;43f8	dd 7e 00	. ~ .
	and a			;43fb	a7		.
	jp z,l4535h		;43fc	ca 35 45	. 5 E
	inc a			;43ff	3c		<
	jp nz,l4540h		;4400	c2 40 45	. @ E
l4403h:
	ld h,(ix+00ch)		;4403	dd 66 0c	. f .
	ld l,(ix+00dh)		;4406	dd 6e 0d	. n .
	ld de,(0a808h)		;4409	ed 5b 08 a8	. [ . .
	add hl,de		;440d	19		.
	ld d,(iy+031h)		;440e	fd 56 31	. V 1
	ld e,(ix+003h)		;4411	dd 5e 03	. ^ .
	add hl,de		;4414	19		.
	ld (iy+031h),h		;4415	fd 74 31	. t 1
	ld (ix+003h),l		;4418	dd 75 03	. u .
	ld h,(ix+01ch)		;441b	dd 66 1c	. f .
	ld l,(ix+01dh)		;441e	dd 6e 1d	. n .
	ld de,(0a80ah)		;4421	ed 5b 0a a8	. [ . .
	add hl,de		;4425	19		.
	ld d,(iy+000h)		;4426	fd 56 00	. V .
	ld e,(ix+005h)		;4429	dd 5e 05	. ^ .
	add hl,de		;442c	19		.
	ld (iy+000h),h		;442d	fd 74 00	. t .
	ld (ix+005h),l		;4430	dd 75 05	. u .
	ld a,(iy+031h)		;4433	fd 7e 31	. ~ 1
	add a,010h		;4436	c6 10		. .
l4438h:
	ld (iy+033h),a		;4438	fd 77 33	. w 3
	ld a,(iy+000h)		;443b	fd 7e 00	. ~ .
	ld (iy+002h),a		;443e	fd 77 02	. w .
	call sub_4447h		;4441	cd 47 44	. G D
	jp l46f0h		;4444	c3 f0 46	. . F
sub_4447h:
	call sub_3cc4h		;4447	cd c4 3c	. . <
	jp c,l46dbh		;444a	da db 46	. . F
	ld a,(0ad04h)		;444d	3a 04 ad	: . .
	ld d,a			;4450	57		W
	cp 004h			;4451	fe 04		. .
	jp z,l44a2h		;4453	ca a2 44	. . D
	ld a,d			;4456	7a		z
	add a,a			;4457	87		.
	add a,a			;4458	87		.
	add a,a			;4459	87		.
	add a,a			;445a	87		.
	ld b,a			;445b	47		G
	ld a,(0a980h)		;445c	3a 80 a9	: . .
	and 002h		;445f	e6 02		. .
	add a,b			;4461	80		.
	ld b,a			;4462	47		G
	ld a,007h		;4463	3e 07		> .
	sub (ix+004h)		;4465	dd 96 04	. . .
	rrca			;4468	0f		.
	and 003h		;4469	e6 03		. .
	ld e,a			;446b	5f		_
	add a,a			;446c	87		.
	add a,a			;446d	87		.
	add a,b			;446e	80		.
	ld hl,l44f1h		;446f	21 f1 44	! . D
	rst 18h			;4472	df		.
	ld b,(hl)		;4473	46		F
	inc hl			;4474	23		#
	ld c,(hl)		;4475	4e		N
	ld hl,04531h		;4476	21 31 45	! 1 E
	ld a,d			;4479	7a		z
	rst 18h			;447a	df		.
	ld d,(hl)		;447b	56		V
	ld a,(ix+002h)		;447c	dd 7e 02	. ~ .
	add a,040h		;447f	c6 40		. @
	cp 080h			;4481	fe 80		. .
	jr c,l4495h		;4483	38 10		8 .
	ld (iy+001h),b		;4485	fd 70 01	. p .
	ld (iy+003h),c		;4488	fd 71 03	. q .
	ld a,d			;448b	7a		z
	add a,080h		;448c	c6 80		. .
	ld (iy+030h),a		;448e	fd 77 30	. w 0
	ld (iy+032h),a		;4491	fd 77 32	. w 2
	ret			;4494	c9		.
l4495h:
	ld (iy+001h),c		;4495	fd 71 01	. q .
	ld (iy+003h),b		;4498	fd 70 03	. p .
	ld (iy+030h),d		;449b	fd 72 30	. r 0
	ld (iy+032h),d		;449e	fd 72 32	. r 2
	ret			;44a1	c9		.
l44a2h:
	ld a,(ix+004h)		;44a2	dd 7e 04	. ~ .
	ld e,a			;44a5	5f		_
	cp 007h			;44a6	fe 07		. .
	jp z,l44bfh		;44a8	ca bf 44	. . D
	inc (ix+006h)		;44ab	dd 34 06	. 4 .
	ld c,(ix+006h)		;44ae	dd 4e 06	. N .
	bit 7,c			;44b1	cb 79		. y
	jr nz,l44c9h		;44b3	20 14		  .
	ld a,e			;44b5	7b		{
	add a,002h		;44b6	c6 02		. .
	cp c			;44b8	b9		.
	jr nc,l44bfh		;44b9	30 04		0 .
	ld (ix+006h),080h	;44bb	dd 36 06 80	. 6 . .
l44bfh:
	ld (iy+030h),070h	;44bf	fd 36 30 70	. 6 0 p
	ld (iy+032h),070h	;44c3	fd 36 32 70	. 6 2 p
	jr l44dch		;44c7	18 13		. .
l44c9h:
	ld a,c			;44c9	79		y
	and 07fh		;44ca	e6 7f		. .
	cp 003h			;44cc	fe 03		. .
	jr c,l44d4h		;44ce	38 04		8 .
	ld (ix+006h),000h	;44d0	dd 36 06 00	. 6 . .
l44d4h:
	ld (iy+030h),051h	;44d4	fd 36 30 51	. 6 0 Q
	ld (iy+032h),051h	;44d8	fd 36 32 51	. 6 2 Q
l44dch:
	ld de,sub_0201h+1	;44dc	11 02 02	. . .
	ld hl,0d4d5h		;44df	21 d5 d4	! . .
	ld a,(0a980h)		;44e2	3a 80 a9	: . .
	bit 2,a			;44e5	cb 57		. W
	jr nz,l44eah		;44e7	20 01		  .
	add hl,de		;44e9	19		.
l44eah:
	ld (iy+001h),l		;44ea	fd 75 01	. u .
	ld (iy+003h),h		;44ed	fd 74 03	. t .
	ret			;44f0	c9		.
l44f1h:
	add hl,sp		;44f1	39		9
	jr c,l452dh		;44f2	38 39		8 9
	jr c,$+61		;44f4	38 3b		8 ;
	ld a,(l3c3dh)		;44f6	3a 3d 3c	: = <
	dec sp			;44f9	3b		;
	ld a,(l3c3dh)		;44fa	3a 3d 3c	: = <
	dec a			;44fd	3d		=
	inc a			;44fe	3c		<
	ccf			;44ff	3f		?
	ld a,0b0h		;4500	3e b0		> .
	or c			;4502	b1		.
	or d			;4503	b2		.
	or e			;4504	b3		.
	or h			;4505	b4		.
	or l			;4506	b5		.
	or (hl)			;4507	b6		.
	or a			;4508	b7		.
	cp b			;4509	b8		.
	cp c			;450a	b9		.
	cp d			;450b	ba		.
	cp e			;450c	bb		.
	cp h			;450d	bc		.
	cp l			;450e	bd		.
	cp (hl)			;450f	be		.
	cp a			;4510	bf		.
	ret nz			;4511	c0		.
	pop bc			;4512	c1		.
	jp nz,0c4c3h		;4513	c2 c3 c4	. . .
	push bc			;4516	c5		.
	add a,0c7h		;4517	c6 c7		. .
	add a,0c7h		;4519	c6 c7		. .
	ret z			;451b	c8		.
	ret			;451c	c9		.
	ret z			;451d	c8		.
	ret			;451e	c9		.
	jp z,0cccbh		;451f	ca cb cc	. . .
	call 0cdcch		;4522	cd cc cd	. . .
	adc a,0cfh		;4525	ce cf		. .
	ret nc			;4527	d0		.
	pop de			;4528	d1		.
	adc a,0cfh		;4529	ce cf		. .
	ret nc			;452b	d0		.
	pop de			;452c	d1		.
l452dh:
	ret nc			;452d	d0		.
	pop de			;452e	d1		.
	jp nc,0e9d3h		;452f	d2 d3 e9	. . .
	ld e,b			;4532	58		X
	ld l,a			;4533	6f		o
	ld l,(hl)		;4534	6e		n
l4535h:
	ld a,(ix+00eh)		;4535	dd 7e 0e	. ~ .
	and a			;4538	a7		.
	jp z,l4663h		;4539	ca 63 46	. c F
	dec (ix+00eh)		;453c	dd 35 0e	. 5 .
	ret			;453f	c9		.
l4540h:
	ld c,a			;4540	4f		O
	ld a,(ix+004h)		;4541	dd 7e 04	. ~ .
	and a			;4544	a7		.
	jr z,l4554h		;4545	28 0d		( .
	dec (ix+004h)		;4547	dd 35 04	. 5 .
	ld (ix+000h),0ffh	;454a	dd 36 00 ff	. 6 . .
	call sub_5683h		;454e	cd 83 56	. . V
	jp l4403h		;4551	c3 03 44	. . D
l4554h:
	ld a,c			;4554	79		y
	cp 0f0h			;4555	fe f0		. .
	jp nz,l45b3h		;4557	c2 b3 45	. . E
	xor a			;455a	af		.
	ld (0a8dch),a		;455b	32 dc a8	2 . .
	call sub_5634h		;455e	cd 34 56	. 4 V
	call sub_56d2h		;4561	cd d2 56	. . V
	ld hl,0a810h		;4564	21 10 a8	! . .
	ld de,l0010h		;4567	11 10 00	. . .
	ld b,00fh		;456a	06 0f		. .
	ld c,014h		;456c	0e 14		. .
l456eh:
	ld a,(hl)		;456e	7e		~
	inc a			;456f	3c		<
	jr nz,l4594h		;4570	20 22		  "
	ld (hl),c		;4572	71		q
	exx			;4573	d9		.
	ld de,l0402h		;4574	11 02 04	. . .
	rst 38h			;4577	ff		.
	exx			;4578	d9		.
l4579h:
	add hl,de		;4579	19		.
	ld a,c			;457a	79		y
	add a,00ah		;457b	c6 0a		. .
	ld c,a			;457d	4f		O
	djnz l456eh		;457e	10 ee		. .
	ld c,03ch		;4580	0e 3c		. <
	ld a,0feh		;4582	3e fe		> .
	ld (0acc6h),a		;4584	32 c6 ac	2 . .
	ld (ix+000h),0e4h	;4587	dd 36 00 e4	. 6 . .
	ld (iy+030h),03dh	;458b	fd 36 30 3d	. 6 0 =
	ld (iy+032h),03dh	;458f	fd 36 32 3d	. 6 2 =
	ret			;4593	c9		.
l4594h:
	inc a			;4594	3c		<
	jr nz,l4579h		;4595	20 e2		  .
	ld (hl),000h		;4597	36 00		6 .
	jr l4579h		;4599	18 de		. .
l459bh:
	ld d,0a7h		;459b	16 a7		. .
	inc de			;459d	13		.
	sub (hl)		;459e	96		.
	defb 0edh ;next byte illegal after ed	;459f	ed		.
	call c,08cf1h		;45a0	dc f1 8c	. . .
	ld l,b			;45a3	68		h
	dec sp			;45a4	3b		;
	dec c			;45a5	0d		.
	defb 0edh ;next byte illegal after ed	;45a6	ed		.
	pop af			;45a7	f1		.
	sbc a,e			;45a8	9b		.
	inc de			;45a9	13		.
	inc de			;45aa	13		.
	inc de			;45ab	13		.
	inc de			;45ac	13		.
	pop af			;45ad	f1		.
	adc a,b			;45ae	88		.
	call c,sub_11edh	;45af	dc ed 11	. . .
	cp c			;45b2	b9		.
l45b3h:
	call l2b60h		;45b3	cd 60 2b	. ` +
	ld a,(iy+031h)		;45b6	fd 7e 31	. ~ 1
	ld b,a			;45b9	47		G
	add a,013h		;45ba	c6 13		. .
	cp 003h			;45bc	fe 03		. .
	jr c,l45d5h		;45be	38 15		8 .
	ld a,b			;45c0	78		x
	add a,010h		;45c1	c6 10		. .
	ld (iy+033h),a		;45c3	fd 77 33	. w 3
	ld a,(iy+000h)		;45c6	fd 7e 00	. ~ .
	ld b,a			;45c9	47		G
	add a,008h		;45ca	c6 08		. .
	cp 028h			;45cc	fe 28		. (
	jr c,l45d5h		;45ce	38 05		8 .
	ld (iy+002h),b		;45d0	fd 70 02	. p .
	jr l45ddh		;45d3	18 08		. .
l45d5h:
	ld (iy+001h),0ffh	;45d5	fd 36 01 ff	. 6 . .
	ld (iy+003h),0ffh	;45d9	fd 36 03 ff	. 6 . .
l45ddh:
	ld a,(ix+000h)		;45dd	dd 7e 00	. ~ .
	cp 0b4h			;45e0	fe b4		. .
	jr z,l4623h		;45e2	28 3f		( ?
	jr c,l45f9h		;45e4	38 13		8 .
	sub 0b4h		;45e6	d6 b4		. .
	rrca			;45e8	0f		.
	rrca			;45e9	0f		.
	rrca			;45ea	0f		.
	dec a			;45eb	3d		=
	and 007h		;45ec	e6 07		. .
	ld hl,l461bh		;45ee	21 1b 46	! . F
	rst 8			;45f1	cf		.
	ld (iy+003h),a		;45f2	fd 77 03	. w .
	inc a			;45f5	3c		<
	ld (iy+001h),a		;45f6	fd 77 01	. w .
l45f9h:
	dec (ix+000h)		;45f9	dd 35 00	. 5 .
	jp z,l4646h		;45fc	ca 46 46	. F F
	ld a,(ix+000h)		;45ff	dd 7e 00	. ~ .
	cp 05ah			;4602	fe 5a		. Z
	ret nz			;4604	c0		.
	ld (iy+001h),0ffh	;4605	fd 36 01 ff	. 6 . .
	ld (iy+003h),0ffh	;4609	fd 36 03 ff	. 6 . .
	ret			;460d	c9		.
sub_460eh:
	ld hl,0a67ch		;460e	21 7c a6	! | .
	ld a,(hl)		;4611	7e		~
	ld c,a			;4612	4f		O
	ld a,(0ab43h)		;4613	3a 43 ab	: C .
	sub c			;4616	91		.
	jp nz,l4643h		;4617	c2 43 46	. C F
	ret			;461a	c9		.
l461bh:
	sub h			;461b	94		.
	sub (hl)		;461c	96		.
	sub (hl)		;461d	96		.
	sub h			;461e	94		.
	sub d			;461f	92		.
	sub b			;4620	90		.
	sub b			;4621	90		.
	sub h			;4622	94		.
l4623h:
	dec (ix+000h)		;4623	dd 35 00	. 5 .
	ld (iy+001h),0feh	;4626	fd 36 01 fe	. 6 . .
	ld (iy+003h),0fdh	;462a	fd 36 03 fd	. 6 . .
	ld (iy+030h),06ch	;462e	fd 36 30 6c	. 6 0 l
	ld (iy+032h),06ch	;4632	fd 36 32 6c	. 6 2 l
	ld a,(WORK_RAM)		;4636	3a 00 a8	: . .
	inc a			;4639	3c		<
	call z,sub_580bh	;463a	cc 0b 58	. . X
	ld de,l040dh		;463d	11 0d 04	. . .
	jp l0038h		;4640	c3 38 00	. 8 .
l4643h:
	jp l461bh		;4643	c3 1b 46	. . F
l4646h:
	ld a,0ffh		;4646	3e ff		> .
	ld (0acc6h),a		;4648	32 c6 ac	2 . .
	ld (ix+000h),000h	;464b	dd 36 00 00	. 6 . .
	ld hl,0ab43h		;464f	21 43 ab	! C .
	ld a,(hl)		;4652	7e		~
	cp 07ch			;4653	fe 7c		. |
	jp nz,l4660h		;4655	c2 60 46	. ` F
	inc hl			;4658	23		#
	ld a,(hl)		;4659	7e		~
	cp 010h			;465a	fe 10		. .
	ret z			;465c	c8		.
	cp 005h			;465d	fe 05		. .
	ret z			;465f	c8		.
l4660h:
	jp l459bh		;4660	c3 9b 45	. . E
l4663h:
	ld a,(0acc6h)		;4663	3a c6 ac	: . .
	and a			;4666	a7		.
	ret nz			;4667	c0		.
	ld a,(0a802h)		;4668	3a 02 a8	: . .
	ld b,a			;466b	47		G
	ld a,(0a980h)		;466c	3a 80 a9	: . .
	ld c,a			;466f	4f		O
	ld a,010h		;4670	3e 10		> .
	bit 3,c			;4672	cb 59		. Y
	jr nz,l4678h		;4674	20 02		  .
	neg			;4676	ed 44		. D
l4678h:
	add a,b			;4678	80		.
	rrca			;4679	0f		.
	rrca			;467a	0f		.
	and 03eh		;467b	e6 3e		. >
l467dh:
	ld hl,l3c84h		;467d	21 84 3c	! . <
	rst 8			;4680	cf		.
	ld (iy+031h),a		;4681	fd 77 31	. w 1
	inc hl			;4684	23		#
	ld a,(hl)		;4685	7e		~
	ld (iy+000h),a		;4686	fd 77 00	. w .
	ld a,b			;4689	78		x
	add a,0c0h		;468a	c6 c0		. .
	and 080h		;468c	e6 80		. .
	ld (ix+002h),a		;468e	dd 77 02	. w .
	call sub_46bah		;4691	cd ba 46	. . F
	ld a,(ix+004h)		;4694	dd 7e 04	. ~ .
	cp 006h			;4697	fe 06		. .
	jr nc,l469fh		;4699	30 04		0 .
	ld (ix+004h),005h	;469b	dd 36 04 05	. 6 . .
l469fh:
	ld (ix+000h),0ffh	;469f	dd 36 00 ff	. 6 . .
	jp l57f7h		;46a3	c3 f7 57	. . W
	ld a,(0a980h)		;46a6	3a 80 a9	: . .
	ld c,a			;46a9	4f		O
	and 01ch		;46aa	e6 1c		. .
	bit 0,c			;46ac	cb 41		. A
	jr nz,l46b2h		;46ae	20 02		  .
	neg			;46b0	ed 44		. D
l46b2h:
	add a,b			;46b2	80		.
	rrca			;46b3	0f		.
	rrca			;46b4	0f		.
	and 03eh		;46b5	e6 3e		. >
	jp l467dh		;46b7	c3 7d 46	. } F
sub_46bah:
	ld hl,l46ceh		;46ba	21 ce 46	! . F
	push hl			;46bd	e5		.
	ld a,(0ad04h)		;46be	3a 04 ad	: . .
	and 007h		;46c1	e6 07		. .
	rst 30h			;46c3	f7		.
	ld b,d			;46c4	42		B
	ld e,c			;46c5	59		Y
	ld c,(hl)		;46c6	4e		N
	ld e,c			;46c7	59		Y
	ld c,(hl)		;46c8	4e		N
	ld e,c			;46c9	59		Y
	ld h,l			;46ca	65		e
	ld e,c			;46cb	59		Y
	ld l,e			;46cc	6b		k
	ld e,c			;46cd	59		Y
l46ceh:
	ld (ix+00ch),d		;46ce	dd 72 0c	. r .
	ld (ix+00dh),e		;46d1	dd 73 0d	. s .
	ld (ix+01ch),b		;46d4	dd 70 1c	. p .
	ld (ix+01dh),c		;46d7	dd 71 1d	. q .
	ret			;46da	c9		.
l46dbh:
	xor a			;46db	af		.
	ld (ix+000h),a		;46dc	dd 77 00	. w .
	ld (iy+000h),a		;46df	fd 77 00	. w .
	ld (iy+002h),a		;46e2	fd 77 02	. w .
	ld (iy+031h),a		;46e5	fd 77 31	. w 1
	ld (iy+033h),a		;46e8	fd 77 33	. w 3
	ld (ix+00eh),05fh	;46eb	dd 36 0e 5f	. 6 . _
	ret			;46ef	c9		.
l46f0h:
	ld a,(ix+000h)		;46f0	dd 7e 00	. ~ .
	inc a			;46f3	3c		<
	ret nz			;46f4	c0		.
	ld a,(0a817h)		;46f5	3a 17 a8	: . .
	and a			;46f8	a7		.
	ret nz			;46f9	c0		.
	ld b,002h		;46fa	06 02		. .
	ld a,(0a827h)		;46fc	3a 27 a8	: ' .
	ld d,a			;46ff	57		W
	add a,a			;4700	87		.
	ld e,a			;4701	5f		_
l4702h:
	ld a,(iy+000h)		;4702	fd 7e 00	. ~ .
	add a,008h		;4705	c6 08		. .
	cp 028h			;4707	fe 28		. (
	jr c,l4726h		;4709	38 1b		8 .
	ld a,(iy+031h)		;470b	fd 7e 31	. ~ 1
	add a,010h		;470e	c6 10		. .
	cp 020h			;4710	fe 20		.  
	jr c,l4726h		;4712	38 12		8 .
	ld a,084h		;4714	3e 84		> .
	sub (iy+000h)		;4716	fd 96 00	. . .
	add a,d			;4719	82		.
	cp e			;471a	bb		.
	jr nc,l4734h		;471b	30 17		0 .
	ld a,078h		;471d	3e 78		> x
	sub (iy+031h)		;471f	fd 96 31	. . 1
	add a,d			;4722	82		.
	cp e			;4723	bb		.
	jr nc,l4734h		;4724	30 0e		0 .
l4726h:
	exx			;4726	d9		.
	ld de,l0010h		;4727	11 10 00	. . .
	add ix,de		;472a	dd 19		. .
	inc iy			;472c	fd 23		. #
	inc iy			;472e	fd 23		. #
	exx			;4730	d9		.
	djnz l4702h		;4731	10 cf		. .
	ret			;4733	c9		.
l4734h:
	ld hl,0a830h		;4734	21 30 a8	! 0 .
	exx			;4737	d9		.
	ld hl,0aa16h		;4738	21 16 aa	! . .
	ld b,002h		;473b	06 02		. .
l473dh:
	exx			;473d	d9		.
	ld a,(hl)		;473e	7e		~
	and a			;473f	a7		.
	jr z,l474ch		;4740	28 0a		( .
	ld de,l0010h		;4742	11 10 00	. . .
	add hl,de		;4745	19		.
	exx			;4746	d9		.
	inc hl			;4747	23		#
	inc hl			;4748	23		#
	djnz l473dh		;4749	10 f2		. .
	ret			;474b	c9		.
l474ch:
	ld (0a991h),hl		;474c	22 91 a9	" . .
	exx			;474f	d9		.
	ld (0a993h),hl		;4750	22 93 a9	" . .
	call sub_565fh		;4753	cd 5f 56	. _ V
	ld hl,0ac7fh		;4756	21 7f ac	! . .
	call sub_33b8h		;4759	cd b8 33	. . 3
	ld h,a			;475c	67		g
	ex de,hl		;475d	eb		.
	ld hl,0a8b4h		;475e	21 b4 a8	! . .
	inc (hl)		;4761	34		4
	ld a,018h		;4762	3e 18		> .
	bit 0,(hl)		;4764	cb 46		. F
	jr nz,l476ah		;4766	20 02		  .
	neg			;4768	ed 44		. D
l476ah:
	ex de,hl		;476a	eb		.
	add a,h			;476b	84		.
	ld b,(iy+031h)		;476c	fd 46 31	. F 1
	ld c,(iy+000h)		;476f	fd 4e 00	. N .
	ld ix,(0a991h)		;4772	dd 2a 91 a9	. * . .
	ld iy,(0a993h)		;4776	fd 2a 93 a9	. * . .
	ld (ix+002h),a		;477a	dd 77 02	. w .
	ld (iy+031h),b		;477d	fd 70 31	. p 1
	ld (iy+000h),c		;4780	fd 71 00	. q .
	ld hl,l4795h		;4783	21 95 47	! . G
	push hl			;4786	e5		.
	ld a,(0ad04h)		;4787	3a 04 ad	: . .
	rst 30h			;478a	f7		.
	adc a,(hl)		;478b	8e		.
	ld e,c			;478c	59		Y
	adc a,(hl)		;478d	8e		.
	ld e,c			;478e	59		Y
	sub h			;478f	94		.
	ld e,c			;4790	59		Y
	sub h			;4791	94		.
	ld e,c			;4792	59		Y
	sub h			;4793	94		.
	ld e,c			;4794	59		Y
l4795h:
	ld (ix+00ah),e		;4795	dd 73 0a	. s .
	ld (ix+00bh),d		;4798	dd 72 0b	. r .
	ld (ix+00ch),c		;479b	dd 71 0c	. q .
	ld (ix+00dh),b		;479e	dd 70 0d	. p .
	ld (iy+001h),04dh	;47a1	fd 36 01 4d	. 6 . M
	ld (iy+030h),062h	;47a5	fd 36 30 62	. 6 0 b
	dec (ix+000h)		;47a9	dd 35 00	. 5 .
	ld a,(0a814h)		;47ac	3a 14 a8	: . .
	ld (0a817h),a		;47af	32 17 a8	2 . .
	ret			;47b2	c9		.
sub_47b3h:
	ld a,(0ad04h)		;47b3	3a 04 ad	: . .
	cp 004h			;47b6	fe 04		. .
	ret z			;47b8	c8		.
	ld ix,0a8f0h		;47b9	dd 21 f0 a8	. ! . .
	ld iy,0aa2eh		;47bd	fd 21 2e aa	. ! . .
	ld a,(ix+000h)		;47c1	dd 7e 00	. ~ .
	and a			;47c4	a7		.
	jp z,04853h		;47c5	ca 53 48	. S H
	inc a			;47c8	3c		<
	jp nz,047f2h		;47c9	c2 f2 47	. . G
	call sub_3e05h		;47cc	cd 05 3e	. . >
	call sub_2b83h		;47cf	cd 83 2b	. . +
	jp c,048adh		;47d2	da ad 48	. . H
	ld a,(0a980h)		;47d5	3a 80 a9	: . .
	rrca			;47d8	0f		.
	rrca			;47d9	0f		.
	rrca			;47da	0f		.
	rrca			;47db	0f		.
	and 007h		;47dc	e6 07		. .
	ld hl,l47eah		;47de	21 ea 47	! . G
	rst 8			;47e1	cf		.
	ld (iy+001h),a		;47e2	fd 77 01	. w .
	ld (iy+030h),075h	;47e5	fd 36 30 75	. 6 0 u
	ret			;47e9	c9		.
l47eah:
	nop			;47ea	00		.
	ld bc,00302h		;47eb	01 02 03	. . .
	inc bc			;47ee	03		.
	ld (bc),a		;47ef	02		.
	ld bc,0cd00h		;47f0	01 00 cd	. . .
	ld h,b			;47f3	60		`
	dec hl			;47f4	2b		+
	ld a,(ix+000h)		;47f5	dd 7e 00	. ~ .
	cp 010h			;47f8	fe 10		. .
	jp z,l4831h		;47fa	ca 31 48	. 1 H
	cp 03ch			;47fd	fe 3c		. <
	jp nc,l4809h		;47ff	d2 09 48	. . H
	dec (ix+000h)		;4802	dd 35 00	. 5 .
	ret nz			;4805	c0		.
	jp 048adh		;4806	c3 ad 48	. . H
l4809h:
	ld (ix+000h),03bh	;4809	dd 36 00 3b	. 6 . ;
	call sub_57ffh		;480d	cd ff 57	. . W
	ld a,(ix+007h)		;4810	dd 7e 07	. ~ .
	cp 004h			;4813	fe 04		. .
	jp nc,l4824h		;4815	d2 24 48	. $ H
	ld hl,l482dh		;4818	21 2d 48	! - H
	rst 8			;481b	cf		.
	ld (iy+001h),a		;481c	fd 77 01	. w .
	ld (iy+030h),06ch	;481f	fd 36 30 6c	. 6 0 l
	ret			;4823	c9		.
l4824h:
	ld (iy+001h),08fh	;4824	fd 36 01 8f	. 6 . .
l4828h:
	ld (iy+030h),06ch	;4828	fd 36 30 6c	. 6 0 l
	ret			;482c	c9		.
l482dh:
	ld sp,hl		;482d	f9		.
	call m,08e8dh		;482e	fc 8d 8e	. . .
l4831h:
	dec (ix+000h)		;4831	dd 35 00	. 5 .
	ld a,(ix+007h)		;4834	dd 7e 07	. ~ .
	inc (ix+007h)		;4837	dd 34 07	. 4 .
	cp 004h			;483a	fe 04		. .
	jp nc,l4849h		;483c	d2 49 48	. I H
	ld hl,l484fh		;483f	21 4f 48	! O H
	rst 18h			;4842	df		.
	ld e,(hl)		;4843	5e		^
	ld d,004h		;4844	16 04		. .
	jp l0038h		;4846	c3 38 00	. 8 .
l4849h:
	ld de,0040fh		;4849	11 0f 04	. . .
	jp l0038h		;484c	c3 38 00	. 8 .
l484fh:
	ld a,(bc)		;484f	0a		.
	inc c			;4850	0c		.
	dec c			;4851	0d		.
	ld c,03ah		;4852	0e 3a		. :
	dec c			;4854	0d		.
	xor l			;4855	ad		.
	and a			;4856	a7		.
	ret nz			;4857	c0		.
	ld a,(0a980h)		;4858	3a 80 a9	: . .
	and 001h		;485b	e6 01		. .
	ret z			;485d	c8		.
	dec (ix+00eh)		;485e	dd 35 0e	. 5 .
	ret nz			;4861	c0		.
	ld a,(0a802h)		;4862	3a 02 a8	: . .
	add a,008h		;4865	c6 08		. .
	rrca			;4867	0f		.
	rrca			;4868	0f		.
	rrca			;4869	0f		.
l486ah:
	and 01eh		;486a	e6 1e		. .
	ld hl,l488dh		;486c	21 8d 48	! . H
	rst 8			;486f	cf		.
	ld (iy+031h),a		;4870	fd 77 31	. w 1
	inc hl			;4873	23		#
	ld a,(hl)		;4874	7e		~
	ld (iy+000h),a		;4875	fd 77 00	. w .
	ld (ix+00ah),000h	;4878	dd 36 0a 00	. 6 . .
	ld (ix+00bh),000h	;487c	dd 36 0b 00	. 6 . .
l4880h:
	ld (ix+00ch),040h	;4880	dd 36 0c 40	. 6 . @
	ld (ix+00dh),000h	;4884	dd 36 0d 00	. 6 . .
	ld (ix+000h),0ffh	;4888	dd 36 00 ff	. 6 . .
	ret			;488c	c9		.
l488dh:
	ret p			;488d	f0		.
	ld b,b			;488e	40		@
	ret p			;488f	f0		.
	add a,b			;4890	80		.
	ret p			;4891	f0		.
	ret m			;4892	f8		.
l4893h:
	ld h,b			;4893	60		`
	ret m			;4894	f8		.
	add a,b			;4895	80		.
	ret m			;4896	f8		.
	and b			;4897	a0		.
	ret m			;4898	f8		.
	djnz l4893h		;4899	10 f8		. .
	nop			;489b	00		.
l489ch:
	add a,b			;489c	80		.
	nop			;489d	00		.
	sub b			;489e	90		.
	djnz l48b1h		;489f	10 10		. .
	jr nc,$+18		;48a1	30 10		0 .
	ld h,b			;48a3	60		`
	djnz $-126		;48a4	10 80		. .
	djnz $-94		;48a6	10 a0		. .
	djnz l486ah		;48a8	10 c0		. .
	djnz l489ch		;48aa	10 f0		. .
	jr z,$-33		;48ac	28 dd		( .
	ld (hl),000h		;48ae	36 00		6 .
	nop			;48b0	00		.
l48b1h:
	ld (iy+000h),000h	;48b1	fd 36 00 00	. 6 . .
	ld (iy+031h),000h	;48b5	fd 36 31 00	. 6 1 .
	ld (ix+00eh),0f0h	;48b9	dd 36 0e f0	. 6 . .
	ret			;48bd	c9		.
sub_48beh:
	call sub_48e7h		;48be	cd e7 48	. . H
	call sub_4941h		;48c1	cd 41 49	. A I
	call sub_4911h		;48c4	cd 11 49	. . I
	call sub_4984h		;48c7	cd 84 49	. . I
	call sub_49d6h		;48ca	cd d6 49	. . I
	ret			;48cd	c9		.
	inc l			;48ce	2c		,
	and a			;48cf	a7		.
	inc de			;48d0	13		.
	defb 0fdh,03bh,088h ;illegal sequence	;48d1	fd 3b 88	. ; .
	dec c			;48d4	0d		.
	call c,0bff1h		;48d5	dc f1 bf	. . .
	ld l,b			;48d8	68		h
	dec c			;48d9	0d		.
	rst 10h			;48da	d7		.
	pop af			;48db	f1		.
	defb 0fdh,03bh,0fdh ;illegal sequence	;48dc	fd 3b fd	. ; .
	call c,0a5fdh		;48df	dc fd a5	. . .
	ld d,a			;48e2	57		W
	defb 0edh ;next byte illegal after ed	;48e3	ed		.
	pop af			;48e4	f1		.
	ld d,d			;48e5	52		R
	cp c			;48e6	b9		.
sub_48e7h:
	ld a,(0a9aeh)		;48e7	3a ae a9	: . .
	rrca			;48ea	0f		.
	rrca			;48eb	0f		.
	rrca			;48ec	0f		.
	ld hl,0a983h		;48ed	21 83 a9	! . .
	rl (hl)			;48f0	cb 16		. .
	ld a,(hl)		;48f2	7e		~
	and 007h		;48f3	e6 07		. .
	cp 001h			;48f5	fe 01		. .
	ret nz			;48f7	c0		.
	call sub_57f1h		;48f8	cd f1 57	. . W
	ld c,001h		;48fb	0e 01		. .
	jp l496eh		;48fd	c3 6e 49	. n I
	cp h			;4900	bc		.
l4901h:
	and (hl)		;4901	a6		.
l4902h:
	dec b			;4902	05		.
l4903h:
	jr nc,$-13		;4903	30 f1		0 .
	ld a,h			;4905	7c		|
	ld l,b			;4906	68		h
	dec sp			;4907	3b		;
l4908h:
	and l			;4908	a5		.
	jr c,l4908h		;4909	38 fd		8 .
	pop af			;490b	f1		.
	sub (hl)		;490c	96		.
	ld e,l			;490d	5d		]
	rla			;490e	17		.
	sbc a,e			;490f	9b		.
	cp c			;4910	b9		.
sub_4911h:
	ld a,(0a9aeh)		;4911	3a ae a9	: . .
	ld hl,0a9cah		;4914	21 ca a9	! . .
	rrca			;4917	0f		.
	rrca			;4918	0f		.
	rl (hl)			;4919	cb 16		. .
	ld a,(hl)		;491b	7e		~
	and 007h		;491c	e6 07		. .
	cp 001h			;491e	fe 01		. .
	ret nz			;4920	c0		.
	ex de,hl		;4921	eb		.
	call sub_57f1h		;4922	cd f1 57	. . W
	ld hl,0a982h		;4925	21 82 a9	! . .
	inc (hl)		;4928	34		4
	ex de,hl		;4929	eb		.
	inc hl			;492a	23		#
	ld a,(hl)		;492b	7e		~
	add a,010h		;492c	c6 10		. .
	ld (hl),a		;492e	77		w
	ld b,a			;492f	47		G
	inc hl			;4930	23		#
	ld a,(hl)		;4931	7e		~
	sub b			;4932	90		.
	ret nc			;4933	d0		.
	ld a,(hl)		;4934	7e		~
	ld c,a			;4935	4f		O
	and 0f0h		;4936	e6 f0		. .
	add a,010h		;4938	c6 10		. .
	dec hl			;493a	2b		+
	neg			;493b	ed 44		. D
	add a,(hl)		;493d	86		.
	ld (hl),a		;493e	77		w
	jr l496eh		;493f	18 2d		. -
sub_4941h:
	ld a,(0a9aeh)		;4941	3a ae a9	: . .
	ld hl,0a9c7h		;4944	21 c7 a9	! . .
	rrca			;4947	0f		.
	rl (hl)			;4948	cb 16		. .
	ld a,(hl)		;494a	7e		~
	and 007h		;494b	e6 07		. .
	cp 001h			;494d	fe 01		. .
	ret nz			;494f	c0		.
	ex de,hl		;4950	eb		.
	call sub_57f1h		;4951	cd f1 57	. . W
	ld hl,0a981h		;4954	21 81 a9	! . .
	inc (hl)		;4957	34		4
	ex de,hl		;4958	eb		.
	inc hl			;4959	23		#
	ld a,(hl)		;495a	7e		~
	add a,010h		;495b	c6 10		. .
	ld (hl),a		;495d	77		w
	ld b,a			;495e	47		G
	inc hl			;495f	23		#
	ld a,(hl)		;4960	7e		~
	sub b			;4961	90		.
	ret nc			;4962	d0		.
	ld a,(hl)		;4963	7e		~
	ld c,a			;4964	4f		O
	and 0f0h		;4965	e6 f0		. .
	add a,010h		;4967	c6 10		. .
	dec hl			;4969	2b		+
	neg			;496a	ed 44		. D
	add a,(hl)		;496c	86		.
	ld (hl),a		;496d	77		w
l496eh:
	ld a,(0a9c0h)		;496e	3a c0 a9	: . .
	and a			;4971	a7		.
	jr nz,sub_4984h		;4972	20 10		  .
	ld a,c			;4974	79		y
	and 00fh		;4975	e6 0f		. .
	ld hl,0a986h		;4977	21 86 a9	! . .
	add a,(hl)		;497a	86		.
	daa			;497b	27		'
	ld (hl),a		;497c	77		w
	jr nc,l4981h		;497d	30 02		0 .
	ld (hl),099h		;497f	36 99		6 .
l4981h:
	call sub_4afbh		;4981	cd fb 4a	. . J
sub_4984h:
	ld a,(0a981h)		;4984	3a 81 a9	: . .
	and a			;4987	a7		.
	ret z			;4988	c8		.
	ld hl,0a984h		;4989	21 84 a9	! . .
	ld a,(hl)		;498c	7e		~
	and a			;498d	a7		.
	jr nz,l4997h		;498e	20 07		  .
	ld (hl),030h		;4990	36 30		6 0
	inc a			;4992	3c		<
	ld (LATCH_COIN_COUNTER_1),a	;4993	32 0a c3	2 . .
	ret			;4996	c9		.
l4997h:
	dec (hl)		;4997	35		5
	jr z,l49a3h		;4998	28 09		( .
	ld a,(hl)		;499a	7e		~
	cp 018h			;499b	fe 18		. .
	ret nz			;499d	c0		.
	xor a			;499e	af		.
	ld (LATCH_COIN_COUNTER_1),a	;499f	32 0a c3	2 . .
	ret			;49a2	c9		.
l49a3h:
	ld hl,0a981h		;49a3	21 81 a9	! . .
	dec (hl)		;49a6	35		5
	ret			;49a7	c9		.
l49a8h:
	rrca			;49a8	0f		.
	ld c,a			;49a9	4f		O
	and 007h		;49aa	e6 07		. .
	ld (0a9c4h),a		;49ac	32 c4 a9	2 . .
	ld a,c			;49af	79		y
	rrca			;49b0	0f		.
	rrca			;49b1	0f		.
	rrca			;49b2	0f		.
	and 001h		;49b3	e6 01		. .
	ld (0a9c6h),a		;49b5	32 c6 a9	2 . .
	ld (DSW2_READ_WATCHDOG_WRITE),a	;49b8	32 00 c2	2 . .
	ld a,(00c3eh)		;49bb	3a 3e 0c	: > .
	ld (LATCH_FLIP_SCREEN),a	;49be	32 02 c3	2 . .
	call sub_00b1h		;49c1	cd b1 00	. . .
	ld b,000h		;49c4	06 00		. .
	ld hl,027deh		;49c6	21 de 27	! . '
	xor a			;49c9	af		.
l49cah:
	add a,(hl)		;49ca	86		.
	inc hl			;49cb	23		#
	djnz l49cah		;49cc	10 fc		. .
	sub 0c5h		;49ce	d6 c5		. .
	call nz,l00d8h		;49d0	c4 d8 00	. . .
	jp l32ebh		;49d3	c3 eb 32	. . 2
sub_49d6h:
	ld a,(0a982h)		;49d6	3a 82 a9	: . .
	and a			;49d9	a7		.
	ret z			;49da	c8		.
	ld hl,0a985h		;49db	21 85 a9	! . .
	ld a,(hl)		;49de	7e		~
	and a			;49df	a7		.
	jr nz,l49e9h		;49e0	20 07		  .
	ld (hl),030h		;49e2	36 30		6 0
	inc a			;49e4	3c		<
	ld (LATCH_COIN_COUNTER_2),a	;49e5	32 0c c3	2 . .
	ret			;49e8	c9		.
l49e9h:
	dec (hl)		;49e9	35		5
	jr z,l49f5h		;49ea	28 09		( .
	ld a,(hl)		;49ec	7e		~
	cp 018h			;49ed	fe 18		. .
	ret nz			;49ef	c0		.
	xor a			;49f0	af		.
	ld (LATCH_COIN_COUNTER_2),a	;49f1	32 0c c3	2 . .
	ret			;49f4	c9		.
l49f5h:
	ld hl,0a982h		;49f5	21 82 a9	! . .
	dec (hl)		;49f8	35		5
	ret			;49f9	c9		.
l49fah:
	xor 0a6h		;49fa	ee a6		. .
	inc d			;49fc	14		.
	and l			;49fd	a5		.
	dec sp			;49fe	3b		;
	add a,a			;49ff	87		.
	pop af			;4a00	f1		.
	call c,0bfd7h		;4a01	dc d7 bf	. . .
	pop af			;4a04	f1		.
	call c,0fdc4h		;4a05	dc c4 fd	. . .
	defb 0edh ;next byte illegal after ed	;4a08	ed		.
	pop af			;4a09	f1		.
	ld a,l			;4a0a	7d		}
	and l			;4a0b	a5		.
	jr c,l4a42h		;4a0c	38 34		8 4
	cp c			;4a0e	b9		.
	ld a,(03213h)		;4a0f	3a 13 32	: . 2
	ld (0a9f0h),a		;4a12	32 f0 a9	2 . .
	ld a,000h		;4a15	3e 00		> .
	ld (0a9f1h),a		;4a17	32 f1 a9	2 . .
	ld a,0ffh		;4a1a	3e ff		> .
	ld (0a9f2h),a		;4a1c	32 f2 a9	2 . .
	ld a,004h		;4a1f	3e 04		> .
	ld (0a9f3h),a		;4a21	32 f3 a9	2 . .
	ld a,0ffh		;4a24	3e ff		> .
	ld (0a9f4h),a		;4a26	32 f4 a9	2 . .
	ld a,008h		;4a29	3e 08		> .
	ld (0a9f6h),a		;4a2b	32 f6 a9	2 . .
	ld hl,l56f1h		;4a2e	21 f1 56	! . V
	ld (0a9f7h),hl		;4a31	22 f7 a9	" . .
	ld b,00dh		;4a34	06 0d		. .
	ld hl,VIDEO_RAM		;4a36	21 00 a4	! . .
	ld c,014h		;4a39	0e 14		. .
l4a3bh:
	ld (hl),c		;4a3b	71		q
	inc hl			;4a3c	23		#
	djnz l4a3bh		;4a3d	10 fc		. .
	ld a,000h		;4a3f	3e 00		> .
	ld (hl),a		;4a41	77		w
l4a42h:
	inc hl			;4a42	23		#
	ld (hl),a		;4a43	77		w
	inc hl			;4a44	23		#
	ld b,00dh		;4a45	06 0d		. .
l4a47h:
	ld (hl),c		;4a47	71		q
	inc hl			;4a48	23		#
	djnz l4a47h		;4a49	10 fc		. .
	ld a,00eh		;4a4b	3e 0e		> .
	ld b,004h		;4a4d	06 04		. .
l4a4fh:
	ld (hl),a		;4a4f	77		w
	inc hl			;4a50	23		#
	djnz l4a4fh		;4a51	10 fc		. .
	ld hl,0a7b1h		;4a53	21 b1 a7	! . .
	res 2,h			;4a56	cb 94		. .
	ld a,(0ad0ch)		;4a58	3a 0c ad	: . .
	ld c,a			;4a5b	4f		O
	ld a,0a0h		;4a5c	3e a0		> .
	add a,c			;4a5e	81		.
	call sub_1319h		;4a5f	cd 19 13	. . .
	ld hl,0a5d1h		;4a62	21 d1 a5	! . .
	res 2,h			;4a65	cb 94		. .
	ld a,020h		;4a67	3e 20		>  
	add a,c			;4a69	81		.
	call sub_1319h		;4a6a	cd 19 13	. . .
	ld hl,0a610h		;4a6d	21 10 a6	! . .
	res 2,h			;4a70	cb 94		. .
	ld a,0a0h		;4a72	3e a0		> .
	add a,c			;4a74	81		.
	ld (hl),a		;4a75	77		w
	add hl,de		;4a76	19		.
	ld a,020h		;4a77	3e 20		>  
	add a,c			;4a79	81		.
	ld (hl),a		;4a7a	77		w
	ld hl,0a612h		;4a7b	21 12 a6	! . .
	res 2,h			;4a7e	cb 94		. .
	ld a,0e0h		;4a80	3e e0		> .
	add a,c			;4a82	81		.
	ld (hl),a		;4a83	77		w
	add hl,de		;4a84	19		.
	ld a,060h		;4a85	3e 60		> `
	add a,c			;4a87	81		.
	ld (hl),a		;4a88	77		w
	ld hl,0a611h		;4a89	21 11 a6	! . .
	res 2,h			;4a8c	cb 94		. .
	ld a,0a0h		;4a8e	3e a0		> .
	add a,c			;4a90	81		.
	ld (hl),a		;4a91	77		w
	add hl,de		;4a92	19		.
	ld a,020h		;4a93	3e 20		>  
	add a,c			;4a95	81		.
	ld (hl),a		;4a96	77		w
	call sub_339ch		;4a97	cd 9c 33	. . 3
	jp sub_0f1ah		;4a9a	c3 1a 0f	. . .
sub_4a9dh:
	ld b,00dh		;4a9d	06 0d		. .
	ld hl,(0a9f7h)		;4a9f	2a f7 a9	* . .
l4aa2h:
	ld a,(hl)		;4aa2	7e		~
	and a			;4aa3	a7		.
	ex de,hl		;4aa4	eb		.
	jr z,l4ab0h		;4aa5	28 09		( .
	ld a,(hl)		;4aa7	7e		~
	inc a			;4aa8	3c		<
	bit 0,c			;4aa9	cb 41		. A
	jr z,l4aafh		;4aab	28 02		( .
	dec a			;4aad	3d		=
	dec a			;4aae	3d		=
l4aafh:
	ld (hl),a		;4aaf	77		w
l4ab0h:
	bit 1,c			;4ab0	cb 49		. I
	ld de,l0020h		;4ab2	11 20 00	.   .
	jr z,l4abah		;4ab5	28 03		( .
	ld de,0ffe0h		;4ab7	11 e0 ff	. . .
l4abah:
	add hl,de		;4aba	19		.
	ex de,hl		;4abb	eb		.
	ld hl,(0a9f7h)		;4abc	2a f7 a9	* . .
	inc hl			;4abf	23		#
	bit 0,c			;4ac0	cb 41		. A
	jr z,l4ac6h		;4ac2	28 02		( .
	dec hl			;4ac4	2b		+
	dec hl			;4ac5	2b		+
l4ac6h:
	ld (0a9f7h),hl		;4ac6	22 f7 a9	" . .
	djnz l4aa2h		;4ac9	10 d7		. .
	ret			;4acb	c9		.
sub_4acch:
	ld a,(0a9b1h)		;4acc	3a b1 a9	: . .
	and 00fh		;4acf	e6 0f		. .
	cp 00fh			;4ad1	fe 0f		. .
	jr nz,l4adah		;4ad3	20 05		  .
	ld hl,0a9c0h		;4ad5	21 c0 a9	! . .
	ld (hl),0ffh		;4ad8	36 ff		6 .
l4adah:
	ld hl,l4b95h		;4ada	21 95 4b	! . K
	rst 8			;4add	cf		.
	ld (0a9c9h),a		;4ade	32 c9 a9	2 . .
	ld a,(0a9b1h)		;4ae1	3a b1 a9	: . .
	rrca			;4ae4	0f		.
	rrca			;4ae5	0f		.
	rrca			;4ae6	0f		.
	rrca			;4ae7	0f		.
	and 00fh		;4ae8	e6 0f		. .
	cp 00fh			;4aea	fe 0f		. .
	jr nz,l4af3h		;4aec	20 05		  .
	ld hl,0a9c0h		;4aee	21 c0 a9	! . .
	ld (hl),0ffh		;4af1	36 ff		6 .
l4af3h:
	ld hl,l4b95h		;4af3	21 95 4b	! . K
	rst 8			;4af6	cf		.
	ld (0a9cch),a		;4af7	32 cc a9	2 . .
	ret			;4afa	c9		.
sub_4afbh:
	ld c,010h		;4afb	0e 10		. .
	ld de,0a47fh		;4afd	11 7f a4	. . .
	ld hl,0a986h		;4b00	21 86 a9	! . .
	call sub_0d81h		;4b03	cd 81 0d	. . .
	ret			;4b06	c9		.
	ld hl,(0ab41h)		;4b07	2a 41 ab	* A .
	ld a,l			;4b0a	7d		}
	xor h			;4b0b	ac		.
	cpl			;4b0c	2f		/
	add a,a			;4b0d	87		.
	add a,a			;4b0e	87		.
	adc hl,hl		;4b0f	ed 6a		. j
	ld (0ab41h),hl		;4b11	22 41 ab	" A .
	ld a,r			;4b14	ed 5f		. _
	add a,l			;4b16	85		.
	xor h			;4b17	ac		.
	ret			;4b18	c9		.
	ld de,00bcch		;4b19	11 cc 0b	. . .
	ld bc,l0089h		;4b1c	01 89 00	. . .
	ld a,(l1a50h)		;4b1f	3a 50 1a	: P .
	ld h,a			;4b22	67		g
l4b23h:
	ld a,(de)		;4b23	1a		.
	add a,c			;4b24	81		.
	ld c,a			;4b25	4f		O
	inc de			;4b26	13		.
	djnz l4b23h		;4b27	10 fa		. .
	sub h			;4b29	94		.
	call nz,sub_0f11h	;4b2a	c4 11 0f	. . .
	jp sub_0f1ah		;4b2d	c3 1a 0f	. . .
sub_4b30h:
	ld hl,l0d1bh		;4b30	21 1b 0d	! . .
	ld b,003h		;4b33	06 03		. .
l4b35h:
	ld e,(hl)		;4b35	5e		^
	inc hl			;4b36	23		#
	ld d,(hl)		;4b37	56		V
	inc hl			;4b38	23		#
	ld a,(de)		;4b39	1a		.
	ex af,af'		;4b3a	08		.
	ld a,004h		;4b3b	3e 04		> .
	add a,d			;4b3d	82		.
	ld d,a			;4b3e	57		W
	ld a,(de)		;4b3f	1a		.
	ld e,(hl)		;4b40	5e		^
	inc hl			;4b41	23		#
	ld d,(hl)		;4b42	56		V
	inc hl			;4b43	23		#
	ld (de),a		;4b44	12		.
	inc e			;4b45	1c		.
	ex af,af'		;4b46	08		.
	ld (de),a		;4b47	12		.
	djnz l4b35h		;4b48	10 eb		. .
	ret			;4b4a	c9		.
sub_4b4bh:
	exx			;4b4b	d9		.
	ld hl,0ab3fh		;4b4c	21 3f ab	! ? .
	ld de,0ab40h		;4b4f	11 40 ab	. @ .
l4b52h:
	ld bc,l0010h		;4b52	01 10 00	. . .
	lddr			;4b55	ed b8		. .
	ld hl,0ab40h		;4b57	21 40 ab	! @ .
	ld a,(0ab37h)		;4b5a	3a 37 ab	: 7 .
	xor (hl)		;4b5d	ae		.
	ld (0ab30h),a		;4b5e	32 30 ab	2 0 .
	ld hl,0a980h		;4b61	21 80 a9	! . .
	add a,(hl)		;4b64	86		.
	exx			;4b65	d9		.
	ret			;4b66	c9		.
sub_4b67h:
	ld hl,l4b84h		;4b67	21 84 4b	! . K
	ld de,0ab30h		;4b6a	11 30 ab	. 0 .
	ld bc,l0011h		;4b6d	01 11 00	. . .
	ldir			;4b70	ed b0		. .
	ld ix,(l086dh)		;4b72	dd 2a 6d 08	. * m .
	ld hl,(l0870h)		;4b76	2a 70 08	* p .
	defb 0ddh,07dh ;ld a,ixl	;4b79	dd 7d		. }
	defb 0ddh,084h ;add a,ixh	;4b7b	dd 84		. .
	add a,l			;4b7d	85		.
	add a,044h		;4b7e	c6 44		. D
	jp nz,06000h		;4b80	c2 00 60	. . `
	ret			;4b83	c9		.
l4b84h:
	rst 38h			;4b84	ff		.
	dec b			;4b85	05		.
	or 080h			;4b86	f6 80		. .
	ld (09c17h),a		;4b88	32 17 9c	2 . .
	ret			;4b8b	c9		.
	ld ix,09874h		;4b8c	dd 21 74 98	. ! t .
	defb 0fdh,0bfh,024h ;illegal sequence	;4b90	fd bf 24	. . $
	xor (hl)		;4b93	ae		.
	ld b,(hl)		;4b94	46		F
l4b95h:
	ld bc,00302h		;4b95	01 02 03	. . .
	inc b			;4b98	04		.
	dec b			;4b99	05		.
	ld b,007h		;4b9a	06 07		. .
	ld de,01513h		;4b9c	11 13 15	. . .
	ld hl,l2420h+2		;4b9f	21 22 24	! " $
	ld sp,l0133h		;4ba2	31 33 01	1 3 .
l4ba5h:
	ld hl,l4bb1h		;4ba5	21 b1 4b	! . K
	ld de,0ab08h		;4ba8	11 08 ab	. . .
	ld bc,l0028h		;4bab	01 28 00	. ( .
	ldir			;4bae	ed b0		. .
	ret			;4bb0	c9		.
l4bb1h:
	nop			;4bb1	00		.
	nop			;4bb2	00		.
	nop			;4bb3	00		.
	ld bc,0117ch		;4bb4	01 7c 11	. | .
	ld l,b			;4bb7	68		h
	pop af			;4bb8	f1		.
	ld bc,08800h		;4bb9	01 00 88	. . .
	nop			;4bbc	00		.
	dec sp			;4bbd	3b		;
	ld de,0f1a5h		;4bbe	11 a5 f1	. . .
	ld (bc),a		;4bc1	02		.
	ld h,b			;4bc2	60		`
	add a,h			;4bc3	84		.
	nop			;4bc4	00		.
	jr c,$+19		;4bc5	38 11		8 .
	defb 0fdh,0f1h,003h ;illegal sequence	;4bc7	fd f1 03	. . .
	jr nz,l4c31h		;4bca	20 65		  e
	nop			;4bcc	00		.
	ld l,b			;4bcd	68		h
	ld de,0f168h		;4bce	11 68 f1	. h .
	inc b			;4bd1	04		.
	nop			;4bd2	00		.
	ld b,e			;4bd3	43		C
	nop			;4bd4	00		.
	cp a			;4bd5	bf		.
	ld de,0f1a5h		;4bd6	11 a5 f1	. . .
sub_4bd9h:
	jp 008aeh		;4bd9	c3 ae 08	. . .
sub_4bdch:
	ld hl,0ab08h		;4bdc	21 08 ab	! . .
	ld de,0a711h		;4bdf	11 11 a7	. . .
	ld c,014h		;4be2	0e 14		. .
	call sub_4c1fh		;4be4	cd 1f 4c	. . L
	ld hl,0ab10h		;4be7	21 10 ab	! . .
	ld de,0a713h		;4bea	11 13 a7	. . .
	ld c,016h		;4bed	0e 16		. .
	call sub_4c1fh		;4bef	cd 1f 4c	. . L
	ld hl,0ab18h		;4bf2	21 18 ab	! . .
	ld de,0a715h		;4bf5	11 15 a7	. . .
	ld c,012h		;4bf8	0e 12		. .
	call sub_4c1fh		;4bfa	cd 1f 4c	. . L
	ld hl,0ab20h		;4bfd	21 20 ab	!   .
	ld de,0a717h		;4c00	11 17 a7	. . .
	ld c,015h		;4c03	0e 15		. .
	call sub_4c1fh		;4c05	cd 1f 4c	. . L
	ld hl,0ab28h		;4c08	21 28 ab	! ( .
	ld de,0a719h		;4c0b	11 19 a7	. . .
	ld c,013h		;4c0e	0e 13		. .
	call sub_4c1fh		;4c10	cd 1f 4c	. . L
	ret			;4c13	c9		.
	ld (hl),e		;4c14	73		s
	and (hl)		;4c15	a6		.
	inc d			;4c16	14		.
	ld a,(hl)		;4c17	7e		~
	add hl,hl		;4c18	29		)
	ret m			;4c19	f8		.
	sub (hl)		;4c1a	96		.
	ld e,l			;4c1b	5d		]
	di			;4c1c	f3		.
	inc de			;4c1d	13		.
	cp c			;4c1e	b9		.
sub_4c1fh:
	push hl			;4c1f	e5		.
	ld a,(hl)		;4c20	7e		~
	add a,a			;4c21	87		.
	add a,(hl)		;4c22	86		.
	ld hl,l4cb4h		;4c23	21 b4 4c	! . L
	rst 8			;4c26	cf		.
	ld (de),a		;4c27	12		.
l4c28h:
	res 2,d			;4c28	cb 92		. .
	ld a,c			;4c2a	79		y
	ld (de),a		;4c2b	12		.
	set 2,d			;4c2c	cb d2		. .
	inc hl			;4c2e	23		#
	rst 20h			;4c2f	e7		.
	ld a,(hl)		;4c30	7e		~
l4c31h:
	ld (de),a		;4c31	12		.
	res 2,d			;4c32	cb 92		. .
	ld a,c			;4c34	79		y
	ld (de),a		;4c35	12		.
	set 2,d			;4c36	cb d2		. .
	inc hl			;4c38	23		#
	rst 20h			;4c39	e7		.
	ld a,(hl)		;4c3a	7e		~
	ld (de),a		;4c3b	12		.
	res 2,d			;4c3c	cb 92		. .
	ld a,c			;4c3e	79		y
	ld (de),a		;4c3f	12		.
	set 2,d			;4c40	cb d2		. .
	ld hl,0ff80h		;4c42	21 80 ff	! . .
	add hl,de		;4c45	19		.
	ex de,hl		;4c46	eb		.
	pop hl			;4c47	e1		.
	inc hl			;4c48	23		#
	inc hl			;4c49	23		#
	inc hl			;4c4a	23		#
	call l0d73h		;4c4b	cd 73 0d	. s .
	push hl			;4c4e	e5		.
	ld hl,0ffa0h		;4c4f	21 a0 ff	! . .
	add hl,de		;4c52	19		.
	ex de,hl		;4c53	eb		.
	pop hl			;4c54	e1		.
	inc hl			;4c55	23		#
	inc hl			;4c56	23		#
	inc hl			;4c57	23		#
	ld a,(hl)		;4c58	7e		~
	ld (de),a		;4c59	12		.
	res 2,d			;4c5a	cb 92		. .
	ld a,c			;4c5c	79		y
	ld (de),a		;4c5d	12		.
	set 2,d			;4c5e	cb d2		. .
	inc hl			;4c60	23		#
	rst 20h			;4c61	e7		.
	ld a,(hl)		;4c62	7e		~
	ld (de),a		;4c63	12		.
	res 2,d			;4c64	cb 92		. .
	ld a,c			;4c66	79		y
	ld (de),a		;4c67	12		.
	set 2,d			;4c68	cb d2		. .
	inc hl			;4c6a	23		#
	rst 20h			;4c6b	e7		.
	ld a,(hl)		;4c6c	7e		~
	ld (de),a		;4c6d	12		.
	res 2,d			;4c6e	cb 92		. .
	ld a,c			;4c70	79		y
	ld (de),a		;4c71	12		.
	set 2,d			;4c72	cb d2		. .
	ret			;4c74	c9		.
sub_4c75h:
	call sub_07d2h		;4c75	cd d2 07	. . .
	ld a,(0ad32h)		;4c78	3a 32 ad	: 2 .
	and a			;4c7b	a7		.
	ld hl,0ad10h		;4c7c	21 10 ad	! . .
	jr z,l4c84h		;4c7f	28 03		( .
	ld hl,0ad20h		;4c81	21 20 ad	!   .
l4c84h:
	ld de,0ad00h		;4c84	11 00 ad	. . .
l4c87h:
	ld bc,l0010h		;4c87	01 10 00	. . .
	ldir			;4c8a	ed b0		. .
	ld a,(0ad30h)		;4c8c	3a 30 ad	: 0 .
	and a			;4c8f	a7		.
	jp z,sub_0f1ah		;4c90	ca 1a 0f	. . .
	ld a,(0ad01h)		;4c93	3a 01 ad	: . .
	ld d,006h		;4c96	16 06		. .
	ld e,a			;4c98	5f		_
l4c99h:
	rst 38h			;4c99	ff		.
	ld a,(0ad00h)		;4c9a	3a 00 ad	: . .
	dec a			;4c9d	3d		=
	ld d,005h		;4c9e	16 05		. .
	ld e,a			;4ca0	5f		_
	rst 38h			;4ca1	ff		.
	ld b,000h		;4ca2	06 00		. .
	ld hl,05b50h		;4ca4	21 50 5b	! P [
	sub a			;4ca7	97		.
l4ca8h:
	xor (hl)		;4ca8	ae		.
	inc hl			;4ca9	23		#
	djnz l4ca8h		;4caa	10 fc		. .
	add a,0ffh		;4cac	c6 ff		. .
	ld (LATCH_VIDEO_ENABLE),a	;4cae	32 08 c3	2 . .
	jp sub_0f1ah		;4cb1	c3 1a 0f	. . .
l4cb4h:
	sub (hl)		;4cb4	96		.
	defb 0edh ;next byte illegal after ed	;4cb5	ed		.
	call c,sub_3b9bh	;4cb6	dc 9b 3b	. . ;
	add a,a			;4cb9	87		.
	call 087d7h		;4cba	cd d7 87	. . .
	di			;4cbd	f3		.
	call c,07fc4h		;4cbe	dc c4 7f	. . .
	call c,sub_21c4h	;4cc1	dc c4 21	. . !
	dec bc			;4cc4	0b		.
	xor e			;4cc5	ab		.
	ld b,005h		;4cc6	06 05		. .
	ld a,(0ad32h)		;4cc8	3a 32 ad	: 2 .
	and a			;4ccb	a7		.
	ld de,0ad35h		;4ccc	11 35 ad	. 5 .
	jr z,l4cd4h		;4ccf	28 03		( .
	ld de,0ad38h		;4cd1	11 38 ad	. 8 .
l4cd4h:
	push hl			;4cd4	e5		.
	push de			;4cd5	d5		.
	call sub_4d2bh		;4cd6	cd 2b 4d	. + M
	jr nc,l4ce4h		;4cd9	30 09		0 .
	pop de			;4cdb	d1		.
	pop hl			;4cdc	e1		.
	ld a,008h		;4cdd	3e 08		> .
	rst 8			;4cdf	cf		.
	djnz l4cd4h		;4ce0	10 f2		. .
	scf			;4ce2	37		7
	ret			;4ce3	c9		.
l4ce4h:
	dec b			;4ce4	05		.
	jr z,l4d26h		;4ce5	28 3f		( ?
	ld hl,0ab27h		;4ce7	21 27 ab	! ' .
	ld de,0ab2fh		;4cea	11 2f ab	. / .
	ld a,b			;4ced	78		x
	add a,a			;4cee	87		.
	add a,a			;4cef	87		.
	add a,a			;4cf0	87		.
	ld c,a			;4cf1	4f		O
	ld b,000h		;4cf2	06 00		. .
	lddr			;4cf4	ed b8		. .
	ex de,hl		;4cf6	eb		.
l4cf7h:
	dec hl			;4cf7	2b		+
	ld (hl),0f1h		;4cf8	36 f1		6 .
	dec hl			;4cfa	2b		+
	ld (hl),0f1h		;4cfb	36 f1		6 .
	dec hl			;4cfd	2b		+
	ld (hl),0f1h		;4cfe	36 f1		6 .
	ld (0a991h),hl		;4d00	22 91 a9	" . .
	dec hl			;4d03	2b		+
	pop de			;4d04	d1		.
	ld bc,l0003h		;4d05	01 03 00	. . .
	ex de,hl		;4d08	eb		.
	lddr			;4d09	ed b8		. .
	ld a,(de)		;4d0b	1a		.
	pop hl			;4d0c	e1		.
	ld hl,0a531h		;4d0d	21 31 a5	! 1 .
	add a,a			;4d10	87		.
	rst 8			;4d11	cf		.
	ld (0a993h),hl		;4d12	22 93 a9	" . .
	ld hl,0ab08h		;4d15	21 08 ab	! . .
	ld de,l0008h		;4d18	11 08 00	. . .
	ld b,005h		;4d1b	06 05		. .
	xor a			;4d1d	af		.
l4d1eh:
	ld (hl),a		;4d1e	77		w
	add hl,de		;4d1f	19		.
	inc a			;4d20	3c		<
	djnz l4d1eh		;4d21	10 fb		. .
	scf			;4d23	37		7
	ccf			;4d24	3f		?
	ret			;4d25	c9		.
l4d26h:
	ld hl,0ab2fh		;4d26	21 2f ab	! / .
	jr l4cf7h		;4d29	18 cc		. .
sub_4d2bh:
	ld c,003h		;4d2b	0e 03		. .
l4d2dh:
	ld a,(de)		;4d2d	1a		.
	cp (hl)			;4d2e	be		.
	ret c			;4d2f	d8		.
	jr nz,l4d37h		;4d30	20 05		  .
	dec de			;4d32	1b		.
	dec hl			;4d33	2b		+
	dec c			;4d34	0d		.
	jr nz,l4d2dh		;4d35	20 f6		  .
l4d37h:
	scf			;4d37	37		7
	ccf			;4d38	3f		?
	ret			;4d39	c9		.
sub_4d3ah:
	ld hl,0ad05h		;4d3a	21 05 ad	! . .
	call sub_4d67h		;4d3d	cd 67 4d	. g M
	ret c			;4d40	d8		.
	inc l			;4d41	2c		,
	call sub_4d67h		;4d42	cd 67 4d	. g M
	jr c,l4d4bh		;4d45	38 04		8 .
	inc l			;4d47	2c		,
	call sub_4d67h		;4d48	cd 67 4d	. g M
l4d4bh:
	ld hl,0a9d7h		;4d4b	21 d7 a9	! . .
	ld a,(hl)		;4d4e	7e		~
	and a			;4d4f	a7		.
	ret z			;4d50	c8		.
	dec (hl)		;4d51	35		5
	ret nz			;4d52	c0		.
	ld a,(0a9d6h)		;4d53	3a d6 a9	: . .
	ld (hl),a		;4d56	77		w
	ld a,(0acc0h)		;4d57	3a c0 ac	: . .
	inc a			;4d5a	3c		<
	cp 010h			;4d5b	fe 10		. .
	jr c,l4d61h		;4d5d	38 02		8 .
	ld a,00fh		;4d5f	3e 0f		> .
l4d61h:
	ld (0acc0h),a		;4d61	32 c0 ac	2 . .
	jp l1a9ah		;4d64	c3 9a 1a	. . .
sub_4d67h:
	ld a,(hl)		;4d67	7e		~
	add a,001h		;4d68	c6 01		. .
	daa			;4d6a	27		'
	ld (hl),a		;4d6b	77		w
	cp 060h			;4d6c	fe 60		. `
	ret c			;4d6e	d8		.
	ld (hl),000h		;4d6f	36 00		6 .
	ret			;4d71	c9		.
	ld c,a			;4d72	4f		O
	ld a,(0ad30h)		;4d73	3a 30 ad	: 0 .
	and a			;4d76	a7		.
	ret z			;4d77	c8		.
	ld de,0a783h		;4d78	11 83 a7	. . .
	ld a,c			;4d7b	79		y
	cp 007h			;4d7c	fe 07		. .
	jr c,l4d82h		;4d7e	38 02		8 .
	ld a,006h		;4d80	3e 06		> .
l4d82h:
	and a			;4d82	a7		.
	jr z,l4d91h		;4d83	28 0c		( .
	ld b,009h		;4d85	06 09		. .
	ld c,018h		;4d87	0e 18		. .
l4d89h:
	ex af,af'		;4d89	08		.
	call sub_4dafh		;4d8a	cd af 4d	. . M
	ex af,af'		;4d8d	08		.
	dec a			;4d8e	3d		=
	jr nz,l4d89h		;4d8f	20 f8		  .
l4d91h:
	ld bc,0f110h		;4d91	01 10 f1	. . .
l4d94h:
	ld hl,l59ddh		;4d94	21 dd 59	! . Y
	add hl,de		;4d97	19		.
	jr nc,l4d9fh		;4d98	30 05		0 .
	call sub_4dcfh		;4d9a	cd cf 4d	. . M
	jr l4d94h		;4d9d	18 f5		. .
l4d9fh:
	ld b,000h		;4d9f	06 00		. .
	ld hl,l0711h		;4da1	21 11 07	! . .
	sub a			;4da4	97		.
l4da5h:
	xor (hl)		;4da5	ae		.
	inc hl			;4da6	23		#
	djnz l4da5h		;4da7	10 fc		. .
	add a,019h		;4da9	c6 19		. .
	jp nz,l4bb1h		;4dab	c2 b1 4b	. . K
	ret			;4dae	c9		.
sub_4dafh:
	ld a,b			;4daf	78		x
	add a,003h		;4db0	c6 03		. .
	ld (de),a		;4db2	12		.
	dec a			;4db3	3d		=
	dec de			;4db4	1b		.
	ld (de),a		;4db5	12		.
	rst 20h			;4db6	e7		.
	ld a,b			;4db7	78		x
	ld (de),a		;4db8	12		.
	inc a			;4db9	3c		<
	inc de			;4dba	13		.
	ld (de),a		;4dbb	12		.
	ld hl,0fc00h		;4dbc	21 00 fc	! . .
	add hl,de		;4dbf	19		.
	rst 20h			;4dc0	e7		.
	ld (hl),c		;4dc1	71		q
	dec hl			;4dc2	2b		+
	ld (hl),c		;4dc3	71		q
	ld a,l			;4dc4	7d		}
	add a,020h		;4dc5	c6 20		.  
	ld l,a			;4dc7	6f		o
	jr nc,l4dcbh		;4dc8	30 01		0 .
	inc h			;4dca	24		$
l4dcbh:
	ld (hl),c		;4dcb	71		q
	inc hl			;4dcc	23		#
	ld (hl),c		;4dcd	71		q
	ret			;4dce	c9		.
sub_4dcfh:
	ex de,hl		;4dcf	eb		.
	ld (hl),b		;4dd0	70		p
	dec hl			;4dd1	2b		+
	ld (hl),0f1h		;4dd2	36 f1		6 .
	res 2,h			;4dd4	cb 94		. .
	ld (hl),c		;4dd6	71		q
	inc hl			;4dd7	23		#
	ld (hl),c		;4dd8	71		q
	set 2,h			;4dd9	cb d4		. .
	ex de,hl		;4ddb	eb		.
	rst 20h			;4ddc	e7		.
	ret			;4ddd	c9		.
sub_4ddeh:
	ld a,(0ad30h)		;4dde	3a 30 ad	: 0 .
	and a			;4de1	a7		.
	ret z			;4de2	c8		.
	ld a,(0a9c3h)		;4de3	3a c3 a9	: . .
	and 001h		;4de6	e6 01		. .
	ld hl,l4e1bh		;4de8	21 1b 4e	! . N
	jr z,l4df0h		;4deb	28 03		( .
	ld hl,l4e30h		;4ded	21 30 4e	! 0 N
l4df0h:
	ld c,(hl)		;4df0	4e		N
	ld b,000h		;4df1	06 00		. .
	inc hl			;4df3	23		#
	ld a,(0ad32h)		;4df4	3a 32 ad	: 2 .
	and a			;4df7	a7		.
	ld a,(0ad35h)		;4df8	3a 35 ad	: 5 .
	jr z,l4e00h		;4dfb	28 03		( .
	ld a,(0ad38h)		;4dfd	3a 38 ad	: 8 .
l4e00h:
	cpir			;4e00	ed b1		. .
	ld hl,0ad03h		;4e02	21 03 ad	! . .
	jr nz,l4e18h		;4e05	20 11		  .
	bit 0,(hl)		;4e07	cb 46		. F
	ret nz			;4e09	c0		.
	set 0,(hl)		;4e0a	cb c6		. .
	ld hl,0ad00h		;4e0c	21 00 ad	! . .
	ld a,(hl)		;4e0f	7e		~
	inc (hl)		;4e10	34		4
	ld d,005h		;4e11	16 05		. .
	ld e,a			;4e13	5f		_
	rst 38h			;4e14	ff		.
	jp l5805h		;4e15	c3 05 58	. . X
l4e18h:
	res 0,(hl)		;4e18	cb 86		. .
	ret			;4e1a	c9		.
l4e1bh:
	inc d			;4e1b	14		.
	ld bc,l1106h		;4e1c	01 06 11	. . .
	ld d,021h		;4e1f	16 21		. !
	ld h,031h		;4e21	26 31		& 1
	ld (hl),041h		;4e23	36 41		6 A
	ld b,(hl)		;4e25	46		F
	ld d,c			;4e26	51		Q
	ld d,(hl)		;4e27	56		V
	ld h,c			;4e28	61		a
	ld h,(hl)		;4e29	66		f
	ld (hl),c		;4e2a	71		q
	halt			;4e2b	76		v
	add a,c			;4e2c	81		.
	add a,(hl)		;4e2d	86		.
	sub c			;4e2e	91		.
	sub (hl)		;4e2f	96		.
l4e30h:
	ld de,l0802h		;4e30	11 02 08	. . .
	inc d			;4e33	14		.
	jr nz,$+40		;4e34	20 26		  &
	ld (l4438h),a		;4e36	32 38 44	2 8 D
	ld d,b			;4e39	50		P
	ld d,(hl)		;4e3a	56		V
	ld h,d			;4e3b	62		b
	ld l,b			;4e3c	68		h
	ld (hl),h		;4e3d	74		t
	add a,b			;4e3e	80		.
	add a,(hl)		;4e3f	86		.
	sub d			;4e40	92		.
	sbc a,b			;4e41	98		.
l4e42h:
	ld l,a			;4e42	6f		o
	and (hl)		;4e43	a6		.
	inc d			;4e44	14		.
	adc a,b			;4e45	88		.
	ld d,a			;4e46	57		W
	and l			;4e47	a5		.
	cp a			;4e48	bf		.
	inc (hl)		;4e49	34		4
	rst 10h			;4e4a	d7		.
	pop af			;4e4b	f1		.
	sbc a,e			;4e4c	9b		.
	pop af			;4e4d	f1		.
	cp c			;4e4e	b9		.
sub_4e4fh:
	ld a,(0ad04h)		;4e4f	3a 04 ad	: . .
	cp 004h			;4e52	fe 04		. .
	jp z,l4f2ah		;4e54	ca 2a 4f	. * O
	dec a			;4e57	3d		=
	jp z,l4ebch		;4e58	ca bc 4e	. . N
	ld a,(0a980h)		;4e5b	3a 80 a9	: . .
	and 001h		;4e5e	e6 01		. .
	jp nz,l4f35h		;4e60	c2 35 4f	. 5 O
l4e63h:
	call sub_4f5dh		;4e63	cd 5d 4f	. ] O
	ld b,004h		;4e66	06 04		. .
	ld de,0a810h		;4e68	11 10 a8	. . .
	ld iy,0aa12h		;4e6b	fd 21 12 aa	. ! . .
	ld l,005h		;4e6f	2e 05		. .
	ld h,00bh		;4e71	26 0b		& .
	call sub_5185h		;4e73	cd 85 51	. . Q
	ld a,(0ad0dh)		;4e76	3a 0d ad	: . .
	and a			;4e79	a7		.
	jr nz,l4e97h		;4e7a	20 1b		  .
	ld b,007h		;4e7c	06 07		. .
	ld l,007h		;4e7e	2e 07		. .
	ld h,00fh		;4e80	26 0f		& .
	call sub_5152h		;4e82	cd 52 51	. R Q
	ld b,003h		;4e85	06 03		. .
	ld l,006h		;4e87	2e 06		. .
	ld h,00dh		;4e89	26 0d		& .
	call sub_5121h		;4e8b	cd 21 51	. ! Q
	ld b,001h		;4e8e	06 01		. .
	ld l,008h		;4e90	2e 08		. .
	ld h,011h		;4e92	26 11		& .
	jp l51b3h		;4e94	c3 b3 51	. . Q
l4e97h:
	ld b,005h		;4e97	06 05		. .
	ld l,007h		;4e99	2e 07		. .
	ld h,00fh		;4e9b	26 0f		& .
	call sub_5152h		;4e9d	cd 52 51	. R Q
	call sub_50b1h		;4ea0	cd b1 50	. . P
	ld b,003h		;4ea3	06 03		. .
	ld de,0a8c0h		;4ea5	11 c0 a8	. . .
	ld iy,0aa28h		;4ea8	fd 21 28 aa	. ! ( .
	ld l,006h		;4eac	2e 06		. .
	ld h,00dh		;4eae	26 0d		& .
	call sub_5121h		;4eb0	cd 21 51	. ! Q
	ld b,001h		;4eb3	06 01		. .
	ld l,008h		;4eb5	2e 08		. .
	ld h,011h		;4eb7	26 11		& .
	jp l51b3h		;4eb9	c3 b3 51	. . Q
l4ebch:
	ld a,(0a980h)		;4ebc	3a 80 a9	: . .
	and 001h		;4ebf	e6 01		. .
	jp nz,l4f35h		;4ec1	c2 35 4f	. 5 O
	call sub_4f7eh		;4ec4	cd 7e 4f	. ~ O
	ld b,004h		;4ec7	06 04		. .
	ld de,0a810h		;4ec9	11 10 a8	. . .
	ld iy,0aa12h		;4ecc	fd 21 12 aa	. ! . .
	ld l,005h		;4ed0	2e 05		. .
	ld h,00bh		;4ed2	26 0b		& .
	call sub_5185h		;4ed4	cd 85 51	. . Q
	ld a,(0ad0dh)		;4ed7	3a 0d ad	: . .
	and a			;4eda	a7		.
	jr nz,l4f02h		;4edb	20 25		  %
	ld b,007h		;4edd	06 07		. .
	ld l,007h		;4edf	2e 07		. .
	ld h,00fh		;4ee1	26 0f		& .
	call sub_5152h		;4ee3	cd 52 51	. R Q
	call sub_507eh		;4ee6	cd 7e 50	. ~ P
	ld b,001h		;4ee9	06 01		. .
	ld de,0a8e0h		;4eeb	11 e0 a8	. . .
	ld iy,0aa2ch		;4eee	fd 21 2c aa	. ! , .
	ld l,005h		;4ef2	2e 05		. .
	ld h,00bh		;4ef4	26 0b		& .
	call sub_5185h		;4ef6	cd 85 51	. . Q
	ld b,001h		;4ef9	06 01		. .
	ld l,008h		;4efb	2e 08		. .
	ld h,011h		;4efd	26 11		& .
	jp l51b3h		;4eff	c3 b3 51	. . Q
l4f02h:
	ld b,005h		;4f02	06 05		. .
	ld l,007h		;4f04	2e 07		. .
	ld h,00fh		;4f06	26 0f		& .
	call sub_5152h		;4f08	cd 52 51	. R Q
	call sub_50b1h		;4f0b	cd b1 50	. . P
	call sub_507eh		;4f0e	cd 7e 50	. ~ P
	ld b,001h		;4f11	06 01		. .
	ld de,0a8e0h		;4f13	11 e0 a8	. . .
	ld iy,0aa2ch		;4f16	fd 21 2c aa	. ! , .
	ld l,005h		;4f1a	2e 05		. .
	ld h,00bh		;4f1c	26 0b		& .
	call sub_5185h		;4f1e	cd 85 51	. . Q
	ld b,001h		;4f21	06 01		. .
	ld l,008h		;4f23	2e 08		. .
	ld h,011h		;4f25	26 11		& .
	jp l51b3h		;4f27	c3 b3 51	. . Q
l4f2ah:
	ld a,(0a980h)		;4f2a	3a 80 a9	: . .
	and 001h		;4f2d	e6 01		. .
	jp z,l4e63h		;4f2f	ca 63 4e	. c N
	jp l5032h		;4f32	c3 32 50	. 2 P
l4f35h:
	ld a,(0ad0dh)		;4f35	3a 0d ad	: . .
	and a			;4f38	a7		.
	jp nz,l4fbfh		;4f39	c2 bf 4f	. . O
	ld de,0a850h		;4f3c	11 50 a8	. P .
	ld iy,0aa1ah		;4f3f	fd 21 1a aa	. ! . .
	ld ix,0aa80h		;4f43	dd 21 80 aa	. ! . .
	ex af,af'		;4f47	08		.
	ld a,007h		;4f48	3e 07		> .
	ld b,a			;4f4a	47		G
	ex af,af'		;4f4b	08		.
	ld c,006h		;4f4c	0e 06		. .
	ld (0a993h),de		;4f4e	ed 53 93 a9	. S . .
	ld (0a991h),iy		;4f52	fd 22 91 a9	. " . .
	ld l,007h		;4f56	2e 07		. .
	ld h,00fh		;4f58	26 0f		& .
	jp l5211h		;4f5a	c3 11 52	. . R
sub_4f5dh:
	ld de,0a8c0h		;4f5d	11 c0 a8	. . .
	ld iy,0aa28h		;4f60	fd 21 28 aa	. ! ( .
	ld ix,0aa80h		;4f64	dd 21 80 aa	. ! . .
	ex af,af'		;4f68	08		.
	ld a,003h		;4f69	3e 03		> .
	ld b,a			;4f6b	47		G
	ex af,af'		;4f6c	08		.
	ld c,006h		;4f6d	0e 06		. .
	ld (0a993h),de		;4f6f	ed 53 93 a9	. S . .
	ld (0a991h),iy		;4f73	fd 22 91 a9	. " . .
	ld l,007h		;4f77	2e 07		. .
	ld h,00fh		;4f79	26 0f		& .
	jp l5211h		;4f7b	c3 11 52	. . R
sub_4f7eh:
	ld l,006h		;4f7e	2e 06		. .
	ld h,00dh		;4f80	26 0d		& .
	ld e,017h		;4f82	1e 17		. .
	ld d,01fh		;4f84	16 1f		. .
	ld iy,0aa80h		;4f86	fd 21 80 aa	. ! . .
	ld b,006h		;4f8a	06 06		. .
	ld a,(0a8c0h)		;4f8c	3a c0 a8	: . .
	inc a			;4f8f	3c		<
	ret nz			;4f90	c0		.
l4f91h:
	ld a,(iy+000h)		;4f91	fd 7e 00	. ~ .
	inc a			;4f94	3c		<
	jr nz,l4fb6h		;4f95	20 1f		  .
	ld a,(0aa28h)		;4f97	3a 28 aa	: ( .
	sub (iy+006h)		;4f9a	fd 96 06	. . .
	add a,l			;4f9d	85		.
	cp h			;4f9e	bc		.
	jr nc,l4fb6h		;4f9f	30 15		0 .
	ld a,(0aa59h)		;4fa1	3a 59 aa	: Y .
	sub (iy+004h)		;4fa4	fd 96 04	. . .
	add a,e			;4fa7	83		.
	cp d			;4fa8	ba		.
	jr nc,l4fb6h		;4fa9	30 0b		0 .
	ld a,0f0h		;4fab	3e f0		> .
	ld (0a8c0h),a		;4fad	32 c0 a8	2 . .
	ld (iy+000h),a		;4fb0	fd 77 00	. w .
	call sub_51deh		;4fb3	cd de 51	. . Q
l4fb6h:
	defb 0fdh,07dh ;ld a,iyl	;4fb6	fd 7d		. }
	add a,010h		;4fb8	c6 10		. .
	defb 0fdh,06fh ;ld iyl,a	;4fba	fd 6f		. o
	djnz l4f91h		;4fbc	10 d3		. .
	ret			;4fbe	c9		.
l4fbfh:
	ld de,0a850h		;4fbf	11 50 a8	. P .
	ld iy,0aa1ah		;4fc2	fd 21 1a aa	. ! . .
	ld ix,0aa80h		;4fc6	dd 21 80 aa	. ! . .
	ex af,af'		;4fca	08		.
	ld a,005h		;4fcb	3e 05		> .
	ld b,a			;4fcd	47		G
	ex af,af'		;4fce	08		.
	ld c,006h		;4fcf	0e 06		. .
	ld (0a993h),de		;4fd1	ed 53 93 a9	. S . .
	ld (0a991h),iy		;4fd5	fd 22 91 a9	. " . .
	ld l,007h		;4fd9	2e 07		. .
	ld h,00fh		;4fdb	26 0f		& .
	call l5211h		;4fdd	cd 11 52	. . R
l4fe0h:
	ld a,(0ad04h)		;4fe0	3a 04 ad	: . .
	and a			;4fe3	a7		.
	jr z,l502bh		;4fe4	28 45		( E
	cp 004h			;4fe6	fe 04		. .
	jr z,l502bh		;4fe8	28 41		( A
	ld l,006h		;4fea	2e 06		. .
	ld h,00dh		;4fec	26 0d		& .
l4feeh:
	ld e,017h		;4fee	1e 17		. .
	ld d,01fh		;4ff0	16 1f		. .
	ld iy,0aa80h		;4ff2	fd 21 80 aa	. ! . .
	ld b,006h		;4ff6	06 06		. .
	ld a,(0a8a0h)		;4ff8	3a a0 a8	: . .
	inc a			;4ffb	3c		<
	ret nz			;4ffc	c0		.
l4ffdh:
	ld a,(iy+000h)		;4ffd	fd 7e 00	. ~ .
	inc a			;5000	3c		<
	jr nz,l5022h		;5001	20 1f		  .
l5003h:
	ld a,(0aa24h)		;5003	3a 24 aa	: $ .
	sub (iy+006h)		;5006	fd 96 06	. . .
	add a,l			;5009	85		.
	cp h			;500a	bc		.
	jr nc,l5022h		;500b	30 15		0 .
	ld a,(0aa55h)		;500d	3a 55 aa	: U .
	sub (iy+004h)		;5010	fd 96 04	. . .
	add a,e			;5013	83		.
	cp d			;5014	ba		.
	jr nc,l5022h		;5015	30 0b		0 .
	ld a,0f0h		;5017	3e f0		> .
	ld (0a8a0h),a		;5019	32 a0 a8	2 . .
	ld (iy+000h),a		;501c	fd 77 00	. w .
	call sub_51deh		;501f	cd de 51	. . Q
l5022h:
	defb 0fdh,07dh ;ld a,iyl	;5022	fd 7d		. }
	add a,010h		;5024	c6 10		. .
	defb 0fdh,06fh ;ld iyl,a	;5026	fd 6f		. o
l5028h:
	djnz l4ffdh		;5028	10 d3		. .
	ret			;502a	c9		.
l502bh:
	ld l,008h		;502b	2e 08		. .
	ld h,011h		;502d	26 11		& .
	jp l4feeh		;502f	c3 ee 4f	. . O
l5032h:
	ld a,(0ad0dh)		;5032	3a 0d ad	: . .
	and a			;5035	a7		.
	jp nz,l505ah		;5036	c2 5a 50	. Z P
	ld de,0a810h		;5039	11 10 a8	. . .
	ld iy,0aa12h		;503c	fd 21 12 aa	. ! . .
	ld ix,0aa80h		;5040	dd 21 80 aa	. ! . .
	ex af,af'		;5044	08		.
	ld a,00bh		;5045	3e 0b		> .
	ld b,a			;5047	47		G
	ex af,af'		;5048	08		.
	ld c,006h		;5049	0e 06		. .
	ld (0a993h),de		;504b	ed 53 93 a9	. S . .
	ld (0a991h),iy		;504f	fd 22 91 a9	. " . .
	ld l,007h		;5053	2e 07		. .
	ld h,00fh		;5055	26 0f		& .
	jp l5211h		;5057	c3 11 52	. . R
l505ah:
	ld de,0a810h		;505a	11 10 a8	. . .
	ld iy,0aa12h		;505d	fd 21 12 aa	. ! . .
	ld ix,0aa80h		;5061	dd 21 80 aa	. ! . .
	ex af,af'		;5065	08		.
	ld a,009h		;5066	3e 09		> .
	ld b,a			;5068	47		G
	ex af,af'		;5069	08		.
	ld c,006h		;506a	0e 06		. .
	ld (0a993h),de		;506c	ed 53 93 a9	. S . .
	ld (0a991h),iy		;5070	fd 22 91 a9	. " . .
	ld l,007h		;5074	2e 07		. .
	ld h,00fh		;5076	26 0f		& .
	call l5211h		;5078	cd 11 52	. . R
	jp l4fe0h		;507b	c3 e0 4f	. . O
sub_507eh:
	ld ix,0aa10h		;507e	dd 21 10 aa	. ! . .
	ld a,(WORK_RAM)		;5082	3a 00 a8	: . .
	inc a			;5085	3c		<
	ret nz			;5086	c0		.
	ld a,(0a8c0h)		;5087	3a c0 a8	: . .
	inc a			;508a	3c		<
	ret nz			;508b	c0		.
	ld a,(0aa28h)		;508c	3a 28 aa	: ( .
	sub (ix+000h)		;508f	dd 96 00	. . .
	add a,006h		;5092	c6 06		. .
	cp 00dh			;5094	fe 0d		. .
	ret nc			;5096	d0		.
	ld a,(0aa59h)		;5097	3a 59 aa	: Y .
	sub (ix+031h)		;509a	dd 96 31	. . 1
	add a,018h		;509d	c6 18		. .
	cp 021h			;509f	fe 21		. !
	ret nc			;50a1	d0		.
	ld a,0f0h		;50a2	3e f0		> .
	ld (WORK_RAM),a		;50a4	32 00 a8	2 . .
	ld (0a8c0h),a		;50a7	32 c0 a8	2 . .
	xor a			;50aa	af		.
	ld (0a8dch),a		;50ab	32 dc a8	2 . .
	jp sub_51deh		;50ae	c3 de 51	. . Q
sub_50b1h:
	ld a,(0ad04h)		;50b1	3a 04 ad	: . .
	and a			;50b4	a7		.
	jr z,l50eeh		;50b5	28 37		( 7
	cp 004h			;50b7	fe 04		. .
	jr z,l50eeh		;50b9	28 33		( 3
	ld ix,0aa10h		;50bb	dd 21 10 aa	. ! . .
	ld a,(WORK_RAM)		;50bf	3a 00 a8	: . .
	inc a			;50c2	3c		<
	ret nz			;50c3	c0		.
	ld a,(0a8a0h)		;50c4	3a a0 a8	: . .
	inc a			;50c7	3c		<
	ret nz			;50c8	c0		.
	ld a,(0aa24h)		;50c9	3a 24 aa	: $ .
	sub (ix+000h)		;50cc	dd 96 00	. . .
	add a,006h		;50cf	c6 06		. .
	cp 00dh			;50d1	fe 0d		. .
	ret nc			;50d3	d0		.
	ld a,(0aa55h)		;50d4	3a 55 aa	: U .
	sub (ix+031h)		;50d7	dd 96 31	. . 1
	add a,019h		;50da	c6 19		. .
	cp 023h			;50dc	fe 23		. #
	ret nc			;50de	d0		.
	ld a,0f0h		;50df	3e f0		> .
	ld (WORK_RAM),a		;50e1	32 00 a8	2 . .
	ld (0a8a0h),a		;50e4	32 a0 a8	2 . .
	xor a			;50e7	af		.
	ld (0a8a4h),a		;50e8	32 a4 a8	2 . .
	jp sub_51deh		;50eb	c3 de 51	. . Q
l50eeh:
	ld ix,0aa10h		;50ee	dd 21 10 aa	. ! . .
	ld a,(WORK_RAM)		;50f2	3a 00 a8	: . .
	inc a			;50f5	3c		<
	ret nz			;50f6	c0		.
	ld a,(0a8a0h)		;50f7	3a a0 a8	: . .
	inc a			;50fa	3c		<
	ret nz			;50fb	c0		.
	ld a,(0aa24h)		;50fc	3a 24 aa	: $ .
	sub (ix+000h)		;50ff	dd 96 00	. . .
	add a,008h		;5102	c6 08		. .
	cp 011h			;5104	fe 11		. .
	ret nc			;5106	d0		.
	ld a,(0aa55h)		;5107	3a 55 aa	: U .
	sub (ix+031h)		;510a	dd 96 31	. . 1
	add a,019h		;510d	c6 19		. .
	cp 023h			;510f	fe 23		. #
	ret nc			;5111	d0		.
	ld a,0f0h		;5112	3e f0		> .
	ld (WORK_RAM),a		;5114	32 00 a8	2 . .
	ld (0a8a0h),a		;5117	32 a0 a8	2 . .
	xor a			;511a	af		.
	ld (0a8a4h),a		;511b	32 a4 a8	2 . .
	jp sub_51deh		;511e	c3 de 51	. . Q
sub_5121h:
	ld a,(WORK_RAM)		;5121	3a 00 a8	: . .
	inc a			;5124	3c		<
	ret nz			;5125	c0		.
l5126h:
	ld a,(de)		;5126	1a		.
	inc a			;5127	3c		<
	jr nz,l5147h		;5128	20 1d		  .
	ld a,(0aa10h)		;512a	3a 10 aa	: . .
	sub (iy+000h)		;512d	fd 96 00	. . .
	add a,l			;5130	85		.
	cp h			;5131	bc		.
	jr nc,l5147h		;5132	30 13		0 .
	ld a,(0aa41h)		;5134	3a 41 aa	: A .
	sub (iy+031h)		;5137	fd 96 31	. . 1
	add a,l			;513a	85		.
	cp h			;513b	bc		.
	jr nc,l5147h		;513c	30 09		0 .
	ld a,0f0h		;513e	3e f0		> .
	ld (WORK_RAM),a		;5140	32 00 a8	2 . .
	ld (de),a		;5143	12		.
	call sub_51deh		;5144	cd de 51	. . Q
l5147h:
	ld a,e			;5147	7b		{
	add a,010h		;5148	c6 10		. .
	ld e,a			;514a	5f		_
	inc iy			;514b	fd 23		. #
	inc iy			;514d	fd 23		. #
	djnz l5126h		;514f	10 d5		. .
	ret			;5151	c9		.
sub_5152h:
	ld a,(WORK_RAM)		;5152	3a 00 a8	: . .
	inc a			;5155	3c		<
	ret nz			;5156	c0		.
l5157h:
	ld a,(de)		;5157	1a		.
	inc a			;5158	3c		<
	jr nz,l517ah		;5159	20 1f		  .
	ld a,(0aa10h)		;515b	3a 10 aa	: . .
	sub (iy+000h)		;515e	fd 96 00	. . .
	add a,l			;5161	85		.
	cp h			;5162	bc		.
	jr nc,l517ah		;5163	30 15		0 .
	ld a,(0aa41h)		;5165	3a 41 aa	: A .
	sub (iy+031h)		;5168	fd 96 31	. . 1
	add a,008h		;516b	c6 08		. .
	cp 011h			;516d	fe 11		. .
	jr nc,l517ah		;516f	30 09		0 .
	ld a,0f0h		;5171	3e f0		> .
	ld (WORK_RAM),a		;5173	32 00 a8	2 . .
	ld (de),a		;5176	12		.
	call sub_51deh		;5177	cd de 51	. . Q
l517ah:
	ld a,e			;517a	7b		{
	add a,010h		;517b	c6 10		. .
	ld e,a			;517d	5f		_
	inc iy			;517e	fd 23		. #
	inc iy			;5180	fd 23		. #
	djnz l5157h		;5182	10 d3		. .
	ret			;5184	c9		.
sub_5185h:
	ld a,(WORK_RAM)		;5185	3a 00 a8	: . .
	inc a			;5188	3c		<
	ret nz			;5189	c0		.
l518ah:
	ld a,(de)		;518a	1a		.
	inc a			;518b	3c		<
	jr nz,l51a8h		;518c	20 1a		  .
	ld a,(0aa10h)		;518e	3a 10 aa	: . .
	sub (iy+000h)		;5191	fd 96 00	. . .
	add a,l			;5194	85		.
	cp h			;5195	bc		.
	jr nc,l51a8h		;5196	30 10		0 .
	ld a,(0aa41h)		;5198	3a 41 aa	: A .
	sub (iy+031h)		;519b	fd 96 31	. . 1
	add a,l			;519e	85		.
	cp h			;519f	bc		.
	jr nc,l51a8h		;51a0	30 06		0 .
	ld a,0f0h		;51a2	3e f0		> .
	ld (WORK_RAM),a		;51a4	32 00 a8	2 . .
	ld (de),a		;51a7	12		.
l51a8h:
	ld a,e			;51a8	7b		{
	add a,010h		;51a9	c6 10		. .
	ld e,a			;51ab	5f		_
	inc iy			;51ac	fd 23		. #
	inc iy			;51ae	fd 23		. #
	djnz l518ah		;51b0	10 d8		. .
	ret			;51b2	c9		.
l51b3h:
	ld a,(WORK_RAM)		;51b3	3a 00 a8	: . .
	inc a			;51b6	3c		<
	ret nz			;51b7	c0		.
l51b8h:
	ld a,(de)		;51b8	1a		.
	inc a			;51b9	3c		<
	jr nz,l51d3h		;51ba	20 17		  .
	ld a,(0aa10h)		;51bc	3a 10 aa	: . .
	sub (iy+000h)		;51bf	fd 96 00	. . .
	add a,l			;51c2	85		.
	cp h			;51c3	bc		.
	jr nc,l51d3h		;51c4	30 0d		0 .
	ld a,(0aa41h)		;51c6	3a 41 aa	: A .
	sub (iy+031h)		;51c9	fd 96 31	. . 1
	add a,l			;51cc	85		.
	cp h			;51cd	bc		.
	jr nc,l51d3h		;51ce	30 03		0 .
	ld a,0f0h		;51d0	3e f0		> .
	ld (de),a		;51d2	12		.
l51d3h:
	ld a,e			;51d3	7b		{
	add a,010h		;51d4	c6 10		. .
	ld e,a			;51d6	5f		_
	inc iy			;51d7	fd 23		. #
	inc iy			;51d9	fd 23		. #
	djnz l51b8h		;51db	10 db		. .
	ret			;51dd	c9		.
sub_51deh:
	push de			;51de	d5		.
	ld a,(0a99dh)		;51df	3a 9d a9	: . .
	and a			;51e2	a7		.
	jr z,l51fah		;51e3	28 15		( .
	ld a,(0a99eh)		;51e5	3a 9e a9	: . .
	inc a			;51e8	3c		<
	ld (0a99eh),a		;51e9	32 9e a9	2 . .
	and 007h		;51ec	e6 07		. .
	inc a			;51ee	3c		<
	ld e,a			;51ef	5f		_
	ld d,004h		;51f0	16 04		. .
	rst 38h			;51f2	ff		.
	pop de			;51f3	d1		.
	ld a,01eh		;51f4	3e 1e		> .
	ld (0a99dh),a		;51f6	32 9d a9	2 . .
	ret			;51f9	c9		.
l51fah:
	ld de,l0401h		;51fa	11 01 04	. . .
	rst 38h			;51fd	ff		.
	pop de			;51fe	d1		.
	ld a,01eh		;51ff	3e 1e		> .
	ld (0a99dh),a		;5201	32 9d a9	2 . .
	ret			;5204	c9		.
sub_5205h:
	ld hl,0a99dh		;5205	21 9d a9	! . .
	ld a,(hl)		;5208	7e		~
	and a			;5209	a7		.
	jr z,l520eh		;520a	28 02		( .
	dec (hl)		;520c	35		5
	ret			;520d	c9		.
l520eh:
	inc l			;520e	2c		,
	ld (hl),a		;520f	77		w
	ret			;5210	c9		.
l5211h:
	ld a,(ix+000h)		;5211	dd 7e 00	. ~ .
	inc a			;5214	3c		<
	jr nz,l5254h		;5215	20 3d		  =
l5217h:
	ld a,(de)		;5217	1a		.
	inc a			;5218	3c		<
	jr nz,l524ah		;5219	20 2f		  /
	ld a,(iy+000h)		;521b	fd 7e 00	. ~ .
	add a,008h		;521e	c6 08		. .
	cp 019h			;5220	fe 19		. .
	jr c,l524ah		;5222	38 26		8 &
	ld a,(iy+031h)		;5224	fd 7e 31	. ~ 1
	add a,010h		;5227	c6 10		. .
	cp 011h			;5229	fe 11		. .
	jr c,l524ah		;522b	38 1d		8 .
	ld a,(ix+006h)		;522d	dd 7e 06	. ~ .
	sub (iy+000h)		;5230	fd 96 00	. . .
	add a,l			;5233	85		.
	cp h			;5234	bc		.
	jr nc,l524ah		;5235	30 13		0 .
	ld a,(ix+004h)		;5237	dd 7e 04	. ~ .
	sub (iy+031h)		;523a	fd 96 31	. . 1
	add a,l			;523d	85		.
	cp h			;523e	bc		.
	jr nc,l524ah		;523f	30 09		0 .
	ld a,0f0h		;5241	3e f0		> .
	ld (ix+000h),a		;5243	dd 77 00	. w .
	ld (de),a		;5246	12		.
	call sub_51deh		;5247	cd de 51	. . Q
l524ah:
	ld a,e			;524a	7b		{
	add a,010h		;524b	c6 10		. .
	ld e,a			;524d	5f		_
	inc iy			;524e	fd 23		. #
	inc iy			;5250	fd 23		. #
	djnz l5217h		;5252	10 c3		. .
l5254h:
	ld iy,(0a991h)		;5254	fd 2a 91 a9	. * . .
	ld de,(0a993h)		;5258	ed 5b 93 a9	. [ . .
	ex af,af'		;525c	08		.
	ld b,a			;525d	47		G
	ex af,af'		;525e	08		.
	defb 0ddh,07dh ;ld a,ixl	;525f	dd 7d		. }
	add a,010h		;5261	c6 10		. .
	defb 0ddh,06fh ;ld ixl,a	;5263	dd 6f		. o
	dec c			;5265	0d		.
	jp nz,l5211h		;5266	c2 11 52	. . R
	ret			;5269	c9		.
sub_526ah:
	ld hl,0ae84h		;526a	21 84 ae	! . .
	ld (0ae80h),hl		;526d	22 80 ae	" . .
	ld hl,0ae04h		;5270	21 04 ae	! . .
	ld (0ae00h),hl		;5273	22 00 ae	" . .
	ret			;5276	c9		.
	ld b,000h		;5277	06 00		. .
	ld hl,027deh		;5279	21 de 27	! . '
	xor a			;527c	af		.
l527dh:
	add a,(hl)		;527d	86		.
	inc hl			;527e	23		#
	djnz l527dh		;527f	10 fc		. .
	sub 0c5h		;5281	d6 c5		. .
	call nz,sub_53d4h	;5283	c4 d4 53	. . S
sub_5286h:
	call sub_530eh		;5286	cd 0e 53	. . S
	call sub_52d2h		;5289	cd d2 52	. . R
	ld a,(0ae00h)		;528c	3a 00 ae	: . .
	cp 004h			;528f	fe 04		. .
	jr z,sub_526ah		;5291	28 d7		( .
	ld c,a			;5293	4f		O
	ld b,000h		;5294	06 00		. .
	ld hl,0ae00h		;5296	21 00 ae	! . .
	ld de,0ae80h		;5299	11 80 ae	. . .
	ldir			;529c	ed b0		. .
	add a,080h		;529e	c6 80		. .
	ld (0ae80h),a		;52a0	32 80 ae	2 . .
	ld hl,0ae04h		;52a3	21 04 ae	! . .
	ld (0ae00h),hl		;52a6	22 00 ae	" . .
	ret			;52a9	c9		.
l52aah:
	ld a,(008c9h)		;52aa	3a c9 08	: . .
	ld (0a98dh),a		;52ad	32 8d a9	2 . .
	ld a,(l0874h)		;52b0	3a 74 08	: t .
	ld (0a9cdh),a		;52b3	32 cd a9	2 . .
	ld a,(DSW1_READ)	;52b6	3a 60 c3	: ` .
	cpl			;52b9	2f		/
	ld (0a9b1h),a		;52ba	32 b1 a9	2 . .
	call sub_4acch		;52bd	cd cc 4a	. . J
	ld a,(DSW2_READ_WATCHDOG_WRITE)	;52c0	3a 00 c2	: . .
	cpl			;52c3	2f		/
	ld c,a			;52c4	4f		O
	and 003h		;52c5	e6 03		. .
	add a,003h		;52c7	c6 03		. .
	cp 006h			;52c9	fe 06		. .
	jr nz,l52cfh		;52cb	20 02		  .
	ld a,0ffh		;52cd	3e ff		> .
l52cfh:
	jp l2e19h		;52cf	c3 19 2e	. . .
sub_52d2h:
	ld a,(0ad0ch)		;52d2	3a 0c ad	: . .
	and 00fh		;52d5	e6 0f		. .
	ld c,a			;52d7	4f		O
	ld hl,(0ae00h)		;52d8	2a 00 ae	* . .
	ld a,l			;52db	7d		}
	sub 004h		;52dc	d6 04		. .
	ret z			;52de	c8		.
	rrca			;52df	0f		.
	rrca			;52e0	0f		.
	and 01fh		;52e1	e6 1f		. .
	ld b,a			;52e3	47		G
	ld hl,0ae04h		;52e4	21 04 ae	! . .
l52e7h:
	ld e,(hl)		;52e7	5e		^
	inc l			;52e8	2c		,
	ld d,(hl)		;52e9	56		V
	inc l			;52ea	2c		,
	ld a,(de)		;52eb	1a		.
	and 010h		;52ec	e6 10		. .
	jr nz,l52feh		;52ee	20 0e		  .
	ld a,(hl)		;52f0	7e		~
	set 2,d			;52f1	cb d2		. .
	ld (de),a		;52f3	12		.
	res 2,d			;52f4	cb 92		. .
	inc l			;52f6	2c		,
	ld a,(hl)		;52f7	7e		~
	inc l			;52f8	2c		,
	add a,c			;52f9	81		.
	ld (de),a		;52fa	12		.
	djnz l52e7h		;52fb	10 ea		. .
	ret			;52fd	c9		.
l52feh:
	inc l			;52fe	2c		,
	inc l			;52ff	2c		,
	djnz l52e7h		;5300	10 e5		. .
	ret			;5302	c9		.
l5303h:
	call sub_200ch		;5303	cd 0c 20	. .  
	cp 067h			;5306	fe 67		. g
	jp nz,l0f8dh		;5308	c2 8d 0f	. . .
	jp sub_0f1ah		;530b	c3 1a 0f	. . .
sub_530eh:
	ld hl,(0ae80h)		;530e	2a 80 ae	* . .
	ld a,l			;5311	7d		}
	and 07fh		;5312	e6 7f		. .
	sub 004h		;5314	d6 04		. .
	ret z			;5316	c8		.
	rrca			;5317	0f		.
	rrca			;5318	0f		.
	and 01fh		;5319	e6 1f		. .
	ld b,a			;531b	47		G
	ld hl,0ae84h		;531c	21 84 ae	! . .
l531fh:
	ld e,(hl)		;531f	5e		^
	inc l			;5320	2c		,
	ld d,(hl)		;5321	56		V
	inc l			;5322	2c		,
	ld a,(de)		;5323	1a		.
	and 010h		;5324	e6 10		. .
	jr nz,l5332h		;5326	20 0a		  .
	inc l			;5328	2c		,
	inc l			;5329	2c		,
	set 2,d			;532a	cb d2		. .
	ld a,020h		;532c	3e 20		>  
	ld (de),a		;532e	12		.
	djnz l531fh		;532f	10 ee		. .
	ret			;5331	c9		.
l5332h:
	inc l			;5332	2c		,
	inc l			;5333	2c		,
	djnz l531fh		;5334	10 e9		. .
	ret			;5336	c9		.
sub_5337h:
	ld a,(ix+004h)		;5337	dd 7e 04	. ~ .
	add a,007h		;533a	c6 07		. .
	ld b,a			;533c	47		G
	ld d,028h		;533d	16 28		. (
	rlca			;533f	07		.
	rl d			;5340	cb 12		. .
	rlca			;5342	07		.
	rl d			;5343	cb 12		. .
	and 0e0h		;5345	e6 e0		. .
	ld e,a			;5347	5f		_
	ld a,(ix+006h)		;5348	dd 7e 06	. ~ .
	add a,007h		;534b	c6 07		. .
	ld c,a			;534d	4f		O
	rrca			;534e	0f		.
	rrca			;534f	0f		.
	rrca			;5350	0f		.
	and 01fh		;5351	e6 1f		. .
	add a,e			;5353	83		.
	ld e,a			;5354	5f		_
	ld a,c			;5355	79		y
	rlca			;5356	07		.
	rlca			;5357	07		.
	rlca			;5358	07		.
	and 038h		;5359	e6 38		. 8
	ld c,a			;535b	4f		O
	ld a,b			;535c	78		x
	ld b,000h		;535d	06 00		. .
	bit 2,a			;535f	cb 57		. W
	jr z,l5364h		;5361	28 01		( .
	inc b			;5363	04		.
l5364h:
	rrca			;5364	0f		.
	rrca			;5365	0f		.
	and 0c0h		;5366	e6 c0		. .
	add a,c			;5368	81		.
	ld c,a			;5369	4f		O
	ld hl,sub_53d4h		;536a	21 d4 53	! . S
	add hl,bc		;536d	09		.
	ld a,(hl)		;536e	7e		~
	inc hl			;536f	23		#
	ld b,(hl)		;5370	46		F
	inc hl			;5371	23		#
	and a			;5372	a7		.
	jr z,l5385h		;5373	28 10		( .
	push hl			;5375	e5		.
	ld hl,(0ae00h)		;5376	2a 00 ae	* . .
	ld (hl),e		;5379	73		s
	inc l			;537a	2c		,
	ld (hl),d		;537b	72		r
	inc l			;537c	2c		,
	ld (hl),a		;537d	77		w
	inc l			;537e	2c		,
	ld (hl),b		;537f	70		p
	inc l			;5380	2c		,
	ld (0ae00h),hl		;5381	22 00 ae	" . .
	pop hl			;5384	e1		.
l5385h:
	inc de			;5385	13		.
	ld a,(hl)		;5386	7e		~
	inc hl			;5387	23		#
	ld b,(hl)		;5388	46		F
	inc hl			;5389	23		#
	and a			;538a	a7		.
	jr z,l539dh		;538b	28 10		( .
	push hl			;538d	e5		.
	ld hl,(0ae00h)		;538e	2a 00 ae	* . .
	ld (hl),e		;5391	73		s
	inc l			;5392	2c		,
	ld (hl),d		;5393	72		r
	inc l			;5394	2c		,
	ld (hl),a		;5395	77		w
	inc l			;5396	2c		,
	ld (hl),b		;5397	70		p
	inc l			;5398	2c		,
	ld (0ae00h),hl		;5399	22 00 ae	" . .
	pop hl			;539c	e1		.
l539dh:
	ld a,e			;539d	7b		{
	add a,01fh		;539e	c6 1f		. .
	ld e,a			;53a0	5f		_
	jr nc,l53a4h		;53a1	30 01		0 .
	inc d			;53a3	14		.
l53a4h:
	ld a,(hl)		;53a4	7e		~
	inc hl			;53a5	23		#
	ld b,(hl)		;53a6	46		F
	inc hl			;53a7	23		#
	and a			;53a8	a7		.
	jr z,l53bbh		;53a9	28 10		( .
	push hl			;53ab	e5		.
	ld hl,(0ae00h)		;53ac	2a 00 ae	* . .
	ld (hl),e		;53af	73		s
	inc l			;53b0	2c		,
	ld (hl),d		;53b1	72		r
	inc l			;53b2	2c		,
	ld (hl),a		;53b3	77		w
	inc l			;53b4	2c		,
	ld (hl),b		;53b5	70		p
	inc l			;53b6	2c		,
	ld (0ae00h),hl		;53b7	22 00 ae	" . .
	pop hl			;53ba	e1		.
l53bbh:
	inc de			;53bb	13		.
	ld a,(hl)		;53bc	7e		~
	inc hl			;53bd	23		#
	ld b,(hl)		;53be	46		F
	inc hl			;53bf	23		#
	and a			;53c0	a7		.
	jr z,l53d3h		;53c1	28 10		( .
	push hl			;53c3	e5		.
	ld hl,(0ae00h)		;53c4	2a 00 ae	* . .
	ld (hl),e		;53c7	73		s
	inc l			;53c8	2c		,
	ld (hl),d		;53c9	72		r
	inc l			;53ca	2c		,
	ld (hl),a		;53cb	77		w
	inc l			;53cc	2c		,
	ld (hl),b		;53cd	70		p
	inc l			;53ce	2c		,
	ld (0ae00h),hl		;53cf	22 00 ae	" . .
	pop hl			;53d2	e1		.
l53d3h:
	ret			;53d3	c9		.
sub_53d4h:
	inc h			;53d4	24		$
	jr nz,l53d7h		;53d5	20 00		  .
l53d7h:
	nop			;53d7	00		.
	nop			;53d8	00		.
	nop			;53d9	00		.
	nop			;53da	00		.
	nop			;53db	00		.
	defb 0ddh,020h,000h ;illegal sequence	;53dc	dd 20 00	.   .
	nop			;53df	00		.
	nop			;53e0	00		.
	nop			;53e1	00		.
	nop			;53e2	00		.
	nop			;53e3	00		.
	ld h,c			;53e4	61		a
	jr nz,l53e7h		;53e5	20 00		  .
l53e7h:
	nop			;53e7	00		.
	nop			;53e8	00		.
	nop			;53e9	00		.
	nop			;53ea	00		.
	nop			;53eb	00		.
	inc a			;53ec	3c		<
	jr nz,l53efh		;53ed	20 00		  .
l53efh:
	nop			;53ef	00		.
	nop			;53f0	00		.
	nop			;53f1	00		.
	nop			;53f2	00		.
	nop			;53f3	00		.
	ld h,c			;53f4	61		a
	ld h,b			;53f5	60		`
	nop			;53f6	00		.
	nop			;53f7	00		.
	nop			;53f8	00		.
	nop			;53f9	00		.
	nop			;53fa	00		.
	nop			;53fb	00		.
	defb 0ddh,060h ;ld ixh,b	;53fc	dd 60		. `
	nop			;53fe	00		.
	nop			;53ff	00		.
	nop			;5400	00		.
	nop			;5401	00		.
	nop			;5402	00		.
	nop			;5403	00		.
	inc h			;5404	24		$
	ld h,b			;5405	60		`
	nop			;5406	00		.
	nop			;5407	00		.
	nop			;5408	00		.
	nop			;5409	00		.
	nop			;540a	00		.
	nop			;540b	00		.
	add hl,sp		;540c	39		9
	jr nz,l5448h		;540d	20 39		  9
	ld h,b			;540f	60		`
	nop			;5410	00		.
	nop			;5411	00		.
	nop			;5412	00		.
	nop			;5413	00		.
	jr nc,l5436h		;5414	30 20		0  
	nop			;5416	00		.
	nop			;5417	00		.
	nop			;5418	00		.
	nop			;5419	00		.
	nop			;541a	00		.
	nop			;541b	00		.
	and c			;541c	a1		.
l541dh:
	jr nz,l541fh		;541d	20 00		  .
l541fh:
	nop			;541f	00		.
	nop			;5420	00		.
	nop			;5421	00		.
	nop			;5422	00		.
	nop			;5423	00		.
	or a			;5424	b7		.
	jr nz,l5427h		;5425	20 00		  .
l5427h:
	nop			;5427	00		.
	nop			;5428	00		.
	nop			;5429	00		.
	nop			;542a	00		.
	nop			;542b	00		.
	ret nc			;542c	d0		.
	jr nz,l542fh		;542d	20 00		  .
l542fh:
	nop			;542f	00		.
	nop			;5430	00		.
	nop			;5431	00		.
	nop			;5432	00		.
	nop			;5433	00		.
	or a			;5434	b7		.
	ld h,b			;5435	60		`
l5436h:
	nop			;5436	00		.
	nop			;5437	00		.
	nop			;5438	00		.
	nop			;5439	00		.
	nop			;543a	00		.
	nop			;543b	00		.
	and c			;543c	a1		.
	ld h,b			;543d	60		`
	nop			;543e	00		.
	nop			;543f	00		.
	nop			;5440	00		.
	nop			;5441	00		.
	nop			;5442	00		.
	nop			;5443	00		.
	jr nc,$+98		;5444	30 60		0 `
	nop			;5446	00		.
	nop			;5447	00		.
l5448h:
	nop			;5448	00		.
	nop			;5449	00		.
	nop			;544a	00		.
	nop			;544b	00		.
	ld l,l			;544c	6d		m
	jr nz,l54bch		;544d	20 6d		  m
	ld h,b			;544f	60		`
	nop			;5450	00		.
	nop			;5451	00		.
	nop			;5452	00		.
	nop			;5453	00		.
	ld b,b			;5454	40		@
	jr nz,l5457h		;5455	20 00		  .
l5457h:
	nop			;5457	00		.
	nop			;5458	00		.
	nop			;5459	00		.
	nop			;545a	00		.
	nop			;545b	00		.
	inc (hl)		;545c	34		4
	jr nz,l545fh		;545d	20 00		  .
l545fh:
	nop			;545f	00		.
	nop			;5460	00		.
	nop			;5461	00		.
	nop			;5462	00		.
	nop			;5463	00		.
	dec hl			;5464	2b		+
	jr nz,l5467h		;5465	20 00		  .
l5467h:
	nop			;5467	00		.
	nop			;5468	00		.
	nop			;5469	00		.
	nop			;546a	00		.
	nop			;546b	00		.
	or c			;546c	b1		.
	jr nz,l546fh		;546d	20 00		  .
l546fh:
	nop			;546f	00		.
	nop			;5470	00		.
	nop			;5471	00		.
	nop			;5472	00		.
	nop			;5473	00		.
	dec hl			;5474	2b		+
	ld h,b			;5475	60		`
	nop			;5476	00		.
	nop			;5477	00		.
	nop			;5478	00		.
	nop			;5479	00		.
	nop			;547a	00		.
	nop			;547b	00		.
	inc (hl)		;547c	34		4
	ld h,b			;547d	60		`
	nop			;547e	00		.
	nop			;547f	00		.
	nop			;5480	00		.
	nop			;5481	00		.
	nop			;5482	00		.
	nop			;5483	00		.
	ld b,b			;5484	40		@
	ld h,b			;5485	60		`
	nop			;5486	00		.
	nop			;5487	00		.
	nop			;5488	00		.
	nop			;5489	00		.
	nop			;548a	00		.
	nop			;548b	00		.
	adc a,(hl)		;548c	8e		.
	jr nz,l541dh		;548d	20 8e		  .
	ld h,b			;548f	60		`
	nop			;5490	00		.
	nop			;5491	00		.
	nop			;5492	00		.
	nop			;5493	00		.
	ld (hl),h		;5494	74		t
	jr nz,l5497h		;5495	20 00		  .
l5497h:
	nop			;5497	00		.
	nop			;5498	00		.
	nop			;5499	00		.
	nop			;549a	00		.
	nop			;549b	00		.
	ld d,h			;549c	54		T
	jr nz,l549fh		;549d	20 00		  .
l549fh:
	nop			;549f	00		.
	nop			;54a0	00		.
	nop			;54a1	00		.
	nop			;54a2	00		.
	nop			;54a3	00		.
l54a4h:
	ld c,h			;54a4	4c		L
	jr nz,l54a7h		;54a5	20 00		  .
l54a7h:
	nop			;54a7	00		.
	nop			;54a8	00		.
	nop			;54a9	00		.
	nop			;54aa	00		.
	nop			;54ab	00		.
	dec l			;54ac	2d		-
	jr nz,l54afh		;54ad	20 00		  .
l54afh:
	nop			;54af	00		.
	nop			;54b0	00		.
	nop			;54b1	00		.
	nop			;54b2	00		.
	nop			;54b3	00		.
	ld c,h			;54b4	4c		L
	ld h,b			;54b5	60		`
l54b6h:
	nop			;54b6	00		.
	nop			;54b7	00		.
	nop			;54b8	00		.
	nop			;54b9	00		.
	nop			;54ba	00		.
	nop			;54bb	00		.
l54bch:
	ld d,h			;54bc	54		T
	ld h,b			;54bd	60		`
	nop			;54be	00		.
	nop			;54bf	00		.
	nop			;54c0	00		.
	nop			;54c1	00		.
	nop			;54c2	00		.
	nop			;54c3	00		.
	ld (hl),h		;54c4	74		t
	ld h,b			;54c5	60		`
	nop			;54c6	00		.
	nop			;54c7	00		.
	nop			;54c8	00		.
	nop			;54c9	00		.
	nop			;54ca	00		.
	nop			;54cb	00		.
	push de			;54cc	d5		.
	jr nz,l54a4h		;54cd	20 d5		  .
	ld h,b			;54cf	60		`
	nop			;54d0	00		.
	nop			;54d1	00		.
	nop			;54d2	00		.
	nop			;54d3	00		.
	ld b,b			;54d4	40		@
	and b			;54d5	a0		.
	nop			;54d6	00		.
	nop			;54d7	00		.
	nop			;54d8	00		.
	nop			;54d9	00		.
	nop			;54da	00		.
	nop			;54db	00		.
	inc (hl)		;54dc	34		4
	and b			;54dd	a0		.
	nop			;54de	00		.
	nop			;54df	00		.
	nop			;54e0	00		.
	nop			;54e1	00		.
	nop			;54e2	00		.
	nop			;54e3	00		.
	dec hl			;54e4	2b		+
	and b			;54e5	a0		.
	nop			;54e6	00		.
	nop			;54e7	00		.
	nop			;54e8	00		.
	nop			;54e9	00		.
	nop			;54ea	00		.
	nop			;54eb	00		.
	or c			;54ec	b1		.
	and b			;54ed	a0		.
	nop			;54ee	00		.
	nop			;54ef	00		.
	nop			;54f0	00		.
	nop			;54f1	00		.
	nop			;54f2	00		.
	nop			;54f3	00		.
	dec hl			;54f4	2b		+
	ret po			;54f5	e0		.
	nop			;54f6	00		.
	nop			;54f7	00		.
	nop			;54f8	00		.
	nop			;54f9	00		.
	nop			;54fa	00		.
	nop			;54fb	00		.
	inc (hl)		;54fc	34		4
	ret po			;54fd	e0		.
	nop			;54fe	00		.
	nop			;54ff	00		.
	nop			;5500	00		.
	nop			;5501	00		.
	nop			;5502	00		.
	nop			;5503	00		.
	ld b,b			;5504	40		@
	ret po			;5505	e0		.
	nop			;5506	00		.
	nop			;5507	00		.
	nop			;5508	00		.
	nop			;5509	00		.
	nop			;550a	00		.
	nop			;550b	00		.
	adc a,(hl)		;550c	8e		.
	and b			;550d	a0		.
	adc a,(hl)		;550e	8e		.
	ret po			;550f	e0		.
	nop			;5510	00		.
	nop			;5511	00		.
	nop			;5512	00		.
	nop			;5513	00		.
	jr nc,l54b6h		;5514	30 a0		0 .
	nop			;5516	00		.
	nop			;5517	00		.
	nop			;5518	00		.
	nop			;5519	00		.
	nop			;551a	00		.
	nop			;551b	00		.
	and c			;551c	a1		.
	and b			;551d	a0		.
	nop			;551e	00		.
	nop			;551f	00		.
	nop			;5520	00		.
	nop			;5521	00		.
	nop			;5522	00		.
	nop			;5523	00		.
	or a			;5524	b7		.
	and b			;5525	a0		.
l5526h:
	nop			;5526	00		.
	nop			;5527	00		.
	nop			;5528	00		.
	nop			;5529	00		.
	nop			;552a	00		.
	nop			;552b	00		.
	ret nc			;552c	d0		.
	and b			;552d	a0		.
	nop			;552e	00		.
	nop			;552f	00		.
	nop			;5530	00		.
	nop			;5531	00		.
	nop			;5532	00		.
	nop			;5533	00		.
	or a			;5534	b7		.
	ret po			;5535	e0		.
	nop			;5536	00		.
	nop			;5537	00		.
	nop			;5538	00		.
	nop			;5539	00		.
	nop			;553a	00		.
	nop			;553b	00		.
	and c			;553c	a1		.
	ret po			;553d	e0		.
	nop			;553e	00		.
	nop			;553f	00		.
	nop			;5540	00		.
	nop			;5541	00		.
	nop			;5542	00		.
	nop			;5543	00		.
	jr nc,l5526h		;5544	30 e0		0 .
	nop			;5546	00		.
	nop			;5547	00		.
	nop			;5548	00		.
	nop			;5549	00		.
	nop			;554a	00		.
	nop			;554b	00		.
	ld l,l			;554c	6d		m
	and b			;554d	a0		.
	ld l,l			;554e	6d		m
	ret po			;554f	e0		.
	nop			;5550	00		.
	nop			;5551	00		.
	nop			;5552	00		.
	nop			;5553	00		.
	inc h			;5554	24		$
	and b			;5555	a0		.
	nop			;5556	00		.
	nop			;5557	00		.
	nop			;5558	00		.
	nop			;5559	00		.
	nop			;555a	00		.
	nop			;555b	00		.
	defb 0ddh,0a0h,000h ;illegal sequence	;555c	dd a0 00	. . .
	nop			;555f	00		.
	nop			;5560	00		.
	nop			;5561	00		.
	nop			;5562	00		.
	nop			;5563	00		.
	ld h,c			;5564	61		a
	and b			;5565	a0		.
	nop			;5566	00		.
	nop			;5567	00		.
	nop			;5568	00		.
	nop			;5569	00		.
	nop			;556a	00		.
	nop			;556b	00		.
	inc a			;556c	3c		<
	and b			;556d	a0		.
	nop			;556e	00		.
	nop			;556f	00		.
	nop			;5570	00		.
	nop			;5571	00		.
	nop			;5572	00		.
	nop			;5573	00		.
	ld h,c			;5574	61		a
	ret po			;5575	e0		.
	nop			;5576	00		.
	nop			;5577	00		.
	nop			;5578	00		.
	nop			;5579	00		.
	nop			;557a	00		.
	nop			;557b	00		.
	defb 0ddh,0e0h,000h ;illegal sequence	;557c	dd e0 00	. . .
	nop			;557f	00		.
	nop			;5580	00		.
	nop			;5581	00		.
	nop			;5582	00		.
	nop			;5583	00		.
	inc h			;5584	24		$
	ret po			;5585	e0		.
	nop			;5586	00		.
	nop			;5587	00		.
	nop			;5588	00		.
	nop			;5589	00		.
	nop			;558a	00		.
	nop			;558b	00		.
	add hl,sp		;558c	39		9
	and b			;558d	a0		.
	add hl,sp		;558e	39		9
	ret po			;558f	e0		.
	nop			;5590	00		.
	nop			;5591	00		.
	nop			;5592	00		.
	nop			;5593	00		.
	ld a,(l0020h)		;5594	3a 20 00	:   .
	nop			;5597	00		.
	ld a,(l00a0h)		;5598	3a a0 00	: . .
	nop			;559b	00		.
	adc a,a			;559c	8f		.
	jr nz,l559fh		;559d	20 00		  .
l559fh:
	nop			;559f	00		.
	adc a,a			;55a0	8f		.
	and b			;55a1	a0		.
	nop			;55a2	00		.
	nop			;55a3	00		.
	ld (hl),b		;55a4	70		p
	jr nz,l55a7h		;55a5	20 00		  .
l55a7h:
	nop			;55a7	00		.
	ld (hl),b		;55a8	70		p
	and b			;55a9	a0		.
	nop			;55aa	00		.
	nop			;55ab	00		.
	ld h,(hl)		;55ac	66		f
	jr nz,l55afh		;55ad	20 00		  .
l55afh:
	nop			;55af	00		.
	ld h,(hl)		;55b0	66		f
	and b			;55b1	a0		.
	nop			;55b2	00		.
	nop			;55b3	00		.
	ld (hl),b		;55b4	70		p
	ld h,b			;55b5	60		`
	nop			;55b6	00		.
	nop			;55b7	00		.
	ld (hl),b		;55b8	70		p
	ret po			;55b9	e0		.
	nop			;55ba	00		.
	nop			;55bb	00		.
	adc a,a			;55bc	8f		.
	ld h,b			;55bd	60		`
	nop			;55be	00		.
	nop			;55bf	00		.
	adc a,a			;55c0	8f		.
	ret po			;55c1	e0		.
	nop			;55c2	00		.
	nop			;55c3	00		.
	ld a,(l0060h)		;55c4	3a 60 00	: ` .
	nop			;55c7	00		.
	ld a,(l00e0h)		;55c8	3a e0 00	: . .
	nop			;55cb	00		.
	rst 0			;55cc	c7		.
	jr nz,$-55		;55cd	20 c7		  .
	ld h,b			;55cf	60		`
	rst 0			;55d0	c7		.
	and b			;55d1	a0		.
	rst 0			;55d2	c7		.
	ret po			;55d3	e0		.
sub_55d4h:
	ld hl,0ac43h		;55d4	21 43 ac	! C .
	ld a,(hl)		;55d7	7e		~
	and a			;55d8	a7		.
	ret z			;55d9	c8		.
	dec (hl)		;55da	35		5
	push af			;55db	f5		.
	inc hl			;55dc	23		#
	ld a,(hl)		;55dd	7e		~
	call sub_55f8h		;55de	cd f8 55	. . U
	pop af			;55e1	f1		.
	ret z			;55e2	c8		.
	dec a			;55e3	3d		=
	ld b,000h		;55e4	06 00		. .
	ld c,a			;55e6	4f		O
	ld e,l			;55e7	5d		]
	ld d,h			;55e8	54		T
	inc hl			;55e9	23		#
	ldir			;55ea	ed b0		. .
	ret			;55ec	c9		.
	ld (hl),e		;55ed	73		s
	and (hl)		;55ee	a6		.
	inc d			;55ef	14		.
	ld a,(hl)		;55f0	7e		~
	add hl,hl		;55f1	29		)
	ret m			;55f2	f8		.
	sub (hl)		;55f3	96		.
	ld e,l			;55f4	5d		]
	rla			;55f5	17		.
	sbc a,e			;55f6	9b		.
	cp c			;55f7	b9		.
sub_55f8h:
	ld (SCANLINE_READ_SOUND_COMMAND_WRITE),a	;55f8	32 00 c0	2 . .
	ld a,001h		;55fb	3e 01		> .
	ld (LATCH_SOUND_IRQ),a	;55fd	32 04 c3	2 . .
	nop			;5600	00		.
	nop			;5601	00		.
	nop			;5602	00		.
	nop			;5603	00		.
	nop			;5604	00		.
	nop			;5605	00		.
	ld a,000h		;5606	3e 00		> .
	ld (LATCH_SOUND_IRQ),a	;5608	32 04 c3	2 . .
	ret			;560b	c9		.
l560ch:
	push hl			;560c	e5		.
	push af			;560d	f5		.
	ld a,(0ad30h)		;560e	3a 30 ad	: 0 .
	and a			;5611	a7		.
	jr nz,l562ah		;5612	20 16		  .
	pop af			;5614	f1		.
	pop hl			;5615	e1		.
	ret			;5616	c9		.
l5617h:
	push hl			;5617	e5		.
	push af			;5618	f5		.
	ld a,(0ad30h)		;5619	3a 30 ad	: 0 .
	and a			;561c	a7		.
	jr nz,l562ah		;561d	20 0b		  .
	ld a,(0a9c6h)		;561f	3a c6 a9	: . .
	and a			;5622	a7		.
	jr nz,l562ah		;5623	20 05		  .
	pop af			;5625	f1		.
	pop hl			;5626	e1		.
	ret			;5627	c9		.
sub_5628h:
	push hl			;5628	e5		.
	push af			;5629	f5		.
l562ah:
	ld hl,0ac43h		;562a	21 43 ac	! C .
	inc (hl)		;562d	34		4
	ld a,(hl)		;562e	7e		~
	rst 8			;562f	cf		.
	pop af			;5630	f1		.
	ld (hl),a		;5631	77		w
	pop hl			;5632	e1		.
	ret			;5633	c9		.
sub_5634h:
	ld a,(l167bh+1)		;5634	3a 7c 16	: | .
	call sub_5628h		;5637	cd 28 56	. ( V
	ld a,(l0a9ch)		;563a	3a 9c 0a	: . .
	call sub_5628h		;563d	cd 28 56	. ( V
	ld a,(01484h)		;5640	3a 84 14	: . .
	call sub_5628h		;5643	cd 28 56	. ( V
	ld a,(l0c78h)		;5646	3a 78 0c	: x .
	call sub_5628h		;5649	cd 28 56	. ( V
	ld a,(sub_07d2h+1)	;564c	3a d3 07	: . .
	call sub_5628h		;564f	cd 28 56	. ( V
	ld a,(033b4h)		;5652	3a b4 33	: . 3
	call sub_5628h		;5655	cd 28 56	. ( V
	ld a,(0ad04h)		;5658	3a 04 ad	: . .
	add a,08ch		;565b	c6 8c		. .
	jr sub_5628h		;565d	18 c9		. .
sub_565fh:
	ld a,(l07a0h+2)		;565f	3a a2 07	: . .
	jr l560ch		;5662	18 a8		. .
l5664h:
	ld a,(016deh)		;5664	3a de 16	: . .
	jr l560ch		;5667	18 a3		. .
l5669h:
	ld a,(04c9fh)		;5669	3a 9f 4c	: . L
	jr l560ch		;566c	18 9e		. .
l566eh:
	ld a,(l07d8h)		;566e	3a d8 07	: . .
	call l560ch		;5671	cd 0c 56	. . V
l5674h:
	ld a,(0276bh)		;5674	3a 6b 27	: k '
	jr l560ch		;5677	18 93		. .
sub_5679h:
	ld a,(007feh)		;5679	3a fe 07	: . .
	jr l560ch		;567c	18 8e		. .
sub_567eh:
	ld a,(03270h)		;567e	3a 70 32	: p 2
	jr l5617h		;5681	18 94		. .
sub_5683h:
	ld a,(l07a4h+2)		;5683	3a a6 07	: . .
	call l5617h		;5686	cd 17 56	. . V
	ld a,(04cdah)		;5689	3a da 4c	: . L
	jr l5617h		;568c	18 89		. .
l568eh:
	ld a,(02d87h)		;568e	3a 87 2d	: . -
	jp l560ch		;5691	c3 0c 56	. . V
	ld c,000h		;5694	0e 00		. .
	ld hl,l0831h		;5696	21 31 08	! 1 .
	ld a,(0a9abh)		;5699	3a ab a9	: . .
l569ch:
	sub (hl)		;569c	96		.
	inc hl			;569d	23		#
	dec c			;569e	0d		.
	jr nz,l569ch		;569f	20 fb		  .
	xor 0c2h		;56a1	ee c2		. .
	ld (0a9abh),a		;56a3	32 ab a9	2 . .
	call SPRITE_RASTER_REWRITE_IF_DUE	;56a6	cd 97 0f	. . .
	call sub_1edfh		;56a9	cd df 1e	. . .
	call SPRITE_RASTER_REWRITE_IF_DUE	;56ac	cd 97 0f	. . .
	call sub_2cbch		;56af	cd bc 2c	. . ,
	call sub_23e3h		;56b2	cd e3 23	. . #
	call SPRITE_RASTER_REWRITE_WAIT	;56b5	cd 98 10	. . .
	ld hl,0a9ebh		;56b8	21 eb a9	! . .
	dec (hl)		;56bb	35		5
	ret nz			;56bc	c0		.
	ld c,000h		;56bd	0e 00		. .
	ld hl,l12a7h		;56bf	21 a7 12	! . .
	ld a,(0a9abh)		;56c2	3a ab a9	: . .
l56c5h:
	sub (hl)		;56c5	96		.
	inc hl			;56c6	23		#
	dec c			;56c7	0d		.
	jr nz,l56c5h		;56c8	20 fb		  .
	xor 059h		;56ca	ee 59		. Y
	ld (0a9abh),a		;56cc	32 ab a9	2 . .
	jp sub_0f1ah		;56cf	c3 1a 0f	. . .
sub_56d2h:
	ld a,(l0c5bh)		;56d2	3a 5b 0c	: [ .
	call l560ch		;56d5	cd 0c 56	. . V
	ld a,(00855h)		;56d8	3a 55 08	: U .
	call l560ch		;56db	cd 0c 56	. . V
	ld a,(l1675h)		;56de	3a 75 16	: u .
	call l560ch		;56e1	cd 0c 56	. . V
sub_56e4h:
	ld a,(027cbh)		;56e4	3a cb 27	: . '
	call l5617h		;56e7	cd 17 56	. . V
	ld a,(l33a0h)		;56ea	3a a0 33	: . 3
	jp l5617h		;56ed	c3 17 56	. . V
	rst 38h			;56f0	ff		.
l56f1h:
	nop			;56f1	00		.
	ld bc,RESET_VECTOR	;56f2	01 00 00	. . .
	nop			;56f5	00		.
	nop			;56f6	00		.
	nop			;56f7	00		.
	nop			;56f8	00		.
	nop			;56f9	00		.
	nop			;56fa	00		.
	nop			;56fb	00		.
	nop			;56fc	00		.
	nop			;56fd	00		.
	nop			;56fe	00		.
	nop			;56ff	00		.
	nop			;5700	00		.
	ld bc,RESET_VECTOR	;5701	01 00 00	. . .
	nop			;5704	00		.
	nop			;5705	00		.
	nop			;5706	00		.
	nop			;5707	00		.
	nop			;5708	00		.
	nop			;5709	00		.
	nop			;570a	00		.
	nop			;570b	00		.
	nop			;570c	00		.
	nop			;570d	00		.
	nop			;570e	00		.
	nop			;570f	00		.
	ld bc,RESET_VECTOR+1	;5710	01 01 00	. . .
	nop			;5713	00		.
	nop			;5714	00		.
	nop			;5715	00		.
	nop			;5716	00		.
	nop			;5717	00		.
	nop			;5718	00		.
	nop			;5719	00		.
	nop			;571a	00		.
	nop			;571b	00		.
	nop			;571c	00		.
	nop			;571d	00		.
	nop			;571e	00		.
	nop			;571f	00		.
	nop			;5720	00		.
	ld bc,RESET_VECTOR	;5721	01 00 00	. . .
	nop			;5724	00		.
	nop			;5725	00		.
	nop			;5726	00		.
	nop			;5727	00		.
	nop			;5728	00		.
	nop			;5729	00		.
	nop			;572a	00		.
	nop			;572b	00		.
	nop			;572c	00		.
	nop			;572d	00		.
	ld bc,RESET_VECTOR	;572e	01 00 00	. . .
	ld bc,RESET_VECTOR+1	;5731	01 01 00	. . .
	nop			;5734	00		.
	nop			;5735	00		.
	nop			;5736	00		.
	nop			;5737	00		.
	nop			;5738	00		.
	nop			;5739	00		.
	nop			;573a	00		.
	nop			;573b	00		.
	nop			;573c	00		.
	nop			;573d	00		.
	nop			;573e	00		.
	nop			;573f	00		.
	nop			;5740	00		.
	nop			;5741	00		.
	ld bc,RESET_VECTOR+1	;5742	01 01 00	. . .
	nop			;5745	00		.
	nop			;5746	00		.
	nop			;5747	00		.
	nop			;5748	00		.
	nop			;5749	00		.
	nop			;574a	00		.
	nop			;574b	00		.
	ld bc,RESET_VECTOR	;574c	01 00 00	. . .
	nop			;574f	00		.
	nop			;5750	00		.
	nop			;5751	00		.
	nop			;5752	00		.
	ld bc,l0101h		;5753	01 01 01	. . .
	nop			;5756	00		.
	nop			;5757	00		.
	nop			;5758	00		.
	nop			;5759	00		.
	nop			;575a	00		.
	nop			;575b	00		.
	nop			;575c	00		.
	nop			;575d	00		.
	nop			;575e	00		.
	nop			;575f	00		.
	nop			;5760	00		.
	nop			;5761	00		.
	nop			;5762	00		.
	nop			;5763	00		.
	nop			;5764	00		.
	ld bc,l0101h		;5765	01 01 01	. . .
	ld bc,l0100h		;5768	01 00 01	. . .
	nop			;576b	00		.
	nop			;576c	00		.
	nop			;576d	00		.
	nop			;576e	00		.
	nop			;576f	00		.
	nop			;5770	00		.
	nop			;5771	00		.
	nop			;5772	00		.
	nop			;5773	00		.
	nop			;5774	00		.
	nop			;5775	00		.
	nop			;5776	00		.
	nop			;5777	00		.
	nop			;5778	00		.
	ld bc,RESET_VECTOR+1	;5779	01 01 00	. . .
	nop			;577c	00		.
	nop			;577d	00		.
	nop			;577e	00		.
	nop			;577f	00		.
	nop			;5780	00		.
	nop			;5781	00		.
	nop			;5782	00		.
	nop			;5783	00		.
	nop			;5784	00		.
	nop			;5785	00		.
	nop			;5786	00		.
	nop			;5787	00		.
	ld bc,l0100h		;5788	01 00 01	. . .
	nop			;578b	00		.
	nop			;578c	00		.
	nop			;578d	00		.
	nop			;578e	00		.
	nop			;578f	00		.
	nop			;5790	00		.
	nop			;5791	00		.
	nop			;5792	00		.
	nop			;5793	00		.
	nop			;5794	00		.
	nop			;5795	00		.
	nop			;5796	00		.
	ld bc,RESET_VECTOR	;5797	01 00 00	. . .
	ld bc,RESET_VECTOR+1	;579a	01 01 00	. . .
	nop			;579d	00		.
	nop			;579e	00		.
	nop			;579f	00		.
	nop			;57a0	00		.
	nop			;57a1	00		.
	nop			;57a2	00		.
	nop			;57a3	00		.
	nop			;57a4	00		.
	nop			;57a5	00		.
	ld bc,RESET_VECTOR+1	;57a6	01 01 00	. . .
	nop			;57a9	00		.
	nop			;57aa	00		.
	ld bc,l0101h		;57ab	01 01 01	. . .
	nop			;57ae	00		.
	nop			;57af	00		.
	nop			;57b0	00		.
	nop			;57b1	00		.
	nop			;57b2	00		.
	nop			;57b3	00		.
	ld bc,RESET_VECTOR+1	;57b4	01 01 00	. . .
	ld bc,RESET_VECTOR+1	;57b7	01 01 00	. . .
	nop			;57ba	00		.
	nop			;57bb	00		.
	nop			;57bc	00		.
	ld bc,RESET_VECTOR+1	;57bd	01 01 00	. . .
	nop			;57c0	00		.
	nop			;57c1	00		.
	nop			;57c2	00		.
	ld bc,l0101h		;57c3	01 01 01	. . .
	nop			;57c6	00		.
	nop			;57c7	00		.
	ld bc,l0101h		;57c8	01 01 01	. . .
	nop			;57cb	00		.
	nop			;57cc	00		.
	nop			;57cd	00		.
	nop			;57ce	00		.
	nop			;57cf	00		.
	nop			;57d0	00		.
	nop			;57d1	00		.
	ld bc,RESET_VECTOR+1	;57d2	01 01 00	. . .
	ld bc,RESET_VECTOR+1	;57d5	01 01 00	. . .
	nop			;57d8	00		.
	nop			;57d9	00		.
	nop			;57da	00		.
	nop			;57db	00		.
	nop			;57dc	00		.
	nop			;57dd	00		.
	nop			;57de	00		.
	nop			;57df	00		.
	nop			;57e0	00		.
	ld bc,l0100h		;57e1	01 00 01	. . .
	nop			;57e4	00		.
	nop			;57e5	00		.
	nop			;57e6	00		.
	nop			;57e7	00		.
	nop			;57e8	00		.
	nop			;57e9	00		.
	nop			;57ea	00		.
	nop			;57eb	00		.
	nop			;57ec	00		.
	nop			;57ed	00		.
	nop			;57ee	00		.
	nop			;57ef	00		.
	rst 38h			;57f0	ff		.
sub_57f1h:
	ld a,(0322eh)		;57f1	3a 2e 32	: . 2
	jp sub_5628h		;57f4	c3 28 56	. ( V
l57f7h:
	ld a,(0ad04h)		;57f7	3a 04 ad	: . .
	add a,00ch		;57fa	c6 0c		. .
	jp l560ch		;57fc	c3 0c 56	. . V
sub_57ffh:
	ld a,(l079bh)		;57ff	3a 9b 07	: . .
	jp l560ch		;5802	c3 0c 56	. . V
l5805h:
	ld a,(02d4eh)		;5805	3a 4e 2d	: N -
	jp l560ch		;5808	c3 0c 56	. . V
sub_580bh:
	ld a,(049eeh)		;580b	3a ee 49	: . I
	jp l560ch		;580e	c3 0c 56	. . V
sub_5811h:
	ld a,(007a9h)		;5811	3a a9 07	: . .
	jp l560ch		;5814	c3 0c 56	. . V
l5817h:
	ld a,(0273ah)		;5817	3a 3a 27	: : '
	jp l560ch		;581a	c3 0c 56	. . V
	inc c			;581d	0c		.
	and a			;581e	a7		.
	inc de			;581f	13		.
	adc a,b			;5820	88		.
	ld d,a			;5821	57		W
	inc (hl)		;5822	34		4
	and l			;5823	a5		.
	defb 0edh ;next byte illegal after ed	;5824	ed		.
	inc (hl)		;5825	34		4
	pop af			;5826	f1		.
	add a,a			;5827	87		.
	inc (hl)		;5828	34		4
	adc a,b			;5829	88		.
	ld l,b			;582a	68		h
	defb 0edh ;next byte illegal after ed	;582b	ed		.
	defb 0fdh,0dch,0f1h ;illegal sequence	;582c	fd dc f1	. . .
	ld (hl),a		;582f	77		w
	ld l,b			;5830	68		h
	defb 0fdh,03bh,0b9h ;illegal sequence	;5831	fd 3b b9	. ; .
sub_5834h:
	ld a,(01767h)		;5834	3a 67 17	: g .
	jp l560ch		;5837	c3 0c 56	. . V
sub_583ah:
	ld a,(018fah)		;583a	3a fa 18	: . .
	jp l560ch		;583d	c3 0c 56	. . V
sub_5840h:
	ld hl,l59d7h		;5840	21 d7 59	! . Y
	jp l58bch		;5843	c3 bc 58	. . X
	ld hl,l5c00h		;5846	21 00 5c	! . \
	jp l58bch		;5849	c3 bc 58	. . X
	ld h,b			;584c	60		`
	and a			;584d	a7		.
	inc d			;584e	14		.
	sub (hl)		;584f	96		.
	djnz $+15		;5850	10 0d		. .
	adc a,b			;5852	88		.
	cp c			;5853	b9		.
sub_5854h:
	ld hl,l5e00h		;5854	21 00 5e	! . ^
	jp l58bch		;5857	c3 bc 58	. . X
	ld hl,l2530h		;585a	21 30 25	! 0 %
	jp l58bch		;585d	c3 bc 58	. . X
l5860h:
	ld hl,l2e3eh		;5860	21 3e 2e	! > .
	jp l58bch		;5863	c3 bc 58	. . X
l5866h:
	ld hl,(l2581h)		;5866	2a 81 25	* . %
	ld bc,00400h		;5869	01 00 04	. . .
	ld d,010h		;586c	16 10		. .
l586eh:
	ld (hl),d		;586e	72		r
	inc hl			;586f	23		#
	dec bc			;5870	0b		.
	ld a,c			;5871	79		y
	or b			;5872	b0		.
	jr nz,l586eh		;5873	20 f9		  .
	ld (DSW2_READ_WATCHDOG_WRITE),a	;5875	32 00 c2	2 . .
	ld hl,(04a37h)		;5878	2a 37 4a	* 7 J
	ld bc,00400h		;587b	01 00 04	. . .
	ld d,0f1h		;587e	16 f1		. .
l5880h:
	ld (hl),d		;5880	72		r
	inc hl			;5881	23		#
	dec bc			;5882	0b		.
	ld a,c			;5883	79		y
	or b			;5884	b0		.
	jr nz,l5880h		;5885	20 f9		  .
	ld hl,RESET_VECTOR	;5887	21 00 00	! . .
	ld a,(RESET_VECTOR)	;588a	3a 00 00	: . .
l588dh:
	add a,(hl)		;588d	86		.
	inc hl			;588e	23		#
	ex af,af'		;588f	08		.
	ld a,h			;5890	7c		|
	cp 060h			;5891	fe 60		. `
	jr nc,l589bh		;5893	30 06		0 .
	ex af,af'		;5895	08		.
	ld (DSW2_READ_WATCHDOG_WRITE),a	;5896	32 00 c2	2 . .
	jr l588dh		;5899	18 f2		. .
l589bh:
	ex af,af'		;589b	08		.
	sub 0afh		;589c	d6 af		. .
	jp nz,l59d7h		;589e	c2 d7 59	. . Y
	jp l2511h		;58a1	c3 11 25	. . %
sub_58a4h:
	ld hl,l08fah		;58a4	21 fa 08	! . .
	jp l58bch		;58a7	c3 bc 58	. . X
l58aah:
	ld hl,l59d7h		;58aa	21 d7 59	! . Y
	jp l58feh		;58ad	c3 fe 58	. . X
	ld hl,l5c00h		;58b0	21 00 5c	! . \
	jp l58feh		;58b3	c3 fe 58	. . X
sub_58b6h:
	ld hl,l5e00h		;58b6	21 00 5e	! . ^
	jp l58feh		;58b9	c3 fe 58	. . X
l58bch:
	ld a,(ix+002h)		;58bc	dd 7e 02	. ~ .
	ld c,a			;58bf	4f		O
	add a,a			;58c0	87		.
	jr nc,l58c4h		;58c1	30 01		0 .
	inc h			;58c3	24		$
l58c4h:
	add a,l			;58c4	85		.
	ld l,a			;58c5	6f		o
	jr nc,l58c9h		;58c6	30 01		0 .
	inc h			;58c8	24		$
l58c9h:
	ld e,(hl)		;58c9	5e		^
	inc hl			;58ca	23		#
	ld d,(hl)		;58cb	56		V
	ld a,c			;58cc	79		y
	add a,0c0h		;58cd	c6 c0		. .
	ld bc,l0180h		;58cf	01 80 01	. . .
	jr nc,l58d7h		;58d2	30 03		0 .
	ld bc,0ff80h		;58d4	01 80 ff	. . .
l58d7h:
	add hl,bc		;58d7	09		.
	ld b,(hl)		;58d8	46		F
	dec hl			;58d9	2b		+
	ld c,(hl)		;58da	4e		N
	ld hl,(0a808h)		;58db	2a 08 a8	* . .
	add hl,de		;58de	19		.
	ld e,(ix+003h)		;58df	dd 5e 03	. ^ .
	ld d,(iy+031h)		;58e2	fd 56 31	. V 1
	add hl,de		;58e5	19		.
	ld (ix+003h),l		;58e6	dd 75 03	. u .
	ld (iy+031h),h		;58e9	fd 74 31	. t 1
	ld hl,(0a80ah)		;58ec	2a 0a a8	* . .
	add hl,bc		;58ef	09		.
	ld e,(ix+005h)		;58f0	dd 5e 05	. ^ .
	ld d,(iy+000h)		;58f3	fd 56 00	. V .
	add hl,de		;58f6	19		.
	ld (ix+005h),l		;58f7	dd 75 05	. u .
	ld (iy+000h),h		;58fa	fd 74 00	. t .
	ret			;58fd	c9		.
l58feh:
	ld a,(ix+002h)		;58fe	dd 7e 02	. ~ .
	ld c,a			;5901	4f		O
	add a,a			;5902	87		.
	jr nc,l5906h		;5903	30 01		0 .
	inc h			;5905	24		$
l5906h:
	add a,l			;5906	85		.
	ld l,a			;5907	6f		o
	jr nc,l590bh		;5908	30 01		0 .
	inc h			;590a	24		$
l590bh:
	ld e,(hl)		;590b	5e		^
	inc hl			;590c	23		#
l590dh:
	ld d,(hl)		;590d	56		V
	ld a,c			;590e	79		y
	add a,0c0h		;590f	c6 c0		. .
	ld bc,l0180h		;5911	01 80 01	. . .
	jr nc,l5919h		;5914	30 03		0 .
	ld bc,0ff80h		;5916	01 80 ff	. . .
l5919h:
	add hl,bc		;5919	09		.
	ld b,(hl)		;591a	46		F
	dec hl			;591b	2b		+
	ld c,(hl)		;591c	4e		N
	ld hl,(0a808h)		;591d	2a 08 a8	* . .
	add hl,de		;5920	19		.
	add hl,de		;5921	19		.
	ld e,(ix+003h)		;5922	dd 5e 03	. ^ .
	ld d,(iy+031h)		;5925	fd 56 31	. V 1
	add hl,de		;5928	19		.
	ld (ix+003h),l		;5929	dd 75 03	. u .
	ld (iy+031h),h		;592c	fd 74 31	. t 1
	ld hl,(0a80ah)		;592f	2a 0a a8	* . .
	add hl,bc		;5932	09		.
	add hl,bc		;5933	09		.
	ld e,(ix+005h)		;5934	dd 5e 05	. ^ .
	ld d,(iy+000h)		;5937	fd 56 00	. V .
	add hl,de		;593a	19		.
	ld (ix+005h),l		;593b	dd 75 05	. u .
	ld (iy+000h),h		;593e	fd 74 00	. t .
	ret			;5941	c9		.
sub_5942h:
	ld hl,l59d7h		;5942	21 d7 59	! . Y
	jp l596eh		;5945	c3 6e 59	. n Y
	ld hl,l5c00h		;5948	21 00 5c	! . \
	jp l596eh		;594b	c3 6e 59	. n Y
l594eh:
	ld hl,l5e00h		;594e	21 00 5e	! . ^
	jp l596eh		;5951	c3 6e 59	. n Y
	ld (hl),e		;5954	73		s
	and (hl)		;5955	a6		.
	inc d			;5956	14		.
	ld a,(hl)		;5957	7e		~
	add hl,hl		;5958	29		)
	ret m			;5959	f8		.
	sub (hl)		;595a	96		.
	ld e,l			;595b	5d		]
	ld (bc),a		;595c	02		.
	inc de			;595d	13		.
	cp c			;595e	b9		.
	ld hl,l2530h		;595f	21 30 25	! 0 %
	jp l596eh		;5962	c3 6e 59	. n Y
l5965h:
	ld hl,l2e3eh		;5965	21 3e 2e	! > .
	jp l596eh		;5968	c3 6e 59	. n Y
l596bh:
	ld hl,l08fah		;596b	21 fa 08	! . .
l596eh:
	ld a,(ix+002h)		;596e	dd 7e 02	. ~ .
	ld c,a			;5971	4f		O
	add a,a			;5972	87		.
	jr nc,l5976h		;5973	30 01		0 .
	inc h			;5975	24		$
l5976h:
	add a,l			;5976	85		.
	ld l,a			;5977	6f		o
	jr nc,l597bh		;5978	30 01		0 .
	inc h			;597a	24		$
l597bh:
	ld e,(hl)		;597b	5e		^
	inc hl			;597c	23		#
	ld d,(hl)		;597d	56		V
	ld a,c			;597e	79		y
	add a,0c0h		;597f	c6 c0		. .
	ld bc,l0180h		;5981	01 80 01	. . .
	jr nc,l5989h		;5984	30 03		0 .
	ld bc,0ff80h		;5986	01 80 ff	. . .
l5989h:
	add hl,bc		;5989	09		.
	ld b,(hl)		;598a	46		F
	dec hl			;598b	2b		+
	ld c,(hl)		;598c	4e		N
	ret			;598d	c9		.
sub_598eh:
	ld hl,l59d7h		;598e	21 d7 59	! . Y
	jp l599dh		;5991	c3 9d 59	. . Y
	ld hl,l5c00h		;5994	21 00 5c	! . \
	jp l599dh		;5997	c3 9d 59	. . Y
	ld hl,l5e00h		;599a	21 00 5e	! . ^
l599dh:
	ld a,(ix+002h)		;599d	dd 7e 02	. ~ .
l59a0h:
	ld c,a			;59a0	4f		O
	add a,a			;59a1	87		.
	jr nc,l59a5h		;59a2	30 01		0 .
	inc h			;59a4	24		$
l59a5h:
	add a,l			;59a5	85		.
	ld l,a			;59a6	6f		o
	jr nc,l59aah		;59a7	30 01		0 .
	inc h			;59a9	24		$
l59aah:
	ld e,(hl)		;59aa	5e		^
	inc hl			;59ab	23		#
	ld d,(hl)		;59ac	56		V
	sla e			;59ad	cb 23		. #
	rl d			;59af	cb 12		. .
	ld a,c			;59b1	79		y
	add a,0c0h		;59b2	c6 c0		. .
	ld bc,l0180h		;59b4	01 80 01	. . .
	jr nc,l59bch		;59b7	30 03		0 .
	ld bc,0ff80h		;59b9	01 80 ff	. . .
l59bch:
	add hl,bc		;59bc	09		.
	ld b,(hl)		;59bd	46		F
	dec hl			;59be	2b		+
	ld c,(hl)		;59bf	4e		N
	sla c			;59c0	cb 21		. !
	rl b			;59c2	cb 10		. .
	ret			;59c4	c9		.
sub_59c5h:
	ld hl,l59d7h		;59c5	21 d7 59	! . Y
	jp l59a0h		;59c8	c3 a0 59	. . Y
sub_59cbh:
	ld hl,l5c00h		;59cb	21 00 5c	! . \
	jp l59a0h		;59ce	c3 a0 59	. . Y
sub_59d1h:
	ld hl,l5e00h		;59d1	21 00 5e	! . ^
	jp l59a0h		;59d4	c3 a0 59	. . Y
l59d7h:
	adc a,000h		;59d7	ce 00		. .
	call 0cc00h		;59d9	cd 00 cc	. . .
	nop			;59dc	00		.
l59ddh:
	rlc b			;59dd	cb 00		. .
	jp z,0c900h		;59df	ca 00 c9	. . .
	nop			;59e2	00		.
	ret z			;59e3	c8		.
	nop			;59e4	00		.
	ret z			;59e5	c8		.
	nop			;59e6	00		.
	add a,000h		;59e7	c6 00		. .
	call nz,DSW2_READ_WATCHDOG_WRITE	;59e9	c4 00 c2	. . .
	nop			;59ec	00		.
	ret nz			;59ed	c0		.
	nop			;59ee	00		.
	cp a			;59ef	bf		.
	nop			;59f0	00		.
	cp h			;59f1	bc		.
	nop			;59f2	00		.
	cp d			;59f3	ba		.
	nop			;59f4	00		.
	cp c			;59f5	b9		.
	nop			;59f6	00		.
	or (hl)			;59f7	b6		.
	nop			;59f8	00		.
	or e			;59f9	b3		.
	nop			;59fa	00		.
	or b			;59fb	b0		.
	nop			;59fc	00		.
	xor a			;59fd	af		.
	nop			;59fe	00		.
	xor h			;59ff	ac		.
	nop			;5a00	00		.
	xor c			;5a01	a9		.
	nop			;5a02	00		.
	xor b			;5a03	a8		.
	nop			;5a04	00		.
	and l			;5a05	a5		.
	nop			;5a06	00		.
	and d			;5a07	a2		.
	nop			;5a08	00		.
	and c			;5a09	a1		.
	nop			;5a0a	00		.
	sbc a,(hl)		;5a0b	9e		.
	nop			;5a0c	00		.
	sbc a,e			;5a0d	9b		.
	nop			;5a0e	00		.
	sbc a,b			;5a0f	98		.
	nop			;5a10	00		.
	sub a			;5a11	97		.
	nop			;5a12	00		.
	sub h			;5a13	94		.
	nop			;5a14	00		.
	sub c			;5a15	91		.
	nop			;5a16	00		.
	sub b			;5a17	90		.
	nop			;5a18	00		.
	adc a,l			;5a19	8d		.
	nop			;5a1a	00		.
	adc a,c			;5a1b	89		.
	nop			;5a1c	00		.
	adc a,b			;5a1d	88		.
	nop			;5a1e	00		.
	add a,l			;5a1f	85		.
	nop			;5a20	00		.
	add a,c			;5a21	81		.
	nop			;5a22	00		.
	ld a,a			;5a23	7f		.
	nop			;5a24	00		.
	ld a,e			;5a25	7b		{
	nop			;5a26	00		.
	ld a,b			;5a27	78		x
	nop			;5a28	00		.
	halt			;5a29	76		v
	nop			;5a2a	00		.
	ld (hl),b		;5a2b	70		p
	nop			;5a2c	00		.
	ld l,l			;5a2d	6d		m
	nop			;5a2e	00		.
	ld l,b			;5a2f	68		h
	nop			;5a30	00		.
	ld h,e			;5a31	63		c
	nop			;5a32	00		.
	ld h,b			;5a33	60		`
	nop			;5a34	00		.
	ld e,h			;5a35	5c		\
	nop			;5a36	00		.
	ld e,b			;5a37	58		X
	nop			;5a38	00		.
	ld d,d			;5a39	52		R
	nop			;5a3a	00		.
	ld c,(hl)		;5a3b	4e		N
	nop			;5a3c	00		.
	ld c,c			;5a3d	49		I
	nop			;5a3e	00		.
	ld b,e			;5a3f	43		C
	nop			;5a40	00		.
	ld a,000h		;5a41	3e 00		> .
	add hl,sp		;5a43	39		9
	nop			;5a44	00		.
	ld (02c00h),a		;5a45	32 00 2c	2 . ,
	nop			;5a48	00		.
	daa			;5a49	27		'
	nop			;5a4a	00		.
	jr nz,l5a4dh		;5a4b	20 00		  .
l5a4dh:
	ld a,(de)		;5a4d	1a		.
	nop			;5a4e	00		.
	inc d			;5a4f	14		.
	nop			;5a50	00		.
	ld c,000h		;5a51	0e 00		. .
	ex af,af'		;5a53	08		.
	nop			;5a54	00		.
	nop			;5a55	00		.
	nop			;5a56	00		.
	nop			;5a57	00		.
	nop			;5a58	00		.
	ret m			;5a59	f8		.
	rst 38h			;5a5a	ff		.
	jp p,l00fdh+2		;5a5b	f2 ff 00	. . .
	nop			;5a5e	00		.
	and 0ffh		;5a5f	e6 ff		. .
	ret po			;5a61	e0		.
	rst 38h			;5a62	ff		.
	exx			;5a63	d9		.
	rst 38h			;5a64	ff		.
	call nc,0ceffh		;5a65	d4 ff ce	. . .
	rst 38h			;5a68	ff		.
	rst 0			;5a69	c7		.
	rst 38h			;5a6a	ff		.
	jp nz,0bdffh		;5a6b	c2 ff bd	. . .
	rst 38h			;5a6e	ff		.
	or a			;5a6f	b7		.
	rst 38h			;5a70	ff		.
	or d			;5a71	b2		.
	rst 38h			;5a72	ff		.
	xor (hl)		;5a73	ae		.
	rst 38h			;5a74	ff		.
	xor b			;5a75	a8		.
	rst 38h			;5a76	ff		.
	and h			;5a77	a4		.
	rst 38h			;5a78	ff		.
	and b			;5a79	a0		.
	rst 38h			;5a7a	ff		.
	sbc a,l			;5a7b	9d		.
	rst 38h			;5a7c	ff		.
	and b			;5a7d	a0		.
	rst 38h			;5a7e	ff		.
	sub e			;5a7f	93		.
	rst 38h			;5a80	ff		.
	sub b			;5a81	90		.
	rst 38h			;5a82	ff		.
	adc a,d			;5a83	8a		.
	rst 38h			;5a84	ff		.
	adc a,b			;5a85	88		.
	rst 38h			;5a86	ff		.
	add a,l			;5a87	85		.
	rst 38h			;5a88	ff		.
	add a,c			;5a89	81		.
	rst 38h			;5a8a	ff		.
	ld a,a			;5a8b	7f		.
	rst 38h			;5a8c	ff		.
	ld a,e			;5a8d	7b		{
	rst 38h			;5a8e	ff		.
	ld a,b			;5a8f	78		x
	rst 38h			;5a90	ff		.
	ld (hl),a		;5a91	77		w
	rst 38h			;5a92	ff		.
	ld (hl),e		;5a93	73		s
	rst 38h			;5a94	ff		.
	ld (hl),b		;5a95	70		p
	rst 38h			;5a96	ff		.
	ld l,a			;5a97	6f		o
	rst 38h			;5a98	ff		.
	ld l,h			;5a99	6c		l
	rst 38h			;5a9a	ff		.
	ld l,c			;5a9b	69		i
	rst 38h			;5a9c	ff		.
	ld l,c			;5a9d	69		i
	rst 38h			;5a9e	ff		.
	ld h,l			;5a9f	65		e
	rst 38h			;5aa0	ff		.
	ld h,d			;5aa1	62		b
	rst 38h			;5aa2	ff		.
	ld e,a			;5aa3	5f		_
	rst 38h			;5aa4	ff		.
	ld e,(hl)		;5aa5	5e		^
	rst 38h			;5aa6	ff		.
	ld e,e			;5aa7	5b		[
	rst 38h			;5aa8	ff		.
	ld e,b			;5aa9	58		X
	rst 38h			;5aaa	ff		.
	ld d,a			;5aab	57		W
	rst 38h			;5aac	ff		.
	ld d,h			;5aad	54		T
	rst 38h			;5aae	ff		.
	ld d,c			;5aaf	51		Q
	rst 38h			;5ab0	ff		.
	ld d,b			;5ab1	50		P
	rst 38h			;5ab2	ff		.
	ld c,l			;5ab3	4d		M
	rst 38h			;5ab4	ff		.
	ld c,d			;5ab5	4a		J
	rst 38h			;5ab6	ff		.
	ld b,a			;5ab7	47		G
	rst 38h			;5ab8	ff		.
	ld b,(hl)		;5ab9	46		F
	rst 38h			;5aba	ff		.
	ld b,h			;5abb	44		D
	rst 38h			;5abc	ff		.
	ld b,c			;5abd	41		A
	rst 38h			;5abe	ff		.
	ld b,b			;5abf	40		@
	rst 38h			;5ac0	ff		.
	ld a,0ffh		;5ac1	3e ff		> .
	inc a			;5ac3	3c		<
	rst 38h			;5ac4	ff		.
	ld a,(l38ffh)		;5ac5	3a ff 38	: . 8
	rst 38h			;5ac8	ff		.
	jr c,$+1		;5ac9	38 ff		8 .
	scf			;5acb	37		7
	rst 38h			;5acc	ff		.
	ld (hl),0ffh		;5acd	36 ff		6 .
	dec (hl)		;5acf	35		5
	rst 38h			;5ad0	ff		.
	inc (hl)		;5ad1	34		4
	rst 38h			;5ad2	ff		.
	inc sp			;5ad3	33		3
	rst 38h			;5ad4	ff		.
	ld (l32ffh),a		;5ad5	32 ff 32	2 . 2
	rst 38h			;5ad8	ff		.
	inc sp			;5ad9	33		3
	rst 38h			;5ada	ff		.
	inc (hl)		;5adb	34		4
	rst 38h			;5adc	ff		.
	dec (hl)		;5add	35		5
	rst 38h			;5ade	ff		.
	ld (hl),0ffh		;5adf	36 ff		6 .
	scf			;5ae1	37		7
	rst 38h			;5ae2	ff		.
	jr c,$+1		;5ae3	38 ff		8 .
	jr c,$+1		;5ae5	38 ff		8 .
	ld a,(l3cffh)		;5ae7	3a ff 3c	: . <
	rst 38h			;5aea	ff		.
	ld a,0ffh		;5aeb	3e ff		> .
	ld b,b			;5aed	40		@
	rst 38h			;5aee	ff		.
	ld b,c			;5aef	41		A
	rst 38h			;5af0	ff		.
	ld b,h			;5af1	44		D
	rst 38h			;5af2	ff		.
	ld b,(hl)		;5af3	46		F
	rst 38h			;5af4	ff		.
	ld b,a			;5af5	47		G
	rst 38h			;5af6	ff		.
	ld c,d			;5af7	4a		J
	rst 38h			;5af8	ff		.
	ld c,l			;5af9	4d		M
	rst 38h			;5afa	ff		.
	ld d,b			;5afb	50		P
	rst 38h			;5afc	ff		.
	ld d,c			;5afd	51		Q
	rst 38h			;5afe	ff		.
	ld d,h			;5aff	54		T
	rst 38h			;5b00	ff		.
	ld d,a			;5b01	57		W
	rst 38h			;5b02	ff		.
	ld e,b			;5b03	58		X
	rst 38h			;5b04	ff		.
	ld e,e			;5b05	5b		[
	rst 38h			;5b06	ff		.
	ld e,(hl)		;5b07	5e		^
	rst 38h			;5b08	ff		.
	ld e,a			;5b09	5f		_
	rst 38h			;5b0a	ff		.
	ld h,d			;5b0b	62		b
	rst 38h			;5b0c	ff		.
	ld h,l			;5b0d	65		e
	rst 38h			;5b0e	ff		.
	ld l,b			;5b0f	68		h
	rst 38h			;5b10	ff		.
	ld l,c			;5b11	69		i
	rst 38h			;5b12	ff		.
	ld l,h			;5b13	6c		l
	rst 38h			;5b14	ff		.
	ld l,a			;5b15	6f		o
	rst 38h			;5b16	ff		.
	ld (hl),b		;5b17	70		p
	rst 38h			;5b18	ff		.
	ld (hl),e		;5b19	73		s
	rst 38h			;5b1a	ff		.
	ld (hl),a		;5b1b	77		w
	rst 38h			;5b1c	ff		.
	ld a,b			;5b1d	78		x
	rst 38h			;5b1e	ff		.
	ld a,e			;5b1f	7b		{
	rst 38h			;5b20	ff		.
	ld a,a			;5b21	7f		.
	rst 38h			;5b22	ff		.
	add a,c			;5b23	81		.
	rst 38h			;5b24	ff		.
	add a,l			;5b25	85		.
	rst 38h			;5b26	ff		.
	adc a,b			;5b27	88		.
	rst 38h			;5b28	ff		.
	adc a,d			;5b29	8a		.
	rst 38h			;5b2a	ff		.
l5b2bh:
	sub b			;5b2b	90		.
	rst 38h			;5b2c	ff		.
	sub e			;5b2d	93		.
	rst 38h			;5b2e	ff		.
	sbc a,b			;5b2f	98		.
	rst 38h			;5b30	ff		.
	sbc a,l			;5b31	9d		.
	rst 38h			;5b32	ff		.
	and b			;5b33	a0		.
	rst 38h			;5b34	ff		.
	and h			;5b35	a4		.
	rst 38h			;5b36	ff		.
	xor b			;5b37	a8		.
	rst 38h			;5b38	ff		.
	xor (hl)		;5b39	ae		.
	rst 38h			;5b3a	ff		.
	or d			;5b3b	b2		.
	rst 38h			;5b3c	ff		.
	or a			;5b3d	b7		.
	rst 38h			;5b3e	ff		.
	cp l			;5b3f	bd		.
	rst 38h			;5b40	ff		.
	jp nz,0c7ffh		;5b41	c2 ff c7	. . .
	rst 38h			;5b44	ff		.
	adc a,0ffh		;5b45	ce ff		. .
	call nc,0d9ffh		;5b47	d4 ff d9	. . .
	rst 38h			;5b4a	ff		.
	ret po			;5b4b	e0		.
	rst 38h			;5b4c	ff		.
	and 0ffh		;5b4d	e6 ff		. .
	call pe,0f2ffh		;5b4f	ec ff f2	. . .
	rst 38h			;5b52	ff		.
	ret m			;5b53	f8		.
	rst 38h			;5b54	ff		.
	nop			;5b55	00		.
	nop			;5b56	00		.
	nop			;5b57	00		.
	nop			;5b58	00		.
	ex af,af'		;5b59	08		.
	nop			;5b5a	00		.
	ld c,000h		;5b5b	0e 00		. .
	inc d			;5b5d	14		.
	nop			;5b5e	00		.
	ld a,(de)		;5b5f	1a		.
	nop			;5b60	00		.
	jr nz,l5b63h		;5b61	20 00		  .
l5b63h:
	daa			;5b63	27		'
	nop			;5b64	00		.
	inc l			;5b65	2c		,
	nop			;5b66	00		.
	ld (l3900h),a		;5b67	32 00 39	2 . 9
	nop			;5b6a	00		.
	ld a,000h		;5b6b	3e 00		> .
	ld b,e			;5b6d	43		C
	nop			;5b6e	00		.
	ld c,c			;5b6f	49		I
	nop			;5b70	00		.
	ld c,(hl)		;5b71	4e		N
	nop			;5b72	00		.
	ld d,d			;5b73	52		R
	nop			;5b74	00		.
	ld e,b			;5b75	58		X
	nop			;5b76	00		.
	ld e,h			;5b77	5c		\
	nop			;5b78	00		.
	ld h,b			;5b79	60		`
	nop			;5b7a	00		.
	ld h,e			;5b7b	63		c
	nop			;5b7c	00		.
	ld h,e			;5b7d	63		c
	nop			;5b7e	00		.
	ld l,l			;5b7f	6d		m
	nop			;5b80	00		.
l5b81h:
	ld (hl),b		;5b81	70		p
	nop			;5b82	00		.
	halt			;5b83	76		v
	nop			;5b84	00		.
	ld a,b			;5b85	78		x
	nop			;5b86	00		.
	ld a,e			;5b87	7b		{
	nop			;5b88	00		.
	ld a,a			;5b89	7f		.
	nop			;5b8a	00		.
	add a,c			;5b8b	81		.
	nop			;5b8c	00		.
	add a,l			;5b8d	85		.
	nop			;5b8e	00		.
	adc a,b			;5b8f	88		.
	nop			;5b90	00		.
	adc a,c			;5b91	89		.
	nop			;5b92	00		.
	adc a,l			;5b93	8d		.
	nop			;5b94	00		.
	sub b			;5b95	90		.
	nop			;5b96	00		.
	sub c			;5b97	91		.
	nop			;5b98	00		.
	sub h			;5b99	94		.
	nop			;5b9a	00		.
	sub a			;5b9b	97		.
	nop			;5b9c	00		.
	sub h			;5b9d	94		.
	nop			;5b9e	00		.
	sbc a,e			;5b9f	9b		.
	nop			;5ba0	00		.
	sbc a,(hl)		;5ba1	9e		.
	nop			;5ba2	00		.
	and c			;5ba3	a1		.
	nop			;5ba4	00		.
	and d			;5ba5	a2		.
	nop			;5ba6	00		.
	and l			;5ba7	a5		.
	nop			;5ba8	00		.
	xor b			;5ba9	a8		.
	nop			;5baa	00		.
	xor c			;5bab	a9		.
	nop			;5bac	00		.
	xor h			;5bad	ac		.
	nop			;5bae	00		.
	xor a			;5baf	af		.
	nop			;5bb0	00		.
	or b			;5bb1	b0		.
	nop			;5bb2	00		.
	or e			;5bb3	b3		.
	nop			;5bb4	00		.
	or (hl)			;5bb5	b6		.
	nop			;5bb6	00		.
	cp c			;5bb7	b9		.
	nop			;5bb8	00		.
	cp d			;5bb9	ba		.
	nop			;5bba	00		.
	cp h			;5bbb	bc		.
	nop			;5bbc	00		.
	cp c			;5bbd	b9		.
	nop			;5bbe	00		.
	ret nz			;5bbf	c0		.
	nop			;5bc0	00		.
	jp nz,0c400h		;5bc1	c2 00 c4	. . .
	nop			;5bc4	00		.
	add a,000h		;5bc5	c6 00		. .
	ret z			;5bc7	c8		.
	nop			;5bc8	00		.
	ret z			;5bc9	c8		.
	nop			;5bca	00		.
	ret			;5bcb	c9		.
	nop			;5bcc	00		.
	jp z,0cb00h		;5bcd	ca 00 cb	. . .
	nop			;5bd0	00		.
	call z,0cd00h		;5bd1	cc 00 cd	. . .
	nop			;5bd4	00		.
	adc a,000h		;5bd5	ce 00		. .
	call sub_07d2h		;5bd7	cd d2 07	. . .
	call sub_0201h		;5bda	cd 01 02	. . .
	ret nz			;5bdd	c0		.
	ld hl,l0bddh		;5bde	21 dd 0b	! . .
	sub a			;5be1	97		.
	ld b,a			;5be2	47		G
l5be3h:
	xor (hl)		;5be3	ae		.
	inc hl			;5be4	23		#
	djnz l5be3h		;5be5	10 fc		. .
	add a,0e4h		;5be7	c6 e4		. .
	call nz,sub_0f11h	;5be9	c4 11 0f	. . .
	ld a,(0a9abh)		;5bec	3a ab a9	: . .
	ld hl,l1734h		;5bef	21 34 17	! 4 .
	ld b,014h		;5bf2	06 14		. .
l5bf4h:
	add a,(hl)		;5bf4	86		.
	inc hl			;5bf5	23		#
	djnz l5bf4h		;5bf6	10 fc		. .
	add a,077h		;5bf8	c6 77		. w
	ld (0a9abh),a		;5bfa	32 ab a9	2 . .
	jp sub_0f1ah		;5bfd	c3 1a 0f	. . .
l5c00h:
	rst 20h			;5c00	e7		.
l5c01h:
	nop			;5c01	00		.
	and 000h		;5c02	e6 00		. .
	push hl			;5c04	e5		.
	nop			;5c05	00		.
	call po,0e300h		;5c06	e4 00 e3	. . .
	nop			;5c09	00		.
	jp po,0e100h		;5c0a	e2 00 e1	. . .
	nop			;5c0d	00		.
	ret po			;5c0e	e0		.
	nop			;5c0f	00		.
	sbc a,000h		;5c10	de 00		. .
	call c,0da00h		;5c12	dc 00 da	. . .
	nop			;5c15	00		.
	ret c			;5c16	d8		.
	nop			;5c17	00		.
	sub 000h		;5c18	d6 00		. .
	out (000h),a		;5c1a	d3 00		. .
	pop de			;5c1c	d1		.
	nop			;5c1d	00		.
	rst 8			;5c1e	cf		.
	nop			;5c1f	00		.
	call z,0c900h		;5c20	cc 00 c9	. . .
	nop			;5c23	00		.
	add a,000h		;5c24	c6 00		. .
	call nz,0c100h		;5c26	c4 00 c1	. . .
	nop			;5c29	00		.
	cp (hl)			;5c2a	be		.
	nop			;5c2b	00		.
	cp h			;5c2c	bc		.
	nop			;5c2d	00		.
	cp c			;5c2e	b9		.
	nop			;5c2f	00		.
	or (hl)			;5c30	b6		.
	nop			;5c31	00		.
	or h			;5c32	b4		.
	nop			;5c33	00		.
	or c			;5c34	b1		.
	nop			;5c35	00		.
	xor (hl)		;5c36	ae		.
	nop			;5c37	00		.
	xor e			;5c38	ab		.
	nop			;5c39	00		.
	xor c			;5c3a	a9		.
	nop			;5c3b	00		.
	and (hl)		;5c3c	a6		.
	nop			;5c3d	00		.
	and e			;5c3e	a3		.
	nop			;5c3f	00		.
	and c			;5c40	a1		.
	nop			;5c41	00		.
	sbc a,(hl)		;5c42	9e		.
	nop			;5c43	00		.
	sbc a,d			;5c44	9a		.
	nop			;5c45	00		.
	sbc a,b			;5c46	98		.
	nop			;5c47	00		.
	sub l			;5c48	95		.
	nop			;5c49	00		.
	sub c			;5c4a	91		.
	nop			;5c4b	00		.
	adc a,(hl)		;5c4c	8e		.
	nop			;5c4d	00		.
	adc a,d			;5c4e	8a		.
	nop			;5c4f	00		.
	add a,a			;5c50	87		.
	nop			;5c51	00		.
	add a,h			;5c52	84		.
	nop			;5c53	00		.
	ld a,(hl)		;5c54	7e		~
	nop			;5c55	00		.
	ld a,d			;5c56	7a		z
	nop			;5c57	00		.
	ld (hl),l		;5c58	75		u
	nop			;5c59	00		.
	ld l,a			;5c5a	6f		o
	nop			;5c5b	00		.
	ld l,h			;5c5c	6c		l
	nop			;5c5d	00		.
	ld h,a			;5c5e	67		g
	nop			;5c5f	00		.
	ld h,d			;5c60	62		b
	nop			;5c61	00		.
	ld e,h			;5c62	5c		\
	nop			;5c63	00		.
	ld d,a			;5c64	57		W
	nop			;5c65	00		.
	ld d,c			;5c66	51		Q
	nop			;5c67	00		.
	ld c,e			;5c68	4b		K
	nop			;5c69	00		.
	ld b,l			;5c6a	45		E
	nop			;5c6b	00		.
	ccf			;5c6c	3f		?
	nop			;5c6d	00		.
	jr c,l5c70h		;5c6e	38 00		8 .
l5c70h:
	ld sp,02b00h		;5c70	31 00 2b	1 . +
	nop			;5c73	00		.
	inc h			;5c74	24		$
	nop			;5c75	00		.
	dec e			;5c76	1d		.
	nop			;5c77	00		.
	ld d,000h		;5c78	16 00		. .
	rrca			;5c7a	0f		.
	nop			;5c7b	00		.
	ex af,af'		;5c7c	08		.
	nop			;5c7d	00		.
	nop			;5c7e	00		.
	nop			;5c7f	00		.
	nop			;5c80	00		.
	nop			;5c81	00		.
	ret m			;5c82	f8		.
	rst 38h			;5c83	ff		.
	pop af			;5c84	f1		.
	rst 38h			;5c85	ff		.
	nop			;5c86	00		.
	nop			;5c87	00		.
	ex (sp),hl		;5c88	e3		.
	rst 38h			;5c89	ff		.
	call c,0d5ffh		;5c8a	dc ff d5	. . .
	rst 38h			;5c8d	ff		.
	rst 8			;5c8e	cf		.
	rst 38h			;5c8f	ff		.
	ret z			;5c90	c8		.
	rst 38h			;5c91	ff		.
	pop bc			;5c92	c1		.
	rst 38h			;5c93	ff		.
	cp e			;5c94	bb		.
	rst 38h			;5c95	ff		.
	or l			;5c96	b5		.
	rst 38h			;5c97	ff		.
	xor a			;5c98	af		.
	rst 38h			;5c99	ff		.
	xor c			;5c9a	a9		.
	rst 38h			;5c9b	ff		.
	and h			;5c9c	a4		.
	rst 38h			;5c9d	ff		.
	sbc a,(hl)		;5c9e	9e		.
	rst 38h			;5c9f	ff		.
	sbc a,c			;5ca0	99		.
	rst 38h			;5ca1	ff		.
	sub h			;5ca2	94		.
	rst 38h			;5ca3	ff		.
	sub c			;5ca4	91		.
	rst 38h			;5ca5	ff		.
	sub h			;5ca6	94		.
	rst 38h			;5ca7	ff		.
	add a,(hl)		;5ca8	86		.
	rst 38h			;5ca9	ff		.
	add a,d			;5caa	82		.
	rst 38h			;5cab	ff		.
	ld a,h			;5cac	7c		|
	rst 38h			;5cad	ff		.
	ld a,c			;5cae	79		y
	rst 38h			;5caf	ff		.
	halt			;5cb0	76		v
	rst 38h			;5cb1	ff		.
	ld (hl),d		;5cb2	72		r
	rst 38h			;5cb3	ff		.
	ld l,a			;5cb4	6f		o
	rst 38h			;5cb5	ff		.
	ld l,e			;5cb6	6b		k
	rst 38h			;5cb7	ff		.
	ld l,b			;5cb8	68		h
	rst 38h			;5cb9	ff		.
	ld h,(hl)		;5cba	66		f
	rst 38h			;5cbb	ff		.
	ld h,d			;5cbc	62		b
	rst 38h			;5cbd	ff		.
	ld e,a			;5cbe	5f		_
	rst 38h			;5cbf	ff		.
	ld e,l			;5cc0	5d		]
	rst 38h			;5cc1	ff		.
	ld e,d			;5cc2	5a		Z
	rst 38h			;5cc3	ff		.
	ld d,a			;5cc4	57		W
	rst 38h			;5cc5	ff		.
	ld d,a			;5cc6	57		W
	rst 38h			;5cc7	ff		.
	ld d,d			;5cc8	52		R
	rst 38h			;5cc9	ff		.
	ld c,a			;5cca	4f		O
	rst 38h			;5ccb	ff		.
	ld c,h			;5ccc	4c		L
	rst 38h			;5ccd	ff		.
	ld c,d			;5cce	4a		J
	rst 38h			;5ccf	ff		.
	ld b,a			;5cd0	47		G
	rst 38h			;5cd1	ff		.
	ld b,h			;5cd2	44		D
	rst 38h			;5cd3	ff		.
	ld b,d			;5cd4	42		B
	rst 38h			;5cd5	ff		.
	ccf			;5cd6	3f		?
	rst 38h			;5cd7	ff		.
	inc a			;5cd8	3c		<
	rst 38h			;5cd9	ff		.
	ld a,(l37ffh)		;5cda	3a ff 37	: . 7
	rst 38h			;5cdd	ff		.
	inc (hl)		;5cde	34		4
	rst 38h			;5cdf	ff		.
	ld sp,l2fffh		;5ce0	31 ff 2f	1 . /
	rst 38h			;5ce3	ff		.
	dec l			;5ce4	2d		-
	rst 38h			;5ce5	ff		.
	ld hl,(sub_28feh+1)	;5ce6	2a ff 28	* . (
	rst 38h			;5ce9	ff		.
	ld h,0ffh		;5cea	26 ff		& .
sub_5cech:
	inc h			;5cec	24		$
	rst 38h			;5ced	ff		.
	ld (l20ffh),hl		;5cee	22 ff 20	" .  
	rst 38h			;5cf1	ff		.
	rra			;5cf2	1f		.
	rst 38h			;5cf3	ff		.
	ld e,0ffh		;5cf4	1e ff		. .
	dec e			;5cf6	1d		.
	rst 38h			;5cf7	ff		.
	inc e			;5cf8	1c		.
	rst 38h			;5cf9	ff		.
	dec de			;5cfa	1b		.
	rst 38h			;5cfb	ff		.
	ld a,(de)		;5cfc	1a		.
	rst 38h			;5cfd	ff		.
	add hl,de		;5cfe	19		.
	rst 38h			;5cff	ff		.
	add hl,de		;5d00	19		.
	rst 38h			;5d01	ff		.
	ld a,(de)		;5d02	1a		.
	rst 38h			;5d03	ff		.
	dec de			;5d04	1b		.
	rst 38h			;5d05	ff		.
	inc e			;5d06	1c		.
	rst 38h			;5d07	ff		.
	dec e			;5d08	1d		.
	rst 38h			;5d09	ff		.
	ld e,0ffh		;5d0a	1e ff		. .
	rra			;5d0c	1f		.
	rst 38h			;5d0d	ff		.
	jr nz,$+1		;5d0e	20 ff		  .
	ld (024ffh),hl		;5d10	22 ff 24	" . $
	rst 38h			;5d13	ff		.
	ld h,0ffh		;5d14	26 ff		& .
	jr z,$+1		;5d16	28 ff		( .
	ld hl,(02dffh)		;5d18	2a ff 2d	* . -
	rst 38h			;5d1b	ff		.
	cpl			;5d1c	2f		/
	rst 38h			;5d1d	ff		.
	ld sp,l34ffh		;5d1e	31 ff 34	1 . 4
	rst 38h			;5d21	ff		.
	scf			;5d22	37		7
	rst 38h			;5d23	ff		.
	ld a,(l3cffh)		;5d24	3a ff 3c	: . <
	rst 38h			;5d27	ff		.
	ccf			;5d28	3f		?
	rst 38h			;5d29	ff		.
	ld b,d			;5d2a	42		B
	rst 38h			;5d2b	ff		.
	ld b,h			;5d2c	44		D
	rst 38h			;5d2d	ff		.
	ld b,a			;5d2e	47		G
	rst 38h			;5d2f	ff		.
	ld c,d			;5d30	4a		J
	rst 38h			;5d31	ff		.
	ld c,h			;5d32	4c		L
	rst 38h			;5d33	ff		.
	ld c,a			;5d34	4f		O
	rst 38h			;5d35	ff		.
	ld d,d			;5d36	52		R
	rst 38h			;5d37	ff		.
	ld d,l			;5d38	55		U
	rst 38h			;5d39	ff		.
	ld d,a			;5d3a	57		W
	rst 38h			;5d3b	ff		.
	ld e,d			;5d3c	5a		Z
	rst 38h			;5d3d	ff		.
	ld e,l			;5d3e	5d		]
	rst 38h			;5d3f	ff		.
	ld e,a			;5d40	5f		_
	rst 38h			;5d41	ff		.
	ld h,d			;5d42	62		b
	rst 38h			;5d43	ff		.
	ld h,(hl)		;5d44	66		f
	rst 38h			;5d45	ff		.
	ld l,b			;5d46	68		h
	rst 38h			;5d47	ff		.
	ld l,e			;5d48	6b		k
	rst 38h			;5d49	ff		.
	ld l,a			;5d4a	6f		o
	rst 38h			;5d4b	ff		.
	ld (hl),d		;5d4c	72		r
	rst 38h			;5d4d	ff		.
	halt			;5d4e	76		v
	rst 38h			;5d4f	ff		.
	ld a,c			;5d50	79		y
	rst 38h			;5d51	ff		.
	ld a,h			;5d52	7c		|
	rst 38h			;5d53	ff		.
	add a,d			;5d54	82		.
	rst 38h			;5d55	ff		.
	add a,(hl)		;5d56	86		.
	rst 38h			;5d57	ff		.
	adc a,e			;5d58	8b		.
	rst 38h			;5d59	ff		.
	sub c			;5d5a	91		.
	rst 38h			;5d5b	ff		.
	sub h			;5d5c	94		.
	rst 38h			;5d5d	ff		.
	sbc a,c			;5d5e	99		.
	rst 38h			;5d5f	ff		.
	sbc a,(hl)		;5d60	9e		.
	rst 38h			;5d61	ff		.
	and h			;5d62	a4		.
	rst 38h			;5d63	ff		.
	xor c			;5d64	a9		.
	rst 38h			;5d65	ff		.
	xor a			;5d66	af		.
	rst 38h			;5d67	ff		.
	or l			;5d68	b5		.
	rst 38h			;5d69	ff		.
	cp e			;5d6a	bb		.
	rst 38h			;5d6b	ff		.
	pop bc			;5d6c	c1		.
	rst 38h			;5d6d	ff		.
	ret z			;5d6e	c8		.
	rst 38h			;5d6f	ff		.
	rst 8			;5d70	cf		.
	rst 38h			;5d71	ff		.
	push de			;5d72	d5		.
	rst 38h			;5d73	ff		.
	call c,0e3ffh		;5d74	dc ff e3	. . .
	rst 38h			;5d77	ff		.
	jp pe,0f1ffh		;5d78	ea ff f1	. . .
	rst 38h			;5d7b	ff		.
	ret m			;5d7c	f8		.
	rst 38h			;5d7d	ff		.
	nop			;5d7e	00		.
	nop			;5d7f	00		.
	nop			;5d80	00		.
	nop			;5d81	00		.
	ex af,af'		;5d82	08		.
	nop			;5d83	00		.
	rrca			;5d84	0f		.
	nop			;5d85	00		.
	ld d,000h		;5d86	16 00		. .
	dec e			;5d88	1d		.
	nop			;5d89	00		.
	inc h			;5d8a	24		$
	nop			;5d8b	00		.
	dec hl			;5d8c	2b		+
	nop			;5d8d	00		.
	ld sp,l3800h		;5d8e	31 00 38	1 . 8
	nop			;5d91	00		.
	ccf			;5d92	3f		?
	nop			;5d93	00		.
	ld b,l			;5d94	45		E
	nop			;5d95	00		.
	ld c,e			;5d96	4b		K
	nop			;5d97	00		.
	ld d,c			;5d98	51		Q
	nop			;5d99	00		.
	ld d,a			;5d9a	57		W
	nop			;5d9b	00		.
	ld e,h			;5d9c	5c		\
	nop			;5d9d	00		.
	ld h,d			;5d9e	62		b
	nop			;5d9f	00		.
	ld h,a			;5da0	67		g
	nop			;5da1	00		.
	ld l,h			;5da2	6c		l
	nop			;5da3	00		.
	ld l,a			;5da4	6f		o
	nop			;5da5	00		.
	ld l,a			;5da6	6f		o
	nop			;5da7	00		.
	ld a,d			;5da8	7a		z
	nop			;5da9	00		.
	ld a,(hl)		;5daa	7e		~
	nop			;5dab	00		.
	add a,h			;5dac	84		.
	nop			;5dad	00		.
	add a,a			;5dae	87		.
	nop			;5daf	00		.
	adc a,d			;5db0	8a		.
	nop			;5db1	00		.
	adc a,(hl)		;5db2	8e		.
	nop			;5db3	00		.
	sub c			;5db4	91		.
	nop			;5db5	00		.
	sub l			;5db6	95		.
	nop			;5db7	00		.
	sbc a,b			;5db8	98		.
	nop			;5db9	00		.
	sbc a,d			;5dba	9a		.
	nop			;5dbb	00		.
	sbc a,(hl)		;5dbc	9e		.
	nop			;5dbd	00		.
	and c			;5dbe	a1		.
	nop			;5dbf	00		.
	and e			;5dc0	a3		.
	nop			;5dc1	00		.
	and (hl)		;5dc2	a6		.
	nop			;5dc3	00		.
	xor c			;5dc4	a9		.
	nop			;5dc5	00		.
	and (hl)		;5dc6	a6		.
	nop			;5dc7	00		.
	xor (hl)		;5dc8	ae		.
	nop			;5dc9	00		.
	or c			;5dca	b1		.
	nop			;5dcb	00		.
	or h			;5dcc	b4		.
	nop			;5dcd	00		.
	or (hl)			;5dce	b6		.
	nop			;5dcf	00		.
	cp c			;5dd0	b9		.
	nop			;5dd1	00		.
	cp h			;5dd2	bc		.
	nop			;5dd3	00		.
	cp (hl)			;5dd4	be		.
	nop			;5dd5	00		.
	pop bc			;5dd6	c1		.
	nop			;5dd7	00		.
	call nz,0c600h		;5dd8	c4 00 c6	. . .
	nop			;5ddb	00		.
	ret			;5ddc	c9		.
	nop			;5ddd	00		.
	call z,0cf00h		;5dde	cc 00 cf	. . .
	nop			;5de1	00		.
	pop de			;5de2	d1		.
	nop			;5de3	00		.
	out (000h),a		;5de4	d3 00		. .
	rst 8			;5de6	cf		.
	nop			;5de7	00		.
	ret c			;5de8	d8		.
	nop			;5de9	00		.
	jp c,0dc00h		;5dea	da 00 dc	. . .
	nop			;5ded	00		.
	sbc a,000h		;5dee	de 00		. .
	ret po			;5df0	e0		.
	nop			;5df1	00		.
	pop hl			;5df2	e1		.
	nop			;5df3	00		.
	jp po,0e300h		;5df4	e2 00 e3	. . .
	nop			;5df7	00		.
	call po,0e500h		;5df8	e4 00 e5	. . .
	nop			;5dfb	00		.
	and 000h		;5dfc	e6 00		. .
	rst 20h			;5dfe	e7		.
	nop			;5dff	00		.
l5e00h:
	nop			;5e00	00		.
	ld bc,l00fdh+2		;5e01	01 ff 00	. . .
	cp 000h			;5e04	fe 00		. .
	defb 0fdh,000h,0fch ;illegal sequence	;5e06	fd 00 fc	. . .
	nop			;5e09	00		.
	ei			;5e0a	fb		.
	nop			;5e0b	00		.
	jp m,0f800h		;5e0c	fa 00 f8	. . .
	nop			;5e0f	00		.
	or 000h			;5e10	f6 00		. .
	call p,0f200h		;5e12	f4 00 f2	. . .
	nop			;5e15	00		.
	ret p			;5e16	f0		.
	nop			;5e17	00		.
	defb 0edh ;next byte illegal after ed	;5e18	ed		.
	nop			;5e19	00		.
	jp pe,0e800h		;5e1a	ea 00 e8	. . .
	nop			;5e1d	00		.
	push hl			;5e1e	e5		.
	nop			;5e1f	00		.
	jp po,0df00h		;5e20	e2 00 df	. . .
	nop			;5e23	00		.
	call c,0d900h		;5e24	dc 00 d9	. . .
	nop			;5e27	00		.
	sub 000h		;5e28	d6 00		. .
	out (000h),a		;5e2a	d3 00		. .
	ret nc			;5e2c	d0		.
	nop			;5e2d	00		.
	call 0ca00h		;5e2e	cd 00 ca	. . .
	nop			;5e31	00		.
	rst 0			;5e32	c7		.
	nop			;5e33	00		.
	call nz,0c100h		;5e34	c4 00 c1	. . .
	nop			;5e37	00		.
	cp (hl)			;5e38	be		.
	nop			;5e39	00		.
	cp e			;5e3a	bb		.
	nop			;5e3b	00		.
	cp b			;5e3c	b8		.
	nop			;5e3d	00		.
	or l			;5e3e	b5		.
	nop			;5e3f	00		.
	or d			;5e40	b2		.
	nop			;5e41	00		.
	xor a			;5e42	af		.
	nop			;5e43	00		.
	xor e			;5e44	ab		.
	nop			;5e45	00		.
	xor b			;5e46	a8		.
	nop			;5e47	00		.
	and l			;5e48	a5		.
	nop			;5e49	00		.
	and c			;5e4a	a1		.
	nop			;5e4b	00		.
	sbc a,l			;5e4c	9d		.
	nop			;5e4d	00		.
	sbc a,c			;5e4e	99		.
	nop			;5e4f	00		.
	sub (hl)		;5e50	96		.
	nop			;5e51	00		.
	sub d			;5e52	92		.
	nop			;5e53	00		.
	adc a,h			;5e54	8c		.
	nop			;5e55	00		.
	add a,a			;5e56	87		.
	nop			;5e57	00		.
	add a,d			;5e58	82		.
	nop			;5e59	00		.
	ld a,e			;5e5a	7b		{
	nop			;5e5b	00		.
	ld a,b			;5e5c	78		x
	nop			;5e5d	00		.
	ld (hl),d		;5e5e	72		r
	nop			;5e5f	00		.
	ld l,h			;5e60	6c		l
	nop			;5e61	00		.
	ld h,(hl)		;5e62	66		f
	nop			;5e63	00		.
	ld h,b			;5e64	60		`
	nop			;5e65	00		.
	ld e,c			;5e66	59		Y
	nop			;5e67	00		.
	ld d,e			;5e68	53		S
	nop			;5e69	00		.
	ld c,h			;5e6a	4c		L
	nop			;5e6b	00		.
	ld b,l			;5e6c	45		E
	nop			;5e6d	00		.
	ld a,000h		;5e6e	3e 00		> .
	ld (hl),000h		;5e70	36 00		6 .
	cpl			;5e72	2f		/
	nop			;5e73	00		.
	jr z,l5e76h		;5e74	28 00		( .
l5e76h:
	jr nz,l5e78h		;5e76	20 00		  .
l5e78h:
	jr l5e7ah		;5e78	18 00		. .
l5e7ah:
	djnz l5e7ch		;5e7a	10 00		. .
l5e7ch:
	ex af,af'		;5e7c	08		.
	nop			;5e7d	00		.
	nop			;5e7e	00		.
	nop			;5e7f	00		.
	nop			;5e80	00		.
	nop			;5e81	00		.
	ret m			;5e82	f8		.
	rst 38h			;5e83	ff		.
	ret p			;5e84	f0		.
	rst 38h			;5e85	ff		.
	nop			;5e86	00		.
	nop			;5e87	00		.
	ret po			;5e88	e0		.
	rst 38h			;5e89	ff		.
	ret c			;5e8a	d8		.
	rst 38h			;5e8b	ff		.
	pop de			;5e8c	d1		.
	rst 38h			;5e8d	ff		.
	jp z,0c2ffh		;5e8e	ca ff c2	. . .
	rst 38h			;5e91	ff		.
	cp e			;5e92	bb		.
	rst 38h			;5e93	ff		.
	or h			;5e94	b4		.
	rst 38h			;5e95	ff		.
	xor l			;5e96	ad		.
	rst 38h			;5e97	ff		.
	and a			;5e98	a7		.
	rst 38h			;5e99	ff		.
	and b			;5e9a	a0		.
	rst 38h			;5e9b	ff		.
	sbc a,d			;5e9c	9a		.
	rst 38h			;5e9d	ff		.
	sub h			;5e9e	94		.
	rst 38h			;5e9f	ff		.
	adc a,(hl)		;5ea0	8e		.
	rst 38h			;5ea1	ff		.
	adc a,b			;5ea2	88		.
	rst 38h			;5ea3	ff		.
	add a,l			;5ea4	85		.
	rst 38h			;5ea5	ff		.
	adc a,b			;5ea6	88		.
	rst 38h			;5ea7	ff		.
	ld a,c			;5ea8	79		y
	rst 38h			;5ea9	ff		.
	ld (hl),h		;5eaa	74		t
	rst 38h			;5eab	ff		.
	ld l,(hl)		;5eac	6e		n
	rst 38h			;5ead	ff		.
	ld l,d			;5eae	6a		j
	rst 38h			;5eaf	ff		.
	ld h,a			;5eb0	67		g
	rst 38h			;5eb1	ff		.
	ld h,e			;5eb2	63		c
	rst 38h			;5eb3	ff		.
	ld e,a			;5eb4	5f		_
	rst 38h			;5eb5	ff		.
	ld e,e			;5eb6	5b		[
	rst 38h			;5eb7	ff		.
	ld e,b			;5eb8	58		X
	rst 38h			;5eb9	ff		.
	ld d,l			;5eba	55		U
	rst 38h			;5ebb	ff		.
	ld d,c			;5ebc	51		Q
	rst 38h			;5ebd	ff		.
	ld c,(hl)		;5ebe	4e		N
	rst 38h			;5ebf	ff		.
	ld c,e			;5ec0	4b		K
	rst 38h			;5ec1	ff		.
	ld c,b			;5ec2	48		H
	rst 38h			;5ec3	ff		.
	ld b,l			;5ec4	45		E
	rst 38h			;5ec5	ff		.
	ld b,l			;5ec6	45		E
	rst 38h			;5ec7	ff		.
	ccf			;5ec8	3f		?
	rst 38h			;5ec9	ff		.
	inc a			;5eca	3c		<
	rst 38h			;5ecb	ff		.
	add hl,sp		;5ecc	39		9
	rst 38h			;5ecd	ff		.
	ld (hl),0ffh		;5ece	36 ff		6 .
	inc sp			;5ed0	33		3
	rst 38h			;5ed1	ff		.
	jr nc,$+1		;5ed2	30 ff		0 .
	dec l			;5ed4	2d		-
	rst 38h			;5ed5	ff		.
	ld hl,(l27ffh)		;5ed6	2a ff 27	* . '
	rst 38h			;5ed9	ff		.
	inc h			;5eda	24		$
	rst 38h			;5edb	ff		.
	ld hl,01effh		;5edc	21 ff 1e	! . .
	rst 38h			;5edf	ff		.
	dec de			;5ee0	1b		.
	rst 38h			;5ee1	ff		.
	jr $+1			;5ee2	18 ff		. .
	ld d,0ffh		;5ee4	16 ff		. .
	inc de			;5ee6	13		.
	rst 38h			;5ee7	ff		.
	djnz $+1		;5ee8	10 ff		. .
	ld c,0ffh		;5eea	0e ff		. .
	inc c			;5eec	0c		.
	rst 38h			;5eed	ff		.
	ld a,(bc)		;5eee	0a		.
	rst 38h			;5eef	ff		.
	ex af,af'		;5ef0	08		.
	rst 38h			;5ef1	ff		.
	ld b,0ffh		;5ef2	06 ff		. .
	dec b			;5ef4	05		.
	rst 38h			;5ef5	ff		.
	inc b			;5ef6	04		.
	rst 38h			;5ef7	ff		.
	inc bc			;5ef8	03		.
	rst 38h			;5ef9	ff		.
	ld (bc),a		;5efa	02		.
	rst 38h			;5efb	ff		.
	ld bc,l00fdh+2		;5efc	01 ff 00	. . .
	rst 38h			;5eff	ff		.
	nop			;5f00	00		.
	rst 38h			;5f01	ff		.
	ld bc,l02ffh		;5f02	01 ff 02	. . .
	rst 38h			;5f05	ff		.
	inc bc			;5f06	03		.
	rst 38h			;5f07	ff		.
	inc b			;5f08	04		.
	rst 38h			;5f09	ff		.
	dec b			;5f0a	05		.
	rst 38h			;5f0b	ff		.
	ld b,0ffh		;5f0c	06 ff		. .
	ex af,af'		;5f0e	08		.
	rst 38h			;5f0f	ff		.
	ld a,(bc)		;5f10	0a		.
	rst 38h			;5f11	ff		.
	inc c			;5f12	0c		.
	rst 38h			;5f13	ff		.
	ld c,0ffh		;5f14	0e ff		. .
	djnz $+1		;5f16	10 ff		. .
	inc de			;5f18	13		.
	rst 38h			;5f19	ff		.
	ld d,0ffh		;5f1a	16 ff		. .
	jr $+1			;5f1c	18 ff		. .
	dec de			;5f1e	1b		.
	rst 38h			;5f1f	ff		.
	ld e,0ffh		;5f20	1e ff		. .
	ld hl,024ffh		;5f22	21 ff 24	! . $
	rst 38h			;5f25	ff		.
	daa			;5f26	27		'
	rst 38h			;5f27	ff		.
	ld hl,(02dffh)		;5f28	2a ff 2d	* . -
	rst 38h			;5f2b	ff		.
	jr nc,$+1		;5f2c	30 ff		0 .
	inc sp			;5f2e	33		3
	rst 38h			;5f2f	ff		.
	ld (hl),0ffh		;5f30	36 ff		6 .
	add hl,sp		;5f32	39		9
	rst 38h			;5f33	ff		.
	inc a			;5f34	3c		<
	rst 38h			;5f35	ff		.
	ccf			;5f36	3f		?
	rst 38h			;5f37	ff		.
	ld b,d			;5f38	42		B
	rst 38h			;5f39	ff		.
	ld b,l			;5f3a	45		E
	rst 38h			;5f3b	ff		.
	ld c,b			;5f3c	48		H
	rst 38h			;5f3d	ff		.
	ld c,e			;5f3e	4b		K
	rst 38h			;5f3f	ff		.
	ld c,(hl)		;5f40	4e		N
	rst 38h			;5f41	ff		.
	ld d,c			;5f42	51		Q
	rst 38h			;5f43	ff		.
	ld d,l			;5f44	55		U
	rst 38h			;5f45	ff		.
	ld e,b			;5f46	58		X
	rst 38h			;5f47	ff		.
	ld e,e			;5f48	5b		[
	rst 38h			;5f49	ff		.
	ld e,a			;5f4a	5f		_
	rst 38h			;5f4b	ff		.
	ld h,e			;5f4c	63		c
	rst 38h			;5f4d	ff		.
	ld h,a			;5f4e	67		g
	rst 38h			;5f4f	ff		.
	ld l,d			;5f50	6a		j
	rst 38h			;5f51	ff		.
	ld l,(hl)		;5f52	6e		n
	rst 38h			;5f53	ff		.
	ld (hl),h		;5f54	74		t
	rst 38h			;5f55	ff		.
	ld a,c			;5f56	79		y
	rst 38h			;5f57	ff		.
	ld a,(hl)		;5f58	7e		~
	rst 38h			;5f59	ff		.
	add a,l			;5f5a	85		.
	rst 38h			;5f5b	ff		.
	adc a,b			;5f5c	88		.
	rst 38h			;5f5d	ff		.
	adc a,(hl)		;5f5e	8e		.
	rst 38h			;5f5f	ff		.
	sub h			;5f60	94		.
	rst 38h			;5f61	ff		.
	sbc a,d			;5f62	9a		.
	rst 38h			;5f63	ff		.
	and b			;5f64	a0		.
	rst 38h			;5f65	ff		.
	and a			;5f66	a7		.
	rst 38h			;5f67	ff		.
	xor l			;5f68	ad		.
	rst 38h			;5f69	ff		.
	or h			;5f6a	b4		.
	rst 38h			;5f6b	ff		.
	cp e			;5f6c	bb		.
	rst 38h			;5f6d	ff		.
	jp nz,0caffh		;5f6e	c2 ff ca	. . .
	rst 38h			;5f71	ff		.
	pop de			;5f72	d1		.
	rst 38h			;5f73	ff		.
	ret c			;5f74	d8		.
	rst 38h			;5f75	ff		.
	ret po			;5f76	e0		.
	rst 38h			;5f77	ff		.
	ret pe			;5f78	e8		.
	rst 38h			;5f79	ff		.
	ret p			;5f7a	f0		.
	rst 38h			;5f7b	ff		.
	ret m			;5f7c	f8		.
	rst 38h			;5f7d	ff		.
	nop			;5f7e	00		.
	nop			;5f7f	00		.
	nop			;5f80	00		.
	nop			;5f81	00		.
	ex af,af'		;5f82	08		.
	nop			;5f83	00		.
	djnz l5f86h		;5f84	10 00		. .
l5f86h:
	jr l5f88h		;5f86	18 00		. .
l5f88h:
	jr nz,l5f8ah		;5f88	20 00		  .
l5f8ah:
	jr z,l5f8ch		;5f8a	28 00		( .
l5f8ch:
	cpl			;5f8c	2f		/
	nop			;5f8d	00		.
	ld (hl),000h		;5f8e	36 00		6 .
	ld a,000h		;5f90	3e 00		> .
	ld b,l			;5f92	45		E
	nop			;5f93	00		.
	ld c,h			;5f94	4c		L
	nop			;5f95	00		.
	ld d,e			;5f96	53		S
	nop			;5f97	00		.
	ld e,c			;5f98	59		Y
	nop			;5f99	00		.
	ld h,b			;5f9a	60		`
	nop			;5f9b	00		.
	ld h,(hl)		;5f9c	66		f
	nop			;5f9d	00		.
	ld l,h			;5f9e	6c		l
	nop			;5f9f	00		.
	ld (hl),d		;5fa0	72		r
	nop			;5fa1	00		.
	ld a,b			;5fa2	78		x
	nop			;5fa3	00		.
	ld a,e			;5fa4	7b		{
	nop			;5fa5	00		.
	ld a,e			;5fa6	7b		{
	nop			;5fa7	00		.
	add a,a			;5fa8	87		.
	nop			;5fa9	00		.
	adc a,h			;5faa	8c		.
	nop			;5fab	00		.
	sub d			;5fac	92		.
	nop			;5fad	00		.
	sub (hl)		;5fae	96		.
	nop			;5faf	00		.
	sbc a,c			;5fb0	99		.
	nop			;5fb1	00		.
	sbc a,l			;5fb2	9d		.
	nop			;5fb3	00		.
	and c			;5fb4	a1		.
	nop			;5fb5	00		.
	and l			;5fb6	a5		.
	nop			;5fb7	00		.
	xor b			;5fb8	a8		.
	nop			;5fb9	00		.
	xor e			;5fba	ab		.
	nop			;5fbb	00		.
	xor a			;5fbc	af		.
	nop			;5fbd	00		.
	or d			;5fbe	b2		.
	nop			;5fbf	00		.
	or l			;5fc0	b5		.
	nop			;5fc1	00		.
	cp b			;5fc2	b8		.
	nop			;5fc3	00		.
	cp e			;5fc4	bb		.
	nop			;5fc5	00		.
	cp b			;5fc6	b8		.
	nop			;5fc7	00		.
	pop bc			;5fc8	c1		.
	nop			;5fc9	00		.
	call nz,0c700h		;5fca	c4 00 c7	. . .
	nop			;5fcd	00		.
	jp z,0cd00h		;5fce	ca 00 cd	. . .
	nop			;5fd1	00		.
	ret nc			;5fd2	d0		.
	nop			;5fd3	00		.
	out (000h),a		;5fd4	d3 00		. .
	sub 000h		;5fd6	d6 00		. .
	exx			;5fd8	d9		.
	nop			;5fd9	00		.
	call c,0df00h		;5fda	dc 00 df	. . .
	nop			;5fdd	00		.
	jp po,0e500h		;5fde	e2 00 e5	. . .
	nop			;5fe1	00		.
	ret pe			;5fe2	e8		.
	nop			;5fe3	00		.
	jp pe,0e500h		;5fe4	ea 00 e5	. . .
	nop			;5fe7	00		.
	ret p			;5fe8	f0		.
	nop			;5fe9	00		.
	jp p,0f400h		;5fea	f2 00 f4	. . .
	nop			;5fed	00		.
	or 000h			;5fee	f6 00		. .
	ret m			;5ff0	f8		.
	nop			;5ff1	00		.
	jp m,0fb00h		;5ff2	fa 00 fb	. . .
	nop			;5ff5	00		.
	call m,0fd00h		;5ff6	fc 00 fd	. . .
	nop			;5ff9	00		.
	cp 000h			;5ffa	fe 00		. .
	rst 38h			;5ffc	ff		.
	nop			;5ffd	00		.
	nop			;5ffe	00		.
	defb 001h		;5fff	01		.
