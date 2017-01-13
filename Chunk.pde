public class Chunk implements Part
{
  private int[][] blocks;
  private int[] resources;
  private String group;
  private int background;
  private color c;

  Chunk(int[][] blocks_,String group_,int background_, color c_, int[] resources_)
  {
    blocks = new int[8][8];
    for(int j = 0;j<8;j++)
      for(int k = 0;k<8;k++)
      {
        blocks[j][k] = blocks_[j][k];
      }

    resources = new int[8];
    for(int i = 0;i<8;i++)
    {
      resources[i] = resources_[i];
    } 

    group = group_;
    background = background_;
  }

  /*Chunk(color c_)
  {
    blocks = new int[8][8];
    for(int j = 0;j<8;j++)
      for(int k = 0;k<8;k++)
        blocks[j][k] = 0;
    
    group = "null";
    background = 0;
    resources = new int[0];
    c = c_;
  }

  Chunk(final int[][] template_,String group_)
  { 
    //int size = SIZE;

    SimulationManager simulationManager = GAME.getSimulationManager();

    simulationManager.newSession(group_);
    simulationManager.add("Organic",new OrganicSim(template_,group_));
    simulationManager.listenTo("water","Organic");
    simulationManager.listenTo("organic","Organic");
    simulationManager.add("OrganicSpawn",new OrganicSpawnSim(template_,group_));
    simulationManager.listenTo("water","OrganicSpawn");
    simulationManager.listenTo("organic_spawn","OrganicSpawn");
    
    blocks = simulationManager.init(template_);

    resources = new int[SIZE];
    for(int i = 0;i<SIZE;i++)
      resources[i] = 0;

    for(int j = 0;j<SIZE;j++)
      for(int k = 0;k<SIZE;k++)
        resources[blocks[j][k]]++;
    
    group = group_;
    background = 0;
    c = color(0);
  }*/

  public Chunk copy()
  {
    return new Chunk(blocks,group,background,c,resources);
  }

  public int[][] iterate(final int[][] template,final int[][] temp_template,final Part[] neighbors){return temp_template;}


  public color getColor(){return c;}

  public boolean is(String type){return false;}

  public int[] getResources()
  {
    return resources;
  }

  public String getGroupName()
  {
    return group;
  }

  public String[] getTypes()
  {
    return new String[0];
  }

  public void drawFrame(int x, int y, int frame)
  {
    drawPartGrid(x,y,frame,blocks,group);
    /*ObjectManager objectManager = GAME.getObjectManager();

    Part[] Tiles = objectManager.getGroup(group);

    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        Tiles[blocks[i][j]].drawFrame(x*8+i,y*8+j,frame);*/
  }
}