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
Game Game;

public void setup() {
  
  int MAP_DETAIL = 4;
  int MAP_SIZE = 4*MAP_DETAIL;
  Game = new Game();
  Game.addGameLoop(new GameLoop(60,60,6));
  Game.addInputHandler(new InputHandler());
  Game.addRenderEngine(new RenderEngine("single",1));
  Game.addObjectManager(new ObjectManager());

  GameLoop GameLoop = Game.GameLoop;
  InputHandler InputHandler = Game.InputHandler;
  RenderEngine RenderEngine = Game.RenderEngine;
  ObjectManager ObjectManager = Game.ObjectManager;
  
  
  RenderEngine.addView("map",4*MAP_DETAIL);

  COUNTER = 0;
  registerObjects();

  Tile[] b = new Tile[6];
  b[0] = createGround();
  b[1] = createLake();
  b[2] = createStone();
  b[3] = createAlga();
  b[4] = createMoss();
  b[5] = createBush();
  TEMPLATE = solidTemplate(0,10,0);

  Map map = new Map("chunk");
  int POS_X = MAP_SIZE/2;
  int POS_Y = MAP_SIZE/2;
  float DIR = 0;
  
  Game.addPlayer(new Player(POS_X,POS_Y));
  Player Player = Game.Player;

  Game.addSceneManager(new SceneManager("main",map.getMap(),"chunk"));
  SceneManager SceneManager = Game.SceneManager;
  SceneManager.addScene("template",TEMPLATE,"tiles");
  SceneManager.chanceScene("template");
}

public void keyReleased()
{
  char k[] = {key};
  String out = new String(k);
  Game.InputHandler.dropInput(out);
}

public void keyPressed()
{
  char k[] = {key};
  String out = new String(k);
  Game.InputHandler.registerInput(out);
}
public Simulation initOrganicSim(final int[][] template,String group)
{
  String[] names = {"organics","water","water_buffer"};
  Simulation sim = new Simulation(names);

  Part[] Tiles = Game.ObjectManager.getGroup(group);
  int size = template[0].length;

  //int[][] organics = new int[size][size];
  //creating Organic table
  for(int i = 0; i<size; i++)
    for(int j = 0; j<size; j++)
    {
      if(Tiles[template[i][j]].is("organic"))
      {
        //we assume that the groupname is element
        if(Tiles[template[i][j]].getGroupName().equals("elements")==false)
        {
          println("BUG in simOrganic:groupname not elements");
          return sim;
        }
        //organics[i][j] = Tiles[template[i][j]].getResources()[3];
        sim.setEntry("organics",i,j,Tiles[template[i][j]].getResources()[3]);
      }
      else
        sim.setEntry("organics",i,j,0);
    }
      
  
  //int[][] water = new int[size][size];
  //int[][] water_buffer = new int[size][size];
  //creating water table and water_buffer
  for(int i = 0; i<size; i++)
    for(int j = 0; j<size; j++)
      if(Tiles[template[i][j]].is("water"))
      {
        sim.setEntry("water",i,j, 100);
        sim.setEntry("water_buffer",i,j,100);
      }

  return sim;
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
*         i.)water.foodEntry += waterEntry.value [max at foodEntry.value]
*     C.)for each water_bufferEntry
*       a.)set waterEntry = 0
*       b.)set foodEntry = 0
*     D.)for each food
*       a.)if foodEntry = 1 delete
*       b.)WaterEntry-=1
*   5.)for each waterEntry
*     A.) delete
*/
public int[][] simOrganic(final int[][] template,final int[][] temp_template_,String group,Simulation sim)
{
  int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
  int x,y;
  int size = template[0].length;
  Part[] Tiles = Game.ObjectManager.getGroup(group);

  int[][] temp_template = new int[size][size];
  for(int i = 0; i<size; i++)
    for(int j = 0; j<size; j++)
      temp_template[i][j] = temp_template_[i][j];

  /*Part[] Tiles = Game.ObjectManager.getGroup(group);
  int size = template[0].length;

  int[][] temp_template = new int[size][size];

  //int[][] organics = new int[size][size];
  for(int i = 0; i<size; i++)
    for(int j = 0; j<size; j++)
    {
      temp_template[i][j] = temp_template_[i][j];


      if(Tiles[template[i][j]].is("organic"))
      {
        //we assume that the groupname is element
        if(Tiles[template[i][j]].getGroupName().equals("elements")==false)
        {
          println("BUG in simOrganic:groupname not elements");
          return temp_template;
        }
        //organics[i][j] = Tiles[template[i][j]].getResources()[3];
        sim.setEntry(1,i,j) = Tiles[template[i][j]].getResources()[3];
      }
      else
        organics[i][j] = 0;
    }
      

  int[][] water = new int[size][size];
  int[][] water_buffer = new int[size][size];
  for(int i = 0; i<size; i++)
    for(int j = 0; j<size; j++)
      if(Tiles[template[i][j]].is("water"))
      {
        water[i][j] = 100;
        water_buffer[i][j] = 100;
      }*/
  
  for(int iter = 0; iter < 16; iter++)
  {
    //int[][] organics = sim.getTable("organics");
    //int[][] water = sim.getTable("water");
    //int[][] water_buffer = sim.getTable("water_buffer");

    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
        //water_buffer[i][j] = water[i][j];
        sim.setEntry("water_buffer",i,j,sim.getEntry("water",i,j));
    
    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
      {
        //if(water[i][j]<=0)
        if(sim.getEntry("water",i,j)<=0)
          continue;
        
        for(int k = 0; k<4; k++)
        {
          x = i+dir[k][0];
          y = j+dir[k][1];
          if(x<0 || y<0 || x>=size || y>=size)
            continue;
          //if(organics[x][y]==0)
          if(sim.getEntry("organics",x,y)==0)
            continue;
          
         // water[x][y]+=water[i][j];
          sim.setEntry("water",x,y,sim.getEntry("water",i,j));
          //if(water[x][y]>organics[x][y])
          if(sim.getEntry("water",x,y)>sim.getEntry("organics",x,y))
            //water[x][y]=organics[x][y];
            sim.setEntry("water",x,y,sim.getEntry("organics",x,y));
        }
      }
    
    for(int i = 0; i<size; i++)
      for(int j = 0; j<size; j++)
      {
        //if(water_buffer[i][j]>0)
        if(sim.getEntry("water_buffer",i,j)>0)
        {
          //water[i][j] = 0;
          sim.setEntry("water",i,j,0);
          //organics[i][j] = 0;
          sim.setEntry("organics",i,j,0);
        }

        if(sim.getEntry("organics",i,j)==0)
        //if(organics[i][j] == 0)
          continue;

        //if(organics[i][j] == 1)
        if(sim.getEntry("organics",i,j)==1)
        {
          //Delete
          if(Tiles[temp_template[i][j]].is("organic"))
            temp_template[i][j] = 0;
        }

        //organics[i][j]--;
        sim.setEntry("organics",i,j,sim.getEntry("organics",i,j)-1);
      }
  }

  return temp_template;
}
public class Chunk implements Part
{
  private int[][] blocks;
  private int[] resources;
  private String group;
  private int background;
  private int c;
  private int x;
  private int y;
  private String name;

