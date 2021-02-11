class A3A_NG_import_dialogue {
    idd = -1;
    access = 0;
    movingEnable = true;
    enableSimulation = false;
    class Controls {
        class GreyBox {
            type = CT_STATIC;
            style = ST_CENTER;
            shadow = 2;
            colorText[] = {1,1,1,1};
            font = "PuristaMedium";
            sizeEx = 0.02;
            colorBackground[] = { 0.2,0.2,0.2, 0.9 };

            idc = -1;
            text = "";
            x = 0.244979 * safezoneW + safezoneX;
            y = 0.223941 * safezoneH + safezoneY;
            w = 0.445038 * safezoneW;
            h = 0.20 * safezoneH;//30
        };

        class Frame {

            type = CT_STATIC;
            style = ST_FRAME;
            shadow = 2;
            colorBackground[] = {1,1,1,1};//{1,1,1,1}
            colorText[] = {1,1,1,0.9};
            font = "PuristaMedium";
            sizeEx = 0.03;

            idc = -1;
            text = "Import navGridDB";
            x = 0.254979 * safezoneW + safezoneX;
            y = 0.233941 * safezoneH + safezoneY;
            w = 0.425038 * safezoneW;
            h = 0.18 * safezoneH;//28
        };

        class EditBox {
            deletable = 0;
            fade = 0;
            access = 0;
            type = CT_EDIT;
            colorBackground[] = {0,0,0,0};
            colorText[] = {0.95,0.95,0.95,1};
            colorDisabled[] = {1,1,1,0.25};
            colorSelection[] =
            {
                "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])",
                "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])",
                "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",
                1
            };
            autocomplete = "";
            text = "Ctrl+A then Ctrl+V";
            style = ST_FRAME;
            font = "RobotoCondensed";
            shadow = 2;
            sizeEx = 0.05;
            canModify = 1;
            tooltipColorText[] = {1,1,1,1};
            tooltipColorBox[] = {1,1,1,1};
            tooltipColorShade[] = {0,0,0,0.65};


            idc = 42069;
            tooltip = "";
            x = 0.272481 * safezoneW + safezoneX;
            y = 0.317959 * safezoneH + safezoneY;
            w = 0.175015 * safezoneW;
            h = 0.0560125 * safezoneH;
        };

        class ImportButton {
            soundEnter[] = {
                "\A3\ui_f\data\sound\RscButton\soundEnter",
                0.09,
                1
            };
            soundPush[] = {
                "\A3\ui_f\data\sound\RscButton\soundPush",
                0.09,
                1
            };
            soundClick[] = {
                "\A3\ui_f\data\sound\RscButton\soundClick",
                0.09,
                1
            };
            soundEscape[] = {
                "\A3\ui_f\data\sound\RscButton\soundEscape",
                0.09,
                1
            };

            access = 0;
            type = CT_BUTTON;
            colorText[] = {0.73,0,0,1};
            colorDisabled[] = {0.4,0.4,0.4,0};
            colorBackground[] =  {0.247,0.243,0.243,1};
            colorBackgroundDisabled[] = {0,0.0,0};
            colorBackgroundActive[] = {0.247,0.243,0.243,1};
            colorFocused[] = {0.247,0.243,0.243,1};
            colorShadow[] = {0.023529,0,0.0313725,1};
            colorBorder[] = {0.023529,0,0.0313725,1};
            style = 2;
            shadow = 2;
            font = "PuristaMedium";
            sizeEx = 0.05;
            offsetX = 0.003;
            offsetY = 0.003;
            offsetPressedX = 0.002;
            offsetPressedY = 0.002;
            borderSize = 0;
            onMouseEnter = "(_this select 0) ctrlSetTextColor [1,0.969,0,1]";
            onMouseExit = "(_this select 0) ctrlSetTextColor [0.73,0,0,1]";

            idc = -1;
            text = "Import";
            tooltip = "";
            x = 0.482498 * safezoneW + safezoneX;
            y = 0.317959 * safezoneH + safezoneY;
            w = 0.175015 * safezoneW;
            h = 0.0560125 * safezoneH;
            action = "A3A_NG_import_NGDB_formatted = ctrlText 42069; closeDialog 1;";
        };
    };
};