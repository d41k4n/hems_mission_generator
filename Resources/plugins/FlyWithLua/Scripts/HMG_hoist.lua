-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Script: Hoist
-- Version: 0.3.2
-- Date: 20-11-2021
-- Author: Henry Favretto
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Description:
-- Display and control hoist parameters.
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- require("graphics")

define_shared_DataRef("hoist/ground_contact", "Int")
define_shared_DataRef("hoist/is_up", "Int")
define_shared_DataRef("hoist/rope_length", "Float")

dataref("dt", "sim/time/framerate_period", "readonly")
dataref("agl", "sim/flightmodel/position/y_agl", "readonly")
dataref("ground_contact", "hoist/ground_contact", "writable")
dataref("is_up", "hoist/is_up", "writable")
dataref("rope_length", "hoist/rope_length", "writable")
dataref("jett_x", "sim/aircraft/overflow/jett_X", "readonly")
dataref("jett_y", "sim/aircraft/overflow/jett_Y", "readonly")
dataref("jett_z", "sim/aircraft/overflow/jett_Z", "readonly")

if not SUPPORTS_FLOATING_WINDOWS then
    -- to make sure the script doesn't stop old FlyWithLua versions
    logMsg("imgui not supported by your FlyWithLua version")
    return
end


ground_contact = 0
is_up = 1

local init_completed = false
local is_rotorsim = false
local tween = require 'tween'

-- Port-side winch positions for H145 model by VLC-Entwicklung
local winch_position_retracted = {-0.920000, 0.617768, -1.588976}
local winch_position_extended = {-1.738400, 0.617768, -1.283000}

-- local cw_hook = {0.9, 0.9, 0.9}
-- local cw_cargo = {0.6, 0.6, 0.6}

hold_down = false
hold_up = false
winch_stopped = true

local rope_speed = 0
local rope_speed_max = 0.5
local rope_speed_min = 0.3
local rope_accel = 0.001
local rope_near = 2
local rope_length_init = 0.319
local winch_duration = 5
-- local cargo_size_connected = {1, 1, 1.8}
-- local cargo_size_released = {0.2, 0.2, 0.2}
local cargo_mass_patient = 90
local cargo_mass_empty = 0.1 -- Should not be zero as otherwise it will disable physics
-- local cargo_height_crew = 1.1
-- local cargo_height_empty = 0.35

local winch_tween = tween.new(winch_duration, winch_position_extended, winch_position_retracted, tween.easing.quad)

function specific_datarefs_exist()
	local ready = false
	if 	XPLMFindCommand("HSL/Load_Connect") ~= nil and
		XPLMFindDataRef("HSL/Rope/RopeLengthNormal")   ~= nil and
		XPLMFindDataRef("HSL/Winch/VectorWinchPosition") ~= nil and
		XPLMFindDataRef("HSL/Cargo/Mass") ~= nil and
		XPLMFindDataRef("HSL/Cargo/Height") ~= nil and
		XPLMFindDataRef("HSL/Cargo/Size") ~= nil and
		XPLMFindDataRef("HSL/Cargo/CWFront") ~= nil then
		ready = true
	end
	return ready
end

function monitor()
	if not init_completed then
		if specific_datarefs_exist() then
			dataref("RopeLength", "HSL/Rope/RopeLengthNormal", "writable")
			dataref("cargo_mass", "HSL/Cargo/Mass", "writable")
			dataref("hook_connected", "HSL/Hook/Connected", "readonly")
			dataref("cargo_connected", "HSL/Cargo/Connected", "readonly")
			dataref("cargo_height", "HSL/Cargo/Height" , "writable")
			dataref("rope_force_scalar", "HSL/Calculated/RopeForceScalar", "readonly")
			winch_position_ref = XPLMFindDataRef("HSL/Winch/VectorWinchPosition")
			winch_pos = XPLMGetDatavf(winch_position_ref, 0, 3)
			-- cargo_size_ref = XPLMFindDataRef("HSL/Cargo/Size")
			-- cw_cargo_ref  = XPLMFindDataRef("HSL/Cargo/CWFront")
			if XPLMFindDataRef("rotorsim/ec135/hoist_angle") ~= nil then
				is_rotorsim = true
				dataref("winch_angle", "rotorsim/ec135/hoist_angle", "readonly")
			end
			init_completed = true
		-- else
			-- draw_string_Helvetica_18(50, 500, "Hoist: Waiting on datarefs to be created!")
		end
	else
		rope_length = RopeLength;
		if RopeLength > agl + 1.3 then
			-- print("Hoist: Ground contact detected")
			ground_contact = 1
		else
			-- print("Hoist: No ground contact")
			ground_contact = 0
			if RopeLength < 0.5 then
				is_up = 1
			else
				is_up = 0
			end
		end
	end
end

function round(number, precision)
   local fmtStr = string.format('%%0.%sf',precision)
   number = string.format(fmtStr,number)
   return number
