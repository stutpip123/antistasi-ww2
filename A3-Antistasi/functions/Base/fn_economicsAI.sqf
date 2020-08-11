//Original Author: Barbolani
//Edited and updated by the Antstasi Community Development Team

_fnc_economics =
{
    params ["_coefficient", "_typeArray", "_accelerator", ["_isOccupants", false]];

    if (_typeArray isEqualType "") then
    {
        _typeArray  = [_typeArray];
    };

	if (_typeArray isEqualTo []) exitWith {};

    {
        private _currentItems = 0;
        _currentItems = (timer getVariable [_x, 0]) + (_coefficient * _accelerator);
        if(_isOccupants) then
        {
            _currentItems = _currentItems + (2 ^ (tierWar/5));
        };
        timer setVariable [_x, _currentItems, true];
    } forEach _typeArray;
};

//--------------------------------------Occupants--------------------------------------------------
private _accelerator = 1.2 + (tierWar + difficultyCoef) / 20;

[0.2, staticATOccupants, _accelerator, true] spawn _fnc_economics;
[0.1, staticAAOccupants, _accelerator, true] spawn _fnc_economics;
[0.2, vehNATOAPC, _accelerator, true] spawn _fnc_economics;
[0.1, vehNATOTank, _accelerator, true] spawn _fnc_economics;
[0.1, vehNATOAA, _accelerator, true] spawn _fnc_economics;
[0.3, vehNATOBoat, _accelerator, true] spawn _fnc_economics;
[0.2, vehNATOPlane, _accelerator, true] spawn _fnc_economics;
[0.2, vehNATOPlaneAA, _accelerator, true] spawn _fnc_economics;
[0.2, vehNATOTransportPlanes, _accelerator, true] spawn _fnc_economics;
[0.2, vehNATOTransportHelis - [vehNATOPatrolHeli], _accelerator, true] spawn _fnc_economics;
[0.2, vehNATOAttackHelis, _accelerator, true] spawn _fnc_economics;
[0.2, vehNATOMRLS, _accelerator, true] spawn _fnc_economics;

//--------------------------------------Invaders---------------------------------------------------
[0.2, staticATInvaders, _accelerator] spawn _fnc_economics;
[0.1, staticAAInvaders, _accelerator] spawn _fnc_economics;
[0.2, vehCSATAPC, _accelerator] spawn _fnc_economics;
[0.1, vehCSATTank, _accelerator] spawn _fnc_economics;
[0.1, vehCSATAA, _accelerator] spawn _fnc_economics;
[0.3, vehCSATBoat, _accelerator] spawn _fnc_economics;
[0.2, vehCSATPlane, _accelerator] spawn _fnc_economics;
[0.2, vehCSATPlaneAA, _accelerator] spawn _fnc_economics;
[0.2, vehCSATTransportPlanes, _accelerator] spawn _fnc_economics;
[0.2, vehCSATTransportHelis - [vehCSATPatrolHeli], _accelerator] spawn _fnc_economics;
[0.2, vehCSATAttackHelis, _accelerator] spawn _fnc_economics;
[0.2, vehCSATMRLS, _accelerator] spawn _fnc_economics;
