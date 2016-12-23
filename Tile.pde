public class Tile implements Part
{
  public int[][][] img;

  public PImage[] images;
  public int[] resources;
  public int background;
  public color c;
  public Set<String> types;

  Tile(int[][][] img_, int[] resources_, int background_, color c_, Set<String> types_)
  {
    resources = new int[5];
    for(int i = 0;i<5;i++)
      resources[i] = resources_[i];
    
    types = types_.copy();
    background = background_;
    c = c_;
    
    images = new PImage[6];
    img = new int[6][8][8];
    for(int i = 0;i<6;i++)
    {
      for(int j = 0;j<8;j++)
        for(int k = 0;k<8;k++)
          img[i][j][k] = img_[i][j][k];
      
      images[i] = Game.RenderEngine.createImgByIntArray(img[i],c,"elements");
    }
  }

  public Tile copy(){return new Tile(img,resources,background,c,types);}

  public boolean is(String type){
    return types.contains(type);
  }
  
  public int[][] getFrame(int i){return img[i];}

  public int[][] iterate(final int[][] template,final int[][] temp_template,final Part[] neighbors)
  {
    return iterateTile(template,temp_template);
  }

  public void drawFrame(int x, int y, int frame)
  {
    images[frame] = Game.RenderEngine.createImgByIntArray(img[frame],c,"elements");
    PImage image = images[frame].copy();
    Game.RenderEngine.drawImg(image,x*8,y*8);
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