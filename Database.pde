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