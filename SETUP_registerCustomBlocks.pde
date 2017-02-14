public void registerCustomBlocks()
{
  ObjectManager objectManager = GAME.getObjectManager();

  int[][] template;
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
    objectManager.registerPart(template_names[i]+"Block",evaluateBlock(template,"shipTiles"));
  }

  String[] ship_blocks = 
  {
    "floorBlock","custom2Block","Air0Block","Energy0Block"
  };
  objectManager.registerGroup("shipBlocks",ship_blocks);
}