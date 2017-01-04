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
  objectManager.registerPart("ground0", createTile("Ground"));
  
  for(int variance = 0; variance < 2; variance++)
  {
    obj = createTile("Lake");
    if(obj.is("water") == false)
      obj = createTile("Lake");
    objectManager.registerPart("lake"+variance, obj);

    obj = createTile("Bush");
    if(obj.is("organic") == false)
      obj = createTile("Bush");
    objectManager.registerPart("bush"+variance, obj);

    for(int i = 0; i < 5; i++)
    {
      obj = obj = createTile("Alga");
      if(obj.is("organic_spawn")) break;
    }
    objectManager.registerPart("alga"+variance, obj);
  }

  objectManager.registerPart("stone0", createTile("Stone"));
  objectManager.registerPart("moss0", createTile("Moss"));
  objectManager.registerPart("gravel0",createTile("Gravel"));

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
    "ground0","stone0"
  };
  objectManager.registerGroup("shipTiles",ship_tiles);

  int variance = 2;

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
  JSONObject json = loadJSONObject("ship.json");
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