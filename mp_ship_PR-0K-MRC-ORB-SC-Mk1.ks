//kOS Ship-Specific Mission Profile v0.1.6

SET all_parts TO SHIP:PARTS.
SET science_parts TO LIST().

SET orbits TO 0.5.

RUNPATH("0:/mp_launch",90,60000,1,0.45,300).
KSC_UPLOAD(mission_log).
KSC_UPLOAD(mission_transcript).

PANELS ON.

NOTIFY("INFO","Launch profile successfully completed.").

FOR one_part IN all_parts{
	FOR module_name IN one_part:MODULES{
		IF module_name = "ScienceExperimentModule"{
			science_parts:ADD(one_part).
		}
	}
}
RUNPATH("0:/mp_science",science_parts, FALSE).
NOTIFY("INFO","Science mission profile successfully completed.").

NOTIFY("INFO","Beginning orbital mission.").
SET period TO SHIP:ORBIT:PERIOD.

SET start_moment TO TIME:SECONDS.

SET duration TO (period * orbits).

WAIT UNTIL (TIME:SECONDS = (start_moment + duration)).

NOTIFY("INFO","10 orbits successfully completed.").

NOTIFY("INFO","Triggering deorbit profile.").
RUNPATH("0:/mp_kerbin_deorbit.ks",0,12).
NOTIFY("INFO","Deorbit profile successfully completed.").