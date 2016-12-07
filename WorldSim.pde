/* PRESS STRG+SHIFT+B TO COMPILE */
int[][] TEMPLATE;
int COUNTER;
Game Game;

void setup() {
  size(640, 640);
  int MAP_DETAIL = 4;
  int MAP_SIZE = 4*MAP_DETAIL;
  Game = new Game();
  Game.addGameLoop(new GameLoop(60,60,6));
  Game.addInputHandler(new InputHandler());
  Game.addRenderEngine(new RenderEngine("single",1));
  Game.addObjectManager(new ObjectManager());

  GameLoop GameLoop = Game.GameLoop;
  InputHandler InputHandler = Game.InputHandler;
  RenderEngine RenderEngine = Game.RenderEngine;
  ObjectManager ObjectManager = Game.ObjectManager;
  
  
  RenderEngine.addView("map",4*MAP_DETAIL);

  COUNTER = 0;
  registerObjects();

  Tile[] b = new Tile[6];
  b[0] = createGround();
  b[1] = createLake();
  b[2] = createStone();
  b[3] = createAlga();
  b[4] = createMoss();
  b[5] = createBush();
  TEMPLATE = solidTemplate(0,10,0);

  Map map = new Map("chunk");
  int POS_X = MAP_SIZE/2;
  int POS_Y = MAP_SIZE/2;
  float DIR = 0;
  
  Game.addPlayer(new Player(POS_X,POS_Y));
  Player Player = Game.Player;

  Game.addSceneManager(new SceneManager("main",map.getMap(),"chunk"));
  SceneManager SceneManager = Game.SceneManager;
  SceneManager.addScene("template",TEMPLATE,"tiles");
  SceneManager.chanceScene("template");
}

void keyReleased()
{
  char k[] = {key};
  String out = new String(k);
  Game.InputHandler.dropInput(out);
}

void keyPressed()
{
  char k[] = {key};
  String out = new String(k);
  Game.InputHandler.registerInput(out);
}