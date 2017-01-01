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
  //objectManager.registerPart("ground", createGround());
  objectManager.registerPart("ground0", createTile("Ground"));
  
  for(int variance = 0; variance < 2; variance++)
  {
    //obj = createLake();
    obj = createTile("Lake");
    if(obj.is("water") == false)
      //obj = createLake();
      obj = createTile("Lake");
    objectManager.registerPart("lake"+variance, obj);

    for(int i = 0; i < 5; i++)
    {
      //obj = createAlga();
      obj = obj = createTile("Alga");
      if(obj.is("organic_spawn")) break;
    }
    objectManager.registerPart("alga"+variance, obj);
  }


  //objectManager.registerPart("stone", createStone());
  objectManager.registerPart("stone0", createTile("Stone"));
  //objectManager.registerPart("moss", createMoss());
  objectManager.registerPart("moss0", createTile("Moss"));
  objectManager.registerPart("gravel0",createTile("Gravel"));

  //obj = createBush();
  obj = createTile("Bush");
  if(obj.is("organic") == false)
    //obj = createBush();
    obj = createTile("Bush");
  objectManager.registerPart("bush0", obj);
  
  String[] tiles = {"ground0","lake0","stone0","alga0","moss0","bush0","gravel0"};
  objectManager.registerGroup("tiles",tiles);

  String[] water_tiles = {"ground0","lake0","lake1","alga0","alga1","bush0"};
  objectManager.registerGroup("waterTiles",water_tiles);

  int variance = 4;

  String name = "groundChunk";
  String[] group = new String[variance];
  for(int i=0;i<variance;i++)
  {
    //objectManager.registerPart(name+i, createGroundChunk());
    objectManager.registerPart(name+i, createChunk("Ground"));
    group[i] = name+i;
  }
  objectManager.registerGroup(name+"s",group);

  name = "waterChunk";
  group = new String[variance];
  for(int i=0;i<variance;i++)
  {
    //objectManager.registerPart(name+i, createSwampChunk());
    objectManager.registerPart(name+i, createChunk("Swamp"));
    group[i] = name+i;
  }
  objectManager.registerGroup(name+"s",group);

  name = "seaChunk";
  group = new String[variance];
  for(int i=0;i<variance;i++)
  {
    //objectManager.registerPart(name+i, createSeaChunk());
    objectManager.registerPart(name+i, createChunk("Sea"));
    group[i] = name+i;
  }
  objectManager.registerGroup(name+"s",group);
  
  name = "mountainChunk";
  group = new String[variance];
  for(int i=0;i<variance;i++)
  {
    //objectManager.registerPart(name+i, createMountainChunk());
    objectManager.registerPart(name+i, createChunk("Mountain"));
    group[i] = name+i;
  }
  objectManager.registerGroup(name+"s",group);

  name = "forestChunk";
  group = new String[variance];
  for(int i=0;i<variance;i++)
  {
    //objectManager.registerPart(name+i, createForestChunk());
    objectManager.registerPart(name+i, createChunk("Forest"));
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