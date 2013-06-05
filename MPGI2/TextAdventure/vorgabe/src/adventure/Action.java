package adventure;
import adventure.Game;
import adventure.Adventure;

/**
 * Actions are what the player can "do" in a given situation.
 * If the user chooses a certain applicable Action, the game
 * calls the apply method, which may modify the game state
 * (and its own state) in order to trigger certain effects.
 */
public interface Action {
  public boolean applicable(Game g);
  public void apply(Adventure a);

}

