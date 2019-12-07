
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

    [btc_cache_obj] call CBA_fnc_deleteEntity;

    if (btc_debug_log) then    {
        [format ["DESTROYED: ID %1 POS %2", btc_cache_n, btc_cache_pos], __FILE__, [false]] call btc_fnc_debug_message;
    };

    btc_rep_bonus_cache call btc_fnc_rep_change;

    btc_cache_pos = [];
    btc_cache_n = btc_cache_n + 1;
    btc_cache_obj = objNull;
    btc_cache_info = btc_info_cache_def;

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
