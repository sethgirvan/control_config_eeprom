/**
 * Remember to update this file when changing computer configuration file
 *
 * Purpose: io_arduino.cpp:getConfig() expects to read the configuration data
 * from EEPROM in the native data format. It uses the arduino EEPROM.read
 * functions, and starts from (what the arduino EEPROM functions treat as)
 * EEPROM address 0. We define a data structure to that will populate the
 * relevant addresses.
 */

#include <avr/eeprom.h>

EEMEM static struct
{
	float settings[44];
} volatile config = {
	0.1, 0.0, 0.0,
	5.0, 0.0, 0.0,
	5.0, 0.0, 0.0,
	0.0, 0.0, 0.0,

	0, 1, 1, -1,    0, 1, -1, -1,
	0, -1, 1, -1,   0, -1, -1, -1,
	-1, 0, 0, 0,    1, 0, 0, 0,
	-1, 0, 0, 0,    1, 0, 0, 0};
