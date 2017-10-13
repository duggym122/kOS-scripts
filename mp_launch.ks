//kOS Launch Functions v0.3.3

PARAMETER orbit_heading.
PARAMETER orbit_altitude.

SET prev_thrust TO MAXTHRUST.
SET cruise_control TO 1.
LOCK THROTTLE TO cruise_control.

FUNCTION AUTO_STAGE{
	//LIST ENGINES IN engine_list.

	//FOR engine IN engine_list{
	//	IF ENGINE:FLAMEOUT{
	//		RETURN TRUE.
	//	} ELSE {
	//		RETURN FALSE.
	//	}
	//}

	PARAMETER prev_thrust.

	LOCK cur_thrust to MAXTHRUST.

	IF cur_thrust < prev_thrust {
		NOTIFY("INFO","Staging").
		SET prev_thrust TO MAXTHRUST.
		RETURN TRUE.
	} ELSE {
		RETURN FALSE.
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

	IF AUTO_STAGE(prev_thrust) {
		STAGE.
	}


	WAIT UNTIL ALT:RADAR >= min_alt.
	LOCK STEERING TO HEADING(compass,bubble).
}

FUNCTION CIRCULARIZE {
	PARAMETER orbital_heading.
	PARAMETER target_altitude.
	PARAMETER apoapsis_eta.

	NOTIFY("INFO","Circularizing.").

	NOTIFY("INFO","Holding on the horizon").
	GRAVITY_TURN(orbital_heading,0,0).

	WAIT UNTIL ETA:APOAPSIS <= apoapsis_eta.

	SET cruise_control TO 1.

	WAIT UNTIL PERIAPSIS >= target_altitude.

	NOTIFY("INFO","Circularization, complete.").

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

	WAIT UNTIL APOAPSIS >= target_altitude.
	SET cruise_control TO 0.


	NOTIFY("INFO","Orbit attained.").
}

ATTAIN_ORBIT(orbit_heading,orbit_altitude).