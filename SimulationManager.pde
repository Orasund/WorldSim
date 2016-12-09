public class SimulationManager
{
  private HashMap<String,Simulation> sims;
  private int[][] template_buffer;

  SimulationManager()
  {
    sims = new HashMap<String,Simulation>();
    template_buffer = new int[SIZE][SIZE];
  }

  void add(String name, final Simulation sim)
  {
    sim.addManager(this);
    sims.put(name,sim);
  }

  void createEntry(int i, int x, int y)
  {
    if(template_buffer[x][y] == 0)
      return;

    template_buffer[x][y] = i;
  }

  void deleteEntry(int x, int y)
  {
    template_buffer[x][y] = 0;
  }

  int[][] init(final int[][] template_,String group_)
  {
    int size = SIZE;
    ArrayList<Simulation> simList = new ArrayList<Simulation>(sims.values());

    template_buffer = new int[size][size];
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
        simList.get(i).sim(template,template_buffer,group_);
        //template_buffer = 
      
      for(int i = 0; i<size; i++)
        for(int j = 0; j<size; j++)
          template[i][j] = template_buffer[i][j];
    }
    
    return template;
  }
}