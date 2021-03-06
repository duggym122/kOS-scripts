// kOS countdown v1.0.2

PARAMETER skip.

CLEARSCREEN.
LOCK THROTTLE TO 0.

IF skip = TRUE {
	NOTIFY("WARN","Skipping countdown").
	WAIT 5.

	NOTIFY("WARN","Select mission profile").
	SET mission_profile TO "mp_ship_" + SHIP:NAME + ".ks".
	NOTIFY("WARN","Mission profile set to " + mission_profile).
	WAIT 2.


	LOCK STEERING TO HEADING (90,90).
	NOTIFY("WARN","Steering locked to HEADING(90,90)").
	WAIT 2.

	STAGE.
	NOTIFY("WARN","Fire main engines").
	WAIT 2.

	LOCK THROTTLE TO 1.
	NOTIFY("WARN","Set throttle to full").

	STAGE.
	NOTIFY("WARN","Fire launch clamps").

	RUNPATH(mission_profile).
}


NOTIFY("INFO", "Initating final countdown sequence").
WAIT 3.

RADIO("Flight", "Cap-Com", "We are at t-minus 10 seconds and holding...").
WAIT 5.

RADIO("Cap-Com", "Crew", "We are at t-minus 10 seconds and holding...").
WAIT 5.

NOTIFY("INFO", "Starting the automatic ground launch sequencer").
WAIT 5.

RADIO("Flight" , "GNC", "Begin computer systems checks.").
WAIT 3.

RADIO("GNC" , "Cap-Com", "All computer programs are loaded and confirmed.").
WAIT RANDOM() * 10.

RADIO("Flight", "GC", "Retract access arms, seal fuel ports and retract filler arms, and start auxiliary power units.").
WAIT 3.

RADIO("GC", "MMACS", "Seal crew cabin and retract crew access").
WAIT 5.
RADIO("MMACS", "GC", "Cabin door sealed, crew access arm retracted").

SET topped_off TO FALSE.
LIST RESOURCES IN reslist.

UNTIL topped_off{
	SET res_status TO 0.
	SET res_checked TO 0.
	FOR res IN reslist {
		SET res_checked TO res_checked + 1.
		IF RES:AMOUNT = RES:CAPACITY{
			SET res_status TO res_status + 1.
			IF (res_status = res_checked) AND (res_status = reslist:LENGTH){
				SET topped_off TO TRUE.
			}
		}

	}
}

RADIO("MMACS", "GC", "Fueling complete.").
WAIT RANDOM() * 3. 
RADIO("Platform Ops" , "MMACS", "Safeties armed, ports sealed.").

RADIO("MMACS" , "GC", "Fuel filler arms retracted").
WAIT 2.

RADIO("GC" , "Flight", "All fueling systems are filled, disconnected, and have been confirmed safe.").
WAIT RANDOM()*5.

RADIO("Flight", "EGIL", "Begin electrical systems check.").
WAIT RANDOM()*15.

RADIO("EGIL" , "Flight", "All electrical systems are confirmed and ready.").
WAIT RANDOM()*5.

RADIO("Flight" , "MMACS", "Begin thermal systems check.").
WAIT RANDOM()*10.

RADIO("MMACS" , "Flight", "All thermal systems are confirmed and ready.").
WAIT RANDOM()*5.

RADIO("Flight" , "FIDO", "Begin control surface systems check.").
WAIT RANDOM()*10.

RADIO("FIDO" , "Flight", "All control surfaces are confirmed and ready.").
WAIT RANDOM()*5.

RADIO("Flight" , "FIDO", "Begin gimble systems check.").
WAIT RANDOM()*10.

RADIO("FIDO" , "Flight", "All gimbles are confirmed and ready.").
WAIT RANDOM()*5.

RADIO("Cap-Com", "Crew", "Close and lock visors, and prepare for ground launch sequencer auto-sequence start.").
WAIT RANDOM()*5.

RADIO("Crew","Cap-Com","Confirm visors are locked, we are ready for auto-sequence start.").
WAIT 2.

ANNOUNCE("Flight", "All systems checks are complete, ground launch sequencer is go for auto-sequence start.").
WAIT 2.

NOTIFY("WARN","Final auto-sequence has begun. We are at t-minus 10 seconds and counting.").

SET countdown TO 10.

UNTIL countdown < 3 {
	NOTIFY("WARN", countdown).
	WAIT 1.
	SET countdown TO (countdown - 1).
}

NOTIFY("WARN", "2").
WAIT 0.5.

LOCK STEERING TO HEADING (90,90).
NOTIFY("WARN","Main ignition firing").
LOCK THROTTLE TO 1.
STAGE.
WAIT 0.5.

NOTIFY("WARN","1").
WAIT 1.

STAGE.
NOTIFY("WARN","Launch clamps disengaged").

WAIT UNTIL ALT:RADAR > 250.
NOTIFY("INFO","Vessel is clear of the launch pad").
RADIO("FIDO" , "Flight", "We now have liftoff, and the vessel is clear of the launch pad.").
RADIO("Cap-Com", "Crew", "You are now clear of the pad. God's speed.").

NOTIFY("WARN","Ground computer handing off control to the onboard computers.").

SET mission_profile TO "mp_ship_" + SHIP:NAME + ".ks".

RUNPATH(mission_profile).