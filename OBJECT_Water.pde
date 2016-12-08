class Water extends Tile
{
  Water(int[][][] img_,int[]resources_,int background_, int x_, int y_,color c_,Set<Boolean> types_)
  {
    super(img_,resources_,background_,x_,y_,c_,types_);
  }

  Water(int[][][] img_,int[]resources_,int background_, int x_, int y_,Set<Boolean> types_)
  {
    super(img_,resources_,background_,x_,y_,color(0,0,255),types_);
  }

  Water(int[][] template)
  { 
    super(template,color(0,0,255));
  }

  Water copy()
  {
    Water out = new Water(img,resources,background,x,y,types);
    return out;
  }

  public boolean is(String type){
    if(type.equals("water"))
      return true;
    return false;
  }
}