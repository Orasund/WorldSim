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