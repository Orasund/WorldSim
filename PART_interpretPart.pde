int[][] interpretPart(Msg msg, int[][] template,int[][] temp_template_, int x, int y)
{
  int[][] temp_template = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        temp_template[i][j]=temp_template_[i][j];

  switch(msg.msg)
  {
    //default:
    case "idle":
      break;
  }

  return temp_template;
}