end

function hoist_op()
	if init_completed then
		if hold_down then
			RopeLengthDisplay = RopeLength
			if rope_speed < rope_speed_max then
				rope_speed = rope_speed + rope_accel
			end
			RopeLength = RopeLengthDisplay + (dt * rope_speed)
		elseif hold_up and RopeLength > 0.32 then
			RopeLengthDisplay = RopeLength
			if RopeLength<rope_near and rope_speed > rope_speed_min then
				rope_speed = rope_speed - rope_accel
			elseif rope_speed < rope_speed_max then
				rope_speed = rope_speed + rope_accel
			end
			RopeLength = RopeLengthDisplay - (dt * rope_speed)
		elseif rope_speed > 0 then
			rope_speed = 0
		end
		if not is_rotorsim then
			if not winch_stopped then
				-- print("Hoist: Moving...")
				winch_stopped = winch_tween:update(dt)
				winch_pos_current = XPLMGetDatavf(winch_position_ref, 0, 3)
				winch_pos_current[0] = winch_pos[0]
				winch_pos_current[1] = winch_pos[1]
				winch_pos_current[2] = winch_pos[2]
				XPLMSetDatavf(winch_position_ref, winch_pos_current, 0, 3)
			end
		else
			winch_pos_current = XPLMGetDatavf(winch_position_ref, 0, 3)
			winch_pos_current[0] = jett_x
			winch_pos_current[1] = jett_y
			winch_pos_current[2] = jett_z
			XPLMSetDatavf(winch_position_ref, winch_pos_current, 0, 3)
		end
	end
end


function hoist_on_build(hoist_wnd, x, y)
	monitor()
	imgui.TextUnformatted("Hoist arm locked: ")
	imgui.SameLine()
	if winch_stopped then 
		imgui.TextUnformatted("true")
	else
		imgui.TextUnformatted("false")
	end
	imgui.TextUnformatted("Rope length (m):   ")
	imgui.SameLine()
	imgui.TextUnformatted(round(RopeLength,2))
	imgui.TextUnformatted("Winch speed (m/s): ")
	imgui.SameLine()
	imgui.TextUnformatted(rope_speed)
	imgui.TextUnformatted("Above Ground (m):  ")
	imgui.SameLine()
	imgui.TextUnformatted(round(agl,2))
	winch_position_current = XPLMGetDatavf(winch_position_ref, 0, 3)
	imgui.TextUnformatted("Winch Position (xyz):  ")
	imgui.SameLine()
	imgui.TextUnformatted("[" .. round(winch_position_current[0],3) .. " ")
	imgui.SameLine()
	imgui.TextUnformatted(round(winch_position_current[1],3) .. " ")
	imgui.SameLine()
	imgui.TextUnformatted(round(winch_position_current[2],3) .. "]")
	imgui.TextUnformatted("Rope force (Nm):  ")
	imgui.SameLine()
	imgui.TextUnformatted(round(rope_force_scalar,2))
end

hoist_wnd = nil

function hoist_show_wnd()
    hoist_wnd = float_wnd_create(330, 120, 1, true)
    float_wnd_set_title(hoist_wnd, "Hoist v0.3.2")
    float_wnd_set_imgui_builder(hoist_wnd, "hoist_on_build")
end

function hoist_hide_wnd()
    if hoist_wnd then
        float_wnd_destroy(hoist_wnd)
    end
end

hoist_show_only_once = 0
hoist_hide_only_once = 0

function toggle_hoist_window()
	if init_completed then
		hoist_show_window = not hoist_show_window
		if hoist_show_window then	
			if hoist_show_only_once == 0 then
				hoist_show_wnd()
				hoist_show_only_once = 1
				hoist_hide_only_once = 0
			end
		else
			if hoist_hide_only_once == 0 then
				hoist_hide_wnd()
				hoist_hide_only_once = 1
				hoist_show_only_once = 0
			end
		end
	end
end

function retract_winch()
	if winch_stopped then
		print("Hoist: Retracting winch")
		winch_pos = XPLMGetDatavf(winch_position_ref, 0, 3)
		winch_pos_target = XPLMGetDatavf(winch_position_ref, 0, 3)
		winch_pos_target[0] = winch_position_retracted[1]
		winch_pos_target[1] = winch_position_retracted[2]
		winch_pos_target[2] = winch_position_retracted[3]
		print(winch_pos[0] .. " -> " .. winch_pos_target[0])
		print(winch_pos[1] .. " -> " .. winch_pos_target[1])
		print(winch_pos[2] .. " -> " .. winch_pos_target[2])
		winch_tween = tween.new(winch_duration, winch_pos, winch_pos_target, tween.easing.inOutQuad)
		winch_stopped = false
		set_array("sim/cockpit2/switches/custom_slider_on",5,0)
	end
end

