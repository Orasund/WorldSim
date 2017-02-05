Part createChunk(String name)
{
  /*JSONObject json = loadJSONObject("chunk.json");
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
  return createChunkByVariance(amounts,variance,names,group);*/

  ObjectManager objectManager = GAME.getObjectManager();
  JSONObject chunk = loadJSONObject("chunk.json").getJSONObject(name); 

  String ground = chunk.getString("ground");
  JSONArray names_arr = chunk.getJSONArray("names");
  JSONArray amounts_arr = chunk.getJSONArray("amounts");
  String[] names = new String[names_arr.size()];
  int[] amounts = new int[amounts_arr.size()];
  for(int i=0; i<names.length; i++)
  {
    names[i] = names_arr.getString(i);
    amounts[i] = amounts_arr.getInt(i);
  }
  int variance = chunk.getInt("variance");

  String[] group = new String[1+variance*names.length];
  group[0] = ground+"0";
  String[] parts;
  int[] final_amounts = new int[variance*names.length];
  for(int i = 0; i < names.length; i++)
  {
    parts = objectManager.getNamesByGroup(names[i]+"Tiles");
    for(int j = 0; j < variance; j++)
    {
      group[1+i*variance+j] = parts[floor(random(parts.length))];
      final_amounts[i*variance+j] = floor(amounts[i]/variance);
    }
  }
  String group_name = name+"_chunktiles";
  objectManager.registerGroup(group_name,group);

  return createChunkByVariance(final_amounts,1,group,group_name);
}

Part createChunkByVariance(int[] amount_, int variance, String[] names_, String group_name)
{
  int[] amount = new int[amount_.length*variance];
  String[] names = new String[amount.length];
  for(int i=0; i<amount_.length; i++)
    for(int j=0; j<variance; j++)
    {
      amount[i*variance+j] = floor(amount_[i]/variance);
      names[i*variance+j] = names_[1+i];//names_[i]+j;
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

int[][] plantTemplate(int stone, int water, int life, int power)
{
  int[][] out = randTemplate(stone,water,life,power);
  
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

int[][] groundTemplate(int stone, int water, int life, int power)
{
  int[][] out = randTemplate(stone,water,life,power);
  return out;
}

int[][] solidTemplate(int stone, int water, int life, int power)
{
  int[][] out = randTemplate(stone,water,life,power);
  
  for(int i=0;i<8;i++)
  {
    out[0][i]=1;
    out[i][0]=1;
    out[7][i]=1;
    out[i][7]=1;
  }
  
  return out;
}