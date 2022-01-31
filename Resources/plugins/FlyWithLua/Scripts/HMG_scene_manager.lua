--
-- dynamic scene manager
--
-- inspired by 'Simple and Nice Loading Equipment from XPJavelin'
--
-- version 0.22
--

define_shared_DataRef("sceneMgr/lat", "Float")
define_shared_DataRef("sceneMgr/lon", "Float")
define_shared_DataRef("sceneMgr/message", "Data")

local hasMissionX = false
if ( XPLMFindDataRef("xpshared/target/lat") ~= nil )then    -- missionX plugin loaded ?
   dataref("mx_lat","xpshared/target/lat","readonly")
   dataref("mx_lon","xpshared/target/lon","readonly")
   hasMissionX = true
end

dataref("scenemgr_lat","sceneMgr/lat","readonly")
dataref("scenemgr_lon","sceneMgr/lon","readonly")
dataref("scenemgr_message","sceneMgr/message","readonly",0)
dataref("plane_hdg", "sim/flightmodel/position/psi", "readonly")

local RescueX_cars  =  "RescueX/cars/"
local RescueX_peps  =  "RescueX/people/"
local RescueX_obj   =  "RescueX/objects/"
local RescueX_light =  "RescueX/lights/"
local People_3D     =  "3D_people_library/"
local R2_Lib_Cars   =  "R2_Library/doprava/vozidla/"
local R2_Lib_Stuff  =  "R2_Library/letiste/doplnky/"
local CDB_Peeps     =  "CDB-Library/Peeps/polynesian/fiji/"

local CCARS = {
	RescueX_cars .. "Crashed_CLK.obj",
	RescueX_cars .. "Crashed_Kia_Picanto.obj",
	RescueX_cars .. "Crashed_Kia_Picanto2.obj",
	RescueX_cars .. "Crashed_Opel_Insignia.obj"
}

local CARS = {
	RescueX_cars .. "car_Datsun_620-73.obj",
	RescueX_cars .. "car_KiaSuv.obj",
	RescueX_cars .. "car_LandRover107.obj",
	RescueX_cars .. "car_Pajero.obj",
	RescueX_cars .. "car_SuzukiCarry2.obj",
	RescueX_cars .. "car_SuzukiCarry_pickup.obj",
	RescueX_cars .. "car_alto.obj",
	RescueX_cars .. "car_daihatsu_tanto.obj",
	RescueX_cars .. "car_datsunGO.obj",
	RescueX_cars .. "car_datsunGOPlus.obj",
	RescueX_cars .. "car_fordRangerWhite.obj",
	RescueX_cars .. "car_gmc_airport.obj",
	RescueX_cars .. "car_gmc_old.obj",
	RescueX_cars .. "car_lexus.obj",
	RescueX_cars .. "car_mitshubishiTbox.obj",
	RescueX_cars .. "car_mitsubishi_pack.obj",
	RescueX_cars .. "car_nissanStanzaWG.obj",
	RescueX_cars .. "car_old_pickup.obj",
	RescueX_cars .. "car_peugeotrossa.obj",
	RescueX_cars .. "car_postTruck.obj",
	RescueX_cars .. "car_sinca.obj",
	RescueX_cars .. "car_subaru_wagon.obj",
	RescueX_cars .. "car_suzukiCarry.obj",
	RescueX_cars .. "car_suzuki_cappuccino.obj",
	RescueX_cars .. "car_toyotaRed_old_pickup.obj",
	RescueX_cars .. "car_toyotaTacoma.obj",
	RescueX_cars .. "car_toyota_camry.obj",
	RescueX_cars .. "car_toyota_corolla.obj",
	RescueX_cars .. "car_toyota_corolla_old.obj",
	RescueX_cars .. "CDBambassador_carblack.obj",
	RescueX_cars .. "CDBcar_van.obj",
	RescueX_cars .. "CDBhummer.ob",
	R2_Lib_Cars .. "s105-red.obj",
	R2_Lib_Cars .. "s105-blue.obj",
	R2_Lib_Cars .. "s105-green.obj",
	R2_Lib_Cars .. "avia.obj",
	R2_Lib_Cars .. "skoda_favorit_blue.obj",
	R2_Lib_Cars .. "skoda_favorit_red.obj",
	R2_Lib_Cars .. "skoda_favorit_white.obj",
	R2_Lib_Cars .. "skoda_favorit_yellow.obj",
	R2_Lib_Cars .. "T815.obj",
	R2_Lib_Cars .. "z7745.obj",
	R2_Lib_Cars .. "bus_mhd.obj",
	R2_Lib_Cars .. "DAF55.obj",
	R2_Lib_Cars .. "bus_2.obj"
}

