class Organic extends Tile
{
  //int food;
  Organic(int[][][] img_,int[]resources_,int background_, int x, int y)
  {
    super(img_,resources_,background_,x,y,color(0,255,0));
  }

  Organic(int[][] template)
  { 
    super(template,color(0,255,0));
    //isObj = true;
    //food = 0;
  }

  Organic copy()
  {
    Organic out = new Organic(img,resources,background,x,y);
    //out.food = food;
    return out;
  }

  public boolean is(String type){
    if(type.equals("organic"))
      return true;
    return false;
  }
}