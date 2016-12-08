class Organic extends Tile
{
  Organic(int[][][] img_,int[]resources_,int background_, color c_, Set<Boolean> types_)
  {
    super(img_,resources_,background_,c_,types_);
  }

  Organic(int[][][] img_,int[]resources_,int background_, Set<Boolean> types_)
  {
    super(img_,resources_,background_,color(0,255,0),types_);
  }

  Organic(int[][] template)
  { 
    super(template,color(0,255,0));
  }

  Organic copy()
  {
    Organic out = new Organic(img,resources,background,c,types);
    return out;
  }

  public boolean is(String type){
    if(type.equals("organic"))
      return true;
    return false;
  }
}