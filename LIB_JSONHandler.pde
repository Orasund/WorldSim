public class JSONObjectHandler
{
  JSONObject obj;

  JSONObjectHandler(JSONObject obj_)
  {
    obj = obj_;
  }

  public String[] getStringArray(String name)
  {
    JSONArray file = obj.getJSONArray(name);
    int size = file.size();
    String[] arr = new String[size];
    for(int i=0; i<size; i++)
      arr[i] = file.getString(i);
    return arr;
  }

  public int[] getIntArray(String name)
  {
    JSONArray file = obj.getJSONArray(name);
    int size = file.size();
    int[] arr = new int[size];
    for(int i=0; i<size; i++)
      arr[i] = file.getInt(i);
    return arr;
  }

  public String getString(String name)
  {
    return obj.getString(name);
  }

  public int getInt(String name)
  {
    return obj.getInt(name);
  }
}