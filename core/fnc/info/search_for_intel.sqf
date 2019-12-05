
/* ----------------------------------------------------------------------------
Function: btc_fnc_info_search_for_intel

Description:
    Fill me when you edit me !

Parameters:
    _target - [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_fnc_info_search_for_intel;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

params [
    ["_target", objNull, [objNull]]
];

private _onFinish = {
    params ["_args"];
    _args params [
        ["_target", objNull, [objNull]],
        ["_player", player, [objNull]],
        ["_radius", 4000, [0]]
    ];

    if (btc_debug_log) then {
        [format ["%1", _target getVariable "intel"], __FILE__, [false]] call btc_fnc_debug_message;
    };

    if (_target getVariable ["intel", false] && !(_target getVariable ["btc_already_interrogated", false])) then {
        _target setVariable ["intel", false];

        private _hint = 1;
        private _n = random 1;
        private _hideoutsRemain = !(btc_hideouts isEqualTo []);

        private _hideoutInfo = {
            params [
                ["_player", player, [objNull]],
                ["_ho", btc_hq, [objNull]]
            ];

            if (btc_hideouts isEqualTo []) exitWith {};

            if (isNull _ho) then {
                _ho = selectRandom btc_hideouts;
                btc_hq = _ho; // Global?
            };

            private _pos = [getPos _ho, _radius] call CBA_fnc_randPos;
            private _directId = owner _player;

            private _marker = createMarker [format ["_USER_DEFINED #%1/%2H/1", _directId, _pos], _pos];
            _marker setMarkerType "hd_dot";
            _marker setMarkerColor "ColorRed";

            private _markers = _ho getVariable ["markers", []];

            _markers pushBack _marker;

            _ho setVariable ["markers", _markers];
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
                [true, 0] spawn btc_fnc_info_cache;
            };
        };

        [_hint] call btc_fnc_show_hint;
    } else {
        [3] remoteExec ["btc_fnc_show_hint", _player];
    };
};

private _radius = 7;
if (_target isKindOf "Man") then {_radius = 4;};
if (_target isKindOf "Helicopter") then {_radius = 20;};

private _condition = {
    params ["_args"];
    _args params ["_target", "_player", "_radius"];

    _target distance _player < _radius
};

[btc_int_search_intel_time, [_target, player, _radius], _onFinish, {}, _localizedTitle, _condition, ["isnotinside"]] call ace_common_fnc_progressBar;
