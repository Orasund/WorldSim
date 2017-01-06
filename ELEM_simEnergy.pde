Simulation initEnergySim(final int[][] template,String group)
{
  String[] names = {};
  return new Simulation(names);
}

/****************************
*
* (1)if next to Life
*   chance Life to Energy
*
* (2)if exactly one Energy is next to it
*   create Energy on oposit side.
*   if not possible
*     chance to Life
*
* (3)else
*   chance to life
*
****************************/
int[][] simEnergy(final int[][] template,final int[][] temp_template_,String group,Simulation sim)
{
  int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
  int x,y;

  int[][] temp_template = new int[SIZE][SIZE];
  for(int i=0;i<SIZE;i++)
    for(int j=0;j<SIZE;j++)
      temp_template[i][j]=temp_template_[i][j];
  
  for(int i=0;i<SIZE;i++)
    for(int j=0;j<SIZE;j++)
    {
      if(template[i][j] != 4)
        continue;

      int[] neighbors = new int[4];
      int friends = 0;
      int sources = 0;
      for(int k=0;k<4;k++)
      {
        x = i+dir[k][0];
        y = j+dir[k][1];
        if(x<0 || y<0 || x>=SIZE || y>=SIZE)
        {
          neighbors[k] = 1;
          continue;
        }
        
        neighbors[k] = template[x][y];
        if(template[x][y] == 4)
          friends++;
        
        if(template[x][y] == 3)
          sources++;
      }

      //(2)
      if(friends == 1)
      {
        for(int k=0;k<4;k++)
        {
          if(neighbors[k] != 4)
            continue;
          
          if(neighbors[(k+2)%4] != 0)
          {
            temp_template[i][j]=3;
            break;
          }

          x = i+dir[(k+2)%4][0];
          y = j+dir[(k+2)%4][1];
          if(x<0 || y<0 || x>=SIZE || y>=SIZE)
            break;
          temp_template[x][y]=4;
        }
        //continue;
      }

      //(1)
      if(sources != 0)
      {
        for(int k=0;k<4;k++)
        {
          if(neighbors[k] == 3)
          {
            x = i+dir[k][0];
            y = j+dir[k][1];
            temp_template[x][y]=4;
          }
        }
        continue;
      }
      
      //(3)
      temp_template[i][j]=3;
    }

  return temp_template;
}