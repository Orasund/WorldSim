public int registerChunk(JSONObject file)
{
  ObjectManager objectManager = GAME.getObjectManager();

  JSONObjectHandler entry = new JSONObjectHandler(file);
  String name = entry.getString("name");
  String[] parts = entry.getStringArray("parts");
  int[] amounts = entry.getIntArray("amounts");
  String ground = entry.getString("ground");
  int picks = entry.getInt("picks");

  Part obj;

  int variance = 2;
  for(int j = 0; j < variance; j++)
  {
    //Preperation
    String[] group = new String[1+picks*parts.length];
    group[0] = ground+"0";
    String[] group_parts;
    int[] final_amounts = new int[picks*parts.length];
    for(int i = 0; i < parts.length; i++)
    {
      group_parts = objectManager.getNamesByGroup(parts[i]+"Tiles");
      for(int k = 0; k < picks; k++)
      {
        group[1+i*picks+k] = group_parts[floor(random(group_parts.length))];
        final_amounts[i*picks+k] = floor(amounts[i]/picks);
      }
    }
    String group_name = name+"_Chunktiles";
    objectManager.registerGroup(group_name,group);

    obj = createChunkByVariance(final_amounts,1,group,group_name);
    //obj = createTile(amounts,template_type);

    objectManager.registerPart(name+"Chunk"+j, obj);
  }
  return 0;
}

/*Part createChunk(String name_)
{
  ObjectManager objectManager = GAME.getObjectManager();
  JSONObject chunk = loadJSONObject("Chunk.json").getJSONObject(name_); 

  String name = name_;
  String ground = chunk.getString("ground");
  JSONArray parts_arr = chunk.getJSONArray("parts");
  JSONArray amounts_arr = chunk.getJSONArray("amounts");
  String[] parts = new String[parts_arr.size()];
  int[] amounts = new int[amounts_arr.size()];
  for(int i=0; i<parts.length; i++)
  {
    parts[i] = parts_arr.getString(i);
    amounts[i] = amounts_arr.getInt(i);
  }
  int picks = chunk.getInt("picks");

  String[] group = new String[1+picks*parts.length];
  group[0] = ground+"0";
  String[] group_parts;
  int[] final_amounts = new int[picks*parts.length];
  for(int i = 0; i < parts.length; i++)
  {
    group_parts = objectManager.getNamesByGroup(parts[i]+"Tiles");
    for(int j = 0; j < picks; j++)
    {
      group[1+i*picks+j] = group_parts[floor(random(group_parts.length))];
      final_amounts[i*picks+j] = floor(amounts[i]/picks);
    }
  }
  String group_name = name+"_chunktiles";
  objectManager.registerGroup(group_name,group);

  return createChunkByVariance(final_amounts,1,group,group_name);
}*/

Part createChunkByVariance(int[] amount_, int picks, String[] parts_, String group_name)
{
  int[] amount = new int[amount_.length*picks];
  String[] parts = new String[amount.length];
  for(int i=0; i<amount_.length; i++)
    for(int j=0; j<picks; j++)
    {
      amount[i*picks+j] = floor(amount_[i]/picks);
      parts[i*picks+j] = parts_[1+i];//parts_[i]+j;
    }

  ObjectManager objectManager = GAME.getObjectManager();

  String[] group = objectManager.getNamesByGroup(group_name);
  int[] adresses = new int[parts.length];
  int size = 8;

  for(int i=0;i<parts.length;i++)
    for(int j=1;j<group.length;j++)
    {
      if(group[j].equals(parts[i]))
      {
        adresses[i] = j;
        break;
      }
      if(j == group.length-1)
        throw new RuntimeException("Part not found: "+parts[i]+" @createChunkByVariance");
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

int[][] seedTemplate(int base, int source, int life, int power)
{
  int[][] out = randTemplate(base,source,life,power);
  
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

int[][] defaultTemplate(int base, int source, int life, int power)
{
  int[][] out = randTemplate(base,source,life,power);
  return out;
}

int[][] frameTemplate(int base, int source, int life, int power)
{
  int[][] out = randTemplate(base,source,life,power);
  
  for(int i=0;i<8;i++)
  {
    out[0][i]=1;
    out[i][0]=1;
    out[7][i]=1;
    out[i][7]=1;
  }
  
  return out;
}