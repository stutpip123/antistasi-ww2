[] spawn
{
private _time = time;
private _mainRoadSegments = nearestTerrainObjects [[worldSize/2, worldSize/2], ["MAIN ROAD", "ROAD", "TRACK"], worldSize, false, true];
hint format ["Found %1 road segments", count _mainRoadSegments];
private _correctedCount = 0;

{
    private _road = _x;
    private _connections = roadsConnectedTo [_road, true];
    _connections = _connections select {(getRoadInfo _x) select 0 != "TRAIL"};
    private _corrected = false;
    if(count _connections == 1) then
    {
        private _connected = _connections select 0;
        private _dir = _connected getDir _road;
        for "_distance" from 3 to 15 do
        {
            private _pos = (getPos _road) getPos [_distance, _dir];
            private _roadAt = roadAt _pos;
            if(!(isNull _roadAt) && {_roadAt != _road}) exitWith
            {
                _connections pushBack _roadAt;
                _corrected = true;
            };
        };
    };
    _connections = count _connections;

    if(_corrected) then
    {
        _correctedCount = _correctedCount + 1;
        private _roadmarker = createMarker [format ["Road%1", _foreachIndex], getPos _x];
        _roadmarker setMarkerShape "ICON";
        _roadmarker setMarkerType "mil_dot";
        _roadmarker setMarkerAlpha 1;
        _roadmarker setMarkerText "Corrected";
        _roadmarker setMarkerColor "ColorRed";
        sleep 0.01;
    };
    if(_connections < 2) then
    {
        private _roadmarker = createMarker [format ["Road%1", _foreachIndex], getPos _x];
        _roadmarker setMarkerShape "ICON";
        _roadmarker setMarkerType "mil_triangle";
        _roadmarker setMarkerAlpha 1;
        _roadmarker setMarkerText format ["Dead End: %1", _connections];
        _roadmarker setMarkerColor "ColorOrange";
        sleep 0.01;
    };
    if(_connections > 2) then
    {
        private _roadmarker = createMarker [format ["Road%1", _foreachIndex], getPos _x];
        _roadmarker setMarkerShape "ICON";
        _roadmarker setMarkerType "mil_box";
        _roadmarker setMarkerAlpha 1;
        _roadmarker setMarkerText format ["Crossroad: %1", _connections];
        _roadmarker setMarkerColor "ColorGrey";
        sleep 0.01;
    }
} forEach _mainRoadSegments;

_time = time - _time;
hint format ["Marker set\nCorrected marker: %1\nTime used: %2", _correctedCount, _time];
};
