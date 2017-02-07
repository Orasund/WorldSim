Part createChunk(int[] amount_, String[] parts_, String group_name)
{
  ObjectManager objectManager = GAME.getObjectManager();

  int[] amount = new int[amount_.length];
  String[] parts = new String[amount.length];
  for(int i=0; i<amount_.length; i++)
  {
    amount[i] = floor(amount_[i]);
    parts[i] = parts_[1+i];//parts_[i]+j;
  }

  String[] group = objectManager.getNamesByGroup(group_name);
  int[] adresses = new int[parts.length];
  int size = 8;

  for(int i=0;i<parts.length;i++)
    for(int j=1;j<group.length;j++)
    {
      if(group[j].equals(parts[i]))
      {
        adresses[i] = j;
        break;
      }
      if(j == group.length-1)
        throw new RuntimeException("Part not found: "+parts[i]+" @createChunk");
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

  //return new Chunk(out,group_name);
  return evaluateChunk(out,group_name);
}