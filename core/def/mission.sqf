
btc_version = 1.19;

//Param
//<< Time options >>
private _p_db = ("btc_p_load" call BIS_fnc_getParamValue) isEqualTo 1;

//<< IED options >>
btc_p_ied = ("btc_p_ied" call BIS_fnc_getParamValue)/2;
private _p_ied_spot = "btc_p_ied_spot" call BIS_fnc_getParamValue;
btc_p_ied_drone = ("btc_p_ied_drone" call BIS_fnc_getParamValue) isEqualTo 1;

//<< Hideout/Cache options >>
private _hideout_n = "btc_p_hideout_n" call BIS_fnc_getParamValue;
private _cache_info_def = "btc_p_cache_info_def" call BIS_fnc_getParamValue;
private _cache_info_ratio = "btc_p_cache_info_ratio" call BIS_fnc_getParamValue;
private _info_chance = "btc_p_info_chance" call BIS_fnc_getParamValue;

//<< Spawn options >>
btc_p_mil_group_ratio = ("btc_p_mil_group_ratio" call BIS_fnc_getParamValue)/100;
btc_p_civ_group_ratio = ("btc_p_civ_group_ratio" call BIS_fnc_getParamValue)/100;
private _wp_house_probability = ("btc_p_wp_house_probability" call BIS_fnc_getParamValue)/100;
btc_p_patrol_max = "btc_p_patrol_max" call BIS_fnc_getParamValue;
btc_p_civ_max_veh = "btc_p_civ_max_veh" call BIS_fnc_getParamValue;

//<< Gameplay options >>
btc_p_sea  = ("btc_p_sea" call BIS_fnc_getParamValue) isEqualTo 1;
btc_p_side_mission_cycle = ("btc_p_side_mission_cycle" call BIS_fnc_getParamValue) isEqualTo 1;

//<< Other options >>
private _p_rep = "btc_p_rep" call BIS_fnc_getParamValue;
private _p_city_radius = ("btc_p_city_radius" call BIS_fnc_getParamValue) * 100;
btc_p_trigger = if (("btc_p_trigger" call BIS_fnc_getParamValue) isEqualTo 1) then {
    "this && !btc_db_is_saving && (false in (thisList apply {_x isKindOf 'Plane'})) && (false in (thisList apply {(_x isKindOf 'Helicopter') && (speed _x > 190)}))"
} else {
    "this && !btc_db_is_saving"
};
btc_p_debug  = "btc_p_debug" call BIS_fnc_getParamValue;

switch (btc_p_debug) do {
    case 0 : {
        btc_debug_log = false;
        btc_debug = false;
    };
    case 1 : {
        btc_debug_log = true;
        btc_debug = true;
        btc_debug_graph = false;
        btc_debug_frames = 0;
    };
    case 2 : {
        btc_debug_log = true;
        btc_debug = false;
    };
};

if (!isMultiplayer) then {
    btc_debug_log = true;
    btc_debug = true;
    btc_debug_graph = false;
    btc_debug_frames = 0;
};

