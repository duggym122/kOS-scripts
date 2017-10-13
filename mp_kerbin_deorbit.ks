//kOS Kerbin Deorbit Profile v0.1.0

PARAMETER return_stage.
PARAMETER safe_airspeed.

NOTIFY("INFO","Initiating deorbit procedure.").

SET cur_stage TO STAGE:NUMBER.

LOCK STEERING TO RETROGRADE.

WAIT UNTIL ETA:APOAPSIS < 3.

LOCK THROTTLE TO 1.

WAIT UNTIL PERIAPSIS <= 35000.

LOCK THROTTLE TO 0.

IF cur_stage < return_stage {
	NOTIFY("WARN","The current stage is beyond the listed return stage. Catastrophic failure may result.").
}

UNTIL cur_stage = return_stage {
	STAGE.
}

IF STAGE:ABLATOR = 0 {
	NOTIFY("WARN","The current stage has no ablator. Catastrophic failure may result.").
} ELSE IF STAGE:ABLATOR:AMOUNT < (STAGE:ABLATOR:CAPACITY/2) {
	NOTIFY("WARN","Ablator capacity is below 50%. Catastrophic failure may result.").
}

NOTIFY("INFO","Deploying chutes as it is safe.").
UNTIL CHUTES AND AIRSPEED < safe_airspeed {
	WHEN (NOT CHUTESSAFE) THEN {
    	CHUTESSAFE ON.
	}

	IF CHUTES {
		NOTIFY("INFO","All chutes deployed.").
	}

	IF AIRSPEED < safe_airspeed {
		NOTIFY("WARN","Return stage exceeding safe airspeed").
	}

}

NOTIFY("INFO","Chutes deployed and return stage successfully slowed to safe airspeed.").

WAIT UNTIL ALT:RADAR < 2.

NOTIFY("INFO","Splashdown achieved").

UNTIL STAGE:ELECTRICCHARGE < (STAGE:ELECTRICCHARGE:CAPACITY/15){
	RADIO("Automated Distress Beacon aboard " + SHIP:NAME,"All channels","We are splashed down at " + LATITUDE + ", " + LONGITUDE ).
	WAIT 5.
}