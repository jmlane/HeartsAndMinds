
/* ----------------------------------------------------------------------------
Function: btc_fnc_info_has_intel

Description:
    Remote (server-side) handler for btc_fnc_info_search_for_intel.

Parameters:
    _target - Target of the interaction. [Object]
    _player - The player who performed the interaction. [Object]
    _radius - Max radius from hideout for information [Number]

Returns:
    [Nothing].

Examples:
    (begin example)
        [
            btc_int_search_intel_time,
            [_target, player, _radius],
            {_this select 0 remoteExecCall ["btc_fnc_info_has_intel", 2]},
            {},
            _localizedTitle,
            _condition,
            ["isnotinside"]
        ] call ace_common_fnc_progressBar;
    (end)

Author:
    Giallustio, jmlane

---------------------------------------------------------------------------- */
params [
    ["_target", objNull, [objNull]],
    ["_player", remoteExecutedOwner, [objNull]],
    ["_radius", 4000, [0]]
];

if (btc_debug_log) then {
    [format ["%1", _target getVariable "intel"], __FILE__, [false]] call btc_fnc_debug_message;
};

private _hint = 3;
if (_target getVariable ["intel", false] && !(_target getVariable ["btc_already_interrogated", false])) then {
    _target setVariable ["intel", false];

    private _n = random 1;
    private _hideoutsRemain = !(btc_hideouts isEqualTo []);

    private _hideoutInfo = {
        params [
            ["_player", player, [objNull]],
            ["_ho", btc_hq, [objNull]]
        ];

        if (isNull _ho) then {
            _ho = selectRandom btc_hideouts;
            btc_hq = _ho; // Global?
        };

        private _pos = [getPos _ho, _radius] call CBA_fnc_randPos;
        private _directId = owner _player;

        [_player, [
            localize "STR_HM_DIARY_INFO",
            [
                format ["%1T @ GRID %2", [dayTime] call BIS_fnc_timeToString, mapGridPosition _player],
                format [localize "STR_HM_DIARY_INFO_BODY", mapGridPosition _pos]
            ]
        ]] remoteExecCall ["createDiaryRecord", _player];
    };

    switch (true) do {
        case (_n > 0.95 && {_hideoutsRemain}) : {
            _hint = 4;
            [true, 0] spawn btc_fnc_info_cache;
            [_player] call _hideoutInfo;
        };
        case (_n >= 0.8 && {_n <= 0.95} && {_hideoutsRemain}) : {
            _hint = 5;
            [_player] call _hideoutInfo;
        };
        default {
            _hint = 1;
            [true, 0] spawn btc_fnc_info_cache;
        };
    };
};
[_hint] remoteExec ["btc_fnc_show_hint", _player];
