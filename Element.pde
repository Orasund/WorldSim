/*public class Element implements Part
{
  private color c;
  String name;

  Element(final color c_,String name_)
  {
    c = c_;
    name = name_;
  }

  public Part copy()
  {
    return new Element(c,name);
  }

  public void drawFrame(int x, int y, int frame){}

  public int[][] iterate(final int[][] template,final int[][] temp_template_,Part[] neighbors)
  {
    int[][] temp_template = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        temp_template[i][j]=temp_template_[i][j];

    return temp_template;
  }

  public color getColor()
  {
    return c;
  }

  public boolean is(String type)
  {
    return type.equals(name);
  }

  public String[] getTypes()
  {
    return new String[0];
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
}*/