if (isServer) then {
    btc_final_phase = false;

    private _allclass = ("true" configClasses (configFile >> "CfgVehicles")) apply {configName _x};
    _allclass = _allclass select {getNumber(configFile >> "CfgVehicles" >> _x >> "scope") isEqualTo 2};

    //City
    btc_city_radius = _p_city_radius;
    btc_city_blacklist = [];//NAME FROM CFG

    //Civ
    btc_civ_veh_active = [];

    //Database
    btc_db_is_saving = false;
    btc_db_load = _p_db;

    //Hideout
    btc_hideouts = [];
    btc_hideouts_id = 0;
    btc_hideouts_radius = 400;
    btc_hideout_n = _hideout_n;
    if (btc_hideout_n isEqualTo 99) then {
        btc_hideout_n = round random 5;
    };
    btc_hideout_safezone = 4000;
    btc_hideout_range = 3500;
    btc_hideout_rinf_time = 600;
    btc_hideout_cap_time = 1800;
    btc_hideout_cap_checking = false;

    //IED
    btc_ied_suic_time = 900;
    btc_ied_suic_spawned = - btc_ied_suic_time;
    btc_ied_offset = [0, -0.03, -0.07] select _p_ied_spot;
    btc_ied_list = [];

    //MIL
    btc_p_mil_wp_ratios = [_wp_house_probability, (1 - _wp_house_probability)/1.5 + _wp_house_probability];

    //Patrol
    btc_patrol_active = [];
    btc_patrol_area = 2500;

    //Rep
    btc_global_reputation = _p_rep;
    btc_rep_militia_call_time = 600;
    btc_rep_militia_called = - btc_rep_militia_call_time;

    //Hideout classname
    btc_type_campfire = ["MetalBarrel_burning_F", "Campfire_burning_F", "Land_Campfire_F", "FirePlace_burning_F"];
    btc_type_bigbox = ["Box_FIA_Ammo_F", "Box_East_AmmoVeh_F", "CargoNet_01_box_F", "O_CargoNet_01_ammo_F", "Land_Pallet_MilBoxes_F", "Land_PaperBox_open_full_F"];
    btc_type_seat = ["Land_WoodenLog_F", "Land_CampingChair_V2_F", "Land_CampingChair_V1_folded_F", "Land_CampingChair_V1_F"];
    btc_type_sleepingbag = ["Land_Sleeping_bag_F", "Land_Sleeping_bag_blue_F", "Land_Sleeping_bag_brown_F"];
    btc_type_tent = ["Land_TentA_F", "Land_TentDome_F"];
    btc_type_camonet = ["CamoNet_ghex_big_F", "CamoNet_OPFOR_big_F", "CamoNet_INDP_big_F", "CamoNet_BLUFOR_big_F", "CamoNet_OPFOR_open_F", "CamoNet_ghex_open_F", "CamoNet_BLUFOR_open_F", "Land_IRMaskingCover_02_F", "CamoNet_BLUFOR_F", "CamoNet_ghex_F", "CamoNet_OPFOR_F", "CamoNet_INDP_F"];

    //Side
    btc_side_aborted = false;
    btc_side_assigned = false;
    btc_side_done = false;
    btc_side_failed = false;
    btc_side_list = [0, 1, 2, 3, 4, 5, 6, 9, 10, 11, 12, 13]; // On ground (Side 9 and 11 are not think for map with different islands. Start and end city can be on different islands.)
    if (btc_p_sea) then {btc_side_list append [7, 8]}; // On sea
    btc_side_list_use = + btc_side_list;
    btc_side_jip_data = [];
    btc_type_tower = ["Land_Communication_F", "Land_TTowerBig_1_F", "Land_TTowerBig_2_F"];
    btc_type_phone = ["Land_PortableLongRangeRadio_F", "Land_MobilePhone_smart_F", "Land_MobilePhone_old_F"];
    btc_type_barrel = ["Land_GarbageBarrel_01_F", "Land_BarrelSand_grey_F", "MetalBarrel_burning_F", "Land_BarrelWater_F", "Land_MetalBarrel_F", "Land_MetalBarrel_empty_F"];
    btc_type_canister = ["Land_CanisterPlastic_F"];
    btc_type_pallet = ["Land_Pallets_stack_F", "Land_Pallets_F", "Land_Pallet_F"];
    btc_type_box = ["Box_East_Wps_F", "Box_East_WpsSpecial_F", "Box_East_Ammo_F"];
    btc_type_generator = ["Land_Device_assembled_F", "Land_Device_disassembled_F"];
    btc_type_storagebladder = ["StorageBladder_02_water_forest_F", "StorageBladder_02_water_sand_F"];
    btc_type_mines = ["APERSMine", "APERSBoundingMine", "APERSTripMine"];
    btc_type_power = ["WaterPump_01_sand_F", "WaterPump_01_forest_F", "Land_PressureWasher_01_F", "Land_DieselGroundPowerUnit_01_F", "Land_JetEngineStarter_01_F", "Land_PowerGenerator_F", "Land_PortableGenerator_01_F"];
    btc_type_cord = ["Land_ExtensionCord_F"];
    btc_type_cones = ["Land_RoadCone_01_F", "RoadCone_F"];
    btc_type_fences = ["Land_PlasticNetFence_01_long_F", "Land_PlasticNetFence_01_long_d_F", "RoadBarrier_F", "TapeSign_F"];
    btc_type_portable_light = ["Land_PortableLight_double_F", "Land_PortableLight_single_F"];
    btc_type_first_aid_kits = ["Land_FirstAidKit_01_open_F", "Land_FirstAidKit_01_closed_F"];
    btc_type_body_bags = _allclass select {
        _x isKindOf "Land_Bodybag_01_base_F" ||
        _x isKindOf "Land_Bodybag_01_empty_base_F" ||
        _x isKindOf "Land_Bodybag_01_folded_base_F"
    };
    btc_type_signs = _allclass select {_x isKindOf "Land_Sign_Mines_F"};
    btc_type_bloods = _allclass select {_x isKindOf "Blood_01_Base_F"};
    btc_type_medicals = _allclass select {_x isKindOf "MedicalGarbage_01_Base_F"};

    // The two arrays below are prefixes of buildings and their multiplier.
    // They will multiply the values of btc_rep_malus_building_destroyed and btc_rep_malus_building_damaged,
    // if a building is not present here it will be multiplied by 1.0.
    // Use 0.0 to disable reputation hit on a specific's building destruction.
    // You can modify this for any other terrain, clearing the table will also make all buildings just have a 1.0 multiplier.
    // If there's a hit in btc_buildings_multiplier, btc_buildings_categories_multipliers will NOT be run
    btc_buildings_multipliers = [
        // Specific buildings that need to have a custom modifier.
        ["Land_BellTower", 0.2 ], ["Land_WIP", 1.5], ["Land_u_Addon_01", 0.2],
        ["Land_Airport_Tower", 10.0], ["Land_Mil_ControlTower", 10.0],
        ["Land_TentHangar", 7.0], ["Land_i_Shed_Ind", 1.5], ["Land_u_Shed_Ind", 1.5],
        ["Land_TTowerBig", 6.0], ["Land_TTowerSmall", 4.5], ["Land_cmp_Tower", 4.0]
    ];

    // The multipliers are applied on top of each other, so "Chapel" and "Small" will both multiply the malus value
    btc_buildings_categories_multipliers = [
        ["Shed", 0.75], ["Slum", 0.8], ["Small", 0.8], ["Big", 1.5], ["Villa", 2.0], ["Main", 3.0], ["Tower", 2.0],
        ["HouseBlock", 2.0], ["Panelak", 2.0], ["Tenement", 7.0],
        ["Barn", 1.5], ["School", 3.0], ["Office", 2.0], ["Shop", 1.5], ["Store", 1.5], ["Hospital", 12.0],
        ["Castle", 2.5], ["Chapel", 3.0], ["Minaret", 3.0], ["Mosque", 4.0], ["Church", 4.0], ["Kostel", 4.0],
        ["Lighthouse", 4.0],
        ["Airport", 4.0], ["Hangar", 1.75], ["ControlTower", 2.25], ["Terminal", 3.0],
        ["Hopper", 2.0], ["Tank", 4.0], ["Factory", 2.0], ["Transformer", 1.1],
        ["FuelStation", 5.0],
        ["Barracks", 1.75],
        ["spp", 3.0], ["Powerstation", 3.0],
        ["Pump", 2.5]
    ];
    btc_buildings_changed = [];
};

