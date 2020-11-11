[] spawn
{
    fnc_setDetailedPointData =
    {
        params ["_road", ["_setMarker", true]];

        if !(_setMarker) exitWith {};
        private _roadmarker = createMarker [format ["Road%1", Random 100000], getPos _road];
        _roadmarker setMarkerShape "ICON";
        _roadmarker setMarkerType "mil_dot";
        _roadmarker setMarkerAlpha 1;
        _roadmarker setMarkerText "Normal";
        _roadmarker setMarkerColor "ColorGrey";
    };

    fnc_setJunctionPointData =
    {
        params ["_road", ["_isJunction", true]];

        private _roadmarker = createMarker [format ["Road%1", Random 100000], getPos _road];
        _roadmarker setMarkerShape "ICON";
        _roadmarker setMarkerType "mil_dot";
        _roadmarker setMarkerAlpha 1;
        if(_isJunction) then
        {
            _roadmarker setMarkerText "Junction";
        }
        else
        {
            _roadmarker setMarkerText "Dead End";
        };

        _roadmarker setMarkerColor "ColorOrange";

        [_road, false] call fnc_setDetailedPointData;
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
    };

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

    fnc_getJunctionData =
    {
        params ["_lastSegment", "_road", "_connections"];

        private _exitPoints = [_lastSegment];

        private _allJunctionNodes = [_road];
        private _nodesToCheck = +_connections;

        //Gather all nodes that have at least
        while {count _nodesToCheck > 0} do
        {
            private _nodeToCheck = _nodesToCheck deleteAt 0;
            private _connections = [_nodeToCheck] call fnc_getRoadConnections;

            private _connectionCount = count _connections;
            if(_connectionCount <= 2) then
            {
                _exitPoints pushBack _nodeToCheck;
            }
            else
            {
                {
                    if(!(_x in _allJunctionNodes) && !(_x in _exitPoints) && !(_x in _nodesToCheck)) then
                    {
                        _nodesToCheck pushBack _x;
                    };
                } forEach _connections;
            };
        };

        //All nodes gathered, now make sure that this is a complete junction, not two merged into each other
        private _canMergeNodes = [[]];
        {
            private _node = _x;
            private _inserted = false;
            {
                private _subArray = _x;
                if(count _subArray == 0) then
                {
                    _subArray pushBack _node;
                }
                else
                {
                    {
                        if([_x, _node] call fnc_isNodeMergable) exitWith
                        {
                            _subArray pushBack _node;
                            _inserted = true;
                        };
                    } forEach _subArray;
                };
            } forEach _canMergeNodes;
            if !(_inserted) then
            {
                _canMergeNodes pushBack [_node];
            };
        } forEach _allJunctionNodes;

        //Now create the data for all found junctions

    };

    fnc_isNodeMergable =
    {
        params ["_node1", "_node2"];

        private _connectionsNode1 = [_node1] call fnc_getRoadConnections;
        private _connectionsNode2 = [_node2] call fnc_getRoadConnections;

        private _intersection1 = (_connectionsNode1 - _connectionsNode2) - [_node1, _node2];
        private _intersection2 = (_connectionsNode2 - _connectionsNode1) - [_node1, _node2];

        private _result = false;
        if((count _intersection1) == 1 && (count _intersection2) == 1) then
        {
            _result = true;
        };
        _result;
    };


    private _time = time;
    private _mainRoadSegments = nearestTerrainObjects [[worldSize/2, worldSize/2], ["MAIN ROAD", "ROAD", "TRACK"], worldSize, false, true];
    private _roadCount = count _mainRoadSegments;
    hint format ["Found %1 road segments", _roadCount];

    if(_roadCount == 0) exitWith
    {
        hint "Found no road segments at all!";
    };

    private _checkedSegments = [];
    private _gridNumber = 0;
    private _openSegments = [];

    while {count _checkedSegments < _roadCount} do
    {
        {
            if !(_x in _checkedSegments) exitWith
            {
                //Needs to be saved as junction for data health
                [_x] call fnc_setJunctionPointData;
                //_openSegments pushBack [_x, _gridNumber, objNull, _x];
                //Create junction from point
                private _connections = [_x] call fnc_getRoadConnections;
                if(count _connections != 2) then
                {
                    //Junction or dead end, save to both grids

                    if(count _connections == 1) then
                    {
                        hint "Start is a dead end!";
                        //Dead end, use only the one connection as start point
                        _openSegments pushBack [_connections select 0, _gridNumber, _x, _x, [_connections select 0] call fnc_getRoadType];


                    }
                    else
                    {
                        hint "Start is a junction!";
                    };
                }
                else
                {
                    hint "Start is a normal road!";
                    _openSegments pushBack [_connections select 0, _gridNumber, _x, _x, [_connections select 0] call fnc_getRoadType];
                    _openSegments pushBack [_connections select 1, _gridNumber, _x, _x, [_connections select 1] call fnc_getRoadType];
                };
                _checkedSegments pushBack _x;
            };
        } forEach _mainRoadSegments;

        while {count _openSegments > 0} do
        {
            private _currentSegmentData = _openSegments deleteAt 0;
            _currentSegmentData params ["_currentSegment", "_gridNumber", "_previousJunctionPoint", "_previousDetailedPoint", "_roadType"];
            private _lastSegment = _previousDetailedPoint;

            for "_counter" from 1 to 5 do
            {
                //Block against further calculation
                _checkedSegments pushBack _currentSegment;

                //Get road connections
                private _connections = [_currentSegment] call fnc_getRoadConnections;

                //Filter out other blocked segments
                _connections = _connections select {!(_x in _checkedSegments)};
                private _connectionCount = count _connections;


                if(_connectionCount == 0) exitWith
                {
                    //Found a dead end, set marker
                    [_currentSegment, false] call fnc_setJunctionPointData;
                };

                if(_connectionCount > 1) exitWith
                {
                    //Search for junction then see what needs to be done
                };

                if(_connectionCount == 1) then
                {
                    //Normal road, just follow
                    if(_counter == 5) then
                    {
                        //Steps reached, set data
                        [_currentSegment] call fnc_setDetailedPointData;
                        _openSegments pushBack [_connections select 0, _gridNumber, _previousJunctionPoint, _currentSegment, [_connections select 0] call fnc_getRoadType];
                    };
                    _lastSegment = _currentSegment;
                    _currentSegment = _connections select 0;

                };
            };
        };

        _gridNumber = _gridNumber + 1;

        if (true) exitWith {};
    };


};
