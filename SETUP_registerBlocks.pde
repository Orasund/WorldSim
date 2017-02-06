/*public void registerBlocks()
{
  ObjectManager objectManager = GAME.getObjectManager();
  SetupManager setupManager = GAME.getSetupManager();
  JSONArray blocks = loadJSONArray("block.json");

  JSONObject block;
  JSONArray names_arr;

  JSONArray elements_arr;
  JSONArray types_arr;
  String name;
  String template_type;
  int[] elements;
  int[][] template;
  int variance;
  String[] types;
  Part obj;
  String group;

  for(int i = 0; i < blocks.size(); i++)
  {
    block = blocks.getJSONObject(i);
    elements_arr = block.getJSONArray("elements");
    types_arr = block.getJSONArray("types");

    name = block.getString("name");
    template_type = block.getString("template_type");
    variance = block.getInt("variance");
    elements = new int[4];
    for(int j=0; j<4; j++)
      elements[j] = elements_arr.getInt(j);
    types = new String[types_arr.size()];
    for(int j=0; j<types_arr.size(); j++)
      types[j] = types_arr.getString(j);
    group = block.getString("group");

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

  println("fails in registerblocks:"+fails);
}*/