
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
    ["_asker", objNull, [objNull]]
];

private _id = 1;
private _n = random 100;

if (btc_hideouts isEqualTo []) then {_n = (btc_info_intel_type select 0) - 10;};

private _hideoutInfo = {
    params [
        ["_ho", btc_hq, [objNull]]
    ];

    if (btc_hideouts isEqualTo []) exitWith {};

    if (isNull _ho) then {
        _ho = selectRandom btc_hideouts;
        btc_hq = _ho;
    };

    private _pos = [getPos _ho, btc_info_hideout_radius] call CBA_fnc_randPos;

    private _marker = createMarker [format ["%1", _pos], _pos];
    _marker setMarkerType "hd_warning";
    _marker setMarkerText format ["%1m", btc_info_hideout_radius];
    _marker setMarkerSize [0.5, 0.5];
    _marker setMarkerColor "ColorRed";

    private _array = _ho getVariable ["markers", []];

    _array pushBack _marker;

    _ho setVariable ["markers", _array];
};

switch (true) do {
    case (_n < (btc_info_intel_type select 0)) : { //cache
        [true, 0] spawn btc_fnc_info_cache;
    };
    case (_n > (btc_info_intel_type select 1) && _n < 101) : { //both
        _id = 4;
        [true, 0] spawn btc_fnc_info_cache;
        [] spawn _hideoutInfo;
    };
    case (_n > (btc_info_intel_type select 0) && _n < (btc_info_intel_type select 1)) : { //hd
        _id = 5;
        [] spawn _hideoutInfo;
    };
    default {
        _id = 0;
        [3] remoteExec ["btc_fnc_show_hint", _asker];
    };
};

if (_id isEqualTo 0) exitWith {};
[_id] remoteExec ["btc_fnc_show_hint", 0];
