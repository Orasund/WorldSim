Chunk createGroundChunk()
{
  int[] amount = {5,10};
  String[] names = {"lake1","bush"};
  return createChunk(amount,names,"tiles");
}

Chunk createWaterChunk()
{
  int[] amount = {70,20};
  int variance = 2;
  String[] names = {"lake","alga"};
  
  String[] names2 = {"lake0","lake1","alga0","alga1"};
  
  int[] amount_ = new int[amount.length*variance];
  String[] names_ = new String[amount_.length];
  for(int i=0; i<amount.length; i++)
    for(int j=0; j<variance; j++)
    {
      amount_[i*variance+j] = floor(amount[i]/variance);
      String name = names[i]+j;
      names_[i*variance+j] = name;
    }
  return createChunk(amount_,names2,"waterTiles");
}

Chunk createMountainChunk()
{
  int[] amount = {5,70,10};
  String[] names = {"lake1","stone","moss"};
  return createChunk(amount,names,"tiles");
}

Chunk createForestChunk()
{
  int[] amount = {10,5,50};
  String[] names = {"lake1","stone","bush"};
  return createChunk(amount,names,"tiles");
}

Tile createBush(){return evaluateTile(plantTemplate(0,10,10));}
Tile createMoss(){return evaluateTile(solidTemplate(50,20,10));}
Tile createGround(){return evaluateTile(groundTemplate(10,0,0));}
Tile createLake(){return evaluateTile(groundTemplate(0,50,0));}
Tile createStone(){return evaluateTile(solidTemplate(80,1,0));}
Tile createAlga(){return evaluateTile(groundTemplate(0,20,4));}

Chunk createChunk(int[] amount, String[] names, String group_name)
{
  ObjectManager objectManager = GAME.getObjectManager();

  String[] group = objectManager.getNamesByGroup(group_name);
  int[] adresses = new int[names.length];
  int size = 8;

  for(int i=0;i<names.length;i++)
    for(int j=1;j<group.length;j++)
      if(group[j]==names[i])
      {
        adresses[i] = j;
        break;
      }

  int[][] out = new int[size][size];
  for(int i=0;i<size;i++)
    for(int j=0;j<size;j++)
    {
      float rand = random(100);

      int type = 0;
      for(int k=0;k<amount.length;k++)
      {
        if(rand<amount[k])
        {
          type = adresses[k];
          break;
        }
        rand-=amount[k];
      }
      out[i][j] = type;
    }
  Chunk ch = new Chunk(out,group_name);
  return ch;
}

int[][] plantTemplate(int stone, int water, int life)
{
  int[][] out = randTemplate(stone,water,life);
  
  for(int i=0;i<2;i++)
    for(int j=0;j<2;j++)
      out[3+i][3+j]=2;

  for(int i=0;i<4;i++)
  {
    
    out[2][2+i]=3;
    out[2+i][2]=3;
    out[5][2+i]=3;
    out[2+i][5]=3;
  }
  
  return out;
}

int[][] groundTemplate(int stone, int water, int life)
{
  int[][] out = randTemplate(stone,water,life);
  return out;
}

int[][] solidTemplate(int stone, int water, int life)
{
  int[][] out = randTemplate(stone,water,life);
  
  for(int i=0;i<8;i++)
  {
    out[0][i]=1;
    out[i][0]=1;
    out[7][i]=1;
    out[i][7]=1;
  }
  
  return out;
}