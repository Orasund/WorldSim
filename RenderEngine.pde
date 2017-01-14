class RenderEngine// implements Service
{
  String corrent_view;
  int max;
  HashMap<String,Camera> cameras;
  RenderEngine(String name, int max_)
  {
    cameras = new HashMap<String,Camera>();
    max = max_;
    corrent_view = name;
    addView(name);
  }

  //please remove if possible
  void addView(String name)
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

  float getZoom()
  {
    return getCamera().getZoom();
  }

  void setZoom(float zoom)
  {
    getCamera().setZoom(zoom);
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
    int zoom = getCamera().getSize();
    PImage out = createImage(SIZE*zoom, SIZE*zoom, RGB);
    out.loadPixels();

    out.pixels = imgToPixels(img);

    out.updatePixels();
    return out;
  }

  /*PVector calcRelPos(PVector pos)
  {
    return getCamera().calcRelPos(pos);
  }*/

  PVector getTempPos(PVector pos)
  {
    return getCamera().getTempPos(pos);
  }

  /*float getTempX(int x)
  {
    return getCamera().getTempX(x);
  }

  float getTempY(int y)
  {
    return getCamera().getTempY(y);
  }*/

  void drawImg(PImage img,int x, int y)
  {


    PVector temp_pos = getTempPos(new PVector(x,y));
    image(img, temp_pos.x, temp_pos.y);
  }

  void drawPart(int[][] img, int x, int y, color background, String group)
  {
    ObjectManager objectManager = GAME.getObjectManager();
    Part[] parts = objectManager.getGroup(group);

    color c;
    for(int i=0;i<SIZE;i++)
      for(int j=0;j<SIZE;j++)
      {
        if(img[i][j] == 0)
          c = background;
        else
          c = parts[img[i][j]].getColor();

        PVector temp_pos = getTempPos(new PVector(x,y));
        float size = getCamera().getSize()*getCamera().getZoom();
        float offset_x = (size*i);
        float offset_y = (size*j);
        fill(c);
        rect(temp_pos.x + offset_x,temp_pos.y + offset_y,size,size);
      }
  }

  public void render()
  {
    SceneManager sceneManager = GAME.getSceneManager();
    GuiManager guiManager = GAME.getGuiManager();
    
    sceneManager.renderArea();

    guiManager.drawGUI();
  }
}