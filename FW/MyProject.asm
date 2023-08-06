
_set_digit:

;MyProject.c,26 :: 		void set_digit(char x){
;MyProject.c,27 :: 		i=8;
	LDI        R27, 8
	STS        _i+0, R27
;MyProject.c,28 :: 		while(i!=0){
L_set_digit0:
	LDS        R16, _i+0
	CPI        R16, 0
	BRNE       L__set_digit102
	JMP        L_set_digit1
L__set_digit102:
;MyProject.c,29 :: 		i--;
	LDS        R16, _i+0
	SUBI       R16, 1
	STS        _i+0, R16
;MyProject.c,30 :: 		DAT=(x & (1<<i)) ? 1 : 0 ;
	MOV        R27, R16
	LDI        R16, 1
	LDI        R17, 0
	TST        R27
	BREQ       L__set_digit104
L__set_digit103:
	LSL        R16
	ROL        R17
	DEC        R27
	BRNE       L__set_digit103
L__set_digit104:
	AND        R16, R2
	ANDI       R17, 0
	MOV        R27, R16
	OR         R27, R17
	BRNE       L__set_digit105
	JMP        L_set_digit2
L__set_digit105:
	LDI        R16, 1
	JMP        L_set_digit3
L_set_digit2:
	LDI        R16, 0
L_set_digit3:
	BST        R16, 0
	IN         R27, PORTB+0
	BLD        R27, 1
	OUT        PORTB+0, R27
;MyProject.c,31 :: 		CLK=0;
	IN         R27, PORTB+0
	CBR        R27, 1
	OUT        PORTB+0, R27
;MyProject.c,32 :: 		CLK=1;
	IN         R27, PORTB+0
	SBR        R27, 1
	OUT        PORTB+0, R27
;MyProject.c,33 :: 		}
	JMP        L_set_digit0
L_set_digit1:
;MyProject.c,34 :: 		}
L_end_set_digit:
	RET
; end of _set_digit

_dectosev:

;MyProject.c,36 :: 		void dectosev(int m){
;MyProject.c,37 :: 		temp= m/100 ;
	PUSH       R3
	PUSH       R2
	LDI        R20, 100
	LDI        R21, 0
	MOVW       R16, R2
	CALL       _Div_16x16_S+0
	MOVW       R16, R22
	POP        R2
	POP        R3
	STS        _temp+0, R16
;MyProject.c,38 :: 		dig1=temp;
	STS        _dig1+0, R16
;MyProject.c,39 :: 		m =m%100;
	PUSH       R3
	PUSH       R2
	LDI        R20, 100
	LDI        R21, 0
	MOVW       R16, R2
	CALL       _Div_16x16_S+0
	MOVW       R16, R24
	POP        R2
	POP        R3
	MOVW       R2, R16
;MyProject.c,40 :: 		temp= m/10;
	PUSH       R3
	PUSH       R2
	LDI        R20, 10
	LDI        R21, 0
	CALL       _Div_16x16_S+0
	MOVW       R16, R22
	POP        R2
	POP        R3
	STS        _temp+0, R16
;MyProject.c,41 :: 		dig2=temp;
	STS        _dig2+0, R16
;MyProject.c,42 :: 		dig3= m%10;
	LDI        R20, 10
	LDI        R21, 0
	MOVW       R16, R2
	CALL       _Div_16x16_S+0
	MOVW       R16, R24
	STS        _dig3+0, R16
;MyProject.c,44 :: 		}
L_end_dectosev:
	RET
; end of _dectosev

_disp:
	PUSH       R30
	PUSH       R31
	PUSH       R27
	IN         R27, SREG+0
	PUSH       R27

;MyProject.c,46 :: 		void disp() iv IVT_ADDR_TIMER0_OVF
;MyProject.c,48 :: 		temp3+=((ADC_Read(0)-temp3)/3);
	PUSH       R2
	CLR        R2
	CALL       _ADC_Read+0
	LDI        R18, 0
	MOV        R19, R18
	CALL       _float_ulong2fp+0
	LDS        R20, _temp3+0
	LDS        R21, _temp3+1
	LDS        R22, _temp3+2
	LDS        R23, _temp3+3
	CALL       _float_fpsub1+0
	LDI        R20, 0
	LDI        R21, 0
	LDI        R22, 64
	LDI        R23, 64
	CALL       _float_fpdiv1+0
	LDS        R20, _temp3+0
	LDS        R21, _temp3+1
	LDS        R22, _temp3+2
	LDS        R23, _temp3+3
	CALL       _float_fpadd1+0
	STS        _temp3+0, R16
	STS        _temp3+1, R17
	STS        _temp3+2, R18
	STS        _temp3+3, R19
;MyProject.c,51 :: 		ndig++; if(ndig>4){ndig=1; }
	LDS        R16, _ndig+0
	MOV        R17, R16
	SUBI       R17, 255
	STS        _ndig+0, R17
	LDI        R16, 4
	CP         R16, R17
	BRLO       L__disp108
	JMP        L_disp4
L__disp108:
	LDI        R27, 1
	STS        _ndig+0, R27
L_disp4:
;MyProject.c,52 :: 		if(ndig==1) {L1=0; L2=1;  L3=1; L4=1;  set_digit(digit_out[dig1]);}
	LDS        R16, _ndig+0
	CPI        R16, 1
	BREQ       L__disp109
	JMP        L_disp5
