public class Template
{
  private int[][] map;

  Template(int[][] map_)
  {
    map = new int[map_.length][map_[0].length];
    for(int i = 0; i < map_.length; i++)
      for(int j = 0; j < map_[0].length; j++)
        map[i][j] = map_[i][j];
  }

  public int[][] iterate()
  {
    int[][] temp_template = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        temp_template[i][j]=0;
    return iterateTile(map,temp_template);
  }

  public int[][] print()
  {
    int[][] out = new int[map.length][map[0].length];
    for(int i = 0; i < map.length; i++)
      for(int j = 0; j < map[0].length; j++)
        out[i][j] = map[i][j];
    return out;
  }
}