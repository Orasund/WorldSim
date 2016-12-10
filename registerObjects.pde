void registerObjects()
{
  ObjectManager ObjectManager = Game.ObjectManager;
  ObjectManager.registerPart("space", new Element(color(0,0,0)));
  ObjectManager.registerPart("base", new Element(color(40,40,40)));
  ObjectManager.registerPart("source", new Element(color(0,0,255)));
  ObjectManager.registerPart("life", new Element(color(0,80,0)));
  String[] elements = {"space","base","source","life"};
  ObjectManager.registerGroup("elements",elements);

  Part obj;
  ObjectManager.registerPart("ground", createGround());
  
  for(int variance = 0; variance < 2; variance++)
  {
    obj = createLake();
    if(obj.is("water") == false) obj = createLake();
    ObjectManager.registerPart("lake"+variance, obj);

    for(int i = 0; i < 5; i++)
    {
      obj = createAlga();
      if(obj.is("organic_spawn")) break;
    }
    ObjectManager.registerPart("alga"+variance, obj);
  }


  ObjectManager.registerPart("stone", createStone());
  ObjectManager.registerPart("moss", createMoss());

  obj = createBush();
  if(obj.is("organic") == false) obj = createBush();
  ObjectManager.registerPart("bush", obj);
  String[] tiles = {"ground","lake1","stone","alga1","moss","bush"};
  ObjectManager.registerGroup("tiles",tiles);

  String[] water_tiles = {"ground","lake0","lake1","alga0","alga1"};
  ObjectManager.registerGroup("waterTiles",water_tiles);

  int variance = 4;

  String name = "groundChunk";
  String[] group = new String[variance];
  for(int i=0;i<variance;i++)
  {
    ObjectManager.registerPart(name+i, createGroundChunk());
    group[i] = name+i;
  }
  ObjectManager.registerGroup(name+"s",group);

  name = "waterChunk";
  group = new String[variance];
  for(int i=0;i<variance;i++)
  {
    ObjectManager.registerPart(name+i, createWaterChunk());
    group[i] = name+i;
  }
  ObjectManager.registerGroup(name+"s",group);
  
  name = "mountainChunk";
  group = new String[variance];
  for(int i=0;i<variance;i++)
  {
    ObjectManager.registerPart(name+i, createMountainChunk());
    group[i] = name+i;
  }
  ObjectManager.registerGroup(name+"s",group);

  name = "forestChunk";
  group = new String[variance];
  for(int i=0;i<variance;i++)
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