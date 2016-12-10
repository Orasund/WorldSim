public class Simulation
{
  private int[][][] tables;
  private String[] names;
  private int size;
  //public SimulationManager SimulationManager;

  Simulation(int n)
  {
    size = 8;
    names = new String[n];
    tables = new int[n][size][size];
    for(int i = 0; i < n; i++)
    {
      for(int j = 0; j < size; j++)
        for(int k = 0; k < size; k++)
          tables[i][j][k] = 0;
    }
    //SimulationManager = SimulationManager_;
  }

  //pls delete as fast as possible
  Simulation(final String[] names_)
  {
    size = 8;
    int n = names_.length;
    names = new String[n];
    tables = new int[n][size][size];
    for(int i = 0; i < n; i++)
    {
      names[i] = names_[i];

      for(int j = 0; j < size; j++)
        for(int k = 0; k < size; k++)
          tables[i][j][k] = 0;
    }
  }

  /*public void addManager(SimulationManager SimulationManager_)
  {
    SimulationManager = SimulationManager_;
  }*/

  void setNames(String[] names_)
  {
    for(int i = 0; i < names.length; i++)
      names[i] = names_[i];
  }

  Simulation copy()
  {
    Simulation out = new Simulation(names);
    for(int i = 0; i<names.length; i++)
      out.setTable(names[i], tables[i]);
    return out;
  }

  int getNumfromName(String name)
  {
    for(int i = 0; i < names.length; i++)
      if(names[i].equals(name))
        return i;
    println("BUG in Simulation.getNumfromName:name not found");
    return -1;
  }

  int[][] getTable(String name)
  {
    int[][] out = new int[size][size];

    int n = getNumfromName(name);

    for(int i = 0; i < n; i++)
      for(int j = 0; j < size; j++)
        out[i][j] = tables[n][i][j];
    
    return out;
  }

  void setTable(String name, final int[][] table)
  {
    int n = getNumfromName(name);

    for(int i = 0; i < n; i++)
      for(int j = 0; j < size; j++)
        tables[n][i][j] = table[i][j];
  }

  int getEntry(String name, int x, int y)
  {
    int n = getNumfromName(name);
    return tables[n][x][y];
  }

  void setEntry(String name, int x, int y,int value)
  {
    int n = getNumfromName(name);
    tables[n][x][y] = value;
  }

  //void
  int[][] sim(final int[][] template,final int[][] temp_template_,String group)
  {
            println("piep");
    return temp_template_;
  }
}