/*
Author: Caleb Serafin
    Rotates position,vectorDirAndUp,velocity around origin according rotation vectorDirAndUp.
    NB: position,vectorDirAndUp,velocity references are modified.
    Currently only performs flat rotations. May be updated in future.

Arguments:
    <POS3D> Original Pos
    <VEC3D,VEC3D> Original vectorDirAndUp
    <VEC3D> Original velocity
    <VEC3D,VEC3D> Rotation vectorDirAndUp
    <BOOLEAN> Reverse rotation, undoes previous rotation.

Return Value:
    <BOOLEAN> true if successful; nil if crash.

Scope: Any.
Environment: Any.
Public: Yes

Example:
*/
params [
    ["_pos",[0,0,0],[ [] ],[3]],
    ["_vectorDirAndUp",[[0,0,0],[0,0,0]],[ [] ],[2]],
    ["_velocity",[0,0,0],[ [] ],[3]],
    ["_rotVectorDirAndUp",[[0,0,0],[0,0,0]],[ [] ],[2]],
    ["_reverse",false,[ false ]]
];

// Get azimuth rotation
private _rotDeg = (_rotVectorDirAndUp#0#0) atan2 (_rotVectorDirAndUp#0#1);  // This will be converted to absolute deg in deserialisation.
if (_reverse) then { _rotDeg = -_rotDeg; };
private _rotationMatrix = [
    [cos _rotDeg, -sin _rotDeg],
    [sin _rotDeg, cos _rotDeg]
];
private _flatRotation = { // Modifies _vec3D reference
    params ["_rotationMatrix","_vec3D"];
    private _vecZ = _vec3D deleteAt 2;
    _vec3D = ( _rotationMatrix matrixMultiply (_vec3D apply {[_x]}) ) apply {_x#0};  // The applies box and unbox elements in an array. // matrixMultiply introduces floating point errors, of ~size 8e-008.
    _vec3D pushBack _vecZ;
};
// Adjust Position & Velocity
[_rotationMatrix,_pos] call _flatRotation;
[_rotationMatrix,_velocity] call _flatRotation;
// Adjust Rotation
private _dir = -(_vectorDirAndUp#0#0) atan2 (_vectorDirAndUp#0#1);
_dir = _dir + _rotDeg;    // rotDeg is already negated from atan2.
_vectorDirAndUp set [0, [-sin _dir, cos _dir, _vectorDirAndUp#0#2]];

true;
