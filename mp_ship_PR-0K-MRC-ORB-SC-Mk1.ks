//kOS Ship-Specific Mission Profile v0.1.3

SET all_parts TO SHIP:PARTS.
SET science_parts TO LIST().

RUNPATH("0:/mp_launch",90,60000,1,0.45,300).
KSC_UPLOAD(mission_log).
KSC_UPLOAD(mission_transcript).

FOR one_part IN all_parts{
	FOR module_name IN one_part:MODULES{
		IF module_name = "ScienceExperimentModule"{
			science_parts:ADD(one_part).
		}
	}
}
RUNPATH("0:/mp_science",science_parts).

SET period TO SHIP:ORBIT:PERIOD.

SET start_moment TO TIMESPAN:SECONDS.

SET duration TO (period * 10).

WAIT UNTIL (TIMESPAN:SECONDS = (start_moment + duration)).

RUNPATH("0:/mp_kerbin_deorbit.ks",0,12).