L__disp109:
	IN         R27, PORTB+0
	CBR        R27, 8
	OUT        PORTB+0, R27
	IN         R27, PORTB+0
	SBR        R27, 16
	OUT        PORTB+0, R27
	IN         R27, PORTB+0
	SBR        R27, 32
	OUT        PORTB+0, R27
	IN         R27, PORTD+0
	SBR        R27, 16
	OUT        PORTD+0, R27
	LDI        R17, #lo_addr(_digit_out+0)
	LDI        R18, hi_addr(_digit_out+0)
	LDS        R16, _dig1+0
	MOV        R30, R16
	LDI        R31, 0
	ADD        R30, R17
	ADC        R31, R18
	LD         R16, Z
	MOV        R2, R16
	CALL       _set_digit+0
L_disp5:
;MyProject.c,53 :: 		if(ndig==2) {L1=1; L2=0;  L3=1; L4=1;  set_digit(digit_out[dig2]);}
	LDS        R16, _ndig+0
	CPI        R16, 2
	BREQ       L__disp110
	JMP        L_disp6
L__disp110:
	IN         R27, PORTB+0
	SBR        R27, 8
	OUT        PORTB+0, R27
	IN         R27, PORTB+0
	CBR        R27, 16
	OUT        PORTB+0, R27
	IN         R27, PORTB+0
	SBR        R27, 32
	OUT        PORTB+0, R27
	IN         R27, PORTD+0
	SBR        R27, 16
	OUT        PORTD+0, R27
	LDI        R17, #lo_addr(_digit_out+0)
	LDI        R18, hi_addr(_digit_out+0)
	LDS        R16, _dig2+0
	MOV        R30, R16
	LDI        R31, 0
	ADD        R30, R17
	ADC        R31, R18
	LD         R16, Z
	MOV        R2, R16
	CALL       _set_digit+0
L_disp6:
;MyProject.c,54 :: 		if(ndig==3) {L1=1; L2=1;  L3=0; L4=1;  set_digit(digit_out[dig3]);}
	LDS        R16, _ndig+0
	CPI        R16, 3
	BREQ       L__disp111
	JMP        L_disp7
L__disp111:
	IN         R27, PORTB+0
	SBR        R27, 8
	OUT        PORTB+0, R27
	IN         R27, PORTB+0
	SBR        R27, 16
	OUT        PORTB+0, R27
	IN         R27, PORTB+0
	CBR        R27, 32
	OUT        PORTB+0, R27
	IN         R27, PORTD+0
	SBR        R27, 16
	OUT        PORTD+0, R27
	LDI        R17, #lo_addr(_digit_out+0)
	LDI        R18, hi_addr(_digit_out+0)
	LDS        R16, _dig3+0
	MOV        R30, R16
	LDI        R31, 0
	ADD        R30, R17
	ADC        R31, R18
	LD         R16, Z
	MOV        R2, R16
	CALL       _set_digit+0
L_disp7:
;MyProject.c,55 :: 		if(ndig==4) {L1=1; L2=1;  L3=1; L4=0;  set_digit(digit_out[dig4]);}
	LDS        R16, _ndig+0
	CPI        R16, 4
	BREQ       L__disp112
	JMP        L_disp8
L__disp112:
	IN         R27, PORTB+0
	SBR        R27, 8
	OUT        PORTB+0, R27
	IN         R27, PORTB+0
	SBR        R27, 16
	OUT        PORTB+0, R27
	IN         R27, PORTB+0
	SBR        R27, 32
	OUT        PORTB+0, R27
	IN         R27, PORTD+0
	CBR        R27, 16
	OUT        PORTD+0, R27
	LDI        R17, #lo_addr(_digit_out+0)
	LDI        R18, hi_addr(_digit_out+0)
	LDS        R16, _dig4+0
	MOV        R30, R16
	LDI        R31, 0
	ADD        R30, R17
	ADC        R31, R18
	LD         R16, Z
	MOV        R2, R16
	CALL       _set_digit+0
L_disp8:
;MyProject.c,56 :: 		}
L_end_disp:
	POP        R2
	POP        R27
	OUT        SREG+0, R27
	POP        R27
	POP        R31
	POP        R30
	RETI
; end of _disp

_tdispupdate:
	PUSH       R30
	PUSH       R31
	PUSH       R27
	IN         R27, SREG+0
	PUSH       R27

;MyProject.c,58 :: 		void tdispupdate() iv IVT_ADDR_TIMER1_OVF
;MyProject.c,60 :: 		if (go_flag==1)dectosev(temp_curr);
	PUSH       R2
	PUSH       R3
	LDS        R16, _go_flag+0
	CPI        R16, 1
	BREQ       L__tdispupdate114
	JMP        L_tdispupdate9
L__tdispupdate114:
	LDS        R16, _temp_curr+0
	LDS        R17, _temp_curr+1
	LDS        R18, _temp_curr+2
	LDS        R19, _temp_curr+3
	CALL       _float_fpint+0
	MOVW       R2, R16
	CALL       _dectosev+0
L_tdispupdate9:
;MyProject.c,61 :: 		}
L_end_tdispupdate:
	POP        R3
	POP        R2
	POP        R27
	OUT        SREG+0, R27
	POP        R27
	POP        R31
	POP        R30
	RETI
; end of _tdispupdate

_do_step:
	PUSH       R30
	PUSH       R31
	PUSH       R27
	IN         R27, SREG+0
	PUSH       R27

;MyProject.c,63 :: 		void do_step() iv IVT_ADDR_TIMER2_OVF
;MyProject.c,65 :: 		STEP=1;STEP=0;
	IN         R27, PORTD+0
	SBR        R27, 32
	OUT        PORTD+0, R27
	IN         R27, PORTD+0
	CBR        R27, 32
	OUT        PORTD+0, R27
