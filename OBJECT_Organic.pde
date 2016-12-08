class Organic extends Tile
{
  //int food;
  Organic(int[][][] img_,int[]resources_,int background_, int x_, int y_,color c_, Set<Boolean> types_)
  {
    super(img_,resources_,background_,x_,y_,c_,types_);
  }

  Organic(int[][][] img_,int[]resources_,int background_, int x_, int y_, Set<Boolean> types_)
  {
    super(img_,resources_,background_,x_,y_,color(0,255,0),types_);
  }

  Organic(int[][] template)
  { 
    super(template,color(0,255,0));
    //isObj = true;
    //food = 0;
  }

  Organic copy()
  {
    Organic out = new Organic(img,resources,background,x,y,c,types);
    //out.food = food;
    return out;
  }

  public boolean is(String type){
    if(type.equals("organic"))
      return true;
    return false;
  }
}