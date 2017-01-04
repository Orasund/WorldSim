public class EnergySim extends Simulation
{
  EnergySim(final int[][] template,String group)
  {
    super(0);
  }

  int[][] simOld(final int[][] template,final int[][] temp_template_,String group)
  {
    return simEnergy(template,temp_template_,group,this);
  }
}