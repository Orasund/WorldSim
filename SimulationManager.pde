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
    sims.put(name,sim);
  }

  public void createEntry(int i, int x, int y)
  {
    TableRow newRow = actions.addRow();
    newRow.setInt("id", i);
    newRow.setInt("x", x);
    newRow.setInt("y", y);
    newRow.setString("action", "create");
    newRow.setString("type", "");
  }

  public void deleteEntry(String type,int x, int y)
  {
    println("call deleteEntry@SimulationManager");

    TableRow newRow = actions.addRow();
    newRow.setInt("id", 0);
    newRow.setInt("x", x);
    newRow.setInt("y", y);
    newRow.setString("action", "delete");
    newRow.setString("type", type);
  }

  public void tellListeners(String type, String event, int x, int y, int id)
  {
    println("call tellListeners@SimulationManager");

    for (TableRow row : listeners.findRows(type,"target")) {
      sims.get(row.getString("sim")).callEvent(type,event,x,y,id);
    }
  }

  int[][] init(final int[][] template_)
  {
    ObjectManager objectManager = GAME.getObjectManager();
    Part[] tiles = objectManager.getGroup(group);

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
      //set actions
      for(int i=0; i<simList.size(); i++)
        simList.get(i).sim(template,template_buffer,group);

      //process actions
      int max = actions.getRowCount();
      for(int i = 0; i<max; i++)
      {
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

              String[] types = tiles[template_buffer[x][y]].getTypes();
              for(int j=0; j< types.length; j++)
                tellListeners(types[j],"create",x,y,id);
            }
            break;

          case "delete":
            if(tiles[template_buffer[x][y]].is(type))
            {
              template_buffer[x][y] = 0;
              tellListeners(type,"delete",x,y,0);
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

  String getGroup()
  {
    return group;
  }
}