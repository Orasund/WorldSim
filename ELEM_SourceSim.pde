public class SourceSim extends Simulation
{
  SourceSim(final int[][] template,String group)
  {
    super(0);
  }

  int[][] simOld(final int[][] template,final int[][] temp_template_,String group)
  {
    return simSource(template,temp_template_,group,this);
  }

  /*
  *
  * (1)if entry next to one source
  *   move to oposite direction if possible
  *
  * (2)if next to more then one source
  *   look clockwise for open space and move there
  *
  * (3)if touching borders
  *   delete
  *
  */
  int[][] sim(final int[][] template,final int[][] temp_template_,String group)
  {
    SimulationManager simulationManager = GAME.getSimulationManager();
    ObjectManager objectManager = GAME.getObjectManager();
    int x,y;

    for(int i = 0; i<SIZE; i++)
      for(int j = 0; j<SIZE; j++)
      {
        //(3)
        if(i==0 || j==0 || i==SIZE-1 || j==SIZE-1)
        {
          simulationManager.deleteEntry("source",i,j);
          continue;
        }
        
        int[] neighbors = new int[4];
        int friends = 0;
        for(int k=0;k<4;k++)
        {
          x = i+dir[k][0];
          y = j+dir[k][1];
          neighbors[k] = template[x][y];
          if(template[x][y] == 2)
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
            if(template[x][y] != 2)
              continue;
            
            x = i+dir[(k+2)%4][0];
            y = j+dir[(k+2)%4][1];
            
            simulationManager.deleteEntry("source",i,j);
            simulationManager.createEntry(2,x,y);
            break;
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

          simulationManager.deleteEntry("source",i,j);
          simulationManager.createEntry(2,x,y);
          break;
        }
      }
    return temp_template_;

/* old */
/*  for(int i=0;i<size;i++)
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
}