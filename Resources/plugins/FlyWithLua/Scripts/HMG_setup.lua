--
-- script to build a new HMG template.xml
--
-- v1.3
--

local applyWaitingFix  = true
local applyNavaidsFix  = true
local applyDistanceFix = false

local acf_txt = {
   ec135  = "Rotorsim EC135 V5",
   h145   = "VLC-Entwicklung H145 Rescue Version v3.1",
   h145f  = "XFER (Fraxy) H145"
}

local contents = {
   hover             = "content-medevac_hover",
   hover_hiker       = "content-medevac_hover_hiker_osm",
   hover_ski         = "content-medevac_hover_ski_osm",
   hover_test        = "content-medevac_hover_test",
   hospital          = "content-medevac_hospital",
   hospital_germany  = "content-medevac_hospital_germany",
   land              = "content-medevac_land",
   parking           = "content-medevac_parking_osm",
   pitch             = "content-medevac_pitch_osm",
   road              = "content-medevac_road_osm"
}

local xtitle     = {}
local xplane     = {}
local xbase      = {}
local xhome      = {}
local xoverpass  = {}
local xcontent   = {}
local xrange     = {}
 
local hmg_dir      = SCRIPT_DIRECTORY .. "../../../../Custom Scenery/missionx/HEMS_Mission_Generator"
local setup_dir    = hmg_dir   .. "/setup"
local template_xml = hmg_dir   .. "/template.xml"
local sites_out    = setup_dir .. "/03_replace"
local sites_in     = setup_dir .. "/sites.in"
local sites_cfg    = setup_dir .. "/sites.cfg"


local template = {}

function initArrays()
  xtitle    = {}
  xplane    = {}
  xbase     = {}
  xhome     = {}
  xoverpass = {}
  xtemplate = {}
  xrange    = {}
  collectgarbage()
end

function printData()
  local k,v
  for k,v in pairs(xtitle) do
    print("HMG-setup: "..k)
    print("   " .. xtitle[k])
    print("   " .. xbase[k])
    print("   " .. xhome[k])
    print("   " .. xplane[k])
    print("   " .. xoverpass[k])
    print("   " .. xrange[k])	
  end
end

function genLocations()
  local k,v
  local fname = setup_dir .. "/01_locations"
  local outfile = io.open(fname,"w")
  local t1 = {} 
  local t2 = {}
  for k,v in pairs(xhome) do
    t1[string.format("- %s\n" , val)] = 1       -- build assoc array with uniqe home-bases
  end
  for k,v in pairs(t1) do
     table.insert(t2,k)                             -- now convert this array into a table
  end
  table.sort(t2)                                    -- no sort this table
  for k,v in ipairs(t2) do
    outfile:write(v)                                -- write the sorted home-base list to file
  end
  io.close(outfile);
end

function readFile(f)
  local infile = io.open(f,"r")
  for line in infile:lines() do
    table.insert (template, line)
  end
  io.close(infile)
end

function appendFile(f)
  local k,v
  local outfile = io.open(f,"a")
  for k,v in ipairs(template) do
    outfile:write(string.format("%s\n" , v))
  end
  io.close(outfile)
end

function writeFile(f)
  local k,v
  local outfile = io.open(f,"w")
  for k,v in ipairs(template) do
    outfile:write(string.format("%s\n" , v))
  end
  io.close(outfile)
end

function readSitesIn()
  template = {}
  readFile(sites_in)
end

function writeSitesOut()
  appendFile(sites_out)
end

function writeHead()
  local fname = sites_out
  local outfile = io.open(fname,"a")
  outfile:write(string.format("<REPLACE_OPTIONS>\n"))
  io.close(outfile)
end

function writeTail()
  local fname = sites_out
  local outfile = io.open(fname,"a")
  outfile:write(string.format("</REPLACE_OPTIONS>\n"))
  io.close(outfile)
end

function fixNavaids()
  local k,v
  for k,v in ipairs(template) do
    v = string.gsub(v,'Pickup location: {navaid_loc_desc}. Helipad coordinates: {navaid_lat}, {navaid_lon}.','')
    v = string.gsub(v,'Location: {navaid_loc_desc}. Helipad coordinates: {navaid_lat}, {navaid_lon}.','')
    v = string.gsub(v,'Location: {navaid_loc_desc}. Target coordinates: {navaid_lat}, {navaid_lon}.','')
    v = string.gsub(v,'Location: {navaid_loc_desc}. Landing area coordinates: {navaid_lat}, {navaid_lon}.','')
    template[k] = v
  end
end

function fixDistance()
  local k,v
  for k,v in ipairs(template) do
    print("k = "..k.." v = "..v.."\n")
    v = string.gsub(v,'nm_between=2%-30','nm_between=2%-10')
    v = string.gsub(v,'nm_between=5%-30','nm_between=5%-10')
    v = string.gsub(v,'nm_between=5%-60','nm_between=5%-20')
    template[k] = v
  end
end

function fixWaiting()
  local k,v
  for k,v in ipairs(template) do
    v = string.gsub(v,'eval_success_for_n_sec="60"','eval_success_for_n_sec="10"')
    v = string.gsub(v,'eval_success_for_n_sec="120"','eval_success_for_n_sec="20"')
    v = string.gsub(v,'eval_success_for_n_sec="180"','eval_success_for_n_sec="30"')
    template[k] = v
  end
