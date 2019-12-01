/////////////////////SERVER\\\\\\\\\\\\\\\\\\\\\
if (isServer) then {
    //CACHE
    btc_fnc_cache_find_pos = compile preprocessFileLineNumbers "core\fnc\cache\find_pos.sqf";
    btc_fnc_cache_spawn = compile preprocessFileLineNumbers "core\fnc\cache\spawn.sqf";
    btc_fnc_cache_create = compile preprocessFileLineNumbers "core\fnc\cache\create.sqf";
    btc_fnc_cache_create_attachto = compile preprocessFileLineNumbers "core\fnc\cache\create_attachto.sqf";

    //COMMON
    btc_fnc_check_los = compile preprocessFileLineNumbers "core\fnc\common\check_los.sqf";
    btc_fnc_clean_up = compile preprocessFileLineNumbers "core\fnc\common\clean_up.sqf";
    btc_fnc_create_composition = compile preprocessFileLineNumbers "core\fnc\common\create_composition.sqf";
    btc_fnc_house_addWP = compile preprocessFileLineNumbers "core\fnc\common\house_addWP.sqf";
    btc_fnc_set_damage = compile preprocessFileLineNumbers "core\fnc\common\set_damage.sqf";
    btc_fnc_road_direction = compile preprocessFileLineNumbers "core\fnc\common\road_direction.sqf";
    btc_fnc_findsafepos = compile preprocessFileLineNumbers "core\fnc\common\findsafepos.sqf";
    btc_fnc_set_groupowner = compile preprocessFileLineNumbers "core\fnc\common\set_groupowner.sqf";
    btc_fnc_find_closecity = compile preprocessFileLineNumbers "core\fnc\common\find_closecity.sqf";
    btc_fnc_delete = compile preprocessFileLineNumbers "core\fnc\common\delete.sqf";
    btc_fnc_deleteEntities = compile preprocessFileLineNumbers "core\fnc\common\deleteEntities.sqf";
    btc_fnc_final_phase = compile preprocessFileLineNumbers "core\fnc\common\final_phase.sqf";
    btc_fnc_findPosOutsideRock = compile preprocessFileLineNumbers "core\fnc\common\findposoutsiderock.sqf";
    btc_fnc_set_groupsowner = compile preprocessFileLineNumbers "core\fnc\common\set_groupsowner.sqf";

    //CITY
    btc_fnc_city_activate = compile preprocessFileLineNumbers "core\fnc\city\activate.sqf";
    btc_fnc_city_create = compile preprocessFileLineNumbers "core\fnc\city\create.sqf";
    btc_fnc_city_de_activate = compile preprocessFileLineNumbers "core\fnc\city\de_activate.sqf";
    btc_fnc_city_set_clear = compile preprocessFileLineNumbers "core\fnc\city\set_clear.sqf";
    btc_fnc_city_trigger_player_side = compile preprocessFileLineNumbers "core\fnc\city\trigger_player_side.sqf";
    btc_fnc_city_findPos = compile preprocessFileLineNumbers "core\fnc\city\findPos.sqf";

    //CIV
    btc_fnc_civ_add_weapons = compile preprocessFileLineNumbers "core\fnc\civ\add_weapons.sqf";
    btc_fnc_civ_add_grenade = compile preprocessFileLineNumbers "core\fnc\civ\add_grenade.sqf";
    btc_fnc_civ_get_weapons = compile preprocessFileLineNumbers "core\fnc\civ\get_weapons.sqf";
    btc_fnc_civ_get_grenade = compile preprocessFileLineNumbers "core\fnc\civ\get_grenade.sqf";
    btc_fnc_civ_populate = compile preprocessFileLineNumbers "core\fnc\civ\populate.sqf";
    btc_fnc_civ_create_patrol = compile preprocessFileLineNumbers "core\fnc\civ\create_patrol.sqf";
    btc_fnc_civ_unit_create = compile preprocessFileLineNumbers "core\fnc\civ\unit_create.sqf";
    btc_fnc_civ_CuratorCivPlaced_s = compile preprocessFileLineNumbers "core\fnc\civ\CuratorCivPlaced_s.sqf";
    btc_fnc_civ_evacuate = compile preprocessFileLineNumbers "core\fnc\civ\evacuate.sqf";

    //DATA
    btc_fnc_data_add_group = compile preprocessFileLineNumbers "core\fnc\data\add_group.sqf";
    btc_fnc_data_get_group = compile preprocessFileLineNumbers "core\fnc\data\get_group.sqf";
    btc_fnc_data_spawn_group = compile preprocessFileLineNumbers "core\fnc\data\spawn_group.sqf";

    //DB
    btc_fnc_db_save = compile preprocessFileLineNumbers "core\fnc\db\save.sqf";
    btc_fnc_db_delete = compile preprocessFileLineNumbers "core\fnc\db\delete.sqf";
    btc_fnc_db_autosave = compile preprocessFileLineNumbers "core\fnc\db\autosave.sqf";
    btc_fnc_db_loadObjectStatus = compile preprocessFileLineNumbers "core\fnc\db\loadObjectStatus.sqf";
    btc_fnc_db_saveObjectStatus = compile preprocessFileLineNumbers "core\fnc\db\saveObjectStatus.sqf";
    btc_fnc_db_loadCargo = compile preprocessFileLineNumbers "core\fnc\db\loadcargo.sqf";

    //EH
    btc_fnc_eh_explosives_defuse = compile preprocessFileLineNumbers "core\fnc\eh\explosives_defuse.sqf";
    btc_fnc_eh_handledisconnect = compile preprocessFileLineNumbers "core\fnc\eh\handledisconnect.sqf";
    btc_fnc_eh_buildingchanged = compile preprocessFileLineNumbers "core\fnc\eh\buildingchanged.sqf";
    btc_fnc_eh_server = compile preprocessFileLineNumbers "core\fnc\eh\server.sqf";

    //IED
    btc_fnc_ied_boom = compile preprocessFileLineNumbers "core\fnc\ied\boom.sqf";
    btc_fnc_ied_check = compile preprocessFileLineNumbers "core\fnc\ied\check.sqf";
    btc_fnc_ied_checkLoop = compile preprocessFileLineNumbers "core\fnc\ied\checkLoop.sqf";
    btc_fnc_ied_create = compile preprocessFileLineNumbers "core\fnc\ied\create.sqf";
    btc_fnc_ied_fired_near = compile preprocessFileLineNumbers "core\fnc\ied\fired_near.sqf";
    btc_fnc_ied_init_area = compile preprocessFileLineNumbers "core\fnc\ied\init_area.sqf";
    btc_fnc_ied_suicider_active = compile preprocessFileLineNumbers "core\fnc\ied\suicider_active.sqf";
    btc_fnc_ied_suicider_create = compile preprocessFileLineNumbers "core\fnc\ied\suicider_create.sqf";
    btc_fnc_ied_drone_active = compile preprocessFileLineNumbers "core\fnc\ied\drone_active.sqf";
    btc_fnc_ied_drone_create = compile preprocessFileLineNumbers "core\fnc\ied\drone_create.sqf";
    btc_fnc_ied_droneLoop = compile preprocessFileLineNumbers "core\fnc\ied\droneLoop.sqf";
    btc_fnc_ied_drone_fire = compile preprocessFileLineNumbers "core\fnc\ied\drone_fire.sqf";

    //INFO
    btc_fnc_info_cache = compile preprocessFileLineNumbers "core\fnc\info\cache.sqf";
    btc_fnc_info_give_intel = compile preprocessFileLineNumbers "core\fnc\info\give_intel.sqf";
    btc_fnc_info_has_intel = compile preprocessFileLineNumbers "core\fnc\info\has_intel.sqf";

    //MIL
    btc_fnc_mil_addWP = compile preprocessFileLineNumbers "core\fnc\mil\addWP.sqf";
    btc_fnc_mil_check_cap = compile preprocessFileLineNumbers "core\fnc\mil\check_cap.sqf";
    btc_fnc_mil_create_group = compile preprocessFileLineNumbers "core\fnc\mil\create_group.sqf";
    btc_fnc_mil_hd_hideout = compile preprocessFileLineNumbers "core\fnc\mil\hd_hideout.sqf";
    btc_fnc_mil_create_hideout = compile preprocessFileLineNumbers "core\fnc\mil\create_hideout.sqf";
    btc_fnc_mil_create_hideout_composition = compile preprocessFileLineNumbers "core\fnc\mil\create_hideout_composition.sqf";
    btc_fnc_mil_create_static = compile preprocessFileLineNumbers "core\fnc\mil\create_static.sqf";
    btc_fnc_mil_create_patrol = compile preprocessFileLineNumbers "core\fnc\mil\create_patrol.sqf";
    btc_fnc_mil_send = compile preprocessFileLineNumbers "core\fnc\mil\send.sqf";
    btc_fnc_mil_unit_create = compile preprocessFileLineNumbers "core\fnc\mil\unit_create.sqf";
    btc_fnc_mil_CuratorMilPlaced_s = compile preprocessFileLineNumbers "core\fnc\mil\CuratorMilPlaced_s.sqf";
    btc_fnc_mil_getStructures = compile preprocessFileLineNumbers "core\fnc\mil\getStructures.sqf";
    btc_fnc_mil_getBuilding = compile preprocessFileLineNumbers "core\fnc\mil\getBuilding.sqf";

    btc_fnc_mil_createVehicle = compile preprocessFileLineNumbers "core\fnc\mil\createVehicle.sqf";
    btc_fnc_mil_createUnits = compile preprocessFileLineNumbers "core\fnc\mil\createUnits.sqf";

    //PATROL
    btc_fnc_patrol_playersInAreaCityGroup = compile preprocessFileLineNumbers "core\fnc\patrol\playersInAreaCityGroup.sqf";
    btc_fnc_patrol_eh = compile preprocessFileLineNumbers "core\fnc\patrol\eh.sqf";
    btc_fnc_patrol_eh_remove = compile preprocessFileLineNumbers "core\fnc\patrol\eh_remove.sqf";
    btc_fnc_patrol_usefulCity = compile preprocessFileLineNumbers "core\fnc\patrol\usefulCity.sqf";
    btc_fnc_patrol_WPCheck = compile preprocessFileLineNumbers "core\fnc\patrol\WPCheck.sqf";
    btc_fnc_patrol_init = compile preprocessFileLineNumbers "core\fnc\patrol\init.sqf";
    btc_fnc_patrol_addWP = compile preprocessFileLineNumbers "core\fnc\patrol\addWP.sqf";

    //REP
    btc_fnc_rep_add_eh = compile preprocessFileLineNumbers "core\fnc\rep\add_eh.sqf";
    btc_fnc_rep_call_militia = compile preprocessFileLineNumbers "core\fnc\rep\call_militia.sqf";
    btc_fnc_rep_change = compile preprocessFileLineNumbers "core\fnc\rep\change.sqf";
    btc_fnc_rep_eh_effects = compile preprocessFileLineNumbers "core\fnc\rep\eh_effects.sqf";
    btc_fnc_rep_hd = compile preprocessFileLineNumbers "core\fnc\rep\hd.sqf";
    btc_fnc_rep_hh = compile preprocessFileLineNumbers "core\fnc\rep\hh.sqf";
    btc_fnc_rep_killed = compile preprocessFileLineNumbers "core\fnc\rep\killed.sqf";
    btc_fnc_rep_firednear = compile preprocessFileLineNumbers "core\fnc\rep\firednear.sqf";
    btc_fnc_rep_remove_eh = compile preprocessFileLineNumbers "core\fnc\rep\remove_eh.sqf";

    //SIDE
    btc_fnc_side_create = compile preprocessFileLineNumbers "core\fnc\side\create.sqf";
    btc_fnc_side_get_city = compile preprocessFileLineNumbers "core\fnc\side\get_city.sqf";
    btc_fnc_side_mines = compile preprocessFileLineNumbers "core\fnc\side\mines.sqf";
    btc_fnc_side_supply = compile preprocessFileLineNumbers "core\fnc\side\supply.sqf";
    btc_fnc_side_vehicle = compile preprocessFileLineNumbers "core\fnc\side\vehicle.sqf";
    btc_fnc_side_civtreatment = compile preprocessFileLineNumbers "core\fnc\side\civtreatment.sqf";
    btc_fnc_side_tower = compile preprocessFileLineNumbers "core\fnc\side\tower.sqf";
    btc_fnc_side_checkpoint = compile preprocessFileLineNumbers "core\fnc\side\checkpoint.sqf";
    btc_fnc_side_civtreatment_boat = compile preprocessFileLineNumbers "core\fnc\side\civtreatment_boat.sqf";
    btc_fnc_side_underwater_generator= compile preprocessFileLineNumbers "core\fnc\side\underwater_generator.sqf";
    btc_fnc_side_convoy = compile preprocessFileLineNumbers "core\fnc\side\convoy.sqf";
    btc_fnc_side_rescue = compile preprocessFileLineNumbers "core\fnc\side\rescue.sqf";
    btc_fnc_side_capture_officer = compile preprocessFileLineNumbers "core\fnc\side\capture_officer.sqf";
    btc_fnc_side_hostage = compile preprocessFileLineNumbers "core\fnc\side\hostage.sqf";
    btc_fnc_side_hack = compile preprocessFileLineNumbers "core\fnc\side\hack.sqf";

    //LOG
    btc_fnc_log_CuratorObjectPlaced_s = compile preprocessFileLineNumbers "core\fnc\log\CuratorObjectPlaced_s.sqf";
    btc_fnc_log_init = compile preprocessFileLineNumbers "core\fnc\log\init.sqf";
};

