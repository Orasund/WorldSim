class RenderEngine// implements Service
{
  JSONObject Views;
  String corrent_view;
  RenderEngine(String name, int max_)
  {
    Views = new JSONObject();
    corrent_view = name;
    addView(name,max_);
  }

  void addView(String name,int max_)
  {
    JSONObject view = new JSONObject();
    int size = height/(max_*8);
    int offset_x = (width-max_*8*size)/2;
    int offset_y = (height-max_*8*size)/2;
    view.setInt("max",max_);
    view.setInt("size",size);
    view.setInt("offset_x",offset_x);
    view.setInt("offset_y",offset_y);
    view.setFloat("pos_x",0);//(10*8*size)/2);
    view.setFloat("pos_y",0);//(10*8*size)/2);
    view.setFloat("rotation",0);
    Views.setJSONObject(name, view);
  }

  JSONObject getView()
  {
    return Views.getJSONObject(corrent_view);
  }

  void setView(String name)
  {
    corrent_view = name;
  }

  void setPos(int x, int y)
  {
    PVector pos = calcPos(x, y);
    setAbsPos(pos.x, pos.y);
  }

  PVector calcPos(int x, int y)
  {
    float size = getView().getInt("size")*8;
    return new PVector(floor(x*size+size/2),floor(y*size+size/2));
  }

  void setAbsPos(float x, float y)
  {
    JSONObject view = getView();
    view.setFloat("pos_x",x);
    view.setFloat("pos_y",y);
    Views.setJSONObject(corrent_view, view);
  }

  float getX()
  {
    JSONObject view = getView();
    return view.getFloat("pos_x");
  }

  float getY()
  {
    JSONObject view = getView();
    return view.getFloat("pos_y");
  }

  float getRot()
  {
    JSONObject view = getView();
    return view.getFloat("rotation");
  }

  void setRot(float rot_)
  {
    float rot = rot_;
    if(rot >= TWO_PI)
      rot-=TWO_PI;
    else if(rot<0)
      rot+=TWO_PI;
    JSONObject view = getView();
    view.setFloat("rotation",rot);
    Views.setJSONObject(corrent_view, view);
  }

  void rotateScene()
  {
    float rot = getView().getFloat("rotation");
    translate(width/2, height/2);
    rotate(rot);
    translate(-width/2, -height/2);
  }

  void drawView()
  {
    noStroke();
    fill(0);
    float temp_x = getView().getInt("offset_x");
    float temp_y = getView().getInt("offset_y");
    float temp_size = getView().getInt("max")*8*getView().getInt("size");
    rect(temp_x,temp_y,temp_size,temp_size);
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

  PImage createImg(color[][] img)
  {
    //create the Image

    int zoom = getView().getInt("size");
    PImage out = createImage(SIZE*zoom, SIZE*zoom, RGB);
    out.loadPixels();

    for (int i = 0; i < SIZE; i++)
      for (int j = 0; j < SIZE; j++)
        for(int k = 0; k < zoom; k++)
          for(int l = 0; l < zoom; l++)
          {
            out.pixels[(j*zoom+l)*SIZE*zoom+i*zoom+k] = img[i][j]; 
          }

    out.updatePixels();
    return out;
  }

  void drawImg(PImage img,int x, int y)
  {
    noStroke();
    float size = getView().getInt("size");

    float temp_x = getView().getInt("offset_x");
    float temp_y = getView().getInt("offset_y");

    //relative Position
    temp_x += (getView().getInt("max")*8*size)/2;
    temp_y += (getView().getInt("max")*8*size)/2;

    //position of the camera on the map
    temp_x -=getView().getFloat("pos_x");
    temp_y -=getView().getFloat("pos_y");

    //position of the block
    temp_x += x*size;
    temp_y += y*size;

    image(img, temp_x, temp_y);
  }

  void drawRect(int x, int y)
  {
    noStroke();
    float size = getView().getInt("size");

    float temp_x = getView().getInt("offset_x");
    float temp_y = getView().getInt("offset_y");

    //relative Position
    temp_x += (getView().getInt("max")*8*size)/2;
    temp_y += (getView().getInt("max")*8*size)/2;

    //position of the camera on the map
    temp_x -=getView().getFloat("pos_x");
    temp_y -=getView().getFloat("pos_y");

    //position of the block
    temp_x += x*size;
    temp_y += y*size;
    
    float temp_size = size;
    rect(temp_x,temp_y,temp_size,temp_size);
  }
  
  void drawBackground(int x, int y)
  {
    noStroke();
    float size = getView().getInt("size");

    float temp_x = getView().getInt("offset_x");
    float temp_y = getView().getInt("offset_y");

    //relative Position
    temp_x += (getView().getInt("max")*8*size)/2;
    temp_y += (getView().getInt("max")*8*size)/2;

    //position of the camera on the map
    temp_x -=getView().getFloat("pos_x");
    temp_y -=getView().getFloat("pos_y");

    //position of the block
    temp_x += x*size;
    temp_y += y*size;
    
    float temp_size = size*8;
    rect(temp_x,temp_y,temp_size,temp_size);
  }

  public void render()
  {
    SceneManager sceneManager = GAME.getSceneManager();
    
    sceneManager.renderArea();
  }
}