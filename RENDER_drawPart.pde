public void drawPart(int x, int y, PImage image, int[][] img, color c, String group)
{
  RenderEngine renderEngine = GAME.getRenderEngine();
  if(renderEngine.getCamera().getZoom()==1)
  {
    renderEngine.drawImg(image,x*8,y*8);
  }
  else
    renderEngine.drawPart(img,x*SIZE,y*SIZE,c,group);
}
