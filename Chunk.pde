public class Chunk implements Part
{
  private int[][] blocks;
  private int[] resources;
  private String group;
  private int background;
  private color c;
  private int x;
  private int y;
  private String name;

  Chunk(String name_, int[][] blocks_,String group_,int background_, int x_, int y_, color c_, int[] resources_)
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

    name = name_;
    group = group_;
    background = background_;
    x = x_;
    y = y_;
  }

  Chunk(color c_)
  {
    blocks = new int[8][8];
    for(int j = 0;j<8;j++)
      for(int k = 0;k<8;k++)
        blocks[j][k] = 0;
    
    group = "null";
    background = 0;
    resources = new int[0];
    c = c_;
    x = 0;
    y = 0;
  }

  Chunk(String name_, int[][] template_,String group_)
  { 
    int size = 8;
    resources = new int[size];
    for(int i = 0;i<size;i++)
    {
      resources[i] = 0;
    }

    
    int[][] temp_template = new int[size][size];
    blocks = new int[size][size];
    for(int j = 0;j<size;j++)
      for(int k = 0;k<size;k++)
      {
        temp_template[j][k] = template_[j][k];
        blocks[j][k] = template_[j][k];
      }
        

    Simulation organicSim = initOrganicSim(template_,group_);
    Simulation organicSpawnSim = initOrganicSpawnSim(template_,group_);
    
    for(int iter = 0; iter<16; iter++)    
    {
      temp_template = simOrganic(blocks,temp_template,group_,organicSim);
      temp_template = simOrganicSpawn(blocks,temp_template,group_,organicSpawnSim);
      
      for(int i = 0; i<size; i++)
        for(int j = 0; j<size; j++)
          blocks[i][j] = temp_template[i][j];
    }
      

    for(int j = 0;j<size;j++)
      for(int k = 0;k<size;k++)
      {
        //blocks[j][k] = template[j][k];
        resources[blocks[j][k]]++;
      }
    
    name = name_;
    group = group_;
    background = 0;
    c = color(0);
    x = 0;
    y = 0;
  }

  public Chunk copy()
  {
    /*int[][] b = new int[8][8];
    for(int j = 0;j<8;j++)
      for(int k = 0;k<8;k++)
      {
        b[j][k] = blocks[j][k];
      }*/
    return new Chunk(name,blocks,group,background,x,y,c,resources);
  }

  public int getX(){return x;}

  public int getY(){return y;}

  public String getName(){return name;}

  public Part createInstance(int x, int y)
  {
    /*int[][] b = new int[8][8];
    for(int j = 0;j<8;j++)
      for(int k = 0;k<8;k++)
        b[j][k] = blocks[j][k];*/
    return new Chunk(name,blocks,group,background,x,y,c,resources);
  }

  public int[][] iterate(final int[][] template,final int[][] temp_template,final int x,final int y,final Part[] neighbors){return temp_template;}

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

  public void drawFrame(int x, int y, int frame)
  {
    Part[] Tiles = Game.ObjectManager.getGroup(group);

    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        Tiles[blocks[i][j]].drawFrame(x*8+i,y*8+j,frame);
  }
}