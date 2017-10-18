//kOS Interplanetary Hohmann Transfer v0.1.0

FUNCTION BURN_TIME {
	//Take in the current speed
	PARAMETER current_speed.

	//Take in the target speed
	PARAMETER target_speed.

	//Set a variable to track delta
	SET delta_speed TO 0.

	//Set a variable to the raw diff between target and current
	SET diff_speed TO (target_speed - current_speed).

	IF diff_speed < 0 {
		//If the diff is negative, set it to a positive delta since time is positive
		SET delta_speed TO (diff_speed * -1).
	} ELSE {
		//If the diff is not negative, the delta is the same as the diff
		SET delta_speed TO diff_speed.
	}

	//Divide the delta by the acceleration to get the number of seconds needed to burn
	RETURN (delta_speed)/(MAXTHRUST / SHIP:MASS).
}

FUNCTION HOHMANN {
	PARAMETER initial_altitude.
	PARAMETER target_altitude.

	//calculate the burn time
	//Calculate the burn vector
	//Wait until we are a proper distance from the periapsis
		//burn until the apoapsis is at the target altitude
		//Calculate burn time
		//Calculate the burn vector
		//Wait until we are a proper distance from the apoapsis
			//Burn until the periapsis is at the target altitude
}