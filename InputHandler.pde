public class InputHandler// implements Service
{
  private int buffer;
  private Set<String> inputs;
  private Set<String> bufferSet;

  InputHandler()
  {
    buffer = 0;
    inputs = new Set<String>();
    bufferSet = new Set<String>();
  }

  private void translateInput(String input)
  {
    Player player = GAME.getPlayer();
    SceneManager sceneManager = GAME.getSceneManager();

    PVector pos;
    float dir;
    JSONObject a;

    switch(input)
    {
      case "w": //up
        pos = player.lookingAt();
        sceneManager.moveTo(int(pos.x), int(pos.y), 20);
        player.setPos(pos);
        break;
      case "s": //down
        pos = player.infrontOf();
        sceneManager.moveTo(int(pos.x), int(pos.y), 20);
        player.setPos(pos);
        break;
      case "d": //rotate right
        dir = player.getDir()-PI/2;
        sceneManager.rotateTo(dir,20);
        player.setDir(dir);
        break;
      case "a": //rotate left
        dir = player.getDir()+PI/2;
        sceneManager.rotateTo(dir,20);
        player.setDir(dir);
        break;
      case "e": //zoom
        sceneManager.zoom(20);
        sceneManager.rotateTo(0,20);
        break;
    }
  }

  public void checkInputs()
  {
    if(buffer>0)
    {
      buffer--;
      return;
    }

    if(inputs.size() == 0)
      return;

    ArrayList<String> array = inputs.toArrayList();
    for(int i = 0; i<array.size(); i++)
      translateInput(array.get(i));
    
    array = bufferSet.toArrayList();
    for(int i = 0; i<array.size(); i++)
      inputs.remove(array.get(i));
    bufferSet.clear();

    buffer = 10;
  }

  public void longInput(String input_)
  {
    println("=>"+input_);
    if(inputs.size()>1 && bufferSet.contains(input_))
      return;
    inputs.add(input_);
  }

  private boolean isLongPress(String input_)
  {
    String[] long_press = {"w","s"};
    for(int i = 0; i < long_press.length; i++)
      if(input_.equals(long_press[i]))
        return true;
    return false;
  }

  public void registerInput(String input_)
  {
    if(isLongPress(input_))
    {
      longInput(input_);
      return;
    }
    println("=>>" + input_);
    translateInput(input_);
  }

  public void dropInput(String input_)
  {
    if(isLongPress(input_) == false)
      return;

    println("<="+input_);
    if(inputs.size()>1)
      bufferSet.add(input_);
    else
      inputs.remove(input_);
  }
}