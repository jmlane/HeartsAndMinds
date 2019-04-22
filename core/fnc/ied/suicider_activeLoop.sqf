
/* ----------------------------------------------------------------------------
Function: btc_fnc_ied_suicider_activeLoop

Description:
    Detect and force the suicider to run in the direction of the soldier nearby.

Parameters:
    _suicider - Suicider. [Object]

Returns:

Examples:
    (begin example)
        [_suicider] call btc_fnc_ied_suicider_activeLoop;
    (end)

Author:
    Giallustio, jmlane

---------------------------------------------------------------------------- */

[{
    params ["_suicider"];

    if (alive _suicider) then {
        private _array = _suicider nearEntities ["SoldierWB", 30];
        if !(_array isEqualTo []) then {
            _suicider doMove (position (_array select 0));
        };
        _this call btc_fnc_ied_suicider_activeLoop;
    } else {
        group _suicider setVariable ["suicider", false];

        if (btc_debug_log) then {
            [format ["_suicider = %1 POS %2 END LOOP", _suicider, getPos _suicider], __FILE__, [false]] call btc_fnc_debug_message;
        };
    };
}, _this, 0.5] call CBA_fnc_waitAndExecute;