  Chunk(String name_, int[][] blocks_,String group_,int background_, int x_, int y_, int c_, int[] resources_)
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

    name = name_;
    group = group_;
    background = background_;
    x = x_;
    y = y_;
  }

  Chunk(int c_)
  {
    blocks = new int[8][8];
    for(int j = 0;j<8;j++)
      for(int k = 0;k<8;k++)
        blocks[j][k] = 0;
    
    group = "null";
    background = 0;
    resources = new int[0];
    c = c_;
    x = 0;
    y = 0;
  }

  Chunk(String name_, int[][] template,String group_)
  { 
    resources = new int[8];
    for(int i = 0;i<8;i++)
    {
      resources[i] = 0;
    }

    blocks = new int[8][8];
    for(int j = 0;j<8;j++)
      for(int k = 0;k<8;k++)
        blocks[j][k] = template[j][k];

    Simulation organicSim = initOrganicSim(template,group_);
    blocks = simOrganic(template,blocks,group_,organicSim);
    for(int j = 0;j<8;j++)
      for(int k = 0;k<8;k++)
      {
        //blocks[j][k] = template[j][k];
        resources[template[j][k]]++;
      }
    
    name = name_;
    group = group_;
    background = 0;
    c = color(0);
    x = 0;
    y = 0;
  }

  public Chunk copy()
  {
    /*int[][] b = new int[8][8];
    for(int j = 0;j<8;j++)
      for(int k = 0;k<8;k++)
      {
        b[j][k] = blocks[j][k];
      }*/
    return new Chunk(name,blocks,group,background,x,y,c,resources);
  }

  public int getX(){return x;}

  public int getY(){return y;}

  public String getName(){return name;}

  public Part createInstance(int x, int y)
  {
    /*int[][] b = new int[8][8];
    for(int j = 0;j<8;j++)
      for(int k = 0;k<8;k++)
        b[j][k] = blocks[j][k];*/
    return new Chunk(name,blocks,group,background,x,y,c,resources);
  }

  public int[][] iterate(final int[][] template,final int[][] temp_template,final int x,final int y,final Part[] neighbors){return temp_template;}

  public int getColor(){return c;}

  public boolean is(String type){return false;}

  public int[] getResources()
  {
    return resources;
  }

  public String getGroupName()
  {
    return group;
  }

  public void drawFrame(int x, int y, int frame)
  {
    Part[] Tiles = Game.ObjectManager.getGroup(group);

    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        Tiles[blocks[i][j]].drawFrame(x*8+i,y*8+j,frame);
  }
}
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
  public String[] getGroup(String name){return groups.get(name);}
  public void add(String name, T item){storage.put(name,item);}
  public T get(String name){return storage.get(name);}
  public void delete(String name){storage.remove(name);}
  public void deleteGroup(String name){groups.remove(name);}
}
public class Base extends Element
{
  Base(final int c_, int x_, int y_){super(c_,x_,y_);}

  Base(final int c_){super(c_);}

  public Part copy(){return new Base(getColor());}

  public Part createInstance(int x_, int y_){return new Base(getColor(),x_,y_);}
  
  public String getName(){return "Base";}

  public boolean is(String type){return false;}

  public int[][] iterate(int[][] template,int[][] temp_template_, int x, int y, Part[] neighbors)
  {
    int[][] temp_template = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        temp_template[i][j]=temp_template_[i][j];

    if(temp_template[x][y]==0)
      temp_template[x][y]=template[x][y];

    return temp_template;
  }
}
public class Life extends Element
{
  Life(final int c_, int x_, int y_)
  {
    super(c_,x_,y_);
  }

  Life(final int c_)
  {
    super(c_);
  }

  public Part copy()
  {
    return new Life(getColor());
  }

  public Part createInstance(int x_, int y_)
  {
    return new Life(getColor(),x_,y_);
  }

  public String getName()
  {
    return "Life";
  }

  public int[][] iterate(int[][] template,int[][] temp_template_, int x, int y, Part[] neighbors)
  {
    int[][] temp_template = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        temp_template[i][j]=temp_template_[i][j];

    int[] coord = simLife(template,x, y);

    if(coord[0]>0 && coord[1]>0)
    {
      temp_template[coord[0]][coord[1]]=3;
      temp_template[x][y]=3;
    }
    else
      temp_template[x][y]=2;

    return temp_template;
  }
 public boolean is(String type){return false;}
}



