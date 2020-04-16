params ["_unit", "_marker", "_isOver", "_unitIndex"];

/*  Inits a unit which is stationated on the marker

    Execution on: All

    Scope: Internal

    Params:
        _unit : OBJECT : The unit which should be initiated
        _marker : STRING : The name of the marker where the unit is stationated
        _isOver : BOOLEAN : Determines if the units is an over unit
        _unitIndex : NUMBER : The ID the unit will carry

    Returns:
        Nothing
*/

_unit setVariable ["UnitIndex", _unitIndex, true];
_unit setVariable ["UnitMarker", _marker, true];
_unit setVariable ["IsOver", _isOver, true];
_unit setVariable ["UnitSide", side (group _unit), true];

//On unit death, remove it from garrison
_unit addEventHandler
[
    "Killed",
    {
        private _unit = _this select 0;
        //Block crew groups from getting into vehicles if one died
        private _group = group _unit;
        _group setVariable ["shouldCrewVehicle", false, true];
        private _id = _unit getVariable "UnitIndex";
        private _marker = _unit getVariable "UnitMarker";
        private _isOver = _unit getVariable "IsOver";
        private _side = _unit getVariable "UnitSide";
        if(_isOver) then
        {
            [_marker, typeOf _unit, _id, _side] call A3A_fnc_removeFromOver;
        }
        else
        {
            [_marker, typeOf _unit, _id, _side] call A3A_fnc_addToRequested;
        };
        //Do a zone check only if marker is still spawned, don't trigger on despawn bleedout
        if(spawner getVariable _marker == 0) then
        {
            [_marker, side _group] call A3A_fnc_zoneCheck;
        };
    }
];

_unit addEventHandler
[
    "HandleDamage",
    {
        //Is there any way to disable this eventhandle after first run?
        private _unit = _this select 0;
        private _marker = _unit getVariable "UnitMarker";
        private _group = group _unit;
        if(_group getVariable ["isDisabled", false]) then
        {
            _group setVariable ["isDisabled", false, true];
            {
                _x enableSimulation true;
                _X enableAI "ALL";
            } forEach (units _group);
            if !(_group getVariable ["isCrewGroup", false]) then
            {
                [leader _group, _marker, "COMBAT", "SPAWNED", "ORIGINAL", "NOFOLLOW", "NOVEH2"] execVM "scripts\UPSMON.sqf";
            };
        };
        //_group setBehaviour "COMBAT"; //Handled by upsmon, check if vcom needs it
        //[_group] call A3A_fnc_abortAmbientAnims
    }
];
