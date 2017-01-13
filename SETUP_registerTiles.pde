public void registerTiles()
{
  ObjectManager objectManager = GAME.getObjectManager();
  JSONObject json;
  json = loadJSONObject("tile.json");
  int fails = 0;

  //loading tiles from JSON file
  //JSONObject tile = json.getJSONObject(name);

  Part obj;
  objectManager.registerPart("void0",createTile("Void"));
  objectManager.registerPart("ground0", createTile("Ground"));
  
  for(int variance = 0; variance < 2; variance++)
  {
    obj = createTile("Lake");
    if(obj.is("water") == false)
    {
      obj = createTile("Lake");
      fails++;
    }
    objectManager.registerPart("lake"+variance, obj);

    obj = createTile("Bush");
    if(obj.is("organic") == false)
    {
      obj = createTile("Bush");
      fails++;    
    }

    objectManager.registerPart("bush"+variance, obj);

    for(int i = 0; i < 5; i++)
    {
      obj = obj = createTile("Alga");
      if(obj.is("organic_spawn")) break;
      fails++;
    }
    objectManager.registerPart("alga"+variance, obj);
  }

  objectManager.registerPart("stone0", createTile("Stone"));
  objectManager.registerPart("moss0", createTile("Moss"));
  objectManager.registerPart("gravel0",createTile("Gravel"));
  objectManager.registerPart("fuel0",createTile("Fuel"));

  json = loadJSONObject("template.json");
  String[] template_names = {"custom1","custom2","floor"};
  int[][] template;
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
    objectManager.registerPart(template_names[i],evaluateTile(template));
  }

  println("fails in registerObjects:"+fails);
}