/*public class Life implements Part
{
  private color c;
  private int x;
  private int y;

  Life(final color c_, int x_, int y_)
  {
    c = c_;
    x = x_;
    y = y_;
  }

  Life(final color c_)
  {
    c = c_;
    x = 0;
    y = 0;
  }

  public Part copy()
  {
    return new Life(c);
  }

  public int[][] iterate(int[][] template,int[][] temp_template_, int x, int y, Part[] neighbors)
  {
    int[][] temp_template = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        temp_template[i][j]=temp_template_[i][j];

    int[] coord = simLife(template,x, y);

    if(coord[0]>0 && coord[1]>0)
    {
      temp_template[coord[0]][coord[1]]=3;
      temp_template[x][y]=3;
    }
    else
      temp_template[x][y]=2;

    return temp_template;
  }

  public void drawFrame(int x, int y, int frame){}

  public color getColor()
  {
    return c;
  }

  public Part createInstance(int x, int y)
  {
    return new Life(c,x,y);
  }

  public int getX()
  {
    return x;
  }

  public int getY()
  {
    return y;
  }

  public String getName()
  {
    return "Life";
  }
}*/
public class Source extends Element
{
  Source(final int c_, int x_, int y_)
  {
    super(c_,x_,y_);
  }

  Source(final int c_)
  {
    super(c_);
  }

  public Part copy()
  {
    return new Source(getColor());
  }

  public Part createInstance(int x_, int y_)
  {
    return new Source(getColor(),x_,y_);
  }

  public String getName()
  {
    return "Source";
  }

  public boolean is(String type){return false;}

  public int[][] iterate(int[][] template,int[][] temp_template_,int x, int y, Part[] neigh)
  {
    int[][] temp_template = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        temp_template[i][j]=temp_template_[i][j];

    int coord[] = {x,y};
    int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
    
    if(x==0 || y==0 || x==7 || y==7)
    {
      coord[0] = -1;
      //return coord;
    }
    else
    {
      int[] neighbors = new int[4];
      for(int i=0;i<4;i++)
        neighbors[i] = template[x+dir[i][0]][y+dir[i][1]];
      
      boolean found = false;

      for(int i=0;i<4;i++)
        if((neighbors[i]==1) && (neighbors[(i+1)%4]==2) && neighbors[(i+2)%4]==2 && (neighbors[(i+3)%4]==2))
        {
          for(int k=0;k<2;k++)
            coord[k] += dir[i][k];
          found = true;
          break;//return coord;
        }
      
      if(found == false)
        for(int i=0;i<4;i++)
          if((neighbors[(i+2)%4]==2 || neighbors[(i+2)%4]==1) && neighbors[i]==0)
          {
            for(int k=0;k<2;k++)
              coord[k] += dir[i][k];
            break;//return coord;
          }
    }

    if(coord[0]>0 && coord[1]>0 && temp_template[coord[0]][coord[1]]==0)
      temp_template[coord[0]][coord[1]]=2;
      
    return temp_template;
  }
}

/*public class Source implements Part
{
  private color c;
  private int x;
  private int y;

  Source(color c_, int x_, int y_)
  {
    c =c_;
    x =x_;
    y = x_;
  }

  Source(final color c_)
  {
    c =c_;
    x =0;
    y = 0;
  }

  public Part copy()
  {
    return new Source(c);
  }

  public color getColor()
  {
    return c;
  }

  public int getX()
  {
    return x;
  }

  public int getY()
  {
    return y;
  }

  public String getName()
  {
    return "Source";
  }

  public void drawFrame(int x, int y, int frame){}

  public Part createInstance(int x, int y)
  {
    return new Source(c,x,y);
  }

  public int[][] iterate(int[][] template,int[][] temp_template_,int x, int y, Part[] neigh)
  {
    int[][] temp_template = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        temp_template[i][j]=temp_template_[i][j];

    int coord[] = {x,y};
    int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
    
    if(x==0 || y==0 || x==7 || y==7)
    {
      coord[0] = -1;
      //return coord;
    }
    else
    {
      int[] neighbors = new int[4];
      for(int i=0;i<4;i++)
        neighbors[i] = template[x+dir[i][0]][y+dir[i][1]];
      
      boolean found = false;

      for(int i=0;i<4;i++)
        if((neighbors[i]==1) && (neighbors[(i+1)%4]==2) && neighbors[(i+2)%4]==2 && (neighbors[(i+3)%4]==2))
        {
          for(int k=0;k<2;k++)
            coord[k] += dir[i][k];
          found = true;
          break;//return coord;
        }
      
      if(found == false)
        for(int i=0;i<4;i++)
          if((neighbors[(i+2)%4]==2 || neighbors[(i+2)%4]==1) && neighbors[i]==0)
          {
            for(int k=0;k<2;k++)
              coord[k] += dir[i][k];
            break;//return coord;
          }
    }

    if(coord[0]>0 && coord[1]>0 && temp_template[coord[0]][coord[1]]==0)
      temp_template[coord[0]][coord[1]]=2;
      
    return temp_template;
  }
}*/
public class Space extends Element
{
  Space(final int c_, int x_, int y_)
  {
    super(c_,x_,y_);
  }

  Space(final int c_)
  {
    super(c_);
  }

  public Part copy()
  {
    return new Space(getColor());
  }

  public Part createInstance(int x_, int y_)
  {
    return new Space(getColor(),x_,y_);
  }

  public String getName()
  {
    return "Space";
  }

  public boolean is(String type){return false;}

