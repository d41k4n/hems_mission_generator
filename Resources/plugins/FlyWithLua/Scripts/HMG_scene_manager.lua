--
-- dynamic scene manager
--
-- inspired by XPJavelin's 'Simple and Nice Loading Equipment'
--
version = "0.41"

local logLevel = 3

local hasMissionX = false
if ( XPLMFindDataRef("xpshared/target/lat") ~= nil )then    -- missionX plugin loaded ?
   dataref("mx_lat","xpshared/target/lat","readonly")
   dataref("mx_lon","xpshared/target/lon","readonly")
   hasMissionX = true
end

local hmg_dir      = SCRIPT_DIRECTORY .. "../../../../Custom Scenery/missionx/HEMS_Mission_Generator"
local setup_dir    = hmg_dir   .. "/setup"
local scene_cfg    = setup_dir .. "/scene.cfg"

define_shared_DataRef("sceneMgr/lat", "Float")
define_shared_DataRef("sceneMgr/lon", "Float")
define_shared_DataRef("sceneMgr/hdg", "Float")
define_shared_DataRef("sceneMgr/message", "Data")
define_shared_DataRef("sceneMgr/status", "Data")

dataref("scenemgr_lat","sceneMgr/lat","readonly")
dataref("scenemgr_lon","sceneMgr/lon","readonly")
dataref("scenemgr_hdg","sceneMgr/hdg","readonly")
dataref("scenemgr_message","sceneMgr/message","readonly",0)
dataref("scenemgr_status","sceneMgr/status","writable",0)
dataref("plane_hdg", "sim/flightmodel/position/psi", "readonly")
dataref("lat_ref","sim/flightmodel/position/lat_ref","readonly")
dataref("lon_ref","sim/flightmodel/position/lon_ref","readonly")


local RescueX_cars  =  "RescueX/cars/"
local RescueX_peep  =  "RescueX/people/"
local RescueX_light =  "RescueX/lights/"
local RescueX_obj   =  "RescueX/objects/"
local People_3D     =  "3D_people_library/"
local R2_Lib_Cars   =  "R2_Library/doprava/vozidla/"
local R2_Lib_Stuff  =  "R2_Library/letiste/doplnky/"
local CDB_Peeps1    =  "CDB-Library/Peeps/polynesian/fiji/"
local CDB_Peeps2    =  "CDB-Library/Peeps/travellers/"
local CDB_Peeps3    =  "CDB-Library/Peeps/airMarshall/"
local CDB_Peeps4    =  "CDB-Library/Peeps/crew/"

local helipads = {
	"handyobjects/helipads/helicopter_hot_spot_IV.obj",
	"handyobjects/helipads/helipad_ground_square.obj"
}

local dolly = {
	"RescueX/objects/helipad_ADAC.obj"
}

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
	CDB_Peeps1 .. "peeps_fijiM6.obj",    -- standing, with bag
	CDB_Peeps1 .. "peeps_fijiM7.obj",    -- standing
	CDB_Peeps1 .. "peeps_fijiM19.obj",   -- standing, with box
	CDB_Peeps1 .. "peeps_fijiM21.obj"    -- standing, no bag	
}

local RTWC2 = {
	CDB_Peeps1 .. "peeps_fijiM5.obj",    -- just kneeing
	CDB_Peeps1 .. "peeps_fijiM20.obj"    -- kneeing, with box
}

