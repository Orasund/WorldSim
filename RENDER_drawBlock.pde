/*void drawBlock(int x, int y, int template[][],int background)
{
  Element space = new Element(color(0,0,0));
  Element life = new Element(color(0,80,0));
  Element source = new Element(color(0,0,255));
  Element base = new Element(color(0,0,0));

  drawBackground(x*8,y*8,background);

  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
      switch(template[i][j])
      {
        case 3:
          life.draw(x*8+i,y*8+j);
          break;
        case 2:
          source.draw(x*8+i,y*8+j);
          break;
        case 1:
          base.draw(x*8+i,y*8+j);
          break;
        case 0:
        default:
          break;
      }
}*/

/*void drawBackground(int x, int y, color c)
{
  
  color c;
  switch(background)
  {
    case 3:
      c = color(0,128,0);
      break;
    case 2:
      c = color(80,80,256);
      break;
    case 1:
      c = color(127,127,127);
      break;
    case 0:
    default:
      c = color(80,255,80);
      break;
  }
  fill(c);
  Game.RenderEngine.drawBackground(x,y);
}*/

/*void drawBackground(int x, int y,int background)
{
  
  color c;
  switch(background)
  {
    case 3:
      c = color(0,128,0);
      break;
    case 2:
      c = color(80,80,256);
      break;
    case 1:
      c = color(127,127,127);
      break;
    case 0:
    default:
      c = color(80,255,80);
      break;
  }
  fill(c);
  Game.RenderEngine.drawBackground(x,y);
  //CURRENT_VIEW.drawBackground(x,y);
}*/