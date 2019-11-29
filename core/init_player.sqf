[] call compile preprocessFileLineNumbers "core\doc.sqf";

[{!isNull player}, {

    player addRating 9999;
    ["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;

    player addEventHandler ["Respawn", {
        player addRating 9999;
        player setCaptive false;

        btc_rep_malus_player_respawn remoteExec ["btc_fnc_rep_change", 2];
    }];

    player addEventHandler ["CuratorObjectPlaced", btc_fnc_eh_CuratorObjectPlaced];
    ["ace_treatmentSucceded", btc_fnc_eh_treatment] call CBA_fnc_addEventHandler;
    player addEventHandler ["WeaponAssembled", btc_fnc_civ_add_leaflets];

    [] call btc_fnc_int_add_actions;
    [] call btc_fnc_int_shortcuts;

    private _standard_tasks = (player call BIS_fnc_tasksUnit) select {
        [_x] call BIS_fnc_taskState isEqualTo "ASSIGNED" &&
        _x in ["0", "1", "2"]
    };
    {
        [_x] call btc_fnc_task_create
    } forEach _standard_tasks;

    btc_int_ask_data = nil;
    ["btc_side_jip_data"] remoteExecCall ["btc_fnc_int_ask_var", 2];

    [{!(isNil "btc_int_ask_data")}, {
        private _side_jip_data = btc_int_ask_data;
        if !(_side_jip_data isEqualTo []) then {
            _side_jip_data call btc_fnc_task_create;
        };
    }] call CBA_fnc_waitUntilAndExecute;
}] call CBA_fnc_waitUntilAndExecute;

if (btc_debug) then {
    player allowDamage false;

    [{!isNull (findDisplay 12)}, {
        private _eh = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", btc_fnc_debug_marker];
    }] call CBA_fnc_waitUntilAndExecute;

    [{!isNull (getAssignedCuratorLogic player)}, {
        (getAssignedCuratorLogic player) addEventHandler ["CuratorObjectRegistered", {
            [{!isNull (findDisplay 312)}, {
                    ((findDisplay 312) displayCtrl 50) ctrlAddEventHandler ["Draw", btc_fnc_debug_marker];
            }] call CBA_fnc_waitUntilAndExecute;
        }];
    }, [], 10] call CBA_fnc_waitUntilAndExecute;
};
