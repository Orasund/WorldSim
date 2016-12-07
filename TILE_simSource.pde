/*int[] simSource(int template[][],int x, int y)
{
  int out[] = {x,y};
  int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
  
  if(x==0 || y==0 || x==7 || y==7)
  {
    out[0] = -1;
    return out;
  }
  
  int[] neighbors = new int[4];
  for(int i=0;i<4;i++)
    neighbors[i] = template[x+dir[i][0]][y+dir[i][1]];
  
  for(int i=0;i<4;i++)
    if((neighbors[i]==1) && (neighbors[(i+1)%4]==2) && neighbors[(i+2)%4]==2 && (neighbors[(i+3)%4]==2))
    {
      for(int k=0;k<2;k++)
        out[k] += dir[i][k];
      return out;
    }
  
  for(int i=0;i<4;i++)
    if((neighbors[(i+2)%4]==2 || neighbors[(i+2)%4]==1) && neighbors[i]==0)
    {
      for(int k=0;k<2;k++)
        out[k] += dir[i][k];
      return out;
    }
    
  return out;
}*/