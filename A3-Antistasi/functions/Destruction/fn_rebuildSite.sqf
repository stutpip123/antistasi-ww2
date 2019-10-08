params ["_marker"];

server setVariable [format ["%1_destruct", _marker], 0];
server setVariable [format ["%1_locked", _marker], false];

//Delete all objects from the marker
_objects = server getVariable [format ["%1_objects", _marker], []];
{
    deleteVehicle _x;
} forEach _objects;

//Reset all buildings
_buildings = server getVariable [format ["%1_buildings", _marker], []];
{
    _x setDamage 0;
} forEach _buildings;

//Create new assets

//These buildings have space to place objects in them
//THESE ARE ALSO USED IN initDestructionObjects, UPDATE BOTH!
private _storageTypes =
[
  "Land_i_Shed_Ind_F", "Land_Shed_Small_F", "Land_Shed_Big_F", "Land_SM_01_shed_F",
  "Land_SM_01_shed_unfinished_F", "Land_SM_01_shelter_narrow_F", "Land_SM_01_shelter_wide_F"
];

_storageBuildings = nearestObjects [_markerPos, _storageTypes, _radius, true];


private _compObjects = [];

//Place objects, but max 3
_storageCount = count _storageBuildings min 3;

//Place the objects
for "_i" from 1 to _storageCount do
{
  //Select building and get needed infos
  private _storage = _storageBuildings deleteAt (round (random (_storageCount - 1)));
  _storageCount = _storageCount - 1;
  private _storPos = getPos _storage;
  private _storDir = getDir _storage;

  //Select composition and build it
  private _comp = selectRandom destructCompositions;
  _compObjects append ([_comp, _storPos, _storDir, _marker] spawn A3A_fnc_createDestructionComposition);
};
