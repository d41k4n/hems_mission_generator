@echo off
cd "Custom Scenery\CH_Hospitals"
mklink /J ".\St.Gallen\objects\apt_lights.dds" "..\..\..\..\Resources\default scenery\sim objects\apt_lights\apt_lights.dds"
mklink /J ".\St.Gallen\objects\apt_lights_LIT.dds" "..\..\..\..\Resources\default scenery\sim objects\apt_lights\apt_lights_LIT.dds"
cd "Custom Scenery\heliport_lib"
mklink /J ".\textures\UrbanHighFac1_ALB.dds" "..\..\..\Resources\default scenery\1000 autogen\US\urban_high\textures\UrbanHighFac1_ALB.dds"
mklink /J ".\textures\UrbanHighFac1_LIT.dds" "..\..\..\Resources\default scenery\1000 autogen\US\urban_high\textures\UrbanHighFac1_LIT.dds"
mklink /J ".\textures\UrbanHighFac1_NML.png" "..\..\..\Resources\default scenery\1000 autogen\US\urban_high\textures\UrbanHighFac1_NML.png"

echo Directory junctions created.
