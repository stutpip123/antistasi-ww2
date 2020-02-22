params ["_type", "_group", "_marker", "_id"];

/*  Spawns in a unit for marker patrols, handles the EHs
*
*   Scope: Internal
*
*   Params:
*       _type : STRING : The config name of the unit to spawn
*       _group : GROUP : The group in which the unit gets spawned
*       _marker : STRING : The name of the marker on which the unit patrols
*       _id : NUMBER : The id of the unit
*
*   Returns:
*       _unit : OBJECT : The spawned in unit
*/

private _unit = _group createUnit [_type, getMarkerPos _marker, [], 5, "NONE"];
_unit setVariable ["UnitIndex", _id, true];
_unit setVariable ["UnitMarker", _marker, true];

[_unit, _marker] call A3A_fnc_NATOinit;

_unit addEventHandler
[
    "Killed",
    {
        private _unit = _this select 0;
        private _id = _unit getVariable "UnitIndex";
        private _marker = _unit getVariable "UnitMarker";
        ["Patrol", _marker, _id, 60] call A3A_fnc_addTimeoutForUnit;
    }
];

_unit;
