// kOS Reusable Master Boot Script v0.2.3

//CONDITIONALS

//Create a mission time timestamp
LOCK mission_time TO "ET_" + MISSIONTIME.

//FUNCTIONS

//For system notifications
FUNCTION NOTIFY {
	PARAMETER type.
	PARAMETER message.

	SET type TO "INFO".

	IF type:contains("ERROR") {
		SET color TO RED.
	} ELSE IF type:contains("WARN") {
		SET color TO YELLOW.
	} ELSE IF type:contains("INFO") {
		SET color TO BLUE.
	} ELSE {
		SET color TO WHITE.
	}

	SET messagetext TO "kOS-" + type + ": " + message.

	HUDTEXT(messagetext, 5, 2, 25, color, false).

	LOG (mission_id + "," + mission_time + "," + messagetext) TO mission_log.
}

//For radio messages
FUNCTION RADIO {
	PARAMETER sender.
	PARAMETER recipient.
	PARAMETER message.

	SET messagetext TO recipient + ", this is " + sender + ". " + message.

	HUDTEXT("Radio Message: " + messagetext, 5, 2, 25, RGB(255,165,0), false).

	LOG (mission_id + "," + mission_time + ",Radio Transcript: " + messagetext) TO mission_transcript.
}

//For KSC PA system announcements
FUNCTION ANNOUNCE {
	PARAMETER sender.
	PARAMETER message.

	SET messagetext TO "PA Announcement: This is " + sender + ". " + message.

	HUDTEXT(messagetext, 5, 2, 25, RGB(255,165,0), false).

	LOG (mission_id + "," + mission_time + "," + messagetext) TO mission_transcript.
}

//Check if a given file exists on a given volume
FUNCTION HAS_FILE {
	PARAMETER filename.
	PARAMETER volumenumber.

	//Change to the target disk to search
	SWITCH TO volumenumber.

	//Get a list of all the files to search
	LIST FILES IN all_files.

	//Check for the requested file on the disk
	FOR one_file IN all_files {
		IF one_file:NAME = filename {

			//If the requested file is found, let us know
			SWITCH TO 1.
			NOTIFY("INFO",filename + " found on " + volumenumber).
			RETURN TRUE.
		}
	}

	//If the requested file is not found, let us know
	SWITCH TO 1.
	NOTIFY("ERROR",filename + " not found on " + volumenumber).
	RETURN FALSE.
}

//Download a file from KSC
FUNCTION KSC_DOWNLOAD {
	PARAMETER filename.

	//Check if the file is already on this ship and delete
	IF HAS_FILE(filename, 1) {
		DELETE filename.
		NOTIFY("WARN",filename + " deleted from ship volume").
	}

	//Copy the file from the archive
	IF HAS_FILE(filename, 0){
		COPYPATH("0:/" + filename, "1:/" + filename).
		NOTIFY("INFO",filename + " successfully downloaded").
	}
}

//Upload a file to KSC
FUNCTION KSC_UPLOAD {
	PARAMETER filename.

	//Check if the file has already been uploaded and delete
	IF HAS_FILE(filename, 0) {
		SWITCH TO 0.
		DELETE filename.
		NOTIFY("WARN",filename + " deleted from KSC archive").
		SWITCH TO 1.
	}

	//Upload the file from the ship
	IF HAS_FILE(filename, 1) {
		COPYPATH("1:/" + filename, "0:/" + filename).
		NOTIFY("INFO",filename + " successfully uploaded").
	}
}

//Adds a variable and its value to a persistence store
FUNCTION PERSIST {
	PARAMETER variable_name.
	PARAMETER variable_value.

	LOG ("SET " + variable_name + " TO " + variable_value + ".") TO "utility_persist.ks".
}

//LOOPS

//BOOT PROCEDURE
//For safety, always kill the throttle whenever this script starts so the craft doesn't run away
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.

//Check if we are on a new mission
IF MISSIONTIME < 5{
	//Create a Mission ID for use in logs
	SET mission_id TO "M_" + TIME:YEAR + "_" + TIME:DAY + "_" + TIME:HOUR.

	//Create a logfile
	SET mission_log TO ("log_" + mission_id + ".csv").

	//Create a flight data recorder
	SET mission_transcript TO ("transcript_" + mission_id + ".csv").

	//Create a persistence file
	IF HAS_FILE("utility_persist.ks",0) {
		DELETE "utility_persist.ks".
	} ELSE {
		PERSIST("mission_id",mission_id).
		PERSIST("mission_log",mission_log).
		PERSIST("mission_transcript",mission_transcript).
	}

	SET mission_profile TO "mp_ship_" + SHIP:NAME + ".ks".

	//Grab all the boot files
	SET list_bootfiles TO LIST("mp_abort_launch.ks",
							   "utility_manage_parts.ks",
							   "mp_launch.ks",
							   "preflight_countdown.ks",
							   "mp_science.ks",
							   "mp_kerbit_deorbit.ks",
							   mission_profile
							  ).

	IF list_bootfiles:LENGTH {
		FOR bootfile IN list_bootfiles {
			KSC_DOWNLOAD(bootfile).
		}
	}

	RUNPATH("0:/preflight_countdown").

} ELSE {
	//In the event we are not on a new mission, be sure to load the required variables from the persistence store
	RUNPATH("0:/utility_persist.ks").
}