//Civ
private _civClasses = [["CIV_F"]] call btc_fnc_civ_class;
btc_civ_type_units = _civClasses select 0;
btc_civ_type_veh = _civClasses select 2;
btc_civ_type_boats = _civClasses select 1;

btc_w_civs = ["V_Rangemaster_belt", "arifle_Mk20_F", "30Rnd_556x45_Stanag", "hgun_ACPC2_F", "9Rnd_45ACP_Mag"];
btc_g_civs = ["HandGrenade", "MiniGrenade", "ACE_M84", "ACE_M84"];


//Cache
btc_cache_type = ["Box_FIA_Ammo_F", "Box_FIA_Support_F", "Box_FIA_Wps_F"];
private _weapons_usefull = "true" configClasses (configFile >> "CfgWeapons") select {(getNumber (_x >> 'type') isEqualTo 1) AND !(getArray(_x >> 'magazines') isEqualTo []) AND (getNumber (_x >> 'scope') isEqualTo 2)};
btc_cache_weapons_type = _weapons_usefull apply {configName _x};

//IED
btc_type_ieds = ["Land_GarbageContainer_closed_F", "Land_GarbageContainer_open_F", "Land_GarbageBarrel_01_F", "Land_Pallets_F", "Land_Portable_generator_F", "Land_WoodenBox_F", "Land_MetalBarrel_F", "Land_BarrelTrash_grey_F", "Land_Sacks_heap_F", "Land_Bricks_V2_F", "Land_Bricks_V3_F", "Land_Bricks_V4_F", "Land_GarbageBags_F", "Land_GarbagePallet_F", "Land_GarbageWashingMachine_F", "Land_JunkPile_F", "Land_Tyres_F", "Land_Wreck_Skodovka_F", "Land_Wreck_Car_F", "Land_Wreck_Car3_F", "Land_Wreck_Car2_F", "Land_Wreck_Offroad_F", "Land_Wreck_Offroad2_F", "Land_WheelieBin_01_F", "Land_GarbageHeap_04_F", "Land_GarbageHeap_03_F", "Land_GarbageHeap_01_F"];
btc_model_ieds = btc_type_ieds apply {(toLower getText(configFile >> "CfgVehicles" >> _x >> "model")) select [1]};
btc_type_ieds_ace = ["IEDLandBig_F", "IEDLandSmall_F"];

