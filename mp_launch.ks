//kOS Launch Functions v0.3.8

PARAMETER orbit_heading.
PARAMETER orbit_altitude.

SET prev_thrust TO MAXTHRUST.
SET cruise_control TO 1.
LOCK THROTTLE TO cruise_control.

FUNCTION AUTO_STAGE{
	PARAMETER prev_thrust.

	LOCK cur_thrust to MAXTHRUST.

	IF cur_thrust < prev_thrust {
		NOTIFY("INFO","Staging").
		SET prev_thrust TO MAXTHRUST.
		STAGE.
	} ELSE {
		NOTIFY("INFO","Not ready to stage.").
	}
}

//Gravity Turn Function
FUNCTION GRAVITY_TURN {
	PARAMETER compass.
	PARAMETER bubble.
	PARAMETER min_alt.

	IF AIRSPEED > 300 AND THROTTLE > 0.45 {
		SET cruise_control TO 0.45.
		NOTIFY("WARN","Reached 300m/s, throttling back").
	}

	AUTO_STAGE(prev_thrust).


	WAIT UNTIL ALT:RADAR >= min_alt.
	LOCK STEERING TO HEADING(compass,bubble).
}

FUNCTION CIRCULARIZE {
	PARAMETER orbital_heading.
	PARAMETER target_altitude.
	PARAMETER apoapsis_eta.

	NOTIFY("INFO","Circularizing.").

	NOTIFY("INFO","Holding on the horizon").
	
	RCS ON.
	NOTIFY("INFO","RCS On").

	GRAVITY_TURN(orbital_heading,0,0).
	NOTIFY("INFO","Heading set at " + orbital_heading + ", 0, 0").

	IF ETA:APOAPSIS < 0 AND THROTTLE = 0 {
		RUNPATH("0:/mp_abort_launch.ks").
	}

	WAIT UNTIL ETA:APOAPSIS <= apoapsis_eta.

	SET cruise_control TO 1.

	WAIT UNTIL PERIAPSIS >= target_altitude.

	NOTIFY("INFO","Circularization, complete.").

	RCS OFF.
	NOTIFY("INFO","RCS Off").
}

//Lift to Orbit Function
FUNCTION ATTAIN_ORBIT {
	PARAMETER orbital_heading.
	PARAMETER target_altitude.

	
	NOTIFY("INFO","Tilting to 90 degrees").
	GRAVITY_TURN(orbital_heading,90,0).

	NOTIFY("INFO","Tilting to 85 degrees").
	GRAVITY_TURN(orbital_heading,85,2000).

	NOTIFY("INFO","Tilting to 80 degrees").
	GRAVITY_TURN(orbital_heading,80,3000).

	NOTIFY("INFO","Tilting to 75 degrees").
	GRAVITY_TURN(orbital_heading,75,4000).

	NOTIFY("INFO","Tilting to 70 degrees").
	GRAVITY_TURN(orbital_heading,70,5000).

	NOTIFY("INFO","Tilting to 65 degrees").
	GRAVITY_TURN(orbital_heading,65,6000).

	NOTIFY("INFO","Tilting to 60 degrees").
	GRAVITY_TURN(orbital_heading,60,7000).

	NOTIFY("INFO","Tilting to 55 degrees").
	GRAVITY_TURN(orbital_heading,55,8000).

	NOTIFY("INFO","Tilting to 50 degrees").
	GRAVITY_TURN(orbital_heading,50,9000).

	NOTIFY("INFO","Tilting to 45 degrees").
	GRAVITY_TURN(orbital_heading,45,10000).

	UNTIL APOAPSIS >= target_altitude {
		SET cruise_control TO 0.
		NOTIFY("INFO","Waiting for apoapsis to reach target altitude").
	}

	NOTIFY("INFO","Apoapsis reached target").

	CIRCULARIZE(orbital_heading,target_altitude,30).


	NOTIFY("INFO","Orbit attained.").
}

ATTAIN_ORBIT(orbit_heading,orbit_altitude).