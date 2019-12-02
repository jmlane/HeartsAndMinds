
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
    Giallustio, jmlane

---------------------------------------------------------------------------- */
params [
    ["_cachePos", btc_cache_pos, [[]]],
    ["_cacheType", btc_cache_type, [objNull]]
];

btc_cache_obj = selectRandom _cacheType createVehicle _cachePos;
btc_cache_obj setPosATL _cachePos;
btc_cache_obj setDir (random 360);

btc_cache_obj addEventHandler ["Killed", {
    params [
        ["_unit", objNull, [objNull]],
        ["_killer", objNull, [objNull]],
        ["_instigator", objNull, [objNull]],
        ["_useEffects", false, [false]]
    ];

    [btc_cache_obj, btc_cache_markers] call CBA_fnc_deleteEntity;

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
}];

if (btc_debug_log) then {
    [format ["ID %1 POS %2", btc_cache_n, _cachePos], __FILE__, [false]] call btc_fnc_debug_message;
};

if (btc_debug) then {
    [format ["in %1", _cachePos], __FILE__, [btc_debug, false]] call btc_fnc_debug_message;
    //Marker
    private _marker = createMarker [format ["%1", _cachePos], _cachePos];
    _marker setMarkerType "mil_unknown";
    _marker setMarkerText format ["Cache %1", btc_cache_n];
    _marker setMarkerSize [0.8, 0.8];
};
