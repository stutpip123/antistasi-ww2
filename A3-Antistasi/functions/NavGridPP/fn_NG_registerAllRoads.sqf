params [
    ["_registerNS",locationNull,[locationNull]]
];

private _halfWorldSize = worldSize/2;
private _worldCentre = [_halfWorldSize,_halfWorldSize];
private _worldMaxRadius = sqrt(0.5 * (worldSize^2));

private _allRoadSegments = nearestTerrainObjects [_worldCentre, ["ROAD", "MAIN ROAD", "TRACK"], _worldMaxRadius, false, true];  // _worldCentre nearRoads _worldMaxRadius;
{
    _registerNS setVariable [str _x,_x]     // str roadSegment == "164390: " // We will not strip the pointless `: ` from the end to save performance.
} forEach _allRoadSegments;

_allRoadSegments;
