/*
Author: Caleb Serafin
    Spawns napalm fire and damage at target location.
    Give seconds to `A3A_dev_napalmDynPrtclUpd` in debug console to set radius check time.

Arguments:
    <POS3|POS2> AGL centre of effect.
    <STRING> CancellationTokenUUID. Provisioning for implementation of cancellationTokens (Default = "");

Return Value:
    <BOOL> true if normal operation. false if something is invalid.

Scope: Same Server/HC, Global Arguments, Global Effect
Environment: Scheduled
Public: Yes.

Example:
    [screenToWorld [0.5,0.5]] remoteExec  ["A3A_fnc_napalm",2];  // Spawn napalm fire and damage at the terrain position you are looking at.
    [_this] spawn {
        params ["_object"];
        uiSleep 10;
        [getPos _object] remoteExec ["A3A_fnc_napalm",2];
    };
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

if (isNil {A3A_dev_napalmDynPrtclUpd}) then {   // After testing and seeing how different values affect performance, should be hard coded.
    A3A_dev_napalmDynPrtclUpd = 5;
};

playSound3D ["a3\sounds_f\weapons\explosion\expl_big_3.wss",_pos, false, AGLToASL _pos, 5, 0.6, 3000];   // Isn't actually audible at 3km, by 500m it's competing with footsteps.
[_pos,_endTime,_cancellationTokenUUID] spawn {
    params ["_pos","_endTime","_canTokUUID"];

    private _fnc_cancelRequested = { false; };// Future provisioning for implementation of cancellationTokens.
    private _audioDuration = 8.3; // audio is 8.538 seconds, subtract possible server->client latency
    private _audioEndTime = _endTime - _audioDuration;

    while {serverTime < _audioEndTime && !([_canTokUUID] call _fnc_cancelRequested)} do {
        playSound3D ["a3\sounds_f\sfx\fire1_loop.wss",_pos, false, AGLToASL _pos, 5, 0.7, 3000];   // Isn't actually audible at 3km, by 500m it's competing with footsteps.
        uiSleep _audioDuration;
    };
};

{ _x hideObjectGlobal true } foreach (nearestTerrainObjects [_pos,["tree","bush","small tree"],27.5])

private _fnc_cancelRequested = { false; };// Future provisioning for implementation of cancellationTokens.
while {_endTime > serverTime && !([_cancellationTokenUUID] call _fnc_cancelRequested)} do {

    // Particles
    private _allRenderers = allPlayers;
    //_allRenderers = _allRenderers select {(_x distance2D _pos) < 1500};  // (distance filtering allPlayers) will be far less than (player filtering nearEntities).
    isNil {  // Run in unscheduled scope to prevent parallel filtering.
        _allRenderers = _allRenderers select {!isNull _x && { !(_storageNamespace getVariable [getPlayerUID _x, false]) }};    // Per napalm as every effect needs to be rendered.
        { _storageNamespace setVariable [getPlayerUID _x, true]; } forEach _allRenderers;
    };
    { [_pos, _startTime,_cancellationTokenUUID] remoteExec ["A3A_fnc_napalmParticles",_x]; } forEach _allRenderers;


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
