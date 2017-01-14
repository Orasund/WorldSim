Simulation initLifeSim(final int[][] template,String group)
{
  String[] names = {};
  return new Simulation(names);
}

/*
*
* (1) if source next to it
*   chance source to life
* 
* (2) if no source next to it
*   chance to source
*
*/
int[][] simLife(final int[][] template,final int[][] temp_template_,String group,Simulation sim)
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
      if(template[i][j] != 3)
        continue;

      int friends = 0;
      for(int k=0;k<4;k++)
      {
        x = i+dir[k][0];
        y = j+dir[k][1];
        if(x<0 || y<0 || x>=SIZE || y>=SIZE)
          continue;
        
        if(template[x][y] != 2)
          continue;
        
        friends++;
        //simulationManager.deleteEntry("source",x,y);
        if(temp_template[x][y]==2)
          temp_template[x][y]=0;
        //simulationManager.createEntry(3,x,y);
        if(temp_template[x][y]==0)
          temp_template[x][y]=3;
        //break;
      }

      //(2)
      if(friends == 0)
      {
        //simulationManager.deleteEntry("life",i,j);
        if(temp_template[i][j]==3)
          temp_template[i][j]=0;
        //simulationManager.createEntry(2,i,j);
        if(temp_template[i][j]==0)
          temp_template[i][j]=2;
      }

      /*if(coord[0]>0 && coord[1]>0)
      {
        temp_template[coord[0]][coord[1]]=3;
        if(temp_template[i][j]!=4)
          temp_template[i][j]=3;
      }
      else if(temp_template[i][j]!=4)
        temp_template[i][j]=2;*/
    }

  return temp_template;
}