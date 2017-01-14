Part evaluateTile(int[][] template)
{
  Set<String> types = new Set<String>();

  //Iterate for 16 Ticks
  int[][] temp_template = new int[8][8];
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
      temp_template[i][j]=template[i][j];
  
  int[][] map_empty = new int[8][8];
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
      map_empty[i][j]=0;
  
  /* OLD */
  for(int k = 0;k<16;k++)
    temp_template = iterateTile(temp_template,map_empty);
  /**/

  /* NEW */
  /*SimulationManager simulationManager = GAME.getSimulationManager();
  String group = "elements";

  simulationManager.newSession(group);
  //simulationManager.add("Energy",new EnergySim(template,group));
  //simulationManager.add("Life",new LifeSim(template,group));
  simulationManager.add("Source",new SourceSim(template,group));

  temp_template = simulationManager.init(template);*/
  /**/
  
  int[][][] img = new int[6][8][8];
  int[] resources = new int[5];
  for(int i = 0;i<5;i++)
    resources[i]=0;
    
  for(int k = 0;k<6;k++)
  {
    temp_template = iterateTile(temp_template,map_empty);
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
      {
        img[k][i][j] = temp_template[i][j];
        if(k==5)
          resources[temp_template[i][j]]++;
      }
  }

  //create simple Background
  // 1 stone = 4 void
  // 1 source = 3 stone = 12 void
  // 1 life = 2.66 source = 5 stone = 20 void

  int[] mult = {1,4,12,20,40};
  int background = 0;
  for(int i=1;i<5;i++)
    if(mult[i]*resources[i]>mult[background]*resources[background])
      background = i;
  
  if(background == 0 && resources[2] != 0)
  {
    background = 2;
  }

  color c;

  //switch
  switch(background)
  {
    //moving
    case 4:
      types.add("moving");
      c = color(255,80,61);
      break; 

    //organic
    case 3:
      if(resources[1]>0) //cell
      {
        types.add("solid");
        types.add("organic");
        c = color(127,178,127);
      }
      else //organic
      {
        types.add("organic");
        c = color(0,128,0);
      }
      break;

    //water
    case 2:
      //does life exist?
      if(resources[3]>0) //OrganicSpawn
      {
        types.add("organic_spawn");
        types.add("water");
        c = color(53,80,128);
      }
      else //water
      {
        types.add("water");
        c = color(80,80,256);
      }
      break;

    //stone
    case 1:
      
      if(resources[1]>28)
      {
        types.add("solid");
        c = color(90,90,90);
      }
      else
      {
        c = color(127,127,127);
      }
      break;

    //ground
    default:
      if(resources[0]==SIZE*SIZE)
        c = color(0,0,0);
      else
        c = color(80,255,80);
  }
  String group = "elements";
  return new Part(img,resources,background,c,types,group);
}