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

  public String[] getTypes()
  {
    ArrayList<String> list = types.toArrayList();
    String[] out = list.toArray(new String[0]);
    return out;
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
    drawPart(x,y,images[frame],img[frame],c,"elements");
    
    /*RenderEngine renderEngine = GAME.getRenderEngine();
    if(renderEngine.getCamera().getZoom()==1)
    {
      PImage image = images[frame];
      renderEngine.drawImg(image,x*8,y*8);
    }
    else
      renderEngine.drawPart(img[frame],x*SIZE,y*SIZE,c,"elements");*/
  }

  public color getColor(){return c;}
  public int[] getResources(){return resources;}
  public String getGroupName(){return "elements";}
}