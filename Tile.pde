public class Tile implements Part
{
  private int[][][] img;
  private PImage[] images;
  private int[] resources;
  private int background;
  private color c;
  private Set<String> types;

  Tile(int[][][] img_, int[] resources_, int background_, color c_, Set<String> types_)
  {
    RenderEngine renderEngine = GAME.getRenderEngine();

    resources = new int[5];
    for(int i = 0;i<5;i++)
      resources[i] = resources_[i];
    
    types = types_.copy();
    background = background_;
    c = c_;
    
    images = new PImage[6];
    img = new int[6][SIZE][SIZE];
    int[][] temp_img;
    for(int i = 0;i<6;i++)
    {
      temp_img = new int[SIZE][SIZE];
      for(int j = 0;j<SIZE;j++)
        for(int k = 0;k<SIZE;k++)
          temp_img[j][k] = img_[i][j][k];
      
      img[i] = temp_img;

      images[i] = renderEngine.createImgByIntArray(temp_img,c,"elements");
    }
    
  }

  public Tile copy(){return new Tile(img,resources,background,c,types);}

  public boolean is(String type)
  {
    return types.contains(type);
  }
  
  public int[][] getFrame(int i)
  {
    return img[i];
  }

  public int[][] iterate(final int[][] template,final int[][] temp_template,final Part[] neighbors)
  {
    return iterateTile(template,temp_template);
  }

  public void drawFrame(int x, int y, int frame)
  {
    RenderEngine renderEngine = GAME.getRenderEngine();

    //images[frame].save("img"+frame+".png");
    
    //images[frame] = renderEngine.createImgByIntArray(img[frame],c,"elements");
    //images[frame].save("img.png");
    PImage image = images[frame];
    //image.save("img.png");
    //image.set(0,0,color(255));
    renderEngine.drawImg(image,x*8,y*8);
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