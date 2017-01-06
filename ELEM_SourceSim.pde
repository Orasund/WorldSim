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
  * (1)if entry next to one source or base
  *   move to oposite direction if possible
  *
  * (2)if next to more then one source or base
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
        if(template[i][j]!=2)
          continue;

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
  }
}