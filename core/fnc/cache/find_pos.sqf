
/* ----------------------------------------------------------------------------
Function: btc_fnc_cache_find_pos

Description:
    Find a house in a city and spawn in it an ammo cache.

Parameters:
    _city_all - Array of cities where the ammo cache can be spawn. [Array]

Returns:

Examples:
    (begin example)
        [] call btc_fnc_cache_find_pos;
    (end)

Author:
    Giallustio, jmlane

---------------------------------------------------------------------------- */

params [
    ["_city_all", btc_city_all, [[]]]
];

private _useful = _city_all select {
    !(_x getVariable ["occupied", false]) && {(_x getVariable ["type", ""] in ["NameLocal", "Hill", "NameMarine"])}
};

private _cachePos = nil;
while {isNil "_cachePos"} do {
    private _city = selectRandom _useful;

    private _xx = _city getVariable ["RadiusX", 500];
    private _yy = _city getVariable ["RadiusY", 500];
    private _pos = [getPos _city, _xx + _yy] call btc_fnc_randomize_pos;

    private _house = selectRandom ([_pos, 50] call btc_fnc_getHouses);
    if (!isNil "_house") then {
        _cachePos = selectRandom (_house buildingPos -1);
    };
};

btc_cache_pos = _cachePos;
[_cachePos] call btc_fnc_cache_create;
