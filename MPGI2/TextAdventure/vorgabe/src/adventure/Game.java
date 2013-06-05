package adventure;

/**
 * This interface is used by Actions and Scenes to examine and modify
 * the current game state.
 * 
 * @author MPGI2 team
 *
 */
public interface Game {

	/**
	 * Change to a specific scene. Should only be called by Actions.
	 * @param scene
	 */
	public void setScene(Scene scene);

	/**
	 * @return the current scene
	 */
	public Scene getScene();

	/**
	 * Adds an item to the player's inventory. (If the player already owns
	 * the item, this method has no effect and returns false.)
	 * Should only be called by Actions.
	 * @param item item identification string
	 * @return true iff the item was added to the inventory.
	 */
	public boolean addItem(String item);

	/**
	 * Looks up whether the player owns an item with a specific name.
	 * @param item item identification string
	 * @return true iff the item is in the inventory
	 */
	public boolean hasItem(String item);

}
