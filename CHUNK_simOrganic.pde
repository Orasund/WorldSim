Simulation initOrganicSim(final int[][] template,String group)
{
  String[] names = {"organics","water","water_buffer"};
  Simulation sim = new Simulation(names);

  Part[] Tiles = Game.ObjectManager.getGroup(group);
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
          return sim;
        }
        sim.setEntry("organics",i,j,Tiles[template[i][j]].getResources()[3]);
      }
      else
        sim.setEntry("organics",i,j,0);
    }
      
  //creating water table and water_buffer
  for(int i = 0; i<size; i++)
    for(int j = 0; j<size; j++)
      if(Tiles[template[i][j]].is("water"))
      {
        sim.setEntry("water",i,j, 100);
        sim.setEntry("water_buffer",i,j,100);
      }

  return sim;
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
int[][] simOrganic(final int[][] template,final int[][] temp_template_,String group,Simulation sim)
{
  int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
  int x,y;
  int size = template[0].length;
  Part[] Tiles = Game.ObjectManager.getGroup(group);

  int[][] temp_template = new int[size][size];
  for(int i = 0; i<size; i++)
    for(int j = 0; j<size; j++)
      temp_template[i][j] = temp_template_[i][j];

  for(int i = 0; i<size; i++)
    for(int j = 0; j<size; j++)
      sim.setEntry("water_buffer",i,j,sim.getEntry("water",i,j));
  
  for(int i = 0; i<size; i++)
    for(int j = 0; j<size; j++)
    {
      if(sim.getEntry("water",i,j)<=0)
        continue;
      
      for(int k = 0; k<4; k++)
      {
        x = i+dir[k][0];
        y = j+dir[k][1];
        if(x<0 || y<0 || x>=size || y>=size)
          continue;
        if(sim.getEntry("organics",x,y)==0)
          continue;
        
        sim.setEntry("water",x,y,sim.getEntry("water",i,j));
        if(sim.getEntry("water",x,y)>sim.getEntry("organics",x,y))
          sim.setEntry("water",x,y,sim.getEntry("organics",x,y));
      }
    }
  
  for(int i = 0; i<size; i++)
    for(int j = 0; j<size; j++)
    {
      if(sim.getEntry("water_buffer",i,j)>0)
      {
        sim.setEntry("water",i,j,0);
        sim.setEntry("organics",i,j,0);
      }

      if(sim.getEntry("organics",i,j)==0)
        continue;

      if(sim.getEntry("organics",i,j)==1)
      {
        //Delete
        if(Tiles[temp_template[i][j]].is("organic"))
          temp_template[i][j] = 0;
      }

      sim.setEntry("organics",i,j,sim.getEntry("organics",i,j)-1);
    }

  return temp_template;
}