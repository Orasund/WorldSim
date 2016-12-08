class OrganicSpawn extends Tile
{
  OrganicSpawn(int[][][] img_,int[]resources_,int background_, int x, int y)
  {
    super(img_,resources_,background_,x,y,color(0,0,255));
  }

  OrganicSpawn(int[][] template)
  { 
    super(template,color(0,0,255));
  }

  OrganicSpawn copy()
  {
    OrganicSpawn out = new OrganicSpawn(img,resources,background,x,y);
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