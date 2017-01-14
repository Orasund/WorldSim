import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class WorldSim extends PApplet {

/* PRESS STRG+SHIFT+B TO COMPILE */
int[][] TEMPLATE;
int COUNTER;
int SIZE;
Game GAME;

public void setup() {
  //size(640, 640);
  //size(1024,768);
  
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

public void keyReleased()
{
  InputHandler inputHandler = GAME.getInputHandler();

  char k[] = {key};
  String out = new String(k);
  inputHandler.dropInput(out);
}

public void keyPressed()
{
  InputHandler inputHandler = GAME.getInputHandler();

  char k[] = {key};
  String out = new String(k);
  inputHandler.registerInput(out);
}
/*public class Block extends Tile
{
  Block(int[][][] img_, int[] resources_, int background_, color c_, Set<String> types_)
  {
    super(img_, resources_, background_, c_, types_);
  }
}*/
public class OrganicSim extends Simulation
{
  OrganicSim(final int[][] template,String group)
  {
    //super(3,SimulationManager_);
    super(3);

    ObjectManager objectManager = GAME.getObjectManager();

    String[] names_ = {"organics","water","water_buffer"};
    setNames(names_);

    Part[] Tiles = objectManager.getGroup(group);
    int size = template[0].length;

    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
      {
        if(Tiles[template[i][j]].is("organic"))
        {
          //we assume that the groupname is element
          if(Tiles[template[i][j]].getGroupName().equals("elements")==false)
          {
            println("BUG in simOrganic:groupname not elements");
            return;
          }
          int value = Tiles[template[i][j]].getResources()[3];
          if(value > 16)
            value = 16;
          setEntry("organics",i,j,value);
        }
        else
          setEntry("organics",i,j,0);
      }
        
    //creating water table and water_buffer
    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
        if(Tiles[template[i][j]].is("water"))
        {
          setEntry("water",i,j, 100);
          setEntry("water_buffer",i,j,100);
        }
  }

  public void callEvent(String type, String event, int x, int y, int id)
  {
    String group = GAME.getSimulationManager().getGroup();
    Part[] tiles = GAME.getObjectManager().getGroup(group);
    switch(type)
    {
      case "water":
        switch(event)
        {
          case "create":
            setEntry("water",x,y,100);
            break;
          case "delete":
            setEntry("water",x,y,0);
            break;
        }
        break;

      case "organic":
        switch(event)
        {
          case "create":
            setEntry("organics",x,y,tiles[id].getResources()[3]);
            break;
          case "delete":
            setEntry("organics",x,y,0);
            break;
        }
        break;
    }
    
  }

  /*
  * Input
  *   template ... a array of the last iteration
  *   temp_template ... a array with updates to the template
  *   group ... name of the group of Parts for the template
  *   sim ... a simulationObject that helps with keeping data stored
  *
  * Output
  *   temp_template ... the same array but with new updates
  *
  * Algorithm
  *   1.)create food&water-table and a water_buffer-table
  *   2.)set food to amount of life-parts in Tile
  *   3.)set water to 100 for each water Tile
  *   4.)iterate 16 times
  *     A.)water_buffer = water
  *     B.)for each waterEntry >0
  *       a.)for each foodEntry next to waterEntry
  *         i.)(old)water.foodEntry += waterEntry.value [max at foodEntry.value]
  *         i.)water.foodEntry++;
  *     C.)for each water_bufferEntry
  *       a.)set waterEntry = 0
  *       b.)set foodEntry = 0
  *     D.)for each food
  *       a.)if foodEntry = 1 delete
  *       b.)WaterEntry-=1
  *   5.)for each waterEntry
  *     A.) delete
  */
  public int[][] sim(final int[][] template,final int[][] temp_template_,String group)
  {
    SimulationManager simulationManager = GAME.getSimulationManager();
    ObjectManager objectManager = GAME.getObjectManager();

    int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
    int x,y;
    int size = template[0].length;
    Part[] Tiles = objectManager.getGroup(group);

    int[][] temp_template = new int[size][size];
    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
        temp_template[i][j] = temp_template_[i][j];

    //(A)
    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
        setEntry("water_buffer",i,j,getEntry("water",i,j));
    
    //(B)
    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
      {
        if(getEntry("water",i,j)<=0)
          continue;
        
        for(int k = 0; k<4; k++)
        {
          x = i+dir[k][0];
          y = j+dir[k][1];
          if(x<0 || y<0 || x>=size || y>=size)
            continue;
          if(getEntry("organics",x,y)==0)
            continue;
          
          //setEntry("water",x,y,getEntry("water",i,j));
          setEntry("water",x,y,getEntry("water",x,y)+1);
          if(getEntry("water",x,y)>getEntry("organics",x,y))
            setEntry("water",x,y,getEntry("organics",x,y));
        }
      }
  
    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
      {
        if(getEntry("water_buffer",i,j)>0)
        {
          setEntry("water",i,j,0);
          setEntry("organics",i,j,0);
        }

        if(getEntry("organics",i,j)==0)
          continue;

        if(getEntry("organics",i,j)==1)
        {
          //Delete
          simulationManager.deleteEntry("organic",i,j);
          //if(Tiles[temp_template[i][j]].is("organic"))
            //temp_template[i][j] = 0;
        }

        setEntry("organics",i,j,getEntry("organics",i,j)-1);
      }

    return temp_template;
  }
}
public class OrganicSpawnSim extends Simulation
{
  private IntList organic_parts;

  OrganicSpawnSim(final int[][] template,String group)
  {
    super(2);//, SimulationManager_);

    ObjectManager objectManager = GAME.getObjectManager();
    organic_parts = new IntList();

    Part[] tiles = objectManager.getGroup(group);
    for(int i = 1; i < tiles.length; i++)
      if(tiles[i].is("organic"))
        organic_parts.append(i); 


    String[] names_ = {"water","organic_spawn"};
    setNames(names_);
    
    
    int size = template[0].length;

    //creating water table and organic_spawn
    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
      {
        if(tiles[template[i][j]].is("water"))
        {
          setEntry("water",i,j, 1);
        }

        if(tiles[template[i][j]].is("organic_spawn"))
        {
          setEntry("organic_spawn",i,j, 1);
        }
      }
  }

  public void callEvent(String type, String event, int x, int y, int id)
  {
    String group = GAME.getSimulationManager().getGroup();
    Part[] tiles = GAME.getObjectManager().getGroup(group);
    switch(type)
    {
      case "water":
        switch(event)
        {
          case "create":
            setEntry("water",x,y,1);
            break;
          case "delete":
            setEntry("water",x,y,0);
            break;
        }
        break;
      
      case "organic_spawn":
        switch(event)
        {
          case "create":
            setEntry("organic_spawn",x,y,1);
            break;
          case "delete":
            setEntry("organic_spawn",x,y,0);
            break;
        }
        break;
    }
    
  }

  //void
  public int[][] sim(final int[][] template,final int[][] temp_template_,String group)
  {
    ObjectManager objectManager = GAME.getObjectManager();
    SimulationManager simulationManager = GAME.getSimulationManager();
    Part[] tiles = objectManager.getGroup(group);

    //return simOrganicSpawn(template,temp_template_,group,sim);
    int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
    int x,y,x2,y2;
    int size = template[0].length;

    int[][] temp_template = new int[size][size];
    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
        temp_template[i][j] = temp_template_[i][j];

    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
      {
        if(getEntry("organic_spawn",i,j)!=1)
          continue;

        //create new spawn if possible
        for(int k = 0; k<4; k++)
        {
          x = i+dir[k][0];
          y = j+dir[k][1];
          if(x<0 || y<0 || x>=size || y>=size)
            continue;

          if(template[x][y] == 0)
          {

            if(organic_parts.size()==0)
              continue;

            //try to create an organic Part
            int my_id = x+y;
            int index = my_id % organic_parts.size();
            simulationManager.createEntry(organic_parts.get(index),x,y);
            continue;
          }

          if(getEntry("water",x,y)==0)
            continue;
          
          if(getEntry("organic_spawn",x,y)==1)
            continue;

          int count = 0;
          for(int l = 0; l<4; l++)
          {
            x2 = x+dir[l][0];
            y2 = y+dir[l][1];
            if(x2<0 || y2<0 || x2>=size || y2>=size)
              continue;

            if(getEntry("water",x2,y2)==0)
              continue;
            
            count++;
          }
          if(count>3 || count <2)
            continue;
          
          //new spawn can be created
          simulationManager.deleteEntry("water",x,y);
          simulationManager.createEntry(template[i][j],x,y);
          //setEntry("organic_spawn",x,y,1);
        }
      }

    return temp_template;
  }
}
/*public class Chunk implements Part
{
  private int[][] blocks;
  private int[] resources;
  private String group;
  private int background;
  private color c;

  Chunk(int[][] blocks_,String group_,int background_, color c_, int[] resources_)
  {
    blocks = new int[8][8];
    for(int j = 0;j<8;j++)
      for(int k = 0;k<8;k++)
      {
        blocks[j][k] = blocks_[j][k];
      }

    resources = new int[8];
    for(int i = 0;i<8;i++)
    {
      resources[i] = resources_[i];
    } 

    group = group_;
    background = background_;
  }

  public Chunk copy()
  {
    return new Chunk(blocks,group,background,c,resources);
  }

  public color getColor(){return c;}

  public boolean is(String type){return false;}

  public int[] getResources()
  {
    return resources;
  }

  public String getGroupName()
  {
    return group;
  }

  public String[] getTypes()
  {
    return new String[0];
  }

  public void drawFrame(int x, int y, int frame)
  {
    drawPartGrid(x,y,frame,blocks,group);
  }
}*/
public class Database<T>
{
  private HashMap<String,T> storage;
  private HashMap<String,String[]> groups;

  Database()
  {
    storage = new HashMap<String,T>();
    groups = new HashMap<String,String[]>();
  }

  public void addGroup(String name, String[] group){groups.put(name,group);}
  public String[] getGroup(String name){
    String[] out = groups.get(name);
    if(out == null)
      println("WARNING: can't find Group:" + name + " @Database.getGroup");
    return out;
  }
  public void add(String name, T item){storage.put(name,item);}
  public T get(String name){return storage.get(name);}
  public void delete(String name){storage.remove(name);}
  public void deleteGroup(String name){groups.remove(name);}
}
/*public class Element implements Part
{
  private color c;
  String name;

  Element(final color c_,String name_)
  {
    c = c_;
    name = name_;
  }

  public Part copy()
  {
    return new Element(c,name);
  }

  public void drawFrame(int x, int y, int frame){}

  public int[][] iterate(final int[][] template,final int[][] temp_template_,Part[] neighbors)
  {
    int[][] temp_template = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        temp_template[i][j]=temp_template_[i][j];

    return temp_template;
  }

  public color getColor()
  {
    return c;
  }

  public boolean is(String type)
  {
    return type.equals(name);
  }

  public String[] getTypes()
  {
    return new String[0];
  }

  public int[] getResources()
  {
    int[] out = new int[8];
    for(int i=0;i<8;i++)
      out[i] = 0;
    return out;
  }

  public String getGroupName()
  {
    return "elements";
  }
}*/
public class Game
{
  private Player player;
  private GameLoop gameLoop;
  private RenderEngine renderEngine;
  private ObjectManager objectManager;
  private SceneManager sceneManager;
  private InputHandler inputHandler;
  private SimulationManager simulationManager;
  private SetupManager setupManager;
  private GuiManager guiManager;

  Game()
  {
  }

  public void addGuiManager(GuiManager sv){guiManager = sv;}

  public GuiManager getGuiManager()
  {
    if(guiManager == null)
      throw new RuntimeException("cant find GuiManager @Game.pde");
    return guiManager;
  }

  public void addSetupManager(SetupManager sv){setupManager = sv;}

  public SetupManager getSetupManager()
  {
    if(setupManager == null)
      throw new RuntimeException("cant find SetupManager @Game.pde");
    return setupManager;
  }

  public void addInputHandler(InputHandler sv){inputHandler = sv;}

  public InputHandler getInputHandler()
  {
    if(inputHandler == null)
      throw new RuntimeException("cant find InputHandler @Game.pde");
    return inputHandler;
  }

  public void addObjectManager(ObjectManager sv){objectManager = sv;}

  public ObjectManager getObjectManager()
  {
    if(objectManager == null)
      throw new RuntimeException("cant find objectManager @Game.pde");
    return objectManager;
  }

  public void addPlayer(Player sv){player = sv;}

  public Player getPlayer()
  {
    if(player == null)
      throw new RuntimeException("cant find player @Game.pde");
    return player;
  }

  public void addGameLoop(GameLoop sv){gameLoop = sv;}

  public GameLoop getGameLoop()
  {
    if(gameLoop == null)
      throw new RuntimeException("cant find gameLoop @Game.pde");
    return gameLoop;
  }

  public void addSimulationManager(SimulationManager sv){simulationManager = sv;}

  public SimulationManager getSimulationManager()
  {
    if(simulationManager == null)
      throw new RuntimeException("cant find simulationManager @Game.pde");
    return simulationManager;
  }

  public void addRenderEngine(RenderEngine sv){renderEngine = sv;}

  public RenderEngine getRenderEngine()
  {
    if(renderEngine == null)
      throw new RuntimeException("cant find renderEngine @Game.pde");
    return renderEngine;
  }

  public void addSceneManager(SceneManager sv){sceneManager = sv;}

  public SceneManager getSceneManager()
  {
    if(sceneManager == null)
      throw new RuntimeException("cant find sceneManager @Game.pde");
    return sceneManager;
  }
}
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
public class InputHandler// implements Service
{
  private int buffer;
  private Set<String> inputs;
  private Set<String> bufferSet;

  InputHandler()
  {
    buffer = 0;
    inputs = new Set<String>();
    bufferSet = new Set<String>();
  }

  private void translateInput(String input)
  {
    Player player = GAME.getPlayer();
    SceneManager sceneManager = GAME.getSceneManager();

    PVector pos;
    float dir;
    JSONObject a;

    switch(input)
    {
      case "w": //up
        pos = player.lookingAt();
        sceneManager.moveTo(PApplet.parseInt(pos.x), PApplet.parseInt(pos.y), 20);
        player.setPos(pos);
        break;
      case "s": //down
        pos = player.infrontOf();
        sceneManager.moveTo(PApplet.parseInt(pos.x), PApplet.parseInt(pos.y), 20);
        player.setPos(pos);
        break;
      case "d": //rotate right
        dir = player.getDir()-PI/2;
        sceneManager.rotateTo(dir,20);
        player.setDir(dir);
        break;
      case "a": //rotate left
        dir = player.getDir()+PI/2;
        sceneManager.rotateTo(dir,20);
        player.setDir(dir);
        break;
      case "e": //zoom
        sceneManager.zoom(20);
        sceneManager.rotateTo(0,20);
        break;
    }
  }

  public void checkInputs()
  {
    if(buffer>0)
    {
      buffer--;
      return;
    }

    if(inputs.size() == 0)
      return;

    ArrayList<String> array = inputs.toArrayList();
    for(int i = 0; i<array.size(); i++)
      translateInput(array.get(i));
    
    array = bufferSet.toArrayList();
    for(int i = 0; i<array.size(); i++)
      inputs.remove(array.get(i));
    bufferSet.clear();

    buffer = 10;
  }

  public void longInput(String input_)
  {
    println("=>"+input_);
    if(inputs.size()>1 && bufferSet.contains(input_))
      return;
    inputs.add(input_);
  }

  private boolean isLongPress(String input_)
  {
    String[] long_press = {"w","s"};
    for(int i = 0; i < long_press.length; i++)
      if(input_.equals(long_press[i]))
        return true;
    return false;
  }

  public void registerInput(String input_)
  {
    if(isLongPress(input_))
    {
      longInput(input_);
      return;
    }
    println("=>>" + input_);
    translateInput(input_);
  }

  public void dropInput(String input_)
  {
    if(isLongPress(input_) == false)
      return;

    println("<="+input_);
    if(inputs.size()>1)
      bufferSet.add(input_);
    else
      inputs.remove(input_);
  }
}
class Map
{
  private int[][] map;
  private String group_name;

  Map(String parts)
  {
    group_name = parts;
    map = genMap();
  }

  Map(int size, int detail, String parts)
  {
    group_name = parts;
    map = genMap();
  }

  public int[][] getMap()
  {
    int[][] out = new int[map.length][map.length];
    for(int i = 0; i < map.length; i++)
      for(int j = 0; j < map[0].length; j++)
        out[i][j] = map[i][j];
    return out;
  }

  public int[][] genMap()
  {
    ObjectManager objectManager = GAME.getObjectManager();

    int size = SIZE;
    Part[] Tiles = objectManager.getGroup(group_name);
    int[][] map_layout = new int[size][size];
    int[] layout_pool = {50,20,10,20};
    int diversity = 2;

    for(int i=0;i<map_layout.length;i++)
      for(int j=0;j<map_layout.length;j++)
      {
        float rand = random(100);
        map_layout[i][j] = 0;
        for(int k=0;k<layout_pool.length;k++)
        {
          if(rand<layout_pool[k])
          {
            map_layout[i][j] = diversity*k+floor(random(diversity));
            break;
          }
          rand-=layout_pool[k];
        }
      }

    return map_layout;
  }

  public int[][] genMap(int size, int detail)
  {
    int[][] map_layout = new int[size/detail][size/detail];
    int[] layout_pool = {50,20,10,20};
    
    for(int i=0;i<map_layout.length;i++)
      for(int j=0;j<map_layout.length;j++)
      {
        float rand = random(100);
        map_layout[i][j] = 0;
        for(int k=0;k<layout_pool.length;k++)
        {
          if(rand<layout_pool[k])
          {
            map_layout[i][j] = k;
            break;
          }
          rand-=layout_pool[k];
        }
      }
    
    int[][] pool =
    {
      {5,0,0,0,10},//ground
      {70,0,10,0,0},//water
      {5,70,0,10,0},//mountain
      {10,5,0,0,50}//forest
    };

    int[][] out = new int[size][size];
    for(int i=0;i<size;i++)
      for(int j=0;j<size;j++)
      {
        float rand = random(100);
        int type;
        int l = map_layout[i/detail][j/detail];

        type = 0;
        for(int k=0;k<pool[l].length;k++)
        {
          if(rand<pool[l][k])
          {
            type = k+1;
            break;
          }
          rand-=pool[l][k];
        }
        out[i][j] = type;
      }
    return out;
  }
}
public class Msg
{
  public JSONObject a;
  public String adress;
  public String msg;

  public Msg(String adress_,String msg_,JSONObject attributes_)
  {
    adress = adress_;
    msg = msg_;
    a = attributes_;
  }
}
public class ObjectManager// implements Service
{
  private Database<Part> database;

  ObjectManager()
  {
    database = new Database<Part>();
  }

  public void registerPart(String name, Part part)
  {
    database.add(name,part.copy());
  }

  public void registerGroup(String name, String[] group)
  {
    String[] names = new String[group.length];
    for(int i=0;i<group.length;i++)
      names[i] = group[i];
    
    database.addGroup(name,names);
  }

  public Part getPart(String name)
  {
    Part out = database.get(name);
    if(out==null)
      throw new RuntimeException("getPart not found: "+name+" @ObjectManager.pde");
    return out;
  }

  public Part[] getGroup(String name)
  {
    String[] names = getNamesByGroup(name);
    Part[] out = new Part[names.length];

    for(int i=0;i<names.length;i++)
      out[i] = getPart(names[i]);

    return out;
  }

  public String[] getNamesByGroup(String name)
  {
    String[] out = database.getGroup(name);
    if(out.length == 0)
      throw new RuntimeException("getGroup not found: "+name+" @ObjectManager.pde");
    return out;
  }
}
public class Part
{
  private int[][][] img;
  private PImage[] images;
  private int[] resources;
  private int background;
  private int c;
  private Set<String> types;
  private String group;

  Part(int[][][] img_, int[] resources_, int background_, int c_, Set<String> types_,String group_)
  {
    RenderEngine renderEngine = GAME.getRenderEngine();

    resources = new int[5];
    for(int i = 0;i<5;i++)
      resources[i] = resources_[i];
    
    types = types_.copy();
    background = background_;
    c = c_;
    
    images = new PImage[6];
    img = new int[6][SIZE][SIZE];
    int[][] temp_img;
    for(int i = 0;i<6;i++)
    {
      temp_img = new int[SIZE][SIZE];
      for(int j = 0;j<SIZE;j++)
        for(int k = 0;k<SIZE;k++)
          temp_img[j][k] = img_[i][j][k];
      
      img[i] = temp_img;

      images[i] = renderEngine.createImgByIntArray(temp_img,c,group_);
    }
    
    group = group_;
  }

  //copy
  private Part(int[][][] img_, int[] resources_, int background_, int c_, Set<String> types_,String group_, PImage[] images_)
  {
    RenderEngine renderEngine = GAME.getRenderEngine();

    resources = new int[5];
    for(int i = 0;i<5;i++)
      resources[i] = resources_[i];
    
    types = types_.copy();
    background = background_;
    c = c_;
    
    images = new PImage[6];
    img = new int[6][SIZE][SIZE];
    int[][] temp_img;
    for(int i = 0;i<6;i++)
    {
      temp_img = new int[SIZE][SIZE];
      for(int j = 0;j<SIZE;j++)
        for(int k = 0;k<SIZE;k++)
          temp_img[j][k] = img_[i][j][k];
      
      img[i] = temp_img;

      images[i] = images_[i].copy();
    }
    
    group = group_;
  }

  //implementing a Element
  Part(int id,int c_,final Set<String> types_)
  {
    RenderEngine renderEngine = GAME.getRenderEngine();

    img = new int[6][8][8];
    resources = new int[5];
    images = new PImage[6];
    int[][] c_arr = new int[SIZE][SIZE];

    for(int k = 0;k<6;k++)
    {
      for(int i=0;i<SIZE;i++)
        for(int j=0;j<SIZE;j++)
        {
          img[k][i][j] = id;
          if(k == 0)
            c_arr[i][j] = c_;
        }
      
      images[k] = renderEngine.createImg(c_arr);
      
      if(k<5)
      {
        if(k==id)
          resources[k] = SIZE*SIZE;
        else
          resources[k] = 0;
      }
    }

    c = c_;
    types = types_;
    background = 0;
    group = "elements";
  }

  public Part copy(){return new Part(img,resources,background,c,types,group,images);}

  public boolean is(String type)
  {
    return types.contains(type);
  }

  public String[] getTypes()
  {
    ArrayList<String> list = types.toArrayList();
    String[] out = list.toArray(new String[0]);
    return out;
  }
  
  public int[][] getFrame(int i)
  {
    return img[i];
  }

  public void drawFrame(int x, int y, int frame)
  {
    drawPart(x,y,images[frame],img[frame],c,group);
  }

  public void drawGrid(int x, int y, int frame)
  {
    drawPartGrid(x,y,frame,img[0],group);
  }

  public int getColor(){return c;}
  public int[] getResources(){return resources;}
  public String getGroupName(){return group;}
  public PImage getImage(int i){return images[i];}
}
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
    if(dir>=TWO_PI*(7.f/8.f) || dir<TWO_PI*(1.f/8.f))
    {
      return new PVector(0,-1);
    }
    else if(dir>=TWO_PI*(1.f/8.f) && dir<TWO_PI*(3.f/8.f))
    {
      return new PVector(-1,0);
    }
    else if(dir>=TWO_PI*(3.f/8.f) && dir<TWO_PI*(5.f/8.f))
    {
      return new PVector(0,1);
    } 
    else if(dir>=TWO_PI*(5.f/8.f) && dir<TWO_PI*(7.f/8.f))
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

  public PVector getTempPos(PVector pos)
  {
    PVector out = new PVector();
    out.x = temp_x - pos_x*zoom + pos.x*size*zoom;
    out.y = temp_y - pos_y*zoom + pos.y*size*zoom;
    return out;
  }

  public void setPos(int x, int y)
  {
    PVector pos = calcPos(x,y); 
    pos_x = floor(pos.x);
    pos_y = floor(pos.y);
  }

  public PVector calcPos(int x, int y)
  {
    PVector out = new PVector();
    float temp_size = size*SIZE;
    out.x = floor(x*temp_size+temp_size/2);
    out.y = floor(y*temp_size+temp_size/2);
    return out;
  }

  public void setRot(float rot)
  {
    rotation = rot;
    if(rotation >= TWO_PI)
      rotation-=TWO_PI;
    else if(rot<0)
      rotation+=TWO_PI;
  }

  public void rotateScene(boolean reverse)
  {
    translate(width/2, height/2);
    if(reverse)
      rotate(-rotation);
    else
      rotate(rotation);
    translate(-width/2, -height/2);
  }

  public float getRot()
  {
    return rotation;
  }

  public float getZoom()
  {
    return zoom;
  }

  public void setZoom(float zoom_)
  {
    zoom = zoom_;
  }

  public int getSize()
  {
    return size;
  }

  public int getPosX()
  {
    return pos_x;
  }

  public int getPosY()
  {
    return pos_y;
  }

  public void setAbsPos(int x, int y)
  {
    pos_x = x;
    pos_y = y;
  }
}
public void drawPart(int x, int y, PImage image, int[][] img, int c, String group)
{
  RenderEngine renderEngine = GAME.getRenderEngine();
  if(renderEngine.getCamera().getZoom()==1)
  {
    renderEngine.drawImg(image,x*8,y*8);
  }
  else
    renderEngine.drawPart(img,x*SIZE,y*SIZE,c,group);
}
public void drawPartGrid(int x, int y, int frame, int[][] blocks, String group)
{
  ObjectManager objectManager = GAME.getObjectManager();

  Part[] Tiles = objectManager.getGroup(group);

  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
      Tiles[blocks[i][j]].drawFrame(x*8+i,y*8+j,frame);
}

/*public void drawFrame(int x, int y, int frame)
  {
    ObjectManager objectManager = GAME.getObjectManager();

    Part[] Tiles = objectManager.getGroup(group);

    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        Tiles[blocks[i][j]].drawFrame(x*8+i,y*8+j,frame);
  }*/
public int[][] randTemplate(int stone, int water, int life, int energy)
{
  int template[][] = new int[8][8];
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
      template[i][j]=0;
    
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
    {
      float rand = random(100);
      int[] elements = {stone,water,life,energy};
      int type = 4;
      for(int k=0;k<4;k++)
      {
        rand -= elements[3-k];
        if(rand<0)
          break;
        type--;
      }
      template[i][j]=type;
    }
  return template;
}
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
  public void addView(String name)
  {
    cameras.put(name,new Camera(max));
  }

  private Camera getCamera()
  {
    return cameras.get(corrent_view);
  }

  public void setView(String name)
  {
    corrent_view = name;
  }

  public void setPos(int x, int y)
  {
    getCamera().setPos(x,y);
  }

  public PVector calcPos(int x, int y)
  {
    return getCamera().calcPos(x, y);
  }

  public void setAbsPos(float x, float y)
  {
    getCamera().setAbsPos(floor(x),floor(y));
  }

  public float getX()
  {
    return getCamera().getPosX();
  }

  public float getY()
  {
    return getCamera().getPosY();
  }

  public float getRot()
  {
    return getCamera().getRot();
  }

  public void setRot(float rot_)
  {
    getCamera().setRot(rot_);
  }

  public float getZoom()
  {
    return getCamera().getZoom();
  }

  public void setZoom(float zoom)
  {
    getCamera().setZoom(zoom);
  }

  public void rotateScene(boolean reverse)
  {
    getCamera().rotateScene(reverse);
  }

  public PImage createImgByIntArray(int[][] template,int c, String group)
  {
    ObjectManager objectManager = GAME.getObjectManager();

    int[][] out = new int[SIZE][SIZE];
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

  public int[] imgToPixels(int[][] a)
  {
    int zoom = getCamera().getSize();
    int[] out = new int[SIZE*zoom*SIZE*zoom];
    for (int i = 0; i < SIZE; i++)
      for (int j = 0; j < SIZE; j++)
        for(int k = 0; k < zoom; k++)
          for(int l = 0; l < zoom; l++)
            out[(j*zoom+l)*SIZE*zoom+i*zoom+k] = a[i][j];
    return out; 
  }

  public int[][] pixelToImg(int[] a)
  {
    int zoom = getCamera().getSize();
    int[][] out = new int[SIZE][SIZE];
    for (int i = 0; i < SIZE; i++)
      for (int j = 0; j < SIZE; j++)
        for(int k = 0; k < zoom; k++)
          for(int l = 0; l < zoom; l++)
            out[i][j] = a[(j*zoom+l)*SIZE*zoom+i*zoom+k];
    return out; 
  }

  public PImage createImg(final int[][] img)
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

  public PVector getTempPos(PVector pos)
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

  public void drawImg(PImage img,int x, int y)
  {


    PVector temp_pos = getTempPos(new PVector(x,y));
    image(img, temp_pos.x, temp_pos.y);
  }

  public void drawPart(int[][] img, int x, int y, int background, String group)
  {
    ObjectManager objectManager = GAME.getObjectManager();
    Part[] parts = objectManager.getGroup(group);

    int c;
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
public Part createChunk(String name)
{
  /*JSONObject json = loadJSONObject("chunk.json");
  JSONObject chunk = json.getJSONObject(name);
  JSONArray arr1 = chunk.getJSONArray("names");
  JSONArray arr2 = chunk.getJSONArray("amounts");
  String[] names = new String[arr1.size()];
  int[] amounts = new int[arr2.size()];

  for(int i=0; i<arr1.size(); i++)
  {
    names[i] = arr1.getString(i);
    amounts[i] = arr2.getInt(i);
  }

  int variance = chunk.getInt("variance");
  String group = chunk.getString("group");
  return createChunkByVariance(amounts,variance,names,group);*/

  ObjectManager objectManager = GAME.getObjectManager();
  JSONObject chunk = loadJSONObject("chunk.json").getJSONObject(name); 

  String ground = chunk.getString("ground");
  JSONArray names_arr = chunk.getJSONArray("names");
  JSONArray amounts_arr = chunk.getJSONArray("amounts");
  String[] names = new String[names_arr.size()];
  int[] amounts = new int[amounts_arr.size()];
  for(int i=0; i<names.length; i++)
  {
    names[i] = names_arr.getString(i);
    amounts[i] = amounts_arr.getInt(i);
  }
  int variance = chunk.getInt("variance");

  String[] group = new String[1+variance*names.length];
  group[0] = ground+"0";
  String[] parts;
  int[] final_amounts = new int[variance*names.length];
  for(int i = 0; i < names.length; i++)
  {
    parts = objectManager.getNamesByGroup(names[i]+"Tiles");
    for(int j = 0; j < variance; j++)
    {
      group[1+i*variance+j] = parts[floor(random(parts.length))];
      final_amounts[i*variance+j] = floor(amounts[i]/variance);
    }
  }
  String group_name = name+"_chunktiles";
  objectManager.registerGroup(group_name,group);

  return createChunkByVariance(final_amounts,1,group,group_name);
}

public Part createChunkByVariance(int[] amount_, int variance, String[] names_, String group_name)
{
  int[] amount = new int[amount_.length*variance];
  String[] names = new String[amount.length];
  for(int i=0; i<amount_.length; i++)
    for(int j=0; j<variance; j++)
    {
      amount[i*variance+j] = floor(amount_[i]/variance);
      names[i*variance+j] = names_[1+i];//names_[i]+j;
    }

  ObjectManager objectManager = GAME.getObjectManager();

  String[] group = objectManager.getNamesByGroup(group_name);
  int[] adresses = new int[names.length];
  int size = 8;

  for(int i=0;i<names.length;i++)
    for(int j=1;j<group.length;j++)
    {
      if(group[j].equals(names[i]))
      {
        adresses[i] = j;
        break;
      }
      if(j == group.length-1)
        throw new RuntimeException("Part not found: "+names[i]+" @createChunkByVariance");
    }
      

  int[][] out = new int[size][size];
  for(int i=0;i<size;i++)
    for(int j=0;j<size;j++)
    {
      float rand = random(100);

      int type = 0;
      for(int k=0;k<amount.length;k++)
      {
        if(rand<amount[k])
        {
          type = adresses[k];
          break;
        }
        rand-=amount[k];
      }
      out[i][j] = type;
    }

  //return new Chunk(out,group_name);
  return evaluateChunk(out,group_name);
}

public int[][] plantTemplate(int stone, int water, int life, int energy)
{
  int[][] out = randTemplate(stone,water,life,energy);
  
  for(int i=0;i<2;i++)
    for(int j=0;j<2;j++)
      out[3+i][3+j]=2;

  for(int i=0;i<4;i++)
  {
    
    out[2][2+i]=3;
    out[2+i][2]=3;
    out[5][2+i]=3;
    out[2+i][5]=3;
  }
  
  return out;
}

public int[][] groundTemplate(int stone, int water, int life, int energy)
{
  int[][] out = randTemplate(stone,water,life,energy);
  return out;
}

public int[][] solidTemplate(int stone, int water, int life, int energy)
{
  int[][] out = randTemplate(stone,water,life,energy);
  
  for(int i=0;i<8;i++)
  {
    out[0][i]=1;
    out[i][0]=1;
    out[7][i]=1;
    out[i][7]=1;
  }
  
  return out;
}
public Part createTile(int[] elements,String template_type)
{
  int[][] template;
  
  switch(template_type)
  {
    case "plant":
      template = plantTemplate(elements[0], elements[1], elements[2], elements[3]);
      break;
    case "solid":
      template = solidTemplate(elements[0], elements[1], elements[2], elements[3]);
      break;
    default:
      template = groundTemplate(elements[0], elements[1], elements[2], elements[3]);
      break;
  }
  return evaluateTile(template);
}
public void gameSetup()
{
  noStroke();
  SIZE = 8;
  int MAP_DETAIL = 4;
  int MAP_SIZE = 4*MAP_DETAIL;
  GAME = new Game();
  GAME.addGameLoop(new GameLoop(60,60,6));
  GAME.addSetupManager(new SetupManager());
  GAME.addInputHandler(new InputHandler());
  GAME.addRenderEngine(new RenderEngine("single",4*MAP_DETAIL));
  RenderEngine renderEngine = GAME.getRenderEngine();
  renderEngine.addView("map");
  GAME.addObjectManager(new ObjectManager());
  GAME.addSimulationManager(new SimulationManager());
  GAME.addGuiManager(new GuiManager());

  GameLoop gameLoop = GAME.gameLoop;
  InputHandler inputHandler = GAME.getInputHandler();
  
  ObjectManager objectManager = GAME.getObjectManager();
  
  


  COUNTER = 0;
  registerObjects();

  TEMPLATE = solidTemplate(0,10,0,0);

  Map map = new Map("chunk");
  int POS_X = MAP_SIZE/2;
  int POS_Y = MAP_SIZE/2;
  float DIR = 0;
  
  GAME.addPlayer(new Player(POS_X,POS_Y));
  Player player = GAME.getPlayer();

  GAME.addSceneManager(new SceneManager("main",map.getMap(),"chunk"));
  SceneManager sceneManager = GAME.getSceneManager();
  //sceneManager.addScene("template",TEMPLATE,"tiles");
  //sceneManager.chanceScene("template");
}
public void registerElements()
{
  ObjectManager objectManager = GAME.getObjectManager();
  
  String[] elements = {"space","base","source","life","energy"};
  for(int i = 0; i<5; i++)
    objectManager.registerPart(elements[i], evaluateElement(i));
  objectManager.registerGroup("elements",elements);
}
public void registerGroups()
{
  ObjectManager objectManager = GAME.getObjectManager();
  SetupManager setupManager = GAME.getSetupManager();

  String[] group;
  group = setupManager.getGroup("plants");
  objectManager.registerGroup("organicTiles",group);

  group = setupManager.getGroup("rock");
  objectManager.registerGroup("rockTiles",group);

  group = setupManager.getGroup("liquid");
  objectManager.registerGroup("liquidTiles",group);

  group = setupManager.getGroup("background");
  objectManager.registerGroup("backgroundTiles",group);

  group = setupManager.getGroup("mechanical");
  objectManager.registerGroup("mechanicalTiles",group);

  /*String[] organic_tiles = 
  {"Bush0","Bush1","Bush2","Bush3"};
  objectManager.registerGroup("organicTiles",organic_tiles);*/

  /*String[] rock_tiles =
  {
    "Stone0","Stone1","Stone2","Stone3","Moss0","Gravel0"
  };
  objectManager.registerGroup("rockTiles",rock_tiles);*/

  /*String[] liquid_tiles =
  {
    "Lake0","Lake1","Lake2","Lake3","Alga0","Alga1"
  };
  objectManager.registerGroup("liquidTiles",liquid_tiles);*/

  String[] ship_tiles = 
  {
    "floor","custom2","Void0","Fuel0"
  };
  objectManager.registerGroup("shipTiles",ship_tiles);
}
public void registerObjects()
{
  registerElements();
  registerTiles();
  registerGroups();
  
  /*register chunks*/
  ObjectManager objectManager = GAME.getObjectManager();

  int variance = 2;

  String[] names = {"Ground","Swamp","Sea","Mountain","Forest"};
  String name;
  String[] group = new String[variance];
  for(int i=0; i<names.length; i++)
  {
    name = names[i]+"Chunk";
    for(int j=0; j<variance; j++)
    {
      objectManager.registerPart(name+j, createChunk(names[i]));
      group[j] = name+j;
    }
    objectManager.registerGroup(name+"s",group);
  }

  String[] chunk = 
  {
    "GroundChunk1","GroundChunk0",
    "SeaChunk1","SwampChunk0",
    "MountainChunk1","MountainChunk0",
    "ForestChunk1","ForestChunk0",
  };
  objectManager.registerGroup("chunk",chunk);

  //ship
  JSONObject json = loadJSONObject("ship.json");
  JSONArray ship_front = json.getJSONArray("front");
  JSONArray ship_back = json.getJSONArray("back");
  int[][] ship_template1 = new int[SIZE][SIZE];
  int[][] ship_template2 = new int[SIZE][SIZE];
  int[][] ship_template3 = new int[SIZE][SIZE];
  int[][] ship_template4 = new int[SIZE][SIZE];
  JSONArray array_front, array_back;
  int num;
  for(int i=0; i<SIZE; i++)
  {
    array_front = ship_front.getJSONArray(i);
    array_back = ship_back.getJSONArray(i);
    for(int j=0; j<SIZE; j++)
    {
      num = array_front.getInt(j);
      ship_template1[j][i] = num;
      ship_template2[SIZE-1-j][i] = num;
      num = array_back.getInt(j);
      ship_template3[j][i] = num;
      ship_template4[SIZE-1-j][i] = num;
    }
  }
    
  Part ship_chunk;
  //ship_chunk = new Chunk(ship_template1,"shipTiles");
  ship_chunk = evaluateChunk(ship_template1,"shipTiles");
  objectManager.registerPart("ship_1", ship_chunk);
  //ship_chunk = new Chunk(ship_template2,"shipTiles");
  ship_chunk = evaluateChunk(ship_template2,"shipTiles");
  objectManager.registerPart("ship_2", ship_chunk);
  //ship_chunk = new Chunk(ship_template3,"shipTiles");
  ship_chunk = evaluateChunk(ship_template3,"shipTiles");
  objectManager.registerPart("ship_3", ship_chunk);
  //ship_chunk = new Chunk(ship_template4,"shipTiles");
  ship_chunk = evaluateChunk(ship_template4,"shipTiles");
  objectManager.registerPart("ship_4", ship_chunk);
  String[] ship = 
  {
    "ship_1","ship_2",
    "ship_3","ship_4"
  };
  objectManager.registerGroup("ship",ship);
}
public void registerTiles()
{
  ObjectManager objectManager = GAME.getObjectManager();
  SetupManager setupManager = GAME.getSetupManager();
  JSONArray tiles = loadJSONArray("tile.json");

  int fails = 0;
  JSONObject tile;
  JSONArray elements_arr;
  JSONArray types_arr;
  String name;
  String template_type;
  int[] elements;
  int[][] template;
  int variance;
  String[] types;
  Part obj;
  String group;

  for(int i = 0; i < tiles.size(); i++)
  {
    tile = tiles.getJSONObject(i);
    elements_arr = tile.getJSONArray("elements");
    types_arr = tile.getJSONArray("types");

    name = tile.getString("name");
    template_type = tile.getString("template_type");
    variance = tile.getInt("variance");
    elements = new int[4];
    for(int j=0; j<4; j++)
      elements[j] = elements_arr.getInt(j);
    types = new String[types_arr.size()];
    for(int j=0; j<types_arr.size(); j++)
      types[j] = types_arr.getString(j);
    group = tile.getString("group");

    for(int j = 0; j < variance; j++)
    {
      obj = createTile(elements,template_type);

      setupManager.addPartToGroup(group,name+j);

      for(int l = 0; l < types.length; l++)
      {
        if(obj.is(types[l]) == false)
        {
          fails++;
          obj = createTile(elements,template_type);
          break;
        }
      }
      objectManager.registerPart(name+j, obj);
    }
  }

  JSONObject json = loadJSONObject("template.json");
  String[] template_names = {"custom1","custom2","floor"};
  JSONArray table,row;
  for(int i=0; i<template_names.length; i++)
  {
    template = new int[SIZE][SIZE];
    table = json.getJSONArray(template_names[i]);
    for(int j=0; j<SIZE; j++)
    {
      row = table.getJSONArray(j);
      for(int k=0; k<SIZE; k++)
        template[k][j] = row.getInt(k);
    }
    objectManager.registerPart(template_names[i],evaluateTile(template));
  }

  println("fails in registerTiles:"+fails);
}
public class BaseSim extends Simulation
{
  BaseSim(final int[][] template,String group)
  {
    super(0);
  }

  public int[][] simOld(final int[][] template,final int[][] temp_template_,String group)
  {
    return simBase(template,temp_template_,group,this);
  }
}
public class EnergySim extends Simulation
{
  EnergySim(final int[][] template,String group)
  {
    super(0);
  }

  public int[][] simOld(final int[][] template,final int[][] temp_template_,String group)
  {
    return simEnergy(template,temp_template_,group,this);
  }
}
public class LifeSim extends Simulation
{
  LifeSim(final int[][] template,String group)
  {
    super(0);
  }

  public int[][] simOld(final int[][] template,final int[][] temp_template_,String group)
  {
    return simLife(template,temp_template_,group,this);
  }
}
public class Simulation
{
  private int[][][] tables;
  private String[] names;
  private int size;
  int[][] dir;
  //public SimulationManager SimulationManager;

  Simulation(int n)
  {
    size = SIZE;
    names = new String[n];
    tables = new int[n][size][size];
    for(int i = 0; i < n; i++)
    {
      for(int j = 0; j < size; j++)
        for(int k = 0; k < size; k++)
          tables[i][j][k] = 0;
    }
    int[][] dir_ = {{-1,0},{0,-1},{1,0},{0,1}};
    dir = dir_;
  }

  //pls delete as fast as possible
  Simulation(final String[] names_)
  {
    size = SIZE;
    int n = names_.length;
    names = new String[n];
    tables = new int[n][size][size];
    for(int i = 0; i < n; i++)
    {
      names[i] = names_[i];

      for(int j = 0; j < size; j++)
        for(int k = 0; k < size; k++)
          tables[i][j][k] = 0;
    }
    int[][] dir_ = {{-1,0},{0,-1},{1,0},{0,1}};
    dir = dir_;
  }

  public void setNames(String[] names_)
  {
    for(int i = 0; i < names.length; i++)
      names[i] = names_[i];
  }

  public Simulation copy()
  {
    Simulation out = new Simulation(names);
    for(int i = 0; i<names.length; i++)
      out.setTable(names[i], tables[i]);
    return out;
  }

  public int getNumfromName(String name)
  {
    for(int i = 0; i < names.length; i++)
      if(names[i].equals(name))
        return i;
    println("BUG in Simulation.getNumfromName:name not found");
    return -1;
  }

  public int[][] getTable(String name)
  {
    int[][] out = new int[size][size];

    int n = getNumfromName(name);

    for(int i = 0; i < n; i++)
      for(int j = 0; j < size; j++)
        out[i][j] = tables[n][i][j];
    
    return out;
  }

  public void setTable(String name, final int[][] table)
  {
    int n = getNumfromName(name);

    for(int i = 0; i < n; i++)
      for(int j = 0; j < size; j++)
        tables[n][i][j] = table[i][j];
  }

  public int getEntry(String name, int x, int y)
  {
    int n = getNumfromName(name);
    return tables[n][x][y];
  }

  public void setEntry(String name, int x, int y,int value)
  {
    int n = getNumfromName(name);
    tables[n][x][y] = value;
  }

  //void
  public int[][] sim(final int[][] template,final int[][] temp_template_,String group)
  {
    return temp_template_;
  }

  public void callEvent(String type, String event, int x, int y, int id)
  {
  }
}
public class SourceSim extends Simulation
{
  SourceSim(final int[][] template,String group)
  {
    super(0);
  }

  public int[][] simOld(final int[][] template,final int[][] temp_template_,String group)
  {
    return simSource(template,temp_template_,group,this);
  }

  /*
  *
  * (1)if entry next to one source or base
  *   move to oposite direction if possible
  *
  * (2)if next to more then one source or base
  *   create source in all directions next to it
  *   delete
  *
  * (3)if touching borders
  *   delete
  *
  */
  public int[][] sim(final int[][] template,final int[][] temp_template_,String group)
  {
    SimulationManager simulationManager = GAME.getSimulationManager();
    ObjectManager objectManager = GAME.getObjectManager();
    int x,y;

    for(int i = 0; i<SIZE; i++)
      for(int j = 0; j<SIZE; j++)
      {
        if(template[i][j]!=2)
          continue;

        //(3)
        if(i==0 || j==0 || i==SIZE-1 || j==SIZE-1)
        {
          simulationManager.deleteEntry("source",i,j);
          continue;
        }
        
        int[] neighbors = new int[4];
        int friends = 0;
        for(int k=0;k<4;k++)
        {
          x = i+dir[k][0];
          y = j+dir[k][1];
          neighbors[k] = template[x][y];
          if(template[x][y] == 2 || template[x][y] == 1)
            friends++;
        }

        if(friends == 0 || friends == 4)
          continue;
        
        //(1)
        if(friends == 1)
        {
          for(int k=0;k<4;k++)
          {
            x = i+dir[k][0];
            y = j+dir[k][1];
            if(template[x][y] != 2 && template[x][y] != 1)
              continue;
            
            x = i+dir[(k+2)%4][0];
            y = j+dir[(k+2)%4][1];
            
            simulationManager.deleteEntry("source",i,j);
            simulationManager.createEntry(2,x,y);
            break;
          }
          continue;
        }

        //(2)
        for(int k=0;k<4;k++)
        {
          x = i+dir[k][0];
          y = j+dir[k][1];
          if(template[x][y] != 0)
            continue;

          simulationManager.deleteEntry("source",i,j);
          simulationManager.createEntry(2,x,y);
          break;
        }
      }
    return temp_template_;
  }
}
public Simulation initBaseSim(final int[][] template,String group)
{
  String[] names = {};
  return new Simulation(names);
}

public int[][] simBase(final int[][] template,final int[][] temp_template_,String group,Simulation sim)
{
  int size = 8;
  int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
  int x,y;

  int[][] temp_template = new int[size][size];
  for(int i=0;i<size;i++)
    for(int j=0;j<size;j++)
    {
      temp_template[i][j]=temp_template_[i][j];

      if(template[i][j] != 1)
        continue;

      temp_template[i][j] = 1;
    }
    
  return temp_template;
}
public Simulation initEnergySim(final int[][] template,String group)
{
  String[] names = {};
  return new Simulation(names);
}

/****************************
*
* (1)if next to Life
*   chance Life to Energy
*
* (2)if exactly one Energy is next to it
*   create Energy on oposit side.
*   if not possible
*     chance to Life
*
* (3)else
*   chance to life
*
****************************/
public int[][] simEnergy(final int[][] template,final int[][] temp_template_,String group,Simulation sim)
{
  int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
  int x,y;

  int[][] temp_template = new int[SIZE][SIZE];
  for(int i=0;i<SIZE;i++)
    for(int j=0;j<SIZE;j++)
      temp_template[i][j]=temp_template_[i][j];
  
  for(int i=0;i<SIZE;i++)
    for(int j=0;j<SIZE;j++)
    {
      if(template[i][j] != 4)
        continue;

      int[] neighbors = new int[4];
      int friends = 0;
      int sources = 0;
      for(int k=0;k<4;k++)
      {
        x = i+dir[k][0];
        y = j+dir[k][1];
        if(x<0 || y<0 || x>=SIZE || y>=SIZE)
        {
          neighbors[k] = 1;
          continue;
        }
        
        neighbors[k] = template[x][y];
        if(template[x][y] == 4)
          friends++;
        
        if(template[x][y] == 3)
          sources++;
      }

      //(2)
      if(friends == 1)
      {
        for(int k=0;k<4;k++)
        {
          if(neighbors[k] != 4)
            continue;
          
          if(neighbors[(k+2)%4] != 0)
          {
            temp_template[i][j]=3;
            break;
          }

          x = i+dir[(k+2)%4][0];
          y = j+dir[(k+2)%4][1];
          if(x<0 || y<0 || x>=SIZE || y>=SIZE)
            break;
          temp_template[x][y]=4;
        }
        //continue;
      }

      //(1)
      if(sources != 0)
      {
        for(int k=0;k<4;k++)
        {
          if(neighbors[k] == 3)
          {
            x = i+dir[k][0];
            y = j+dir[k][1];
            temp_template[x][y]=4;
          }
        }
        continue;
      }
      
      //(3)
      temp_template[i][j]=3;
    }

  return temp_template;
}
public Simulation initLifeSim(final int[][] template,String group)
{
  String[] names = {};
  return new Simulation(names);
}

/*
*
* (1) if source next to it
*   chance source to life
* 
* (2) if no source next to it
*   chance to source
*
*/
public int[][] simLife(final int[][] template,final int[][] temp_template_,String group,Simulation sim)
{
  int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
  int x,y;

  int[][] temp_template = new int[SIZE][SIZE];
  for(int i=0;i<SIZE;i++)
    for(int j=0;j<SIZE;j++)
      temp_template[i][j]=temp_template_[i][j];
  
  for(int i=0;i<SIZE;i++)
    for(int j=0;j<SIZE;j++)
    {
      if(template[i][j] != 3)
        continue;

      int friends = 0;
      for(int k=0;k<4;k++)
      {
        x = i+dir[k][0];
        y = j+dir[k][1];
        if(x<0 || y<0 || x>=SIZE || y>=SIZE)
          continue;
        
        if(template[x][y] != 2)
          continue;
        
        friends++;
        //simulationManager.deleteEntry("source",x,y);
        if(temp_template[x][y]==2)
          temp_template[x][y]=0;
        //simulationManager.createEntry(3,x,y);
        if(temp_template[x][y]==0)
          temp_template[x][y]=3;
        //break;
      }

      //(2)
      if(friends == 0)
      {
        //simulationManager.deleteEntry("life",i,j);
        if(temp_template[i][j]==3)
          temp_template[i][j]=0;
        //simulationManager.createEntry(2,i,j);
        if(temp_template[i][j]==0)
          temp_template[i][j]=2;
      }

      /*if(coord[0]>0 && coord[1]>0)
      {
        temp_template[coord[0]][coord[1]]=3;
        if(temp_template[i][j]!=4)
          temp_template[i][j]=3;
      }
      else if(temp_template[i][j]!=4)
        temp_template[i][j]=2;*/
    }

  return temp_template;
}
public Simulation initSourceSim(final int[][] template,String group)
{
  String[] names = {};
  return new Simulation(names);
}

public int[][] simSource(final int[][] template,final int[][] temp_template_,String group,Simulation sim)
{
  int[][] temp_template = new int[8][8];
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
      temp_template[i][j]=temp_template_[i][j];

  int x,y;
  int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};

  for(int i = 0; i<SIZE; i++)
    for(int j = 0; j<SIZE; j++)
    {
      if(template[i][j]!=2)
        continue;

      //(3)
      if(i==0 || j==0 || i==SIZE-1 || j==SIZE-1)
      {
        //simulationManager.deleteEntry("source",i,j);
        if(temp_template[i][j]==2)
          temp_template[i][j]=0;
        continue;
      }
      
      int[] neighbors = new int[4];
      int friends = 0;
      for(int k=0;k<4;k++)
      {
        x = i+dir[k][0];
        y = j+dir[k][1];
        neighbors[k] = template[x][y];
        if(template[x][y] == 2 || template[x][y] == 1)
          friends++;
      }

      if(friends == 0 || friends == 4)
        continue;
      
      //(1)
      if(friends == 1)
      {
        for(int k=0;k<4;k++)
        {
          x = i+dir[k][0];
          y = j+dir[k][1];
          if(template[x][y] != 2 && template[x][y] != 1)
            continue;
          
          x = i+dir[(k+2)%4][0];
          y = j+dir[(k+2)%4][1];
          
          //simulationManager.deleteEntry("source",i,j);
          if(temp_template[i][j]==2)
            temp_template[i][j]=0;
          //simulationManager.createEntry(2,x,y);
          if(temp_template[x][y]==0)
            temp_template[x][y]=2;
          //break;
        }
        continue;
      }

      //(2)
      for(int k=0;k<4;k++)
      {
        x = i+dir[k][0];
        y = j+dir[k][1];
        if(template[x][y] != 0)
          continue;

        //simulationManager.deleteEntry("source",i,j);
        if(temp_template[i][j]==2)
            temp_template[i][j]=0;
        //simulationManager.createEntry(2,x,y);
        if(temp_template[x][y]==0)
            temp_template[x][y]=2;
        //break;
      }
    }
  return temp_template;

  /*int size = 8;
  int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
  int x,y;

  int[][] temp_template = new int[8][8];
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
      temp_template[i][j]=temp_template_[i][j];

  for(int i=0;i<size;i++)
    for(int j=0;j<size;j++)
    {
      if(temp_template[i][j]!=2)
        continue;

      int coord[] = {i,j};
      
      temp_template[i][j]=0;

      if(i==0 || j==0 || i==7 || j==7)
        continue;
        
      int[] neighbors = new int[4];
      for(int k=0;k<4;k++)
      {
        x = i+dir[k][0];
        y = j+dir[k][1];
        neighbors[k] = template[x][y];
      }
      
      boolean found = false;

      for(int k=0;k<4;k++)
        if((neighbors[k]==1) && (neighbors[(k+1)%4]==2) && neighbors[(k+2)%4]==2 && (neighbors[(k+3)%4]==2))
        {
          for(int l=0;l<2;l++)
            coord[l] += dir[k][l];
          found = true;
          break;
        }
      
      if(found == false)
        for(int k=0;k<4;k++)
          if((neighbors[(k+2)%4]==2 || neighbors[(k+2)%4]==1) && neighbors[k]==0)
          {
            for(int l=0;l<2;l++)
              coord[l] += dir[k][l];
            break;
          }

      if(coord[0]>0 && coord[1]>0 && temp_template[coord[0]][coord[1]]==0)
        temp_template[coord[0]][coord[1]]=2;
    }
  return temp_template;*/
}
//test
public class Scene
{
  private int[][] map;
  private Part[] tiles;
  String group_name;

  Scene(int[][] map_,String tiles)
  {
    map = new int[map_.length][map_[0].length];
    for(int i = 0; i < map_.length; i++)
      for(int j = 0; j < map_[0].length; j++)
        map[i][j] = map_[i][j];
    
    group_name = tiles;
  }

  public void setMap(int[][] map_)
  {
    for(int i = 0; i < map.length; i++)
      for(int j = 0; j < map[0].length; j++)
        map[i][j] = map_[i][j];
  }

  public int[][] getMap()
  {
    int[][] out = new int[map.length][map[0].length];
    for(int i = 0; i < map.length; i++)
      for(int j = 0; j < map[0].length; j++)
        out[i][j] = map[i][j];
    return out;
  }

  public String getCorrentPartName()
  {
    ObjectManager objectManager = GAME.getObjectManager();
    Player player = GAME.getPlayer();
    
    String[] parts = objectManager.getNamesByGroup(group_name);
    PVector pos = player.getPos();
    int x = floor(pos.x/SIZE);
    int y = floor(pos.y/SIZE);

    return parts[map[x][y]];
  }  

  public int[][] getMapArea(int x, int y, int w, int h)
  {
    int[][] out = new int[map.length][map[0].length];
    for(int i = 0; i < map.length; i++)
      for(int j = 0; j < map[0].length; j++)
        out[i][j] = map[i][j];
    return out;
  }

  public void renderArea()
  {
    RenderEngine renderEngine = GAME.getRenderEngine();
    ObjectManager objectManager = GAME.getObjectManager();
    GameLoop gameLoop = GAME.getGameLoop();
    Player player = GAME.getPlayer();
    PVector pos = player.getPos();
    int x = floor(pos.x/SIZE);
    int y = floor(pos.y/SIZE);
    
    renderEngine.rotateScene(false);

    Part[] tiles = objectManager.getGroup(group_name);
    Part[] ship = objectManager.getGroup("ship");

    for(int i=0;i<5;i++)
      for(int j=0;j<5;j++)
      {
        int x2 = x+i-2;
        int y2 = y+j-2;
        if(x2==3 && y2 == -2)
        	ship[0].drawGrid(x2,y2,gameLoop.getFrame());
        if(x2==3 && y2 == -1)
          ship[2].drawGrid(x2,y2,gameLoop.getFrame());
        if(x2==4 && y2 == -2)
          ship[1].drawGrid(x2,y2,gameLoop.getFrame());
        if(x2==4 && y2 == -1)
          ship[3].drawGrid(x2,y2,gameLoop.getFrame());

        if(x2<0 || y2<0 || x2>=SIZE || y2>=SIZE)
          continue;

        tiles[map[x2][y2]].drawGrid(x2,y2,gameLoop.getFrame());
      }
    
    renderEngine.rotateScene(true);
  }
}
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

public class Set<E>
{
  private ArrayList<E> list;

  Set()
  {
    list = new ArrayList<E>();
  }

  public boolean add(E e)
  {
    if(list.contains(e))
      return false;

    list.add(e);
    return true;
  }

  public void clear()
  {
    list.clear();
  }

  public Set<E> copy()
  {
    Set<E> out = new Set<E>();
    int size = list.size();
    for(int i = 0; i < size; i++)
      out.add(list.get(i));
    return out;
  }

  public boolean contains(E e)
  {
    return list.contains(e);
  }

  public boolean isEmpty()
  {
    return list.size()==0;
  }

  public boolean remove(E e)
  {
    return list.remove(e);
  }

  public int size()
  {
    return list.size();
  }

  public ArrayList<E> toArrayList()
  {
    ArrayList<E> out = new ArrayList<E>(list);
    return out;
  }
}
public class SetupManager
{;
  HashMap<String,ArrayList<String>> groups;

  SetupManager()
  {
    groups = new HashMap<String,ArrayList<String>>();
    groups.put("background",new ArrayList<String>());
    groups.put("plants",new ArrayList<String>());
    groups.put("mechanical",new ArrayList<String>());
    groups.put("rock",new ArrayList<String>());
    groups.put("liquid",new ArrayList<String>());
  }

  public void addPartToGroup(String name,String part)
  {
    ArrayList<String> group = groups.get(name);
    group.add(part);
  }

  public String[] getGroup(String name)
  {
    ArrayList<String> group = groups.get(name);
    String[] out = group.toArray(new String[0]);
    return out;
  }
}
public class SimulationManager
{
  private HashMap<String,Simulation> sims;
  private int[][] template_buffer;
  private String group;
  private Table listeners;
  private Table actions;

  SimulationManager()
  {
    sims = new HashMap<String,Simulation>();
    template_buffer = new int[SIZE][SIZE];
    group = "";

    actions = new Table();
    actions.addColumn("id",Table.INT);
    actions.addColumn("x", Table.INT);
    actions.addColumn("y", Table.INT);
    actions.addColumn("action", Table.STRING);
    actions.addColumn("type", Table.STRING);

    listeners = new Table();
    listeners.addColumn("target",Table.STRING);
    listeners.addColumn("sim",Table.STRING);
  }

  public void newSession(String name)
  {
    sims.clear();
    template_buffer = new int[SIZE][SIZE];
    group = name;
  }

  public void listenTo(String target,String sim)
  {
    TableRow newRow = listeners.addRow();
    newRow.setString("target", target);
    newRow.setString("sim", sim);
  }

  public void add(String name, final Simulation sim)
  {
    sims.put(name,sim);
  }

  public void createEntry(int i, int x, int y)
  {
    TableRow newRow = actions.addRow();
    newRow.setInt("id", i);
    newRow.setInt("x", x);
    newRow.setInt("y", y);
    newRow.setString("action", "create");
    newRow.setString("type", "");
  }

  public void deleteEntry(String type,int x, int y)
  {
    TableRow newRow = actions.addRow();
    newRow.setInt("id", 0);
    newRow.setInt("x", x);
    newRow.setInt("y", y);
    newRow.setString("action", "delete");
    newRow.setString("type", type);
  }

  public void tellListeners(String type, String event, int x, int y, int id)
  {
    for (TableRow row : listeners.findRows(type,"target")) {
      sims.get(row.getString("sim")).callEvent(type,event,x,y,id);
    }
  }

  public int[][] init(final int[][] template_)
  {
    ObjectManager objectManager = GAME.getObjectManager();
    Part[] tiles = objectManager.getGroup(group);

    int size = SIZE;
    ArrayList<Simulation> simList = new ArrayList<Simulation>(sims.values());

    int[][] template = new int[size][size];
    for(int i = 0;i<size;i++)
      for(int j = 0;j<size;j++)
      {
        template_buffer[i][j] = template_[i][j];
        template[i][j] = template_[i][j];
      }
    
    for(int iter = 0; iter<16; iter++)    
    {
      //set actions
      for(int i=0; i<simList.size(); i++)
        simList.get(i).sim(template,template_buffer,group);

      //process actions
      int max = actions.getRowCount();
      for(int i = 0; i<max; i++)
      {
        TableRow row = actions.getRow(i);
        int x = row.getInt("x");
        int y = row.getInt("y");
        int id = row.getInt("id");
        String type = row.getString("type");
        switch(row.getString("action"))
        {
          case "create":
            if(template_buffer[x][y] == 0)
            {
              template_buffer[x][y] = id;

              String[] types = tiles[template_buffer[x][y]].getTypes();
              for(int j=0; j< types.length; j++)
                tellListeners(types[j],"create",x,y,id);
            }
            break;

          case "delete":
            if(tiles[template_buffer[x][y]].is(type))
            {
              template_buffer[x][y] = 0;
              tellListeners(type,"delete",x,y,0);
            }
            break;
        }
      }

      actions.clearRows();

      for(int i = 0; i<size; i++)
        for(int j = 0; j<size; j++)
          template[i][j] = template_buffer[i][j];
    }
    
    return template;
  }

  public String getGroup()
  {
    return group;
  }
}
public int[][] iterateTile(final int[][] template, final int[][] temp_template_)
{
  int[][] temp_template = new int[8][8];
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
      temp_template[i][j]=template[i][j];

  String group = "elements";
  Simulation lifeSim = initLifeSim(template,group);
  Simulation sourceSim = initSourceSim(template,group);
  Simulation baseSim = initBaseSim(template,group);
  Simulation energySim = initEnergySim(template,group);
  
  temp_template = simEnergy(template,temp_template,group,energySim);
  temp_template = simLife(template,temp_template,group,lifeSim);
  temp_template = simSource(template,temp_template,group,sourceSim);
  temp_template = simBase(template,temp_template,group,baseSim);
     
  return temp_template;
}
public class Template
{
  private int[][] map;

  Template(int[][] map_)
  {
    map = new int[map_.length][map_[0].length];
    for(int i = 0; i < map_.length; i++)
      for(int j = 0; j < map_[0].length; j++)
        map[i][j] = map_[i][j];
  }

  public int[][] iterate()
  {
    int[][] temp_template = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        temp_template[i][j]=0;
    return iterateTile(map,temp_template);
  }

  public int[][] print()
  {
    int[][] out = new int[map.length][map[0].length];
    for(int i = 0; i < map.length; i++)
      for(int j = 0; j < map[0].length; j++)
        out[i][j] = map[i][j];
    return out;
  }
}
/*public class Tile implements Part
{
  private int[][][] img;
  private PImage[] images;
  private int[] resources;
  private int background;
  private color c;
  private Set<String> types;

  Tile(int[][][] img_, int[] resources_, int background_, color c_, Set<String> types_)
  {
    RenderEngine renderEngine = GAME.getRenderEngine();

    resources = new int[5];
    for(int i = 0;i<5;i++)
      resources[i] = resources_[i];
    
    types = types_.copy();
    background = background_;
    c = c_;
    
    images = new PImage[6];
    img = new int[6][SIZE][SIZE];
    int[][] temp_img;
    for(int i = 0;i<6;i++)
    {
      temp_img = new int[SIZE][SIZE];
      for(int j = 0;j<SIZE;j++)
        for(int k = 0;k<SIZE;k++)
          temp_img[j][k] = img_[i][j][k];
      
      img[i] = temp_img;

      images[i] = renderEngine.createImgByIntArray(temp_img,c,"elements");
    }
    
  }

  public Tile copy(){return new Tile(img,resources,background,c,types);}

  public boolean is(String type)
  {
    return types.contains(type);
  }

  public String[] getTypes()
  {
    ArrayList<String> list = types.toArrayList();
    String[] out = list.toArray(new String[0]);
    return out;
  }
  
  public int[][] getFrame(int i)
  {
    return img[i];
  }

  public void drawFrame(int x, int y, int frame)
  {
    drawPart(x,y,images[frame],img[frame],c,"elements");
  }

  public color getColor(){return c;}
  public int[] getResources(){return resources;}
  public String getGroupName(){return "elements";}
}*/
public void draw()
{
  try
  {
    InputHandler inputHandler = GAME.getInputHandler();
    GameLoop gameLoop = GAME.getGameLoop();
    RenderEngine renderEngine = GAME.getRenderEngine();
    Player player = GAME.getPlayer();
    SceneManager sceneManager = GAME.getSceneManager();

    inputHandler.checkInputs();

    if(gameLoop.tick())
    {

      COUNTER++;

      //disabling the template Scene
      if(COUNTER <16)
        COUNTER = 16;
      
      if(COUNTER == 16)
      {
        renderEngine.setView("map");
        PVector pos = player.getPos();
        renderEngine.setPos(PApplet.parseInt(pos.x), PApplet.parseInt(pos.y));
        sceneManager.chanceScene("main");
      }

      if(COUNTER <16)
      {
        int[][] map_empty = new int[8][8];
        for(int i=0;i<8;i++)
          for(int j=0;j<8;j++)
            map_empty[i][j]=0;
        
        int[][] map = sceneManager.getMap();
        sceneManager.setMap(iterateTile(map,map_empty));
      }
        
    }

    background(0);

    if(COUNTER <16)
    {
      //Needs a system to display the iterations like drawTemplate
      //drawBlock(0,0,TEMPLATE,0);
      //still not working!!!
      //templateScene.render();
    }
    else
    {
      //draw the area around the player
      renderEngine.render();
    }    
  }
  catch (Exception e)
  {
    println("ERROR:"+e.getMessage());
    exit();
  }
}
public Part evaluateChunk(final int[][] template_,String group_)
{
  SimulationManager simulationManager = GAME.getSimulationManager();

  simulationManager.newSession(group_);
  simulationManager.add("Organic",new OrganicSim(template_,group_));
  simulationManager.listenTo("water","Organic");
  simulationManager.listenTo("organic","Organic");
  /*
  simulationManager.add("OrganicSpawn",new OrganicSpawnSim(template_,group_));
  simulationManager.listenTo("water","OrganicSpawn");
  simulationManager.listenTo("organic_spawn","OrganicSpawn");
  */
  
  int[][] blocks = simulationManager.init(template_);

  int[] resources = new int[16];
  for(int i = 0;i<16;i++)
    resources[i] = 0;

  for(int j = 0;j<SIZE;j++)
    for(int k = 0;k<SIZE;k++)
      resources[blocks[j][k]]++;

  String group = group_;
  int background = 0;
  int c = color(0);
  Set<String> types = new Set<String>();

  int[][][] img = {blocks,blocks,blocks,blocks,blocks,blocks};

  return new Part(img,resources,background,c,types,group);
  //return new Chunk(blocks,group,background,c,resources);
}
public Part evaluateElement(int id)
{
  String[] names = {"space",    "base",         "source",       "life",       "energy"};
  int[] colors = {color(0,0,0),color(40,40,40),color(0,0,255),color(0,80,0),color(255,20,20)};
  int c = colors[id];
  Set<String> types = new Set<String>();
  types.add(names[id]);

  return new Part(id,c,types);

  /*int[][][] img = new int[6][8][8];
  int[] resources = new int[5];

  for(int k = 0;k<6;k++)
  {
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        img[k][i][j] = id;
    
    if(k<5)
    {
      if(k==id)
        resources[k] = SIZE*SIZE;
      else
        resources[k] = 0;
    }
  }

  int background = 0;
  String group = "elements";
  return new Part(img,resources,background,c,types,group);*/
}
public Part evaluateTile(int[][] template)
{
  Set<String> types = new Set<String>();

  //Iterate for 16 Ticks
  int[][] temp_template = new int[8][8];
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
      temp_template[i][j]=template[i][j];
  
  int[][] map_empty = new int[8][8];
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
      map_empty[i][j]=0;
  
  /* OLD */
  for(int k = 0;k<16;k++)
    temp_template = iterateTile(temp_template,map_empty);
  /**/

  /* NEW */
  /*SimulationManager simulationManager = GAME.getSimulationManager();
  String group = "elements";

  simulationManager.newSession(group);
  //simulationManager.add("Energy",new EnergySim(template,group));
  //simulationManager.add("Life",new LifeSim(template,group));
  simulationManager.add("Source",new SourceSim(template,group));

  temp_template = simulationManager.init(template);*/
  /**/
  
  int[][][] img = new int[6][8][8];
  int[] resources = new int[5];
  for(int i = 0;i<5;i++)
    resources[i]=0;
    
  for(int k = 0;k<6;k++)
  {
    temp_template = iterateTile(temp_template,map_empty);
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
      {
        img[k][i][j] = temp_template[i][j];
        if(k==5)
          resources[temp_template[i][j]]++;
      }
  }

  //create simple Background
  // 1 stone = 4 void
  // 1 source = 3 stone = 12 void
  // 1 life = 2.66 source = 5 stone = 20 void

  int[] mult = {1,4,12,20,40};
  int background = 0;
  for(int i=1;i<5;i++)
    if(mult[i]*resources[i]>mult[background]*resources[background])
      background = i;
  
  if(background == 0 && resources[2] != 0)
  {
    background = 2;
  }

  int c;

  //switch
  switch(background)
  {
    //moving
    case 4:
      types.add("moving");
      c = color(255,80,61);
      break; 

    //organic
    case 3:
      if(resources[1]>0) //cell
      {
        types.add("solid");
        types.add("organic");
        c = color(127,178,127);
      }
      else //organic
      {
        types.add("organic");
        c = color(0,128,0);
      }
      break;

    //water
    case 2:
      //does life exist?
      if(resources[3]>0) //OrganicSpawn
      {
        types.add("organic_spawn");
        types.add("water");
        c = color(53,80,128);
      }
      else //water
      {
        types.add("water");
        c = color(80,80,256);
      }
      break;

    //stone
    case 1:
      
      if(resources[1]>28)
      {
        types.add("solid");
        c = color(90,90,90);
      }
      else
      {
        c = color(127,127,127);
      }
      break;

    //ground
    default:
      if(resources[0]==SIZE*SIZE)
        c = color(0,0,0);
      else
        c = color(80,255,80);
  }
  String group = "elements";
  return new Part(img,resources,background,c,types,group);
}
  public void settings() {  size(1024,768,P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "WorldSim" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
