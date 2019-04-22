
/* ----------------------------------------------------------------------------
Function: btc_fnc_ied_suicider_active

Description:
    Activate the suicider by adding explosive charge around his pelvis and force suicider to move in the direction of soldier.

Parameters:
    _suicider - Suicider created. [Object]

Returns:

Examples:
    (begin example)
        [_suicider] call btc_fnc_ied_suicider_active;
    (end)

Author:
    Giallustio, jmlane

---------------------------------------------------------------------------- */

params [
    ["_suicider", objNull, [objNull]]
];

private _group = createGroup [btc_enemy_side, true];
[_suicider] joinSilent _group;

_suicider call btc_fnc_rep_remove_eh;

[_group] call CBA_fnc_clearWaypoints;

[_suicider, btc_player_side, 10, selectRandom [0, 1, 2], false] call ace_zeus_fnc_moduleSuicideBomber;

private _array = getPos _suicider nearEntities ["SoldierWB", 30];

if (_array isEqualTo []) exitWith {};

private _expl1 = "DemoCharge_Remote_Ammo" createVehicle (position _suicider);
_expl1 attachTo [_suicider, [-0.1, 0.1, 0.15], "Pelvis"];
private _expl2 = "DemoCharge_Remote_Ammo" createVehicle (position _suicider);
_expl2 attachTo [_suicider, [0, 0.15, 0.15], "Pelvis"];
private _expl3 = "DemoCharge_Remote_Ammo" createVehicle (position _suicider);
_expl3 attachTo [_suicider, [0.1, 0.1, 0.15], "Pelvis"];

[_expl1, _expl2, _expl3] remoteExec ["btc_fnc_ied_belt", 0];

_suicider addEventHandler ["Killed", {
    params ["_unit", "_killer"];

    if !(isPlayer _killer) then {
        (attachedObjects _unit) call CBA_fnc_deleteEntity;
    };
}];

_group setBehaviour "CARELESS";
_group setSpeedMode "FULL";

if (btc_debug_log) then {
    [format ["_suicider = %1 POS %2 START LOOP", _suicider, getPos _suicider], __FILE__, [false]] call btc_fnc_debug_message;
};

[{
    params ["_args, _handle"];
    private _suicider = _args # 0;

    if (!alive _suicider) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;

        group _suicider setVariable ["suicider", false];

        if (btc_debug_log) then {
            [format ["_suicider = %1 POS %2 END LOOP", _suicider, getPos _suicider], __FILE__, [false]] call btc_fnc_debug_message;
        };
    };

    private _array = _suicider nearEntities ["SoldierWB", 30];
    if !(_array isEqualTo []) then {
        _suicider doMove (position (_array select 0));
    };
}, 0.5, [_suicider]] call CBA_fnc_addPerFrameHandler;
