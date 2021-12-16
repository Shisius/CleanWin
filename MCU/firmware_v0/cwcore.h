/// ---Core---

#ifndef _CWCORE_
#define _CWCORE_

#include <stdint.h>
#include <vector>

/// CPU CONSTANTS
#ifndef F_CPU
#define F_CPU 16000000UL
#endif

/// Errors & results
enum cwerror{
	FAIL = -1,
	SUCCESSS,
	EMPTYBOTTLE
};

#endif