
/* ----------------------------------------------------------------------------
Function: btc_fnc_info_give_intel

Description:
    Fill me when you edit me !

Parameters:
    _asker - [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_fnc_info_give_intel;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

params [
    ["_asker", player, [objNull]],
    ["_radius", 4000, [0]]
];

private _hint = 1;
private _n = random 1;
private _hideoutsRemain = !(btc_hideouts isEqualTo []);

private _hideoutInfo = {
    params [
        ["_asker", player, [objNull]],
        ["_ho", btc_hq, [objNull]]
    ];

    if (btc_hideouts isEqualTo []) exitWith {};

    if (isNull _ho) then {
        _ho = selectRandom btc_hideouts;
        btc_hq = _ho; // Global?
    };

    private _pos = [getPos _ho, _radius] call CBA_fnc_randPos;
    private _directId = owner _asker;

    private _marker = createMarker [format ["_USER_DEFINED #%1/%2/1", _directId, _pos], _pos];
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
        [_asker] call _hideoutInfo;
    };
    case (_n >= 0.8 && {_n <= 0.95} && {_hideoutsRemain}) : {
        _hint = 5;
        [_asker] call _hideoutInfo;
    };
    default {
        [true, 0] spawn btc_fnc_info_cache;
    };
};

[_hint] call btc_fnc_show_hint;
