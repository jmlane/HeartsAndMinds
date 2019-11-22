
/* ----------------------------------------------------------------------------
Function: btc_fnc_int_add_actions

Description:
    Fill me when you edit me !

Parameters:

Returns:

Examples:
    (begin example)
        _result = [] call btc_fnc_int_add_actions;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */


//Database
private _action = ["Database", localize "STR_BTC_HAM_ACTION_DATA_MAIN", "\A3\ui_f\data\igui\cfg\simpleTasks\letters\D_ca.paa", {}, {serverCommandAvailable "#logout" || !isMultiplayer}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["request_save", localize "str_3den_display3den_menubar_missionsave_text", "\A3\ui_f\data\igui\cfg\simpleTasks\types\download_ca.paa", {call btc_fnc_db_request_save;}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "Database"], _action] call ace_interact_menu_fnc_addActionToObject;
_action = ["request_delete", localize "str_a3_cfgvehicles_modulerespawnvehicle_f_arguments_wreck_values_delete_0", "\A3\ui_f\data\igui\cfg\simpleTasks\types\exit_ca.paa", {call btc_fnc_db_request_delete;}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "Database"], _action] call ace_interact_menu_fnc_addActionToObject;

//Intel
_action = ["Search_intel", localize "STR_A3_Showcase_Marksman_BIS_tskIntel_title", "\A3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa", {(_this select 0) spawn btc_fnc_info_search_for_intel;}, {!Alive (_this select 0)}] call ace_interact_menu_fnc_createAction;
{[_x, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToClass;} forEach (btc_type_units + btc_type_divers);
_action = ["Interrogate_intel", localize "STR_BTC_HAM_ACTION_INTEL_INTERROGATE", "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa", {[(_this select 0),true] spawn btc_fnc_info_ask;}, {Alive (_this select 0) && {[_this select 0] call ace_common_fnc_isAwake} && captive (_this select 0)}] call ace_interact_menu_fnc_createAction;
{[_x, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToClass;} forEach (btc_type_units + btc_type_divers);

//Log point
_action = ["Logistic", localize "STR_BTC_HAM_ACTION_LOC_MAIN", "\A3\ui_f\data\igui\cfg\simpleTasks\letters\L_ca.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
[btc_create_object, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
_action = ["Require_object", localize "STR_BTC_HAM_ACTION_LOGPOINT_REQOBJ", "\A3\ui_f\data\igui\cfg\simpleTasks\types\rearm_ca.paa", {[btc_create_object_point] spawn btc_fnc_log_create}, {true}, {}, [], [0, 0, 0.4], 5] call ace_interact_menu_fnc_createAction;
[btc_create_object, 0, ["ACE_MainActions", "Logistic"], _action] call ace_interact_menu_fnc_addActionToObject;
_action = ["Repair_wreck", localize "STR_BTC_HAM_ACTION_LOGPOINT_REPWRECK", "\A3\ui_f\data\igui\cfg\simpleTasks\types\repair_ca.paa", {[btc_create_object_point] spawn btc_fnc_log_repair_wreck}, {true}, {}, [], [0, 0, 0], 5] call ace_interact_menu_fnc_createAction;
[btc_create_object, 0, ["ACE_MainActions", "Logistic"], _action] call ace_interact_menu_fnc_addActionToObject;
_action = ["Require_veh", localize "STR_BTC_HAM_ACTION_LOGPOINT_REQVEH", "\A3\ui_f\data\map\vehicleicons\iconCar_ca.paa", {[btc_create_object_point] spawn btc_fnc_arsenal_garage}, {(serverCommandAvailable "#logout" || !isMultiplayer) and btc_p_garage}, {}, [], [0, 0, 0], 5] call ace_interact_menu_fnc_createAction;
[btc_create_object, 0, ["ACE_MainActions", "Logistic"], _action] call ace_interact_menu_fnc_addActionToObject;
_action = ["Tool", localize "str_3den_display3den_menubar_tools_text", "\A3\ui_f\data\igui\cfg\simpleTasks\letters\T_ca.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
[btc_create_object, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
_action = ["Copy", localize "STR_BTC_HAM_ACTION_COPYPASTE_COPY", "\A3\ui_f\data\igui\cfg\simpleTasks\types\download_ca.paa", {[btc_create_object_point] spawn btc_fnc_log_copy}, {true}, {}, [], [0, 0, 0.4], 5] call ace_interact_menu_fnc_createAction;
[btc_create_object, 0, ["ACE_MainActions", "Tool"], _action] call ace_interact_menu_fnc_addActionToObject;
_action = ["Paste", localize "STR_BTC_HAM_ACTION_COPYPASTE_PASTE", "\A3\ui_f\data\igui\cfg\simpleTasks\types\upload_ca.paa", {[btc_copy_container, btc_create_object_point] call btc_fnc_log_paste}, {!isNil "btc_copy_container"}, {}, [], [0, 0, 0.4], 5] call ace_interact_menu_fnc_createAction;
[btc_create_object, 0, ["ACE_MainActions", "Tool"], _action] call ace_interact_menu_fnc_addActionToObject;

//Logistic
_action = ["Logistic", localize "STR_BTC_HAM_ACTION_LOC_MAIN", "\A3\ui_f\data\igui\cfg\simpleTasks\letters\L_ca.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
{[_x, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToClass;} forEach btc_log_def_loadable;

//FOB
_action = ["Mount_FOB", localize "STR_BTC_HAM_ACTION_FOB_MOUNT", "\A3\Ui_f\data\Map\Markers\NATO\b_hq.paa", {(_this select 0) spawn btc_fnc_fob_create}, {true}] call ace_interact_menu_fnc_createAction;
[btc_fob_mat, 0, ["ACE_MainActions", "Logistic"], _action] call ace_interact_menu_fnc_addActionToClass;
_action = ["Dismantle_FOB", localize "STR_BTC_HAM_ACTION_FOB_DISMANTLE", "", {(_this select 0) spawn btc_fnc_fob_dismantle}, {true}, {}, [], [0, 0, -2], 5] call ace_interact_menu_fnc_createAction;
[btc_fob_flag, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToClass;
_action = ["Place", localize "STR_3DEN_Display3DEN_ControlsHint_Place", "\A3\ui_f\data\map\markers\military\end_CA.paa", {(_this select 0) spawn btc_fnc_log_place}, {!btc_log_placing}] call ace_interact_menu_fnc_createAction;
{[_x, 0, ["ACE_MainActions", "Logistic"], _action] call ace_interact_menu_fnc_addActionToClass;} forEach btc_log_def_placeable;

//Orders
_action = ["Civil_Orders", localize "STR_BTC_HAM_ACTION_ORDERS_MAIN", "\A3\ui_f\data\igui\cfg\simpleTasks\types\meet_ca.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["Civil_Stop", localize "STR_BTC_HAM_ACTION_ORDERS_STOP", "\A3\ui_f\data\igui\cfg\simpleTasks\types\talk3_ca.paa", {[1] call btc_fnc_int_orders;}, {vehicle player isEqualTo player}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "Civil_Orders"], _action] call ace_interact_menu_fnc_addActionToObject;
_action = ["Civil_Get_down", localize "STR_BTC_HAM_ACTION_ORDERS_GETDOWN", "\A3\ui_f\data\igui\cfg\simpleTasks\types\talk2_ca.paa", {[2] call btc_fnc_int_orders;}, {vehicle player isEqualTo player}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "Civil_Orders"], _action] call ace_interact_menu_fnc_addActionToObject;
_action = ["Civil_Go_away", localize "STR_BTC_HAM_ACTION_ORDERS_GOAWAY", "\A3\ui_f\data\igui\cfg\simpleTasks\types\talk1_ca.paa", {[3] call btc_fnc_int_orders;}, {vehicle player isEqualTo player}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "Civil_Orders"], _action] call ace_interact_menu_fnc_addActionToObject;

{ //Actions attachted to AI
    _action = ["Civil_Orders", localize "STR_BTC_HAM_ACTION_ORDERS_MAIN", "\A3\ui_f\data\igui\cfg\simpleTasks\types\meet_ca.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
    [_x, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToClass;
    _action = ["Civil_taxi", localize "STR_BTC_HAM_ACTION_ORDERS_TAXI", "\A3\ui_f\data\igui\cfg\simpleTasks\types\talk4_ca.paa", {[4, (_this select 0)] spawn btc_fnc_int_orders;}, {(Alive (_this select 0)) && !((vehicle (_this select 0)) isEqualTo (_this select 0))}] call ace_interact_menu_fnc_createAction;
    [_x, 0, ["ACE_MainActions", "Civil_Orders"], _action] call ace_interact_menu_fnc_addActionToClass;
    _action = ["Civil_Stop", localize "STR_BTC_HAM_ACTION_ORDERS_STOP", "\A3\ui_f\data\igui\cfg\simpleTasks\types\talk3_ca.paa", {[1, (_this select 0)] call btc_fnc_int_orders;}, {Alive (_this select 0)}] call ace_interact_menu_fnc_createAction;
    [_x, 0, ["ACE_MainActions", "Civil_Orders"], _action] call ace_interact_menu_fnc_addActionToClass;
    _action = ["Civil_Get_down", localize "STR_BTC_HAM_ACTION_ORDERS_GETDOWN", "\A3\ui_f\data\igui\cfg\simpleTasks\types\talk2_ca.paa", {[2, (_this select 0)] call btc_fnc_int_orders;}, {Alive (_this select 0)}] call ace_interact_menu_fnc_createAction;
    [_x, 0, ["ACE_MainActions", "Civil_Orders"], _action] call ace_interact_menu_fnc_addActionToClass;
    _action = ["Civil_Go_away", localize "STR_BTC_HAM_ACTION_ORDERS_GOAWAY", "\A3\ui_f\data\igui\cfg\simpleTasks\types\talk1_ca.paa", {[3, (_this select 0)] call btc_fnc_int_orders;}, {Alive (_this select 0)}] call ace_interact_menu_fnc_createAction;
    [_x, 0, ["ACE_MainActions", "Civil_Orders"], _action] call ace_interact_menu_fnc_addActionToClass;
    _action = ["Ask_Info", localize "STR_BTC_HAM_ACTION_ORDERS_ASKINFO", "\A3\ui_f\data\igui\cfg\simpleTasks\types\talk_ca.paa", {[(_this select 0),false] spawn btc_fnc_info_ask;}, {Alive (_this select 0) && {[_this select 0] call ace_common_fnc_isAwake} && {side (_this select 0) isEqualTo civilian}}] call ace_interact_menu_fnc_createAction;
    [_x, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToClass;
    _action = ["Ask_Reputation", localize "STR_BTC_HAM_ACTION_ORDERS_ASKREP", "\A3\ui_f\data\igui\cfg\simpleTasks\types\talk_ca.paa", {[_this select 0] spawn btc_fnc_info_ask_reputation;}, {Alive (_this select 0) && {[_this select 0] call ace_common_fnc_isAwake} && {side (_this select 0) isEqualTo civilian}}] call ace_interact_menu_fnc_createAction;
    [_x, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToClass;

    //remove ace3 "get down" order
    [_x, 0, ["ACE_MainActions", "ACE_GetDown"]] call ace_interact_menu_fnc_removeActionFromClass;
    //remove ace3 "go away" order
    [_x, 0, ["ACE_MainActions", "ACE_SendAway"]] call ace_interact_menu_fnc_removeActionFromClass;
} forEach btc_civ_type_units;

//Side missions
_action = ["side_mission", localize "STR_BTC_HAM_ACTION_SIDEMISSION_MAIN", "\A3\ui_f\data\igui\cfg\simpleTasks\types\whiteboard_ca.paa", {}, {player getVariable ["side_mission", false]}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["side_mission_abort", localize "STR_BTC_HAM_ACTION_SIDEMISSION_ABORT", "\A3\ui_f\data\igui\cfg\simpleTasks\types\exit_ca.paa", {[] call btc_fnc_side_abort}, {player getVariable ["side_mission", false] && {btc_side_assigned}}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "side_mission"], _action] call ace_interact_menu_fnc_addActionToObject;
_action = ["side_mission_request", localize "STR_BTC_HAM_ACTION_SIDEMISSION_REQ", "\A3\ui_f\data\igui\cfg\simpleTasks\types\default_ca.paa", {[] spawn btc_fnc_side_request}, {player getVariable ["side_mission", false] && {!btc_side_assigned}}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "side_mission"], _action] call ace_interact_menu_fnc_addActionToObject;

//Debug
if (btc_debug) then {
    _action = ["Debug_graph", "Disable debug graph", "\a3\Ui_f\data\GUI\Rsc\RscDisplayMissionEditor\iconCamera_ca.paa", {btc_debug_graph = !btc_debug_graph}, {btc_debug_graph}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
    _action = ["Debug_graph", "Enable debug graph", "\a3\Ui_f\data\GUI\Rsc\RscDisplayMissionEditor\iconCamera_ca.paa", {btc_debug_graph = true; 73001 cutRsc ["TER_fpscounter", "PLAIN"];}, {!btc_debug_graph}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
};

//Re-deploy
_action = ["fob_redeploy", localize "STR_BTC_HAM_ACTION_REDEPLOY_MAIN", "\A3\ui_f\data\igui\cfg\simpleTasks\types\run_ca.paa", {[] spawn btc_fnc_fob_redeploy}, {btc_p_redeploy}, {}, [], [0.4, 0, 0.4], 5] call ace_interact_menu_fnc_createAction;
[btc_gear_object, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

//Arsenal
//BIS
if (btc_p_arsenal_Type < 3) then {
    btc_gear_object addAction [localize "STR_BTC_HAM_ACTION_ARSENAL_OPEN_BIS", "['Open', [true, _this select 0]] call bis_fnc_arsenal;"];
};
//ACE
if (btc_p_arsenal_Type > 0) then {
    [btc_gear_object, true, false] call ace_arsenal_fnc_initBox;
    if (btc_p_arsenal_Type in [2, 4]) then {
        btc_gear_object addAction [localize "STR_BTC_HAM_ACTION_ARSENAL_OPEN_ACE", "[btc_gear_object, player] call ace_arsenal_fnc_openBox;"];
    };
};
if (true) then {[btc_gear_object, btc_p_arsenal_Type, 3, btc_custom_arsenal] call btc_fnc_arsenal_data;};
