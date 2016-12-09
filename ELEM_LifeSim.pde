public class LifeSim extends Simulation
{
  LifeSim(final int[][] template,String group)
  {
    super(0);

    //initLifeSim(template,group);
  }

  int[][] sim(final int[][] template,final int[][] temp_template_,String group)
  {
    return simLife(template,temp_template_,group,this);
  }
}