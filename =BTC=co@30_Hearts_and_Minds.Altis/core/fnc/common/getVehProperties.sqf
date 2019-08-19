
/* ----------------------------------------------------------------------------
Function: btc_fnc_getVehProperties

Description:
    Get properties of a vehicle.

Parameters:
    _veh - Vehicle to get properties. [Object]

Returns:
    _customization - Get skin. [Array]
    _isMedicalVehicle - Is medical vehicle. [Boolean]
    _isRepairVehicle - Is repair vehicle. [Boolean]
    _fuelSource - Fuel cargo and hook. [Array]
    _pylons - Array of pylon. [Array]

Examples:
    (begin example)
        [vehicle player] call btc_fnc_getVehProperties;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    ["_vehicle", objNull, [objNull]]
];

private _customization = [_vehicle] call BIS_fnc_getVehicleCustomization;
private _isMedicalVehicle = [_vehicle] call ace_medical_fnc_isMedicalVehicle;
private _isRepairVehicle = [_vehicle] call ace_repair_fnc_isRepairVehicle;
private _fuelSource = [
    [_vehicle] call ace_refuel_fnc_getFuel,
    _vehicle getVariable ["ace_refuel_hooks", []]
];
private _pylons = getPylonMagazines _vehicle;

[_customization, _isMedicalVehicle, _isRepairVehicle, _fuelSource, _pylons]
