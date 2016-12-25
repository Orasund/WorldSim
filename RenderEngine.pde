class RenderEngine// implements Service
{
  String corrent_view;
  HashMap<String,Camera> cameras;
  RenderEngine(String name, int max_)
  {
    cameras = new HashMap<String,Camera>();
    corrent_view = name;
    addView(name,max_);
  }

  void addView(String name,int max)
  {
    cameras.put(name,new Camera(max));
  }

  private Camera getCamera()
  {
    return cameras.get(corrent_view);
  }

  void setView(String name)
  {
    corrent_view = name;
  }

  void setPos(int x, int y)
  {
    getCamera().setPos(x,y);
  }

  PVector calcPos(int x, int y)
  {
    return getCamera().calcPos(x, y);
  }

  void setAbsPos(float x, float y)
  {
    getCamera().setAbsPos(floor(x),floor(y));
  }

  float getX()
  {
    return getCamera().getPosX();
  }

  float getY()
  {
    return getCamera().getPosY();
  }

  float getRot()
  {
    return getCamera().getRot();
  }

  void setRot(float rot_)
  {
    getCamera().setRot(rot_);
  }

  void rotateScene()
  {
    getCamera().rotateScene();
  }

  PImage createImgByIntArray(int[][] template,color c, String group)
  {
    ObjectManager objectManager = GAME.getObjectManager();

    color[][] out = new color[SIZE][SIZE];
    Part[] parts = objectManager.getGroup(group);
    for(int i=0;i<SIZE;i++)
      for(int j=0;j<SIZE;j++)
      {
        if(template[i][j] == 0)
          out[i][j] = c;
        else
          out[i][j] = parts[template[i][j]].getColor();
      }
    return createImg(out);
  }

  color[] imgToPixels(color[][] a)
  {
    int zoom = getCamera().getSize();
    color[] out = new color[SIZE*zoom*SIZE*zoom];
    for (int i = 0; i < SIZE; i++)
      for (int j = 0; j < SIZE; j++)
        for(int k = 0; k < zoom; k++)
          for(int l = 0; l < zoom; l++)
            out[(j*zoom+l)*SIZE*zoom+i*zoom+k] = a[i][j];
    return out; 
  }

  color[][] pixelToImg(color[] a)
  {
    int zoom = getCamera().getSize();
    color[][] out = new color[SIZE][SIZE];
    for (int i = 0; i < SIZE; i++)
      for (int j = 0; j < SIZE; j++)
        for(int k = 0; k < zoom; k++)
          for(int l = 0; l < zoom; l++)
            out[i][j] = a[(j*zoom+l)*SIZE*zoom+i*zoom+k];
    return out; 
  }

  PImage createImg(final color[][] img)
  {
    //create the Image
    //BUG
    int zoom = getCamera().getSize();
    //int zoom = 6;
    PImage out = createImage(SIZE*zoom, SIZE*zoom, RGB);
    out.loadPixels();

    out.pixels = imgToPixels(img);

    out.updatePixels();
    return out;
  }

  float getTempX(int x)
  {
    return getCamera().getTempX(x);
  }

  float getTempY(int y)
  {
    return getCamera().getTempY(y);
  }

  void drawImg(PImage img,int x, int y)
  {
    noStroke();

    float temp_x = getTempX(x);
    float temp_y = getTempY(y);

    image(img, temp_x, temp_y);
  }

  public void render()
  {
    SceneManager sceneManager = GAME.getSceneManager();
    
    sceneManager.renderArea();
  }
}