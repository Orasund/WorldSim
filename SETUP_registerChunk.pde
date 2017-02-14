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
      group_parts = objectManager.getNamesByGroup(parts[i]+"Blocks");
      for(int k = 0; k < picks; k++)
      {
        group[1+i*picks+k] = group_parts[floor(random(group_parts.length))];
        final_amounts[i*picks+k] = floor(amounts[i]/picks);
      }
    }
    String group_name = name+"_Chunktiles";
    objectManager.registerGroup(group_name,group);

    obj = createChunk(final_amounts,group,group_name);
    //obj = createTile(amounts,template_type);

    objectManager.registerPart(name+"Chunk"+j, obj);
  }
  return 0;
}