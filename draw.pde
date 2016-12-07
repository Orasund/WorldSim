void draw()
{
  //JSONObject a = new JSONObject;
  Game.send("input","check",new JSONObject());
  //InputHandler.checkInputs();

  if(Game.GameLoop.tick())
  {
    /*if(keyReleased)
      InputHandler.dropInput(key);
    if(keyPressed)
      InputHandler.registerInput(key);*/
      //controller();

    COUNTER++;

    //disabling the template Scene
    if(COUNTER<16)
      COUNTER = 16;
    
    if(COUNTER == 16)
    {
      Game.RenderEngine.setView("map");
      PVector pos = Game.Player.getPos();
      Game.RenderEngine.setPos(int(pos.x), int(pos.y));
      JSONObject a = new JSONObject();
      a.setString("a1","main");
      Game.send("scene","chanceScene",a);
      //SceneManager.chanceScene("main");
    }

    if(COUNTER<16)
    {
      int[][] map_empty = new int[8][8];
      for(int i=0;i<8;i++)
        for(int j=0;j<8;j++)
          map_empty[i][j]=0;
      
      int[][] map = Game.SceneManager.getMap();
      Game.SceneManager.setMap(iterateTile(map,map_empty));
    }
      
  }

  background(255);
  Game.RenderEngine.drawView();
  //RenderEngine.setRot(Player.getDir());
  
  /*translate(width/2, height/2);
  rotate((TWO_PI*(60*CURRENT_FRAME+tick))/(60*6));
  translate(-width/2, -height/2);*/

  if(COUNTER<16)
  {
    //Needs a system to display the iterations like drawTemplate
    //drawBlock(0,0,TEMPLATE,0);
    //still not working!!!
    //templateScene.render();
  }
  else
  {
    Game.SceneManager.renderArea();
  }
}