public class Game
{
  Player Player;
  GameLoop GameLoop;
  RenderEngine RenderEngine;
  ObjectManager ObjectManager;
  SceneManager SceneManager;
  InputHandler InputHandler;

  Game()
  {
  }

  Game(Player Player_,GameLoop GameLoop_,RenderEngine RenderEngine_,ObjectManager ObjectManager_,SceneManager SceneManager_,InputHandler InputHandler_)
  {
    Player = Player_;
    GameLoop = GameLoop_;
    RenderEngine = RenderEngine_;
    ObjectManager = ObjectManager_;
    SceneManager = SceneManager_;
    InputHandler = InputHandler_;
  }

  private void sendToInput(Msg msg)
  {
    switch(msg.msg)
    {
      case "drop":
        InputHandler.dropInput(msg.a.getString("a1"));
        break;
      case "register":
        InputHandler.registerInput(msg.a.getString("a1"));
        break;
      case "check":
        InputHandler.checkInputs();
        break;
    }
  }

  public void addInputHandler(InputHandler sv)
  {
    InputHandler = sv;
  }

  public void addObjectManager(ObjectManager sv)
  {
    ObjectManager = sv;
  }

  public void addPlayer(Player sv)
  {
    Player = sv;
  }

  public void addGameLoop(GameLoop sv)
  {
    GameLoop = sv;
  }

  public void addRenderEngine(RenderEngine sv)
  {
    RenderEngine = sv;
  }

  public void addSceneManager(SceneManager sv)
  {
    SceneManager = sv;
  }

  /*public void add(String name, Service service)
  {
    switch(name)
    {
      case "player":
        Player = service;
        break;
      case "gameLoop":
        GameLoop = service;
        break;
      case "renderEngine":
        RenderEngine = service;
        break;
      case "objectManager":
        ObjectManager = service;
        break;
      case "sceneManager":
        SceneManager = service;
        break;
      case "inputHandler":
        InputHandler = service;
        break;
      default:
        println("(!!!) TIPO in Game.add()");
    }
  }*/

  private void sendToScene(Msg msg)
  {
    int i1,i2,i3;
    float f1;
    String s1;
    switch(msg.msg)
    {
      case "moveTo":
        i1 = msg.a.getInt("a1");
        i2 = msg.a.getInt("a2");
        i3 = msg.a.getInt("a3");
        SceneManager.moveTo(i1, i2, i3);
        break;
      case "rotateTo":
        f1 = msg.a.getFloat("a1");
        i2 = msg.a.getInt("a2");
        SceneManager.rotateTo(f1,i2);
        break;
      case "renderArea":
        SceneManager.renderArea();
        break;
      case "chanceScene":
        s1 = msg.a.getString("a1");
        SceneManager.chanceScene(s1);
        break;
    }
  }

  public void send(String adress_,String msg_,JSONObject attributes_)
  {
    Msg msg = new Msg(adress_,msg_,attributes_);
    switch(msg.adress)
    {
      case "input":
        sendToInput(msg);
        break;
      case "scene":
        sendToScene(msg);
        break;
      /*case "render":
        sendToRender(msg);
        break;
      case "object":
        sendToObject(msg);
        break;*/
    }
  }
}