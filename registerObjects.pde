void registerObjects()
{
  ObjectManager ObjectManager = Game.ObjectManager;
  ObjectManager.registerPart("space", new Space(color(0,0,0)));
  ObjectManager.registerPart("base", new Base(color(40,40,40)));
  ObjectManager.registerPart("source", new Source(color(0,0,255)));
  ObjectManager.registerPart("life", new Life(color(0,80,0)));
  String[] elements = {"space","base","source","life"};
  ObjectManager.registerGroup("elements",elements);

  ObjectManager.registerPart("ground", createGround());
  ObjectManager.registerPart("lake", createLake());
  ObjectManager.registerPart("stone", createStone());
  ObjectManager.registerPart("alga", createAlga());
  ObjectManager.registerPart("moss", createMoss());
  ObjectManager.registerPart("bush", createBush());
  String[] tiles = {"ground","lake","stone","alga","moss","bush"};
  ObjectManager.registerGroup("tiles",tiles);

  int amount = 4;

  String name = "groundChunk";
  String[] group = new String[amount];
  for(int i=0;i<amount;i++)
  {
    ObjectManager.registerPart(name+i, createGroundChunk());
    group[i] = name+i;
  }
  ObjectManager.registerGroup(name+"s",group);

  name = "waterChunk";
  group = new String[amount];
  for(int i=0;i<amount;i++)
  {
    ObjectManager.registerPart(name+i, createWaterChunk());
    group[i] = name+i;
  }
  ObjectManager.registerGroup(name+"s",group);
  
  name = "mountainChunk";
  group = new String[amount];
  for(int i=0;i<amount;i++)
  {
    ObjectManager.registerPart(name+i, createMountainChunk());
    group[i] = name+i;
  }
  ObjectManager.registerGroup(name+"s",group);

  name = "forestChunk";
  group = new String[amount];
  for(int i=0;i<amount;i++)
  {
    ObjectManager.registerPart(name+i, createForestChunk());
    group[i] = name+i;
  }
  ObjectManager.registerGroup(name+"s",group);

  String[] chunk = 
  {
    "groundChunk1","groundChunk2",
    "waterChunk1","waterChunk2",
    "mountainChunk1","mountainChunk2",
    "forestChunk1","forestChunk2",
  };
  ObjectManager.registerGroup("chunk",chunk);
}