local POLV = {
	RescueX_cars .. "Polizei_FuStw_01.obj",
	RescueX_cars .. "Polizei_FuStw_01_lit.obj",
	RescueX_cars .. "Polizei_FuStw_01_lit_open.obj",
	RescueX_cars .. "NEF_Passat_sb1099.obj",
	RescueX_cars .. "NEF_Passat_sb1099_lit.obj",
	RescueX_cars .. "NEF_Passat_sb1099_lit_open.obj",
	RescueX_cars .. "NEF_Passat_sb1099_not_tilted.obj"
}

local POLC = {
        People_3D .. "police.obj",
        People_3D .. "police_officer.obj",
        People_3D .. "policeman1_walking.obj",
        People_3D .. "policeman1.obj",
        People_3D .. "policeman2.obj",
        People_3D .. "policeman3.obj",
        People_3D .. "policeman4.obj",
        People_3D .. "policeman5.obj",
        People_3D .. "policeman6.obj",
        People_3D .. "policeman7.obj",
        People_3D .. "policeman8.obj"
}

local ADAC_CARS = {
	RescueX_cars .. "ADAC_TowTruck.obj",
	RescueX_cars .. "ADAC_Masterlift.obj"
}

local BERGV = {
	RescueX_cars .. "Bergwacht_Einsatzleitfahrzeug.obj",
	RescueX_cars .. "Bergwacht_Vito.obj"
}

local STRETCHER = {
	RescueX_obj  .. "stretcher.obj"
}

local OBS = {
	RescueX_obj  .. "OBJ_Faltdreieck.obj",
	RescueX_obj  .. "OBJ_Faltdreieck_Leuchte.obj",
	RescueX_obj  .. "OBJ_Leuchte.obj",
	RescueX_obj  .. "OBJ_pylone.obj",
	R2_Lib_Stuff .. "kuzel_cerveny.obj",
	R2_Lib_Stuff .. "kuzely_cervene.obj"
}

local OBS2 = {
	R2_Lib_Stuff .. "oznaceni_letiste.obj",
	R2_Lib_Stuff .. "oznaceni_letiste_dlouhe.obj",
	R2_Lib_Stuff .. "sudy_CB_letiste.obj",
	R2_Lib_Stuff .. "sudy_letiste.obj",
	R2_Lib_Stuff .. "znaceni_letiste_prkna.obj"
}

local FWV = {
	RescueX_cars .. "FW_BF_Karlsruhe_DLK.obj",
	RescueX_cars .. "FW_BF_Karlsruhe_HLF.obj",
	RescueX_cars .. "FW_BF_Karlsruhe_HLF_open.obj",
	RescueX_cars .. "FW_BF_Karlsruhe_WLF.obj",
	RescueX_cars .. "FW_FF_Stuehlingen_RW1.obj",
	RescueX_cars .. "FW_FF_Stuehlingen_RW1_open.obj",
	RescueX_cars .. "FW_FF_Stuehlingen_RW1_open_Lichtmast.obj",
	RescueX_cars .. "FW_GEN_DLK.obj"
}

local FWC = {
	People_3D .. "Fireman.obj",
	People_3D .. "fireman2.obj",
	People_3D .. "fireman3.obj",
	People_3D .. "fireman4.obj"
}

local RTWV = {
	RescueX_cars .. "RTW_DRK_Bayern.obj",
	RescueX_cars .. "RTW_DRK_Bayern_not_tilted.obj",
	RescueX_cars .. "RTW_ASB_1.obj",
	RescueX_cars .. "RTW_ASB_2.obj",
	RescueX_cars .. "RTW_FEU_GUT.obj"
}

local RTWC = {
    	CDB_Peeps .. "peeps_fijiM6.obj",    -- standing, with bag
  	CDB_Peeps .. "peeps_fijiM7.obj",    -- standing
   	CDB_Peeps .. "peeps_fijiM19.obj",   -- standing, with box
    	CDB_Peeps .. "peeps_fijiM21.obj"    -- standing, no bag	
}

local RTWC2 = {
  	CDB_Peeps .. "peeps_fijiM5.obj",    -- just kneeing
  	CDB_Peeps .. "peeps_fijiM20.obj"    -- kneeing, with box
}

local RTWC3 = {
    	CDB_Peeps .. "peeps_fijiM6.obj"    -- standing, no bag	
}

local LAMPS = {
	RescueX_light .. "scheinwerfer_boden_180m_45o_120w.obj",
	RescueX_light .. "scheinwerfer_boden_30m_45o_120w.obj"
}

local BIKER = {
	People_3D .. "cyclist.obj",
	People_3D .. "cyclist_standing.obj",
	People_3D .. "biker.obj",
	People_3D .. "biker2.obj",
	People_3D .. "biker3.obj"
}

