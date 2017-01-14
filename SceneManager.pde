public class SceneManager //implements Service
{
  private String corrent_scene;
  private int trans_time;
  private PVector trans_location;
  private float rot_location;
  private float rot_time;
  private float zoom_time;
  private int zoom_level;

  private Database<Scene> database;

  private Scene getCorrentScene(){return database.get(corrent_scene);}

  SceneManager(String name, int[][] map, String tiles)
  {
    corrent_scene = name;
    database = new Database<Scene>();

    trans_time = 0;
    trans_location = new PVector(0,0);

    rot_time = 0;
    rot_location = 0;

    zoom_time = 0;
    zoom_level = 0;

    addScene(name,map,tiles);
  }

  public String getCorrentPartName()
  {
    return getCorrentScene().getCorrentPartName();
  }

  public void moveTo(int x, int y, int time)
  {
    RenderEngine renderEngine = GAME.getRenderEngine();

    trans_location = renderEngine.calcPos(x, y);
    trans_time = time;
  }

  public void rotateTo(float rot, int time)
  {
    if(rot >= TWO_PI)
      rot-=TWO_PI;
    else if(rot<0)
      rot+=TWO_PI;

    rot_location = rot;
    rot_time = time;
  }

  public void zoom(int time)
  {
    RenderEngine renderEngine = GAME.getRenderEngine();
    
    zoom_time = time;
    if(renderEngine.getZoom()<SIZE/2)
    {
      zoom_level = 1;
    }
    else
      zoom_level = 0;
  }

  public void addScene(String name, int[][] map, String tiles)
  {
    database.add(name,new Scene(map,tiles));
  }

  public void chanceScene(String name)
  {
    corrent_scene = name;
  }

  public void renderScene()
  {
    getCorrentScene().renderArea();
  }

  public void renderArea()
  {
    RenderEngine renderEngine = GAME.getRenderEngine();

    if(trans_time != 0)
    {
      PVector location = new PVector(renderEngine.getX(),renderEngine.getY());
      PVector target = trans_location;
      PVector difference = PVector.sub(target,location);
      difference.setMag(difference.mag()/trans_time);
      location.add(difference);
      renderEngine.setAbsPos(location.x,location.y);
      trans_time--;
    }

    if(rot_time != 0)
    {
      float rot = renderEngine.getRot();
      float difference = rot_location-rot;
      
      if(difference > PI)
        difference -= TWO_PI;
      else if(difference < -PI)
        difference += TWO_PI;

      difference /= rot_time;
      renderEngine.setRot(rot+difference);
      
      rot_time--;
    }

    if(zoom_time != 0)
    {
      float zoom = renderEngine.getZoom();
      float factor = pow(SIZE*2,zoom_level);
      
      float difference = (factor-zoom)/zoom_time;
      renderEngine.setZoom(zoom+difference);
      zoom_time--;
    }

    getCorrentScene().renderArea();
  }

  public void setMap(int[][] map)
  {
    getCorrentScene().setMap(map);
  }

  public int[][] getMap()
  {
    return getCorrentScene().getMap();
  }
}

