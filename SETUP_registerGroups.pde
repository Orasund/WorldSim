public void registerGroups()
{
  ObjectManager objectManager = GAME.getObjectManager();
  SetupManager setupManager = GAME.getSetupManager();

  String[] group;
  group = setupManager.getGroup("organism");
  objectManager.registerGroup("organicTiles",group);

  group = setupManager.getGroup("mineral");
  objectManager.registerGroup("mineralTiles",group);

  group = setupManager.getGroup("liquid");
  objectManager.registerGroup("liquidTiles",group);

  group = setupManager.getGroup("background");
  objectManager.registerGroup("backgroundTiles",group);

  group = setupManager.getGroup("reaction");
  objectManager.registerGroup("reactionTiles",group);

  String[] ship_tiles = 
  {
    "floor","custom2","Air0","Energy0"
  };
  objectManager.registerGroup("shipTiles",ship_tiles);
}