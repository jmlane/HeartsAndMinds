[] call compile preprocessFileLineNumbers "core\fnc\city\init.sqf";

{[_x] spawn btc_fnc_task_create} forEach [0, 1];

if (btc_db_load && {profileNamespace getVariable [format ["btc_hm_%1_db", worldName], false]}) then {
    if (btc_version >= (profileNamespace getVariable [format ["btc_hm_%1_version", worldName], 1.18])) then {
        [] call compile preprocessFileLineNumbers "core\fnc\db\load.sqf";
    };
} else {
    for "_i" from 1 to btc_hideout_n do {[] call btc_fnc_mil_create_hideout;};
    [] call compile preprocessFileLineNumbers "core\fnc\cache\init.sqf";
};

[] call btc_fnc_db_autosave;
[] call btc_fnc_eh_server;
[btc_ied_list] call btc_fnc_ied_fired_near;

["Initialize"] call BIS_fnc_dynamicGroups;

if (btc_p_side_mission_cycle) then {
    [true] spawn btc_fnc_side_create;
};
