public void registerCostumChunks()
{
  ObjectManager objectManager = GAME.getObjectManager();

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
