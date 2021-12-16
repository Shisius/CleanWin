/// ---STEPPER---

#ifndef _CWSTEPPER_
#define _CWSTEPPER_

#include "cwcore.h"

// Stepper constants
#define STEP_MIN_PULSE_DUR_US 50
// Rotation tracker
#define ROT_TRACK_PIN 2
// Enable
#define EN_PIN 7
#define EN_PORT PORTD
#define EN_DDR EN_DDR
#define EN_OFFSET 7
#define EN_INIT EN_DDR |= 1 << EN_OFFSET // Output 
#define STEPPER_ENABLE EN_PORT &= ~(1 << EN_OFFSET) // Enable on Low
#define STEPPER_DISABLE EN_PORT |= 1 << EN_OFFSET // Disable on High
// Direction
#define DIR_PIN 8
#define DIR_PORT PORTB
#define DIR_DDR DDRB
#define DIR_OFFSET 0
#define DIR_INIT DIR_DDR |= 1 << DIR_OFFSET // Output 
#define DIR_LOW DIR_PORT &= ~(1 << DIR_OFFSET) 
#define DIR_HIGH DIR_PORT |= 1 << DIR_OFFSET
#define DIR_INV DIR_PORT ^= 1 << DIR_OFFSET
// Step
#define STEP_PIN 9
#define STEP_PORT PORTB
#define STEP_DDR DDRB
#define STEP_OFFSET 1
#define STEP_PIN_INIT STEP_DDR |= 1 << STEP_OFFSET // Output
#define STEP_LOW STEP_PORT &= ~(1 << STEP_OFFSET) 
#define STEP_HIGH STEP_PORT |= 1 << STEP_OFFSET 
#define STEP_INV STEP_PORT ^= 1 << STEP_OFFSET 
// Timer
#define STEP_TIMER_CTC TCCR2A |= (1 << WGM21); TCCR2A &= ~(1 << WGM20); TCCR2B &= ~(1 << WGM22)
#define STEP_TIMER_SET_INT_COMP TIMSK2 |= (1 << OCIE2A); TIMSK2 &= ~(1 << TOIE2)
#define STEP_TIMER_START TCNT2 = 0; STEP_TIMER_SET_INT_COMP; sei()
#define STEP_TIMER_STOP TIMSK2 &= ~(0x07)
#define STEP_TIMER_INIT STEP_TIMER_CTC; STEP_TIMER_STOP
#define STEP_MAX_PULSE_FREQ (1000000UL / STEP_MIN_PULSE_DUR_US)
#define STEP_SET_REG(value) (value < 256 ? OCR2A = value : OCR2A = 0xFF)

// States & Properties
struct StepperState
{
	bool _stepper_running;
	uint32_t _edge_counter; // pulse counter = edge counter / 2
	uint32_t position_um; // position in micrometers

};
volatile StepperState * stepper_state = nullptr;
struct StepperSettingsInside
{
	uint32_t _max_edge_count;
	uint8_t _timer_reg_init; // Start speed
	uint8_t _timer_reg_cruising; // Cruising speed
	uint8_t _timer_reg_inc; // Timer increment for acceleration 
	//bool 
};
struct StepperSettingsOutside
{
	uint32_t passage_length_um; // Maximum legth of passage in micrometers
	uint16_t velocity_mm_ps; // velocity in millimeters per second
	uint16_t cruising_velocity_mm_ps; // initial velocity before acceleration
	uint16_t acceleration_mm_pss // acceleration in millimeters per square second
	// dir cw to up/down convert
};
struct StepperProperties
{
	uint32_t _prescaler;
	uint16_t _steps_per_revolution;
};
struct StepperGear
{
	uint16_t _n_wheel_teeth; // number of teeth of stepper wheel
	uint16_t _belt_step_um; // belt teeth step in micrometers
	
};

// Convertings


volatile uint8_t _passage_counter = 0;
volatile uint8_t _max_passage_count = 0;
ISR (TIMER2_COMPA_vect)
{
	if (stepper_state->_stepper_running) {
		STEP_INV;
		stepper_state->_edge_counter++;
		// If stepper reachs the limit of movement
		if (stepper_state->_edge_counter >= _max_edge_count) {
			STEPPER_STOP;
			// Stepper should go back
			DIR_INV;
			// What about next passage?
			_passage_counter++;
			if (_passage_counter >= _max_passage_count)

		}
	}	
}
#define STEPPER_SETUP EN_INIT; DIR_INIT; STEP_PIN_INIT; STEP_TIMER_INIT
#define STEPPER_STOP STEPPER_DISABLE; stepper_state->_stepper_running = false; STEP_TIMER_STOP; stepper_state->_edge_counter = 0
#define STEPPER_START STEP_LOW; stepper_state->_edge_counter = 0; _passage_counter = 0; STEPPER_ENABLE; STEP_TIMER_START; stepper_state->_stepper_running = true

void stepper_setup() {
	stepper_state = new StepperState()
}

cwerror stepper_run() {

}

#endif // _CWSTEPPER_

/// Start edge counter value
/// Start DIR value

/// Convert functions
// mm/s to steps per second - required wheel diameter, steps per revolution
// steps/s to pulse per second - required stepper prescaler
// pulse/s to timer reg - required timer prescaler