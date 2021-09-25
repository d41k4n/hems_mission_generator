# HEMS Mission Generator
A HEMS (**H**elicopter **E**mergency **M**edical **S**ervice) random mission generator for the [X-Plane](https://www.x-plane.com) flight simulator. 

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
- [EC 135 v5](https://rotorsim.de/ec135v5/) by Rotorsim
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