;MyProject.c,66 :: 		TCNT2=motor_speed;
	LDS        R16, _motor_speed+0
	OUT        TCNT2+0, R16
;MyProject.c,67 :: 		}
L_end_do_step:
	POP        R27
	OUT        SREG+0, R27
	POP        R27
	POP        R31
	POP        R30
	RETI
; end of _do_step

_butt_stop:
	PUSH       R30
	PUSH       R31
	PUSH       R27
	IN         R27, SREG+0
	PUSH       R27

;MyProject.c,69 :: 		void butt_stop() iv IVT_ADDR_INT0
;MyProject.c,72 :: 		if(go_flag==1){
	LDS        R16, _go_flag+0
	CPI        R16, 1
	BREQ       L__butt_stop117
	JMP        L_butt_stop10
L__butt_stop117:
;MyProject.c,73 :: 		HEAT=0;
	IN         R27, PORTD+0
	CBR        R27, 64
	OUT        PORTD+0, R27
;MyProject.c,74 :: 		HEAT_LED=0;
	IN         R27, PORTC+0
	CBR        R27, 32
	OUT        PORTC+0, R27
;MyProject.c,75 :: 		go_flag=0;
	LDI        R27, 0
	STS        _go_flag+0, R27
;MyProject.c,76 :: 		}else
	JMP        L_butt_stop11
L_butt_stop10:
;MyProject.c,78 :: 		go_flag=1;
	LDI        R27, 1
	STS        _go_flag+0, R27
;MyProject.c,79 :: 		}
L_butt_stop11:
;MyProject.c,80 :: 		delay_ms(200);
	LDI        R18, 13
	LDI        R17, 45
	LDI        R16, 216
L_butt_stop12:
	DEC        R16
	BRNE       L_butt_stop12
	DEC        R17
	BRNE       L_butt_stop12
	DEC        R18
	BRNE       L_butt_stop12
	NOP
	NOP
;MyProject.c,81 :: 		while(PIND2_bit==0) temp_menu=0;
L_butt_stop14:
	IN         R27, PIND2_bit+0
	SBRC       R27, BitPos(PIND2_bit+0)
	JMP        L_butt_stop15
	LDI        R27, 0
	STS        _temp_menu+0, R27
	JMP        L_butt_stop14
L_butt_stop15:
;MyProject.c,82 :: 		delay_ms(200);
	LDI        R18, 13
	LDI        R17, 45
	LDI        R16, 216
L_butt_stop16:
	DEC        R16
	BRNE       L_butt_stop16
	DEC        R17
	BRNE       L_butt_stop16
	DEC        R18
	BRNE       L_butt_stop16
	NOP
	NOP
;MyProject.c,83 :: 		}
L_end_butt_stop:
	POP        R27
	OUT        SREG+0, R27
	POP        R27
	POP        R31
	POP        R30
	RETI
; end of _butt_stop

_get_adc:

;MyProject.c,85 :: 		int get_adc (char x){
;MyProject.c,87 :: 		temp2=0;
	LDI        R27, 0
	STS        _temp2+0, R27
	STS        _temp2+1, R27
;MyProject.c,88 :: 		for(s=20; s!=0; s-- ) temp2+=ADC_Read(x) ;
; s start address is: 20 (R20)
	LDI        R20, 20
; s end address is: 20 (R20)
L_get_adc18:
; s start address is: 20 (R20)
	CPI        R20, 0
	BRNE       L__get_adc119
	JMP        L_get_adc19
L__get_adc119:
	CALL       _ADC_Read+0
	LDS        R18, _temp2+0
	LDS        R19, _temp2+1
	ADD        R16, R18
	ADC        R17, R19
	STS        _temp2+0, R16
	STS        _temp2+1, R17
	MOV        R16, R20
	SUBI       R16, 1
	MOV        R20, R16
; s end address is: 20 (R20)
	JMP        L_get_adc18
L_get_adc19:
;MyProject.c,89 :: 		return  temp2/20;
	PUSH       R2
	LDI        R20, 20
	LDI        R21, 0
	LDS        R16, _temp2+0
	LDS        R17, _temp2+1
	CALL       _Div_16x16_S+0
	MOVW       R16, R22
	POP        R2
;MyProject.c,90 :: 		}
L_end_get_adc:
	RET
; end of _get_adc

_button_chk:

