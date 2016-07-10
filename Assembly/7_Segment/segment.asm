;********************************************************
;
;	7 segment a to dp pin connected to PORTB0 ~ PORTB7
; 	7 segment common PORTD4 and PORTD5
;
;	Author :	Michael Umenyi
;	Created on 2016/07/10
;	
;	chip: 	Attiny2313
; 	frequency: 	20Mhz
;
;******************************************************** 	

.include "tn2313def.inc"

.org 0x0000

.equ 	aSeg 		= PORTD4
.equ 	bSeg 		= PORTD5
.equ 	dataPin 	= PORTB

.def 	seg 		= r20
.def 	bData 		= r23
.def	aData 		= r22


data:					;data to display
.db		0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x27,0x7f,0x6f

rjmp main

main:					;main function

		sbi 	DDRD, 	aSeg
		sbi 	DDRD, 	bSeg
		ldi 	r16, 	0xff
		out 	DDRB, 	r16
		rjmp 	loop
		
loop: 					
		
		ldi		r18, 	0
;--------------------------------------		
	jLoop:
		ldi		ZH, 	HIGH(data)
		ldi		ZL, 	LOW(data)	
		add		ZL, 	r18
		lpm		aData,	Z	
		ldi 	r19, 	0
	;//////////////////////////////	
		iLoop:
			ldi		ZH, 	HIGH(data)
			ldi		ZL, 	LOW(data)	
			add		ZL, 	r19
			lpm		bData,	Z	
			ldi 	r21, 	100
			;**************************
				nLoop:
					push 	r18
					push 	r19
					rcall 	Display
					pop 	r19
					pop 	r18
					dec 	r21
					brne 	nLoop
			;**************************		
			inc 	r19
			cpi 	r19, 	10
			brne 	iLoop
	;//////////////////////////////		
		inc 	r18
		cpi 	r18, 	10
		brne 	jLoop
;-----------------------------------------		
		rjmp 	loop
		
Display:
		out 	PORTB, 	aData
		ldi 	r18, 	0x20
		out 	PORTD, 	r18
		rcall 	delay1S
		
		out 	PORTB, 	bData
		ldi 	r18, 	0x10
		out 	PORTD, 	r18
		rcall 	delay1S
		ret
		
delay1S:

		ldi  r18, 130
		ldi  r19, 222
	L1: dec  r19
		brne L1
		dec  r18
		brne L1
		nop
		ret
