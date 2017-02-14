public Part createBlock(int[] amount, String[] parts, String unused_group_name)
{
  ObjectManager objectManager = GAME.getObjectManager();

  /*String[] group = objectManager.getNamesByGroup(group_name);
  int[] adresses = new int[parts.length];

  for(int i=0;i<parts.length;i++)
    for(int j=1;j<group.length;j++)
    {
      if(group[j].equals(parts[i]))
      {
        adresses[i] = j;
        break;
      }
      if(j == group.length-1)
        throw new RuntimeException("Part not found: "+parts[i]+" @createBlock");
    }*/
  String[] group = {"Air0",parts[0]+"0"};
  String group_name = parts[0]+"TempGroup";
  int[] adresses = {0,1};
  objectManager.registerGroup(group_name, group);
  
  int[][] out = new int[SIZE][SIZE];
  for(int i=0;i<SIZE;i++)
    for(int j=0;j<SIZE;j++)
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
  
  return evaluateBlock(out,group_name);
}