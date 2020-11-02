params ["_gunship", "_strikeGroup", "_supportName"];

private _crewUnit = typeOf (driver _gunship);
private _crew = objNull;

for "_i" from 1 to 3 do
{
    _crew = [_strikeGroup, _crewUnit, getPos _gunship] call A3A_fnc_createUnit;
    _crew moveInAny _gunship;
};

/*
autocannon_40mm_VTOL_01_F
cannon_105mm_VTOL_01_F
gatling_20mm_VTOL_01_F
*/
