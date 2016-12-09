/*int[] simLife(int template[][],int x, int y)
{
  int out[] = {x,y};
  int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
  
  int[] neighbors = new int[4];
  for(int i=0;i<4;i++)
  {
    if(x+dir[i][0]<0 || y+dir[i][1]<0 || x+dir[i][0]>7 || y+dir[i][1]>7)
      neighbors[i] = 1;
    else
      neighbors[i] = template[x+dir[i][0]][y+dir[i][1]];
  }
  
  for(int i=0;i<4;i++)
    if(neighbors[i]==2)
    {
      for(int k=0;k<2;k++)
        out[k] += dir[i][k];
      return out;
    }
  
  out[0]=-1;
  return out;
}*/