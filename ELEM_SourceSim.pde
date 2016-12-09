public class SourceSim extends Simulation
{
  SourceSim(final int[][] template,String group)
  {
    super(0);

    //initSourceSim(template,group);
  }

  int[][] simOld(final int[][] template,final int[][] temp_template_,String group)
  {
    return simSource(template,temp_template_,group,this);
  }
}