/////////////////////SERVER AND HEADLESS\\\\\\\\\\\\\\\\\\\\\
if (isServer OR (!isDedicated && !hasInterface)) then {
    //MIL
    btc_fnc_mil_unit_killed = compile preprocessFileLineNumbers "core\fnc\mil\unit_killed.sqf";
    btc_fnc_mil_add_eh = compile preprocessFileLineNumbers "core\fnc\mil\add_eh.sqf";
};

/////////////////////CLIENT AND SERVER\\\\\\\\\\\\\\\\\\\\\

//COMMON
btc_fnc_find_veh_with_turret = compile preprocessFileLineNumbers "core\fnc\common\find_veh_with_turret.sqf";
btc_fnc_get_class = compile preprocessFileLineNumbers "core\fnc\common\get_class.sqf";
btc_fnc_randomize_pos = compile preprocessFileLineNumbers "core\fnc\common\randomize_pos.sqf";
btc_fnc_getHouses = compile preprocessFileLineNumbers "core\fnc\common\getHouses.sqf";
btc_fnc_house_addWP_loop = compile preprocessFileLineNumbers "core\fnc\common\house_addWP_loop.sqf";

//DEBUG
btc_fnc_debug_message = compile preprocessFileLineNumbers "core\fnc\debug\message.sqf";


