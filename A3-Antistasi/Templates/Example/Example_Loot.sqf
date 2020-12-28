//////////////////
// Basic Items ///
//////////////////
/*Contains: allMaps + allToolkits + allWatches + allCompasses + allMedikits + allFirstAidKits*/
lootBasicItem append [];

/////////////////
//    NVG'S   ///
/////////////////
lootNVG append []];

/////////////////////
// Assigned Items ///
/////////////////////
/*Contains: allUAVTerminals + allMineDetectors + allGPS + allRadios + allLaserDesignators + allBinoculars + allLaserBatteries + lootNVG + allGadgets*/
lootItem append [];

////////////////////
//    Weapons    ///
////////////////////
/*Contains: allRifles + allSniperRifles + allHandguns + allMachineGuns + allMissileLaunchers + allRocketLaunchers + allSMGs + allShotguns*/
lootWeapon append [];

/////////////////////////////
//   Weapon Attachments   ///
/////////////////////////////
/*Contains: allBipods + allOptics + allMuzzleAttachments + allPointerAttachments*/
lootAttachment append [];

////////////////////
//    Grenades   ///
////////////////////
/*Contains: allGrenades + allMagShell + allIRGrenades + allMagSmokeShell + allMagFlare*/
lootGrenade append [];

////////////////////
//   Magazines   ///
////////////////////
/*Contains: allMagBullet + allMagShotgun + allMagMissile + allMagRocket + lootGrenade*/
lootMagazine append [];

///////////////////
//  Explosives  ///
///////////////////
/*Contains: allMine + allMineDirectional + allMineBounding*/
lootExplosive append [];

///////////////////
//   Backpacks  ///
///////////////////
lootBackpack append [];

/////////////////
//   Helmets  ///
/////////////////
lootHelmet append [];

///////////////
//   Vests  ///
///////////////
lootVest append [];

//////////////////
//   UAV Bags  ///
//////////////////
/*This one is automatic and actually competent, leave it.*/
private _lootDeviceBag = [];

switch (teamPlayer) do {
     case independent: {_lootDeviceBag append rebelBackpackDevice};
     default {_lootDeviceBag append occupantBackpackDevice};
};
lootDevice append _lootDeviceBag + allBackpacksRadio;

////////////////////////////////////
//      REBEL STARTING ITEMS     ///
////////////////////////////////////
//KEEP AT BOTTOM!!! Not sure if it's being used here yet.
/*
initialRebelEquipment append lootBasicItem;
initialRebelEquipment append allRebelUniforms;
initialRebelEquipment append allCivilianUniforms;
initialRebelEquipment append allCivilianHeadgear;
initialRebelEquipment append allCivilianGlasses;
*/