end

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function applyReplace(name)
  local t,k,v

  local xw
  local xh = xhome[name]
  local xb = xbase[name]
  local xt = xtitle[name]
  local xp = xplane[name]
  local xo = xoverpass[name]
  local xr1,xr2,xr3,xr4
  
  local xi = "HMG_"..xb..".png"
  local xa = acf_txt[xp]
  local xc = "\n"

  if ( file_exists(hmg_dir .. "/includes/webosm_filters_"..xbase[name]..".xml") ) then
     xw = xb
  else
     xw = "default"      -- use default webosm_filter if no file exists
  end

  -- build "my content" table
  local myContent = {}
  for w in string.gmatch(xcontent[name], "[%w_]+") do
    myContent[w] = 1
  end
  
  if ( xrange[name] == "near" ) then
    xr1="2-15"
    xr2="5-15"
    xr3="5-20"
    xr4="10-20"
  elseif ( xrange[name] == "far" ) then
    xr1="2-40"
    xr2="5-40"
    xr3="5-80"
    xr4="10-50"
  else
    xr1="2-30"
    xr2="5-30"
    xr3="5-60"
    xr4="10-30"
  end

  for k,v in ipairs(template) do
    t = string.gsub(v,"%%NAME%%",name)
    t = string.gsub(t,"%%TITLE%%",xt)
    t = string.gsub(t,"%%BASE%%",xb)
    t = string.gsub(t,"%%HOME%%",xh)
    t = string.gsub(t,"%%PLANE%%",xp)
    t = string.gsub(t,"%%PLANE_DESC%%",xa)
    t = string.gsub(t,"%%OVERPASS%%",xo)
    t = string.gsub(t,"%%IMAGE%%",xi)
    t = string.gsub(t,"%%INFO%%","Homebase: "..xh.."\nAircraft: "..xa)
    t = string.gsub(t,"%%WEBOSM%%",xw)
    t = string.gsub(t,"%%RANGE1%%",xr1)
    t = string.gsub(t,"%%RANGE2%%",xr2)
    t = string.gsub(t,"%%RANGE3%%",xr3)
    t = string.gsub(t,"%%RANGE4%%",xr4)

    for idx, val in pairs(contents) do
      if ( myContent[idx] == 1 ) then
        t = string.gsub(t,"%%"..idx.."%%",val)
      else
        t = string.gsub(t,"%%"..idx.."%%","empty")  -- add empty.xml for anything else
      end
    end 
    template[k] = t
  end
  
end

function readConfig()
  local fname = sites_cfg
  local infile = io.open(fname,"r")
  local name


  if ( infile ~= nil ) then

    local fileContent = {}
    for line in infile:lines() do
        table.insert (fileContent, line)
    end
    io.close(infile)

    for index, value in ipairs(fileContent) do
      if ( not value:match('^#') ) then         -- skip comment lines

        if ( string.find(value,"name ",1) ) then
          name = string.sub(value,6) 
          xcontent[name] = ""
		  xrange[name] = ""
  
        elseif ( string.find(value,"title ",1) ) then
          xtitle[name] = string.sub(value,7) 
  
        elseif ( string.find(value,"plane ",1) ) then
          xplane[name] = string.sub(value,7)
  
        elseif ( string.find(value,"base ",1) ) then
          xbase[name] = string.sub(value,6)
   
        elseif ( string.find(value,"home ",1) ) then
          xhome[name] = string.sub(value,6)
   
        elseif ( string.find(value,"overpass ",1) ) then
          xoverpass[name] = string.sub(value,10)
   
        elseif ( string.find(value,"content ",1) ) then
          xcontent[name] = string.sub(value,9) 

        elseif ( string.find(value,"range ",1) ) then
          xrange[name] = string.sub(value,7) 

        end

      end
    end
  else
    print("HMG-setup: cannot open sites.cfg")
  end
end

--
-- concat all 4 files together and make the template.xml
---
function makeTemplate()
  template = {}
  readFile(setup_dir .. "/00_header")
  readFile(setup_dir .. "/01_locations")
  readFile(setup_dir .. "/02_missions")
  readFile(setup_dir .. "/03_replace")

  -- optional fixes
  if ( applyWaitingFix ) then
    fixWaiting()
  end
  if ( applyNavaidsFix ) then
    fixNavaids()
  end
  if ( applyDistanceFix ) then
    fixDistance()
  end
  writeFile(template_xml)
end

--
-- main function
--
function genTemplate()
  local k,v
  local t = {}

  initArrays()

  readConfig()			-- read sites.cfg

  printData()			-- show what we found

  genLocations()		-- generate sites overview

  os.remove(sites_out)	-- delete old sites.out

  writeHead()			-- start a new sites.out

  for k,v in pairs(xtitle) do   -- sort unique mission IDs
    table.insert(t,k)
  end
  table.sort(t)

  for k,v in ipairs(t) do

    readSitesIn()			-- do for each mission config

    applyReplace(v)

    writeSitesOut()
  end

  writeTail()			-- close the sites.out

  makeTemplate()		-- now concat them all together

  XPLMSpeakString("H M G template generated")
end


add_macro("gen HMG template","genTemplate()" )
--create_command("FlyWithLua/genHMGtemplate", "gen HMG template","genTemplate()", "", "")
--set_button_assignment(6,"FlyWithLua/genHMGtemplate")


