int[][] iterateTile(final int[][] template, final int[][] temp_template_)
{
  int[][] temp_template = new int[8][8];
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
      temp_template[i][j]=template[i][j];

  String group = "elements";
  Simulation lifeSim = initLifeSim(template,group);
  Simulation sourceSim = initSourceSim(template,group);
  Simulation baseSim = initBaseSim(template,group);
  Simulation energySim = initEnergySim(template,group);
  
  temp_template = simEnergy(template,temp_template,group,energySim);
  temp_template = simLife(template,temp_template,group,lifeSim);
  temp_template = simSource(template,temp_template,group,sourceSim);
  temp_template = simBase(template,temp_template,group,baseSim);
     
  return temp_template;
}