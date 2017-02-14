Part evaluateElement(int id)
{
  String[] names = {"space",    "base",         "source",       "life",       "power"};
  color[] colors = {color(0,0,0),color(40,40,40),color(0,0,255),color(0,80,0),color(255,20,20)};
  color c = colors[id];
  Set<String> types = new Set<String>();
  types.add(names[id]);

  return new Part(id,c,types);

  /*int[][][] img = new int[6][8][8];
  int[] resources = new int[5];

  for(int k = 0;k<6;k++)
  {
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        img[k][i][j] = id;
    
    if(k<5)
    {
      if(k==id)
        resources[k] = SIZE*SIZE;
      else
        resources[k] = 0;
    }
  }

  int background = 0;
  String group = "elements";
  return new Part(img,resources,background,c,types,group);*/
}