local PEOPLE = { 
	People_3D .. "man_standing.obj",
	People_3D .. "man_standing_2.obj",
	People_3D .. "man_standing_3.obj",
	People_3D .. "man_standing_4.obj",
	People_3D .. "man_standing_5.obj",
	People_3D .. "man_standing_6.obj",
	People_3D .. "man_standing_7.obj",
	People_3D .. "man_standing_8.obj",
	People_3D .. "man_standing_9.obj",
	People_3D .. "man_standing_10.obj",
	People_3D .. "man_standing_11.obj",
	People_3D .. "man_standing_12.obj",
	People_3D .. "man_standing_13.obj",
	People_3D .. "man_standing_14.obj",
	People_3D .. "man_standing_15.obj",
	People_3D .. "man_standing_16.obj",
	People_3D .. "man_standing_17.obj",
	People_3D .. "man_standing_18.obj",
	People_3D .. "man_standing_19.obj",
	People_3D .. "man_standing_20.obj",
	People_3D .. "man_standing_21.obj",
	People_3D .. "man_standing_22.obj",
	People_3D .. "man_standing_23.obj",
	People_3D .. "man_standing_24.obj",
	People_3D .. "man_standing_25.obj",
	People_3D .. "man_standing_26.obj",
	People_3D .. "man_standing_27.obj",
	People_3D .. "man_standing_28.obj",
	People_3D .. "man_standing_29.obj",
	People_3D .. "man_standing_30.obj",
	People_3D .. "man_standing_31.obj",
	People_3D .. "man_standing_32.obj",
	People_3D .. "man_standing_33.obj",
	People_3D .. "man_standing_34.obj",
	People_3D .. "man_standing_35.obj",
	People_3D .. "man_standing_36.obj",
	People_3D .. "woman_standing.obj",
	People_3D .. "woman_standing2.obj",
	People_3D .. "woman_standing3.obj",
	People_3D .. "woman_standing4.obj",
	People_3D .. "woman_standing5.obj",
	People_3D .. "woman_standing6.obj",
	People_3D .. "woman_standing7.obj",
	People_3D .. "woman_standing8.obj",
	People_3D .. "woman_standing9.obj",
	People_3D .. "woman_standing10.obj",
	People_3D .. "woman_standing11.obj",
	People_3D .. "woman_standing12.obj",
	People_3D .. "woman_standing13.obj",
	People_3D .. "woman_standing13.obj",
	People_3D .. "female1.obj"
}

local STAFF = {
	People_3D .. "ground_crew_male_1.obj",
	People_3D .. "ground_crew_male_2.obj",
	People_3D .. "ground_crew_male_3.obj",
	People_3D .. "ground_crew_male_4.obj",
	People_3D .. "ground_crew_male_6.obj",
	People_3D .. "ground_crew_male_7_marshaling.obj",
	People_3D .. "ground_crew_male_8_marshaling.obj",
	People_3D .. "ground_crew_male_9.obj",
	People_3D .. "first_aider.obj"
}

--
-- scene groups
--
local g_patient = {PEOPLE}                     -- patient table
local g_sani = {RTWC3}                         -- patient table
local g_sani_knee = {RTWC2}                    -- patient table
local g_stretcher = {STRETCHER}                -- patient table

local g_car = {CARS}                           -- 1 car

local g_cars = {CARS,CARS,CARS,CARS}           -- 4 random cars

local g_police = {POLC,POLC,POLV}              -- 2 police Crew and one Vehicle 

local g_ambulance = {RTWC,RTWC,RTWV}           -- 2 RTW Crew and one Vehicle

local g_fireworker = {FWC,FWC,FWC,FWC,FWV}     -- 4 fireworker Crew and one Vehicle

local g_objects = {OBS,OBS,OBS,OBS,OBS}        -- 5 random objects

local g_peps = {PEOPLE}

local g_winch = {PEOPLE,RTWC,PEOPLE,RTWC,PEOPLE,OBS2,OBS2}

-- groups used by "parse_mission"
local g_ADAC  = {ADAC_CARS}                    -- a random crash car
local g_VU  = {CCARS}                          -- a random crash car
local g_FW  = {FWC,FWC,FWC,FWC,FWV}            -- table of tables
local g_RTW = {RTWC,RTWC,RTWV}                 -- table of tables


local g_shifted_x = 0
local g_shifted_z = 0
local showScene = 0

set("sceneMgr/lat",LATITUDE)
set("sceneMgr/lon",LONGITUDE)

------------------------------------------------------------------------------------

require("bit")

local ffi = require ("ffi")

-- find the right lib to load
local XPLMlib = ""

if SYSTEM == "IBM" then
  -- Windows OS (no path and file extension needed)
  if SYSTEM_ARCHITECTURE == 64 then
    XPLMlib = "XPLM_64"  -- 64bit
  else
    XPLMlib = "XPLM"     -- 32bit
  end
