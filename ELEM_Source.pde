/*public class Source extends Element
{
  Source(final color c_, int x_, int y_)
  {
    super(c_,x_,y_);
  }

  Source(final color c_)
  {
    super(c_);
  }

  public Part copy()
  {
    return new Source(getColor());
  }

  public Part createInstance(int x_, int y_)
  {
    return new Source(getColor(),x_,y_);
  }

  public String getName()
  {
    return "Source";
  }

  public boolean is(String type){return false;}

  public int[][] iterate(int[][] template,int[][] temp_template_,int x, int y, Part[] neigh)
  {
    int[][] temp_template = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        temp_template[i][j]=temp_template_[i][j];

    int coord[] = {x,y};
    int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
    
    if(x==0 || y==0 || x==7 || y==7)
    {
      coord[0] = -1;
      //return coord;
    }
    else
    {
      int[] neighbors = new int[4];
      for(int i=0;i<4;i++)
        neighbors[i] = template[x+dir[i][0]][y+dir[i][1]];
      
      boolean found = false;

      for(int i=0;i<4;i++)
        if((neighbors[i]==1) && (neighbors[(i+1)%4]==2) && neighbors[(i+2)%4]==2 && (neighbors[(i+3)%4]==2))
        {
          for(int k=0;k<2;k++)
            coord[k] += dir[i][k];
          found = true;
          break;//return coord;
        }
      
      if(found == false)
        for(int i=0;i<4;i++)
          if((neighbors[(i+2)%4]==2 || neighbors[(i+2)%4]==1) && neighbors[i]==0)
          {
            for(int k=0;k<2;k++)
              coord[k] += dir[i][k];
            break;//return coord;
          }
    }

    if(coord[0]>0 && coord[1]>0 && temp_template[coord[0]][coord[1]]==0)
      temp_template[coord[0]][coord[1]]=2;
      
    return temp_template;
  }
}*/