;MyProject.c,92 :: 		void button_chk(){
;MyProject.c,93 :: 		if(get_adc(1)<1000){
	PUSH       R2
	LDI        R27, 1
	MOV        R2, R27
	CALL       _get_adc+0
	LDI        R18, 232
	LDI        R19, 3
	CP         R16, R18
	CPC        R17, R19
	BRLT       L__button_chk121
	JMP        L_button_chk21
L__button_chk121:
;MyProject.c,94 :: 		Delay_ms(50);
	LDI        R18, 4
	LDI        R17, 12
	LDI        R16, 52
L_button_chk22:
	DEC        R16
	BRNE       L_button_chk22
	DEC        R17
	BRNE       L_button_chk22
	DEC        R18
	BRNE       L_button_chk22
	NOP
	NOP
;MyProject.c,95 :: 		if((get_adc(1)<(483+ADC_HYST))&&(get_adc(1))>(483-ADC_HYST)) spdup_but_flag=1;
	LDI        R27, 1
	MOV        R2, R27
	CALL       _get_adc+0
	LDI        R18, 247
	LDI        R19, 1
	CP         R16, R18
	CPC        R17, R19
	BRLT       L__button_chk122
	JMP        L__button_chk85
L__button_chk122:
	LDI        R27, 1
	MOV        R2, R27
	CALL       _get_adc+0
	LDI        R18, 207
	LDI        R19, 1
	CP         R18, R16
	CPC        R19, R17
	BRLT       L__button_chk123
	JMP        L__button_chk84
L__button_chk123:
L__button_chk83:
	LDI        R27, 1
	STS        _spdup_but_flag+0, R27
L__button_chk85:
L__button_chk84:
;MyProject.c,96 :: 		if((get_adc(1)<(408+ADC_HYST))&&(get_adc(1))>(408-ADC_HYST)) spddown_but_flag=1;
	LDI        R27, 1
	MOV        R2, R27
	CALL       _get_adc+0
	LDI        R18, 172
	LDI        R19, 1
	CP         R16, R18
	CPC        R17, R19
	BRLT       L__button_chk124
	JMP        L__button_chk87
L__button_chk124:
	LDI        R27, 1
	MOV        R2, R27
	CALL       _get_adc+0
	LDI        R18, 132
	LDI        R19, 1
	CP         R18, R16
	CPC        R19, R17
	BRLT       L__button_chk125
	JMP        L__button_chk86
L__button_chk125:
L__button_chk82:
	LDI        R27, 1
	STS        _spddown_but_flag+0, R27
L__button_chk87:
L__button_chk86:
;MyProject.c,97 :: 		if((get_adc(1)<(312+ADC_HYST))&&(get_adc(1))>(312-ADC_HYST)) tup_but_flag=1;
	LDI        R27, 1
	MOV        R2, R27
	CALL       _get_adc+0
	LDI        R18, 76
	LDI        R19, 1
	CP         R16, R18
	CPC        R17, R19
	BRLT       L__button_chk126
	JMP        L__button_chk89
L__button_chk126:
	LDI        R27, 1
	MOV        R2, R27
	CALL       _get_adc+0
	LDI        R18, 36
	LDI        R19, 1
	CP         R18, R16
	CPC        R19, R17
	BRLT       L__button_chk127
	JMP        L__button_chk88
L__button_chk127:
L__button_chk81:
	LDI        R27, 1
	STS        _tup_but_flag+0, R27
L__button_chk89:
L__button_chk88:
;MyProject.c,98 :: 		if((get_adc(1)<(183+ADC_HYST))&&(get_adc(1))>(183-ADC_HYST)) tdown_but_flag=1;
	LDI        R27, 1
	MOV        R2, R27
	CALL       _get_adc+0
	LDI        R18, 203
	LDI        R19, 0
	CP         R16, R18
	CPC        R17, R19
	BRLT       L__button_chk128
	JMP        L__button_chk91
L__button_chk128:
	LDI        R27, 1
	MOV        R2, R27
	CALL       _get_adc+0
	LDI        R18, 163
	LDI        R19, 0
	CP         R18, R16
	CPC        R19, R17
	BRLT       L__button_chk129
	JMP        L__button_chk90
L__button_chk129:
L__button_chk80:
	LDI        R27, 1
	STS        _tdown_but_flag+0, R27
L__button_chk91:
L__button_chk90:
;MyProject.c,99 :: 		if((get_adc(1)<(0+ADC_HYST))) stb_but_flag=1;
	LDI        R27, 1
	MOV        R2, R27
	CALL       _get_adc+0
	LDI        R18, 20
	LDI        R19, 0
	CP         R16, R18
	CPC        R17, R19
	BRLT       L__button_chk130
	JMP        L_button_chk36
L__button_chk130:
	LDI        R27, 1
	STS        _stb_but_flag+0, R27
L_button_chk36:
;MyProject.c,100 :: 		}
L_button_chk21:
;MyProject.c,102 :: 		}
L_end_button_chk:
	POP        R2
	RET
; end of _button_chk

_main:
	LDI        R27, 255
	OUT        SPL+0, R27
	LDI        R27, 0
	OUT        SPL+1, R27
	IN         R28, SPL+0
	IN         R29, SPL+1
	SBIW       R28, 4
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	ADIW       R28, 1

