public class PowerSim extends Simulation
{
  PowerSim(final int[][] template,String group)
  {
    super(0);
  }

  int[][] simOld(final int[][] template,final int[][] temp_template_,String group)
  {
    return simPower(template,temp_template_,group,this);
  }
}