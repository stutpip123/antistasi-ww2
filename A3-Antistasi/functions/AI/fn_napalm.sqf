/*
Author: Caleb Serafin
    Spawns napalm fire and damage at target location.

Arguments:
    <POS3|POS2> AGL centre of effect.
    <ARRAY<BOOL>> CancellationTokenUUID. Provisioning for implementation of cancellationTokens (Default = "");

Return Value:
    <BOOL> true if normal operation. false if something is invalid.

Scope: Clients, Global Arguments, Local Effect
Environment: Scheduled
Public: Yes. Can be called on positions independently, will not trigger other effects or functions.

Example:
    [screenToWorld [0.5,0.5], true] call A3A_fnc_napalmDamage;  // Spawn napalm fire and damage at the terrain position you are looking at.
*/
params [
    ["_pos",[],[ [] ], [2,3]],
    ["_cancellationTokenUUID","",[ "" ]]
];
if (!isServer) exitWith {false};
if ((count _pos) isEqualTo 2) then {
    _pos pushBack 0;
};

true;
