public void registerTiles(JSONArray file)
{
  ObjectManager objectManager = GAME.getObjectManager();
  SetupManager setupManager = GAME.getSetupManager();

  int fails = 0;

  JSONObjectHandler entry;
  String name;
  String template_type;
  int[] elements;
  int variance;
  String[] types;
  Part obj;
  String group;

  for(int i = 0; i < file.size(); i++)
  {
    entry = new JSONObjectHandler(file.getJSONObject(i));
    name = entry.getString("name");
    template_type = entry.getString("template_type");
    variance = entry.getInt("variance");
    elements = entry.getIntArray("elements");
    types = entry.getStringArray("types");
    group = entry.getString("group");

    for(int j = 0; j < variance; j++)
    {
      obj = createTile(elements,template_type);

      setupManager.addPartToGroup(group,name+j);

      for(int l = 0; l < types.length; l++)
      {
        if(obj.is(types[l]) == false)
        {
          fails++;
          obj = createTile(elements,template_type);
          break;
        }
      }
      objectManager.registerPart(name+j, obj);
    }
  }
  println("fails in registerTiles:"+fails);
}