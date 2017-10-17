//kOS Science Functions v0.1.0

//NOTE: The reason this code accepts a pre-curated list of science parts is because a user may wish to perform different
	// experiments at different stages within their mission. For example, they could create lists of atmospheric, 
	// ground-based, or space-born experiments and run them separately or conditionally. Please do not submit any requests
	// to change that functionality here, since it is intentional.

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