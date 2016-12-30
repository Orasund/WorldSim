void draw()
{
  try
  {
    InputHandler inputHandler = GAME.getInputHandler();
    GameLoop gameLoop = GAME.getGameLoop();
    RenderEngine renderEngine = GAME.getRenderEngine();
    Player player = GAME.getPlayer();
    SceneManager sceneManager = GAME.getSceneManager();

    inputHandler.checkInputs();

    if(gameLoop.tick())
    {

      COUNTER++;

      //disabling the template Scene
      if(COUNTER <16)
        COUNTER = 16;
      
      if(COUNTER == 16)
      {
        renderEngine.setView("map");
        PVector pos = player.getPos();
        renderEngine.setPos(int(pos.x), int(pos.y));
        sceneManager.chanceScene("main");
      }

      if(COUNTER <16)
      {
        int[][] map_empty = new int[8][8];
        for(int i=0;i<8;i++)
          for(int j=0;j<8;j++)
            map_empty[i][j]=0;
        
        int[][] map = sceneManager.getMap();
        sceneManager.setMap(iterateTile(map,map_empty));
      }
        
    }

    background(0);

    if(COUNTER <16)
    {
      //Needs a system to display the iterations like drawTemplate
      //drawBlock(0,0,TEMPLATE,0);
      //still not working!!!
      //templateScene.render();
    }
    else
    {
      //draw the area around the player
      sceneManager.renderArea();
    }    
  }
  catch (Exception e)
  {
    println("ERROR:"+e.getMessage());
    exit();
  }
}