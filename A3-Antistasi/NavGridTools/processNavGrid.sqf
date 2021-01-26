[] spawn
{
    fnc_getRoadConnections =
    {
        params ["_road"];

        //Find all connections to the road and cross out pedestrian rodes
        private _corrected = [];
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
                    _corrected pushBackUnique _roadAt;
                };
            };
        };
        [_connections, _corrected];
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

        mainGrid select _indexOne select 5 pushBack [_indexTwo, _roadConnectionType, _distance];
        mainGrid select _indexTwo select 5 pushBack [_indexOne, _roadConnectionType, _distance];
    };

    private _time = time;

    //Preprocessing phase, generate a simple nav grid out of the road data
    private _mainRoadSegments = nearestTerrainObjects [[worldSize/2, worldSize/2], ["MAIN ROAD", "ROAD", "TRACK"], worldSize, false, true];
    private _segmentsCount = count _mainRoadSegments;
    private _lastProcessed = 0;
    private _timeDiff = _time;
    //[Road segment, road type, connections]
    private _preGrid = [];
    private _corrections = [];

    {
        private _road = _x;
        private _connections = [_road] call fnc_getRoadConnections;
        {
            _corrections pushBack [_x, _road];
        } forEach (_connections select 1);
        private _roadName = [_road] call fnc_getRoadString;
        _preGrid pushBack [_road, [_road] call fnc_getRoadType, (_connections select 0)];
        private _connectionsCount = count (_connections select 0) + count (_connections select 1);

        if(_connectionsCount < 2) then
        {
            private _roadmarker = createMarker [format ["Marker%1", _roadName], getPos _road];
            _roadmarker setMarkerShape "ICON";
            _roadmarker setMarkerType "mil_triangle";
            _roadmarker setMarkerAlpha 1;
            _roadmarker setMarkerColor "ColorRed";
        };
        if(_connectionsCount > 2) then
        {
            private _roadmarker = createMarker [format ["Marker%1", _roadName], getPos _road];
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

    hintSilent "PREPROCESSING PHASE\n\nCleanup and finalising";

    {
        private _data = _x;
        private _index = _preGrid findIf {_x select 0 == _data select 0};
        if(_index != -1) then
        {
            (_preGrid select _index select 2) pushBackUnique (_data select 1);
        };
    } forEach _corrections;



    private _preTime = time - _time;
    hint format ["PREPROCESSING PHASE\n\nCompleted after %1 seconds\nStarting main phase now!", _preTime];
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
                        if(_counter >= 7) then
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
                        private _process = (1 - (_currentCount/_startCount));
                        _estimate = ((time - _preTime)/_process * (1 - _process));
                        hintSilent format
                        [
                            "MAINPROCESSING PHASE\n\nProgress: %1%2 (%3/%4)\nTime elapsed: %5 seconds\nEstimated time left: %6 seconds",
                            _process * 100,
                            "%",
                            (_startCount - _currentCount),
                            _startCount,
                            round (time - _preTime),
                            round (_estimate)
                        ];
                        _lastProcessed = _currentCount;
                    };
                };
            };
        };
        _gridNumber = _gridNumber + 1;
    };

    hint format ["MAINPROCESSING PHASE\n\nCompleted after %1 seconds\nStarting postprocessing phase now" , time - _time];

    private _finalisedGrid = [];
    private _removedIndexes = [];
    private _finalIndex = count mainGrid;

    {
        //[_roadName, _roadPos, _roadType, _isJunction, _gridNumber, []]
        //Connections as [roadName, roadType, distance]
        _x params ["_roadName", "_roadPos", "_roadType", "_isJunction", "_gridNumber", "_connections"];
        private _index = _forEachIndex;
        if !(_index in _removedIndexes) then
        {
            if(count _connections > 2) then
            {
                //Multi way cross detected, remove unneeded nodes
                private _allJunctionNodes = [];
                private _allJunctionIndex = [];
                private _openNodes = [_x];
                private _closedNodes = [];
                private _exitPoints = [];

                //Find all junction nodes connected
                while {count _openNodes > 0} do
                {
                    private _junctionNode = _openNodes deleteAt 0;
                    _closedNodes pushBack (_junctionNode select 0);
                    if(count (_junctionNode select 5) > 2) then
                    {
                        _allJunctionNodes pushBack _junctionNode;
                        private _currentIndex = missionNamespace getVariable [format ["Index%1", _junctionNode select 0], -1];
                        _allJunctionIndex pushBack _currentIndex;
                        {

                            private _junctionIndex = _x select 0;
                            private _distance = _x select 2;
                            if(_distance < 18) then
                            {
                                private _segment = (mainGrid select _junctionIndex);
                                if !((_segment select 0) in _closedNodes) then
                                {
                                    _openNodes pushBack _segment;
                                };
                            };
                        } forEach (_junctionNode select 5);
                    }
                    else
                    {
                        _exitPoints pushBack _junctionNode;
                    };
                };

                //Mark all junction nodes and calculate the midpoint
                private _midPoint = [0, 0, 0];
                {
                    _midPoint = _midPoint vectorAdd (_x select 1);
                } forEach _allJunctionNodes;
                _midPoint = _midPoint vectorMultiply (1/(count _allJunctionNodes));


                private _newConnections = [];
                {
                    private _connections = (_x select 5);
                    private _index = _connections findIf {_x select 0 in _allJunctionIndex};
                    if(_index != -1) then
                    {
                        (_x select 5 select _index) set [0, _finalIndex];
                        private _distance = (_x select 1) distance _midPoint;
                        (_x select 5 select _index) set [2, (_x select 1) distance _midPoint];
                        _newConnections pushBack [missionNamespace getVariable (format ["Index%1", _x select 0]), (_x select 5 select _index select 2), _distance];
                    };
                } forEach _exitPoints;

                private _roadmarker = createMarker [format ["Corrected%1", _finalIndex], _midPoint];
                _roadmarker setMarkerShape "ICON";
                _roadmarker setMarkerType "mil_dot";
                _roadmarker setMarkerAlpha 1;
                _roadmarker setMarkerColor "ColorRed";
                mainGrid pushBack ["", _midPoint, _roadType, true, _gridNumber, _newConnections];
                _finalIndex = _finalIndex + 1;

                _removedIndexes append _allJunctionIndex;
            };
        };
    } forEach mainGrid;

    {
        _x params ["_roadName", "_roadPos", "_roadType", "_isJunction", "_gridNumber", "_connections"];
        private _index = _forEachIndex;
        if !(_index in _removedIndexes) then
        {
            private _insertIndex = _finalisedGrid pushBack [_roadPos, _isJunction, _gridNumber, _connections];
            missionNamespace setVariable [format ["Conversion%1", _forEachIndex], _insertIndex];
        };
    } forEach mainGrid;

    {
        private _connections = _x select 3;
        {
            private _connectionID = _x select 0;
            private _newID = missionNamespace getVariable [format ["Conversion%1", _connectionID], -1];
            if(_newID != -1) then
            {
                _x set [0, _newID];
            }
            else
            {
                hint format ["Bad Connection %1, check the code again", _connectionID];
                sleep 5;
            };
        } forEach _connections;
    } forEach _finalisedGrid;

    private _finalisedGridCount = count _finalisedGrid;
    private _map = findDisplay 12 displayCtrl 51;
    {
        private _roadmarker = createMarker [format ["Marker%1", _forEachIndex], (_x select 0)];
        _roadmarker setMarkerShape "ICON";
        _roadmarker setMarkerAlpha 1;
        if(_x select 1) then
        {
            _roadmarker setMarkerColor "ColorGreen";
        }
        else
        {
            _roadmarker setMarkerColor "ColorGrey";
        };

        if(count (_x select 3) > 2) then
        {
            _roadmarker setMarkerType "mil_box";
        }
        else
        {
            if(count (_x select 3) == 1) then
            {
                _roadmarker setMarkerType "mil_triangle";
            }
            else
            {
                _roadmarker setMarkerType "mil_dot";
            };
        };

        private _thisNode = _x;
        private _thisPos = _x select 0;
        private _thisIndex = _forEachIndex;
        {
            private _conIndex = (_x select 0);

            if(_conIndex > _thisIndex) then
            {
                if(_conIndex >= _finalisedGridCount) then
                {
                    player globalChat format ["Node was %1", _thisNode];
                    sleep 3;
                }
                else
                {
                    private _conPos = _finalisedGrid select (_x select 0) select 0;
                    _map drawLine [_thisPos, _conPos, [1,1,0,1]];
                };
            };
        } forEach (_x select 3);
    } forEach _finalisedGrid;
};
