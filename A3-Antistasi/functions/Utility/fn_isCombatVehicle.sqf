params ["_vehicle"];

/*  Checks if a vehicle is a combat vehicle by checking against the template

    Execution on: HC or Server

    Scope: External

    Params:
        _vehicle : STRING or OBJECT : The vehicle that should be checked

    Returns:
        _result : BOOLEAN : True if the vehicle is combat ready, false otherwise
*/
if(isNull _vehicle || {_vehicle isEqualTo ""}) exitWith {false};

private _vehicleType = if (_vehicle isEqualType objNull) then {typeOf _vehicle} else {_vehicle};

private _result = _vehicleType in
(
    vehCSATLightArmed +
    vehCSATAttack +
    [vehCSATAA, vehCSATPlane, vehCSATPlaneAA] +
    vehCSATAttackHelis +
    vehNATOLightArmed +
    vehNATOAttack +
    [vehNATOAA, vehNATOPlane, vehNATOPlaneAA] +
    vehNATOAttackHelis
);

_result;
