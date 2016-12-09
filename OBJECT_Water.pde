class Water extends Tile
{
  Water(int[][][] img_,int[]resources_,int background_,color c_,Set<String> types_)
  {
    super(img_,resources_,background_,c_,types_);
  }

  Water(int[][][] img_,int[]resources_,int background_,Set<String> types_)
  {
    super(img_,resources_,background_,color(0,0,255),types_);
  }

  Water(int[][] template)
  { 
    super(template,color(0,0,255));
  }

  Water copy()
  {
    Water out = new Water(img,resources,background,c,types);
    return out;
  }

  /*public boolean is(String type){
    if(type.equals("water"))
      return true;
    return false;
  }*/
}