;MyProject.c,104 :: 		void main(){
;MyProject.c,106 :: 		DDRD=0b11111011;
	PUSH       R2
	PUSH       R3
	LDI        R27, 251
	OUT        DDRD+0, R27
;MyProject.c,107 :: 		DDRC=0b11110000;
	LDI        R27, 240
	OUT        DDRC+0, R27
;MyProject.c,108 :: 		DDRB=255;
	LDI        R27, 255
	OUT        DDRB+0, R27
;MyProject.c,109 :: 		L1 = L2 = L3= L4 = 1;
	IN         R27, PORTD+0
	SBR        R27, 16
	OUT        PORTD+0, R27
	IN         R27, PORTD+0
	BST        R27, 4
	IN         R27, PORTB+0
	BLD        R27, 5
	OUT        PORTB+0, R27
	IN         R27, PORTB+0
	BST        R27, 5
	IN         R27, PORTB+0
	BLD        R27, 4
	OUT        PORTB+0, R27
	IN         R27, PORTB+0
	BST        R27, 4
	IN         R27, PORTB+0
	BLD        R27, 3
	OUT        PORTB+0, R27
;MyProject.c,110 :: 		P_ON=1;
	IN         R27, PORTD+0
	SBR        R27, 1
	OUT        PORTD+0, R27
;MyProject.c,111 :: 		EN=0;
	IN         R27, PORTB+0
	CBR        R27, 4
	OUT        PORTB+0, R27
;MyProject.c,112 :: 		HEAT=0;
	IN         R27, PORTD+0
	CBR        R27, 64
	OUT        PORTD+0, R27
;MyProject.c,114 :: 		CS02_bit=1;
	IN         R27, CS02_bit+0
	SBR        R27, BitMask(CS02_bit+0)
	OUT        CS02_bit+0, R27
;MyProject.c,115 :: 		CS01_bit=0;
	IN         R27, CS01_bit+0
	CBR        R27, BitMask(CS01_bit+0)
	OUT        CS01_bit+0, R27
;MyProject.c,116 :: 		CS00_bit=0;
	IN         R27, CS00_bit+0
	CBR        R27, BitMask(CS00_bit+0)
	OUT        CS00_bit+0, R27
;MyProject.c,117 :: 		CS10_bit=1;
	IN         R27, CS10_bit+0
	SBR        R27, BitMask(CS10_bit+0)
	OUT        CS10_bit+0, R27
;MyProject.c,118 :: 		CS11_bit=1;
	IN         R27, CS11_bit+0
	SBR        R27, BitMask(CS11_bit+0)
	OUT        CS11_bit+0, R27
;MyProject.c,119 :: 		CS12_bit=0;
	IN         R27, CS12_bit+0
	CBR        R27, BitMask(CS12_bit+0)
	OUT        CS12_bit+0, R27
;MyProject.c,120 :: 		CS22_bit=1;
	IN         R27, CS22_bit+0
	SBR        R27, BitMask(CS22_bit+0)
	OUT        CS22_bit+0, R27
;MyProject.c,121 :: 		CS21_bit=1;
	IN         R27, CS21_bit+0
	SBR        R27, BitMask(CS21_bit+0)
	OUT        CS21_bit+0, R27
;MyProject.c,122 :: 		CS20_bit=1;
	IN         R27, CS20_bit+0
	SBR        R27, BitMask(CS20_bit+0)
	OUT        CS20_bit+0, R27
;MyProject.c,124 :: 		SREG_I_bit=1;
	IN         R27, SREG_I_bit+0
	SBR        R27, BitMask(SREG_I_bit+0)
	OUT        SREG_I_bit+0, R27
;MyProject.c,125 :: 		TOIE0_bit=1;
	IN         R27, TOIE0_bit+0
	SBR        R27, BitMask(TOIE0_bit+0)
	OUT        TOIE0_bit+0, R27
;MyProject.c,126 :: 		TOIE1_bit=1;
	IN         R27, TOIE1_bit+0
	SBR        R27, BitMask(TOIE1_bit+0)
	OUT        TOIE1_bit+0, R27
;MyProject.c,127 :: 		TOIE2_bit=1;
	IN         R27, TOIE2_bit+0
	SBR        R27, BitMask(TOIE2_bit+0)
	OUT        TOIE2_bit+0, R27
;MyProject.c,128 :: 		INT0_bit=1;
	IN         R27, INT0_bit+0
	SBR        R27, BitMask(INT0_bit+0)
	OUT        INT0_bit+0, R27
;MyProject.c,129 :: 		ISC00_bit=0;
	IN         R27, ISC00_bit+0
	CBR        R27, BitMask(ISC00_bit+0)
	OUT        ISC00_bit+0, R27
;MyProject.c,130 :: 		ISC01_bit=0;
	IN         R27, ISC01_bit+0
	CBR        R27, BitMask(ISC01_bit+0)
	OUT        ISC01_bit+0, R27
;MyProject.c,132 :: 		ADC_Init();
	CALL       _ADC_Init+0
;MyProject.c,133 :: 		rpm=2;
	LDI        R27, 2
	STS        _rpm+0, R27
;MyProject.c,134 :: 		Delay_ms(2000);
	LDI        R18, 122
	LDI        R17, 193
	LDI        R16, 130
L_main37:
	DEC        R16
	BRNE       L_main37
	DEC        R17
	BRNE       L_main37
	DEC        R18
	BRNE       L_main37
	NOP
	NOP
;MyProject.c,136 :: 		while(1){
L_main39:
;MyProject.c,137 :: 		while (go_flag==0 && stby_flag==0){
L_main41:
	LDS        R16, _go_flag+0
	CPI        R16, 0
	BREQ       L__main132
	JMP        L__main100
L__main132:
	LDS        R16, _stby_flag+0
	CPI        R16, 0
	BREQ       L__main133
	JMP        L__main99
L__main133:
L__main94:
;MyProject.c,138 :: 		dig1=14;
	LDI        R27, 14
	STS        _dig1+0, R27
;MyProject.c,139 :: 		dig2=14;
	LDI        R27, 14
	STS        _dig2+0, R27
;MyProject.c,140 :: 		dig3=14;
	LDI        R27, 14
	STS        _dig3+0, R27
;MyProject.c,141 :: 		dig4=14;
	LDI        R27, 14
	STS        _dig4+0, R27
;MyProject.c,142 :: 		HEAT=0;
	IN         R27, PORTD+0
	CBR        R27, 64
	OUT        PORTD+0, R27
;MyProject.c,143 :: 		button_chk();
	CALL       _button_chk+0
;MyProject.c,144 :: 		if (spddown_but_flag||spdup_but_flag)
	LDS        R16, _spddown_but_flag+0
	TST        R16
	BREQ       L__main134
	JMP        L__main96
L__main134:
	LDS        R16, _spdup_but_flag+0
	TST        R16
	BREQ       L__main135
	JMP        L__main95
L__main135:
	JMP        L_main47
L__main96:
L__main95:
;MyProject.c,145 :: 		{  temp_menu=0; dig4=13;
	LDI        R27, 0
	STS        _temp_menu+0, R27
	LDI        R27, 13
	STS        _dig4+0, R27
;MyProject.c,146 :: 		while(temp_menu<20)
L_main48:
	LDS        R16, _temp_menu+0
	CPI        R16, 20
	BRLO       L__main136
	JMP        L_main49
L__main136:
;MyProject.c,148 :: 		if (spddown_but_flag){
	LDS        R16, _spddown_but_flag+0
	TST        R16
	BRNE       L__main137
	JMP        L_main50
L__main137:
;MyProject.c,149 :: 		rpm--;
	LDS        R16, _rpm+0
	SUBI       R16, 1
	STS        _rpm+0, R16
;MyProject.c,150 :: 		if(rpm<1) rpm=1;
	CPI        R16, 1
	BRLO       L__main138
	JMP        L_main51
L__main138:
	LDI        R27, 1
	STS        _rpm+0, R27
L_main51:
;MyProject.c,151 :: 		spddown_but_flag=0;
	LDI        R27, 0
	STS        _spddown_but_flag+0, R27
;MyProject.c,152 :: 		temp_menu=0;
	LDI        R27, 0
	STS        _temp_menu+0, R27
;MyProject.c,153 :: 		}
L_main50:
;MyProject.c,154 :: 		if (spdup_but_flag){
	LDS        R16, _spdup_but_flag+0
	TST        R16
	BRNE       L__main139
	JMP        L_main52
L__main139:
;MyProject.c,155 :: 		rpm++;
	LDS        R16, _rpm+0
	MOV        R17, R16
	SUBI       R17, 255
	STS        _rpm+0, R17
;MyProject.c,156 :: 		if(rpm>100) rpm=100;
	LDI        R16, 100
	CP         R16, R17
	BRLO       L__main140
	JMP        L_main53
L__main140:
	LDI        R27, 100
	STS        _rpm+0, R27
L_main53:
;MyProject.c,157 :: 		spdup_but_flag=0;
	LDI        R27, 0
	STS        _spdup_but_flag+0, R27
;MyProject.c,158 :: 		temp_menu=0;
	LDI        R27, 0
	STS        _temp_menu+0, R27
;MyProject.c,159 :: 		}
L_main52:
;MyProject.c,160 :: 		motor_speed=255-(200/rpm);
	LDI        R16, 200
	LDS        R20, _rpm+0
	CALL       _Div_8x8_U+0
	MOV        R0, R16
	LDI        R16, 255
	SUB        R16, R0
	STS        _motor_speed+0, R16
;MyProject.c,161 :: 		temp_menu++;
	LDS        R16, _temp_menu+0
	SUBI       R16, 255
	STS        _temp_menu+0, R16
;MyProject.c,162 :: 		dectosev(rpm);
	LDS        R2, _rpm+0
	LDI        R27, 0
	MOV        R3, R27
	CALL       _dectosev+0
;MyProject.c,163 :: 		delay_ms(80);
	LDI        R18, 5
	LDI        R17, 223
	LDI        R16, 188
L_main54:
	DEC        R16
	BRNE       L_main54
	DEC        R17
	BRNE       L_main54
	DEC        R18
	BRNE       L_main54
	NOP
	NOP
;MyProject.c,164 :: 		button_chk();
	CALL       _button_chk+0
;MyProject.c,165 :: 		}
	JMP        L_main48
L_main49:
;MyProject.c,166 :: 		}
L_main47:
;MyProject.c,167 :: 		if (tup_but_flag||tdown_but_flag)
	LDS        R16, _tup_but_flag+0
	TST        R16
	BREQ       L__main141
	JMP        L__main98
L__main141:
	LDS        R16, _tdown_but_flag+0
	TST        R16
	BREQ       L__main142
	JMP        L__main97
L__main142:
	JMP        L_main58
L__main98:
L__main97:
;MyProject.c,168 :: 		{  temp_menu=0; dig4=12;
	LDI        R27, 0
	STS        _temp_menu+0, R27
	LDI        R27, 12
	STS        _dig4+0, R27
;MyProject.c,169 :: 		while(temp_menu<20)
L_main59:
	LDS        R16, _temp_menu+0
	CPI        R16, 20
	BRLO       L__main143
	JMP        L_main60
L__main143:
;MyProject.c,171 :: 		if (tdown_but_flag){
	LDS        R16, _tdown_but_flag+0
	TST        R16
	BRNE       L__main144
	JMP        L_main61
L__main144:
;MyProject.c,172 :: 		temp_set=temp_set-1;
	LDI        R20, 0
	LDI        R21, 0
	LDI        R22, 128
	LDI        R23, 63
	LDS        R16, _temp_set+0
	LDS        R17, _temp_set+1
	LDS        R18, _temp_set+2
	LDS        R19, _temp_set+3
	CALL       _float_fpsub1+0
	STS        _temp_set+0, R16
	STS        _temp_set+1, R17
	STS        _temp_set+2, R18
	STS        _temp_set+3, R19
;MyProject.c,173 :: 		if(temp_set<100) temp_set=100;
	LDI        R20, 0
	LDI        R21, 0
	LDI        R22, 200
	LDI        R23, 66
	CALL       _float_op_less+0
	OR         R0, R0
	LDI        R27, 0
	BREQ       L__main145
	LDI        R27, 1
L__main145:
	MOV        R16, R27
	TST        R16
	BRNE       L__main146
	JMP        L_main62
L__main146:
	LDI        R27, 0
	STS        _temp_set+0, R27
	STS        _temp_set+1, R27
	LDI        R27, 200
	STS        _temp_set+2, R27
	LDI        R27, 66
	STS        _temp_set+3, R27
L_main62:
;MyProject.c,174 :: 		tdown_but_flag=0;
	LDI        R27, 0
	STS        _tdown_but_flag+0, R27
;MyProject.c,175 :: 		temp_menu=0;
	LDI        R27, 0
	STS        _temp_menu+0, R27
;MyProject.c,176 :: 		}
L_main61:
;MyProject.c,177 :: 		if (tup_but_flag){
	LDS        R16, _tup_but_flag+0
	TST        R16
	BRNE       L__main147
	JMP        L_main63
L__main147:
;MyProject.c,178 :: 		temp_set=temp_set+1;
	LDS        R16, _temp_set+0
	LDS        R17, _temp_set+1
	LDS        R18, _temp_set+2
	LDS        R19, _temp_set+3
	LDI        R20, 0
	LDI        R21, 0
	LDI        R22, 128
	LDI        R23, 63
	CALL       _float_fpadd1+0
	STS        _temp_set+0, R16
	STS        _temp_set+1, R17
	STS        _temp_set+2, R18
	STS        _temp_set+3, R19
;MyProject.c,179 :: 		if(temp_set>200) temp_set=200;
	LDI        R20, 0
	LDI        R21, 0
	LDI        R22, 72
	LDI        R23, 67
	CALL       _float_op_big+0
	OR         R0, R0
	LDI        R27, 0
	BREQ       L__main148
	LDI        R27, 1
L__main148:
	MOV        R16, R27
	TST        R16
	BRNE       L__main149
	JMP        L_main64
L__main149:
	LDI        R27, 0
	STS        _temp_set+0, R27
	STS        _temp_set+1, R27
	LDI        R27, 72
	STS        _temp_set+2, R27
	LDI        R27, 67
	STS        _temp_set+3, R27
L_main64:
;MyProject.c,180 :: 		tup_but_flag=0;
	LDI        R27, 0
	STS        _tup_but_flag+0, R27
;MyProject.c,181 :: 		temp_menu=0;
	LDI        R27, 0
	STS        _temp_menu+0, R27
;MyProject.c,182 :: 		}
L_main63:
;MyProject.c,183 :: 		temp_menu++;
	LDS        R16, _temp_menu+0
	SUBI       R16, 255
	STS        _temp_menu+0, R16
;MyProject.c,184 :: 		dectosev(temp_set);
	LDS        R16, _temp_set+0
	LDS        R17, _temp_set+1
	LDS        R18, _temp_set+2
	LDS        R19, _temp_set+3
	CALL       _float_fpint+0
	MOVW       R2, R16
	CALL       _dectosev+0
;MyProject.c,185 :: 		delay_ms(40);
	LDI        R18, 3
	LDI        R17, 112
	LDI        R16, 93
L_main65:
	DEC        R16
	BRNE       L_main65
	DEC        R17
	BRNE       L_main65
	DEC        R18
	BRNE       L_main65
	NOP
;MyProject.c,186 :: 		button_chk();
	CALL       _button_chk+0
;MyProject.c,187 :: 		}
	JMP        L_main59
L_main60:
;MyProject.c,188 :: 		}
L_main58:
;MyProject.c,189 :: 		if(stb_but_flag){
	LDS        R16, _stb_but_flag+0
	TST        R16
	BRNE       L__main150
	JMP        L_main67
L__main150:
;MyProject.c,190 :: 		stb_but_flag=0;
	LDI        R27, 0
	STS        _stb_but_flag+0, R27
;MyProject.c,191 :: 		stby_flag=1;
	LDI        R27, 1
	STS        _stby_flag+0, R27
;MyProject.c,192 :: 		}
L_main67:
;MyProject.c,194 :: 		}
	JMP        L_main41
