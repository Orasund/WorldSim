class Water extends Tile
{
  Water(int[][][] img_,int[]resources_,int background_, int x, int y)
  {
    super(img_,resources_,background_,x,y,color(0,0,255));
  }

  Water(int[][] template)
  { 
    super(template,color(0,0,255));
  }

  Water copy()
  {
    Water out = new Water(img,resources,background,x,y);
    return out;
  }

  public boolean is(String type){
    if(type.equals("water"))
      return true;
    return false;
  }
}