# HEMS Mission Generator
A HEMS (**H**elicopter **E**mergency **M**edical **S**ervice) random mission generator package for the [X-Plane](https://www.x-plane.com) flight simulator including crew intercom simulation and automatic animations (doors, boom, winch, cargo, boarding/unboarding etc.).


### What's included?
The package basically includes the following:

 - config files (.xml, .ini, .txt)
 - scripts (.bas, .lua)
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

#### Currently supported helicopter models
- [EC 135 v5 EMS](https://rotorsim.de/download-ec-135-v5/download/5-ec-135/14-ec-135-v5-ems) by Rotorsim
- [H145 Rescue Version v3.1](https://forums.x-plane.org/index.php?/files/file/37080-h145-rescue-version-v3/) by VLC-Entwicklung

This might get extended and/or made more generic in the future.

### Prerequisites

 - Working X-Plane 11 installation (Windows/Mac/Linux are supported)
 - Base mesh scenery covering Central Europe or at least the area of Switzerland and Southern Germany (Baden-Württemberg) as a minimum
	 - A ZL17 orthophoto mesh based on [high-quality elevation data](https://forums.x-plane.org/index.php?/forums/topic/165525-lidar-digital-terrain-models-dtm-of-european-countries/) is highly recommended
 - Latest [X-Europe](https://simheaven.com/x-europe/) overlay scenery
 - Latest [Mission-X](https://forums.x-plane.org/index.php?/files/file/41874-mission-x/) plugin
 - Latest [FlyWithLUA](https://forums.x-plane.org/index.php?/files/file/38445-flywithlua-ng-next-generation-edition-for-x-plane-11-win-lin-mac/) plugin
 - Latest [Helicopter Sling Load (HSL)](https://github.com/kristian80/HSL) plugin
 - At least one of the following aircraft models installed in X-Plane's home folder under `./Aircraft/Helicopters` using their default folder names i.e.:
	 -  [EC 135 v5 EMS](https://rotorsim.de/download-ec-135-v5/download/5-ec-135/14-ec-135-v5-ems) installed under `./Aircraft/Helicopters/EC 145 V5 EMS`
	 -  [H145 Rescue Version v3.1](https://forums.x-plane.org/index.php?/files/file/37080-h145-rescue-version-v3/) installed under `./Aircraft/Helicopters/H145 T2 Rescue Version XP11 V3.1`
 - Scenery libraries: [RescueX](https://www.rotorsim.de/component/jdownloads/download/4-andere/9-rescuex?Itemid=3111), [3D People](https://forums.x-plane.org/index.php?/files/file/26611-3d-people-library/), [R2](http://r2.xpl.cz/), [OpenSceneryX](https://www.opensceneryx.com/), [MisterX](https://forums.x-plane.org/index.php?/files/file/28167-misterx-library-and-static-aircraft-extension/), [CDB](https://forums.x-plane.org/index.php?/files/file/27907-cdb-library/), [RuScenery](http://ruscenery.x-air.ru/), [Handy Objects](https://forums.x-plane.org/index.php?/files/file/24261-the-handy-objects-library/)

### Recommended free custom airport scenery

 - [HeliAlpes Swiss Pack](https://forums.x-plane.org/index.php?/files/file/72131-h%C3%A9lialpes-swiss-pack-v11/)
 - [LSMD Dübendorf Rega 1 heliport](https://forums.x-plane.org/index.php?/files/file/19778-lsmd-d%C3%BCbendorf-rega-1-heliport/)
 - [LSXU Untervaz Rega 5 heliport](https://forums.x-plane.org/index.php?/files/file/39336-lsxu-untervaz-rega-5-heliport/)

### Installation

Since the package relies on symbolic links pointing to X-Plane's core assets the installation process may be a bit more involved depending on the chosen installation methods as provided below.

Before starting it might be a good idea to back up the following files residing within your X-Plane home (if they already exist):

    ./Aircraft/Helicopters/EC 145 V5 EMS/HSLAircraft.ini 
    ./Aircraft/Helicopters/H145 T2 Rescue Version XP11 V3.1/HSLAircraft.ini
    ./Aircraft/Helicopters/H145 T2 Rescue Version XP11 V3.1/VRConfigHotSpots.ini
    ./Aircraft/Helicopters/H145 T2 Rescue Version XP11 V3.1/ec145T2.acf
  

#### Git clone method

This method is the easiest but requires an installed [Git client](https://git-scm.com/downloads) so that the `git` command is available via on the command line. To verify open a command terminal and type the following followed by `RETURN`:

    git --version

It should output the Git version on the console. If not that means your Git client was not installed correctly.

By following the instructions below the master branch of this Github repository will be checked out ("cloned") locally into the existing X-Plane home folder and overwrite any existing files. It assumes there is no pre-existing folder named `.git` inside your X-Plane home folder. The Git client will then take care of creating required symbolic links automatically and everything should _just work_&trade;.

 1. Open a command terminal inside X-Plane's home folder
 3. Execute the following commands in sequence:
```
git init
git config core.symlinks true
git remote add origin https://github.com/d41k4n/hems_mission_generator.git
git fetch
git reset origin/master
git reset --hard HEAD
```

#### Zip file method
tbd