//CIV
btc_fnc_civ_class = compile preprocessFileLineNumbers "core\fnc\civ\class.sqf";
btc_fnc_civ_addWP = compile preprocessFileLineNumbers "core\fnc\civ\addWP.sqf";

//INT
btc_fnc_int_orders_give = compile preprocessFileLineNumbers "core\fnc\int\orders_give.sqf";
btc_fnc_int_orders_behaviour = compile preprocessFileLineNumbers "core\fnc\int\orders_behaviour.sqf";
btc_fnc_int_ask_var = compile preprocessFileLineNumbers "core\fnc\int\ask_var.sqf";

//LOG
btc_fnc_log_place_create_camera = compile preprocessFileLineNumbers "core\fnc\log\place_create_camera.sqf";
btc_fnc_log_place_destroy_camera = compile preprocessFileLineNumbers "core\fnc\log\place_destroy_camera.sqf";

//MIL
btc_fnc_mil_class = compile preprocessFileLineNumbers "core\fnc\mil\class.sqf";
btc_fnc_mil_ammoUsage = compile preprocessFileLineNumbers "core\fnc\mil\ammoUsage.sqf";

//TASK
btc_fnc_task_create = compile preprocessFileLineNumbers "core\fnc\task\create.sqf";
btc_fnc_task_fail = compile preprocessFileLineNumbers "core\fnc\task\fail.sqf";
btc_fnc_task_set_done = compile preprocessFileLineNumbers "core\fnc\task\set_done.sqf";

