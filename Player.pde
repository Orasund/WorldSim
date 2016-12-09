public class Player //implements Service
{
  private PVector pos;
  private float dir;
  
  Player(int x, int y)
  {
    pos = new PVector(x,y);
    dir = 0;
  }

  private PVector dirVector()
  {
    if(dir>=TWO_PI*(7./8.) || dir<TWO_PI*(1./8.))
    {
      return new PVector(0,-1);
    }
    else if(dir>=TWO_PI*(1./8.) && dir<TWO_PI*(3./8.))
    {
      return new PVector(-1,0);
    }
    else if(dir>=TWO_PI*(3./8.) && dir<TWO_PI*(5./8.))
    {
      return new PVector(0,1);
    } 
    else if(dir>=TWO_PI*(5./8.) && dir<TWO_PI*(7./8.))
    {
      return new PVector(1,0);
    } 
    println("WARNING:something is wrong at dirVector()");
    return new PVector(0,0);
  }

  public PVector getPos(){return pos.copy();}

  public float getDir(){return dir;}

  public void setPos(final PVector pos_){pos = pos_.copy(); }

  public void setDir(float dir_)
  {
    dir = dir_;
    if(dir<0)
      dir+=TWO_PI;
    if(dir>=TWO_PI)
      dir-=TWO_PI;
  }

  public PVector lookingAt(){return PVector.add(pos,dirVector());}

  public PVector infrontOf(){return PVector.sub(pos,dirVector());}
}