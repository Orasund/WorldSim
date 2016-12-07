public class Base extends Element
{
  Base(final color c_, int x_, int y_){super(c_,x_,y_);}

  Base(final color c_){super(c_);}

  public Part copy(){return new Base(getColor());}

  public Part createInstance(int x_, int y_){return new Base(getColor(),x_,y_);}
  
  public String getName(){return "Base";}

  public boolean is(String type){return false;}

  public int[][] iterate(int[][] template,int[][] temp_template_, int x, int y, Part[] neighbors)
  {
    int[][] temp_template = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        temp_template[i][j]=temp_template_[i][j];

    if(temp_template[x][y]==0)
      temp_template[x][y]=template[x][y];

    return temp_template;
  }
}