class Map
{
  private int[][] map;
  //private Block[][] obj_map;
  //private ArrayList<Block> obj;
  private String group_name;

  Map(String parts)
  {
    group_name = parts;
    map = genMap();
  }

  Map(int size, int detail, String parts)
  {
    group_name = parts;

    //map = genMap(size, detail);
    map = genMap();
    //interate



    
    //obj_map = new Block[size/detail][size/detail];
    /*obj = new ArrayList<Block>();
    for(int i=0;i<size;i++)
      for(int j=0;j<size;j++)
      {
        if(b[map[i][j]].isObj)
        {
          obj.add(b[map[i][j]].createBlock(i,j));
        }
      }*/
  }

  public int[][] getMap()
  {
    int[][] out = new int[map.length][map.length];
    for(int i = 0; i < map.length; i++)
      for(int j = 0; j < map[0].length; j++)
        out[i][j] = map[i][j];
    return out;
  }

  int[][] genMap()
  {
    int size = 8;
    Part[] Tiles = Game.ObjectManager.getGroup(group_name);
    int[][] map_layout = new int[size][size];
    int[] layout_pool = {50,20,10,20};
    int diversity = 2;

    for(int i=0;i<map_layout.length;i++)
      for(int j=0;j<map_layout.length;j++)
      {
        float rand = random(100);
        map_layout[i][j] = 0;
        for(int k=0;k<layout_pool.length;k++)
        {
          if(rand<layout_pool[k])
          {
            map_layout[i][j] = diversity*k+floor(random(diversity));
            break;
          }
          rand-=layout_pool[k];
        }
      }

    return map_layout;
  }

  int[][] genMap(int size, int detail)
  {
    int[][] map_layout = new int[size/detail][size/detail];
    int[] layout_pool = {50,20,10,20};
    
    for(int i=0;i<map_layout.length;i++)
      for(int j=0;j<map_layout.length;j++)
      {
        float rand = random(100);
        map_layout[i][j] = 0;
        for(int k=0;k<layout_pool.length;k++)
        {
          if(rand<layout_pool[k])
          {
            map_layout[i][j] = k;
            break;
          }
          rand-=layout_pool[k];
        }
      }
    
    //int[] lake = {};
    int[][] pool =
    {
      {5,0,0,0,10},//ground
      {70,0,10,0,0},//water
      {5,70,0,10,0},//mountain
      {10,5,0,0,50}//forest
    };

    int[][] out = new int[size][size];
    for(int i=0;i<size;i++)
      for(int j=0;j<size;j++)
      {
        float rand = random(100);
        int type;
        int l = map_layout[i/detail][j/detail];

        type = 0;
        for(int k=0;k<pool[l].length;k++)
        {
          if(rand<pool[l][k])
          {
            type = k+1;
            break;
          }
          rand-=pool[l][k];
        }
        out[i][j] = type;
      }
    return out;
  }

  /*void draw()
  {
    for(int i=0;i<MAP_SIZE;i++)
        for(int j=0;j<MAP_SIZE;j++)
          b[map[i][j]].drawFrame(i,j,GameLoop.getFrame());
          //drawBlock(i,j,b[map[i][j]].getFrame(CURRENT_FRAME),b[map[i][j]].background);
  }*/
}