;MyProject.c,137 :: 		while (go_flag==0 && stby_flag==0){
L__main100:
L__main99:
;MyProject.c,196 :: 		while (go_flag==1)
L_main68:
	LDS        R16, _go_flag+0
	CPI        R16, 1
	BREQ       L__main151
	JMP        L_main69
L__main151:
;MyProject.c,198 :: 		dig4=12;
	LDI        R27, 12
	STS        _dig4+0, R27
;MyProject.c,199 :: 		temp_curr = temp3*0.186947+47.4777;
	LDS        R16, _temp3+0
	LDS        R17, _temp3+1
	LDS        R18, _temp3+2
	LDS        R19, _temp3+3
	LDI        R20, 9
	LDI        R21, 111
	LDI        R22, 63
	LDI        R23, 62
	CALL       _float_fpmul1+0
	LDI        R20, 42
	LDI        R21, 233
	LDI        R22, 61
	LDI        R23, 66
	CALL       _float_fpadd1+0
	STD        Y+0, R16
	STD        Y+1, R17
	STD        Y+2, R18
	STD        Y+3, R19
	STS        _temp_curr+0, R16
	STS        _temp_curr+1, R17
	STS        _temp_curr+2, R18
	STS        _temp_curr+3, R19
;MyProject.c,200 :: 		if(temp_curr<(temp_set-HYST))
	LDI        R20, 0
	LDI        R21, 0
	LDI        R22, 128
	LDI        R23, 62
	LDS        R16, _temp_set+0
	LDS        R17, _temp_set+1
	LDS        R18, _temp_set+2
	LDS        R19, _temp_set+3
	CALL       _float_fpsub1+0
	LDD        R20, Y+0
	LDD        R21, Y+1
	LDD        R22, Y+2
	LDD        R23, Y+3
	CALL       _float_op_big+0
	OR         R0, R0
	LDI        R27, 0
	BREQ       L__main152
	LDI        R27, 1
L__main152:
	MOV        R16, R27
	TST        R16
	BRNE       L__main153
	JMP        L_main70
L__main153:
;MyProject.c,202 :: 		HEAT=1;
	IN         R27, PORTD+0
	SBR        R27, 64
	OUT        PORTD+0, R27
;MyProject.c,203 :: 		HEAT_LED=1;
	IN         R27, PORTC+0
	SBR        R27, 32
	OUT        PORTC+0, R27
;MyProject.c,204 :: 		}
L_main70:
;MyProject.c,205 :: 		if(temp_curr>(temp_set+HYST))
	LDS        R16, _temp_set+0
	LDS        R17, _temp_set+1
	LDS        R18, _temp_set+2
	LDS        R19, _temp_set+3
	LDI        R20, 0
	LDI        R21, 0
	LDI        R22, 128
	LDI        R23, 62
	CALL       _float_fpadd1+0
	MOVW       R20, R16
	MOVW       R22, R18
	LDS        R16, _temp_curr+0
	LDS        R17, _temp_curr+1
	LDS        R18, _temp_curr+2
	LDS        R19, _temp_curr+3
	CALL       _float_op_big+0
	OR         R0, R0
	LDI        R16, 0
	BREQ       L__main154
	LDI        R16, 1
