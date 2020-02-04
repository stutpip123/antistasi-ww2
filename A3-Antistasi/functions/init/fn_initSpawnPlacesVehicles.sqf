#define SPACING     2

params ["_vehicleMarker"];

/*  Calculates and searches for vehicle spawn places
*
*
*/

private _fileName = "initSpawnPlacesVehicles";
private _vehicles = [];
{
    private _marker = _x;
    private _size = getMarkerSize _marker;
    private _length = (_size select 0) * 2;
    private _width = (_size select 1) * 2;
    if(_width < (4 + 2 * SPACING)) then
    {
        [
            1,
            format ["Marker %1 is not wide enough for vehicles, required are %2 meters!", _x , (4 + 2 * SPACING)],
            _fileName
        ] call A3A_fnc_log;
    }
    else
    {
        if(_length < 10) then
        {
            [
                1,
                format ["Marker %1 is not long enough for vehicles, required are 10 meters!", _x],
                _fileName
            ] call A3A_fnc_log;
        }
        else
        {
            //Cleaning area
            private _radius = sqrt (_length * _length + _width * _width);
            {
                if((getPos _x) inArea _marker) then
                {
                    _x hideObjectGlobal true;
                };
            } foreach (nearestTerrainObjects [getMarkerPos _marker, ["Tree","Bush", "Hide", "Rock", "Fence"], _radius, true]);

            //Create the places
            private _vehicleCount = floor ((_length - SPACING) / (4 + SPACING));
            private _realLength = _vehicleCount * 4;
            private _realSpace = (_length - _realLength) / (_vehicleCount + 1);
            private _markerDir = markerDir _marker;
            for "_i" from 1 to _vehicleCount do
            {
                //Wow, I should have commented that, as I was writing this, no clue how this works, sorry
                private _dis = (_realSpace + 2 + ((_i - 1) * (4 + _realSpace))) - (_length / 2);
                private _pos = [getMarkerPos _marker, _dis, (_markerDir + 90)] call BIS_fnc_relPos;
                _pos set [2, ((_pos select 2) + 0.1) max 0.1];
                _vehicles pushBack [[_pos, _markerDir], false];
            };
        };
    };
} forEach _vehicleMarker;

_vehicles;
