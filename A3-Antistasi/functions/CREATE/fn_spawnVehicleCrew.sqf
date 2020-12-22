/*
Author: Caleb Serafin
    Fills a vehicle non-cargo seats with crew determined from the group side and faction templates.

Arguments:
    <OBJECT> Vehicle for crew to be added to.
    <GROUP> Group of new crew members. Determines side.

Return Value:
    <ARRAY<OBJECT>> Spawned crew members; empty if error/no seats.

Scope: Single Execution. Local Arguments. Global Effect.
Environment: Any. Automatically creates Unscheduled scope when needed.
Public: Yes.

Example:
    private _freshMeat = [_vehicle,_group] call A3A_fnc_spawnVehicleCrew;
*/
params [
    ["_vehicle",objNull,[ objNull ]],
    ["_group",grpNull,[ grpNull ]]
];
private _filename = "fn_spawnVehicleCrew";
private _crewPeople = [];

if (isNull _vehicle) exitWith {[1, "ObjectNull | The passed vehicle does not exit.", _filename] remoteExecCall ["A3A_fnc_log",2,false]; _crewPeople;};
if (isNull _group) exitWith {[1, "GroupNull | The passed crew group for """,typeOf _vehicle,""" is null.", _filename] remoteExecCall ["A3A_fnc_log",2,false]; _crewPeople;};

private _isStaticWeapon = !(["StaticWeapon","StaticMGWeapon"] findIf {_vehicle isKindOf _x} isEqualTo -1);
private _crewClassSelection = [];
if (false) then {   // New template system detection goes here.
    _crewClassSelection = ["B_Soldier_VR_F","O_Soldier_VR_F","I_Soldier_VR_F","C_Soldier_VR_F"]; // New template system selection goes here.
} else {
    _crewClassSelection = switch (side _group) do {
        case west: { [NATOCrew,staticCrewOccupants] select (_isStaticWeapon) };
        case east: { [CSATCrew,staticCrewInvaders] select (_isStaticWeapon) };
        case civilian: { [] };
        case resistance: { staticCrewTeamPlayer };
        default { [] };
    };
};
if !(_crewClassSelection isEqualType []) then {_crewClassSelection = [_crewClassSelection]};

if (_crewClassSelection isEqualTo []) exitWith {
    _group addVehicle _vehicle;
    private _oldGroup = createVehicleCrew _vehicle;
    _crewPeople = crew _vehicle;
    _crewPeople joinSilent _group;
    deleteGroup _oldGroup;
    _crewPeople;
};

private _posAboveVehicle = getPos _vehicle vectorAdd [0,0,10];
isNil {
    _group addVehicle _vehicle;
    {
        private _crewClassName = selectRandom _crewClassSelection;
        private _crewPerson = _group createUnit [_crewClassName, _posAboveVehicle, [], 0, "CAN_COLLIDE"];
        if (isNull _crewPerson) then {
            [1, "InvalidObjectClassName | """+_crewClassName+""" does not exit or failed creation.", _filename] remoteExecCall ["A3A_fnc_log",2,false];
            _crewPerson = _group createUnit ["B_Soldier_VR_F", _posAboveVehicle, [], 0, "CAN_COLLIDE"];     // Retry with glowing VR man so that vehicle is crewed at least.
            _crewPerson setVariable ["InvalidObjectClassName",true,true];                  // Allow external code to check for incorrect crew.
        };
        if (isNull _crewPerson) exitWith {
            [1, "CreateUnitFailure | Could not create unit for group"""+_group+""".", _filename] remoteExecCall ["A3A_fnc_log",2,false];
        };
        if (_x isEqualTo []) then {
            _crewPerson assignAsDriver _vehicle;
            _crewPerson moveInDriver _vehicle;    // moveInTurret does not like [], everything else appears to work as expected.
        } else {
            _crewPerson assignAsTurret [_vehicle, _x];    // This might not be necessary, but I don't permit AI freedom for future funnies...
            _crewPerson moveInTurret [_vehicle, _x];
        };
        _crewPeople pushBack _crewPerson;
    } forEach (((fullCrew [_vehicle,nil,true]) select {_x#2 isEqualTo -1}) apply {_x#3});
};
_crewPeople joinSilent _group;  // Force to group side and not config side.
if (false) then {   // New template system detection goes here.
    {
        _x setUnitLoadout [[],[],[],[[]],[],[],"","G_Goggles_VR",[],["","","","","",""]]  // New template system dress-up goes here.
    } forEach _crewPeople;
};
_crewPeople;
