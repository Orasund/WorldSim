int[][] randTemplate(int stone, int water, int life, int energy)
{
  int template[][] = new int[8][8];
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
      template[i][j]=0;
    
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
    {
      float rand = random(100);
      int[] elements = {stone,water,life,energy};
      int type = 4;
      for(int k=0;k<4;k++)
      {
        rand -= elements[3-k];
        if(rand<0)
          break;
        type--;
      }
      template[i][j]=type;
    }
  return template;
}