int[][] iterateTile(int[][] template, int[][] temp_template_)
{
  Part[] elements = Game.ObjectManager.getGroup("elements");

  int[][] temp_template = new int[8][8];
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
      temp_template[i][j]=temp_template_[i][j];
  
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
    {
      if(template[i][j] == 0)
        continue;
      Part part = elements[template[i][j]];
      Part[] neighbors = new Part[4];
      int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
      for(int k = 0; k < 4; k++)
      {
        int x = dir[k][0]+i;
        int y = dir[k][1]+j;
        if(x>=0 && x<8 && y>=0 && y<8)
          neighbors[k] = elements[template[x][y]].copy();
        else
          neighbors[k] = elements[0].copy();
      }
        
      temp_template = part.iterate(template,temp_template,i, j, neighbors);
    }
      
  return temp_template;
}