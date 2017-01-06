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
  private float zoom;
  Camera(int max_)
  {
    size = height/(max_*8);
    offset_x = (width-max_*8*size)/2;
    offset_y = (height-max_*8*size)/2;
    max = max_;
    pos_x = 0;
    pos_y = 0;
    rotation = 0;
    zoom = 1;

    temp_x = offset_x;
    temp_y = offset_y;

    //relative Position
    temp_x += (max*SIZE*size)/2;
    temp_y += (max*SIZE*size)/2;
  }

  PVector getTempPos(PVector pos)
  {
    PVector out = new PVector();
    out.x = temp_x - pos_x*zoom + pos.x*size*zoom;
    out.y = temp_y - pos_y*zoom + pos.y*size*zoom;
    return out;
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

  float getZoom()
  {
    return zoom;
  }

  void setZoom(float zoom_)
  {
    zoom = zoom_;
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