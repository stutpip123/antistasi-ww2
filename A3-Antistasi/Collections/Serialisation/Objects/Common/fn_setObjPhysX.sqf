/*
Author: Caleb Serafin
    Applies PhyX data to object.

Arguments:
    <OBJECT> Object
    <
        <SCALAR> _mass
        <VEC3D> _positionWorld
        <SCALAR> _positionAGLZ
        <SCALAR> _modelHeight
        <VEC3D,VEC3D> _vectorDirAndUp
        <VEC3D> _velocity
    > physXData
    <
        <POS3D> positionWorld Reference
        <VEC3D,VEC3D> vectorDirAndUp Reference.
        <BOOLEAN> _usePositionAGL.
    > physXDataRef

Return Value:
    <BOOLEAN> true if successful; nil if crash.

Scope: Single Machine, effect is global.
Environment: Any.
Public: Yes

Example:
*/
params [
    ["_object",objNull,[objNull]],
    ["_physXData",[],[ [] ], [6]],
    ["_physXDataRef",[],[ [] ], [2]]
];
_physXData params [
    ["_mass",nil,[ 0 ]],
    ["_positionWorld",[0,0,0],[ [] ], [3]],
    ["_positionAGLZ",[0,0,0],[ [] ], [3]],
    ["_modelHeight",10,[ 0 ]],  // Safe number so that model does not clip into ground if problem with loading value.
    ["_vectorDirAndUp",[[0,0,0],[0,0,0]],[ [] ], [2]],
    ["_velocity",[0,0,0],[ [] ], [3]]
];
_physXDataRef params [
    ["_positionWorldRef",[0,0,0],[ [] ],[3]],
    ["_vectorDirAndUpRef",[[0,0,0],[0,0,0]],[ [] ],[2]],
    ["_usePositionAGL",false,[ false ]]
];

[_positionWorld,_vectorDirAndUp,_velocity,_vectorDirAndUpRef,true] call Col_fnc_rotatePosRotVel;
_object setMass _mass;
_positionWorld = _positionWorld vectorAdd _positionWorldRef;
if (_usePositionAGL) then { _positionWorld set [2,_positionAGLZ + _modelHeight] };
_object setPosWorld _positionWorld;
_object setVectorDirAndUp _vectorDirAndUp;
_object setVelocity _velocity;

true;
