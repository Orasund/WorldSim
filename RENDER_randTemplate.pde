int[][] randTemplate(int stone, int water, int life)
{
  int template[][] = new int[8][8];
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
      template[i][j]=0;
    
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
    {
      float rand = random(100);
      int type;
      if(rand<life)
        type = 3;
      else if(rand<water+life)
        type = 2;
      else if(rand<water+stone+life)
        type = 1;
      else
        type = 0;
      template[i][j]=type;
    }
  return template;
}