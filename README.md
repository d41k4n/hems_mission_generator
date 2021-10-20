



# HEMS Mission Generator
A HEMS (**H**elicopter **E**mergency **M**edical **S**ervice) random mission generator package for the [X-Plane](https://www.x-plane.com) flight simulator including crew intercom simulation and automatic animations (doors, boom, winch, cargo, boarding/unboarding etc.).

### How does it work?
The mission generator uses a mission template which is processed by the [Mission-X](https://forums.x-plane.org/index.php?/files/file/41874-mission-x/) plugin for creating random but plausible rescue scenarios. Mission goals and accident locations are computed dynamically based on distance, terrain features (slope, surface), annotated vector data obtained from the live OpenStreetMap database (roads, trails, pistes, outdoor pitches/parkings and administrative boundaries) and augmented with real historical traffic accident open data (where available). Rescue locations are populated with plausible objects to make them recognizable from the air. Mission types include patient extractions (by either landing at or hovering over designated accident locations) and hospital transfers. Crew interaction during hovering (winch ops) is partially automated and simulated (attach/detach payload, boom operation, payload and hover position advisories). Location of patient drop-off is calculated to give a plausible travel distance (e.g. closest hospital up to a maximum, but not too close). Mission progress and instructions are communicated over audio (TTS).

### What's included?
The package basically includes the following:

 - config files (.xml, .ini, .txt)
 - script files (.bas, .lua)
 - custom overlay scenery for hospitals
 - a custom heliport scenery library ([heliport_lib](https://github.com/d41k4n/hems_mission_generator/tree/master/scenery/heliport_lib))
 - custom aircraft definitions (.acf)
 - various resources (e.g. images)

### Limitations
In the current state it provides dedicated mission templates for HEMS missions originating out of a subset of heliports located in __Switzerland only__ as well as for a limited number of aircraft models. 

#### Currently supported origin heliports:
- LSMD Dübendorf ([Rega 1](https://www.rega.ch/en/our-missions/sites-and-infrastructure/rega-1-zurich-base) home base)
- LSXU Untervaz ([Rega 5](https://www.rega.ch/en/our-missions/sites-and-infrastructure/rega-5-untervaz-base) home base)
- LSZF Birrfeld ([Lions 1](https://de.wikipedia.org/wiki/LIONS_1) home base, operated by [Alpine Air Ambulance AG](https://www.air-ambulance.ch/))
- LSZE Zermatt (operated by [Air Zermatt](https://www.air-zermatt.ch/))
- LSGS Sion (operated by [Air-Glaciers](https://www.air-glaciers.ch/))

#### Supported helicopter models
Due to the scripted interaction with the aircraft (animations, weight distribution etc.) custom integration for the actual aircraft model is required. This is the reason why separate mission templates are provided per aircraft type.

Currently the following helicopter models are supported:
- [EC 135 v5 EMS](https://rotorsim.de/download-ec-135-v5/download/5-ec-135/14-ec-135-v5-ems) by Rotorsim
- [H145 Rescue Version v3.1](https://forums.x-plane.org/index.php?/files/file/37080-h145-rescue-version-v3/) by VLC-Entwicklung

This might get extended and/or made more generic in the future.

Note that only a _port-side_ mounted hoist is supported for hover missions or otherwise animations will not match.

### Prerequisites

 - Working X-Plane installation (Windows/Mac/Linux are supported)
 - X-Plane sound output enabled with system support for speech synthesis (check sound settings)
 - Working internet connection
 - Base mesh scenery covering Central Europe or at least the area of Switzerland and Southern Germany (Baden-Württemberg) as a minimum
	 - A ZL17 orthophoto mesh based on [high-quality elevation data](https://forums.x-plane.org/index.php?/forums/topic/165525-lidar-digital-terrain-models-dtm-of-european-countries/) is highly recommended
 - Latest [X-Europe](https://simheaven.com/x-europe/) overlay scenery
 - Latest [Mission-X](https://forums.x-plane.org/index.php?/files/file/41874-mission-x/) plugin incl. "Random Mission Pack"
 - Latest [FlyWithLUA](https://forums.x-plane.org/index.php?/files/file/38445-flywithlua-ng-next-generation-edition-for-x-plane-11-win-lin-mac/) plugin
 - Latest [Helicopter Sling Load (HSL)](https://github.com/kristian80/HSL) plugin
 - At least one of the following aircraft models installed in X-Plane's home folder under `./Aircraft/Helicopters` using their default folder names i.e.:
	 -  [EC 135 v5 EMS](https://rotorsim.de/download-ec-135-v5/download/5-ec-135/14-ec-135-v5-ems) installed under `./Aircraft/Helicopters/EC 145 V5 EMS`
	 -  [H145 Rescue Version v3.1](https://forums.x-plane.org/index.php?/files/file/37080-h145-rescue-version-v3/) installed under `./Aircraft/Helicopters/H145 T2 Rescue Version XP11 V3.1`
 - Scenery libraries: [RescueX](https://www.rotorsim.de/component/jdownloads/download/4-andere/9-rescuex?Itemid=3111), [3D People](https://forums.x-plane.org/index.php?/files/file/26611-3d-people-library/), [R2](http://r2.xpl.cz/), [OpenSceneryX](https://www.opensceneryx.com/), [MisterX](https://forums.x-plane.org/index.php?/files/file/28167-misterx-library-and-static-aircraft-extension/), [CDB](https://forums.x-plane.org/index.php?/files/file/27907-cdb-library/), [RuScenery](http://ruscenery.x-air.ru/), [Handy Objects](https://forums.x-plane.org/index.php?/files/file/24261-the-handy-objects-library/), [NZ Pro Scenery - Overlay](http://www.alpilotx.net/downloads/x-plane-10-new-zealand-pro/#Download)

### Recommended free custom airport scenery

 - [HeliAlpes Swiss Pack](https://forums.x-plane.org/index.php?/files/file/72131-h%C3%A9lialpes-swiss-pack-v11/)
 - [LSMD Dübendorf Rega 1 heliport](https://forums.x-plane.org/index.php?/files/file/19778-lsmd-d%C3%BCbendorf-rega-1-heliport/)
 - [LSXU Untervaz Rega 5 heliport](https://forums.x-plane.org/index.php?/files/file/39336-lsxu-untervaz-rega-5-heliport/)

### Installation

Installation involves copying files into the following folders within X-Plane's home directory:
```
./Custom Scenery/missionx/HEMS_Mission_Generator
./Custom Scenery/CH_Hospitals
./Custom Scenery/helipad_lib
./Aircraft/Helicopters/EC 135 V5 EMS
./Aircraft/Helicopters/H145 T2 Rescue Version XP11 V3.1
./Aircraft/_slingload_objects
./Resources/plugins/FlyWithLua/Scripts
./Resources/plugins/FlyWithLua/Modules
./Resources/plugins/HSL
```
To be on the safe side consider making backup copies of these folders before proceeding.

Since the package relies on certain X-Plane core assets that cannot be re-distributed the installation process may be a bit more involved depending on the chosen installation method as provided below.

#### Git clone method

This method is the easiest but requires an installed [Git client](https://git-scm.com/downloads) so that the `git` command is available on the command line. To verify open a command terminal and execute the following command:

    git --version

It should output the Git version on the console. If not that means your Git client was not installed correctly.

By following the instructions below the master branch of this Github repository will be checked out ("cloned") locally into the existing X-Plane home folder overwriting any existing files. It assumes there is no pre-existing folder named `.git` inside your X-Plane home folder. The Git client will then take care of creating required symbolic links automatically and everything should _just work_&trade;.

 1. Open a command terminal inside X-Plane's home folder
 3. Execute the following commands in sequence:

		git init
		git config core.symlinks true
		git remote add origin https://github.com/d41k4n/hems_mission_generator.git
		git fetch
		git reset origin/master
		git reset --hard HEAD

To update (or reinstall) the latest version simply execute the following commands from within X-Plane's home folder:
```
git fetch
git reset --hard HEAD
```

#### Zip file method

 1. Download the [current master branch as a zip file](https://github.com/d41k4n/hems_mission_generator/archive/refs/heads/master.zip)
 2. Unzip the contents of the zipped folder "hems_mission_generator_master" directly into X-Plane's home folder overwriting any existing files (don't unzip the folder "hems_mission_generator_master" itself!).
 3. Within folder `./Custom Scenery/CH_Heliports` find and replace all file occurrences like

		*/apt_lights.png
		*/apt_lights_LIT.png
        
	with either copies or symbolic links to the same-name core assets within X-Plane's home folder i.e.

		./Resources/default scenery/sim objects/apt_lights/apt_lights.png
		./Resources/default scenery/sim objects/apt_lights/apt_lights_LIT.png

 4. Finally, replace file

		./Custom Scenery/heliport_lib/textures

	with either a copy or a symbolic link to the core asset folder within X-Plane's home folder i.e.

		./Resources/default scenery/1000 autogen/US/urban_high/textures
		
### Suggested controller setup

For best experience during hover missions it is recommended to assign the following commands to some physical controllers (e.g. joystick buttons):

 - `FlyWithLua/hoist/show_toggle`
	 - Toggles a small pop-up window with some useful info about the status of the hoist such as current rope length and height above ground.
 - `FlyWithLua/hoist/winch_down`
	 - Lowers the winch while pressed (release to stop)
 - `FlyWithLua/hoist/winch_up`
	 - Raises the winch while pressed (release to stop)

### Optional: Configure custom overpass server
In order to optimize mission creation in Mission-X for the general area of Switzerland it is highly recommended to customize the overpass server URL in the plugin settings. 

To do so proceed as follows:

1. In the X-Plane menu select Plugins -> Mission-X vx.x.xxx.x
2. Click on `Setup`
3. Locate section `OVERPASS settings`
4. Replace the value for `Overpass URL` with `https://overpass.osm.ch/api/interpreter`

### Starting a mission

Starting missions is done by selecting the provided mission template through the Mission-X UI:

1. In the X-Plane menu select `Plugins -> Mission-X vx.x.xxx.x`
2. Click on `Templates`
3. Select the "HEMS Mission Generator" template icon
4. Read the template description carefully and make sure that 
	- you have selected the desired option for the combination of location and helicopter from the dropdown
	- you have configured your flight to use the appropriate helicopter model as indicated (use port-side hoist configuration for hover missions)
	- you are positioned within 80m of the indicated home base coordinates (this will also be evaluated as your last waypoint or the mission won't terminate)
5. Click on `Generate Mission from Template`
6. Wait for the actual mission to be generated (a blue button labeled `>> Start mission <<` will appear)
7. Read again the template description as it will now contain the actual mission briefing
8. When ready, click  `>> Start mission <<` 
9. Listen for audio messages containing status information and/or instructions as the mission progresses
10. Have fun!

### Hints

#### General
- It's important to follow the instructions provided during flight and wait with proceeding to the next waypoint of the generated flight plan until you are instructed to do so. Aborting/skipping any intermediate tasks will cause the mission not to progress correctly.

#### Navigation
- A flight plan containing the minimal set of mandatory waypoints is auto-generated and will be loaded into the GPS/FMS at mission start. Reaching of these waypoints (within a radius of 80m) is evaluated by the mission script.
- The flight plan can also be exported for use in third-party tools. Have a look at the documentation at `./Resources/plugins/missionx/docs/Configuring External FPLN folders for Mission-X (vx.x.xxx.x).pdf`

#### Hover missions
- Lowering/raising the winch must be done by you (the pilot). While this is not realistic it is done to give full control over coordinating your flight position and attitude with respect to the position and movement of attached load.
- Use the hoist plugin pop-up (see [Suggested controller setup](#suggested-controller-setup)) to determine when the attached load reaches the ground by comparing current rope length with above ground altitude. 
- Keep lowering the winch until you hear/read the message "Stop winch!". You might have to keep extending the rope beyond the current height above ground in order to provide some extra slack (e.g. to compensate for horizontal and/or vertical drift).
- Start raising the winch when you hear/read message "Start raising winch carefully".
- If you hear/read the message "Get back into position!" that means you have strayed too far from the hover target (> 30m horizontally, >150ft vertically). Correct your position using the accident scene mission objects as a visual reference.

### Troubleshooting

tbd

### Acknowledgements

The following third party assets were used (and adapted where necessary) with kind permission of their authors:
 - Slingload objects by [X-Alberto](https://forums.x-plane.org/index.php?/profile/14984-x-alberto/)
 - Parts of "HeliAlpes Swiss Pack" scenery by [marc1227](https://forums.x-plane.org/index.php?/profile/398981-marc1227/) 
 - Parts of "CH HEMS HeliPack 2016 A" for FSX by Pascal Küffer
