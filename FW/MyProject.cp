#line 1 "D:/projectsCavr/my/MyProject.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for avr/include/built_in.h"
#line 18 "D:/projectsCavr/my/MyProject.c"
char digit_out[20]={192, 249, 164, 176, 153,
 146, 130, 248, 128, 144,255,198,156,167,163,146,135,131,145,194};
char dig1=0 , dig2=0 , dig3=0 , dig4=12 , ndig=0, adig=0;
char i, motor_speed=225 , temp,temp_menu , stby_flag=1, rpm=10, go_flag=0 ;
int temp2=0 ;
float temp_set=180; float temp_curr; float temp3;
char stb_but_flag=0,tdown_but_flag=0,tup_but_flag=0,spdup_but_flag=0,spddown_but_flag=0;

void set_digit(char x){
 i=8;
 while(i!=0){
 i--;
  PORTB.F1 =(x & (1<<i)) ? 1 : 0 ;
  PORTB.F0 =0;
  PORTB.F0 =1;
 }
}

void dectosev(int m){
temp= m/100 ;
dig1=temp;
m =m%100;
temp= m/10;
dig2=temp;
dig3= m%10;

}

void disp() iv IVT_ADDR_TIMER0_OVF
{
temp3+=((ADC_Read(0)-temp3)/3);


 ndig++; if(ndig>4){ndig=1; }
 if(ndig==1) { PORTB.F3 =0;  PORTB.F4 =1;  PORTB.F5 =1;  PORTD.F4 =1; set_digit(digit_out[dig1]);}
 if(ndig==2) { PORTB.F3 =1;  PORTB.F4 =0;  PORTB.F5 =1;  PORTD.F4 =1; set_digit(digit_out[dig2]);}
 if(ndig==3) { PORTB.F3 =1;  PORTB.F4 =1;  PORTB.F5 =0;  PORTD.F4 =1; set_digit(digit_out[dig3]);}
 if(ndig==4) { PORTB.F3 =1;  PORTB.F4 =1;  PORTB.F5 =1;  PORTD.F4 =0; set_digit(digit_out[dig4]);}
 }

void tdispupdate() iv IVT_ADDR_TIMER1_OVF
{
 if (go_flag==1)dectosev(temp_curr);
}

void do_step() iv IVT_ADDR_TIMER2_OVF
{
 PORTD.F5 =1; PORTD.F5 =0;
TCNT2=motor_speed;
}

void butt_stop() iv IVT_ADDR_INT0
{

if(go_flag==1){
  PORTD.F6 =0;
  PORTC.F5 =0;
 go_flag=0;
 }else
 {
 go_flag=1;
 }
 delay_ms(200);
while(PIND2_bit==0) temp_menu=0;
delay_ms(200);
}

int get_adc (char x){
char s;
temp2=0;
for(s=20; s!=0; s-- ) temp2+=ADC_Read(x) ;
 return temp2/20;
}

void button_chk(){
 if(get_adc(1)<1000){
 Delay_ms(50);
 if((get_adc(1)<(483+ 20 ))&&(get_adc(1))>(483- 20 )) spdup_but_flag=1;
 if((get_adc(1)<(408+ 20 ))&&(get_adc(1))>(408- 20 )) spddown_but_flag=1;
 if((get_adc(1)<(312+ 20 ))&&(get_adc(1))>(312- 20 )) tup_but_flag=1;
 if((get_adc(1)<(183+ 20 ))&&(get_adc(1))>(183- 20 )) tdown_but_flag=1;
 if((get_adc(1)<(0+ 20 ))) stb_but_flag=1;
 }

}

void main(){

 DDRD=0b11111011;
 DDRC=0b11110000;
 DDRB=255;
  PORTB.F3  =  PORTB.F4  =  PORTB.F5 =  PORTD.F4  = 1;
  PORTD.F0 =1;
  PORTB.F2 =0;
  PORTD.F6 =0;

 CS02_bit=1;
 CS01_bit=0;
 CS00_bit=0;
 CS10_bit=1;
 CS11_bit=1;
 CS12_bit=0;
 CS22_bit=1;
 CS21_bit=1;
 CS20_bit=1;

 SREG_I_bit=1;
 TOIE0_bit=1;
 TOIE1_bit=1;
 TOIE2_bit=1;
 INT0_bit=1;
 ISC00_bit=0;
 ISC01_bit=0;

 ADC_Init();
 rpm=2;
 Delay_ms(2000);

while(1){
 while (go_flag==0 && stby_flag==0){
 dig1=14;
 dig2=14;
 dig3=14;
 dig4=14;
  PORTD.F6 =0;
 button_chk();
 if (spddown_but_flag||spdup_but_flag)
 { temp_menu=0; dig4=13;
 while(temp_menu<20)
 {
 if (spddown_but_flag){
 rpm--;
 if(rpm<1) rpm=1;
 spddown_but_flag=0;
 temp_menu=0;
 }
 if (spdup_but_flag){
 rpm++;
 if(rpm>100) rpm=100;
 spdup_but_flag=0;
 temp_menu=0;
 }
 motor_speed=255-(200/rpm);
 temp_menu++;
 dectosev(rpm);
 delay_ms(80);
 button_chk();
 }
 }
 if (tup_but_flag||tdown_but_flag)
 { temp_menu=0; dig4=12;
 while(temp_menu<20)
 {
 if (tdown_but_flag){
 temp_set=temp_set-1;
 if(temp_set<100) temp_set=100;
 tdown_but_flag=0;
 temp_menu=0;
 }
 if (tup_but_flag){
 temp_set=temp_set+1;
 if(temp_set>200) temp_set=200;
 tup_but_flag=0;
 temp_menu=0;
 }
 temp_menu++;
 dectosev(temp_set);
 delay_ms(40);
 button_chk();
 }
 }
 if(stb_but_flag){
 stb_but_flag=0;
 stby_flag=1;
 }

 }

while (go_flag==1)
 {
 dig4=12;
 temp_curr = temp3*0.186947+47.4777;
 if(temp_curr<(temp_set- 0.25 ))
 {
  PORTD.F6 =1;
  PORTC.F5 =1;
 }
 if(temp_curr>(temp_set+ 0.25 ))
 {
  PORTD.F6 =0;
  PORTC.F5 =0;
 }
 }
 delay_ms(2000);
 while(stby_flag==1){
  PORTD.F6 =0;
 if(get_adc(0)<150){
 TOIE2_bit=0;
  PORTB.F2 =1;
  PORTD.F0 =0;
 }
 button_chk();
 dig1=15;
 dig2=16;
 dig3=17;
 dig4=18;
 if(stb_but_flag){
 stby_flag=0;
 go_flag=0;
 TOIE2_bit=1;
  PORTB.F2 =0;
  PORTD.F0 =1;
 while(stb_but_flag){
 button_chk();
 stb_but_flag=0;
 Delay_100ms();
 }
 }
 }
}}
