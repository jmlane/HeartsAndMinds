
/* ----------------------------------------------------------------------------
Function: btc_fnc_info_cache

Description:
    Fill me when you edit me !

Parameters:
    _isReal - [Boolean]
    _showHint - [Number]

Returns:

Examples:
    (begin example)
        _result = [] call btc_fnc_info_cache;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

params [
    ["_isReal", true, [true]],
    ["_showHint", 0, [0]],
    ["_cache", btc_cache_obj, [objNull]]
];

if (isNull _cache) exitWith {};

private _pos = [btc_cache_pos, btc_cache_info] call CBA_fnc_randPos;
private _directId = 0;//owner _asker;

if !(_isReal) then {
    private _axis = getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize") / 2;
    _pos = [[_axis, _axis, 0], btc_cache_info + _axis] call CBA_fnc_randPos;
};

private _marker = createMarker [format ["_USER_DEFINED #%1/%2C/1", _directId, _pos], _pos];
_marker setMarkerType "hd_dot";
_marker setMarkerColor "ColorRed";

if (_showHint > 0) then {[1] remoteExec ["btc_fnc_show_hint", 0];};

btc_cache_info = btc_cache_info - btc_info_cache_ratio;
if (btc_cache_info < btc_info_cache_ratio) then {btc_cache_info = btc_info_cache_ratio;};
