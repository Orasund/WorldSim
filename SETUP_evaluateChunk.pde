public Part evaluateChunk(final int[][] template_,String group_)
{
/*  SimulationManager simulationManager = GAME.getSimulationManager();

  simulationManager.newSession(group_);
  simulationManager.add("Organic",new OrganicSim(template_,group_));
  simulationManager.listenTo("floid","Organic");
  simulationManager.listenTo("organic","Organic");
  
  int[][] blocks = simulationManager.init(template_);

  int[] resources = new int[16];
  for(int i = 0;i<16;i++)
    resources[i] = 0;

  for(int j = 0;j<SIZE;j++)
    for(int k = 0;k<SIZE;k++)
      resources[blocks[j][k]]++;

  String group = group_;
  int background = 0;
  color c = color(0);
  Set<String> types = new Set<String>();

  int[][][] img = {blocks,blocks,blocks,blocks,blocks,blocks};

  return new Part(img,resources,background,c,types,group);*/
  int[] resources = new int[16];
  for(int i = 0;i<16;i++)
    resources[i] = 0;

  for(int j = 0;j<SIZE;j++)
    for(int k = 0;k<SIZE;k++)
      resources[template_[j][k]]++;
  
  String group = group_;
  int background = 0;
  color c = color(0);
  Set<String> types = new Set<String>();
  int[][][] img = {template_,template_,template_,template_,template_,template_};
  
  return new Part(img,resources,background,c,types,group);
}