  /*public int[][] iterate(int[][] template,int[][] temp_template_,int x, int y, Part[] neigh)
  {
    int[][] temp_template = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        temp_template[i][j]=temp_template_[i][j];

    int coord[] = {x,y};
    int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
    
    if(x==0 || y==0 || x==7 || y==7)
    {
      coord[0] = -1;
      //return coord;
    }
    else
    {
      int[] neighbors = new int[4];
      for(int i=0;i<4;i++)
        neighbors[i] = template[x+dir[i][0]][y+dir[i][1]];
      
      boolean found = false;

      for(int i=0;i<4;i++)
        if((neighbors[i]==1) && (neighbors[(i+1)%4]==2) && neighbors[(i+2)%4]==2 && (neighbors[(i+3)%4]==2))
        {
          for(int k=0;k<2;k++)
            coord[k] += dir[i][k];
          found = true;
          break;//return coord;
        }
      
      if(found == false)
        for(int i=0;i<4;i++)
          if((neighbors[(i+2)%4]==2 || neighbors[(i+2)%4]==1) && neighbors[i]==0)
          {
            for(int k=0;k<2;k++)
              coord[k] += dir[i][k];
            break;//return coord;
          }
    }

    if(coord[0]>0 && coord[1]>0 && temp_template[coord[0]][coord[1]]==0)
      temp_template[coord[0]][coord[1]]=2;
      
    return temp_template;
  }*/
}

/*public class Space implements Part
{
  private color c;
  private int x;
  private int y;

  Space(final color c_, int x_, int y_)
  {
    c = c_;
    x = x_;
    y = y_;
  }

  Space(final color c_)
  {
    c = c_;
    x = 0;
    y = 0;
  }

  public Part copy()
  {
    return new Space(c);
  }

  public Part createInstance(int x, int y)
  {
    return new Space(c,x,y);
  }

  public void drawFrame(int x, int y, int frame){}

  public int[][] iterate(final int[][] template,final int[][] temp_template_,
    int x, int y, Part[] neighbors)
  {
    int[][] temp_template = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        temp_template[i][j]=temp_template_[i][j];

    Message msg = new Message("interpreter","idle",new JSONArray());

    return interpretPart(msg,template,temp_template,x,y);
  }

  public color getColor()
  {
    return c;
  }

  public int getX()
  {
    return x;
  }

  public int getY()
  {
    return y;
  }

  public String getName()
  {
    return "Space";
  }
}*/
class Water extends Tile
{
  Water(int[][][] img_,int[]resources_,int background_, int x, int y)
  {
    super(img_,resources_,background_,x,y,color(0,0,255));
  }

  Water(int[][] template)
  { 
    super(template,color(0,0,255));
  }

  public Water copy()
  {
    Water out = new Water(img,resources,background,x,y);
    return out;
  }

  public boolean is(String type){
    if(type.equals("water"))
      return true;
    return false;
  }
}
public class Element implements Part
{
  private int c;
  private int x;
  private int y;

  Element(final int c_, int x_, int y_)
  {
    c = c_;
    x = x_;
    y = y_;
  }

  Element(final int c_)
  {
    c = c_;
    x = 0;
    y = 0;
  }

  public Part copy()
  {
    return new Element(c);
  }

  public Part createInstance(int x_, int y_)
  {
    return new Element(c,x_,y_);
  }

  public void drawFrame(int x, int y, int frame){}

  public int[][] iterate(final int[][] template,final int[][] temp_template_,
    int x, int y, Part[] neighbors)
  {
    int[][] temp_template = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        temp_template[i][j]=temp_template_[i][j];

    //String[] a = {};
    Msg msg = new Msg("interpreter","idle",new JSONObject());

    return interpretPart(msg,template,temp_template,x,y);
  }

  public int getColor()
  {
    return c;
  }

  public int getX()
  {
    return x;
  }

  public int getY()
  {
    return y;
  }

  public boolean is(String type){return false;}

  public String getName()
  {
    return "Undefined Element";
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
}
public class Game
{
  Player Player;
  GameLoop GameLoop;
  RenderEngine RenderEngine;
  ObjectManager ObjectManager;
  SceneManager SceneManager;
  InputHandler InputHandler;

  Game()
  {
  }

  Game(Player Player_,GameLoop GameLoop_,RenderEngine RenderEngine_,ObjectManager ObjectManager_,SceneManager SceneManager_,InputHandler InputHandler_)
  {
    Player = Player_;
    GameLoop = GameLoop_;
    RenderEngine = RenderEngine_;
    ObjectManager = ObjectManager_;
    SceneManager = SceneManager_;
    InputHandler = InputHandler_;
  }

  private void sendToInput(Msg msg)
  {
    switch(msg.msg)
    {
      case "drop":
        InputHandler.dropInput(msg.a.getString("a1"));
        break;
      case "register":
        InputHandler.registerInput(msg.a.getString("a1"));
        break;
      case "check":
        InputHandler.checkInputs();
        break;
    }
  }

  public void addInputHandler(InputHandler sv)
  {
    InputHandler = sv;
  }

  public void addObjectManager(ObjectManager sv)
  {
    ObjectManager = sv;
  }

  public void addPlayer(Player sv)
  {
    Player = sv;
  }

  public void addGameLoop(GameLoop sv)
  {
    GameLoop = sv;
  }

  public void addRenderEngine(RenderEngine sv)
  {
    RenderEngine = sv;
  }

  public void addSceneManager(SceneManager sv)
  {
    SceneManager = sv;
  }

  /*public void add(String name, Service service)
  {
    switch(name)
    {
      case "player":
        Player = service;
        break;
      case "gameLoop":
        GameLoop = service;
        break;
      case "renderEngine":
        RenderEngine = service;
        break;
      case "objectManager":
        ObjectManager = service;
        break;
      case "sceneManager":
        SceneManager = service;
        break;
      case "inputHandler":
        InputHandler = service;
        break;
      default:
        println("(!!!) TIPO in Game.add()");
    }
  }*/

  private void sendToScene(Msg msg)
  {
    int i1,i2,i3;
    float f1;
    String s1;
    switch(msg.msg)
    {
      case "moveTo":
        i1 = msg.a.getInt("a1");
        i2 = msg.a.getInt("a2");
        i3 = msg.a.getInt("a3");
        SceneManager.moveTo(i1, i2, i3);
        break;
      case "rotateTo":
        f1 = msg.a.getFloat("a1");
        i2 = msg.a.getInt("a2");
        SceneManager.rotateTo(f1,i2);
        break;
      case "renderArea":
        SceneManager.renderArea();
        break;
      case "chanceScene":
        s1 = msg.a.getString("a1");
        SceneManager.chanceScene(s1);
        break;
    }
  }

