public void registerChunk()
{
  ObjectManager objectManager = GAME.getObjectManager();

  int variance = 2;

  String[] names = {"Plain","Swamp","Sea","Hill","Forest","Lava"};
  String name;
  String[] group = new String[variance];
  for(int i=0; i<names.length; i++)
  {
    name = names[i]+"Chunk";
    for(int j=0; j<variance; j++)
    {
      objectManager.registerPart(name+j, createChunk(names[i]));
      group[j] = name+j;
    }
    objectManager.registerGroup(name+"s",group);
  }

  String[] chunk = 
  {
    "PlainChunk1","PlainChunk0",
    "SeaChunk1","SwampChunk0",
    "HillChunk1","LavaChunk0",
    "ForestChunk1","ForestChunk0",
  };
  objectManager.registerGroup("chunk",chunk);
  registerCostumChunks();
}
