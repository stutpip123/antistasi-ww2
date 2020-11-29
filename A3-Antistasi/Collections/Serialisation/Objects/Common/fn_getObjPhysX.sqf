/*
Author: Caleb Serafin
    Gets object PhyX data and outputs to array.

Arguments:
    <OBJECT> Object
    <
        <POS3D> positionWorld Reference
        <VEC3D,VEC3D> vectorDirAndUp Reference.
    > physXDataRef

Return Value:
    <
        <SCALAR> _mass,
        <VEC3D> _positionWorld,
        <SCALAR> _positionAGLZ,
        <SCALAR> _modelHeight,
        <VEC3D,VEC3D> _vectorDirAndUp,
        <VEC3D> _velocity
    > physX data.

Scope: Preferably where object is local.
Environment: Any.
Public: Yes

Example:
*/
params [
    ["_object",objNull,[objNull]],
    ["_physXDataRef",[],[ [] ], [2]]
];
_physXDataRef params [
    ["_positionWorldRef",[0,0,0],[ [] ],[3]],
    ["_vectorDirAndUpRef",[[0,0,0],[0,0,0]],[ [] ],[2]]
];

private _mass = getMass _object;
private _positionWorld = (getPosWorld _object) vectorDiff _positionWorldRef;  // Because other position systems XY rely on an incorrect boundingBox/Model centre calculations.
private _positionAGLZ = ASLToAGL (getPosASL _object)#2;  // Not transformed by new XY pos of flat rotation because it represents the object on a flat plane, therefore a flat rotation makes no height difference.
private _modelHeight = (getPosWorld _object)#2 - (getPosASL _object)#2;
private _vectorDirAndUp = [vectorDir _object, vectorUp _object];
private _velocity = velocity _object;

[_positionWorld,_vectorDirAndUp,_velocity,_vectorDirAndUpRef,false] call Col_fnc_rotatePosRotVel;

[_mass,_positionWorld,_positionAGLZ,_modelHeight,_vectorDirAndUp,_velocity];
