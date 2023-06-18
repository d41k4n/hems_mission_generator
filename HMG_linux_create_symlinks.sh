#!/bin/bash

echo
cd Custom\ Scenery/CH_Hospitals
ls "../../../../Resources/default scenery/sim objects/apt_lights/apt_lights.dds" > /dev/null
ls "../../../../Resources/default scenery/sim objects/apt_lights/apt_lights_LIT.dds" > /dev/null
cd Custom\ Scenery/heliport_lib
ls "../../../Resources/default scenery/1000 autogen/US/urban_high/textures/UrbanHighFac1_ALB.dds" > /dev/null
ls "../../../Resources/default scenery/1000 autogen/US/urban_high/textures/UrbanHighFac1_LIT.dds" > /dev/null
ls "../../../Resources/default scenery/1000 autogen/US/urban_high/textures/UrbanHighFac1_NML.png" > /dev/null

if [ $? != 0 ] 
then
  echo "script terminated unsuccessfully"
  echo
  exit
fi

cd Custom\ Scenery/CH_Hospitals
ln -sf "../../../../Resources/default scenery/sim objects/apt_lights/apt_lights.dds" "./St.Gallen/objects/apt_lights.dds"
ln -sf "../../../../Resources/default scenery/sim objects/apt_lights/apt_lights_LIT.dds" "./St.Gallen/objects/apt_lights_LIT.dds"
cd Custom\ Scenery/heliport_lib
ln -sf "../../../Resources/default scenery/1000 autogen/US/urban_high/textures/UrbanHighFac1_ALB.dds" "./textures/UrbanHighFac1_ALB.dds"
ln -sf "../../../Resources/default scenery/1000 autogen/US/urban_high/textures/UrbanHighFac1_LIT.dds" "./textures/UrbanHighFac1_LIT.dds"
ln -sf "../../../Resources/default scenery/1000 autogen/US/urban_high/textures/UrbanHighFac1_NML.png" "./textures/UrbanHighFac1_NML.png"
echo "done"
echo