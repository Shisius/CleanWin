
/// ---Delay---
#define DELAY_TIMER_CTC TCCR0A |= (1 << WGM01); TCCR0A &= ~(1 << WGM00); TCCR0B &= ~(1 << WGM02)


/// ---Tasks---
class CWtask
{
private:
	cwerror (*action)(uint16_t parameter);
	uint16_t parameter;
	bool blocking; // Whether the event blocks main loop until the event is finished
	bool is_running = false;
public:
	CWtask(cwerror (*action)(), uint16_t parameter);
	~CWtask() {}
	cwerror execute() {
		return this->action(this->parameter);
	}
};
std::vector<CWtask> cwtasks;

cwerror run()
{
	;
}
/// ---Main---
void cwinit()
{
	STEPPER_SETUP;
	PUMP_SETUP;
}
/// CW commands:
// CLEAR(CL) - clear the events queue. Stops all routines
// RUN(RN) - start the events queue
// ADD(AD + 2 * uint16) - add event with parameters
// SET(ST + 2 * uint16) - set global parameter
/// CW routines:
// stepper_run(n_passages)
// stepper_stop()
// pump_on()
// pump_off()
// delay(milliseconds)
/// CW settings:
// stepper_speed(mm/s)
// stepper_path(mm)
// stepper_initial_position(mm) 0 - on top
// stepper_initial_dir

