public class OrganicSim extends Simulation
{
  OrganicSim(final int[][] template,String group)
  {
    super(3);
    String[] names_ = {"organics","water","water_buffer"};
    setNames(names_);

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

  int[][] sim(final int[][] template,final int[][] temp_template_,String group,Simulation sim)
  {
    return simOrganic(template,temp_template_,group,sim);
  }
}