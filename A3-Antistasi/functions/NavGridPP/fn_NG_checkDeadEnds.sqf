params [
    ["_navGrids",[],[ [] ]],  // ARRAY<ARRAY<segmentStruct>>
    ["_deadEndIndices",[],[ [] ]]  // ARRAY<ARRAY<index>>  // islands must be in same order
];



private _segmentAzimuth = 0;
private _startDistance = 3;
if (isNull _parentSegment) then {   // Well, we have a single road island, we will have to work in both directions.
    private _roadInfo = getRoadInfo _currentSegment;
    _segmentAzimuth = (_roadInfo#6) getDir (_roadInfo#7);
    _startDistance = -15;  // Look behind as well.
};

private _missingSegment = objNull;
private _segmentPos = getPos _currentSegment;
_segmentAzimuth = _parentSegment getDir _currentSegment;
for "_distance" from _startDistance to 15 step 3 do
{
    _missingSegment = roadAt (_segmentPos getPos [_distance,_segmentAzimuth]);
    if (!isNull _missingSegment && {!(_missingSegment isEqualTo _currentSegment)}) exitWith {};
};

if (!isNull _missingSegment) then {
    _currentConnections pushBack _missingSegment;
    if (_unprocessedNS getVariable [str _missingSegment, false]) then {

    } else {

    };
};

if (_unprocessedNS getVariable [str _missingSegment, false]) then {  // will be false if _missingSegment is null.
    _parentSegment = _currentSegment;
    _currentSegment = _missingSegment;
} else {
    _parentSegment = objNull;   // If already processed or null: Jump back to last junction.
    _currentSegment = _lastUnexploredJunctions deleteAt 0
};
