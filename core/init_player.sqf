[] call compile preprocessFileLineNumbers "core\doc.sqf";

[{!isNull player}, {

    player addRating 9999;
    ["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;

    [player] call btc_fnc_eh_player;

    [] call btc_fnc_int_add_actions;
    [] call btc_fnc_int_shortcuts;

    if (player getVariable ["interpreter", false]) then {
        player createDiarySubject [localize "STR_BTC_HAM_CON_INFO_ASKHIDEOUT_DIARYLOG", localize "STR_BTC_HAM_CON_INFO_ASKHIDEOUT_DIARYLOG"];
    };

    player setUnitLoadout ([_arsenal_trait select 0] call btc_fnc_arsenal_loadout);

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

    onMapSingleClick "vehicle player setPos _pos";
    player allowDamage false;

    waitUntil {!isNull (findDisplay 12)};
    private _eh = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", btc_fnc_debug_marker];
};
