//#include <A4988.h>
//#include <BasicStepperDriver.h>
//#include <DRV8825.h>
//#include <DRV8834.h>
//#include <DRV8880.h>
//#include <MultiDriver.h>
//#include <SyncDriver.h>

//#include "MsTimer2.h"
//#include "Timer.h"
#include "CyberLib.h"

#include "joystick.h"

#define JY_PIN 0
#define JY_SPEED_PIN 1
#define RE_PIN 13
#define SWITCH_PIN 2
#define STEPS_PER_REV 200
#define DIR_PIN 10
#define STEP_PIN 9
#define M2_PIN 6
#define M1_PIN 5
#define M0_PIN 4
#define NOENABLE_PIN 7
#define DIR2_PIN 11


volatile bool stepper_switch = true;

uint16_t speed_coeff = 400;
uint16_t half_pulse_us = 500;
bool stepper_run = 0;
uint16_t dir_pulse_us = 1000;
uint16_t half_period_us = 500;

volatile bool timer_switch = false;

JoyStick joy_stick = JoyStick(JY_PIN);

JoyStick joy_stick_speed = JoyStick(JY_SPEED_PIN);

uint32_t n_steps_per_rotation = 200;
uint32_t clk_freq = 16E6;
uint32_t prescaler = 8;
//uint32_t cur_pw_us = 250;
uint32_t stepper_prescaler = 8;

//DRV8825 step_driver(STEPS_PER_REV, DIR_PIN, STEP_PIN, M0_PIN, M1_PIN, M2_PIN);

void setup() {
  // relay
  pinMode(RE_PIN, OUTPUT);
  pinMode(DIR_PIN, OUTPUT);
  pinMode(DIR2_PIN, OUTPUT);
  pinMode(STEP_PIN, OUTPUT);
  pinMode(M2_PIN, OUTPUT);
  pinMode(M1_PIN, OUTPUT);
  pinMode(M0_PIN, OUTPUT);
  pinMode(NOENABLE_PIN, OUTPUT);
  digitalWrite(DIR_PIN, 1);
  digitalWrite(DIR2_PIN, 0);
  digitalWrite(STEP_PIN, 0);
  digitalWrite(M0_PIN, 0);
  digitalWrite(M1_PIN, 0);
  digitalWrite(M2_PIN, 0);
  //attachInterrupt(digitalPinToInterrupt(SWITCH_PIN), stepper_onoff, FALLING);
  
  stepper_off();
  joy_stick.init();
  joy_stick_speed.init();
  //Serial.begin(115200);
  //Serial.println(joy_stick.getZeroState());
}

void loop() {
  int joy_level = 0;
  int cur_joy_level = 0;
  int joy_speed_level = 0;
  int cur_joy_speed_level = 0;
  int step_dir = 1;
  //step_driver.stop();
  stepper_off();
//  while (!stepper_switch)
//    delay(100);
  //stepper_on();
  delay(200);
  //MsTimer2::set(1 , timer_pulse);
  //MsTimer2::start();
  //delay(100000);
  //step_driver.begin(100, 1);
  while (stepper_switch) {
    cur_joy_level = joy_stick.getSign();
    cur_joy_speed_level = joy_stick_speed.getSign();
    //Serial.println(digitalRead(NOFAULT_PIN));
    if (joy_level != cur_joy_level) { 
      if (!cur_joy_level) {
        //step_driver.stop();
        //stepper_run = 0;
        //digitalWrite(NOENABLE_PIN, 1);
          stepper_off();
      } else if (cur_joy_level > 0) {
          dir_pulse(1);
          stepper_on(cur_joy_speed_level);
      } else {
          dir_pulse(0);
          stepper_on(cur_joy_speed_level);
      }
        joy_level = cur_joy_level;
        joy_speed_level = cur_joy_speed_level;
    } else if (joy_speed_level != cur_joy_speed_level) {
        stepper_resume(cur_joy_speed_level);
        joy_speed_level = cur_joy_speed_level;
    } 
  }
}

//void stepper_onoff()
//{
//  stepper_switch = !stepper_switch;
//  if (stepper_switch)
//    stepper_on();
//  else
//    stepper_off();
//}

