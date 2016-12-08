/*public class Life extends Element
{
  Life(final color c_, int x_, int y_)
  {
    super(c_,x_,y_);
  }

  Life(final color c_)
  {
    super(c_);
  }

  public Part copy()
  {
    return new Life(getColor());
  }

  public Part createInstance(int x_, int y_)
  {
    return new Life(getColor(),x_,y_);
  }

  public String getName()
  {
    return "Life";
  }

  public int[][] iterate(int[][] template,int[][] temp_template_, int x, int y, Part[] neighbors)
  {
    int[][] temp_template = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        temp_template[i][j]=temp_template_[i][j];

    int[] coord = simLife(template,x, y);

    if(coord[0]>0 && coord[1]>0)
    {
      temp_template[coord[0]][coord[1]]=3;
      temp_template[x][y]=3;
    }
    else
      temp_template[x][y]=2;

    return temp_template;
  }
  
  public boolean is(String type){return false;}
}
*/