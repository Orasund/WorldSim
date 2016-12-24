public class OrganicSim extends Simulation
{
  OrganicSim(final int[][] template,String group)
  {
    //super(3,SimulationManager_);
    super(3);

    ObjectManager objectManager = GAME.getObjectManager();

    String[] names_ = {"organics","water","water_buffer"};
    setNames(names_);

    Part[] Tiles = objectManager.getGroup(group);
    int size = template[0].length;

    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
      {
        if(Tiles[template[i][j]].is("organic"))
        {
          //we assume that the groupname is element
          if(Tiles[template[i][j]].getGroupName().equals("elements")==false)
          {
            println("BUG in simOrganic:groupname not elements");
            return;
          }
          setEntry("organics",i,j,Tiles[template[i][j]].getResources()[3]);
        }
        else
          setEntry("organics",i,j,0);
      }
        
    //creating water table and water_buffer
    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
        if(Tiles[template[i][j]].is("water"))
        {
          setEntry("water",i,j, 100);
          setEntry("water_buffer",i,j,100);
        }
  }

  /*
  * Input
  *   template ... a array of the last iteration
  *   temp_template ... a array with updates to the template
  *   group ... name of the group of Parts for the template
  *   sim ... a simulationObject that helps with keeping data stored
  *
  * Output
  *   temp_template ... the same array but with new updates
  *
  * Algorithm
  *   1.)create food&water-table and a water_buffer-table
  *   2.)set food to amount of life-parts in Tile
  *   3.)set water to 100 for each water Tile
  *   4.)iterate 16 times
  *     A.)water_buffer = water
  *     B.)for each waterEntry >0
  *       a.)for each foodEntry next to waterEntry
  *         i.)water.foodEntry += waterEntry.value [max at foodEntry.value]
  *     C.)for each water_bufferEntry
  *       a.)set waterEntry = 0
  *       b.)set foodEntry = 0
  *     D.)for each food
  *       a.)if foodEntry = 1 delete
  *       b.)WaterEntry-=1
  *   5.)for each waterEntry
  *     A.) delete
  */
  int[][] sim(final int[][] template,final int[][] temp_template_,String group)
  {
    SimulationManager simulationManager = GAME.getSimulationManager();
    ObjectManager objectManager = GAME.getObjectManager();

    int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
    int x,y;
    int size = template[0].length;
    Part[] Tiles = objectManager.getGroup(group);

    int[][] temp_template = new int[size][size];
    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
        temp_template[i][j] = temp_template_[i][j];

    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
        setEntry("water_buffer",i,j,getEntry("water",i,j));
    
    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
      {
        if(getEntry("water",i,j)<=0)
          continue;
        
        for(int k = 0; k<4; k++)
        {
          x = i+dir[k][0];
          y = j+dir[k][1];
          if(x<0 || y<0 || x>=size || y>=size)
            continue;
          if(getEntry("organics",x,y)==0)
            continue;
          
          setEntry("water",x,y,getEntry("water",i,j));
          if(getEntry("water",x,y)>getEntry("organics",x,y))
            setEntry("water",x,y,getEntry("organics",x,y));
        }
      }
  
    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
      {
        if(getEntry("water_buffer",i,j)>0)
        {
          setEntry("water",i,j,0);
          setEntry("organics",i,j,0);
        }

        if(getEntry("organics",i,j)==0)
          continue;

        if(getEntry("organics",i,j)==1)
        {
          //Delete
          simulationManager.deleteEntry("organic",i,j);
          //if(Tiles[temp_template[i][j]].is("organic"))
            //temp_template[i][j] = 0;
        }

        setEntry("organics",i,j,getEntry("organics",i,j)-1);
      }

    return temp_template;
  }
}