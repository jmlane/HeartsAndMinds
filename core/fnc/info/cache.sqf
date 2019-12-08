
/* ----------------------------------------------------------------------------
Function: btc_fnc_info_cache

Description:
    Server-side cache info handler that populates player diary with cache information.

Parameters:
    _player - Player that has gained the information. [Object]
    _isReal - Is the information accurate? [Boolean]
    _cache - Cache object. [Object]

Returns:
    [Nothing].

Examples:
    (begin example)
        [_player, _info_type isEqualTo "REAL"] remoteExecCall ["btc_fnc_info_cache", 2];
    (end)

Author:
    Giallustio, jmlane

---------------------------------------------------------------------------- */

params [
    ["_player", player, [objNull]],
    ["_isReal", true, [true]],
    ["_cache", btc_cache_obj, [objNull]]
];

// TODO: provide meaningful exit rather than nothing.
if (isNull _cache) exitWith {};

private _pos = if (_isReal) then {
    [btc_cache_pos, btc_cache_info] call CBA_fnc_randPos;
} else {
    private _axis = getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize") / 2;
    [[_axis, _axis, 0], btc_cache_info + _axis] call CBA_fnc_randPos;
};

[_player, [
    localize "STR_HM_DIARY_INFO",
    [
        format ["%1T @ GRID %2", [dayTime] call BIS_fnc_timeToString, mapGridPosition _player],
        format [localize "STR_HM_DIARY_INFO_BODY", mapGridPosition _pos]
    ]
]] remoteExecCall ["createDiaryRecord", _player];

btc_cache_info = if (btc_cache_info < btc_info_cache_ratio) then {
    btc_info_cache_ratio;
} else {
    btc_cache_info - btc_info_cache_ratio;
};

nil
