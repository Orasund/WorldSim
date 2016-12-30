Chunk createGroundChunk()
{
  int[] amount = {3,10,2};
  String[] names = {"lake1","bush","alga1"};
  return createChunk(amount,names,"tiles");
}

Chunk createSwampChunk()
{
  int[] amount = {50,5};
  int variance = 2;
  String[] names = {"lake","alga"};
  return createChunkByVariance(amount,variance,names,"waterTiles");
}

Chunk createSeaChunk()
{
  int[] amount = {70,1};
  int variance = 2;
  String[] names = {"lake","alga"};
  return createChunkByVariance(amount,variance,names,"waterTiles");
}

Chunk createMountainChunk()
{
  int[] amount = {5,70,10};
  String[] names = {"lake1","stone","moss"};
  return createChunk(amount,names,"tiles");
}

Chunk createForestChunk()
{
  int[] amount = {10,5,50};
  String[] names = {"lake1","stone","bush"};
  return createChunk(amount,names,"tiles");
}

/*Tile createBush(){return evaluateTile(plantTemplate(0,10,10));}
Tile createMoss(){return evaluateTile(solidTemplate(50,20,10));}
Tile createGround(){return evaluateTile(groundTemplate(10,0,0));}
Tile createLake(){return evaluateTile(groundTemplate(0,50,0));}
Tile createStone(){return evaluateTile(solidTemplate(80,1,0));}
Tile createAlga(){return evaluateTile(groundTemplate(0,20,4));}
Tile createGravel(){return evaluateTile(groundTemplate(20,0,0));}
*/

Tile createTile(String name)
{
  println(name);
  JSONObject json = loadJSONObject("elements.json");
  JSONObject tile;
  String template_type;
  JSONArray elem;
  int[][] template;
  int[] arr = new int[4];

  tile = json.getJSONObject(name);
  template_type = tile.getString("template_type");
  elem = tile.getJSONArray("elements");
  for(int i=0; i<4; i++)
    arr[i] = elem.getInt(i);

  switch(template_type)
  {
    case "plant":
      template = plantTemplate(arr[0], arr[1], arr[2]);
      break;
    case "solid":
      template = solidTemplate(arr[0], arr[1], arr[2]);
      break;
    default:
      template = groundTemplate(arr[0], arr[1], arr[2]);
      break;
  }
  return evaluateTile(template);
}

/*void createTilesByJSON()
{
  JSONArray json = loadJSONArray("elements.json");
  JSONObject tile;
  String name;
  String template_type;
  int[] elements;
  int[][] template;
  Tile object;

  int size = json.size();
  for(int i=0; i<sie; i++)
  {
    tile = json.getJSONObject(i);
    name = tile.getString("name");
    template_type = tile.getString("template_type");
    elements = tile.getIntArray("elements");
    switch(template_type)
    {
      case "plant":
        template = plantTemplate(int stone, int water, int life);
        break;
      case "solid":
        template = solidTemplate(int stone, int water, int life);
        break;
      default:
        template = groundTemplate(int stone, int water, int life);
        break;
    }
    object = evaluateTile(template);
    objectManager.registerPart(name, object);
  }
}*/

Chunk createChunkByVariance(int[] amount, int variance, String[] names, String group)
{
  int[] amount_ = new int[amount.length*variance];
  String[] names_ = new String[amount_.length];
  for(int i=0; i<amount.length; i++)
    for(int j=0; j<variance; j++)
    {
      amount_[i*variance+j] = floor(amount[i]/variance);
      names_[i*variance+j] = names[i]+j;
    }
  
  return createChunk(amount_,names_,group);
}

Chunk createChunk(int[] amount, final String[] names, String group_name)
{
  ObjectManager objectManager = GAME.getObjectManager();

  String[] group = objectManager.getNamesByGroup(group_name);
  int[] adresses = new int[names.length];
  int size = 8;

  for(int i=0;i<names.length;i++)
    for(int j=1;j<group.length;j++)
      if(group[j].equals(names[i]))
      {
        adresses[i] = j;
        break;
      }

  int[][] out = new int[size][size];
  for(int i=0;i<size;i++)
    for(int j=0;j<size;j++)
    {
      float rand = random(100);

      int type = 0;
      for(int k=0;k<amount.length;k++)
      {
        if(rand<amount[k])
        {
          type = adresses[k];
          break;
        }
        rand-=amount[k];
      }
      out[i][j] = type;
    }
  Chunk ch = new Chunk(out,group_name);
  return ch;
}

int[][] plantTemplate(int stone, int water, int life)
{
  int[][] out = randTemplate(stone,water,life);
  
  for(int i=0;i<2;i++)
    for(int j=0;j<2;j++)
      out[3+i][3+j]=2;

  for(int i=0;i<4;i++)
  {
    
    out[2][2+i]=3;
    out[2+i][2]=3;
    out[5][2+i]=3;
    out[2+i][5]=3;
  }
  
  return out;
}

int[][] groundTemplate(int stone, int water, int life)
{
  int[][] out = randTemplate(stone,water,life);
  return out;
}

int[][] solidTemplate(int stone, int water, int life)
{
  int[][] out = randTemplate(stone,water,life);
  
  for(int i=0;i<8;i++)
  {
    out[0][i]=1;
    out[i][0]=1;
    out[7][i]=1;
    out[i][7]=1;
  }
  
  return out;
}