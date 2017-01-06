void registerObjects()
{
  /* Register Parts */
  ObjectManager objectManager = GAME.getObjectManager();
  int fails = 0;

  objectManager.registerPart("space", new Element(color(0,0,0),"space"));
  objectManager.registerPart("base", new Element(color(40,40,40),"base"));
  objectManager.registerPart("source", new Element(color(0,0,255),"source"));
  objectManager.registerPart("life", new Element(color(0,80,0),"life"));
  objectManager.registerPart("energy", new Element(color(255,40,40),"energy"));
  String[] elements = {"space","base","source","life","energy"};
  objectManager.registerGroup("elements",elements);

  Part obj;
  objectManager.registerPart("void",createTile("Void"));
  objectManager.registerPart("ground0", createTile("Ground"));
  
  for(int variance = 0; variance < 2; variance++)
  {
    obj = createTile("Lake");
    if(obj.is("water") == false)
    {
      obj = createTile("Lake");
      fails++;
    }
    objectManager.registerPart("lake"+variance, obj);

    obj = createTile("Bush");
    if(obj.is("organic") == false)
    {
      obj = createTile("Bush");
      fails++;    
    }

    objectManager.registerPart("bush"+variance, obj);

    for(int i = 0; i < 5; i++)
    {
      obj = obj = createTile("Alga");
      if(obj.is("organic_spawn")) break;
      fails++;
    }
    objectManager.registerPart("alga"+variance, obj);
  }

  objectManager.registerPart("stone0", createTile("Stone"));
  objectManager.registerPart("moss0", createTile("Moss"));
  objectManager.registerPart("gravel0",createTile("Gravel"));
  objectManager.registerPart("fuel0",createTile("Fuel"));

  JSONObject json = loadJSONObject("template.json");
  String[] template_names = {"custom1","custom2","floor"};
  int[][] template;
  JSONArray table,row;
  Tile tile;
  for(int i=0; i<template_names.length; i++)
  {
    template = new int[SIZE][SIZE];
    table = json.getJSONArray(template_names[i]);
    for(int j=0; j<SIZE; j++)
    {
      row = table.getJSONArray(j);
      for(int k=0; k<SIZE; k++)
        template[k][j] = row.getInt(k);
    }
    objectManager.registerPart(template_names[i],evaluateTile(template));
  }

  println("fails in registerObjects:"+fails);

  /* register Groups */
  String[] tiles = {"ground0","lake0","stone0","alga0","moss0","bush0","gravel0"};
  objectManager.registerGroup("tiles",tiles);

  String[] water_tiles = 
  {
    "ground0",
    "lake0","lake1","alga0","alga1","bush0","bush1"
  };
  objectManager.registerGroup("waterTiles",water_tiles);

  String[] forest_tiles = 
  {
    "ground0",
    "alga0","alga1","stone0","bush0","bush1"
  };
  objectManager.registerGroup("forestTiles",forest_tiles);

  String[] ship_tiles = 
  {
    "floor","custom2","void","fuel0"
  };
  objectManager.registerGroup("shipTiles",ship_tiles);

  int variance = 2;

  /*register chunks*/
  String[] names = {"Ground","Swamp","Sea","Mountain","Forest"};
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
    "GroundChunk1","GroundChunk0",
    "SeaChunk1","SwampChunk0",
    "MountainChunk1","MountainChunk0",
    "ForestChunk1","ForestChunk0",
  };
  objectManager.registerGroup("chunk",chunk);

  //ship
  json = loadJSONObject("ship.json");
  JSONArray ship_front = json.getJSONArray("front");
  JSONArray ship_back = json.getJSONArray("back");
  int[][] ship_template1 = new int[SIZE][SIZE];
  int[][] ship_template2 = new int[SIZE][SIZE];
  int[][] ship_template3 = new int[SIZE][SIZE];
  int[][] ship_template4 = new int[SIZE][SIZE];
  JSONArray array_front, array_back;
  int num;
  for(int i=0; i<SIZE; i++)
  {
    array_front = ship_front.getJSONArray(i);
    array_back = ship_back.getJSONArray(i);
    for(int j=0; j<SIZE; j++)
    {
      num = array_front.getInt(j);
      ship_template1[j][i] = num;
      ship_template2[SIZE-1-j][i] = num;
      num = array_back.getInt(j);
      ship_template3[j][i] = num;
      ship_template4[SIZE-1-j][i] = num;
    }
  }
    
  Chunk ship_chunk = new Chunk(ship_template1,"shipTiles");
  objectManager.registerPart("ship_1", ship_chunk);
  ship_chunk = new Chunk(ship_template2,"shipTiles");
  objectManager.registerPart("ship_2", ship_chunk);
  ship_chunk = new Chunk(ship_template3,"shipTiles");
  objectManager.registerPart("ship_3", ship_chunk);
  ship_chunk = new Chunk(ship_template4,"shipTiles");
  objectManager.registerPart("ship_4", ship_chunk);
  String[] ship = 
  {
    "ship_1","ship_2",
    "ship_3","ship_4"
  };
  objectManager.registerGroup("ship",ship);
}