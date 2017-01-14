public class GuiManager
{
  GuiManager()
  {
    
  }

  public void drawGUI()
  {
    SceneManager sceneManager = GAME.getSceneManager();
    ObjectManager objectManager = GAME.getObjectManager();

    String part_name = sceneManager.getCorrentPartName();
    Part part = objectManager.getPart(part_name);
    String group_name = part.getGroupName();
    Part[] group = objectManager.getGroup(group_name);

    //TODO absolute DrawTools
    int img_size = group[0].getImage(0).width;
    int x = width/2;
    int y = height-img_size;
    fill(255);
    rect(0,y-1,16*(img_size+1),height);
    for(int i = 0; i< group.length; i++)
    {
      PImage img = group[i].getImage(0);
      x = 1+i*(img_size+1);
      y = height-img_size;
      image(img, x, y);
    }
  }
}