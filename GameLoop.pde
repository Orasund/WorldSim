public class GameLoop //implements Service
{
  private int length;
  private int counter;
  private int frame_rate;
  private int frame;
  private int max_frame;
  GameLoop(int length_, int frame_rate_, int max_frame_)
  {
    length = length_;
    counter = 0;
    frame = 0;
    frame_rate = frame_rate_;
    max_frame = max_frame_;
  }

  private void nextFrame()
  {
    frame++;
    if(frame >= max_frame)
      frame = 0;
  }

  public int getFrame()
  {
    return frame;
  }

  public boolean tick()
  {
    boolean out = false;

    counter++;
    if(counter >= length)
    {
      counter = 0;
      out = true;
    }
    
    if(counter%frame_rate == 0)
      nextFrame();

    return out;
  }
}
