params ["_vehicle", "_marker", "_isOver", "_lineIndex"];

/*  Inits the given vehicle on the marker

    Execution on: All

    Scope: Internal

    Params:
        _vehicle : OBJECT : The vehicle to be initialized
        _marker: STRING : The name of the marker
        _isOver: BOOLEAN : Determines if vehicle is over unit
        _lineIndex: NUMBER : The number of line the vehicle is added to

    Returns:
        Nothing
*/

_vehicle setVariable ["UnitIndex", _lineIndex * 10, true];
_vehicle setVariable ["UnitMarker", _marker, true];
_vehicle setVariable ["IsOver", _isOver, true];

//On vehicle death, remove it from garrison
_vehicle addEventHandler
[
    "Killed",
    {
        private _vehicle = _this select 0;
        private _id = _vehicle getVariable "UnitIndex";
        private _marker = _vehicle getVariable "UnitMarker";
        private _isOver = _vehicle getVariable "IsOver";
        if(_isOver) then
        {
            [_marker, typeOf _vehicle, _id] call A3A_fnc_removeFromOver;
        }
        else
        {
            [_marker, typeOf _vehicle, _id] call A3A_fnc_addToRequested;
        };
    }
];

_vehicle addEventHandler
[
    "GetIn",
    {
        private _vehicle = _this select 0;
        private _unit = _this select 2;
        if(side (group _unit) == teamPlayer && (isPlayer _unit)) then
        {
            private _id = _vehicle getVariable "UnitIndex";
            private _marker = _vehicle getVariable "UnitMarker";
            private _isOver = _vehicle getVariable "IsOver";
            [_marker, _vehicle] call A3A_fnc_removeFromSpawnedArrays;
            [_vehicle] spawn A3A_fnc_vehicleDespawner;
            if(_isOver) then
            {
                [_marker, typeOf _vehicle, _id] call A3A_fnc_removeFromOver;
            }
            else
            {
                [_marker, typeOf _vehicle, _id] call A3A_fnc_addToRequested;
            };
        };
    }
];
