//test
public class Scene
{
  private int[][] map;
  private Part[] tiles;
  String group_name;

  Scene(int[][] map_,String tiles)
  {
    map = new int[map_.length][map_[0].length];
    for(int i = 0; i < map_.length; i++)
      for(int j = 0; j < map_[0].length; j++)
        map[i][j] = map_[i][j];
    
    group_name = tiles;
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
    RenderEngine renderEngine = GAME.getRenderEngine();
    ObjectManager objectManager = GAME.getObjectManager();
    GameLoop gameLoop = GAME.getGameLoop();
    Player player = GAME.getPlayer();
    PVector pos = player.getPos();
    int x = floor(pos.x/SIZE);
    int y = floor(pos.y/SIZE);
    
    renderEngine.rotateScene();

    Part[] tiles = objectManager.getGroup(group_name);
    Part[] ship = objectManager.getGroup("ship");

    for(int i=0;i<5;i++)
      for(int j=0;j<5;j++)
      {
        int x2 = x+i-2;
        int y2 = y+j-2;
        if(x2==3 && y2 == -2)
        	ship[0].drawGrid(x2,y2,gameLoop.getFrame());
        if(x2==3 && y2 == -1)
          ship[2].drawGrid(x2,y2,gameLoop.getFrame());
        if(x2==4 && y2 == -2)
          ship[1].drawGrid(x2,y2,gameLoop.getFrame());
        if(x2==4 && y2 == -1)
          ship[3].drawGrid(x2,y2,gameLoop.getFrame());

        if(x2<0 || y2<0 || x2>=SIZE || y2>=SIZE)
          continue;

        tiles[map[x2][y2]].drawGrid(x2,y2,gameLoop.getFrame());
      }
  }
}