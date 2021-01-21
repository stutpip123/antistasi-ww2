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

    fnc_setNavPointData =
    {
        params ["_roadName", "_roadPos", "_roadType", "_isJunction", "_gridNumber"];

        private _entryIndex = missionNamespace getVariable [format ["Index%1", _roadName], -1];
        if(_entryIndex == -1) then
        {
            mainGrid pushBack [_roadName, _roadPos, _roadType, _isJunction, _gridNumber, []];
            missionNamespace setVariable [format ["Index%1", _roadName], index, true];
            index = index + 1;
        };
    };

    fnc_setConnection =
    {
        params ["_nodeOne", "_nodeTwo"];

        private _indexOne = missionNamespace getVariable [format ["Index%1", [_nodeOne] call fnc_getRoadString], -1];
        private _indexTwo = missionNamespace getVariable [format ["Index%1", [_nodeTwo] call fnc_getRoadString], -1];

        if(_indexOne == -1 || _indexTwo == -1) exitWith {};

        private _roadConnectionType = (mainGrid select _indexOne select 2) min (mainGrid select _indexTwo select 2);
        private _distance = (mainGrid select _indexOne select 1) distance2D (mainGrid select _indexTwo select 1);

        mainGrid select _indexOne select 5 pushBack [[_nodeOne] call fnc_getRoadString, _roadConnectionType, _distance];
        mainGrid select _indexTwo select 5 pushBack [[_nodeTwo] call fnc_getRoadString, _roadConnectionType, _distance];
    };

    private _time = time;

    //Preprocessing phase, generate a simple nav grid out of the road data
    private _mainRoadSegments = nearestTerrainObjects [[worldSize/2, worldSize/2], ["MAIN ROAD", "ROAD", "TRACK"], worldSize, false, true];
    private _segmentsCount = count _mainRoadSegments;
    private _lastProcessed = 0;
    private _timeDiff = _time;
    //[Road segment, road type, connections]
    private _preGrid = [];

    {
        private _connections = [_x] call fnc_getRoadConnections;
        private _roadName = [_x] call fnc_getRoadString;
        _preGrid pushBack [_x, [_x] call fnc_getRoadType, _connections];
        private _connectionsCount = count _connections;

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
        };
        if(time - _timeDiff > 0.5) then
        {
            _timeDiff = time;
            hintSilent format
            [
                "PREPROCESSING PHASE\n\nProgress: %1%2 (%3/%4)\nTime elapsed: %5 seconds\nEstimated time left: %6 seconds",
                (_forEachIndex/_segmentsCount) * 100,
                "%",
                _forEachIndex,
                _segmentsCount,
                round (time - _time),
                round ((_segmentsCount - _forEachIndex)/(_forEachIndex - _lastProcessed) * 0.5)
            ];
            _lastProcessed = _forEachIndex;
        };
    } forEach _mainRoadSegments;



    private _preTime = time - _time;
    hint format ["Preprocessing done after %1 seconds\nStarting main phase now!", _preTime];
    sleep 3;
    _preTime = _preTime + 3;

    private _gridNumber = 0;
    private _junctions = [];
    private _startCount = count _preGrid;
    private _estimate = 0;
    _timeDiff = time;
    _lastProcessed = 0;
    mainGrid = [];
    index = 0;

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

        //Start segment found, set all connections as open segments and node as nav connection
        [[_startSegment select 0] call fnc_getRoadString, getPos (_startSegment select 0), (_startSegment select 1), true, _gridNumber] call fnc_setNavPointData;

        private _openSegments = [];
        {
            private _connection = _x;
            private _index = _preGrid findIf {_x select 0 == _connection};
            if(_index != -1) then
            {
                private _connectedSegment = _preGrid deleteAt _index;
                _connectedSegment pushBack 0;
                _connectedSegment pushBack (_startSegment select 0);
                _openSegments pushBack _connectedSegment;
            };
        } forEach (_startSegment select 2);

        private _roadName = [(_startSegment select 0)] call fnc_getRoadString;
        deleteMarker format ["Marker%1", _roadName];
        private _roadmarker = createMarker [format ["MarkerStart%1", _roadName], getPos (_startSegment select 0)];
        _roadmarker setMarkerShape "ICON";
        _roadmarker setMarkerType "mil_dot";
        _roadmarker setMarkerAlpha 1;
        _roadmarker setMarkerColor "ColorBlue";
        _roadmarker setMarkerText format ["Connections: %1", count (_startSegment select 2)];

        while {count _openSegments > 0} do
        {
            private _segment = _openSegments deleteAt 0;
            private _lastSegment = _segment select 4;

            if(missionNamespace getVariable [format ["Index%1", [_segment select 0] call fnc_getRoadString], -1] <= 0) then
            {
                //Segment not already worked on
                while {_segment isEqualType []} do
                {
                    _segment params ["_roadSegment", "_roadType", "_connections", "_counter" , "_lastConnection"];
                    private _roadName = [_roadSegment] call fnc_getRoadString;
                    deleteMarker format ["Marker%1", _roadName];

                    if(count _connections != 2) then
                    {
                        //Either crossroad or dead end, mark detailed and as junction
                        _counter = 0;
                        //private _roadmarker = createMarker [format ["Marker%1", _roadName], getPos _roadSegment];
                        //_roadmarker setMarkerShape "ICON";
                        //_roadmarker setMarkerAlpha 1;

                        //Save junctions for postprocessing
                        //if(count _connections > 2) then
                        //{
                        //    _roadmarker setMarkerType "mil_box";
                        //    _roadmarker setMarkerColor "ColorGreen";
                        //}
                        //else
                        //{
                        //    _roadmarker setMarkerType "mil_triangle";
                        //    _roadmarker setMarkerColor "ColorGreen";
                        //};

                        //Mark connection
                        [_roadName, getPos _roadSegment, _roadType, true, _gridNumber] call fnc_setNavPointData;
                        [_roadSegment, _lastConnection] call fnc_setConnection;

                        //Update connection data
                        _lastConnection = _roadSegment;

                        {
                            private _connection = _x;
                            private _index = _preGrid findIf {_x select 0 == _connection};
                            if(_index != -1) then
                            {
                                private _connectedSegment = _preGrid deleteAt _index;
                                _connectedSegment pushBack (_counter + 1);
                                _connectedSegment pushBack _lastConnection;
                                _openSegments pushBack _connectedSegment;
                            }
                            else
                            {
                                if(missionNamespace getVariable [format ["Index%1", [_connection] call fnc_getRoadString], -1] != -1) then
                                {
                                    [_roadSegment, _connection] call fnc_setConnection;
                                };
                            };
                        } forEach _connections;

                        _segment = objNull;
                    }
                    else
                    {
                        //Normal street
                        if(_counter >= 5) then
                        {
                            //Reached limit, mark detailed without junction
                            _counter = 0;
                            //private _roadmarker = createMarker [format ["Marker%1", _roadName], getPos _roadSegment];
                            //_roadmarker setMarkerShape "ICON";
                            //_roadmarker setMarkerType "mil_dot";
                            //_roadmarker setMarkerAlpha 1;
                            //_roadmarker setMarkerColor "ColorGrey";

                            //Mark connection
                            [_roadName, getPos _roadSegment, _roadType, false, _gridNumber] call fnc_setNavPointData;
                            [_roadSegment, _lastConnection] call fnc_setConnection;

                            //Update connection data
                            _lastConnection = _roadSegment;
                        };

                        private _nextConnection = _connections select 0;
                        if(_nextConnection == _lastSegment) then
                        {
                            _nextConnection = _connections select 1;
                        };

                        _lastSegment = _roadSegment;
                        private _index = _preGrid findIf {_x select 0 == _nextConnection};
                        if(_index != -1) then
                        {
                            _segment = _preGrid deleteAt _index;
                            _segment pushBack (_counter + 1);
                            _segment pushBack _lastConnection;
                        }
                        else
                        {
                            _segment = objNull;
                        };
                    };
                    if(time - _timeDiff > 0.5) then
                    {
                        _timeDiff = time;
                        private _currentCount = count _preGrid;
                        _estimate = round (0.95 * _estimate + 0.05 * round (_currentCount/((_lastProcessed - _currentCount) max 1) * 0.5));
                        hintSilent format
                        [
                            "MAINPROCESSING PHASE\n\nProgress: %1%2 (%3/%4)\nTime elapsed: %5 seconds\nEstimated time left: %6 seconds",
                            (1 - (_currentCount/_startCount)) * 100,
                            "%",
                            (_startCount - _currentCount),
                            _startCount,
                            round (time - _preTime),
                            round (_estimate * (0.8 * (1 - (_currentCount/_startCount)) + 0.2))
                        ];
                        _lastProcessed = _currentCount;
                    };
                };
            };
        };
        _gridNumber = _gridNumber + 1;
    };

    hint format ["Mainprocessing done after %1 seconds" , time - _time];
};
