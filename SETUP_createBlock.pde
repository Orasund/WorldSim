  /*public Part createBlock(int[] elements,String template_type)
{

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
}*/