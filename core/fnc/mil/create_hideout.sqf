
/* ----------------------------------------------------------------------------
Function: btc_fnc_mil_create_hideout

Description:
    Fill me when you edit me !

Parameters:
    _pos - [Array]
    _id_hideout - [Number]
    _rinf_time - [Number]
    _cap_time - [Number]
    _id - [Number]

Returns:

Examples:
    (begin example)
        _result = [] call btc_fnc_mil_create_hideout;
    (end)

Author:
    Giallustio, jmlane

---------------------------------------------------------------------------- */

params [
    ["_pos", [], [[]]],
    ["_id_hideout", btc_hideouts_id, [0]],
    ["_rinf_time", time, [0]],
    ["_cap_time", time - btc_hideout_cap_time, [0]],
    ["_id", 0, [0]]
];

private _createHideoutComposition = {
    params [
        ["_pos", [0, 0, 0], [[]]]
    ];

    private _campfire = ["MetalBarrel_burning_F", "Campfire_burning_F", "Land_Campfire_F", "FirePlace_burning_F"];
    private _bigbox = ["Box_FIA_Ammo_F", "Box_East_AmmoVeh_F", "CargoNet_01_box_F", "O_CargoNet_01_ammo_F", "Land_Pallet_MilBoxes_F", "Land_PaperBox_open_full_F"];
    private _box = ["Box_East_Wps_F", "Box_East_WpsSpecial_F", "Box_East_Ammo_F"];
    private _power = ["WaterPump_01_sand_F", "WaterPump_01_forest_F", "Land_PressureWasher_01_F", "Land_DieselGroundPowerUnit_01_F", "Land_JetEngineStarter_01_F", "Land_PowerGenerator_F", "Land_PortableGenerator_01_F"];
    private _seat = ["Land_WoodenLog_F", "Land_CampingChair_V2_F", "Land_CampingChair_V1_folded_F", "Land_CampingChair_V1_F"];
    private _sleepingbag = ["Land_Sleeping_bag_F", "Land_Sleeping_bag_blue_F", "Land_Sleeping_bag_brown_F"];
    private _tent = ["Land_TentA_F", "Land_TentDome_F"];
    private _camonet = ["CamoNet_ghex_big_F", "CamoNet_OPFOR_big_F", "CamoNet_INDP_big_F", "CamoNet_BLUFOR_big_F", "CamoNet_OPFOR_open_F", "CamoNet_ghex_open_F", "CamoNet_BLUFOR_open_F", "Land_IRMaskingCover_02_F", "CamoNet_BLUFOR_F", "CamoNet_ghex_F", "CamoNet_OPFOR_F", "CamoNet_INDP_F"];

    private _hideoutObject = selectRandom ["Box_FIA_Ammo_F", "C_supplyCrate_F", "Box_East_AmmoVeh_F"];

    private _composition_hideout = [
        [selectRandom _campfire,0,[-2.30957,-1.02979,0]],
        [_hideoutObject,121.331,[0.675781,-1.52539,0]],
        [selectRandom _bigbox,227.166,[2.66504,1.4126,0]],
        [selectRandom _sleepingbag,135.477,[0.758789,-3.91309,0]],
        [selectRandom _power,77.6499,[0.418945,3.51855,0]],
        [selectRandom _seat,171.123,[-2.08203,-3.39795,0]],
        ["Flag_Red_F",0,[0,0,0]],
        [selectRandom _sleepingbag,161.515,[-0.726563,-4.76953,0]],
        ["Land_SatelliteAntenna_01_F",304.749,[-3.71973,2.46143,0]],
        [selectRandom _seat,279.689,[-4.52783,-0.76416,0]],
        [selectRandom _seat,238.639,[-3.89014,-2.94873,0]],
        [selectRandom _bigbox,346.664,[3.66455,-1.72998,0]],
        [selectRandom _box,36.4913,[-2.65088,-4.5625,0]],
        [selectRandom _tent,86.984,[3.19922,-4.36133,0]],
        [selectRandom _tent,10,[-4.35303,-5.66309,0]],
        [selectRandom _tent,300,[-8.47949,-1.64063,0]]
    ];
    if (random 1 > 0.5) then {
        _composition_hideout pushBack [selectRandom _camonet,0,[-0.84668,-2.16113,0]];
    };

    private _composition = [_pos, random 360, _composition_hideout] call btc_fnc_create_composition;

    _composition select ((_composition apply {typeOf _x}) find _hideoutObject);
};

