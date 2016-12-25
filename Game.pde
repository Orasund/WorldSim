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

  public void addInputHandler(InputHandler sv){inputHandler = sv;}

  public InputHandler getInputHandler()
  {
    if(inputHandler == null)
      throw new RuntimeException("cant find InputHandler @Game.pde");
    return inputHandler;
  }

  public void addObjectManager(ObjectManager sv){objectManager = sv;}

  public ObjectManager getObjectManager()
  {
    if(objectManager == null)
      throw new RuntimeException("cant find objectManager @Game.pde");
    return objectManager;
  }

  public void addPlayer(Player sv){player = sv;}

  public Player getPlayer()
  {
    if(player == null)
      throw new RuntimeException("cant find player @Game.pde");
    return player;
  }

  public void addGameLoop(GameLoop sv){gameLoop = sv;}

  public GameLoop getGameLoop()
  {
    if(gameLoop == null)
      throw new RuntimeException("cant find gameLoop @Game.pde");
    return gameLoop;
  }

  public void addSimulationManager(SimulationManager sv){simulationManager = sv;}

  public SimulationManager getSimulationManager()
  {
    if(simulationManager == null)
      throw new RuntimeException("cant find simulationManager @Game.pde");
    return simulationManager;
  }

  public void addRenderEngine(RenderEngine sv){renderEngine = sv;}

  public RenderEngine getRenderEngine()
  {
    if(renderEngine == null)
      throw new RuntimeException("cant find renderEngine @Game.pde");
    return renderEngine;
  }

  public void addSceneManager(SceneManager sv){sceneManager = sv;}

  public SceneManager getSceneManager()
  {
    if(sceneManager == null)
      throw new RuntimeException("cant find sceneManager @Game.pde");
    return sceneManager;
  }
}