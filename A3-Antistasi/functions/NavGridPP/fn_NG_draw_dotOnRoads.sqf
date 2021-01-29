params [
    ["_navGrids",[],[ [] ]] //<ARRAY< island ARRAY<Road,connections ARRAY<Road>>  >>
];

private _markers = [localNamespace,"A3A_NGPP","draw","dotOnRoads",[]] call Col_fnc_nestLoc_get;
{
    deleteMarker _x;
} forEach _markers;
_markers resize 0;  // Preserves reference

{
    private _island = str _forEachIndex;
    {
        if (count (_x#1) != 2) then { // Ignore non-junction roads
            private _name = "NGPP_dot_" + str (_x#0);
            _markers pushBack createMarkerLocal [_name,getPosWorld (_x#0)];
            _name setMarkerTypeLocal "mil_dot";
            _name setMarkerSizeLocal [0.4, 0.4];
            _name setMarkerTextLocal _island;
            _name setMarkerColor (switch (count (_x#1)) do { // Broadcasts here
                case 0: { "ColorBlack" };
                case 1: { "ColorRed" };
                //case 2: { "ColorOrange" };
                case 3: { "ColorYellow" };
                case 4: { "ColorGreen" };
                default { "ColorBlue" };
            });
        };
    } forEach _x;   // island ARRAY<Road,connections ARRAY<Road>>  // _x is <Road,connections ARRAY<Road>>
} forEach _navGrids; //<ARRAY< island ARRAY<Road,connections ARRAY<Road>>  >>// _x is <island ARRAY<Road,connections ARRAY<Road>>>

[localNamespace,"A3A_NGPP","draw","dotOnRoads",_markers] call Col_fnc_nestLoc_set;