public class BaseSim extends Simulation
{
  BaseSim(final int[][] template,String group)
  {
    super(0);
  }

  int[][] simOld(final int[][] template,final int[][] temp_template_,String group)
  {
    return simBase(template,temp_template_,group,this);
  }
}