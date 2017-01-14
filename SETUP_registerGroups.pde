public void registerGroups()
{
  ObjectManager objectManager = GAME.getObjectManager();
  SetupManager setupManager = GAME.getSetupManager();

  String[] organic_tiles = setupManager.getGroup("plants");
  objectManager.registerGroup("organicTiles",organic_tiles);


  /*String[] organic_tiles = 
  {"Bush0","Bush1","Bush2","Bush3"};
  objectManager.registerGroup("organicTiles",organic_tiles);*/

  String[] rock_tiles =
  {
    "Stone0","Stone1","Stone2","Stone3","Moss0","Gravel0"
  };
  objectManager.registerGroup("rockTiles",rock_tiles);

  String[] liquid_tiles =
  {
    "Lake0","Lake1","Lake2","Lake3","Alga0","Alga1"
  };
  objectManager.registerGroup("liquidTiles",liquid_tiles);

  String[] ship_tiles = 
  {
    "floor","custom2","Void0","Fuel0"
  };
  objectManager.registerGroup("shipTiles",ship_tiles);
}