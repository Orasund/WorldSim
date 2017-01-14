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