private _city = objNull;
if (_pos isEqualTo []) then {
    private _useful = btc_city_all select {(
            !(_x getVariable ["active", false]) &&
            {_x distance (getMarkerPos btc_respawn_marker) > btc_hideout_safezone} &&
            {!(_x getVariable ["has_ho", false])} &&
            {_x getVariable ["type", ""] in ["NameLocal", "Hill", "NameVillage", "Airport"]}
        )};
    _city = selectRandom _useful;

    private _radius = ((_city getVariable ["RadiusX", 0]) + (_city getVariable ["RadiusY", 0]))/2;
    private _random_pos = [getPos _city, _radius] call btc_fnc_randomize_pos;
    _pos = [_random_pos, 0, 100, 2, false] call btc_fnc_findsafepos;

    _id = _city getVariable ["id", 0];
    _city setVariable ["occupied", true];
    _city setVariable ["has_ho", true];
    _city setVariable ["ho_units_spawned", false];
} else {
    _city = btc_city_all select _id;
};

_city setPos _pos;
_city setVariable ["ho_pos", _pos];
if (btc_debug) then {deleteMarker format ["loc_%1", _id];};
deleteVehicle (_city getVariable ["trigger_player_side", objNull]);

[_pos, btc_hideouts_radius, btc_hideouts_radius, _city, _city getVariable "occupied", _city getVariable "name", _city getVariable "type", _city getVariable "id"] call btc_fnc_city_trigger_player_side;

private _hideout = [_pos] call _createHideoutComposition;

_hideout setVariable ["id", _id_hideout];
_hideout setVariable ["rinf_time", _rinf_time];
_hideout setVariable ["cap_time", _cap_time];
_hideout setVariable ["assigned_to", _city];

_hideout addEventHandler ["Killed", {
    params [
        ["_unit", objNull, [objNull]],
        ["_killer", objNull, [objNull]],
        ["_instigator", objNull, [objNull]],
        ["_useEffects", false, [false]]
    ];

    private _id = _unit getVariable "id";

    btc_hideouts deleteRange (btc_hideouts select { _x getVariable "id" isEqualTo _id});

    btc_rep_bonus_hideout call btc_fnc_rep_change;

    private _city = _unit getVariable ["assigned_to", _unit];
    _city setVariable ["has_ho", false];

    deleteVehicle (nearestObject [getPos _unit, "Flag_Red_F"]);

    if (btc_hq isEqualTo _unit) then {btc_hq = objNull};
    if (btc_hideouts isEqualTo []) then {[] spawn btc_fnc_final_phase;};

    //Notification
    [2, count btc_hideouts] remoteExec ["btc_fnc_show_hint", 0];
    if (btc_debug_log) then {
        [format ["_this = %1 ; POS %2 ID %3", _this, getPos _unit, _id], __FILE__, [false]] call btc_fnc_debug_message;
    };
}];

if (btc_debug) then {
    private _marker = createMarker [format ["btc_hideout_%1", _pos], _pos];
    _marker setMarkerType "mil_unknown";
    _marker setMarkerText format ["Hideout %1", _id_hideout];
    _marker setMarkerSize [0.8, 0.8];
    _marker setMarkerColor "ColorRed";
};

if (btc_debug_log) then {
    [format ["_this = %1 ; POS %2 ID %3", _this, _pos, btc_hideouts_id], __FILE__, [false]] call btc_fnc_debug_message;
};

btc_hideouts_id = btc_hideouts_id + 1;
btc_hideouts pushBack _hideout;

true
