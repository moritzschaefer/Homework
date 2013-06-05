package adventure.ActioniUseItem;

class ActionGoto implements Action {
  private String mActionString;
  private Scene mScene;
  public ActionGoto(String actionString, Scene scene) {
    mActionString = actionString;
    mScene = scene;
  }

  public void apply(Adventure a) {
    a.setScene(mScene);
  }
  
  @Override
  public String toString() {
    return mActionString;
  }
}
