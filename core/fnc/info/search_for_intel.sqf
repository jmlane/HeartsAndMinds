
/* ----------------------------------------------------------------------------
Function: btc_fnc_info_search_for_intel

Description:
    ACE Interaction action handler for searching for information.

Parameters:
    _target - Target of the interaction. [Object]
    _player - The player who performed the interaction. [Object]
    _args - Custom arguments. [Array]

Returns:
    [Nothing].

Examples:
    (begin example)
        _action = [
            "Search_intel",
            localize "STR_A3_Showcase_Marksman_BIS_tskIntel_title",
            "\A3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa",
            btc_fnc_info_search_for_intel,
            {!Alive (_this select 0)}
        ] call ace_interact_menu_fnc_createAction;
    (end)

Author:
    Giallustio, jmlane

---------------------------------------------------------------------------- */

params [
    ["_target", objNull, [objNull]],
    ["_player", player, [objNull]]
];

private _radius = 7;
if (_target isKindOf "Man") then {_radius = 4;};
if (_target isKindOf "Helicopter") then {_radius = 20;};

private _condition = {
    params ["_args"];
    _args params ["_target", "_player", "_radius"];

    _target distance _player < _radius
};

[btc_int_search_intel_time, [_target, player, _radius], {_this select 0 remoteExecCall ["btc_fnc_info_has_intel", 2]}, {}, _localizedTitle, _condition, ["isnotinside"]] call ace_common_fnc_progressBar;