elseif SYSTEM == "LIN" then
  -- Linux OS (we need the path "Resources/plugins/" here for some reason)
  if SYSTEM_ARCHITECTURE == 64 then
    XPLMlib = "Resources/plugins/XPLM_64.so"  -- 64bit
  else
    XPLMlib = "Resources/plugins/XPLM.so"     -- 32bit
  end
elseif SYSTEM == "APL" then
  -- Mac OS (we need the path "Resources/plugins/" here for some reason)
  XPLMlib = "Resources/plugins/XPLM.framework/XPLM" -- 64bit and 32 bit
else
  return -- this should not happen
end

-- load the lib and store in local variable
local XPLM = ffi.load(XPLMlib)

-- create declarations of C types
local cdefs = [[

  typedef struct {
    int                       structSize;
    float                     x;
    float                     y;
    float                     z;
    float                     pitch;
    float                     heading;
    float                     roll;
  } XPLMDrawInfo_t;

  typedef struct {
    int                       structSize;
    float                     locationX;
    float                     locationY;
    float                     locationZ;
    float                     normalX;
    float                     normalY;
    float                     normalZ;
    float                     velocityX;
    float                     velocityY;
    float                     velocityZ;
    int                       is_wet;
  } XPLMProbeInfo_t;


  typedef void *inRefcon;
  typedef void *XPLMDataRef;
  typedef void *XPLMObjectRef;
  typedef void *XPLMInstanceRef;
  typedef void *XPLMProbeRef;
  typedef int XPLMProbeType;
  typedef int XPLMProbeResult;

  typedef void (*XPLMObjectLoaded_f)(XPLMObjectRef inObject, void *inRefcon);

  typedef int (*XPLMGetDatai_f)(void *inRefcon);
  typedef void (*XPLMSetDatai_f)(void *inRefcon, int inValue);

  typedef float (*XPLMGetDataf_f)(void *inRefcon);
  typedef void (*XPLMSetDataf_f)(void *inRefcon, float inValue);

  typedef double (*XPLMGetDatad_f)(void *inRefcon);
  typedef void (*XPLMSetDatad_f)(void *inRefcon, double inValue);

  typedef int (*XPLMGetDatavi_f)(void *inRefcon,
                                  int *outValues,    /* Can be NULL */
                                  int inOffset,
                                  int inMax);
  typedef void (*XPLMSetDatavi_f)(void *inRefcon,
                                   int *inValues,
                                   int inOffset,
                                   int inCount);
  typedef int (*XPLMGetDatavf_f)(void *inRefcon,
                                  float *outValues,    /* Can be NULL */
                                  int inOffset,
                                  int inMax);
  typedef void (*XPLMSetDatavf_f)(void *inRefcon,
                                   float *inValues,
                                   int inOffset,
                                   int inCount);
  typedef int (*XPLMGetDatab_f)(void *inRefcon,
                                  void *inValue,
                                  int inOffset,
                                  int inLength);
  typedef void (* XPLMLibraryEnumerator_f)(
                         const char *         inFilePath,
                         void *               inRef);

/*
  XPLMDataRef XPLMRegisterDataAccessor(
                         const char *         inDataName,
                         int                  inDataType,
                         int                  inIsWritable,
                         XPLMGetDatai_f       inReadInt,
                         XPLMSetDatai_f       inWriteInt,
                         XPLMGetDataf_f       inReadFloat,
                         XPLMSetDataf_f       inWriteFloat,
                         XPLMGetDatad_f       inReadDouble,
                         XPLMSetDatad_f       inWriteDouble,
                         XPLMGetDatavi_f      inReadIntArray,
                         XPLMSetDatavi_f      inWriteIntArray,
                         XPLMGetDatavf_f      inReadFloatArray,
                         XPLMSetDatavf_f      inWriteFloatArray,
                         XPLMGetDatab_f       inReadData,
                         XPLMSetDatab_f       inWriteData,
                         void *               inReadRefcon,
                         void *               inWriteRefcon);
*/

  XPLMObjectRef XPLMLoadObject( const char *inPath);
  void XPLMLoadObjectAsync( const char * inPath, XPLMObjectLoaded_f inCallback, void *inRefcon);

  XPLMInstanceRef XPLMCreateInstance(XPLMObjectRef obj, const char **datarefs);
  void XPLMInstanceSetPosition(XPLMInstanceRef instance, const XPLMDrawInfo_t *new_position, const float *data);

  XPLMProbeRef XPLMCreateProbe(XPLMProbeType inProbeType);
  XPLMProbeResult XPLMProbeTerrainXYZ( XPLMProbeRef inProbe, float inX, float inY, float inZ, XPLMProbeInfo_t *outInfo);

  void XPLMUnregisterDataAccessor(XPLMDataRef inDataRef);
  void XPLMDestroyInstance(XPLMInstanceRef instance);
  void XPLMUnloadObject(XPLMObjectRef inObject);
  void XPLMDestroyProbe(XPLMProbeRef inProbe);

  int  XPLMLookupObjects( const char * inPath, float inLatitude, float inLongitude, XPLMLibraryEnumerator_f enumerator,    void * ref);

  void XPLMWorldToLocal( double inLatitude, double inLongitude, double inAltitude, double *outX, double *outY, double *outZ);
  void XPLMLocalToWorld( double inX, double inY, double inZ, double *outLatitude, double *outLongitude, double *outAltitude);

  void XPLMGetSystemPath(char * outSystemPath);

]]