  public void send(String adress_,String msg_,JSONObject attributes_)
  {
    Msg msg = new Msg(adress_,msg_,attributes_);
    switch(msg.adress)
    {
      case "input":
        sendToInput(msg);
        break;
      case "scene":
        sendToScene(msg);
        break;
      /*case "render":
        sendToRender(msg);
        break;
      case "object":
        sendToObject(msg);
        break;*/
    }
  }
}
public class GameLoop implements Service
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
public interface Part
{
  public int[][] iterate(final int[][] template,final int[][] temp_template,final int x,final int y,final Part[] neighbors);
  public String getName();
  public int getColor();
  public int getX();
  public int getY();
  public int[] getResources();
  public String getGroupName();
  public Part copy();
  public boolean is(String type);
  public Part createInstance(int x, int y);
  public void drawFrame(int x, int y, int frame);
}
public class InputHandler implements Service
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
    PVector pos;
    float dir;
    JSONObject a;
    Player player = Game.Player;
    switch(input)
    {
      case "w":
        pos = player.lookingAt();
        Game.SceneManager.moveTo(PApplet.parseInt(pos.x), PApplet.parseInt(pos.y), 10);
        player.setPos(pos);
        break;

      case "s":
        pos = player.infrontOf();
        Game.SceneManager.moveTo(PApplet.parseInt(pos.x), PApplet.parseInt(pos.y), 10);
        player.setPos(pos);
        break;
      case "d":
        dir = player.getDir()-PI/2;
        Game.SceneManager.rotateTo(dir,10);
        player.setDir(dir);
        break;
      case "a":
        dir = player.getDir()+PI/2;
        Game.SceneManager.rotateTo(dir,10);
        player.setDir(dir);
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
    //String[] long_press = {"w","s"};
    /*for(int i = 0; i < long_press.length; i++)
      if(input_ == long_press[i])
      {
        longInput(input_);
        return;
      }*/
    if(isLongPress(input_))
    {
      longInput(input_);
      return;
    }
    println("=>>" + input_);
    translateInput(input_);

    
    //bufferSet.remove(input_);
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
  //private Block[][] obj_map;
  //private ArrayList<Block> obj;
  private String group_name;

  Map(String parts)
  {
    group_name = parts;
    map = genMap();
  }

  Map(int size, int detail, String parts)
  {
    group_name = parts;

    //map = genMap(size, detail);
    map = genMap();
    //interate



    
    //obj_map = new Block[size/detail][size/detail];
    /*obj = new ArrayList<Block>();
    for(int i=0;i<size;i++)
      for(int j=0;j<size;j++)
      {
        if(b[map[i][j]].isObj)
        {
          obj.add(b[map[i][j]].createBlock(i,j));
        }
      }*/
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
    int size = 8;
    Part[] Tiles = Game.ObjectManager.getGroup(group_name);
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
    
    //int[] lake = {};
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

  /*void draw()
  {
    for(int i=0;i<MAP_SIZE;i++)
        for(int j=0;j<MAP_SIZE;j++)
          b[map[i][j]].drawFrame(i,j,GameLoop.getFrame());
          //drawBlock(i,j,b[map[i][j]].getFrame(CURRENT_FRAME),b[map[i][j]].background);
  }*/
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
class Organic extends Tile
{
  //int food;
  Organic(int[][][] img_,int[]resources_,int background_, int x, int y)
  {
    super(img_,resources_,background_,x,y,color(0,255,0));
  }

  Organic(int[][] template)
  { 
    super(template,color(0,255,0));
    //isObj = true;
    //food = 0;
  }

  public Organic copy()
  {
    Organic out = new Organic(img,resources,background,x,y);
    //out.food = food;
    return out;
  }

  public boolean is(String type){
    if(type.equals("organic"))
      return true;
    return false;
  }
}
public class ObjectManager implements Service
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
    return database.get(name);
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
    return database.getGroup(name);
  }
}
public int[][] interpretPart(Msg msg, int[][] template,int[][] temp_template_, int x, int y)
{
  int[][] temp_template = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        temp_template[i][j]=temp_template_[i][j];

  switch(msg.msg)
  {
    //default:
    case "idle":
      break;
  }

  return temp_template;
}
public class Player implements Service
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
/*void drawBlock(int x, int y, int template[][],int background)
{
  Element space = new Element(color(0,0,0));
  Element life = new Element(color(0,80,0));
  Element source = new Element(color(0,0,255));
  Element base = new Element(color(0,0,0));

  drawBackground(x*8,y*8,background);

  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
      switch(template[i][j])
      {
        case 3:
          life.draw(x*8+i,y*8+j);
          break;
        case 2:
          source.draw(x*8+i,y*8+j);
          break;
        case 1:
          base.draw(x*8+i,y*8+j);
          break;
        case 0:
        default:
          break;
      }
}*/

public void drawBackground(int x, int y,int background)
{
  
  int c;
  switch(background)
  {
    case 3:
      c = color(0,128,0);
      break;
    case 2:
      c = color(80,80,256);
      break;
    case 1:
      c = color(127,127,127);
      break;
    case 0:
    default:
      c = color(80,255,80);
      break;
  }
  fill(c);
  Game.RenderEngine.drawBackground(x,y);
  //CURRENT_VIEW.drawBackground(x,y);
}
public int[][] randTemplate(int stone, int water, int life)
{
  int template[][] = new int[8][8];
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
      template[i][j]=0;
    
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
    {
      float rand = random(100);
      int type;
      if(rand<life)
        type = 3;
      else if(rand<water+life)
        type = 2;
      else if(rand<water+stone+life)
        type = 1;
      else
        type = 0;
      template[i][j]=type;
    }
  return template;
}
class RenderEngine implements Service
{
  JSONObject Views;
  String corrent_view;
  RenderEngine(String name, int max_)
  {
    Views = new JSONObject();
    corrent_view = name;
    addView(name,max_);
  }

