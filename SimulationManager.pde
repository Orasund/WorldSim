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

    actions = new Table();
    actions.addColumn("id",Table.INT);
    actions.addColumn("x", Table.INT);
    actions.addColumn("y", Table.INT);
    actions.addColumn("action", Table.STRING);
    //table.addColumn("sim", Table.STRING);
    actions.addColumn("type", Table.STRING);

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

  void listenTo(String target,String sim)
  {
    TableRow newRow = listeners.addRow();
    newRow.setString("target", target);
    newRow.setString("sim", sim);
  }

  void add(String name, final Simulation sim)
  {
    //sim.addManager(this);
    sims.put(name,sim);
  }

  public void createEntry(int i, int x, int y)
  {
    /*if(template_buffer[x][y] == 0)
      return;

    template_buffer[x][y] = i;*/
    TableRow newRow = actions.addRow();
    newRow.setInt("id", i);
    newRow.setInt("x", x);
    newRow.setInt("y", y);
    newRow.setString("action", "create");
    newRow.setString("type", "");
  }

  public void deleteEntry(String type,int x, int y)
  {
    /*Part[] Tiles = Game.ObjectManager.getGroup(group);
    if(Tiles[template_buffer[x][y]].is(type))
      template_buffer[x][y] = 0;*/
    TableRow newRow = actions.addRow();
    newRow.setInt("id", 0);
    newRow.setInt("x", x);
    newRow.setInt("y", y);
    newRow.setString("action", "delete");
    newRow.setString("type", type);

    /*for(int i = 0; i<actions.getRowCount(); i++)
    {
      TableRow row = actions.getRow(i);
      if(row.getString("target") == type)
      {
        
      }
    }*/

  }

  //,String group_)
  int[][] init(final int[][] template_)
  {
    int size = SIZE;
    ArrayList<Simulation> simList = new ArrayList<Simulation>(sims.values());

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
        simList.get(i).sim(template,template_buffer,group);

      int max = actions.getRowCount();
      for(int i = 0; i<max; i++)
      {
        println(i+":"+max);
        TableRow row = actions.getRow(i);
        int x = row.getInt("x");
        int y = row.getInt("y");
        int id = row.getInt("id");
        String type = row.getString("type");
        switch(row.getString("action"))
        {
          case "create":
            if(template_buffer[x][y] == 0)
            {
              template_buffer[x][y] = id;
              println("create:"+id); 
            }
            else 
            {
              println("woooot?");
            }
            break;

          case "delete":
            Part[] Tiles = Game.ObjectManager.getGroup(group);
            if(Tiles[template_buffer[x][y]].is(type))
            {
              println("delete:"+type); 
              template_buffer[x][y] = 0;
            }
            break;
        }
      }

      actions.clearRows();

      for(int i = 0; i<size; i++)
        for(int j = 0; j<size; j++)
          template[i][j] = template_buffer[i][j];
    }
    
    return template;
  }
}