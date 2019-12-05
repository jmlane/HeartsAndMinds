
/* ----------------------------------------------------------------------------
Function: btc_fnc_info_has_intel

Description:
    Fill me when you edit me !

Parameters:
    _body - [Object]
    _asker - [Object]
    _radius - Max radius from hideout for information [Number]

Returns:

Examples:
    (begin example)
        _result = [] call btc_fnc_info_has_intel;
    (end)

Author:
    Giallustio, jmlane

---------------------------------------------------------------------------- */

params [
    ["_target", objNull, [objNull]],
    ["_player", player, [objNull]],
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
            _hint = 1;
            [true, 0] spawn btc_fnc_info_cache;
        };
    };
};
[_hint] remoteExec ["btc_fnc_show_hint", _player];
