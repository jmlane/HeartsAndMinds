
/* ----------------------------------------------------------------------------
Function: btc_fnc_log_init

Description:
    Fill me when you edit me !

Parameters:
    _obj - [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_fnc_log_init;
    (end)

Author:
    Vdauphin and jmlane

---------------------------------------------------------------------------- */

params [
    ["_obj", objNull, [objNull]]
];

btc_log_obj_created pushBack _obj;
btc_curator addCuratorEditableObjects [[_obj], false];
