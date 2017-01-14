void gameSetup()
{
  noStroke();
  SIZE = 8;
  int MAP_DETAIL = 4;
  int MAP_SIZE = 4*MAP_DETAIL;
  GAME = new Game();
  GAME.addGameLoop(new GameLoop(60,60,6));
  GAME.addSetupManager(new SetupManager());
  GAME.addInputHandler(new InputHandler());
  GAME.addRenderEngine(new RenderEngine("single",4*MAP_DETAIL));
  RenderEngine renderEngine = GAME.getRenderEngine();
  renderEngine.addView("map");
  GAME.addObjectManager(new ObjectManager());
  GAME.addSimulationManager(new SimulationManager());

  GameLoop gameLoop = GAME.gameLoop;
  InputHandler inputHandler = GAME.getInputHandler();
  
  ObjectManager objectManager = GAME.getObjectManager();
  
  


  COUNTER = 0;
  registerObjects();

  TEMPLATE = solidTemplate(0,10,0,0);

  Map map = new Map("chunk");
  int POS_X = MAP_SIZE/2;
  int POS_Y = MAP_SIZE/2;
  float DIR = 0;
  
  GAME.addPlayer(new Player(POS_X,POS_Y));
  Player player = GAME.getPlayer();

  GAME.addSceneManager(new SceneManager("main",map.getMap(),"chunk"));
  SceneManager sceneManager = GAME.getSceneManager();
  sceneManager.addScene("template",TEMPLATE,"tiles");
  sceneManager.chanceScene("template");
}