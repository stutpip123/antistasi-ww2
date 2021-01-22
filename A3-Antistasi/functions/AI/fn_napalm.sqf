/*
Author: Caleb Serafin
    Spawns napalm fire and damage at target location.
    Give distance to `A3A_dev_napalmDynPrtclDist` in debug console to set dynamic particle rendering radius.
    Give seconds to `A3A_dev_napalmDynPrtclUpd` in debug console to set radius check time.

Arguments:
    <POS3|POS2> AGL centre of effect.
    <ARRAY<BOOL>> CancellationTokenUUID. Provisioning for implementation of cancellationTokens (Default = "");

Return Value:
    <BOOL> true if normal operation. false if something is invalid.

Scope: Same Server/HC, Global Arguments, Global Effect
Environment: Scheduled
Public: Yes.

Example:
    [screenToWorld [0.5,0.5], true] remoteExec  ["A3A_fnc_napalm",2];  // Spawn napalm fire and damage at the terrain position you are looking at.
*/
params [
    ["_pos",[],[ [] ], [2,3]],
    ["_cancellationTokenUUID","",[ "" ]]
];
if (!isServer) exitWith {false};
if ((count _pos) isEqualTo 2) then {
    _pos pushBack 0;
};

private _startTime = serverTime;
private _endTime = _startTime + 90;

private _napalmID = str serverTime + str random 1e5;
private _storageNamespace = [localNamespace,"A3A_NapalmRegister",_napalmID,"active",true] call A3A_fnc_setNestedObject;

if (isNil {A3A_dev_napalmDynPrtclUpd}) then {   // After testing and playing with different values, should be hard coded.
    A3A_dev_napalmDynPrtclUpd = 5;
};
if (isNil {A3A_dev_napalmDynPrtclDist}) then {   // After testing and playing with different values, should be hard coded.
    A3A_dev_napalmDynPrtclDist = 2000;
};

private _fnc_cancelRequested = { false; };// Future provisioning for implementation of cancellationTokens.
while {_endTime > serverTime && !([_cancellationTokenUUID] call _fnc_cancelRequested)} do {

    // Particles
    private _allRenderers = allPlayers;
    _allRenderers = _allRenderers select {(_x distance2D _pos) < A3A_dev_napalmDynPrtclDist}  // (distance filtering allPlayers) will be far less than (player filtering nearEntities).

    isNil {  // Run in unscheduled scope to prevent parallel filtering.
        _allRenderers = _allRenderers select {!isNull _x && { !(_storageNamespace getVariable [getPlayerUID _x, false]) }};    // Per napalm as every effect needs to be rendered.
        { _storageNamespace setVariable [getPlayerUID _x, true]; } forEach _allRenderers;
    };

    { [_x, _startTime,_cancellationTokenUUID] remoteExec ["A3A_fnc_napalmParticles",_x]; } forEach _allRenderers;


    // Damage
    private _victims = _pos nearEntities 27.5;  // The particle system is hardcoded. Radius appears 20-40m depending on wind.
    private _crew = [];
    { _crew append crew _x; } forEach _victims;
    _victims append _crew;

    isNil {  // Run in unscheduled scope to prevent parallel filtering.
        _victims = _victims select { !isNull _x && {(_x getVariable ["A3A_napalm_processing",0]) < serverTime}};    // Global to avoid double damage.
        { _x setVariable ["A3A_napalm_processing",serverTime + 30]; } forEach _victims;
    };

    { [_x, true,_cancellationTokenUUID] remoteExecCall ["A3A_fnc_napalmDamage",_x]; } forEach _victims;


    uiSleep A3A_dev_napalmDynPrtclUpd;
};

_storageNamespace setVariable ["active",false];
true;
