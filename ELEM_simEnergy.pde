Simulation initEnergySim(final int[][] template,String group)
{
  String[] names = {};
  return new Simulation(names);
}

/****************************
*
* if Entry is next to Life
*   chance Life to Energy, create Energy oposit of Life
*
* if Entry has no Energy and no Life next to it
*   chance Entry to Void
*
* if Entry has more then 1 Energy next to it
*   chance to Life
*
* if Entry has exactly one Energy next to it
*   create Energy on oposit side.
*   if not possible
*     chance to Life
*
****************************/
int[][] simEnergy(final int[][] template,final int[][] temp_template_,String group,Simulation sim)
{
  //int size = SIZE;
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

      temp_template[i][j]=0;

      int[] coord = {-1,-1}; //bullshit
      int[] neighbors = new int[4];
      int friend = 0;
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
          friend++;
        if(template[x][y] == 4 || template[x][y] == 3)
        {
          temp_template[i][j]=3;
        }
      }

      for(int k=0;k<4;k++)
      {
        if(neighbors[k] == 3 && neighbors[(k+2)%4] == 0)
        {
          x = i+dir[k][0];
          y = j+dir[k][1];
          temp_template[x][y]=4;
          x = i+dir[(k+2)%4][0];
          y = j+dir[(k+2)%4][1];
          temp_template[x][y]=4;
        }
      }
      
      if(friend > 1)
        temp_template[i][j]=3;
      else
        temp_template[i][j]=4;
      
      if(friend == 1)
      for(int k=0;k<4;k++)
      {
        if(neighbors[k] != 4)
          continue;
        
        if(neighbors[(k+2)%4] != 0)
          break;
        
        x = i+dir[(k+2)%4][0];
        y = j+dir[(k+2)%4][1];
        temp_template[x][y]=4;
      }
    }

  return temp_template;
}