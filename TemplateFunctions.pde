Chunk createGroundChunk()
{
  int[] amount = {5,10};
  String[] names = {"lake","bush"};
  return createChunk("ground",amount,names,"tiles");
  //return new Chunk("ground",chunkTemplate({5,10},{"lake","bush"},"tiles"),"tiles");
}

Chunk createWaterChunk()
{
  int[] amount = {70,10};
  String[] names = {"lake","alga"};
  return createChunk("water",amount,names,"tiles");
}

Chunk createMountainChunk()
{
  int[] amount = {5,70,10};
  String[] names = {"lake","stone","moss"};
  return createChunk("mountain",amount,names,"tiles");
}

Chunk createForestChunk()
{
  int[] amount = {10,5,50};
  String[] names = {"lake","stone","bush"};
  return createChunk("mountain",amount,names,"tiles");
}

Tile createBush(){return new Organic(plantTemplate(0,10,10));}
Tile createMoss(){return new Tile(solidTemplate(50,20,10),color(0,0,0));}
Tile createGround(){return new Tile(groundTemplate(10,0,0),color(0,0,0));}
Tile createLake(){return new Water(groundTemplate(0,50,0));}//,color(0,0,255));}
Tile createStone(){return new Tile(solidTemplate(80,1,0),color(0,0,0));}
Tile createAlga(){return new OrganicSpawn(groundTemplate(0,20,4));}//,color(0,0,255));}

Chunk createChunk(String name, int[] amount, String[] names, String group_name)
{
  String[] group = Game.ObjectManager.getNamesByGroup(group_name);
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
      //int l = map_layout[i/detail][j/detail];

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
  Chunk ch = new Chunk(name,out,group_name);
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