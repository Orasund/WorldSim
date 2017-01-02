/* PRESS STRG+SHIFT+B TO COMPILE */
int[][] TEMPLATE;
int COUNTER;
int SIZE;
Game GAME;

void setup() {
  //size(640, 640);
  //size(1024,768);
  size(1024,768,P2D);
  try
  {
    gameSetup();
  }
  catch (Exception e)
  {
    println("!!!ERROR:"+e.getMessage());
    e.printStackTrace();
    //exit();
  }
}

void keyReleased()
{
  InputHandler inputHandler = GAME.getInputHandler();

  char k[] = {key};
  String out = new String(k);
  inputHandler.dropInput(out);
}

void keyPressed()
{
  InputHandler inputHandler = GAME.getInputHandler();

  char k[] = {key};
  String out = new String(k);
  inputHandler.registerInput(out);
}