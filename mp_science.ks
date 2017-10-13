//kOS Science Functions v0.1.0

//Takes in a list of science parts (allows the caller to decide what parts they want to run experiments for)
PARAMETER science_parts_list.

//Takes a boolean to allow callers to decide if they want to have science transmitted (useful for probes and satellites vs. return-ready craft)
PARAMETER allow_transmit.

FOR science_part IN science_parts_list {
	SET experiment TO science_part:GETMODULE("ModuleScienceExperiment").

	IF experiment:INOPERABLE <> TRUE {
		experiment:DEPLOY.
		NOTIFY("INFO","Running " + experimend:NAME + " on " + science_part:NAME).

		WAIT UNTIL experiment:HASDATA.
		
		FOR result IN experiment:DATA {
			IF result:SCIENCEVALUE = 0 {
				experiment:DUMP().
			} ELSE IF result:TRANSMITVALUE <> 0 AND experiment:RERUNNABLE AND allow_transmit {
				experiment:TRANSMIT().
				experiment:RESET().
			}
		}
	}

}