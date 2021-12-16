#ifndef _JOYSTICK_
#define _JOYSTICK_

class JoyStick
{
private:
  const uint16_t max_value = 1023;
  const uint16_t min_value = 0;
  uint8_t pin;
  int16_t zero_state;
public:
  int16_t value_step;
  
  JoyStick(uint8_t pin) 
  {
    this->pin = pin;
    value_step = 100;
  }
  ~JoyStick() {}

  void init()
  {
    zero_state = analogRead(pin);
  }
  
  int getLevel()
  {
    int16_t value = analogRead(pin);
    if (value > max_value)
      value = 0;
    return round((value - zero_state) / value_step);
  }
  
  int getSign()
  {
	  int16_t value = analogRead(pin);
	  if (value > max_value) {
		  value = 0;
	  }
	  int level = round((value - zero_state) / value_step);
	  if (level > 0)
		  return 1;
	  else if (level < 0)
		  return -1;
	  else return 0;
  }

  int getMaxLevel()
  {
    return round((max_value - zero_state) / value_step);
  }

  int getMinLevel()
  {
    return round((min_value - zero_state) / value_step);
  }

  int16_t getZeroState()
  {
    return zero_state;
  }

};

#endif