local RTWC3 = {
	CDB_Peeps1 .. "peeps_fijiM6.obj"    -- standing, no bag	
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

local SKIERS = {
	CDB_Peeps2 .. "peeps_TW_standing7.obj",
	CDB_Peeps2 .. "peeps_TW_standing8.obj",
	CDB_Peeps2 .. "peeps_TW_standing9.obj",
	CDB_Peeps2 .. "peeps_TW_standing10.obj"
}

local DOCS = {
	CDB_Peeps3 .. "peeps_ramp_agentM9.obj",
	CDB_Peeps4 .. "peeps_crew3.obj"
}

local BASESTAFF = {
	--RescueX_peep .. "Bergwacht/Bergwacht_Hubschraubereinweiser.obj"
	--"helos/Heli-Marschaller.obj"
	CDB_Peeps3 .. "peeps_ramp_agentM1.obj"
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
-- scene groups : tables of tables of objects
--
local g_patient = {PEOPLE}                     -- patient table
local g_sani = {RTWC3}                         -- patient table
local g_sani_knee = {RTWC2}                    -- patient table
local g_stretcher = {STRETCHER}                -- patient table
local g_doc = {DOCS}                           -- doctor table
local g_skier = {SKIERS}                       -- skiers table

local g_car = {CARS}                           -- 1 car

local g_cars = {CARS,CARS,CARS,CARS}           -- 4 random cars

local g_police = {POLC,POLC,POLV}              -- 2 police Crew and one Vehicle 

local g_ambulance = {RTWC,RTWC,RTWV}           -- 2 RTW Crew and one Vehicle

local g_fireworker = {FWC,FWC,FWC,FWC,FWV}     -- 4 fireworker Crew and one Vehicle

local g_objects = {OBS,OBS,OBS,OBS,OBS}        -- 5 random objects

local g_people = {PEOPLE}

local g_winch = {PEOPLE,RTWC,PEOPLE,RTWC,PEOPLE,OBS2,OBS2}

local g_dropoff = {STRETCHER,DOCS}

local g_pickup = {STRETCHER,DOCS}

-- groups used by "parse_mission"
local g_ADAC  = {ADAC_CARS}                    -- a random crash car
local g_VU  = {CCARS}                          -- a random crash car
local g_FW  = {FWC,FWC,FWC,FWC,FWV}            -- table of tables
local g_RTW = {RTWC,RTWC,RTWV}                 -- table of tables


local out_x = 0
local out_y = 0
local out_z = 0
local bearing = 0
local showScene = 0
local isPatient = false
local lat_ref_last = lat_ref
local lon_ref_last = lon_ref

set("sceneMgr/lat",LATITUDE)                   -- default is ACF position
set("sceneMgr/lon",LONGITUDE)
set("sceneMgr/hdg",0)

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

  void XPLMUnregisterDataAccessor(XPLMDataRef inDataRef);
*/

  XPLMObjectRef XPLMLoadObject( const char *inPath);
  void XPLMLoadObjectAsync( const char * inPath, XPLMObjectLoaded_f inCallback, void *inRefcon);

  XPLMInstanceRef XPLMCreateInstance(XPLMObjectRef obj, const char **datarefs);
  void XPLMInstanceSetPosition(XPLMInstanceRef instance, const XPLMDrawInfo_t *new_position, const float *data);

  XPLMProbeRef XPLMCreateProbe(XPLMProbeType inProbeType);
  XPLMProbeResult XPLMProbeTerrainXYZ( XPLMProbeRef inProbe, float inX, float inY, float inZ, XPLMProbeInfo_t *outInfo);

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


local MAX_OBJECTS     = 100
local currentScene    = 0
local objectsInScene  = {}    -- object attributes
      objectsInScene[currentScene] = 0
local totalObjects    = 0     -- number of mission objects
local inScenePosition = {}

local Object_Inst    = ffi.new("XPLMInstanceRef[100]")
local Object_Obj     = ffi.new("XPLMObjectRef[100]")
local Object_Chg     = {}
local Object_LAT     = {}    -- object latitude
local Object_LON     = {}    -- object longitude
local Object_HDG     = {}    -- object heading
local Object_SIT     = {}    -- object situation
local Object_ATR     = {}    -- object attribute
local Object_SCN     = {}    -- object scene

-- object attributes:
--	1=patient
--	( more TBD )

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

function smLog(t,l)
   if ( l <= logLevel ) then
      print("[SM] "..t)
   end
end

local scene_lookup = {}

function read_scene_lookup()
   scene_lookup = {}
   local infile = io.open(scene_cfg,"r")
   if ( infile ) then
      for line in infile:lines() do
         if ( not line:match('^#') and line:match(':') ) then         -- skip comment lines

            local k , v = line:match("([^:]+):([^:]+)")
            scene_lookup[k] = v
            smLog("reading scene config  k="..k.."  and v="..v,2)
         end
      end
      io.close(infile)
   else
      smLog("not scene lookup file found",0)
   end
end

function write_scene_lookup()
   local infile = io.open(scene_cfg,"r")
   if ( infile ) then
      local outfile = io.open(scene_cfg..".tmp","w")
      if ( outfile ) then
         smLog("write scene.cfg",2)
         for line in infile:lines() do
      
            if ( not line:match('^#') and line:match(':') ) then         -- skip comment lines
               local k , v = line:match("([^:]+):([^:]+)")
               local t = k..":"..scene_lookup[k]
               smLog("upd: "..t,3)
               outfile:write(t.."\n")
               scene_lookup[k] = nil   -- remove updated entries from array
            else
               smLog("copy: "..line,3)
               outfile:write(line.."\n")
            end
         end
         smLog("closing infile",3)
         io.close(infile)

         -- write new entries
         for k,v in pairs(scene_lookup) do
            smLog("k == "..k,3)
            if ( v == nil ) then
               smLog("v == nil",3)
            else 
               smLog("new: "..v,3)
               outfile:write(k..":"..v.."\n")
            end
         end
         smLog("closing outfile",3)
         io.close(outfile)
         smLog("remove old cfg",3)
         os.remove(scene_cfg)
         smLog("renaming tmp file",3)
         os.rename(scene_cfg..".tmp",scene_cfg)
         smLog("re-read scene.cfg ",3)
         read_scene_lookup()
         smLog("done.",3)
      else
         smLog("cannot open scene.cfg.tmp for writing",0)
      end
   else
      smLog("cannot open scene.cfg for reading",0)
   end
end

function load_position(k,obj)
   for w in string.gmatch(scene_lookup[k], '([^;]+)') do
      if ( w:match('^'..obj..'=') ) then
         smLog("matching = "..obj,2)

         local la,lo,hd = w:match(".*=([^,]+),([^,]+),([^,]+)")

         smLog("using coords = "..la.." , "..lo.." , "..hd,2)
         scenemgr_lat = tonumber(la)
         scenemgr_lon = tonumber(lo)
         scenemgr_hdg = tonumber(hd)
      end
   end
end

function make_key(lat,lon)
   local k = string.format("%s",lat)
   local i = string.format("%s",lon)
   -- truncate to 3 decimals without rounding
   return(k:sub(1,k:find("%.")+3) ..","..  i:sub(1,i:find("%.")+3))
end

function object_lookup(lat,lon,obj)
   local k = make_key(lat,lon)

   if ( scene_lookup[k] ) then
      smLog("scene lookup match with "..k,2)
      load_position(k,obj)
      return(true)
   else
      smLog("NO scene lookup match with "..k,2)
      return(false)
   end
end

--------------------------------------------------------------

function load_object(n,path)
   if Object_Inst[n] == nil then
      smLog("load object: "..n.." > "..path,1)

      XPLM.XPLMLookupObjects( path, 0,0,
         function(real_path, inRefcon)
            smLog("real_path: "..ffi.string(real_path),1)
            XPLM.XPLMLoadObjectAsync(real_path,
               function(inObject, inRefcon)
                  smLog("load object: executing callback",1)
                  Object_Inst[n] = XPLM.XPLMCreateInstance(inObject, datarefs_addr)
                  Object_Obj[n] = inObject
               end,
               inRefcon )
         end,
         inRefcon )
   else
      smLog("load object: instance " .. n .. " exists",1)
   end
end

function draw_object(n)
   local l_lat,l_lon,l_alt,l_hdg

   l_lat = Object_LAT[n]
   l_lon = Object_LON[n]
   l_hdg = Object_HDG[n]

   local N = inScenePosition[n] -- use the "in scene position" instead total 

   l_alt = 0
   smLog("l_lat="..l_lat.." l_lon="..l_lon.." hdg="..l_hdg,4)

   in_x, in_y, in_z = latlon_to_local(l_lat, l_lon, l_alt)        -- start with elv 0

   smLog("pass0: x="..in_x.." y="..in_y.." z="..in_z,4)
 
   out_x,out_y,out_z,wetness = probe_elevation (in_x, in_y, in_z) -- find elv of x,z

   smLog("pass1: x="..in_x.." ("..out_x..") y="..in_y.." ("..out_y..") z="..in_z.." ("..out_z..")",4)

   local b_lat,b_lon,b_alt = local_to_latlon(out_x,out_y,out_z)   -- get world alt

   in_x, in_y, in_z = latlon_to_local(l_lat, l_lon, b_alt)        -- redo with new alt

   smLog("pass2: x="..in_x.." y="..in_y.." z="..in_z,4)


   -- SIT ( situation )
   --    0 = default
   --    1 = object laying on ground ( i.e. person on its back )
   --    2 = object laying on right side  
   --    3 = object elevated and shifted ( i.e. person on stretcher ) 
   --    4 = object will not be shifted
   --    5 = object will not be shifted but heading oriented towards the ACF
   --    6 = as 3 plus moved away a bit
   --    7 = as 4 plus moved away a bit
   --    8 = as 4 plus moved 10 ahead of ACF 

   if ( Object_SIT[n] < 3 ) then      -- situation < 3 = normal distribution
       -- SHIFT
       --     POSITIVE LEFT < x > NEGATIVE RIGHT
       --     POSITIVE FWD < z > NEGATIVE AFT

      shift_object(in_x, in_z, N*0.5, N*0.5, l_hdg )
      smLog("new heading "..l_hdg,3)
   else
      if ( Object_SIT[n] == 6 or Object_SIT[n] == 7 ) then 
         in_z = in_z + 2
         in_x = in_x + 2
      end

      if ( Object_SIT[n] == 3 or Object_SIT[n] == 6 ) then     -- situation 3 = adjust patient to stretcher
         shift_object(in_x, in_z, 0.0, -0.9, l_hdg )		 

      else
         out_x = in_x
         out_z = in_z
      end
   end

   local out_x,out_y,out_z,wetness = probe_elevation (out_x, in_y, out_z)  -- find final elv
 
   objpos_value[0].x = out_x 
   objpos_value[0].y = out_y
   objpos_value[0].z = out_z 
   
   smLog("pass3: out_x="..out_x.." out_y="..out_y.." out_z="..out_z,4)

   objpos_value[0].heading = l_hdg

   float_value[0] = 0
   float_addr = float_value
 
   objpos_value[0].pitch = 0
   objpos_value[0].roll = 0

   if ( Object_SIT[n] == 1 ) then                             -- situation 1 = person laying on ground 
      objpos_value[0].pitch = -90
      objpos_value[0].y = out_y + 0.3

   elseif ( Object_SIT[n] == 2 ) then                         -- situation 2 = object laying on right side
      objpos_value[0].roll = 90
      objpos_value[0].y = out_y + 0.5

   elseif ( Object_SIT[n] == 3 or Object_SIT[n] == 6) then    -- situation 3 & 6 = patient on stretcher
      objpos_value[0].pitch = -90
      objpos_value[0].y = out_y + 1.1

   elseif ( Object_SIT[n] == 5 ) then                         -- situation 5 = oriented towards the aircraft 

      l_hdg = get_heading(l_lat,l_lon,LATITUDE,LONGITUDE)     -- get heading towards the aircraft
      l_hdg = (l_hdg + 180 + 360) % 360
      objpos_value[0].heading = l_hdg
      smLog("sit 5 heading "..l_hdg,4)

   end

   --smLog("world: in_x=" .. in_x .. ", in_y=" .. in_y .. ", in_z=" .. in_z ,3)
   smLog("draw object: latlon: l_lat=" .. l_lat .. ", l_lon=" .. l_lon .. ", l_alt=" .. l_alt .. ", l_hdg=" .. l_hdg,2)

   smLog("draw object: altitude " .. objpos_value[0].y,3)
   objpos_addr = objpos_value
   XPLM.XPLMInstanceSetPosition(Object_Inst[n], objpos_addr, float_addr) 
   smLog("draw object: done",3)
   Object_Chg[n] = false 
end

-- unload / hide / destroy a single object based on its ID number
function unload_object(n)
   smLog("unload object: "..n,1)
   if Object_Inst[n] ~= nil then   XPLM.XPLMDestroyInstance(Object_Inst[n]) end
   if Object_Obj[n] ~= nil then   XPLM.XPLMUnloadObject(Object_Obj[n])  end
   Object_Inst[n] = nil
   Object_Obj[n] = nil
   Object_Chg[n] = false
   totalObjects = totalObjects - 1
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
   out_x  =  in_x - math.sin ( math.rad ( in_heading - l_heading) ) * l_dist * -1
   out_z  =  in_z -  math.cos ( math.rad ( in_heading - l_heading) ) *  l_dist
end


function get_heading(la1, lo1, la2, lo2)
   -- from https://www.igismap.com/formula-to-find-bearing-or-heading-angle-between-two-points-latitude-longitude/

   local lat1 = math.rad(la1)
   local lat2 = math.rad(la2)

   local D = (math.rad(lo2)-math.rad(lo1))
   local Y = math.sin(D) * math.cos(lat2)
   local X = math.cos(lat1)*math.sin(lat2)-math.sin(lat1)*math.cos(lat2)*math.cos(D)
   local p = math.atan2(Y,X)
   bearing = ((p * 180 / math.pi) + 360) % 360

   return(bearing)

end

function latlon_to_local(in_lat, in_lon, in_alt)
   x1_value[0] = in_lat
   y1_value[0] = in_lon
   z1_value[0] = in_alt

   -- reuse the same variable for lat and long to receive the local x, y, z coordinates.
   XPLM.XPLMWorldToLocal(x1_value[0],y1_value[0], z1_value[0], x1_value, y1_value, z1_value )

   return  x1_value[0], y1_value[0], z1_value[0]    -- y is the elevation from mean sea level which we dont need for the time being

end

function local_to_latlon(in_x, in_y, in_z)
   x1_value[0] = in_x
   y1_value[0] = in_y
   z1_value[0] = in_z

   -- reuse the same variable for lat and long to receive the local x, y, z coordinates.
   XPLM.XPLMLocalToWorld(x1_value[0],y1_value[0], z1_value[0], x1_value, y1_value, z1_value )

   return  x1_value[0], y1_value[0], z1_value[0]    -- y is the elevation from mean sea level which we dont need for the time being
end

-- get ground elevation
function probe_elevation (in_x, in_y, in_z)

   x1_value[0] = in_x
   y1_value[0] = in_y
   z1_value[0] = in_z

   XPLM.XPLMProbeTerrainXYZ(proberef, x1_value[0], y1_value[0], z1_value[0], probeinfo_addr)
   probeinfo_value = probeinfo_addr --XPLMProbeInfo_t

   in_x = probeinfo_value[0].locationX
   in_y = probeinfo_value[0].locationY
   in_z = probeinfo_value[0].locationZ

   wetness = probeinfo_value[0].is_wet -- is Wet is a boolean, 0 not over water, 1 over water.
   smLog("probe elevation: terrain at height " .. in_y .." and it is wet=" .. wetness,3)

   return in_x,in_y,in_z,wetness
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
   if ( totalObjects < MAX_OBJECTS ) then
      load_object(totalObjects,path)
      Object_Chg[totalObjects] = true
      Object_LAT[totalObjects] = lat
      Object_LON[totalObjects] = lon
      Object_HDG[totalObjects] = hdg
      Object_SIT[totalObjects] = sit

      Object_ATR[totalObjects] = 0
      Object_SCN[totalObjects] = currentScene 

      inScenePosition[totalObjects] = objectsInScene[currentScene]

      smLog("add object "..totalObjects.." to scene "..currentScene.." as nbr "..objectsInScene[currentScene],2)

      Object_ATR[totalObjects] = 0
      if ( isPatient ) then
         Object_ATR[totalObjects] = 1
         isPatient = false
      end 

      totalObjects = totalObjects + 1
      objectsInScene[currentScene] = objectsInScene[currentScene] + 1
   else
      smLog("Warning: maximum number of objects reached",0)
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

function ref_has_changed()
   if ( lat_ref ~= lat_ref_last or lon_ref ~= lon_ref_last ) then
      lat_ref_last = lat_ref
      lon_ref_last = lon_ref
      return(true)
   else
      return(false)
   end
end

-- update objects if changed
function update_objects()
   local n = 0
   if ( ref_has_changed() ) then               -- re-draw objects on new tile only
      while ( n < totalObjects ) do  
         if ( Object_Inst[n] ~= nil ) then
           draw_object(n)
         end
         n = n + 1
      end
   else
      while ( n < totalObjects ) do  
         if ( Object_Inst[n] ~= nil and (Object_Chg[n] or (Object_SIT[n] == 5 and is_near(Object_LAT[n],Object_LON[n])) ) ) then
            draw_object(n)
         end
         n = n + 1
      end
   end
end

function is_near(lat, lon)
   if (  (tonumber(string.format("%.2f",lat)) == tonumber(string.format("%.2f",LATITUDE))) and
         (tonumber(string.format("%.2f",lon)) == tonumber(string.format("%.2f",LONGITUDE))) ) then
      --print("is near")
      return(true)
   else
      --print("is not near")
      return(false)
   end
end

-- hide patient 
function unload_Patient()
   local n = 0
   local z = totalObjects
   scenemgr_status = "unload patient"

   while ( n < z ) do
      if ( Object_ATR[n] == 1 ) then
         unload_object(n)
         totalObjects = totalObjects + 1      -- correct object count to ignore "hole"
      end
      n = n + 1
   end 
end

-- unload all objects
function unload_All()
   local n = 0
   local z = totalObjects
   scenemgr_status = "unload all"

   while ( n < z ) do
      unload_object(n)
      n = n + 1
   end 
   totalObjects = 0
   currentScene = 0
  objectsInScene = {}
end

-- unload current scene only
function unload_current_scene()
   local n = 0

   if ( currentScene > 0 ) then
      local z = totalObjects
      while ( n < z ) do
         if ( Object_SCN[n] == currentScene ) then
            unload_object(n)
         end
         n = n + 1
      end 
      objectsInScene[currentScene] = 0
      currentScene = currentScene - 1
   end
end

function create_new_scene()
   if ( currentScene < 100 ) then
      currentScene = currentScene + 1
      objectsInScene[currentScene] = 0
   end
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

------------------------------------------------------------------------------------

-- create a random scene of hiker and helper
function add_Hiker_Scene()                --- TO BE COMPLETED 

   scenemgr_status = "hiker called"
   create_new_scene()
   
   if ( hasMissionX ) then     -- load MissionX target coordinates
      set("sceneMgr/lat",mx_lat)
      set("sceneMgr/lon",mx_lon)
   end

   place_objects(scenemgr_lat,scenemgr_lon,g_police,0)
   place_objects(scenemgr_lat,scenemgr_lon,g_ambulance,0)
end

-- create a random scene of accident and helper
function add_Accident_Scene()

   scenemgr_status = "accident called"
   create_new_scene()

   if ( hasMissionX ) then     -- load MissionX target coordinates
      set("sceneMgr/lat",mx_lat)
      set("sceneMgr/lon",mx_lon)
   end

   parse_mission("VU 1 PATIENT 1 RTW POLIZEI")
end

-- create a random scene for winch mission
function add_Winch_Scene()
   local dir1 = random_direction()

   scenemgr_status = "winch called"
   create_new_scene()
   
   if ( hasMissionX ) then     -- load MissionX target coordinates
      set("sceneMgr/lat",mx_lat)
      set("sceneMgr/lon",mx_lon)
   end

   isPatient = true
   add_object(scenemgr_lat,scenemgr_lon,dir1,1,get_random_from_table(PEOPLE))
   isPatient = true
   add_object(scenemgr_lat,scenemgr_lon,dir1,0,get_random_from_table(RTWC2)) -- kneeing guy
   place_objects(scenemgr_lat,scenemgr_lon,g_winch,0)     -- some other winch scene objects
end

-- create a random scene for dropoff leg
function add_Dropoff_Scene(n)
   local dir1 = random_direction()
   
   scenemgr_status = "dropoff called"
   create_new_scene()
   
   if ( n == 0 and hasMissionX ) then     -- load MissionX target coordinates
      set("sceneMgr/lat",mx_lat)
      set("sceneMgr/lon",mx_lon)
   else
      scenemgr_lat = LATITUDE
	  scenemgr_lon = LONGITUDE
   end
  
   scenemgr_hdg = 0
   if ( object_lookup(scenemgr_lat,scenemgr_lon,"dropoff") ) then    
      isPatient = true
      add_object(scenemgr_lat,scenemgr_lon,scenemgr_hdg,4,get_random_from_table(DOCS))
      isPatient = true
      add_object(scenemgr_lat,scenemgr_lon-0.00002,scenemgr_hdg,4,get_random_from_table(STRETCHER))
   end 
end

-- create a random scene for dropoff leg
function add_Pickup_Scene(n)
   local dir1 = random_direction()
   
   scenemgr_status = "pickup called"
   create_new_scene()

   if ( n == 0 and hasMissionX ) then     -- load MissionX target coordinates
      set("sceneMgr/lat",mx_lat)
      set("sceneMgr/lon",mx_lon)
   else
      scenemgr_lat = LATITUDE
	  scenemgr_lon = LONGITUDE
   end
  
   scenemgr_hdg = 0
   if ( object_lookup(scenemgr_lat,scenemgr_lon,"pickup") ) then     
      isPatient = true
      add_object(scenemgr_lat,scenemgr_lon,scenemgr_hdg,4,get_random_from_table(DOCS))
      isPatient = true
      add_object(scenemgr_lat,scenemgr_lon-0.00002,scenemgr_hdg,4,get_random_from_table(STRETCHER))
      isPatient = true
      add_object(scenemgr_lat,scenemgr_lon-0.00002,scenemgr_hdg-90,3,get_random_from_table(PEOPLE))
   end 
end

-- create a random scene of police , fireworker and ambulance
function add_Rescue_Scene()

   scenemgr_status = "rescue called"
   create_new_scene()

   if ( hasMissionX ) then     -- load MissionX target coordinates
      set("sceneMgr/lat",mx_lat)
      set("sceneMgr/lon",mx_lon)
   end

   parse_mission("1 PATIENT 1 RTW")
end

-- create a scene for home base
function add_Base_Scene(n)

   scenemgr_status = "base called"
   create_new_scene()

   if ( n == 0 and hasMissionX ) then             -- load MissionX target coordinates
      set("sceneMgr/lat",mx_lat)
      set("sceneMgr/lon",mx_lon)
   else
      scenemgr_lat = LATITUDE
	  scenemgr_lon = LONGITUDE
   end
   
   scenemgr_hdg = 0
   
   if ( object_lookup(scenemgr_lat,scenemgr_lon,"marshall") ) then
      add_object(scenemgr_lat,scenemgr_lon,scenemgr_hdg,4,get_random_from_table(BASESTAFF))
   end

   --add_object(scenemgr_lat,scenemgr_lon,0,5,get_random_from_table(BASESTAFF))
   --add_object(scenemgr_lat,scenemgr_lon,180,4,get_random_from_table(BASESTAFF))
   -- maybe add APU and fire extinguisher
end

-- create a dude for adjustment
function show_Marshall()

   scenemgr_status = "marshall called"
   create_new_scene()

   local in_x, in_y, in_z = latlon_to_local(LATITUDE, LONGITUDE, 0)
   shift_object(in_x, in_z, 0, 5, plane_hdg )  -- place doc scene 5m ahead of us
   local  l_lat, l_lon, l_alt = local_to_latlon(out_x, 0 , out_z)
   
   add_object(l_lat,l_lon,0,4,get_random_from_table(BASESTAFF))
end

function show_Doc()

   scenemgr_status = "doc called"
   create_new_scene()

   local in_x, in_y, in_z = latlon_to_local(LATITUDE, LONGITUDE, 0)
   shift_object(in_x, in_z, 0, 5, plane_hdg )  -- place doc scene 5m ahead of us
   local  l_lat, l_lon, l_alt = local_to_latlon(out_x, 0 , out_z)
   
   add_object(l_lat,l_lon,0,4,get_random_from_table(DOCS))
end

-------------------------------------------------------------------------------------

function add_patient_on_stretcher()
   local dir1 = random_direction()   -- get random direction
   local dir2 = dir1 - 90            -- adjust patient to it
   local dir3 = dir1 + 90            -- adjust patient to it

   isPatient = true                  -- flag next object "as patient"
   -- use stretcher , situation 4 and direction 1
   place_obj_with_direction(scenemgr_lat,scenemgr_lon,g_stretcher,7,dir1)

   isPatient = true                  -- flag next object "as patient"
   -- use random patient , situation 3 and direction 2
   place_obj_with_direction(scenemgr_lat,scenemgr_lon,g_patient,6,dir2)

   isPatient = true                  -- flag next object "as patient"
   -- use standing sani , situation 4 and direction 2
   place_obj_with_direction(scenemgr_lat,scenemgr_lon,g_sani,7,dir2)
end

-- hide last scene
function unload_Scene()
   scenemgr_status = "unload scene"
   unload_current_scene()
end

-- parse a mission message and create scene from it
function parse_mission(txt)

   create_new_scene()

   local mult = 1
   for token in string.gmatch(txt, "[^%s]+") do
      if ( token:match("%D") ) then
         while ( mult > 0 ) do
            smLog(token..": text",2)
            if ( token == "VU" ) then
               place_objects(scenemgr_lat,scenemgr_lon,g_VU,0)
               place_objects(scenemgr_lat,scenemgr_lon,g_objects,0)
            elseif ( token == "PATIENT" ) then
               add_patient_on_stretcher()
            elseif ( token == "PERSONEN" or token == "people" ) then
               place_objects(scenemgr_lat,scenemgr_lon,g_people,0)
            elseif ( token == "POLIZEI" or token == "police" ) then
               place_objects(scenemgr_lat,scenemgr_lon,g_police,0)
            elseif ( token == "FW" or token == "FFW" ) then
               place_objects(scenemgr_lat,scenemgr_lon,g_FW,0)
            elseif ( token == "AUTO" or token == "cars" ) then
               place_objects(scenemgr_lat,scenemgr_lon,g_car,0)
            elseif ( token == "RTW" ) then
               place_objects(scenemgr_lat,scenemgr_lon,g_RTW,0)
            elseif ( token == "ADAC" ) then
               place_objects(scenemgr_lat,scenemgr_lon,g_ADAC,0)
            end
            mult = mult - 1
         end
         mult = 1
      else 
         smLog(token..": number",2)
         mult = tonumber(token)
      end
   end
end

-- mappable scene control
function toggle_Demo()
   if ( showScene == 1 )  then
      unload_Patient()
      showScene = 2
   elseif ( showScene == 2 )  then
      unload_Scene()
      showScene = 0
   else
      place_Demo()
      showScene = 1
   end
end

function load_auto_objects()
   if ( LATITUDE > 47.872 and LATITUDE < 47.875 and  LONGITUDE > 12.630 and LONGITUDE < 12.632 ) then

      add_object( 47.873983772 , 12.631342556 ,270,4,"RescueX/objects/helipad_ADAC.obj")       
      add_object( 47.874159240 , 12.631392020 ,180,4,"handyobjects/helipads/helipad_ground_square.obj")

   end
end

-- place a demo scene
function place_Demo()

   local in_x, in_y, in_z = latlon_to_local(LATITUDE, LONGITUDE, 0)

   shift_object(in_x, in_z, 0, 100, plane_hdg )  -- place demo scene 100m ahead of us

   local  l_lat, l_lon, l_alt = local_to_latlon(out_x, 0 , out_z)

   set("sceneMgr/lat",l_lat)
   set("sceneMgr/lon",l_lon)

   parse_mission("VU mit 1 PATIENT 2 RTW und 1 FW sowie ADAC bereits vor ort")
   --parse_mission("1 PATIENT ")
end

-- parse the message from the message dataref
function parse_Message()
   parse_mission(scenemgr_message)
end

----------------------------------------------------------------------------------

function move_North()
   local n = totalObjects - 1
   if ( n >= 0 and Object_Obj[n] ~= nil ) then
      Object_LAT[n] = Object_LAT[n] + 0.00001
      Object_Chg[n] = true
      draw_object(n)
   end
end

function move_South()
   local n = totalObjects - 1
   if ( n >= 0 and Object_Obj[n] ~= nil ) then
      Object_LAT[n] = Object_LAT[n] - 0.00001
      Object_Chg[n] = true
      draw_object(n)
   end
end

function move_West()
   local n = totalObjects - 1
   if ( n >= 0 and Object_Obj[n] ~= nil) then
      Object_LON[n] = Object_LON[n] - 0.00001
      Object_Chg[n] = true
      draw_object(n)
   end
end

function move_East()
   local n = totalObjects - 1
   if ( n >= 0 and Object_Obj[n] ~= nil ) then
      Object_LON[n] = Object_LON[n] + 0.00001
      Object_Chg[n] = true
      draw_object(n)
   end
end

function turn_Left()
   local n = totalObjects - 1
   if ( n >= 0 and Object_Obj[n] ~= nil ) then
      Object_HDG[n] = (Object_HDG[n] + 360 - 10) % 360
      Object_Chg[n] = true
      draw_object(n)
   end
end

function turn_Right()
   local n = totalObjects - 1
   if ( n >= 0 and Object_Obj[n] ~= nil ) then
      Object_HDG[n] = (Object_HDG[n] + 360 + 10) % 360
      Object_Chg[n] = true
      draw_object(n)
   end
end

function save_as(t)
   local n = totalObjects - 1
   if ( n >= 0 and Object_Obj[n] ~= nil ) then

      local k = make_key(LATITUDE,LONGITUDE)

      smLog("save "..t.." for key " .. k .. " with "..Object_LAT[n].." / "..Object_LON[n],2)

      if ( scene_lookup[k] ) then           -- key already exists
         smLog("save before: "..scene_lookup[k],3)

         local v = ""
         for w in string.gmatch(scene_lookup[k], '([^;]+)') do
            if ( not w:match('^'..t..'=') ) then
               v = v..w..";"
            end
         end
         v = v..t.."="..Object_LAT[n]..","..Object_LON[n]..","..Object_HDG[n]..";"
         scene_lookup[k] = v

      else                                 -- add new key for current location
         smLog("save before: empty",3)
         scene_lookup[k] = t.."="..Object_LAT[n]..","..Object_LON[n]..","..Object_HDG[n]..";"
      end
      smLog("save after: "..scene_lookup[k],3)

      write_scene_lookup()

   end
end

----------------------------------------------------------------------------------

smLog("sceneMgr version "..version.." started",0)

load_probe()

read_scene_lookup()

--load_auto_objects()

math.randomseed(os.time())

do_often("update_objects()")

------------------------------------------------------------------------------------

--
-- plugin interface
--
create_command("FlyWithLua/sceneMgr",         "toggle demo scene",  "toggle_Demo()",        "",   "")

create_command("sceneMgr/place_Demo",         "place demo scene",   "place_Demo()",         "",   "")
create_command("sceneMgr/unload_All",         "unload all scenes",  "unload_All()",         "",   "")
create_command("sceneMgr/unload_Scene",       "unload scene",       "unload_Scene()",       "",   "")
create_command("sceneMgr/unload_Patient",     "unload patient",     "unload_Patient()",     "",   "")
create_command("sceneMgr/parse_Message",      "parse message",      "parse_Message()",      "",   "")
create_command("sceneMgr/add_Winch_Scene",    "add winch scene",    "add_Winch_Scene()",    "",   "")
create_command("sceneMgr/add_Hiker_Scene",    "add hiker scene",    "add_Hiker_Scene()",    "",   "")
create_command("sceneMgr/add_Accident_Scene", "add accident scene", "add_Accident_Scene()", "",   "")
create_command("sceneMgr/add_Base_Scene",     "add base scene",     "add_Base_Scene(0)",    "",   "")
create_command("sceneMgr/add_Dropoff_Scene",  "add dropoff scene",  "add_Dropoff_Scene(0)", "",   "")
create_command("sceneMgr/add_Pickup_Scene",   "add pickup scene",   "add_Pickup_Scene(0)",  "",   "")
create_command("sceneMgr/add_Rescue_Scene",   "add rescue scene",   "add_Rescue_Scene()",   "",   "")


create_command("sceneMgr/move_North",         "move object north",  "move_North()",         "",   "")
create_command("sceneMgr/move_South",         "move object south",  "move_South()",         "",   "")
create_command("sceneMgr/move_West",          "move object west",   "move_West()",          "",   "")
create_command("sceneMgr/move_East",          "move object east",   "move_East()",          "",   "")
create_command("sceneMgr/turn_Left",          "turn object left",   "turn_Left()",          "",   "")
create_command("sceneMgr/turn_Right",         "turn object right",  "turn_Right()",         "",   "")
create_command("sceneMgr/save_Marshall",      "save as marshall",   'save_as("marshall")',  "",   "")
create_command("sceneMgr/save_Dropoff",       "save as dropoff",    'save_as("dropoff")',   "",   "")
create_command("sceneMgr/save_Pickup",        "save as pickup",     'save_as("pickup")',    "",   "")
create_command("sceneMgr/test_Marshall",      "test marshall",      'add_Base_Scene(1)',    "",   "")
create_command("sceneMgr/test_Dropoff",       "test dropoff",       'add_Dropoff_Scene(1)', "",   "")
create_command("sceneMgr/test_Pickup",        "test pickup",        'add_Pickup_Scene(1)',  "",   "")
create_command("sceneMgr/show_Marshall",      "show marshall",      "show_Marshall()",      "",   "")
create_command("sceneMgr/show_Doc",           "show doc",           "show_Doc()",           "",   "")



