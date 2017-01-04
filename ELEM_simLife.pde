Simulation initLifeSim(final int[][] template,String group)
{
  String[] names = {};
  return new Simulation(names);
}

int[][] simLife(final int[][] template,final int[][] temp_template_,String group,Simulation sim)
{
  int size = 8;
  int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
  int x,y;

  int[][] temp_template = new int[size][size];
  for(int i=0;i<size;i++)
    for(int j=0;j<size;j++)
      temp_template[i][j]=temp_template_[i][j];
  
  for(int i=0;i<size;i++)
    for(int j=0;j<size;j++)
    {
      if(template[i][j] != 3)
        continue;

      int[] coord = {-1,-1};
      for(int k=0;k<4;k++)
      {
        x = i+dir[k][0];
        y = j+dir[k][1];
        if(x<0 || y<0 || x>7 || y>7)
          continue;
        
        if(template[x][y] == 2)
        {
          coord[0] = x;
          coord[1] = y;
          break;
        }
      }

      if(coord[0]>0 && coord[1]>0)
      {
        temp_template[coord[0]][coord[1]]=3;
        if(temp_template[i][j]!=4)
          temp_template[i][j]=3;
      }
      else if(temp_template[i][j]!=4)
        temp_template[i][j]=2;
    }

  return temp_template;
}