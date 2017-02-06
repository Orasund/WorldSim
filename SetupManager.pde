public class SetupManager
{
  HashMap<String,ArrayList<String>> groups;

  SetupManager()
  {
    groups = new HashMap<String,ArrayList<String>>();
    /*groups.put("background",new ArrayList<String>());
    groups.put("organism",new ArrayList<String>());
    groups.put("reaction",new ArrayList<String>());
    groups.put("mineral",new ArrayList<String>());
    groups.put("liquid",new ArrayList<String>());*/
  }

  public void addGroup(String name)
  {
    if(groups.containsKey(name))
      return;
    groups.put(name,new ArrayList<String>());
  }

  public void clear()
  {
    groups.clear();
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