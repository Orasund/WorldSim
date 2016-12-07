public class Scene
{
  private int[][] map;
  private Tile[] tiles;
  String group_name;

  Scene(int[][] map_,String tiles)
  {
    map = new int[map_.length][map_[0].length];
    for(int i = 0; i < map_.length; i++)
      for(int j = 0; j < map_[0].length; j++)
        map[i][j] = map_[i][j];
    
    group_name = tiles;
    /*tiles = new Tile[tiles_.length];
    for(int i = 0; i < tiles_.length; i++)
      tiles[i] = tiles_[i].copy();*/
  }

  public void setMap(int[][] map_)
  {
    for(int i = 0; i < map.length; i++)
      for(int j = 0; j < map[0].length; j++)
        map[i][j] = map_[i][j];
  }

  public int[][] getMap()
  {
    int[][] out = new int[map.length][map[0].length];
    for(int i = 0; i < map.length; i++)
      for(int j = 0; j < map[0].length; j++)
        out[i][j] = map[i][j];
    return out;
  }

  public int[][] getMapArea(int x, int y, int w, int h)
  {
    int[][] out = new int[map.length][map[0].length];
    for(int i = 0; i < map.length; i++)
      for(int j = 0; j < map[0].length; j++)
        out[i][j] = map[i][j];
    return out;
  }

  public void renderArea()
  {
    Game.RenderEngine.rotateScene();
    Part[] Tiles = Game.ObjectManager.getGroup(group_name);

    for(int i=0;i<map.length;i++)
      for(int j=0;j<map[0].length;j++)
        Tiles[map[i][j]].drawFrame(i,j,Game.GameLoop.getFrame());
        //tiles[map[i][j]].drawFrame(i,j,GameLoop.getFrame());
  }
}