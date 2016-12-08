Simulation initBaseSim(final int[][] template,String group)
{
  String[] names = {};
  return new Simulation(names);
}

int[][] simBase(final int[][] template,final int[][] temp_template_,String group,Simulation sim)
{
  int size = 8;
  int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
  int x,y;

  int[][] temp_template = new int[size][size];
  for(int i=0;i<size;i++)
    for(int j=0;j<size;j++)
    {
      temp_template[i][j]=temp_template_[i][j];

      if(template[i][j] != 1)
        continue;

      temp_template[i][j] = 1;
    }
    
  return temp_template;
}