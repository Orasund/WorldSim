public class Tile implements Part
{
  public int[][][] img;
  public int[] resources;
  public int background;
  //public boolean isObj;
  private color c;
  public int x;
  public int y;
  private String name;

  Tile(int[][][] img_,int[]resources_,int background_, int x, int y, color c)
  {
    img = new int[6][8][8];
    for(int i = 0;i<6;i++)
      for(int j = 0;j<8;j++)
        for(int k = 0;k<8;k++)
          img[i][j][k] = img_[i][j][k];

    resources = new int[5];
    for(int i = 0;i<5;i++)
      resources[i] = resources_[i];
    
    background = background_;
    //isObj = isObj_;

    x = 0;
    y = 0;
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
    
    background = 0;
    //isObj = false;
    c = c_;

    x = 0;
    y = 0;
  }

  Tile(int[][] template, color c_)
  {    
    int[][] temp_template = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        temp_template[i][j]=template[i][j];
    
    int[][] map_empty = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        map_empty[i][j]=0;
        
    for(int k = 0;k<16;k++)
    {
      temp_template = iterate(temp_template,map_empty,0,0);
    }
    
    img = new int[6][8][8];
    resources = new int[5];
    for(int k = 0;k<6;k++)
    {
      temp_template = iterate(temp_template,map_empty,0,0);
      for(int i=0;i<8;i++)
        for(int j=0;j<8;j++)
        {
          img[k][i][j] = temp_template[i][j];
          if(k==0)
            resources[temp_template[i][j]]=0;
          if(k==5)
            resources[temp_template[i][j]]++;
        }
    }
    
    int[] mult = {1,4,12,20,1};
    background = 0;
    for(int i=1;i<5;i++)
      if(mult[i]*resources[i]>mult[background]*resources[background])
        background = i;
    
    c = c_;
    //isObj = false;

    x = 0;
    y = 0;
  }

  public Tile copy(){return new Tile(img,resources,background,x,y,c);}

  public int getX(){return x;}

  public int getY(){return y;}

  public String getName(){return name;}

  public boolean is(String type){return false;}

  public Part createInstance(int x, int y)
  {
    return new Tile(img,resources,background,x,y,c);
  }

  //Pls remove as fast as possible
  /*public Block createBlock(int x, int y)
  {
    return new Block(img,resources,background,x,y,c);
  }*/
  
  public int[][] getFrame(int i){return img[i];}

  public int[][] iterate(final int[][] template,final int[][] temp_template,final int x,final int y,final Part[] neighbors)
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

    drawBackground(x*8,y*8,background);

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