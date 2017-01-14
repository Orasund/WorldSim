public class GuiManager
{
  GuiManager()
  {
    
  }

  public void drawGUI()
  {
    SceneManager sceneManager = GAME.getSceneManager();
    ObjectManager objectManager = GAME.objectManager();

    String part_name = sceneManager.getCorrentPartName();
    Part part = objectManager.getPart(part_name);
    String group_name = part.getGroupName();
    Part[] group = objectManager.getGroup(group_name);

    //TODO absolute DrawTools
  }
}