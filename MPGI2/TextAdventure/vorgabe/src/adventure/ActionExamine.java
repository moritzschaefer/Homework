package adventure;


public class ActionExamine implements Action{
  private String mActionString;
  private String mResultString;
  public ActionExamine(String s1, String s2) {
    mActionString = s1;
    mResultString = s2;
  }
  public void apply(Adventure a) {
    System.out.println(mResultString);
    
  }
  public boolean applicable(Game g) {
    return true;
  }
  @Override
  public String toString() {
    return mActionString;
  }
}