function extend_winch()
	if winch_stopped then
		print("Hoist: Extending winch")
		winch_pos = XPLMGetDatavf(winch_position_ref, 0, 3)
		winch_pos_target = XPLMGetDatavf(winch_position_ref, 0, 3)
		winch_pos_target[0] = winch_position_extended[1]
		winch_pos_target[1] = winch_position_extended[2]
		winch_pos_target[2] = winch_position_extended[3]
		print(winch_pos[0] .. " -> " .. winch_pos_target[0])
		print(winch_pos[1] .. " -> " .. winch_pos_target[1])
		print(winch_pos[2] .. " -> " .. winch_pos_target[2])
		winch_tween = tween.new(winch_duration, winch_pos, winch_pos_target, tween.easing.inOutQuad)
		winch_stopped = false
		set_array("sim/cockpit2/switches/custom_slider_on",5,1)
	end
end

function connect_winch()
	print("Hoist: Connecting winch")
    cargo_mass = 0 -- Set to zero as crew mass is already modeled as the hook mass in HSL.ini
	--cargo_height = cargo_height_crew
	command_once("HSL/Sling_Enable")
	-- Set cargo size
	-- cargo_size = XPLMGetDatavf(cargo_size_ref, 0, 3)
	--local cargo_size_target = XPLMGetDatavf(cargo_size_ref, 0, 3)
	--cargo_size_target[0] = cargo_size_connected[1]
	--cargo_size_target[1] = cargo_size_connected[2]
	--cargo_size_target[2] = cargo_size_connected[3]
	--XPLMSetDatavf(cargo_size_ref, cargo_size_target, 0, 3)
	-- Set cargo CW
	--local cargo_cw_target = XPLMGetDatavf(cw_cargo_ref, 0, 3)
	--cargo_cw_target[0] = cw_cargo[1]
	--cargo_cw_target[1] = cw_cargo[2]
	--cargo_cw_target[2] = cw_cargo[3]
	--XPLMSetDatavf(cw_cargo_ref, cargo_cw_target, 0, 3)

end

function disable_winch()
	print("Hoist: Disabling winch")
	--cargo_mass = cargo_mass_empty
	--cargo_height = cargo_height_empty
	command_once("HSL/Sling_Disable")
	-- cargo_size = XPLMGetDatavf(cargo_size_ref, 0, 3)
	--local cargo_size_target = XPLMGetDatavf(cargo_size_ref, 0, 3)
	--cargo_size_target[0] = cargo_size_released[1]
	--cargo_size_target[1] = cargo_size_released[2]
	--cargo_size_target[2] = cargo_size_released[3]
	--XPLMSetDatavf(cargo_size_ref, cargo_size_target, 0, 3)
	-- Set hook CW
	--local cargo_cw_target = XPLMGetDatavf(cw_cargo_ref, 0, 3)
	--cargo_cw_target[0] = cw_hook[1]
	--cargo_cw_target[1] = cw_hook[2]
	--cargo_cw_target[2] = cw_hook[3]
	--XPLMSetDatavf(cw_cargo_ref, cargo_cw_target, 0, 3)
end

function add_patient()
	print("Hoist: Adding patient to winch cargo")
	cargo_mass = cargo_mass_patient
	command_once("HSL/Load_Connect")
end

function remove_patient()
	print("Hoist: Removing patient from winch cargo")
	cargo_mass = cargo_mass_empty
end

function reset_winch()
	print("Hoist: Resetting winch")
	cargo_mass = cargo_mass_empty
    RopeLength = rope_length_init
end

do_sometimes("monitor()")
do_every_frame ("hoist_op()")

-- make a switchable menu entry , default is on
add_macro("Hoist Window: open/close", "hoist_show_wnd()", "hoist_hide_wnd()", "deactivate")
create_command("FlyWithLua/hoist/show_toggle", "Open/close hoist window", "toggle_hoist_window()", "", "")
create_command("FlyWithLua/hoist/winch_reset", "Reset winch", "reset_winch()", "", "")
create_command("FlyWithLua/hoist/winch_down", "Lower winch", "", "hold_down = true", "hold_down = false")
create_command("FlyWithLua/hoist/winch_up", "Raise winch", "", "hold_up = true", "hold_up = false")
create_command("FlyWithLua/hoist/winch_retract", "Retract winch", "retract_winch()", "", "")
create_command("FlyWithLua/hoist/winch_extend", "Extend winch", "extend_winch()", "", "")
create_command("FlyWithLua/hoist/winch_connect", "Connect winch", "connect_winch()", "", "")
create_command("FlyWithLua/hoist/winch_disable", "Disable winch", "disable_winch()", "", "")
create_command("FlyWithLua/hoist/winch_add_patient", "Add patient to winch cargo", "add_patient()", "", "")
create_command("FlyWithLua/hoist/winch_remove_patient", "Remove patient from winch cargo", "remove_patient()", "", "")
