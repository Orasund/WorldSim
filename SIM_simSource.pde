Simulation initSourceSim(final int[][] template,String group)
{
  String[] names = {};
  return new Simulation(names);
}

int[][] simSource(final int[][] template,final int[][] temp_template_,String group,Simulation sim)
{
  int[][] temp_template = new int[8][8];
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
      temp_template[i][j]=temp_template_[i][j];

  int x,y;
  int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};

  for(int i = 0; i<SIZE; i++)
    for(int j = 0; j<SIZE; j++)
    {
      if(template[i][j]!=2)
        continue;

      //(3)
      if(i==0 || j==0 || i==SIZE-1 || j==SIZE-1)
      {
        //simulationManager.deleteEntry("source",i,j);
        if(temp_template[i][j]==2)
          temp_template[i][j]=0;
        continue;
      }
      
      int[] neighbors = new int[4];
      int friends = 0;
      for(int k=0;k<4;k++)
      {
        x = i+dir[k][0];
        y = j+dir[k][1];
        neighbors[k] = template[x][y];
        if(template[x][y] == 2 || template[x][y] == 1)
          friends++;
      }

      if(friends == 0 || friends == 4)
        continue;
      
      //(1)
      if(friends == 1)
      {
        for(int k=0;k<4;k++)
        {
          x = i+dir[k][0];
          y = j+dir[k][1];
          if(template[x][y] != 2 && template[x][y] != 1)
            continue;
          
          x = i+dir[(k+2)%4][0];
          y = j+dir[(k+2)%4][1];
          
          //simulationManager.deleteEntry("source",i,j);
          if(temp_template[i][j]==2)
            temp_template[i][j]=0;
          //simulationManager.createEntry(2,x,y);
          if(temp_template[x][y]==0)
            temp_template[x][y]=2;
          //break;
        }
        continue;
      }

      //(2)
      for(int k=0;k<4;k++)
      {
        x = i+dir[k][0];
        y = j+dir[k][1];
        if(template[x][y] != 0)
          continue;

        //simulationManager.deleteEntry("source",i,j);
        if(temp_template[i][j]==2)
            temp_template[i][j]=0;
        //simulationManager.createEntry(2,x,y);
        if(temp_template[x][y]==0)
            temp_template[x][y]=2;
        //break;
      }
    }
  return temp_template;

  /*int size = 8;
  int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
  int x,y;

  int[][] temp_template = new int[8][8];
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
      temp_template[i][j]=temp_template_[i][j];

  for(int i=0;i<size;i++)
    for(int j=0;j<size;j++)
    {
      if(temp_template[i][j]!=2)
        continue;

      int coord[] = {i,j};
      
      temp_template[i][j]=0;

      if(i==0 || j==0 || i==7 || j==7)
        continue;
        
      int[] neighbors = new int[4];
      for(int k=0;k<4;k++)
      {
        x = i+dir[k][0];
        y = j+dir[k][1];
        neighbors[k] = template[x][y];
      }
      
      boolean found = false;

      for(int k=0;k<4;k++)
        if((neighbors[k]==1) && (neighbors[(k+1)%4]==2) && neighbors[(k+2)%4]==2 && (neighbors[(k+3)%4]==2))
        {
          for(int l=0;l<2;l++)
            coord[l] += dir[k][l];
          found = true;
          break;
        }
      
      if(found == false)
        for(int k=0;k<4;k++)
          if((neighbors[(k+2)%4]==2 || neighbors[(k+2)%4]==1) && neighbors[k]==0)
          {
            for(int l=0;l<2;l++)
              coord[l] += dir[k][l];
            break;
          }

      if(coord[0]>0 && coord[1]>0 && temp_template[coord[0]][coord[1]]==0)
        temp_template[coord[0]][coord[1]]=2;
    }
  return temp_template;*/
}