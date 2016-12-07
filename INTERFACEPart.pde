public interface Part
{
  public int[][] iterate(final int[][] template,final int[][] temp_template,final int x,final int y,final Part[] neighbors);
  public String getName();
  public color getColor();
  public int getX();
  public int getY();
  public int[] getResources();
  public String getGroupName();
  public Part copy();
  public boolean is(String type);
  public Part createInstance(int x, int y);
  public void drawFrame(int x, int y, int frame);
}