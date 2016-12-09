public interface Part
{
  public int[][] iterate(final int[][] template,final int[][] temp_template,final Part[] neighbors);
  public color getColor();
  public int[] getResources();
  public String getGroupName();
  public Part copy();
  public boolean is(String type);
  public void drawFrame(int x, int y, int frame);
}