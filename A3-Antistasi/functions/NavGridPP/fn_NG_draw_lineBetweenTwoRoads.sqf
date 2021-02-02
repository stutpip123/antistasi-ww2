params ["_myRoad","_otherRoad","_markerID","_roadColourClassification"];

private _myPos = getPos _myRoad;
private _otherPos = getPos _otherRoad;

private _length = _myPos distance2D _otherPos;
private _azimuth = _myPos getDir _otherPos;
private _centre = (_myPos vectorAdd _otherPos) vectorMultiply 0.5;

private _name = "NGPP_line_" + _markerID;
private _marker = createMarkerLocal [_name, _centre];
_marker setMarkerDirLocal _azimuth;
_marker setMarkerSizeLocal [1, 0.5*_length];
_marker setMarkerShapeLocal "RECTANGLE";
//_marker setMarkerBrushLocal "Solid";
_marker setMarkerBrushLocal "SolidFull";

private _types = _roadColourClassification#0;
private _colourScore = (_types find (getRoadInfo _myRoad #0)) max (_types find (getRoadInfo _otherRoad #0));
/*
if (_colourScore == -1) then {
    _marker setMarkerColor "ColorBlack";
} else {
    _marker setMarkerColor (_roadColourClassification #1 #_colourScore);
};
*/
_marker setMarkerColor selectRandom ["ColorBlack","ColorGrey","ColorRed","ColorBrown","ColorOrange","ColorYellow","ColorKhaki","ColorGreen","ColorBlue","ColorPink","ColorWhite","ColorWEST","ColorEAST","ColorGUER","ColorCIV","ColorUNKNOWN","colorBLUFOR","colorOPFOR","colorIndependent","colorCivilian","Color1_FD_F","Color2_FD_F","Color3_FD_F","Color4_FD_F","Color5_FD_F","Color6_FD_F"];

_marker;

