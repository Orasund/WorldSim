void registerObjects()
{
  registerElements();

  //registerTiles
  //TODO:make a generall Function for all Parts
  String[] groups = {"background","organism","reaction","mineral","liquid"};
  String part_name = "Tile";

  ObjectManager objectManager = GAME.getObjectManager();
  SetupManager setupManager = GAME.getSetupManager();
  setupManager.clear();

  for(int i=0; i<groups.length; i++)
    setupManager.addGroup(groups[i]);
  
  JSONArray file = loadJSONArray(part_name+".json");
  registerTiles(file);

  String[] new_group;
  for(int i=0; i<groups.length; i++)
  {
    new_group = setupManager.getGroup(groups[i]);
    objectManager.registerGroup(groups[i]+part_name+"s",new_group);
  }
  registerCustomTiles();
  //registerTiles END
  
  registerChunk();
}