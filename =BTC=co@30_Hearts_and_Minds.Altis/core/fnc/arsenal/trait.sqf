params [
    ["_player", objNull, [objNull]]
];

// 0 - Rifleman, 1 - Medic Adv, 2 - Medic Basic, 3 - Repair, 4 - Engineer, 5 - Anti-Tank, 6 - Anti Air, 7 - Sniper/Machine gunner, 8 - Diver
// https://community.bistudio.com/wiki/CfgAmmo_Config_Reference#aiAmmoUsageFlags
private _type_ammoUsageAllowed = [];
switch (true) do {
    case ((_player getUnitTrait "medic") && (ace_medical_level isEqualTo 1)): {
        _type_ammoUsageAllowed = [1, ["64"], 0];
    };
    case ((_player getUnitTrait "medic") && (ace_medical_level isEqualTo 2)): {
        _type_ammoUsageAllowed = [2, ["64"], 0];
    };
    case (_player getVariable ["ace_isEngineer", 0] in [1, 2]): {
        _type_ammoUsageAllowed = [3, ["64"], 0];
    };
    case (_player getUnitTrait "explosiveSpecialist"): {
        _type_ammoUsageAllowed = [4, ["64", "16"], 0];
    };
    case ([typeOf _player, "128 + 512"] call btc_fnc_mil_ammoUsage): {
        _type_ammoUsageAllowed = [5, ["64", "128 + 512"], 1];
    };
    case ([typeOf _player] call btc_fnc_mil_ammoUsage): {
        _type_ammoUsageAllowed = [6, ["64", "256"], 1];
    };
    case ([typeOf _player, "64 + 128 + 256"] call btc_fnc_mil_ammoUsage): {
        _type_ammoUsageAllowed = [7, ["64 + 128 + 256"], 0];
    };
    case ([typeOf _player, "64 + 32"] call btc_fnc_mil_ammoUsage): {
        _type_ammoUsageAllowed = [8, ["64 + 32"], 0];
    };
    default {
        _type_ammoUsageAllowed = [0, ["64", "64 + 128", "128 + 512"], 0];
    };
};
mmg_01_hex_f
if (btc_debug || btc_debug_log) then {
    [
        format ["IsMedic basic: %1 IsMedic Adv: %2 IsAdvEngineer: %3 IsExplosiveSpecialist: %4 IsAT: %5 IsAA: %6",
            (_player getUnitTrait "medic") && (ace_medical_level isEqualTo 1),
            (_player getUnitTrait "medic") && (ace_medical_level isEqualTo 2),
            _player getVariable ["ace_isEngineer", 0],
            _player getUnitTrait "explosiveSpecialist",
            [typeOf _player, "128 + 512"] call btc_fnc_mil_ammoUsage,
            [typeOf _player] call btc_fnc_mil_ammoUsage
        ], __FILE__, [btc_debug, btc_debug_log]
    ] call btc_fnc_debug_message;
};

_type_ammoUsageAllowed