-- add these types to the FFI:
ffi.cdef(cdefs)


-- Variables to handle C pointers
local char_str = ffi.new("char[256]")

local datarefs_addr = ffi.new("const char**")
local dataref_name = ffi.new("char[150]")         -- define the length of the string to store the name of the dataref. can be longer but not shorter

local dataref_register7 = ffi.new("XPLMDataRef")
local dataref_array2 = ffi.new("const char*[2]")  -- this is for the signboard, one dataref and one null dataref

local proberef = ffi.new("XPLMProbeRef")           -- for the probe


local MAX_OBJECTS     = 50
local Mission_Objects = 0     -- number of mission objects
local Mission_Inst    = ffi.new("XPLMInstanceRef[50]")
local Mission_Obj     = ffi.new("XPLMObjectRef[50]")
local Mission_Chg     = {}
local Mission_LAT     = {}    -- object latitude
local Mission_LON     = {}    -- object longitude
local Mission_HDG     = {}    -- object heading
local Mission_SIT     = {}    -- object situation
local Mission_PAT     = {}    -- object is patient

local acft_x, acft_y, acft_z = 0, 0, 0     -- position in local coordinates

-- used arbitrary to store info about the object
local objpos_addr =  ffi.new("const XPLMDrawInfo_t*")
local objpos_value = ffi.new("XPLMDrawInfo_t[1]")

-- use arbitrary to store float value & addr of float value
local float_addr = ffi.new("const float*")
local float_value = ffi.new("float[1]")

-- meant for the probe
local probeinfo_addr =  ffi.new("XPLMProbeInfo_t*")
local probeinfo_value = ffi.new("XPLMProbeInfo_t[1]")

local probetype = ffi.new("int[1]")

-- to store float values of the local coordinates
local x1_value = ffi.new("double[1]")
local y1_value = ffi.new("double[1]")
local z1_value = ffi.new("double[1]")


-- to store in values of the local nature of the terrain (wet / land)
local terrain_nature = ffi.new("int[1]")

------------------------------------------------------------------------------------

function load_object(n,path)
   if Mission_Inst[n] == nil then
      print(">> load object: "..n.." : "..path)

      XPLM.XPLMLookupObjects(
         path,
         0,0,
         function(real_path, inRefcon)
            print(">> real_path :"..ffi.string(real_path))
            XPLM.XPLMLoadObjectAsync(real_path,
               function(inObject, inRefcon)
                  print(">> load object: executing callback")
                  Mission_Inst[n] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
                  Mission_Obj[n] = inObject
                end,
               inRefcon )
         end,
         inRefcon )
   else
      print(">> load object: instance " .. n .. " exists")
   end
end

