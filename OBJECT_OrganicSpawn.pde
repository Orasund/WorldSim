class OrganicSpawn extends Tile
{
  OrganicSpawn(int[][][] img_,int[]resources_,int background_, color c_, Set<String> types_)
  {
    super(img_,resources_,background_,c_,types_);
  }

  /*
  OrganicSpawn(int[][][] img_,int[]resources_,int background_, Set<String> types_)
  {
    super(img_,resources_,background_,color(0,0,255),types_);
  }*/

  OrganicSpawn(int[][] template)
  { 
    super(template,color(0,0,255));
  }

  OrganicSpawn copy()
  {
    OrganicSpawn out = new OrganicSpawn(img,resources,background,c,types);
    return out;
  }

  public boolean is(String type){
    if(type.equals("water"))
      return true;
    if(type.equals("organic_spawn"))
      return true;
    return false;
  }
}