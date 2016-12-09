public class Tile implements Part
{
  public int[][][] img;
  public int[] resources;
  public int background;
  public color c;
  public Set<Boolean> types;

  Tile(int[][][] img_,int[]resources_,int background_, color c_,Set<Boolean> types_)
  {
    img = new int[6][8][8];
    for(int i = 0;i<6;i++)
      for(int j = 0;j<8;j++)
        for(int k = 0;k<8;k++)
          img[i][j][k] = img_[i][j][k];

    resources = new int[5];
    for(int i = 0;i<5;i++)
      resources[i] = resources_[i];
    
    types = types_.copy();

    background = background_;

    c = c_;
  }

  Tile(color c_)
  {
    int[][][] img_ = new int[6][8][8];
    for(int i = 0;i<6;i++)
      for(int j = 0;j<8;j++)
        for(int k = 0;k<8;k++)
          img_[i][j][k] = 0;
    
    int[] resources_ = new int[5];
    for(int k = 0;k<5;k++)
      resources_[k] = 0;
    
    types = new Set<Boolean>();
    
    background = 0;
    c = c_;
  }

  Tile(int[][] template, color c_)
  { 
    types = new Set<Boolean>();

    int[][] temp_template = new int[8][8];
    int[][] map_empty = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
      {
        temp_template[i][j]=template[i][j];
        map_empty[i][j]=template[i][j];
      }

    String group = "elements";

    //Iteration
    img = new int[6][8][8];

    resources = new int[5];
    for(int i = 0;i<5;i++)
      resources[i] = 0;

    for(int iter = 0;iter<16;iter++)
    {
      map_empty = iterate(temp_template,map_empty,0,0);

      for(int i=0;i<8;i++)
        for(int j=0;j<8;j++)
        {
          temp_template[i][j] = map_empty[i][j];
        
          if(iter>=10)
            img[iter-10][i][j] = temp_template[i][j];
        }
    }
    
    
    resources = new int[5];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        resources[temp_template[i][j]]++;
    
    int[] mult = {1,4,12,20,1};
    background = 0;
    for(int i=1;i<5;i++)
      if(mult[i]*resources[i]>mult[background]*resources[background])
        background = i;
    
    c = c_;
  }

  public Tile copy(){return new Tile(img,resources,background,c,types);}

  public boolean is(String type){return false;}
  
  public int[][] getFrame(int i){return img[i];}

  public int[][] iterate(final int[][] template,final int[][] temp_template,final Part[] neighbors)
  {
    return iterateTile(template,temp_template);
  }
  
  //PLS remove as fast as possible
  public int[][] iterate(int[][] template,int[][] temp_template, int x, int y)
  {
    return iterateTile(template,temp_template);
  }

  public void drawFrame(int x, int y, int frame)
  {
    int[][] template = img[frame];
    Part[] elements = Game.ObjectManager.getGroup("elements");

    fill(c);
    Game.RenderEngine.drawBackground(x*8,y*8);

    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
      {
        if(template[i][j] == 0)
          continue;
        
        fill(elements[template[i][j]].getColor());
        Game.RenderEngine.drawRect(x*8+i,y*8+j);
      }
  }

  public color getColor()
  {
    return c;
  }

  public int[] getResources()
  {
    return resources;
  }

  public String getGroupName()
  {
    return "elements";
  }
}