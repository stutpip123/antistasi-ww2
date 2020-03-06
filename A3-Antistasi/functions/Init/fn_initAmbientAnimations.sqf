briefingAnims = [];
{
    briefingAnims append ((_x call BIS_fnc_ambientAnimGetParams) select 0);
} forEach ["BRIEFING", "BRIEFING_POINT_LEFT", "BRIEFING_POINT_RIGHT", "BRIEFING_POINT_TABLE"];

listeningAnims = [];
{
    listeningAnims append ((_x call BIS_fnc_ambientAnimGetParams) select 0);
} forEach ["STAND1", "GUARD", "LISTEN_BRIEFING"];

repairAnims = [];
{
    repairAnims append ((_x call BIS_fnc_ambientAnimGetParams) select 0);
} forEach ["REPAIR_VEH_PRONE", "REPAIR_VEH_KNEEL", "REPAIR_VEH_STAND"];

publicVariable "briefingAnims";
publicVariable "listeningAnims";
publicVariable "repairAnims";