function draw_object(n)
   local l_lat,l_lon,l_alt,l_hdg

   l_lat = Mission_LAT[n]
   l_lon = Mission_LON[n]
   l_hdg = Mission_HDG[n]
   l_alt = 0

   in_x, in_y, in_z = latlon_to_local(l_lat, l_lon, l_alt)

   in_z = in_z + 20   -- offset to current plane position 

   -- SHIFT
   --     POSITIVE LEFT < x > NEGATIVE RIGHT
   --     POSITIVE FWD < z > NEGATIVE AFT

   -- SIT ( situation )
   --    0 = default
   --    1 = object laying on ground ( i.e. person on its back )
   --    2 = object laying on right side  
   --    3 = object elevated and shifted ( i.e. person on stretcher ) 
   --    4 = object will not be shifted/random placed  

   if ( Mission_SIT[n] < 3 ) then      -- situation < 3 = normal distribution
      shift_object(in_x, in_z, n*0.5, n*0.5, l_hdg )
   else
      in_z = in_z + 2
      in_x = in_x + 2
      if ( Mission_SIT[n] == 3 ) then     -- situation 3 = adjust patient to stretcher
         shift_object(in_x, in_z, 0.0, -0.9, l_hdg )
      else
         g_shifted_x = in_x
         g_shifted_z = in_z
      end
   end

   objpos_value[0].x = g_shifted_x 
   objpos_value[0].z = g_shifted_z 
   objpos_value[0].heading = l_hdg

   acft_y,wetness = probe_y (g_shifted_x, in_y, g_shifted_z)

   --print(">> world: in_x=" .. in_x .. ", in_y=" .. in_y .. ", in_z=" .. in_z )
   print(">> draw object: latlon: l_lat=" .. l_lat .. ", l_lon=" .. l_lon .. ", l_alt=" .. l_alt .. ", l_hdg=" .. l_hdg)

   float_value[0] = 0
   float_addr = float_value
   objpos_value[0].y = acft_y
   objpos_value[0].pitch = 0
   objpos_value[0].roll = 0

   if ( Mission_SIT[n] == 1 ) then         -- situation 1 = person laying on ground 
      objpos_value[0].pitch = -90
      objpos_value[0].y = acft_y + 0.3
   end

   if ( Mission_SIT[n] == 3 ) then         -- situaton 3 = patient on stretcher
      objpos_value[0].pitch = -90
      objpos_value[0].y = acft_y + 1.1
   end

   if ( Mission_SIT[n] == 2 ) then         -- situation 2 = object laying on right side
      objpos_value[0].roll = 90
      objpos_value[0].y = acft_y + 0.5
   end

   --print(">> draw object: altitude " .. objpos_value[0].y)
   objpos_addr = objpos_value
   XPLM.XPLMInstanceSetPosition(Mission_Inst[n], objpos_addr, float_addr) 
   --print(">> draw object: done")
   Mission_Chg[n] = false 

end

-- unload / hide / destroy a single object based on its ID number
function unload_object(n)
   --print(">> unload object: "..n)
   if Mission_Inst[n] ~= nil then   XPLM.XPLMDestroyInstance(Mission_Inst[n]) end
   if Mission_Obj[n] ~= nil then   XPLM.XPLMUnloadObject(Mission_Obj[n])  end
   Mission_Inst[n] = nil
   Mission_Obj[n] = nil
   Mission_Chg[n] = false
end

function shift_object(in_x, in_z, in_delta_x, in_delta_z, in_heading )

  -- in_delta_x refers to the difference between the x coordinates (left/right) of the ref pt and the shifted position
  -- in_delta_z refers to the difference between the z coordinates (up/down) of the ref pt and the shifted position
  -- If the shifted position is below the ref pt, in_delta_z is negative.
  -- If the shifted position is to the right of the ref pt, in_delta_x is positive
  -- in_heading is the heading that the ref pt is facing
  -- in_ref_x, in_ref_z refers to the ref point which we know the x, z coordinates and we are using that to determine the shifted pos coordinates


  l_dist = math.sqrt ( (in_delta_x ^ 2) + (in_delta_z ^ 2) )
  l_heading = math.fmod ( ( math.deg ( math.atan2 ( in_delta_x , in_delta_z  ) ) + 360 ),  360 )
  g_shifted_x  =  in_x - math.sin ( math.rad ( in_heading - l_heading) ) * l_dist * -1
  g_shifted_z  =  in_z -  math.cos ( math.rad ( in_heading - l_heading) ) *  l_dist
end


function latlon_to_local(in_lat, in_lon, in_alt)

  x1_value[0] = in_lat
  y1_value[0] = in_lon
  z1_value[0] = in_alt

  -- reuse the same variable for lat and long to receive the local x, y, z coordinates.
  XPLM.XPLMWorldToLocal(x1_value[0],y1_value[0], z1_value[0], x1_value, y1_value, z1_value )

  return  x1_value[0], y1_value[0], z1_value[0]    -- y is the elevation from mean sea level which we dont need for the time being

end

function local_to_latlon(l_x, l_y, l_z)
  x1_value[0] = l_x
  y1_value[0] = l_y
  z1_value[0] = l_z

  -- reuse the same variable for lat and long to receive the local x, y, z coordinates.
  XPLM.XPLMLocalToWorld(x1_value[0],y1_value[0], z1_value[0], x1_value, y1_value, z1_value )

  return  x1_value[0], y1_value[0], z1_value[0]    -- y is the elevation from mean sea level which we dont need for the time being
end

-- get ground elevation
function probe_y (in_x, in_y, in_z)
  local l_lat, l_on, l_alt = 0, 0, 0

  x1_value[0] = in_x
  y1_value[0] = in_y
  z1_value[0] = in_z
  --terrain_nature[0] = is_wet
  XPLM.XPLMProbeTerrainXYZ(proberef, x1_value[0], y1_value[0], z1_value[0], probeinfo_addr)
  probeinfo_value = probeinfo_addr --XPLMProbeInfo_t
  l_lat, l_lon, l_alt = local_to_latlon(probeinfo_value[0].locationX, probeinfo_value[0].locationY, probeinfo_value[0].locationZ)
  in_x, in_y, in_z = latlon_to_local(l_lat, l_lon, l_alt)
  wetness = probeinfo_value[0].is_wet -- is Wet is a boolean, 0 not over water, 1 over water.
  print(">> probe y: terrain at height " .. in_y .." and it is wet=" .. wetness)

  return in_y,wetness
