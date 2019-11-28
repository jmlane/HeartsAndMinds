
/* ----------------------------------------------------------------------------
Function: btc_fnc_ied_boom

Description:
    Fill me when you edit me !

Parameters:
    _wreck - [Object]
    _ied - [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_fnc_ied_boom;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

params [
    ["_wreck", objNull, [objNull]],
    ["_ied", objNull, [objNull]]
];

if (btc_debug_log) then {
    [format ["%1 - POS %2", [_wreck, _ied], getPos _wreck], __FILE__, [false]] call btc_fnc_debug_message;
};

private _pos = getPos _ied;
_ied setDamage 1;
