
/* ----------------------------------------------------------------------------
Function: btc_fnc_info_has_intel

Description:
    Fill me when you edit me !

Parameters:
    _body - [Object]
    _asker - [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_fnc_info_has_intel;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

params [
    ["_body", objNull, [objNull]],
    ["_asker", objNull, [objNull]]
];

if (btc_debug_log) then {
    [format ["%1", _body getVariable "intel"], __FILE__, [false]] call btc_fnc_debug_message;
};

if (_body getVariable ["intel", false] && !(_body getVariable ["btc_already_interrogated", false])) then {
    _body setVariable ["intel", false];

    [_asker] call btc_fnc_info_give_intel;
} else {
    [3] remoteExec ["btc_fnc_show_hint", _asker];
};
