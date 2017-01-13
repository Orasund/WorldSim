public Chunk evaluateChunk(final int[][] template_,String group_)
{
  SimulationManager simulationManager = GAME.getSimulationManager();

  simulationManager.newSession(group_);
  simulationManager.add("Organic",new OrganicSim(template_,group_));
  simulationManager.listenTo("water","Organic");
  simulationManager.listenTo("organic","Organic");
  /*
  simulationManager.add("OrganicSpawn",new OrganicSpawnSim(template_,group_));
  simulationManager.listenTo("water","OrganicSpawn");
  simulationManager.listenTo("organic_spawn","OrganicSpawn");
  */
  
  int[][] blocks = simulationManager.init(template_);

  int[] resources = new int[SIZE];
  for(int i = 0;i<SIZE;i++)
    resources[i] = 0;

  for(int j = 0;j<SIZE;j++)
    for(int k = 0;k<SIZE;k++)
      resources[blocks[j][k]]++;

  String group = group_;
  int background = 0;
  color c = color(0);

  return new Chunk(blocks,group,background,c,resources);
}
