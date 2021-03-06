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