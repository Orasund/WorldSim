public interface Part
{
  //public int[][] iterate(final int[][] template,final int[][] temp_template,final Part[] neighbors);
  public color getColor();
  public int[] getResources();
  public String getGroupName();
  public Part copy();
  public boolean is(String type);
  public String[] getTypes();
  public void drawFrame(int x, int y, int frame);
}

/*public class Part
{
  private int[][][] img;
  private PImage[] images;
  private int[] resources;
  private int background;
  private color c;
  private Set<String> types;
  private String group;

  Part(int[][][] img_, int[] resources_, int background_, color c_, Set<String> types_,String group_)
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

      images[i] = renderEngine.createImgByIntArray(temp_img,c,group_);
    }
    
    group = group_;
  }

  public Part copy(){return new Part(img,resources,background,c,types,group);}

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

  public void drawFrame(int x, int y, int frame)
  {
    drawPart(x,y,images[frame],img[frame],c,group);
  }

  public color getColor(){return c;}
  public int[] getResources(){return resources;}
  public String getGroupName(){return group;}
}*/