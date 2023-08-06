// This is a simple Solder station on ATmega8. Uses 7seg display through shift registers
// Based on ATX PSU
#include <built_in.h>
#define P_ON PORTD.F0     // Enable PSU
#define HEAT_LED PORTC.F5 // LED
#define FAN PORTD.F5      // PSU fan
#define HEAT PORTD.F6     // Heater MOSFET
#define CLK PORTB.F0      // Display shift regs
#define DAT PORTB.F1      //
#define L1 PORTB.F3       //Display common anode 1
#define L2 PORTB.F4       //Display common anode 2
#define L3 PORTB.F5       //Display common anode 3
#define L4 PORTD.F4       //Display common anode 4
//********************
// CONST
#define ADC_HYST 20
#define HYST 0.25
//********************
char digit_out[20] = {192, 249, 164, 176, 153,
                      146, 130, 248, 128, 144, 255, 198, 156, 167, 163, 146, 135, 131, 145, 194};
char dig1 = 0, dig2 = 0, dig3 = 0, dig4 = 12, ndig = 0, adig = 0;
char i, motor_speed = 225, temp, temp_menu, stby_flag = 1, rpm = 10, go_flag = 0;
int temp2 = 0;
float temp_set = 180;
float temp_curr;
float temp3;
char stb_but_flag = 0, tdown_but_flag = 0, tup_but_flag = 0, spdup_but_flag = 0, spddown_but_flag = 0;
//********************//********************
void set_digit(char x)
{
  i = 8;
  while (i != 0)
  {
    i--;
    DAT = (x & (1 << i)) ? 1 : 0;
    CLK = 0;
    CLK = 1;
  }
}
//********************//********************
void dectosev(int m)
{
  temp = m / 100;
  dig1 = temp;
  m = m % 100;
  temp = m / 10;
  dig2 = temp;
  dig3 = m % 10;
}
//********************//********************
void disp() iv IVT_ADDR_TIMER0_OVF
{
  temp3 += ((ADC_Read(0) - temp3) / 3);

  // adig++; if(adig>10){adig=1; }
  ndig++;
  if (ndig > 4)
  {
    ndig = 1;
  }
  if (ndig == 1)
  {
    L1 = 0;
    L2 = 1;
    L3 = 1;
    L4 = 1;
    set_digit(digit_out[dig1]);
  }
  if (ndig == 2)
  {
    L1 = 1;
    L2 = 0;
    L3 = 1;
    L4 = 1;
    set_digit(digit_out[dig2]);
  }
  if (ndig == 3)
  {
    L1 = 1;
    L2 = 1;
    L3 = 0;
    L4 = 1;
    set_digit(digit_out[dig3]);
  }
  if (ndig == 4)
  {
    L1 = 1;
    L2 = 1;
    L3 = 1;
    L4 = 0;
    set_digit(digit_out[dig4]);
  }
}
//***************INT_UPS********************
void tdispupdate() iv IVT_ADDR_TIMER1_OVF
{
  if (go_flag == 1)
    dectosev(temp_curr);
}
//********************//********************
void do_step() iv IVT_ADDR_TIMER2_OVF
{
  FAN = 1;
  FAN = 0;
  TCNT2 = motor_speed;
}
//********************//********************
void butt_stop() iv IVT_ADDR_INT0
{

  if (go_flag == 1)
  {
    HEAT = 0;
    HEAT_LED = 0;
    go_flag = 0;
  }
  else
  {
    go_flag = 1;
  }
  delay_ms(200);
  while (PIND2_bit == 0)
    temp_menu = 0;
  delay_ms(200);
}
//********************//********************
int get_adc(char x)
{
  char s;
  temp2 = 0;
  for (s = 20; s != 0; s--)
    temp2 += ADC_Read(x);
  return temp2 / 20;
}
//********************//********************
void button_chk()
{
  if (get_adc(1) < 1000)
  {
    Delay_ms(50);
    if ((get_adc(1) < (483 + ADC_HYST)) && (get_adc(1)) > (483 - ADC_HYST))
      spdup_but_flag = 1;
    if ((get_adc(1) < (408 + ADC_HYST)) && (get_adc(1)) > (408 - ADC_HYST))
      spddown_but_flag = 1;
    if ((get_adc(1) < (312 + ADC_HYST)) && (get_adc(1)) > (312 - ADC_HYST))
      tup_but_flag = 1;
    if ((get_adc(1) < (183 + ADC_HYST)) && (get_adc(1)) > (183 - ADC_HYST))
      tdown_but_flag = 1;
    if ((get_adc(1) < (0 + ADC_HYST)))
      stb_but_flag = 1;
  }
}
//********************//********************
void main()
{
  // CONF
  DDRD = 0b11111011;
  DDRC = 0b11110000;
  DDRB = 255;
  L1 = L2 = L3 = L4 = 1;
  P_ON = 1;
  EN = 0;
  HEAT = 0;
  // timers
  CS02_bit = 1;
  CS01_bit = 0;
  CS00_bit = 0;
  CS10_bit = 1;
  CS11_bit = 1;
  CS12_bit = 0;
  CS22_bit = 1;
  CS21_bit = 1;
  CS20_bit = 1;
  /// intups
  SREG_I_bit = 1;
  TOIE0_bit = 1;
  TOIE1_bit = 1;
  TOIE2_bit = 1;
  INT0_bit = 1;
  ISC00_bit = 0;
  ISC01_bit = 0;
  // END CONF
  ADC_Init();
  rpm = 2;
  Delay_ms(2000);
  //********************//********************
  while (1)
  {
    while (go_flag == 0 && stby_flag == 0)
    {
      dig1 = 14;
      dig2 = 14;
      dig3 = 14;
      dig4 = 14;
      HEAT = 0;
      button_chk();
      if (spddown_but_flag || spdup_but_flag)
      {
        temp_menu = 0;
        dig4 = 13;
        while (temp_menu < 20)
        {
          if (spddown_but_flag)
          {
            rpm--;
            if (rpm < 1)
              rpm = 1;
            spddown_but_flag = 0;
            temp_menu = 0;
          }
          if (spdup_but_flag)
          {
            rpm++;
            if (rpm > 100)
              rpm = 100;
            spdup_but_flag = 0;
            temp_menu = 0;
          }
          motor_speed = 255 - (200 / rpm);
          temp_menu++;
          dectosev(rpm);
          delay_ms(80);
          button_chk();
        }
      }
      if (tup_but_flag || tdown_but_flag)
      {
        temp_menu = 0;
        dig4 = 12;
        while (temp_menu < 20)
        {
          if (tdown_but_flag)
          {
            temp_set = temp_set - 1;
            if (temp_set < 100)
              temp_set = 100;
            tdown_but_flag = 0;
            temp_menu = 0;
          }
          if (tup_but_flag)
          {
            temp_set = temp_set + 1;
            if (temp_set > 200)
              temp_set = 200;
            tup_but_flag = 0;
            temp_menu = 0;
          }
          temp_menu++;
          dectosev(temp_set);
          delay_ms(40);
          button_chk();
        }
      }
      if (stb_but_flag)
      {
        stb_but_flag = 0;
        stby_flag = 1;
      }
    }

    while (go_flag == 1)
    {
      dig4 = 12;
      temp_curr = temp3 * 0.186947 + 47.4777;
      if (temp_curr < (temp_set - HYST))
      {
        HEAT = 1;
        HEAT_LED = 1;
      }
      if (temp_curr > (temp_set + HYST))
      {
        HEAT = 0;
        HEAT_LED = 0;
      }
    }
    delay_ms(2000);
    while (stby_flag == 1)
    {
      HEAT = 0;
      if (get_adc(0) < 150)
      {
        TOIE2_bit = 0;
        EN = 1;
        P_ON = 0;
      }
      button_chk();
      dig1 = 15;
      dig2 = 16;
      dig3 = 17;
      dig4 = 18;
      if (stb_but_flag)
      {
        stby_flag = 0;
        go_flag = 0;
        TOIE2_bit = 1;
        EN = 0;
        P_ON = 1;
        while (stb_but_flag)
        {
          button_chk();
          stb_but_flag = 0;
          Delay_100ms();
        }
      }
    }
  }
}
