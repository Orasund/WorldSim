public class Game
{
  private Player player;
  private GameLoop gameLoop;
  private RenderEngine renderEngine;
  private ObjectManager objectManager;
  private SceneManager sceneManager;
  private InputHandler inputHandler;
  private SimulationManager simulationManager;

  Game()
  {
  }

  public void addInputHandler(InputHandler sv)
  {
    inputHandler = sv;
  }

  public InputHandler getInputHandler()
  {
    if(inputHandler == null)
    {
      println("ERROR:");
    }
    return inputHandler;
  }

  public void addObjectManager(ObjectManager sv)
  {
    objectManager = sv;
  }

  public ObjectManager getObjectManager()
  {
    return objectManager;
  }

  public void addPlayer(Player sv)
  {
    player = sv;
  }

  public Player getPlayer()
  {
    return player;
  }

  public void addGameLoop(GameLoop sv)
  {
    gameLoop = sv;
  }

  public GameLoop getGameLoop()
  {
    return gameLoop;
  }

  public void addSimulationManager(SimulationManager sv)
  {
    simulationManager = sv;
  }

  public SimulationManager getSimulationManager()
  {
    return simulationManager;
  }

  public void addRenderEngine(RenderEngine sv)
  {
    renderEngine = sv;
  }

  public RenderEngine getRenderEngine()
  {
    return renderEngine;
  }

  public void addSceneManager(SceneManager sv)
  {
    sceneManager = sv;
  }

  public SceneManager getSceneManager()
  {
    return sceneManager;
  }
}