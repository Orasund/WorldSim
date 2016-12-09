Tile evaluateTile(int[][] template)
{
  Tile out;
  Set<String> types = new Set<String>();

  //Iterate for 16 Ticks
  int[][] temp_template = new int[8][8];
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
      temp_template[i][j]=template[i][j];
  
  int[][] map_empty = new int[8][8];
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
      map_empty[i][j]=0;
      
  for(int k = 0;k<16;k++)
    temp_template = iterateTile(temp_template,map_empty);
  
  int[][][] img = new int[6][8][8];
  int[] resources = new int[5];
  for(int k = 0;k<6;k++)
  {
    temp_template = iterateTile(temp_template,map_empty);
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
      {
        img[k][i][j] = temp_template[i][j];
        if(k==0)
          resources[temp_template[i][j]]=0;
        if(k==5)
          resources[temp_template[i][j]]++;
      }
  }

  //create simple Background
  // 1 stone = 4 void
  // 1 source = 3 stone = 12 void
  // 1 life = 2.66 source = 5 stone = 20 void
  int[] mult = {1,4,12,20,1};
  int background = 0;
  for(int i=1;i<5;i++)
    if(mult[i]*resources[i]>mult[background]*resources[background])
      background = i;
  
  //life
  switch(background)
  {
    //organic
    case 3:
      out = new Organic(img,resources,background,color(0,128,0),types);
      break;

    //water
    case 2:
      //does life exist?
      if(resources[3]>0) //OrganicSpawn
        out = new OrganicSpawn(img,resources,background,color(53,80,128),types);
      else //water
        types.add("water");
        out = new Water(img,resources,background,color(80,80,256),types);
      break;

    //stone
    case 1:
      out = new Tile(img,resources,background,color(127,127,127),types);
      break;

    //ground
    default:
      out = new Tile(img,resources,background,color(80,255,80),types);
  }

  return out;
}