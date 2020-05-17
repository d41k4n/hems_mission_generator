' v1.0

' Functions 

def func_check_up()
  'print "[Script] Winch up: Testing rope length"; 'debug
  hoist_ground_contact = fn_get_dref_value("hoist_ground_contact");
  rope_length = round(fn_get_dref_value("rope_length"));
  agl = fn_get_dref_value("agl");
  hoist_is_up = fn_get_dref_value ("hoist_is_up");
  if (mxError <> "") then
    print "Error: ", mxError;
  elseif hoist_is_up = 1 then
    fn_send_text_message("Stop winch!", "winch_up_stop", true);
    fn_set_trigger_property("trig_1_onboard_patient", "script_conditions_met_b", "true");
  elseif rope_length = 10 then 
    fn_send_text_message ("10 meters to recovery", "winch_up_check_10", true);
  elseif rope_length = 5 then 
    fn_send_text_message ("5", "winch_up_check_5", true);
  elseif rope_length = 4 then 
    fn_send_text_message ("4", "winch_up_check_4", true);
  elseif rope_length = 3 then 
    fn_send_text_message ("3", "winch_up_check_3", true);
  elseif rope_length = 2 then 
    fn_send_text_message ("2", "winch_up_check_2", true);
  elseif rope_length = 1 then 
    fn_send_text_message ("1", "winch_up_check_1", true);
  endif
enddef

def func_check_down()
  'print "[Script] Winch down check"; 'debug
  hoist_ground_contact = fn_get_dref_value("hoist_ground_contact");
  rope_length = fn_get_dref_value("rope_length");
  agl = fn_get_dref_value("agl");
  diff = round (agl - rope_length - 1.3);
  'print "[Script] rope length: ", rope_length;
  if (mxError <> "") then 
    print "Error: ", mxError;
  elseif hoist_ground_contact = 1 then 
    fn_send_text_message ("Stop winch!", "winch_down_check", true);
    fn_set_trigger_property("trig_1_stop_winch", "script_conditions_met_b", "true");
  elseif diff = 10 then 
	fn_send_text_message ("10 meters to ground contact", "winch_down_check_10", true);
  elseif diff = 5 then 
	fn_send_text_message ("5", "winch_down_check_5", true);
  elseif diff = 4 then 
	fn_send_text_message ("4", "winch_down_check_4", true);
  elseif diff = 3 then 
	fn_send_text_message ("3", "winch_down_check_3", true);
  elseif diff = 2 then 
	fn_send_text_message ("2", "winch_down_check_2", true);
  elseif diff = 1 then 
	fn_send_text_message ("1", "winch_down_check_1", true);
  endif
enddef

def func_rotor_stopped_1()
  'print "[Script] Rotor stopped check"; 'debug
  main_rotor_speed = fn_get_dref_value("main_rotor_speed");
  'print "[Script] main rotor speed: ", main_rotor_speed;
  if (mxError <> "") then 
    print "Error: ", mxError;
  elseif main_rotor_speed < 0.5 then 
    fn_set_trigger_property("trig_1_crew_off", "script_conditions_met_b", "true");
  'elseif main_rotor_speed > 0.5 then 
  '  fn_send_text_message ("Shut down engines!", "main_rotor_stopped_check", true);
  endif
enddef

def func_rotor_stopped_2()
  'print "[Script] Rotor stopped check"; 'debug
  main_rotor_speed = fn_get_dref_value("main_rotor_speed");
  'print "[Script] main rotor speed: ", main_rotor_speed;
  if (mxError <> "") then 
    print "Error: ", mxError;
  elseif main_rotor_speed < 0.5 then 
    fn_set_trigger_property("trig_2_crew_off", "script_conditions_met_b", "true");
  'elseif main_rotor_speed > 0.5 then 
  '  fn_send_text_message ("Shut down engines!", "main_rotor_stopped_check", true);
  endif
enddef


' Main branching code
if (mxFuncCall = "check_down") then
  call func_check_down();
elseif (mxFuncCall = "check_up") then
  call func_check_up();
elseif (mxFuncCall = "rotor_stopped_1") then
  call func_rotor_stopped_1();
elseif (mxFuncCall = "rotor_stopped_2") then
  call func_rotor_stopped_2();
endif

