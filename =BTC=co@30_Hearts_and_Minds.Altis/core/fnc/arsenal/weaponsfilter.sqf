params [
    ["_trait", [0, ["64", "64 + 128", "128 + 512"], 0], [[]]],
    ["_custom_arsenal", btc_custom_arsenal, [[]]],
    ["_arsenalRestrict", btc_p_arsenal_Restrict, [0]],
    ["_type_units", btc_type_units, [[]]]
];
_trait params ["_type", "_ammo_usageAllowed", "_canlock"];

private _weapons = ("true" configClasses (configFile >> "CfgWeapons") select {
    getNumber (_x >> "scope") isEqualTo 2 &&
    {getNumber (_x >> "type") in [1, 4]}
}) apply {configName _x};

private _allowedWeapons = [];
{
    _allowedWeapons append ([_weapons, _x, _canlock] call btc_fnc_arsenal_ammoUsage);
} forEach _ammo_usageAllowed;

private _enemyWeapons = [];
{
    _enemyWeapons append getArray (configFile >> "CfgVehicles" >> _x >> "weapons");
} forEach _type_units;
_allowedWeapons = _allowedWeapons - _enemyWeapons;

if (_arsenalRestrict isEqualTo 1) then {
    (_custom_arsenal select 0) append _allowedWeapons;
} else {
    (_custom_arsenal select 0) append (_weapons - _allowedWeapons);
};

_allowedWeapons
