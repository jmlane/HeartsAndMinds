
/* ----------------------------------------------------------------------------
Function: btc_fnc_cache_create

Description:
    Create a cache at btc_cache_pos position.

Parameters:

Returns:

Examples:
    (begin example)
        _result = [] call btc_fnc_cache_create;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

btc_cache_obj = selectRandom btc_cache_type createVehicle btc_cache_pos;
btc_cache_obj setPosATL btc_cache_pos;
btc_cache_obj setDir (random 360);

clearWeaponCargoGlobal btc_cache_obj;
clearItemCargoGlobal btc_cache_obj;
clearMagazineCargoGlobal btc_cache_obj;

btc_cache_obj addEventHandler ["HandleDamage", {
    params [
        ["_cache", objNull, [objNull]],
        ["_part", "", [""]],
        ["_damage", 0, [0]],
        ["_injurer", objNull, [objNull]],
        ["_ammo", "", [""]]
    ];

    private _explosive = (getNumber(configFile >> "cfgAmmo" >> _ammo >> "explosive") > 0);

    if (isNil {_cache getVariable "btc_hd_cache"} && {_explosive} && {_damage > 0.6}) then {
        _cache setVariable ["btc_hd_cache", true];

        //Effects
        private _pos = getPosATL btc_cache_obj;
        "Bo_GBU12_LGB_MI10" createVehicle _pos;
        [_pos] spawn {
            params ["_pos"];

            sleep 2;
            "M_PG_AT" createVehicle _pos;
            sleep 2;
            "M_Titan_AT" createVehicle _pos;
        };

        [attachedObjects _cache, btc_cache_obj, btc_cache_markers] call CBA_fnc_deleteEntity;

        private _marker = createMarker [format ["btc_cache_%1", btc_cache_n], btc_cache_pos];
        _marker setMarkerType "hd_destroy";
        [_marker, "STR_BTC_HAM_O_EH_HDCACHE_MRK", btc_cache_n] remoteExec ["btc_fnc_set_markerTextLocal", [0, -2] select isDedicated, _marker]; //Cached %1 destroyed

        _marker setMarkerSize [1, 1];
        _marker setMarkerColor "ColorRed";

        if (btc_debug_log) then    {
            [format ["DESTROYED: ID %1 POS %2", btc_cache_n, btc_cache_pos], __FILE__, [false]] call btc_fnc_debug_message;
        };

        btc_rep_bonus_cache call btc_fnc_rep_change;

        btc_cache_pos = [];
        btc_cache_n = btc_cache_n + 1;
        btc_cache_obj = objNull;
        btc_cache_info = btc_info_cache_def;
        btc_cache_markers = [];

        //Notification
        [0] remoteExec ["btc_fnc_show_hint", 0];

        [] spawn {[] call btc_fnc_cache_find_pos;};
    } else {
        0
    };
}];

private _pos_type_array = ["TOP", "FRONT", "CORNER_L", "CORNER_R"];

for "_i" from 1 to (1 + round random 3) do {
    private _holder = createVehicle ["groundWeaponHolder", btc_cache_pos, [], 0, "can_collide"];
    _holder addWeaponCargoGlobal [selectRandom btc_cache_weapons_type, 1];
    _holder setVariable ["no_cache", true];

    private _pos_type = selectRandom _pos_type_array;
    _pos_type_array = _pos_type_array - [_pos_type];
    [btc_cache_obj, _holder, _pos_type] call btc_fnc_cache_create_attachto;
};

if (btc_debug_log) then {
    [format ["ID %1 POS %2", btc_cache_n, btc_cache_pos], __FILE__, [false]] call btc_fnc_debug_message;
};

if (btc_debug) then {
    [format ["in %1", btc_cache_pos], __FILE__, [btc_debug, false]] call btc_fnc_debug_message;
    //Marker
    private _marker = createMarker [format ["%1", btc_cache_pos], btc_cache_pos];
    _marker setMarkerType "mil_unknown";
    _marker setMarkerText format ["Cache %1", btc_cache_n];
    _marker setMarkerSize [0.8, 0.8];
};
