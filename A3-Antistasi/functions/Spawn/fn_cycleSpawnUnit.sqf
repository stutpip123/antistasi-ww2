params ["_marker", "_type", "_lineIndex", "_group", "_spawnParameter", "_isOver"];

private _fileName = "cycleSpawnUnit";
[
    3,
    format ["Spawning in %1 on %2 in line %3 on position %4, is over %5", _type, _marker, _lineIndex, _spawnParameter, _isOver],
    _fileName
] call A3A_fnc_log;

private _position =_spawnParameter select 0;
private _dir = _spawnParameter select 1;

private _unit = _group createUnit [_type, _position, [], 5, "NONE"];
_unit setDir _dir;
_unit setPosATL _position;

//Should work as a local variable needs testing
if((_type != NATOCrew) && (_type != CSATCrew)) then
{
    _unit setVariable ["UnitIndex", (_lineIndex * 10 + 2)];
}
else
{
    _unit setVariable ["UnitIndex", (_lineIndex * 10 + 1)];
};
_unit setVariable ["UnitMarker", _marker];
_unit setVariable ["IsOver", _isOver];

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
        if(_isOver) then
        {
            [_marker, typeOf _unit, _id] call A3A_fnc_removeFromOver;
        }
        else
        {
            [_marker, typeOf _unit, _id] call A3A_fnc_addToRequested;
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
            [leader _group, _marker, "COMBAT", "SPAWNED", "ORIGINAL", "NOFOLLOW", "NOVEH2"] execVM "scripts\UPSMON.sqf";
        };
        //_group setBehaviour "COMBAT"; //Handled by upsmon, check if vcom needs it
        //[_group] call A3A_fnc_abortAmbientAnims
    }
];

if(side _group != teamPlayer) then
{
    [_unit, _marker] call A3A_fnc_NATOinit;
}
else
{
    [_unit] call A3A_fnc_FIAinit;
};

(group _unit) setVariable ["isDisabled", true, true];
_unit disableAI "ALL";
doStop _unit;
_unit spawn
{
    sleep 5;
    if((group _this) getVariable ["isDisabled", false]) then
    {
        _this enableSimulation false;
    };
    _this doFollow (leader (group _this));
};

_unit;
