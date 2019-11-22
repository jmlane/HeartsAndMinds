
/* ----------------------------------------------------------------------------
Function: btc_fnc_fob_dismantle_s

Description:
    Fill me when you edit me !

Parameters:
    _flag - [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_fnc_fob_dismantle_s;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    ["_flag", objNull, [objNull]]
];

private _FOBname = _flag getVariable "btc_fob";
private _element = (btc_fobs select 0) find _FOBname;
private _pos = getPosASL _flag;

deleteVehicle _flag;
deleteVehicle ((btc_fobs select 1) deleteAt _element);

private _obj = objNull;
if (getText (configFile >> "cfgVehicles" >> btc_fob_mat >> "displayName") isEqualTo "") then {
    _obj = [btc_create_object_point, btc_fob_mat] call ace_rearm_fnc_createDummy;
} else {
    _obj = btc_fob_mat createVehicle [0, 0, 0];
};
_obj setVectorUp surfaceNormal _pos;
_obj setPosASL _pos;

[_obj] call btc_fnc_log_init;

deleteMarker ((btc_fobs select 0) deleteAt _element);
