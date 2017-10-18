# kOS Scripts for Spaceflight Automation

## Overview
This page is to describe all of the available kOS files in this repository.

## Boot Scripts
These are scripts run automatically at boot time. There should only be a need for one such file, and updates to the local copy may be needed when trying to ingest specific profile bootfiles for a single launch. However, for the most part, mission-specific profiles should be referenced from the ship profile.

## Mission Profile Scripts
### Launch Profiles
These files are for the liftoff to orbit phase. As of now, there is only one, as it is generic enough for any craft going to any circular orbit with any stage configuration. Future variations may contain more parameters to allow for non-circular orbits.

### Abort Profiles
As of now, this exists but is not called from any other profile. It can only handle sub-orbital aborts, but will be updated with logic to enact a return from anywhere, if it can reach Kerbin's SOI, or to maintain the closest possible orbit to allow for rescue.

### Science Profile
This is a single-function profile that allows the user to run a number of experiments however they wish. As long as the user creates a list of the parts, all of their science experiments can be run in one go.

### Ship-Specific Profiles
These files must be named with the convention "mp_ship_<ship_name />.ks" and should be mission specific  

### Body-Specific Profiles
For particular maneuvers around specific bodies, profiles with specialized parameters should be put in this type. These files should follow the convention "mp_<maneuver>_<body>.ks" or "mp_<maneuver>_<origin body>_<target body>.ks"

## Preflight Scripts
Self explanatory

## Utility Scripts
For anything not belonging in the above.
