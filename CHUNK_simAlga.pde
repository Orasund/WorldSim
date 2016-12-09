Simulation initOrganicSpawnSim(final int[][] template,String group)
{
  String[] names = {"water","organic_spawn"};
  Simulation sim = new Simulation(names);
  Part[] Tiles = Game.ObjectManager.getGroup(group);
  int size = template[0].length;

  //creating water table and organic_spawn
  for(int i = 0; i<size; i++)
    for(int j = 0; j<size; j++)
    {
      if(Tiles[template[i][j]].is("water"))
      {
        sim.setEntry("water",i,j, 1);
      }

      if(Tiles[template[i][j]].is("organic_spawn"))
      {
        sim.setEntry("organic_spawn",i,j, 1);
      }
    }

  return sim; 
}

int[][] simOrganicSpawn(final int[][] template,final int[][] temp_template_,String group,Simulation sim)
{
  int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
  int x,y,x2,y2;
  int size = template[0].length;
  Part[] Tiles = Game.ObjectManager.getGroup(group);

  int[][] temp_template = new int[size][size];
  for(int i = 0; i<size; i++)
    for(int j = 0; j<size; j++)
      temp_template[i][j] = temp_template_[i][j];

  for(int i = 0; i<size; i++)
    for(int j = 0; j<size; j++)
    {
      if(sim.getEntry("organic_spawn",i,j)==0)
        continue;

      //create new spawn if possible

      for(int k = 0; k<4; k++)
      {
        x = i+dir[k][0];
        y = j+dir[k][1];
        if(x<0 || y<0 || x>=size || y>=size)
          continue;

        if(sim.getEntry("water",x,y)==0)
          continue;
        
        if(sim.getEntry("organic_spawn",x,y)==1)
          continue;

        //two or three waters next to it are allowed
        int count = 0;
        for(int l = 0; l<4; l++)
        {
          x2 = x+dir[l][0];
          y2 = y+dir[l][1];
          if(x2<0 || y2<0 || x2>=size || y2>=size)
          continue;

          if(sim.getEntry("water",x2,y2)==0)
            continue;
          
          count++;
        }

        if(count>3 || count <2)
          continue;
        
        //new spawn can be created
        temp_template[x][y] = template[i][j];
        sim.setEntry("organic_spawn",x,y,1);
      }
    }

  return temp_template;
}