/*
Author: Caleb Serafin
    Allows spawning a vehicle while loading units from templates.
    Supports multiple coordinate systems through the use of A3A_fnc_setPos.

Arguments:
    <STRING> Desired classname of new vehicle. [Default=""]
    <POS3D> Leaves placement up to createUnit. | <POS3DTYPE> Places according to the specified coordinate system. [Default=[0,0,0]]
    <SCALAR> Angles towards heading. | <VECTORDIR> Angles according to VectorDir. | <<VECTORDIR>,<VECTORUP>> Angles according to VectorDir And VectorUp. [Default=0]
    <SIDE> Side of crew | <GROUP> Group and side of crew | <BOOLEAN> No crew. [Default=sideLogic]
    <SCALAR> If above zero, will look for an empty position nearby. [Default=0]
    <BOOLEAN> True to make aircraft spawn at minimum 100m and fly at 110% stall speed. [Default=true]
    <BOOLEAN> True to enable vehicle BIS randomisation. [Default=true]

Return Value:
    <OBJECT> Spawned Vehicle; objNull if error.

Scope: Single Execution. Local Arguments. Global Effect.
Environment: Any. Automatically creates Unscheduled scope when needed.
Public: Yes.

Example:
    ["B_T_LSV_01_armed_F",getPos player, 0, resistance, 20] call A3A_fnc_spawnVehicle;

    private _myPos = getPosWorld player;
    _myPos = [_myPos#0,_myPos#1,0,"AGLS"];  // Spawn 0m above highest roof above the player.
    ["B_T_LSV_01_armed_F",_myPos, 0, resistance, 20] call A3A_fnc_spawnVehicle;
*/
params [
    ["_className","",[ "" ]],
    ["_position",[0,0,0],[ [] ], [3,4]],
    ["_direction",0,[ 0,[] ], [ 3,2 ]],
    ["_groupSide",sideLogic, [ sideLogic,grpNull,false ]],
    ["_emptyPositionRadius",0, [ 0 ]],
    ["_addAircraftPhysics",true, [ true ]],
    ["_enableRandomization",true, [ true ]]
];
private _filename = "fn_spawnVehicle";

private _isAircraft = _addAircraftPhysics && {(toLower getText(configFile >> "CfgVehicles" >> _className >> "simulation")) in ["airplanex","helicopterrtd","helicopterx"]};
private _velocity = if (_isAircraft) then {getNumber(configFile >> "CfgVehicles" >> _className >> "stallSpeed") / 3.6 * 1.1} else {0};  // kilometres per hour to metres per second; 110% of stall speed.
private _createVehicleSpecial = ["CAN_COLLIDE","FLY"] select (_isAircraft);  // kilometres per hour to metres per second; 110% of stall speed.

private _fnc_directionAdjuster = switch (true) do {
    case (_direction isEqualType 0): {{_this#0 setDir _this#1}};
    case (_direction isEqualType [] && count _direction isEqualTo 3): {{_this#0 setVectorDir _this#1}};
    case (_direction isEqualType [] && count _direction isEqualTo 2): {{_this#0 setVectorDirAndUp _this#1}};
    default {{ }};
};

private _vehicle = objNull;
if (isNil {
    _vehicle = createVehicle [_className, _position select [0,3], [], 0, _createVehicleSpecial];
    if (isNull _vehicle) then {
        [1, "InvalidObjectClassName | """+_className+""" does not exist or failed creation.", _filename] remoteExecCall ["A3A_fnc_log",2,false];
        _vehicle = createVehicle [_className, _position select [0,3], [], 0, _createVehicleSpecial];     // Retry with a vehicle so that a convoy/mission which doesn't check won't error out.
        _vehicle setVariable ["InvalidObjectClassName",true,true];                  // Allow external code to check for incorrect vehicle.
    };
    if (isNull _vehicle) exitWith {
        [1, "CreateVehicleFailure | Could not create vehicle", _filename] remoteExecCall ["A3A_fnc_log",2,false];
        nil;    // Will cause outer scope to exit as well.
    };
    _vehicle setVariable ["BIS_enableRandomization", _enableRandomization];

    [_vehicle,_position] call A3A_fnc_setPos;
    if (_isAircraft && getPosVisual _vehicle #2 < 50) then { [_vehicle,[_position#0,_position#1,100],"AGLS"] call A3A_fnc_setPos };

    [_vehicle, _direction] call _fnc_directionAdjuster;
    _vehicle setVelocityModelSpace [0, _velocity, 0];

    if (_emptyPositionRadius > 0) then {
        _spawnPosition = getPos _vehicle findEmptyPosition [0, _emptyPositionRadius, _className];
        if (_spawnPosition isEqualTo []) then {
            [2, "EmptyPositionNotFound | Unable to find suitable empty position """+_emptyPositionRadius+"""m within """+getPosASL _vehicle+"""(ASL) for """+_className+""" on """+worldName+""".", _filename] remoteExecCall ["A3A_fnc_log",2,false];
            _spawnPosition = getPos _vehicle
        } else {
            [_vehicle,_spawnPosition,"AGLS"] call A3A_fnc_setPos;
        };
    };
    true;
}) exitWith {_vehicle};

if (false) then {   // New template system detection goes here.
    _vehicle forceFlagTexture "\A3\Data_F\Flags\Flag_red_CO.paa"; // New template system dress-up goes here.
};

private _group = switch (typeName _groupSide) do {
    case "SIDE": { createGroup _groupSide };
    case "GROUP" : { _groupSide };
    default { grpNull };
};
if !(isNull _group) then {
    [_vehicle,_group] call A3A_fnc_spawnVehicleCrew;
};

_vehicle;
