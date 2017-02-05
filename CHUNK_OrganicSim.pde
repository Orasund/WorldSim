public class OrganicSim extends Simulation
{
  OrganicSim(final int[][] template,String group)
  {
    //super(3,SimulationManager_);
    super(3);

    ObjectManager objectManager = GAME.getObjectManager();

    String[] names_ = {"organics","floid","floid_buffer"};
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
          int value = Tiles[template[i][j]].getResources()[3];
          if(value > 16)
            value = 16;
          setEntry("organics",i,j,value);
        }
        else
          setEntry("organics",i,j,0);
      }
        
    //creating floid table and floid_buffer
    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
        if(Tiles[template[i][j]].is("floid"))
        {
          setEntry("floid",i,j, 100);
          setEntry("floid_buffer",i,j,100);
        }
  }

  void callEvent(String type, String event, int x, int y, int id)
  {
    String group = GAME.getSimulationManager().getGroup();
    Part[] tiles = GAME.getObjectManager().getGroup(group);
    switch(type)
    {
      case "floid":
        switch(event)
        {
          case "create":
            setEntry("floid",x,y,100);
            break;
          case "delete":
            setEntry("floid",x,y,0);
            break;
        }
        break;

      case "organic":
        switch(event)
        {
          case "create":
            setEntry("organics",x,y,tiles[id].getResources()[3]);
            break;
          case "delete":
            setEntry("organics",x,y,0);
            break;
        }
        break;
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
  *   1.)create food&floid-table and a floid_buffer-table
  *   2.)set food to amount of life-parts in Tile
  *   3.)set floid to 100 for each floid Tile
  *   4.)iterate 16 times
  *     A.)floid_buffer = floid
  *     B.)for each floidEntry >0
  *       a.)for each foodEntry next to floidEntry
  *         i.)(old)floid.foodEntry += floidEntry.value [max at foodEntry.value]
  *         i.)floid.foodEntry++;
  *     C.)for each floid_bufferEntry
  *       a.)set floidEntry = 0
  *       b.)set foodEntry = 0
  *     D.)for each food
  *       a.)if foodEntry = 1 delete
  *       b.)WaterEntry-=1
  *   5.)for each floidEntry
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

    //(A)
    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
        setEntry("floid_buffer",i,j,getEntry("floid",i,j));
    
    //(B)
    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
      {
        if(getEntry("floid",i,j)<=0)
          continue;
        
        for(int k = 0; k<4; k++)
        {
          x = i+dir[k][0];
          y = j+dir[k][1];
          if(x<0 || y<0 || x>=size || y>=size)
            continue;
          if(getEntry("organics",x,y)==0)
            continue;
          
          //setEntry("floid",x,y,getEntry("floid",i,j));
          setEntry("floid",x,y,getEntry("floid",x,y)+1);
          if(getEntry("floid",x,y)>getEntry("organics",x,y))
            setEntry("floid",x,y,getEntry("organics",x,y));
        }
      }
  
    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
      {
        if(getEntry("floid_buffer",i,j)>0)
        {
          setEntry("floid",i,j,0);
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