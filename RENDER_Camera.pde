public class Camera
{
  private int max;
  private int size;
  private int offset_x;
  private int offset_y;
  private int pos_x;
  private int pos_y;
  private float rotation;
  private float temp_x;
  private float temp_y;
  Camera(int max_)
  {
    //JSONObject view = new JSONObject();



    size = height/(max_*8);
    //size=6;


    offset_x = (width-max_*8*size)/2;
    offset_y = (height-max_*8*size)/2;
    //view.setInt("max",max_);
    max = max_;
    //view.setInt("size",size);
    //view.setInt("offset_x",offset_x);
    //view.setInt("offset_y",offset_y);
    pos_x = 0;
    pos_y = 0;
    //view.setFloat("pos_x",0);//(10*8*size)/2);
    //view.setFloat("pos_y",0);//(10*8*size)/2);
    //view.setFloat("rotation",0);
    rotation = 0;
    //Views.setJSONObject(name, view);

    temp_x = offset_x;
    temp_y = offset_y;

    //relative Position
    temp_x += (max*SIZE*size)/2;
    temp_y += (max*SIZE*size)/2;
  }

  float getTempX(int x)
  {
    return temp_x -pos_x + x*size;
  }

  float getTempY(int y)
  {
    return temp_y -pos_y + y*size;
  }

  void setPos(int x, int y)
  {
    PVector pos = calcPos(x,y); 
    pos_x = floor(pos.x);
    pos_y = floor(pos.y);
  }

  PVector calcPos(int x, int y)
  {
    PVector out = new PVector();
    float temp_size = size*SIZE;
    out.x = floor(x*temp_size+temp_size/2);
    out.y = floor(y*temp_size+temp_size/2);
    return out;
  }

  void setRot(float rot)
  {
    rotation = rot;
    if(rotation >= TWO_PI)
      rotation-=TWO_PI;
    else if(rot<0)
      rotation+=TWO_PI;
  }

  void rotateScene()
  {
    translate(width/2, height/2);
    rotate(rotation);
    translate(-width/2, -height/2);
  }

  float getRot()
  {
    return rotation;
  }

  int getSize()
  {
    return size;
  }

  int getPosX()
  {
    return pos_x;
  }

  int getPosY()
  {
    return pos_y;
  }

  void setAbsPos(int x, int y)
  {
    pos_x = x;
    pos_y = y;
  }
}