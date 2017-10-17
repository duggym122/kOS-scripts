//kOS Launch Functions v1.4.0

PARAMETER orbit_compass.
PARAMETER orbit_altitude.
PARAMETER launch_throttle.
PARAMETER throttle_down.
PARAMETER airspeed_threshold.

//Save the maximum thrust for staging calculation
SET prev_thrust TO MAXTHRUST.
LOCK cur_thrust TO MAXTHRUST.

//Set a throttle safety threshold
SET safe_throttle TO throttle_down.

//Set an airspeed safety threshold
SET safe_speed TO airspeed_threshold.

//Set the starting run_mode
SET run_mode TO 1.

SET debug TO TRUE.

FUNCTION GRAVITY_TURN {
	PARAMETER compass.
	PARAMETER bubble.

	LOCK STEERING TO HEADING(compass,bubble).
	NOTIFY("INFO","Ascent angle set to " + bubble).

	IF AIRSPEED > safe_speed AND THROTTLE <> safe_throttle {
		SET THROTTLE TO safe_throttle.
		NOTIFY("WARN","Safe airspeed limit exceeded").
		NOTIFY("INFO","Decreasing throttle to " + safe_throttle).
	}

	RETURN.
}

//Begin the launch profile
UNTIL run_mode = 0 {

	SET cur_thrust TO MAXTHRUST.

	IF debug {
		CLEARSCREEN.
		PRINT "Current Maxthrust:  " + MAXTHRUST.
		PRINT "cur_thrust:         " + cur_thrust.
		PRINT "prev_thrust:        " + prev_thrust.
		PRINT "Run Mode:           " + run_mode.
	}

	IF cur_thrust < (prev_thrust - 10){
        SET prev_thrust TO cur_thrust.
        NOTIFY("INFO","Triggering stage " + STAGE:NUMBER).
		STAGE.
		NOTIFY("INFO","Now on stage " + STAGE:NUMBER).
	}

	IF run_mode = 1{
		LOCK STEERING TO HEADING(90,orbit_compass).
		IF ALT:RADAR > 1000{
			NOTIFY("INFO","Triggering Run Mode 1").
			GRAVITY_TURN(orbit_compass,85).
			SET run_mode TO 2.
			PERSIST("run_mode",run_mode).
		}

	} ELSE IF run_mode = 2 AND ALT:RADAR > 2000 {
		NOTIFY("INFO","Triggering Run Mode 2").
		GRAVITY_TURN(orbit_compass,80).
		SET run_mode TO 3.
		PERSIST("run_mode",run_mode).

	} ELSE IF run_mode = 3 AND ALT:RADAR > 5000 {
		NOTIFY("INFO","Triggering Run Mode 3").
		GRAVITY_TURN(orbit_compass,70).
		SET run_mode TO 4.
		PERSIST("run_mode",run_mode).

	} ELSE IF run_mode = 4 AND ALT:RADAR > 6000 {
		NOTIFY("INFO","Triggering Run Mode 4").
		GRAVITY_TURN(orbit_compass,65).
		SET run_mode TO 5.
		PERSIST("run_mode",run_mode).

	} ELSE IF run_mode = 5 AND ALT:RADAR > 7000 {
		NOTIFY("INFO","Triggering Run Mode 5").
		GRAVITY_TURN(orbit_compass,60).
		SET run_mode TO 6.
		PERSIST("run_mode",run_mode).

	} ELSE IF run_mode = 6 AND ALT:RADAR > 8000 {
		NOTIFY("INFO","Triggering Run Mode 6").
		GRAVITY_TURN(orbit_compass,55).
		SET run_mode TO 7.
		PERSIST("run_mode",run_mode).

	} ELSE IF run_mode = 7 AND ALT:RADAR > 9000 {
		NOTIFY("INFO","Triggering Run Mode 7").
		GRAVITY_TURN(orbit_compass,50).
		SET run_mode TO 8.
		PERSIST("run_mode",run_mode).			

	} ELSE IF run_mode = 8 AND ALT:RADAR > 10000 {
		NOTIFY("INFO","Triggering Run Mode 8").
		GRAVITY_TURN(orbit_compass,45).
		SET run_mode TO 9.
		PERSIST("run_mode",run_mode).	

	} ELSE IF run_mode = 9 {
		NOTIFY("INFO","Triggering Run Mode 9").
		SET THROTTLE TO 1.
		SET run_mode TO 10.
		PERSIST("run_mode",run_mode).

	} ELSE IF run_mode = 10 AND APOAPSIS >= orbit_altitude {
		SET THROTTLE TO 0.

		RCS ON.

		LOCK STEERING TO "kill".

		SET run_mode TO 11.
		PERSIST("run_mode",run_mode).
	} ELSE IF run_mode = 11 AND ETA:APOAPSIS <= 30 {
		RCS OFF.

		GRAVITY_TURN(orbit_compass,0).

		SET THROTTLE TO 1.

		SET run_mode TO 12.
		PERSIST("run_mode",run_mode).
	} ELSE IF run_mode = 12 AND PERIAPSIS >= orbit_altitude {
		NOTIFY("INFO","Orbit achieved").

		SET THROTTLE TO 0.

		SET run_mode TO 0.

		NOTIFY("INFO","Run Mode sequence complete").
	}
}