//Int
btc_int_radius_orders = 25;
btc_int_search_intel_time = 4;

//Info
btc_info_intel_chance = _info_chance;
btc_info_cache_def = _cache_info_def;
btc_info_cache_ratio = _cache_info_ratio;

//Supplies
btc_supplies_mat = "Land_Cargo20_IDAP_F";

if (isServer) then {
    //Player
    missionNamespace setVariable ["btc_player_side", west, true];
    missionNamespace setVariable ["btc_respawn_marker", "respawn_west", true];

    //Log
    private _allclass = ("true" configClasses (configFile >> "CfgVehicles")) apply {configName _x};
    _allclass = _allclass select {getNumber(configFile >> "CfgVehicles" >> _x >> "scope") isEqualTo 2};
    private _rearming_static =
    [
        //"Static"
    ] + (_allclass select {(
        _x isKindOf "GMG_TriPod" ||
        _x isKindOf "StaticMortar" ||
        _x isKindOf "HMG_01_base_F" ||
        _x isKindOf "AA_01_base_F" ||
        _x isKindOf "AT_01_base_F") && (
        getNumber (configfile >> "CfgVehicles" >> _x >> "side") isEqualTo ([east, west, independent, civilian] find btc_player_side))
    });
    ([_rearming_static] call btc_fnc_find_veh_with_turret) params ["_rearming_static", "_magazines_static"];
};

btc_log_obj_created = [];

//Mil
btc_hq = objNull;

private _enemyFaction = "IND_G_F";
private _enemyClasses = [[_enemyFaction]] call btc_fnc_mil_class;

//Save class name to global variable
btc_enemy_side = _enemyClasses select 0;
btc_type_units = _enemyClasses select 1;
btc_type_divers = _enemyClasses select 2;
btc_type_crewmen = _enemyClasses select 3;
btc_type_boats = _enemyClasses select 4;
btc_type_motorized = _enemyClasses select 5;
btc_type_motorized_armed = _enemyClasses select 6;
btc_type_mg = _enemyClasses select 7;
btc_type_gl = _enemyClasses select 8;

//Sometimes you need to remove units: - ["Blabla","moreBlabla"];
//Sometimes you need to add units: + ["Blabla","moreBlabla"];
switch (_enemyFaction) do {
    /*case "Myfactionexemple" : {
        btc_type_units = btc_type_units - ["Blabla","moreBlabla"];
        btc_type_divers = btc_type_divers + ["Blabla","moreBlabla"];
        btc_type_crewmen = btc_type_crewmen + ["Blabla","moreBlabla"] - ["Blabla","moreBlabla"];
        btc_type_boats = btc_type_boats;
        btc_type_motorized = btc_type_motorized;
        btc_type_mg = btc_type_mg;
        btc_type_gl = btc_type_gl;
    };*/
    case "OPF_G_F" : {
        btc_type_motorized = btc_type_motorized + ["I_Truck_02_transport_F", "I_Truck_02_covered_F"];
        btc_type_motorized_armed = btc_type_motorized_armed + ["I_Heli_light_03_F"];
    };
    case "IND_C_F" : {
        btc_type_motorized = btc_type_motorized + ["I_G_Offroad_01_repair_F", "I_G_Offroad_01_F", "I_G_Quadbike_01_F", "I_G_Van_01_fuel_F", "I_Truck_02_transport_F", "I_Truck_02_covered_F"];
        btc_type_motorized_armed = btc_type_motorized_armed + ["I_Heli_light_03_F", "I_G_Offroad_01_F"];
        btc_type_units = btc_type_units - ["I_C_Soldier_Camo_F"];
    };
};

//Rep
btc_rep_bonus_cache = 100;
btc_rep_bonus_civ_hh = 3;
btc_rep_bonus_disarm = 25;
btc_rep_bonus_hideout = 200;
btc_rep_bonus_mil_killed = 0.25;

btc_rep_malus_civ_hd = - 10;
btc_rep_malus_civ_killed = - 10;
btc_rep_malus_civ_firenear = - 5;
btc_rep_malus_player_respawn = - 10;
btc_rep_malus_building_damaged = - 2.5;
btc_rep_malus_building_destroyed = - 5;

//Side
if (isNil "btc_side_assigned") then {btc_side_assigned = false;};
