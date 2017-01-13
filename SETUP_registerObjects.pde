void registerObjects()
{
  /* Register Parts */
  ObjectManager objectManager = GAME.getObjectManager();

  registerElements();
  registerTiles();

  /* register Groups */
  String[] tiles = {"Ground0","Lake0","Stone0","Alga0","Moss0","Bush0","Gravel0"};
  objectManager.registerGroup("tiles",tiles);

  String[] water_tiles = 
  {
    "Ground0",
    "Lake0","Lake1","Alga0","Alga1","Bush0","Bush1","Stone0","Stone1"
  };
  objectManager.registerGroup("waterTiles",water_tiles);

  String[] organic_tiles = 
  {"Bush0","Bush1","Moss0"};
  objectManager.registerGroup("organicTiles",organic_tiles);

  String[] rock_tiles =
  {
    "Stone0","Stone1","Moss0","Gravel0"
  };
  objectManager.registerGroup("rockTiles",organic_tiles);

  String[] ground_tiles =
  {
    "Ground0","Gravel0"
  };

  String[] liquid_tiles =
  {
    "Lake0","Lake1","Alga0","Alga1"
  };

  String[] forest_tiles = 
  {
    "Ground0",
    "Alga0","Alga1","Stone0","Stone1","Bush0","Bush1"
  };
  objectManager.registerGroup("forestTiles",forest_tiles);

  String[] ship_tiles = 
  {
    "floor","custom2","Void0","Fuel0"
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
    
  Part ship_chunk;
  //ship_chunk = new Chunk(ship_template1,"shipTiles");
  ship_chunk = evaluateChunk(ship_template1,"shipTiles");
  objectManager.registerPart("ship_1", ship_chunk);
  //ship_chunk = new Chunk(ship_template2,"shipTiles");
  ship_chunk = evaluateChunk(ship_template2,"shipTiles");
  objectManager.registerPart("ship_2", ship_chunk);
  //ship_chunk = new Chunk(ship_template3,"shipTiles");
  ship_chunk = evaluateChunk(ship_template3,"shipTiles");
  objectManager.registerPart("ship_3", ship_chunk);
  //ship_chunk = new Chunk(ship_template4,"shipTiles");
  ship_chunk = evaluateChunk(ship_template4,"shipTiles");
  objectManager.registerPart("ship_4", ship_chunk);
  String[] ship = 
  {
    "ship_1","ship_2",
    "ship_3","ship_4"
  };
  objectManager.registerGroup("ship",ship);
}