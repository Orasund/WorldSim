public class OrganicSpawnSim extends Simulation
{
  private IntList organic_parts;

  OrganicSpawnSim(final int[][] template,String group)
  {
    super(2);//, SimulationManager_);

    ObjectManager objectManager = GAME.getObjectManager();
    organic_parts = new IntList();

    Part[] tiles = objectManager.getGroup(group);
    for(int i = 1; i < tiles.length; i++)
      if(tiles[i].is("organic"))
        organic_parts.append(i); 


    String[] names_ = {"water","organic_spawn"};
    setNames(names_);
    
    
    int size = template[0].length;

    //creating water table and organic_spawn
    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
      {
        if(tiles[template[i][j]].is("water"))
        {
          setEntry("water",i,j, 1);
        }

        if(tiles[template[i][j]].is("organic_spawn"))
        {
          setEntry("organic_spawn",i,j, 1);
        }
      }
  }

  void callEvent(String type, String event, int x, int y, int id)
  {
    String group = GAME.getSimulationManager().getGroup();
    Part[] tiles = GAME.getObjectManager().getGroup(group);
    switch(type)
    {
      case "water":
        switch(event)
        {
          case "create":
            setEntry("water",x,y,1);
            break;
          case "delete":
            setEntry("water",x,y,0);
            break;
        }
        break;
      
      case "organic_spawn":
        switch(event)
        {
          case "create":
            setEntry("organic_spawn",x,y,1);
            break;
          case "delete":
            setEntry("organic_spawn",x,y,0);
            break;
        }
        break;
    }
    
  }

  //void
  int[][] sim(final int[][] template,final int[][] temp_template_,String group)
  {
    ObjectManager objectManager = GAME.getObjectManager();
    SimulationManager simulationManager = GAME.getSimulationManager();
    Part[] tiles = objectManager.getGroup(group);

    //return simOrganicSpawn(template,temp_template_,group,sim);
    int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
    int x,y,x2,y2;
    int size = template[0].length;

    int[][] temp_template = new int[size][size];
    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
        temp_template[i][j] = temp_template_[i][j];

    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
      {
        if(getEntry("organic_spawn",i,j)!=1)
          continue;

        //create new spawn if possible
        for(int k = 0; k<4; k++)
        {
          x = i+dir[k][0];
          y = j+dir[k][1];
          if(x<0 || y<0 || x>=size || y>=size)
            continue;

          if(template[x][y] == 0)
          {

            if(organic_parts.size()==0)
              continue;

            //try to create an organic Part
            int my_id = x+y;
            int index = my_id % organic_parts.size();
            simulationManager.createEntry(organic_parts.get(index),x,y);
            continue;
          }

          if(getEntry("water",x,y)==0)
            continue;
          
          if(getEntry("organic_spawn",x,y)==1)
            continue;

          int count = 0;
          for(int l = 0; l<4; l++)
          {
            x2 = x+dir[l][0];
            y2 = y+dir[l][1];
            if(x2<0 || y2<0 || x2>=size || y2>=size)
            continue;

            if(getEntry("water",x2,y2)==0)
              continue;
            
            count++;
          }
          if(count>3 || count <2)
            continue;
          
          //new spawn can be created
          simulationManager.deleteEntry("water",x,y);
          simulationManager.createEntry(template[i][j],x,y);
          //setEntry("organic_spawn",x,y,1);
        }
      }

    return temp_template;
  }
}