end

-- define probe type
function load_probe()
  probeinfo_value[0].structSize = ffi.sizeof(probeinfo_value[0])
  probeinfo_addr = probeinfo_value
  probetype[1] = 0
  proberef =  XPLM.XPLMCreateProbe(probetype[1])
end

-- add object to current scene
function add_object(lat,lon,hdg,sit,path)
   if ( Mission_Objects < MAX_OBJECTS ) then
      load_object(Mission_Objects,path)
      Mission_Chg[Mission_Objects] = true
      Mission_LAT[Mission_Objects] = lat
      Mission_LON[Mission_Objects] = lon
      Mission_HDG[Mission_Objects] = hdg
      Mission_SIT[Mission_Objects] = sit

      Mission_PAT[Mission_Objects] = isPatient
      isPatient = false

      Mission_Objects = Mission_Objects + 1
   else
      print("Warning: maximum number of objects reached")
   end
end

-- provide random direction
function random_direction()
   return(math.random(1,360))
end

-- provide random situation
function random_situation()
   return(math.random(0,2))
end

-- update objects if changed
function update_objects()
   local n = 0
   while ( n < Mission_Objects ) do  
      if ( Mission_Chg[n] and Mission_Inst[n] ~= nil ) then
         draw_object(n)
      end
      n = n + 1
   end
end

-- hide patient 
function unload_Patient()
   local n = 0
   while ( n < Mission_Objects ) do
      if ( Mission_PAT[n] ) then
         unload_object(n)
      end
      n = n + 1
   end 
   showScene = 2
end

-- hide all objects
function unload_Objects()
   local n = 0
   while ( n < Mission_Objects ) do
      unload_object(n)
      n = n + 1
   end 
   Mission_Objects = 0
   showScene = 0
end

-- get table length
function table_length(t)
   local getN = 0
   for n in pairs(t) do 
      getN = getN + 1 
   end
   return getN
end

-- get random element from table
function get_random_from_table(t)
   local n = table_length(t) 
   return(t[math.random(1,n)])
end

-- place a random object to scene with direction
function place_obj_with_direction(lat,lon,scene,sit,dir)
   for k,v in ipairs(scene) do
      add_object(lat,lon,dir,sit,get_random_from_table(v))
   end
end

-- place a random object to scene
function place_objects(lat,lon,scene,sit)
   for k,v in ipairs(scene) do
      add_object(lat,lon,random_direction(),sit,get_random_from_table(v))
   end
end

-- create a random scene of police , fireworker abd ambulance
function add_Mission_Scene()
  if ( hasMissionX ) then     -- load MissionX target coordinates
      set("sceneMgr/lat",mx_lat)
      set("sceneMgr/lon",mx_lon)
   end

   place_objects(scenemgr_lat,scenemgr_lon,g_police,0)
   place_objects(scenemgr_lat,scenemgr_lon,g_fireworker,0)
   place_objects(scenemgr_lat,scenemgr_lon,g_ambulance,0)
   showScene = 1
end

-- create a random scene of hiker and helper
function add_Hiker_Scene()
  if ( hasMissionX ) then     -- load MissionX target coordinates
      set("sceneMgr/lat",mx_lat)
      set("sceneMgr/lon",mx_lon)
   end

   place_objects(scenemgr_lat,scenemgr_lon,g_police,0)
   place_objects(scenemgr_lat,scenemgr_lon,g_fireworker,0)
   place_objects(scenemgr_lat,scenemgr_lon,g_ambulance,0)
   showScene = 1
end

-- create a random scene of accident and helper
function add_Accident_Scene()
  if ( hasMissionX ) then     -- load MissionX target coordinates
      set("sceneMgr/lat",mx_lat)
      set("sceneMgr/lon",mx_lon)
   end

   place_objects(scenemgr_lat,scenemgr_lon,g_VU,0)
   place_objects(scenemgr_lat,scenemgr_lon,g_objects,0)
   place_objects(scenemgr_lat,scenemgr_lon,g_police,0)
   place_objects(scenemgr_lat,scenemgr_lon,g_ambulance,0)
   showScene = 1
end

