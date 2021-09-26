# HEMS Mission Generator
A HEMS (**H**elicopter **E**mergency **M**edical **S**ervice) random mission generator package for the [X-Plane](https://www.x-plane.com) flight simulator including crew intercom simulation and automatic animations (doors, boom, winch, cargo, boarding/unboarding etc.).

### Content
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
 - At least one of the following aircraft models:
	 -  [EC 135 v5](https://rotorsim.de/ec135v5/) by Rotorsim
	 -  [H145 Rescue Version v3.1](https://forums.x-plane.org/index.php?/files/file/37080-h145-rescue-version-v3/) by VLC-Entwicklung
 - Scenery libraries: [RescueX](https://www.rotorsim.de/component/jdownloads/download/4-andere/9-rescuex?Itemid=3111), [3D People](https://forums.x-plane.org/index.php?/files/file/26611-3d-people-library/), [R2](http://r2.xpl.cz/), [OpenSceneryX](https://www.opensceneryx.com/), [MisterX](https://forums.x-plane.org/index.php?/files/file/28167-misterx-library-and-static-aircraft-extension/), [CDB](https://forums.x-plane.org/index.php?/files/file/27907-cdb-library/), [RuScenery](http://ruscenery.x-air.ru/), [Handy Objects](https://forums.x-plane.org/index.php?/files/file/24261-the-handy-objects-library/)
### Recommended free custom airport scenery
- [HeliAlpes Swiss Pack](https://forums.x-plane.org/index.php?/files/file/72131-h%C3%A9lialpes-swiss-pack-v11/)
- [LSMD Dübendorf Rega 1 heliport](https://forums.x-plane.org/index.php?/files/file/19778-lsmd-d%C3%BCbendorf-rega-1-heliport/)
- [LSXU Untervaz Rega 5 heliport](https://forums.x-plane.org/index.php?/files/file/39336-lsxu-untervaz-rega-5-heliport/)


