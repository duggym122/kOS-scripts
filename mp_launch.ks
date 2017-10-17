//kOS Launch Functions v1.1.6

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




LOCK radar_alt TO ALT:RADAR.

FUNCTION GRAVITY_TURN {
	PARAMETER compass.
	PARAMETER bubble.
	PARAMETER min_alt.

	WAIT UNTIL AIRSPEED > safe_speed OR radar_alt >= min_alt.
	SET save_bubble TO bubble.
	NOTIFY("INFO","Ascent angle set to " + save_bubble).
	
	LOCK STEERING TO HEADING(compass,bubble).


	IF AIRSPEED > safe_speed AND THROTTLE <> safe_throttle {
		NOTIFY("WARN","Safe airspeed limit exceeded").

		SET THROTTLE TO safe_throttle.
		NOTIFY("INFO","Decreasing throttle to " + safe_throttle).
	}
}

//Begin the launch profile
UNTIL run_mode = 0 {
	IF cur_thrust < (prev_thrust - 10){
		STAGE.
		SET prev_thrust TO MAXTHRUST.
	}
	IF run_mode = 1{
		LOCK STEERING TO HEADING(90,orbit_compass).
		//Starts immediately after liftoff
		NOTIFY("INFO","Triggering Run Mode 1").

		GRAVITY_TURN(orbit_compass,85,1000).
		SET run_mode TO 2.
		PERSIST("run_mode",run_mode).

	} ELSE IF run_mode = 2 {

		//Starts at 1000m
		NOTIFY("INFO","Triggering Run Mode 2").
		GRAVITY_TURN(orbit_compass,80,2000).
		SET run_mode TO 3.
		PERSIST("run_mode",run_mode).

	} ELSE IF run_mode = 3 {

		//Starts at 2000m
		NOTIFY("INFO","Triggering Run Mode 3").
		GRAVITY_TURN(orbit_compass,70,5000).
		SET run_mode TO 4.
		PERSIST("run_mode",run_mode).

	} ELSE IF run_mode = 4 {

		//Starts at 5000m
		NOTIFY("INFO","Triggering Run Mode 4").
		GRAVITY_TURN(orbit_compass,65,6000).
		SET run_mode TO 5.
		PERSIST("run_mode",run_mode).

	} ELSE IF run_mode = 5 {

		//Starts at 6000m
		NOTIFY("INFO","Triggering Run Mode 5").
		GRAVITY_TURN(orbit_compass,60,7000).
		SET run_mode TO 6.
		PERSIST("run_mode",run_mode).

	} ELSE IF run_mode = 6 {

		//Starts at 7000m
		NOTIFY("INFO","Triggering Run Mode 6").
		GRAVITY_TURN(orbit_compass,55,8000).
		SET run_mode TO 7.
		PERSIST("run_mode",run_mode).

	} ELSE IF run_mode = 7 {

		//Starts at 8000m
		NOTIFY("INFO","Triggering Run Mode 7").
		GRAVITY_TURN(orbit_compass,50,9000).
		SET run_mode TO 8.
		PERSIST("run_mode",run_mode).

	} ELSE IF run_mode = 8 {

		//Starts at 9000m
		NOTIFY("INFO","Triggering Run Mode 8").
		GRAVITY_TURN(orbit_compass,45,10000).
		SET run_mode TO 9.
		PERSIST("run_mode",run_mode).

	} ELSE IF run_mode = 9 {

		//Starts at 10000m
		NOTIFY("INFO","Triggering Run Mode 9").
		SET THROTTLE TO 1.
		
		WAIT UNTIL APOAPSIS >= orbit_altitude.

		SET THROTTLE TO 0.

		RCS ON.
		LOCK STEERING TO "kill".

		WAIT UNTIL ETA:APOAPSIS <= 30.

		LOCK STEERING TO HEADING(save_bubble,orbit_compass).
		RCS OFF.

		GRAVITY_TURN(orbit_compass,0,0).

		SET THROTTLE TO 1.

		WAIT UNTIL PERIAPSIS >= orbit_altitude.

		NOTIFY("INFO","Orbit achieved").

		SET THROTTLE TO 0.

		SET run_mode TO 0.

		NOTIFY("INFO","Run Mode sequence complete").

	}

}