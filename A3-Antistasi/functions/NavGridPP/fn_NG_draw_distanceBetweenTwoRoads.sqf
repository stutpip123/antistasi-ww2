params ["_myRoad","_otherRoad","_markerID","_roadColourClassification","_realDistance"];

private _centre = (getPos _myRoad vectorAdd getPos _otherRoad) vectorMultiply 0.5;

private _name = "NGPP_dist_" + _markerID;
createMarkerLocal [_name,_centre];
_name setMarkerTypeLocal "mil_dot";
_name setMarkerTextLocal _realDistance;
_name setMarkerSizeLocal [0.01, 0.01];  // We do not want the dot to be visible.

private _types = _roadColourClassification#0;
private _colourScore = (_types find (getRoadInfo _myRoad #0)) max (_types find (getRoadInfo _otherRoad #0));
if (_colourScore == -1) then {
    _name setMarkerColor "ColorBlack";
} else {
    _name setMarkerColor (_roadColourClassification #1 #_colourScore);
};

_name;
