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