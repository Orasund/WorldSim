public class SimulationManager
{
  private HashMap<String,Simulation> sims;
  private int[][] template_buffer;
  private String group;
  private Table listeners;
  private Table actions;

  SimulationManager()
  {
    sims = new HashMap<String,Simulation>();
    template_buffer = new int[SIZE][SIZE];
    group = "";

    table = new Table();
    table.addColumn("id",Table.INT);
    table.addColumn("x", Table.INT);
    table.addColumn("y", Table.INT);
    table.addColumn("sim", Table.FLOAT);
    table.addColumn("type", Table.FLOAT);

    listeners = new Table();
    listeners.addColumn("target",Table.STRING);
    listeners.addColumn("sim",Table.STRING);
  }

  void newSession(String name)
  {
    sims.clear();
    template_buffer = new int[SIZE][SIZE];
    group = name;
  }

  void listeningTo(String target,String sim)
  {

  }

  void add(String name, final Simulation sim)
  {
    //sim.addManager(this);
    sims.put(name,sim);
  }

  public void createEntry(int i, int x, int y)
  {
    if(template_buffer[x][y] == 0)
      return;

    template_buffer[x][y] = i;
  }

  public void deleteEntry(String type,int x, int y)
  {
    Part[] Tiles = Game.ObjectManager.getGroup(group);
    if(Tiles[template_buffer[x][y]].is("type"))
      template_buffer[x][y] = 0;
  }

  int[][] init(final int[][] template_,String group_)
  {
    int size = SIZE;
    ArrayList<Simulation> simList = new ArrayList<Simulation>(sims.values());

    //template_buffer = new int[size][size];
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
      {
         //template_buffer = 
         simList.get(i).sim(template,template_buffer,group_);
      }

      
      for(int i = 0; i<size; i++)
        for(int j = 0; j<size; j++)
          template[i][j] = template_buffer[i][j];
    }
    
    return template;
  }
}