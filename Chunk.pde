/*public class Chunk implements Part
{
  private int[][] blocks;
  private int[] resources;
  private String group;
  private int background;
  private color c;

  Chunk(int[][] blocks_,String group_,int background_, color c_, int[] resources_)
  {
    blocks = new int[8][8];
    for(int j = 0;j<8;j++)
      for(int k = 0;k<8;k++)
      {
        blocks[j][k] = blocks_[j][k];
      }

    resources = new int[8];
    for(int i = 0;i<8;i++)
    {
      resources[i] = resources_[i];
    } 

    group = group_;
    background = background_;
  }

  public Chunk copy()
  {
    return new Chunk(blocks,group,background,c,resources);
  }

  public color getColor(){return c;}

  public boolean is(String type){return false;}

  public int[] getResources()
  {
    return resources;
  }

  public String getGroupName()
  {
    return group;
  }

  public String[] getTypes()
  {
    return new String[0];
  }

  public void drawFrame(int x, int y, int frame)
  {
    drawPartGrid(x,y,frame,blocks,group);
  }
}*/