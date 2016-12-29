void registerObjects()
{
  ObjectManager objectManager = GAME.getObjectManager();

  objectManager.registerPart("space", new Element(color(0,0,0)));
  objectManager.registerPart("base", new Element(color(40,40,40)));
  objectManager.registerPart("source", new Element(color(0,0,255)));
  objectManager.registerPart("life", new Element(color(0,80,0)));
  String[] elements = {"space","base","source","life"};
  objectManager.registerGroup("elements",elements);

  Part obj;
  objectManager.registerPart("ground", createGround());
  
  for(int variance = 0; variance < 2; variance++)
  {
    obj = createLake();
    if(obj.is("water") == false) obj = createLake();
    objectManager.registerPart("lake"+variance, obj);

    for(int i = 0; i < 5; i++)
    {
      obj = createAlga();
      if(obj.is("organic_spawn")) break;
    }
    objectManager.registerPart("alga"+variance, obj);
  }


  objectManager.registerPart("stone", createStone());
  objectManager.registerPart("moss", createMoss());

  obj = createBush();
  if(obj.is("organic") == false) obj = createBush();
  objectManager.registerPart("bush", obj);
  String[] tiles = {"ground","lake1","stone","alga1","moss","bush"};
  objectManager.registerGroup("tiles",tiles);

  String[] water_tiles = {"ground","lake0","lake1","alga0","alga1","bush"};
  objectManager.registerGroup("waterTiles",water_tiles);

  int variance = 4;

  String name = "groundChunk";
  String[] group = new String[variance];
  for(int i=0;i<variance;i++)
  {
    objectManager.registerPart(name+i, createGroundChunk());
    group[i] = name+i;
  }
  objectManager.registerGroup(name+"s",group);

  name = "waterChunk";
  group = new String[variance];
  for(int i=0;i<variance;i++)
  {
    objectManager.registerPart(name+i, createSwampChunk());
    group[i] = name+i;
  }
  objectManager.registerGroup(name+"s",group);

  name = "seaChunk";
  group = new String[variance];
  for(int i=0;i<variance;i++)
  {
    objectManager.registerPart(name+i, createSeaChunk());
    group[i] = name+i;
  }
  objectManager.registerGroup(name+"s",group);
  
  name = "mountainChunk";
  group = new String[variance];
  for(int i=0;i<variance;i++)
  {
    objectManager.registerPart(name+i, createMountainChunk());
    group[i] = name+i;
  }
  objectManager.registerGroup(name+"s",group);

  name = "forestChunk";
  group = new String[variance];
  for(int i=0;i<variance;i++)
  {
    objectManager.registerPart(name+i, createForestChunk());
    group[i] = name+i;
  }
  objectManager.registerGroup(name+"s",group);

  String[] chunk = 
  {
    "groundChunk1","groundChunk2",
    "waterChunk1","waterChunk2",
    "mountainChunk1","mountainChunk2",
    "forestChunk1","forestChunk2",
  };
  objectManager.registerGroup("chunk",chunk);
}