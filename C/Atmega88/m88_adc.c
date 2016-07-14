/********************************************************
;
;	7 segment a to dp pin connected to PORTD0 ~ PORTD7
; 	7 segment common PORTB4 and PORTB5
;	analog pin0 used to get value
;
;	Author :	Michael Umenyi
;	Created on 2016/07/14
;	
;	chip: 	Atmega88
; 	frequency: 	1Mhz
;
********************************************************/

#define F_CPU 1000000UL  

#include <avr/io.h>
#include <util/delay.h>

void Display(int aSeg, int bSeg){
	PORTD = aSeg;
	PORTB = 0x10;
	_delay_ms(5);
	
	PORTD = bSeg;
	PORTB = 0x20;
	_delay_ms(5);
	
	}

void main(void){
	DDRB = 0x30;
	DDRD = 0xff;
	int data[10] = {0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x27,0x7f,0x6f};
	int val, i, j;
	
	ADCSRA |= 1<<ADPS2;		// set the adc prescaler to 16
	ADMUX |= 1<<ADLAR;		// set the data ragister to 8bit mode(0~255)
	ADMUX |= 1<<REFS0;		// set the voltage reference to AVcc with extarnal capacitor at AREF pin
	ADCSRA |= 1<<ADEN;		// set it to enable adc
	
	while(1){
		if(!(ADCSRA & 1<<ADSC)){	// if ADSC bit in ADCSRA register is 0
			ADCSRA |= 1<<ADSC;		// start adc
			}
		val = ADCH;
		val *= (float)99/255;		// convert the value(0~255) to segment value(0~99)
		j = (val/10)%10;
		i = val%10;	
		Display(data[i], data[j]);
		
		}
	}
