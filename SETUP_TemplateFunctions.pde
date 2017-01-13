Part createChunk(String name)
{
  JSONObject json = loadJSONObject("chunk.json");
  JSONObject chunk = json.getJSONObject(name);
  JSONArray arr1 = chunk.getJSONArray("names");
  JSONArray arr2 = chunk.getJSONArray("amounts");
  String[] names = new String[arr1.size()];
  int[] amounts = new int[arr2.size()];

  for(int i=0; i<arr1.size(); i++)
  {
    names[i] = arr1.getString(i);
    amounts[i] = arr2.getInt(i);
  }

  int variance = chunk.getInt("variance");
  String group = chunk.getString("group");
  return createChunkByVariance(amounts,variance,names,group);
}

/*Part createTile(String name)
{
  JSONObject json = loadJSONObject("tile.json");
  int[][] template;
  int[] arr = new int[4];

  JSONObject tile = json.getJSONObject(name);
  String template_type = tile.getString("template_type");
  JSONArray elem = tile.getJSONArray("elements");
  for(int i=0; i<4; i++)
    arr[i] = elem.getInt(i);

  switch(template_type)
  {
    case "plant":
      template = plantTemplate(arr[0], arr[1], arr[2], arr[3]);
      break;
    case "solid":
      template = solidTemplate(arr[0], arr[1], arr[2], arr[3]);
      break;
    default:
      template = groundTemplate(arr[0], arr[1], arr[2], arr[3]);
      break;
  }
  return evaluateTile(template);
}*/

Part createChunkByVariance(int[] amount_, int variance, String[] names_, String group_name)
{
  int[] amount = new int[amount_.length*variance];
  String[] names = new String[amount.length];
  for(int i=0; i<amount_.length; i++)
    for(int j=0; j<variance; j++)
    {
      amount[i*variance+j] = floor(amount_[i]/variance);
      names[i*variance+j] = names_[i]+j;
    }

  ObjectManager objectManager = GAME.getObjectManager();

  String[] group = objectManager.getNamesByGroup(group_name);
  int[] adresses = new int[names.length];
  int size = 8;

  for(int i=0;i<names.length;i++)
    for(int j=1;j<group.length;j++)
    {
      if(group[j].equals(names[i]))
      {
        adresses[i] = j;
        break;
      }
      if(j == group.length-1)
        throw new RuntimeException("Part not found: "+names[i]+" @createChunkByVariance");
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

  //return new Chunk(out,group_name);
  return evaluateChunk(out,group_name);
}

int[][] plantTemplate(int stone, int water, int life, int energy)
{
  int[][] out = randTemplate(stone,water,life,energy);
  
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

int[][] groundTemplate(int stone, int water, int life, int energy)
{
  int[][] out = randTemplate(stone,water,life,energy);
  return out;
}

int[][] solidTemplate(int stone, int water, int life, int energy)
{
  int[][] out = randTemplate(stone,water,life,energy);
  
  for(int i=0;i<8;i++)
  {
    out[0][i]=1;
    out[i][0]=1;
    out[7][i]=1;
    out[i][7]=1;
  }
  
  return out;
}