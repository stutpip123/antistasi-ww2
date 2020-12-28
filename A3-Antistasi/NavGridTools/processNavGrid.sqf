[] spawn
{
    fnc_getRoadConnections =
    {
        params ["_road"];

        //Find all connections to the road and cross out pedestrian rodes
        private _connections = roadsConnectedTo [_road, true];
        _connections = _connections select {(getRoadInfo _x) select 0 != "TRAIL"};

        //If this seems to be a dead end, search ahead of the road to see if there are more road segments
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
                    _connections pushBackUnique _roadAt;
                };
            };
        };
        _connections;
    };

    fnc_getRoadType =
    {
        params ["_road"];

        private _type = (getRoadInfo _road) select 0;
        private _result = 0;
        switch (_type) do
        {
            case ("MAIN ROAD"):
            {
                _result = 2;
            };
            case ("ROAD"):
            {
                _result = 1;
            };
        };

        _result;
    };

    fnc_getRoadString =
    {
        params ["_road"];

        _roadNameFull = str _road;
        _stringArray = _roadNameFull splitString ":";

         private _result = _stringArray select 0;
        _result;
    };


    private _time = time;

    //Preprocessing phase, generate a simple nav grid out of the road data
    private _mainRoadSegments = nearestTerrainObjects [[worldSize/2, worldSize/2], ["MAIN ROAD", "ROAD", "TRACK"], worldSize, false, true];
    private _preGrid = [];

    {
        private _connections = [_x] call fnc_getRoadConnections;
        private _roadName = [_x] call fnc_getRoadString;
        //[Road segment, position, road type, connections]
        _preGrid pushBack [_x, [_x] call fnc_getRoadType, _connections];
        private _connectionsCount = count _connections;

        if(_connectionsCount == 2) then
        {
            private _roadmarker = createMarker [format ["Marker%1", _roadName], getPos _x];
            _roadmarker setMarkerShape "ICON";
            _roadmarker setMarkerType "mil_dot";
            _roadmarker setMarkerAlpha 1;
            _roadmarker setMarkerColor "ColorGrey";
        };
        if(_connectionsCount < 2) then
        {
            private _roadmarker = createMarker [format ["Marker%1", _roadName], getPos _x];
            _roadmarker setMarkerShape "ICON";
            _roadmarker setMarkerType "mil_triangle";
            _roadmarker setMarkerAlpha 1;
            _roadmarker setMarkerColor "ColorRed";
        };
        if(_connectionsCount > 2) then
        {
            private _roadmarker = createMarker [format ["Marker%1", _roadName], getPos _x];
            _roadmarker setMarkerShape "ICON";
            _roadmarker setMarkerType "mil_box";
            _roadmarker setMarkerAlpha 1;
            _roadmarker setMarkerColor "ColorOrange";
        }
    } forEach _mainRoadSegments;

    hint format ["Preprocessing done after %1 seconds", time - _time];

    private _gridNumber = 0;

    //Mainprocessing phase, reduce the raw nav grid to a less detailed one
    while {true} do
    {
        private _startSegment = objNull;
        //Search for starting segment
        if (count _preGrid > 0) then
        {
            _startSegment = _preGrid deleteAt 0;
        };

        if(_startSegment isEqualType objNull) exitWith {};

        _startSegment pushBack 0;
        _startSegment pushBack (_startSegment select 0);
        _startSegment pushBack (_startSegment select 0);

        private _openSegments = [_startSegment];

        while {count _openSegments > 0} do
        {
            private _segment = _openSegments deleteAt 0;
            _segment params ["_roadSegment", "_roadType", "_connections", "_counter" , "_lastJunction", "_lastNormal"];
            private _roadName = [_roadSegment] call fnc_getRoadString;
            deleteMarker format ["Marker%1", _roadName];

            if(count _connections != 2) then
            {
                //Either crossroad or dead end, mark detailed and as junction
                _counter = 0;
                private _roadmarker = createMarker [format ["Marker%1", _roadName], getPos _roadSegment];
                _roadmarker setMarkerShape "ICON";
                _roadmarker setMarkerType "mil_triangle";
                _roadmarker setMarkerAlpha 1;
                _roadmarker setMarkerColor "ColorRed";

                //Mark, draw connection to _lastJunction and _lastNormal, then update these

                _lastJunction = _roadSegment;
                _lastNormal = _roadSegment;
            }
            else
            {
                //Normal street
                if(_counter >= 5) then
                {
                    //Reached limit, mark detailed without junction
                    _counter = 0;
                    private _roadmarker = createMarker [format ["Marker%1", _roadName], getPos _roadSegment];
                    _roadmarker setMarkerShape "ICON";
                    _roadmarker setMarkerType "mil_dot";
                    _roadmarker setMarkerAlpha 1;
                    _roadmarker setMarkerColor "ColorGrey";

                    //Mark, draw connection to _lastNormal, then update it

                    _lastNormal = _roadSegment;
                };
            };

            {
                private _connection = _x;
                private _index = _preGrid findIf {_x select 0 == _connection};
                if(_index != -1) then
                {
                    private _connectedSegment = _preGrid deleteAt _index;
                    _connectedSegment pushBack (_counter + 1);
                    _connectedSegment pushBack _lastJunction;
                    _connectedSegment pushBack _lastNormal;
                    _openSegments pushBack _connectedSegment;
                };
            } forEach _connections;
        };

        _gridNumber = _gridNumber + 1;
    };

    hint format ["Mainprocessing done after %1 seconds" , time - _time];
};
