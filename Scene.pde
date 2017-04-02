//test
interface Scene
{
  public void setGroupName(String name);

  public void setMap(int[][] map_);

  public int[][] getMap();

  public String getCorrentPartName();

  public int[][] getMapArea(int x, int y, int w, int h);

  public void renderArea();
}