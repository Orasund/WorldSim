public class Element implements Part
{
  private color c;
  private int x;
  private int y;

  Element(final color c_, int x_, int y_)
  {
    c = c_;
    x = x_;
    y = y_;
  }

  Element(final color c_)
  {
    c = c_;
    x = 0;
    y = 0;
  }

  public Part copy()
  {
    return new Element(c);
  }

  public Part createInstance(int x_, int y_)
  {
    return new Element(c,x_,y_);
  }

  public void drawFrame(int x, int y, int frame){}

  public int[][] iterate(final int[][] template,final int[][] temp_template_,
    int x, int y, Part[] neighbors)
  {
    int[][] temp_template = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        temp_template[i][j]=temp_template_[i][j];

    //String[] a = {};
    //Msg msg = new Msg("interpreter","idle",new JSONObject());

    return temp_template;//interpretPart(msg,template,temp_template,x,y);
  }

  public color getColor()
  {
    return c;
  }

  public int getX()
  {
    return x;
  }

  public int getY()
  {
    return y;
  }

  public boolean is(String type){return false;}

  public String getName()
  {
    return "Undefined Element";
  }

  public int[] getResources()
  {
    int[] out = new int[8];
    for(int i=0;i<8;i++)
      out[i] = 0;
    return out;
  }

  public String getGroupName()
  {
    return "elements";
  }
}