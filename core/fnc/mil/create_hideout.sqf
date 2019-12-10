
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

private _hideout = [_pos] call btc_fnc_mil_create_hideout_composition;
clearWeaponCargoGlobal _hideout;
clearItemCargoGlobal _hideout;
clearMagazineCargoGlobal _hideout;

_hideout setVariable ["id", _id_hideout];
_hideout setVariable ["rinf_time", _rinf_time];
_hideout setVariable ["cap_time", _cap_time];
_hideout setVariable ["assigned_to", _city];

_hideout addEventHandler ["HandleDamage", {
    params [
        ["_hideout", objNull, [objNull]],
        ["_selection", "", [""]],
        ["_damage", 0, [0]],
        ["_source", objNull, [objNull]],
        ["_ammo", "", [""]],
        ["_hitIndex", 0, [0]],
        ["_instigator", objNull, [objNull]],
        ["_hitPoint", "", [""]]
    ];
    params ["_hideout", "_selection", "_damage", "_source", "_ammo", "_hitIndex", "_instigator", "_hitPoint"];

    private _explosive = getNumber(configFile >> "cfgAmmo" >> _ammo >> "explosive") > 0;

    if (_explosive && {_damage > 0.6}) then {
        private _id = _hideout getVariable "id";

        for "_i" from 0 to (count btc_hideouts - 1) do {
            if ((btc_hideouts select _i) getVariable "id" isEqualTo _id) then {
                btc_hideouts set [_i, 0];
            };
        };
        btc_hideouts = btc_hideouts - [0];

        btc_rep_bonus_hideout spawn btc_fnc_rep_change;

        private _city = _hideout getVariable ["assigned_to", _hideout];
        _city setVariable ["has_ho", false];

        deleteVehicle (nearestObject [getPos _hideout, "Flag_Red_F"]);
        _hideout setDamage 1;

        if (btc_hq isEqualTo _hideout) then {btc_hq = objNull};
        if (btc_hideouts isEqualTo []) then {[] spawn btc_fnc_final_phase;};

        //Notification
        [2, count btc_hideouts] remoteExec ["btc_fnc_show_hint", 0];
        if (btc_debug_log) then {
            [format ["_this = %1 ; POS %2 ID %3", _this, getPos _hideout, _id], __FILE__, [false]] call btc_fnc_debug_message;
        };
    } else {
        0
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
