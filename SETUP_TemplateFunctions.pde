int[][] seedTemplate(int base, int source, int life, int power)
{
  int[][] out = randTemplate(base,source,life,power);
  
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

int[][] defaultTemplate(int base, int source, int life, int power)
{
  int[][] out = randTemplate(base,source,life,power);
  return out;
}

int[][] frameTemplate(int base, int source, int life, int power)
{
  int[][] out = randTemplate(base,source,life,power);
  
  for(int i=0;i<8;i++)
  {
    out[0][i]=1;
    out[i][0]=1;
    out[7][i]=1;
    out[i][7]=1;
  }
  
  return out;
}