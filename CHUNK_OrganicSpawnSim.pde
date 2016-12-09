public class OrganicSpawnSim extends Simulation
{
  OrganicSpawnSim(final int[][] template,String group)
  {
    super(2);
    String[] names_ = {"water","organic_spawn"};
    setNames(names_);
    
    Part[] Tiles = Game.ObjectManager.getGroup(group);
    int size = template[0].length;

    //creating water table and organic_spawn
    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
      {
        if(Tiles[template[i][j]].is("water"))
        {
          setEntry("water",i,j, 1);
        }

        if(Tiles[template[i][j]].is("organic_spawn"))
        {
          setEntry("organic_spawn",i,j, 1);
        }
      }
  }

  int[][] sim(final int[][] template,final int[][] temp_template_,String group,Simulation sim)
  {
    return simOrganicSpawn(template,temp_template_,group,sim);
  }
}