  public void addView(String name,int max_)
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

  public JSONObject getView()
  {
    return Views.getJSONObject(corrent_view);
  }

  public void setView(String name)
  {
    corrent_view = name;
  }

  public void setPos(int x, int y)
  {
    //float size = getView().getInt("size")*8;
    /*JSONObject view = getView();
    view.setFloat("pos_x",floor(x*size+size/2));
    view.setFloat("pos_y",floor(y*size+size/2));
    Views.setJSONObject(corrent_view, view);*/
    PVector pos = calcPos(x, y);
    setAbsPos(pos.x, pos.y);
  }

  public PVector calcPos(int x, int y)
  {
    float size = getView().getInt("size")*8;
    return new PVector(floor(x*size+size/2),floor(y*size+size/2));
  }

  public void setAbsPos(float x, float y)
  {
    /*float size = getView().getInt("size")*8;*/
    JSONObject view = getView();
    view.setFloat("pos_x",x);
    view.setFloat("pos_y",y);
    Views.setJSONObject(corrent_view, view);
  }

  public float getX()
  {
    JSONObject view = getView();
    return view.getFloat("pos_x");
  }

  public float getY()
  {
    JSONObject view = getView();
    return view.getFloat("pos_y");
  }

  public float getRot()
  {
    JSONObject view = getView();
    return view.getFloat("rotation");
  }

  public void setRot(float rot_)
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

  public void rotateScene()
  {
    float rot = getView().getFloat("rotation");
    translate(width/2, height/2);
    rotate(rot);
    translate(-width/2, -height/2);
  }

  public void drawView()
  {
    noStroke();
    fill(0);
    float temp_x = getView().getInt("offset_x");
    float temp_y = getView().getInt("offset_y");
    float temp_size = getView().getInt("max")*8*getView().getInt("size");
    rect(temp_x,temp_y,temp_size,temp_size);
  }

  public void drawRect(int x, int y)
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
  
  public void drawBackground(int x, int y)
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
    JSONObject a = new JSONObject();
    Game.send("scene","renderArea",a);
    //SceneManager.renderArea();
  }
}
public class Scene
{
  private int[][] map;
  private Tile[] tiles;
  String group_name;

  Scene(int[][] map_,String tiles)
  {
    map = new int[map_.length][map_[0].length];
    for(int i = 0; i < map_.length; i++)
      for(int j = 0; j < map_[0].length; j++)
        map[i][j] = map_[i][j];
    
    group_name = tiles;
    /*tiles = new Tile[tiles_.length];
    for(int i = 0; i < tiles_.length; i++)
      tiles[i] = tiles_[i].copy();*/
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
    Game.RenderEngine.rotateScene();
    Part[] Tiles = Game.ObjectManager.getGroup(group_name);

    for(int i=0;i<map.length;i++)
      for(int j=0;j<map[0].length;j++)
        Tiles[map[i][j]].drawFrame(i,j,Game.GameLoop.getFrame());
        //tiles[map[i][j]].drawFrame(i,j,GameLoop.getFrame());
  }
}
public class SceneManager implements Service
{
  private String corrent_scene;
  private int trans_time;
  private PVector trans_location;
  private float rot_location;
  private float rot_time;

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

