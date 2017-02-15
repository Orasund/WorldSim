void loadObjects()
{
  registerElements();

  String[][] groups = 
  {
    {},
    {"background","organism","reaction","mineral","liquid"},
    {}
  };
  String[] part_name = {"Tile","Block","Chunk"};
  for(int j = 0; j < part_name.length; j++)
  {
    ObjectManager objectManager = GAME.getObjectManager();
    SetupManager setupManager = GAME.getSetupManager();
    setupManager.clear();

    for(int i=0; i<groups[j].length; i++)
      setupManager.addGroup(groups[j][i]);
    
    JSONArray file = loadJSONArray(part_name[j]+".json");
    
    int fails = 0;
    for(int i = 0; i < file.size(); i++)
    {
      switch(j)
      {
        case 0:
          fails += registerTile(file.getJSONObject(i));
          break;
        case 1:
          fails += registerBlock(file.getJSONObject(i));
          break;
        case 2:
          fails += registerChunk(file.getJSONObject(i));
          break;
      }
    }
    println("fails in register"+part_name[j]+"s:"+fails);

    String[] new_group;
    for(int i=0; i<groups[j].length; i++)
    {
      new_group = setupManager.getGroup(groups[j][i]);
      objectManager.registerGroup(groups[j][i]+part_name[j]+"s",new_group);
    }
    switch(j)
    {
      case 0:
        registerCustomTiles();
        break;
      case 1:
        registerCustomBlocks();
        break;
      case 2:
        String[] chunk = 
        {
          "PlainChunk1","PlainChunk0",
          "SeaChunk1","SwampChunk0",
          "HillChunk1","LavaChunk0",
          "ForestChunk1","ForestChunk0",
        };
        objectManager.registerGroup("chunk",chunk);      
        registerCostumChunks();
        break;
    }
  }
}