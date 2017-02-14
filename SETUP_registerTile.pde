public int registerTile(JSONObject file)
{
  ObjectManager objectManager = GAME.getObjectManager();
  SetupManager setupManager = GAME.getSetupManager();

  JSONObjectHandler entry = new JSONObjectHandler(file);
  String name = entry.getString("name");
  String template_type = entry.getString("template_type");
  int variance = entry.getInt("variance");
  int[] amounts = entry.getIntArray("amounts");
  String[] types = entry.getStringArray("types");
  String group = entry.getString("group");
  Part obj;

  int fails = 0;
  for(int j = 0; j < variance; j++)
  {
    obj = createTile(amounts,template_type);

    //old
    //setupManager.addPartToGroup(group,name+j);

    for(int l = 0; l < types.length; l++)
    {
      if(obj.is(types[l]) == false)
      {
        fails++;
        obj = createTile(amounts,template_type);
        break;
      }
    }
    objectManager.registerPart(name+j, obj);
  }
  return fails;
}