    addScene(name,map,tiles);
  }

  public void moveTo(int x, int y, int time)
  {
    trans_location = Game.RenderEngine.calcPos(x, y);
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
    if(trans_time != 0)
    {
      PVector location = new PVector(Game.RenderEngine.getX(),Game.RenderEngine.getY());
      PVector target = trans_location;
      PVector difference = PVector.sub(target,location);
      difference.setMag(difference.mag()/trans_time);
      location.add(difference);
      Game.RenderEngine.setAbsPos(location.x,location.y);
      trans_time--;
    }

    if(rot_time != 0)
    {
      float rot = Game.RenderEngine.getRot();
      float difference = rot_location-rot;
      
      if(difference > PI)
        difference -= TWO_PI;
      else if(difference < -PI)
        difference += TWO_PI;

      difference /= rot_time;
      Game.RenderEngine.setRot(rot+difference);
      
      rot_time--;
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

public interface Service
{

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
public class Simulation
{
  int[][][] tables;
  String[] names;
  int size;

  Simulation(final String[] names_)
  {
    size = 8;
    int n = names_.length;
    names = new String[3];
    tables = new int[n][size][size];
    for(int i = 0; i < n; i++)
    {
      names[i] = names_[i];

      for(int j = 0; j < size; j++)
        for(int k = 0; k < size; k++)
          tables[i][j][k] = 0;
    }
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
}
public int[][] iterateTile(int[][] template, int[][] temp_template_)
{
  Part[] elements = Game.ObjectManager.getGroup("elements");

  int[][] temp_template = new int[8][8];
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
      temp_template[i][j]=temp_template_[i][j];
  
  for(int i=0;i<8;i++)
    for(int j=0;j<8;j++)
    {
      if(template[i][j] == 0)
        continue;
      Part part = elements[template[i][j]];
      Part[] neighbors = new Part[4];
      int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
      for(int k = 0; k < 4; k++)
      {
        int x = dir[k][0]+i;
        int y = dir[k][1]+j;
        if(x>=0 && x<8 && y>=0 && y<8)
          neighbors[k] = elements[template[x][y]].copy();
        else
          neighbors[k] = elements[0].copy();
      }
        
      temp_template = part.iterate(template,temp_template,i, j, neighbors);
    }
      
  return temp_template;
}
public int[] simLife(int template[][],int x, int y)
{
  int out[] = {x,y};
  int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
  
  int[] neighbors = new int[4];
  for(int i=0;i<4;i++)
  {
    if(x+dir[i][0]<0 || y+dir[i][1]<0 || x+dir[i][0]>7 || y+dir[i][1]>7)
      neighbors[i] = 1;
    else
      neighbors[i] = template[x+dir[i][0]][y+dir[i][1]];
  }
  
  for(int i=0;i<4;i++)
    if(neighbors[i]==2)
    {
      for(int k=0;k<2;k++)
        out[k] += dir[i][k];
      return out;
    }
  
  out[0]=-1;
  return out;
}
/*int[] simSource(int template[][],int x, int y)
{
  int out[] = {x,y};
  int[][] dir = {{-1,0},{0,-1},{1,0},{0,1}};
  
  if(x==0 || y==0 || x==7 || y==7)
  {
    out[0] = -1;
    return out;
  }
  
  int[] neighbors = new int[4];
  for(int i=0;i<4;i++)
    neighbors[i] = template[x+dir[i][0]][y+dir[i][1]];
  
  for(int i=0;i<4;i++)
    if((neighbors[i]==1) && (neighbors[(i+1)%4]==2) && neighbors[(i+2)%4]==2 && (neighbors[(i+3)%4]==2))
    {
      for(int k=0;k<2;k++)
        out[k] += dir[i][k];
      return out;
    }
  
  for(int i=0;i<4;i++)
    if((neighbors[(i+2)%4]==2 || neighbors[(i+2)%4]==1) && neighbors[i]==0)
    {
      for(int k=0;k<2;k++)
        out[k] += dir[i][k];
      return out;
    }
    
  return out;
}*/
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
public Chunk createGroundChunk()
{
  int[] amount = {5,10};
  String[] names = {"lake","bush"};
  return createChunk("ground",amount,names,"tiles");
  //return new Chunk("ground",chunkTemplate({5,10},{"lake","bush"},"tiles"),"tiles");
}

public Chunk createWaterChunk()
{
  int[] amount = {70,10};
  String[] names = {"lake","alga"};
  return createChunk("water",amount,names,"tiles");
}

public Chunk createMountainChunk()
{
  int[] amount = {5,70,10};
  String[] names = {"lake","stone","moss"};
  return createChunk("mountain",amount,names,"tiles");
}

public Chunk createForestChunk()
{
  int[] amount = {10,5,50};
  String[] names = {"lake","stone","bush"};
  return createChunk("mountain",amount,names,"tiles");
}

public Tile createBush(){return new Organic(plantTemplate(0,10,10));}
public Tile createMoss(){return new Tile(solidTemplate(50,20,10),color(0,0,0));}
public Tile createGround(){return new Tile(groundTemplate(10,0,0),color(0,0,0));}
public Tile createLake(){return new Water(groundTemplate(0,50,0));}//,color(0,0,255));}
public Tile createStone(){return new Tile(solidTemplate(80,1,0),color(0,0,0));}
public Tile createAlga(){return new Water(groundTemplate(0,20,4));}//,color(0,0,255));}

public Chunk createChunk(String name, int[] amount, String[] names, String group_name)
{
  String[] group = Game.ObjectManager.getNamesByGroup(group_name);
  int[] adresses = new int[names.length];
  int size = 8;

  for(int i=0;i<names.length;i++)
    for(int j=1;j<group.length;j++)
      if(group[j]==names[i])
      {
        adresses[i] = j;
        break;
      }

  int[][] out = new int[size][size];
  for(int i=0;i<size;i++)
    for(int j=0;j<size;j++)
    {
      float rand = random(100);
      //int l = map_layout[i/detail][j/detail];

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
  Chunk ch = new Chunk(name,out,group_name);
  return ch;
}

public int[][] plantTemplate(int stone, int water, int life)
{
  int[][] out = randTemplate(stone,water,life);
  
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

public int[][] groundTemplate(int stone, int water, int life)
{
  int[][] out = randTemplate(stone,water,life);
  return out;
}

public int[][] solidTemplate(int stone, int water, int life)
{
  int[][] out = randTemplate(stone,water,life);
  
  for(int i=0;i<8;i++)
  {
    out[0][i]=1;
    out[i][0]=1;
    out[7][i]=1;
    out[i][7]=1;
  }
  
  return out;
}
public class Tile implements Part
{
  public int[][][] img;
  public int[] resources;
  public int background;
  //public boolean isObj;
  private int c;
  public int x;
  public int y;
  private String name;

  Tile(int[][][] img_,int[]resources_,int background_, int x, int y, int c)
  {
    img = new int[6][8][8];
    for(int i = 0;i<6;i++)
      for(int j = 0;j<8;j++)
        for(int k = 0;k<8;k++)
          img[i][j][k] = img_[i][j][k];

    resources = new int[5];
    for(int i = 0;i<5;i++)
      resources[i] = resources_[i];
    
    background = background_;
    //isObj = isObj_;

    x = 0;
    y = 0;
  }

  Tile(int c_)
  {
    int[][][] img_ = new int[6][8][8];
    for(int i = 0;i<6;i++)
      for(int j = 0;j<8;j++)
        for(int k = 0;k<8;k++)
          img_[i][j][k] = 0;
    
    int[] resources_ = new int[5];
    for(int k = 0;k<5;k++)
      resources_[k] = 0;
    
    background = 0;
    //isObj = false;
    c = c_;

    x = 0;
    y = 0;
  }

  Tile(int[][] template, int c_)
  {    
    int[][] temp_template = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        temp_template[i][j]=template[i][j];
    
    int[][] map_empty = new int[8][8];
    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
        map_empty[i][j]=0;
        
    for(int k = 0;k<16;k++)
    {
      temp_template = iterate(temp_template,map_empty,0,0);
    }
    
    img = new int[6][8][8];
    resources = new int[5];
    for(int k = 0;k<6;k++)
    {
      temp_template = iterate(temp_template,map_empty,0,0);
      for(int i=0;i<8;i++)
        for(int j=0;j<8;j++)
        {
          img[k][i][j] = temp_template[i][j];
          if(k==0)
            resources[temp_template[i][j]]=0;
          if(k==5)
            resources[temp_template[i][j]]++;
        }
    }
    
    int[] mult = {1,4,12,20,1};
    background = 0;
    for(int i=1;i<5;i++)
      if(mult[i]*resources[i]>mult[background]*resources[background])
        background = i;
    
    c = c_;
    //isObj = false;

    x = 0;
    y = 0;
  }

  public Tile copy(){return new Tile(img,resources,background,x,y,c);}

  public int getX(){return x;}

  public int getY(){return y;}

  public String getName(){return name;}

  public boolean is(String type){return false;}

  public Part createInstance(int x, int y)
  {
    return new Tile(img,resources,background,x,y,c);
  }

  //Pls remove as fast as possible
  /*public Block createBlock(int x, int y)
  {
    return new Block(img,resources,background,x,y,c);
  }*/
  
  public int[][] getFrame(int i){return img[i];}

  public int[][] iterate(final int[][] template,final int[][] temp_template,final int x,final int y,final Part[] neighbors)
  {
    return iterateTile(template,temp_template);
  }
  
  //PLS remove as fast as possible
  public int[][] iterate(int[][] template,int[][] temp_template, int x, int y)
  {
    return iterateTile(template,temp_template);
  }

  public void drawFrame(int x, int y, int frame)
  {
    int[][] template = img[frame];
    Part[] elements = Game.ObjectManager.getGroup("elements");

    drawBackground(x*8,y*8,background);

    for(int i=0;i<8;i++)
      for(int j=0;j<8;j++)
      {
        if(template[i][j] == 0)
          continue;
        
        fill(elements[template[i][j]].getColor());
        Game.RenderEngine.drawRect(x*8+i,y*8+j);
      }
  }

  public int getColor()
  {
    return c;
  }

  public int[] getResources()
  {
    return resources;
  }

  public String getGroupName()
  {
    return "elements";
  }
}
public void draw()
{
  //JSONObject a = new JSONObject;
  Game.send("input","check",new JSONObject());
  //InputHandler.checkInputs();

  if(Game.GameLoop.tick())
  {
    /*if(keyReleased)
      InputHandler.dropInput(key);
    if(keyPressed)
      InputHandler.registerInput(key);*/
      //controller();

    COUNTER++;

    //disabling the template Scene
    if(COUNTER<16)
      COUNTER = 16;
    
    if(COUNTER == 16)
    {
      Game.RenderEngine.setView("map");
      PVector pos = Game.Player.getPos();
      Game.RenderEngine.setPos(PApplet.parseInt(pos.x), PApplet.parseInt(pos.y));
      JSONObject a = new JSONObject();
      a.setString("a1","main");
      Game.send("scene","chanceScene",a);
      //SceneManager.chanceScene("main");
    }

    if(COUNTER<16)
    {
      int[][] map_empty = new int[8][8];
      for(int i=0;i<8;i++)
        for(int j=0;j<8;j++)
          map_empty[i][j]=0;
      
      int[][] map = Game.SceneManager.getMap();
      Game.SceneManager.setMap(iterateTile(map,map_empty));
    }
      
  }

  background(255);
  Game.RenderEngine.drawView();
  //RenderEngine.setRot(Player.getDir());
  
  /*translate(width/2, height/2);
  rotate((TWO_PI*(60*CURRENT_FRAME+tick))/(60*6));
  translate(-width/2, -height/2);*/

  if(COUNTER<16)
  {
    //Needs a system to display the iterations like drawTemplate
    //drawBlock(0,0,TEMPLATE,0);
    //still not working!!!
    //templateScene.render();
  }
  else
  {
    Game.SceneManager.renderArea();
  }
}
public void registerObjects()
{
  ObjectManager ObjectManager = Game.ObjectManager;
  ObjectManager.registerPart("space", new Space(color(0,0,0)));
  ObjectManager.registerPart("base", new Base(color(40,40,40)));
  ObjectManager.registerPart("source", new Source(color(0,0,255)));
  ObjectManager.registerPart("life", new Life(color(0,80,0)));
  String[] elements = {"space","base","source","life"};
  ObjectManager.registerGroup("elements",elements);

  ObjectManager.registerPart("ground", createGround());
  ObjectManager.registerPart("lake", createLake());
  ObjectManager.registerPart("stone", createStone());
  ObjectManager.registerPart("alga", createAlga());
  ObjectManager.registerPart("moss", createMoss());
  ObjectManager.registerPart("bush", createBush());
  String[] tiles = {"ground","lake","stone","alga","moss","bush"};
  ObjectManager.registerGroup("tiles",tiles);

  int amount = 4;

  String name = "groundChunk";
  String[] group = new String[amount];
  for(int i=0;i<amount;i++)
  {
    ObjectManager.registerPart(name+i, createGroundChunk());
    group[i] = name+i;
  }
  ObjectManager.registerGroup(name+"s",group);

  name = "waterChunk";
  group = new String[amount];
  for(int i=0;i<amount;i++)
  {
    ObjectManager.registerPart(name+i, createWaterChunk());
    group[i] = name+i;
  }
  ObjectManager.registerGroup(name+"s",group);
  
  name = "mountainChunk";
  group = new String[amount];
  for(int i=0;i<amount;i++)
  {
    ObjectManager.registerPart(name+i, createMountainChunk());
    group[i] = name+i;
  }
  ObjectManager.registerGroup(name+"s",group);

  name = "forestChunk";
  group = new String[amount];
  for(int i=0;i<amount;i++)
  {
    ObjectManager.registerPart(name+i, createForestChunk());
    group[i] = name+i;
  }
  ObjectManager.registerGroup(name+"s",group);

  String[] chunk = 
  {
    "groundChunk1","groundChunk2",
    "waterChunk1","waterChunk2",
    "mountainChunk1","mountainChunk2",
    "forestChunk1","forestChunk2",
  };
  ObjectManager.registerGroup("chunk",chunk);
}
  public void settings() {  size(640, 640); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "WorldSim" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}