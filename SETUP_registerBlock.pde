public int registerBlock(JSONObject file)
{
  ObjectManager objectManager = GAME.getObjectManager();
  SetupManager setupManager = GAME.getSetupManager();

  JSONObjectHandler entry = new JSONObjectHandler(file);
  String name = entry.getString("name");
  String[] parts = entry.getStringArray("parts");
  int[] amounts = entry.getIntArray("amounts");
  String group = entry.getString("group");
  Part obj;

  int fails = 0;
  int variance = 2;
  for(int j = 0; j < variance; j++)
  {
    obj = createBlock(amounts,parts,group);

    setupManager.addPartToGroup(group,name+j);
    objectManager.registerPart(name+j, obj);
  }
  return fails;
}

/*public void registerBlocks()
{
  ObjectManager objectManager = GAME.getObjectManager();
  SetupManager setupManager = GAME.getSetupManager();
  setupManager.clear();

  String[] groups = {"background","organism","reaction","mineral","liquid"};
  for(int i=0; i<groups.length; i++)
    setupManager.addGroup(groups[i]);

  JSONArray file = loadJSONArray("block.json");

  //JSON Structure
  JSONObject entry;
  JSONArray parts_arr;
  JSONArray amounts_arr;
  String name;
  String[] parts;
  int[] amounts;
  int variance;



  JSONArray elements_arr;
  JSONArray types_arr;

  String template_type;
  int[] elements;
  int[][] template;

  String[] types;
  Part obj;
  String group;

  for(int i = 0; i < file.size(); i++)
  {
    entry = file.getJSONObject(i);
    elements_arr = entry.getJSONArray("elements");
    types_arr = entry.getJSONArray("types");

    name = entry.getString("name");
    template_type = entry.getString("template_type");
    variance = entry.getInt("variance");
    elements = new int[4];
    for(int j=0; j<4; j++)
      elements[j] = elements_arr.getInt(j);
    types = new String[types_arr.size()];
    for(int j=0; j<types_arr.size(); j++)
      types[j] = types_arr.getString(j);
    group = entry.getString("group");

    for(int j = 0; j < variance; j++)
    {
      obj = createblock(elements,template_type);

      setupManager.addPartToGroup(group,name+j);

      for(int l = 0; l < types.length; l++)
      {
        if(obj.is(types[l]) == false)
        {
          fails++;
          obj = createblock(elements,template_type);
          break;
        }
      }
      objectManager.registerPart(name+j, obj);
    }
  }

  JSONObject json = loadJSONObject("template.json");
  String[] template_names = {"custom1","custom2","floor"};
  JSONArray table,row;
  for(int i=0; i<template_names.length; i++)
  {
    template = new int[SIZE][SIZE];
    table = json.getJSONArray(template_names[i]);
    for(int j=0; j<SIZE; j++)
    {
      row = table.getJSONArray(j);
      for(int k=0; k<SIZE; k++)
        template[k][j] = row.getInt(k);
    }
    objectManager.registerPart(template_names[i],evaluateblock(template));
  }

  println("fails in registerBlocks:"+fails);
}*/