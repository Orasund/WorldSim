public class InputHandler implements Service
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
    PVector pos;
    float dir;
    JSONObject a;
    Player player = Game.Player;
    switch(input)
    {
      case "w":
        pos = player.lookingAt();
        Game.SceneManager.moveTo(int(pos.x), int(pos.y), 10);
        player.setPos(pos);
        break;

      case "s":
        pos = player.infrontOf();
        Game.SceneManager.moveTo(int(pos.x), int(pos.y), 10);
        player.setPos(pos);
        break;
      case "d":
        dir = player.getDir()-PI/2;
        Game.SceneManager.rotateTo(dir,10);
        player.setDir(dir);
        break;
      case "a":
        dir = player.getDir()+PI/2;
        Game.SceneManager.rotateTo(dir,10);
        player.setDir(dir);
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
    //String[] long_press = {"w","s"};
    /*for(int i = 0; i < long_press.length; i++)
      if(input_ == long_press[i])
      {
        longInput(input_);
        return;
      }*/
    if(isLongPress(input_))
    {
      longInput(input_);
      return;
    }
    println("=>>" + input_);
    translateInput(input_);

    
    //bufferSet.remove(input_);
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