-- create a random scene for winch mission
function add_Winch_Scene()
   local dir1 = random_direction()
   
   if ( hasMissionX ) then     -- load MissionX target coordinates
      set("sceneMgr/lat",mx_lat)
      set("sceneMgr/lon",mx_lon)
   end

   isPatient = true
   add_object(scenemgr_lat,scenemgr_lon,dir1,1,get_random_from_table(PEOPLE))
   isPatient = true
-- add_object(scenemgr_lat,scenemgr_lon,dir1,0,CDB_Peeps.."peeps_fijiM5.obj") -- kneeing guy
   add_object(scenemgr_lat,scenemgr_lon,dir1,0,get_random_from_table(RTWC2)) -- kneeing guy

   place_objects(scenemgr_lat,scenemgr_lon,g_winch,0)     -- some other winch scene objects
   showScene = 1
end

function add_patient_on_stretcher()
   local dir1 = random_direction()   -- get random direction
   local dir2 = dir1 - 90            -- adjust patient to it
   local dir3 = dir1 + 90            -- adjust patient to it

   isPatient = true                  -- flag next object "as patient"
   -- use stretcher , situation 4 and direction 1
   place_obj_with_direction(scenemgr_lat,scenemgr_lon,g_stretcher,4,dir1)

   isPatient = true                  -- flag next object "as patient"
   -- use random patient , situation 3 and direction 2
   place_obj_with_direction(scenemgr_lat,scenemgr_lon,g_patient,3,dir2)

   isPatient = true                  -- flag next object "as patient"
   -- use standing sani , situation 4 and direction 2
   place_obj_with_direction(scenemgr_lat,scenemgr_lon,g_sani,4,dir2)
end

-- hide the scene
function unload_Scene()
   unload_Objects()
   showScene = 0
end

-- parse a mission message and create scene from it
function parse_mission(txt)
   local mult = 1
   for token in string.gmatch(txt, "[^%s]+") do
      if ( token:match("%D") ) then
         while ( mult > 0 ) do
            print(token..": text")
            if ( token == "VU" ) then
               place_objects(scenemgr_lat,scenemgr_lon,g_VU,2)
               place_objects(scenemgr_lat,scenemgr_lon,g_objects,0)
               showScene = 1
            elseif ( token == "FW" or token == "FFW" ) then
               place_objects(scenemgr_lat,scenemgr_lon,g_FW,0)
               showScene = 1
            elseif ( token == "PATIENT" ) then
               add_patient_on_stretcher()
               showScene = 1
            elseif ( token == "RTW" ) then
               place_objects(scenemgr_lat,scenemgr_lon,g_RTW,0)
               showScene = 1
            elseif ( token == "ADAC" ) then
               place_objects(scenemgr_lat,scenemgr_lon,g_ADAC,0)
               showScene = 1
            end
            mult = mult - 1
         end
         mult = 1
      else 
         print(token..": number")
         mult = tonumber(token)
      end
   end
end

-- mappable scene control
function toggle_Demo()
   if ( showScene == 1 )  then
      unload_Patient()
   elseif ( showScene == 2 )  then
      unload_Scene()
   else
      place_Demo()
   end
end

function place_Scene()
end

-- place a demo scene
function place_Demo()

   local in_x, in_y, in_z = latlon_to_local(LATITUDE, LONGITUDE, 0)

   shift_object(in_x, in_z, 0, 100, plane_hdg )  -- place demo scene 200m ahead of us

   local  l_lat, l_lon, l_alt = local_to_latlon(g_shifted_x, 0 , g_shifted_z)

   set("sceneMgr/lat",l_lat)
   set("sceneMgr/lon",l_lon)

   parse_mission("VU mit 1 PATIENT 2 RTW und 1 FW sowie ADAC bereits vor ort")
   --parse_mission("1 PATIENT ")
end

-- parse the message from the message dataref
function parse_Message()
   parse_mission(scenemgr_message)
end

------------------------------------------------------------------------------------

load_probe()

math.randomseed(os.time())

do_often("update_objects()")

------------------------------------------------------------------------------------

--
-- plugin interface
--
create_command("FlyWithLua/sceneMgr",    "toggle demo scene", "toggle_Demo()",   "",   "")

create_command("sceneMgr/place_Demo",    "place demo scene",  "place_Demo()",   "",   "")
create_command("sceneMgr/unload_Scene",  "unload scene",      "unload_Scene()",   "",   "")
create_command("sceneMgr/unload_Patient","unload patient",    "unload_Patient()", "",   "")
create_command("sceneMgr/parse_Message", "parse message",     "parse_Message()","",   "")
create_command("sceneMgr/add_Winch_Scene", "add winch scene", "add_Winch_Scene()",  "",   "")
create_command("sceneMgr/add_Hiker_Scene", "add hiker scene", "add_Hiker_Scene()",  "",   "")
create_command("sceneMgr/add_Accident_Scene", "add accident scene", "add_Accident_Scene()",  "",   "")



