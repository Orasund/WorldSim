public void drawPartGrid(int x, int y, int frame, int[][] blocks, String group)
{
  ObjectManager objectManager = GAME.getObjectManager();

  Part[] Tiles = objectManager.getGroup(group);

  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
      Tiles[blocks[i][j]].drawFrame(x*8+i,y*8+j,frame);
}

/*public void drawFrame(int x, int y, int frame)
  {
    ObjectManager objectManager = GAME.getObjectManager();

    Part[] Tiles = objectManager.getGroup(group);

    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        Tiles[blocks[i][j]].drawFrame(x*8+i,y*8+j,frame);
  }*/