L__main154:
	TST        R16
	BRNE       L__main155
	JMP        L_main71
L__main155:
;MyProject.c,207 :: 		HEAT=0;
	IN         R27, PORTD+0
	CBR        R27, 64
	OUT        PORTD+0, R27
;MyProject.c,208 :: 		HEAT_LED=0;
	IN         R27, PORTC+0
	CBR        R27, 32
	OUT        PORTC+0, R27
;MyProject.c,209 :: 		}
L_main71:
;MyProject.c,210 :: 		}
	JMP        L_main68
L_main69:
;MyProject.c,211 :: 		delay_ms(2000);
	LDI        R18, 122
	LDI        R17, 193
	LDI        R16, 130
L_main72:
	DEC        R16
	BRNE       L_main72
	DEC        R17
	BRNE       L_main72
	DEC        R18
	BRNE       L_main72
	NOP
	NOP
;MyProject.c,212 :: 		while(stby_flag==1){
L_main74:
	LDS        R16, _stby_flag+0
	CPI        R16, 1
	BREQ       L__main156
	JMP        L_main75
L__main156:
;MyProject.c,213 :: 		HEAT=0;
	IN         R27, PORTD+0
	CBR        R27, 64
	OUT        PORTD+0, R27
;MyProject.c,214 :: 		if(get_adc(0)<150){
	CLR        R2
	CALL       _get_adc+0
	LDI        R18, 150
	LDI        R19, 0
	CP         R16, R18
	CPC        R17, R19
	BRLT       L__main157
	JMP        L_main76
L__main157:
;MyProject.c,215 :: 		TOIE2_bit=0;
	IN         R27, TOIE2_bit+0
	CBR        R27, BitMask(TOIE2_bit+0)
	OUT        TOIE2_bit+0, R27
;MyProject.c,216 :: 		EN=1;
	IN         R27, PORTB+0
	SBR        R27, 4
	OUT        PORTB+0, R27
;MyProject.c,217 :: 		P_ON=0;
	IN         R27, PORTD+0
	CBR        R27, 1
	OUT        PORTD+0, R27
;MyProject.c,218 :: 		}
L_main76:
;MyProject.c,219 :: 		button_chk();
	CALL       _button_chk+0
;MyProject.c,220 :: 		dig1=15;
	LDI        R27, 15
	STS        _dig1+0, R27
;MyProject.c,221 :: 		dig2=16;
	LDI        R27, 16
	STS        _dig2+0, R27
;MyProject.c,222 :: 		dig3=17;
	LDI        R27, 17
	STS        _dig3+0, R27
;MyProject.c,223 :: 		dig4=18;
	LDI        R27, 18
	STS        _dig4+0, R27
;MyProject.c,224 :: 		if(stb_but_flag){
	LDS        R16, _stb_but_flag+0
	TST        R16
	BRNE       L__main158
	JMP        L_main77
L__main158:
;MyProject.c,225 :: 		stby_flag=0;
	LDI        R27, 0
	STS        _stby_flag+0, R27
;MyProject.c,226 :: 		go_flag=0;
	LDI        R27, 0
	STS        _go_flag+0, R27
;MyProject.c,227 :: 		TOIE2_bit=1;
	IN         R27, TOIE2_bit+0
	SBR        R27, BitMask(TOIE2_bit+0)
	OUT        TOIE2_bit+0, R27
;MyProject.c,228 :: 		EN=0;
	IN         R27, PORTB+0
	CBR        R27, 4
	OUT        PORTB+0, R27
;MyProject.c,229 :: 		P_ON=1;
	IN         R27, PORTD+0
	SBR        R27, 1
	OUT        PORTD+0, R27
;MyProject.c,230 :: 		while(stb_but_flag){
L_main78:
	LDS        R16, _stb_but_flag+0
	TST        R16
	BRNE       L__main159
	JMP        L_main79
L__main159:
;MyProject.c,231 :: 		button_chk();
	CALL       _button_chk+0
;MyProject.c,232 :: 		stb_but_flag=0;
	LDI        R27, 0
	STS        _stb_but_flag+0, R27
;MyProject.c,233 :: 		Delay_100ms();
	CALL       _Delay_100ms+0
;MyProject.c,234 :: 		}
	JMP        L_main78
L_main79:
;MyProject.c,235 :: 		}
L_main77:
;MyProject.c,236 :: 		}
	JMP        L_main74
L_main75:
;MyProject.c,237 :: 		}}
	JMP        L_main39
L_end_main:
	POP        R3
	POP        R2
L__main_end_loop:
	JMP        L__main_end_loop
; end of _main
