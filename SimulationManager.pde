public class SimulationManager
{
  private HashMap<String,Simulation> sims;

  SimulationManager()
  {
    sims = new HashMap<String,Simulation>();
  }

  void add(String name, final Simulation sim)
  {
    sims.put(name,sim);
  }

  int[][] init(final int[][] template_,String group_)
  {
    int size = 8;
    ArrayList<Simulation> simList = new ArrayList<Simulation>(sims.values());

    int[][] template_buffer = new int[size][size];
    int[][] template = new int[size][size];
    for(int i = 0;i<size;i++)
      for(int j = 0;j<size;j++)
      {
        template_buffer[i][j] = template_[i][j];
        template[i][j] = template_[i][j];
      }
    
    for(int iter = 0; iter<16; iter++)    
    {
      for(int i=0; i<simList.size(); i++)
        template_buffer = simList.get(i).sim(template,template_buffer,group_);
      
      for(int i = 0; i<size; i++)
        for(int j = 0; j<size; j++)
          template[i][j] = template_buffer[i][j];
    }
    
    return template;
  }
}