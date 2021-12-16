/// ---PUMP---

#ifndef _CWPUMP_
#define _CWPUMP_

#include "cwcore.h"

#define PUMP_PIN 12
#define PUMP_PORT PORTB
#define PUMP_DDR DDRB
#define PUMP_OFFSET 4
#define PUMP_INIT PUMP_DDR |= 1 << PUMP_OFFSET // Output 
#define PUMP_ON PUMP_PORT &= ~(1 << PUMP_OFFSET) // Low on rum mode
#define PUMP_OFF PUMP_PORT |= 1 << PUMP_OFFSET // High on stop mode
#define PUMP_SETUP PUMP_INIT; PUMP_OFF;

#endif