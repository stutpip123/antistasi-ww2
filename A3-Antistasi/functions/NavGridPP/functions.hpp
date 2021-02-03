class A3A {
    class NavGridPP {
        class NG_convert_navIslands_navGridDB {};
        class NG_convert_navGridDB_navIslands {};
        class NG_draw_distanceBetweenTwoRoads {};
        class NG_draw_dotOnRoads {};
        class NG_draw_lineBetweenTwoRoads {};
        class NG_draw_linesBetweenRoads {};
        class NG_main {};
        class NG_mergeIslands {};
        class NG_missingRoadCheck {};
        class NG_separateIslands {};
        class NG_simplify_conDupe {};
        class NG_simplify_flat {};
        class NG_simplify_junc {};
    };
    class UI {
        class customHint {};
        class customHintDismiss {};
        class customHintInit {};
        class customHintRender {};
        class shader_ratioToHex {};
    };
    class Utility {
        class log {};
    };
};

class Collections
{
    tag = "Col";
    class Collections_Array
    {
        file="Collections\Array";
        class array_deleteAts {};
        class array_displace {};
        class array_remIndices {};
    };
    class Collections_ID
    {
        file="Collections\ID";
        class ID_init { preInit = 1 };
        class ID_LArray_isEqualTo {};
        class ID_LArray {};
    };
    class Collections_Location
    {
        file="Collections\Location";
        class location_init { preInit = 1 };
        class location_new {};
        class location_serialiseAddress {};
    };
    class Collections_NestLoc
    {
        file="Collections\NestLoc";
        class nestLoc_get {};
        class nestLoc_rem {};
        class nestLoc_set {};
    };
    class Collections_Serialisation_Primitives
    {
        file="Collections\Serialisation\Primitives";
        class serialise_namespace {};
    };
};