//SIDE
btc_fnc_side_abort = compile preprocessFileLineNumbers "core\fnc\side\abort.sqf";

/////////////////////CLIENT\\\\\\\\\\\\\\\\\\\\\
if (!isDedicated) then {
    //DB
    btc_fnc_db_request_save = compile preprocessFileLineNumbers "core\fnc\db\request_save.sqf";
    btc_fnc_db_request_delete = compile preprocessFileLineNumbers "core\fnc\db\request_delete.sqf";

    //COMMON
    btc_fnc_end_mission = compile preprocessFileLineNumbers "core\fnc\common\end_mission.sqf";
    btc_fnc_get_cardinal = compile preprocessFileLineNumbers "core\fnc\common\get_cardinal.sqf";
    btc_fnc_show_hint = compile preprocessFileLineNumbers "core\fnc\common\show_hint.sqf";
    btc_fnc_set_markerTextLocal = compile preprocessFileLineNumbers "core\fnc\common\set_markerTextLocal.sqf";
    btc_fnc_showSubtitle = compile preprocessFileLineNumbers "core\fnc\common\showSubtitle.sqf";

    //DEBUG
    btc_fnc_debug_marker = compile preprocessFileLineNumbers "core\fnc\debug\marker.sqf";
    btc_fnc_debug_units = compile preprocessFileLineNumbers "core\fnc\debug\units.sqf";
    btc_fnc_debug_fps = compile preprocessFileLineNumbers "core\fnc\debug\fps.sqf";
    btc_fnc_debug_graph = compile preprocessFileLineNumbers "core\fnc\debug\graph.sqf";

    //CIV
    btc_fnc_civ_add_leaflets = compile preprocessFileLineNumbers "core\fnc\civ\add_leaflets.sqf";

    //EH
    btc_fnc_eh_CuratorObjectPlaced = compile preprocessFileLineNumbers "core\fnc\eh\CuratorObjectPlaced.sqf";
    btc_fnc_eh_treatment = compile preprocessFileLineNumbers "core\fnc\eh\treatment.sqf";
    btc_fnc_eh_leaflets = compile preprocessFileLineNumbers "core\fnc\eh\leaflets.sqf";

    //INT
    btc_fnc_int_add_actions = compile preprocessFileLineNumbers "core\fnc\int\add_actions.sqf";
    btc_fnc_int_action_result = compile preprocessFileLineNumbers "core\fnc\int\action_result.sqf";
    btc_fnc_int_orders = compile preprocessFileLineNumbers "core\fnc\int\orders.sqf";
    btc_fnc_int_shortcuts = compile preprocessFileLineNumbers "core\fnc\int\shortcuts.sqf";
    btc_fnc_int_terminal = compile preprocessFileLineNumbers "core\fnc\int\terminal.sqf";

    //INFO
    btc_fnc_info_ask = compile preprocessFileLineNumbers "core\fnc\info\ask.sqf";
    btc_fnc_info_hideout_asked = compile preprocessFileLineNumbers "core\fnc\info\hideout_asked.sqf";
    btc_fnc_info_search_for_intel = compile preprocessFileLineNumbers "core\fnc\info\search_for_intel.sqf";
    btc_fnc_info_troops = compile preprocessFileLineNumbers "core\fnc\info\troops.sqf";
    btc_fnc_info_ask_reputation = compile preprocessFileLineNumbers "core\fnc\info\ask_reputation.sqf";

    //TASK
    btc_fnc_task_create = compile preprocessFileLineNumbers "core\fnc\task\create.sqf";
    btc_fnc_task_fail = compile preprocessFileLineNumbers "core\fnc\task\fail.sqf";
    btc_fnc_task_set_done = compile preprocessFileLineNumbers "core\fnc\task\set_done.sqf";

    //SIDE
    btc_fnc_side_request = compile preprocessFileLineNumbers "core\fnc\side\request.sqf";
};
