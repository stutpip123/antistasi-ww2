params ["_myRoad","_myName","_otherRoad","_otherName","_roadColourClassification","_realDistance"];

private _myPos = getPos _myRoad;
private _otherPos = getPos _otherRoad;

private _length = _myPos distance2D _otherPos;
private _azimuth = _myPos getDir _otherPos;
private _centre = (_myPos vectorAdd _otherPos) vectorMultiply 0.5;

private _name = "NGPP_line_" + _myName + _otherName;
private _marker = createMarkerLocal [_name, _centre];
_marker setMarkerDirLocal _azimuth;
_marker setMarkerSizeLocal [10, 0.5*_length];
_marker setMarkerTextLocal _realDistance;
_marker setMarkerShapeLocal "RECTANGLE";
_marker setMarkerBrushLocal "SOLID";

private _types = _roadColourClassification#0;
private _colourScore = (_types find (getRoadInfo _myRoad #0)) max (_types find (getRoadInfo _otherRoad #0));
if (_colourScore == -1) then {
    _marker setMarkerColor "ColorBlack";
} else {
    _marker setMarkerColor (_roadColourClassification #1 #_colourScore);
};

_marker;
