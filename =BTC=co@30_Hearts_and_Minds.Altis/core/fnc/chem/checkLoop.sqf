
/* ----------------------------------------------------------------------------
Function: btc_fnc_chem_checkLoop

Description:
    Loop over chemical objects and check if player is around. If yes, set damage to player. Then propagate the contamination if player get in vehicle or contaminated objets are loaded to vehicle.

Parameters:

Returns:

Examples:
    (begin example)
        [] call btc_fnc_chem_checkLoop;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

if !(btc_p_chem) exitWith {};

private _bodyParts = ["head","body","hand_l","hand_r","leg_l","leg_r"];

[{
    params ["_args", "_id"];
    _args params ["_contaminated", "_decontaminate", "_bodyParts", "_cfgGlasses"];

    if (_contaminated isEqualTo []) exitWith {};

    private _units = allUnits;
    private _objtToDecontaminate = [];
    private _unitsContaminated = _contaminated select {_x in _units};
    {
        (0 boundingBoxReal _x) params ["_p1", "_p2"];
        private _maxWidth = abs ((_p2 select 0) - (_p1 select 0));
        private _maxLength = abs ((_p2 select 1) - (_p1 select 1));
        private _pos = getPosWorld _x;
        private _maxHeight = abs ((_p2 select 2) - (_p1 select 2)) + (_pos select 2);
        private _sorted = _contaminated;
        if (_x isKindOf "DeconShower_01_F") then {
            _sorted = _unitsContaminated; // Small shower can only decontaminate units
        };
        _objtToDecontaminate append (_sorted inAreaArray [_pos, _maxWidth/2, _maxLength/2, getDir _x, true, _maxHeight]);
    } forEach (_decontaminate select {_x animationSourcePhase "valve_source" isEqualTo 1});
    {
        if (!(local _x) && {_x in _units}) then {
            ["btc_chem_decontaminated", [_x], _x] call CBA_fnc_targetEvent;
        };
        _contaminated deleteAt (_contaminated find _x);
        {
            if (!(local _x) && {_x in _units}) then {
                ["btc_chem_decontaminated", [_x], _x] call CBA_fnc_targetEvent;
            };
            _contaminated deleteAt (_contaminated find _x);
            {
                _contaminated deleteAt (_contaminated find _x);
            } forEach (_x getVariable ["ace_cargo_loaded", []]);
        } forEach ((_x getVariable ["ace_cargo_loaded", []]) + crew _x);
    } forEach _objtToDecontaminate;

    if (_contaminated isEqualTo []) exitWith {};

    private _unitContaminate = [];
    private _range = 3;
    {
        if (_x in _units) then {
            _range = _range / 2;
        };
        private _pos = getPosWorld _x;
        _unitContaminate append (_units inAreaArray [_pos, _range, _range, 0, false, 2 + (_pos select 2)]);
    } forEach _contaminated;
    {
        private _notAlready = _contaminated pushBackUnique _x > -1;
        if (local _x) then {
            [_x, _notAlready, _bodyParts, _cfgGlasses] call btc_fnc_chem_damage;
        } else {
            if (_notAlready) then {
                [_x] remoteExecCall ["btc_fnc_chem_damageLoop", _x]; // ropeburn
            };
        };
    } forEach _unitContaminate;
}, 3, [btc_chem_contaminated, btc_chem_decontaminate, _bodyParts, configFile >> "CfgGlasses"]] call CBA_fnc_addPerFrameHandler;