void stepper_on(int speed_level)
{
  //step_driver.stop();
  
  digitalWrite(RE_PIN, 0);
  digitalWrite(NOENABLE_PIN, 0);
  if (!speed_level) {
    stepper_accelerate(200, 200, 50);
  } else if (speed_level > 0) {
    stepper_accelerate(300, 500, 50);
  } else if (speed_level < 0) {
    stepper_accelerate(100, 100, 50);
  }
  
}

void stepper_off()
{
  //step_driver.stop();
  digitalWrite(NOENABLE_PIN, 1);
  digitalWrite(RE_PIN, 1);
}

void stepper_resume(int speed_level)
{
  if (!speed_level) {
    stepper_accelerate(200, 200, 50);
  } else if (speed_level > 0) {
    stepper_accelerate(500, 500, 50);
  } else if (speed_level < 0) {
    stepper_accelerate(100, 100, 50);
  }
}

//void stepper_pulse()
//{
  //if (stepper_run) {
    //D9_High;
//    delayMicroseconds(half_pulse_us);
//    D9_Low;
//    delayMicroseconds(half_period_us);
//  }
//}

//void timer_pulse()
//{
//  timer_switch = !timer_switch;
//  if (timer_switch)
//    D9_High;
//  else
//    D9_Low;
//}

void dir_pulse(bool dir)
{
  if (dir) {
    D10_High;
    D11_Low;
    delayMicroseconds(dir_pulse_us);
//    D4_Low;
//    delayMicroseconds(dir_pulse_us);
//    D4_High;
//    delayMicroseconds(dir_pulse_us);
  } else {
    D10_Low;
    D11_High;
    delayMicroseconds(dir_pulse_us);
//    D4_High;
//    delayMicroseconds(dir_pulse_us);
//    D4_Low;
//    delayMicroseconds(dir_pulse_us);
  }
}

uint16_t freq_reg_value(uint32_t pwm_freq)
{
  uint32_t reg = clk_freq / (prescaler * pwm_freq) - 1;
  if (reg < 0xFFFF)
    return reg;
  else
    return 0xFFFF;
}

uint16_t pulse_peg_value(uint32_t pulse_width_us)
{
  return static_cast<uint16_t>(((clk_freq / 1E6) * pulse_width_us) / prescaler - 1);
}

void setup_accel_pin9()
{
  // set pin 9 to OUTPUT
  DDRB |= 1 << DDB1;
  
  // set none-inverted mode on pin 9 (PB1)
  TCCR1A |= 1 << COM1A1;
  TCCR1A &= ~(1 << COM1A0);
  
  // set Fast PWM mode using ICR1 as TOP
  TCCR1A |= (1 << WGM11);
  TCCR1B |= (1 << WGM12)|(1 << WGM13);
  TCCR1A &= ~(1 << WGM10);

  // start the timer1 with no prescaler
  TCCR1B |= (1 << CS11);
  TCCR1B &= ~(1 << CS10);
  TCCR1B &= ~(1 << CS12);

  sei();
}  

uint32_t rpm2freq(uint16_t rpm)
{
  return static_cast<uint32_t>(rpm) * n_steps_per_rotation * stepper_prescaler / 60;
}

void stepper_accelerate(uint16_t start_rpm, uint16_t finish_rpm, uint32_t pulse_width_us)
{
  // if prescaler = 1, stepper_prescaler = 8 -> min_rpm = 9, abs_max_rpm = 9375, max_rpm_20 = 937, 
  // calculate freq reg values
  uint16_t cur_icr = freq_reg_value(rpm2freq(start_rpm));
  //Serial.println(rpm2freq(start_rpm));
  uint16_t max_icr = freq_reg_value(rpm2freq(finish_rpm));
  // set pulse width 
  OCR1A = pulse_peg_value(pulse_width_us);
  //OCR1AH = 0x00;
  //OCR1AL = 0xFF;
  // OCR1A |= 0xFFFF;
  //Serial.println(OCR1A);
  // less then 50% duty cycle
  if (max_icr < OCR1A * 2)
    max_icr = OCR1A * 2;
  // start
  setup_accel_pin9();
  // freq reg
  ICR1 = cur_icr;
  // accelerate
  while (cur_icr > max_icr) 
  {
    cur_icr--;
    ICR1--;
    delay_ms(1);
  }
  //Serial.println();
}
