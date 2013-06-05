package adventure;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

abstract public class Scene {
	/**
	 * Every Scene is connected to the main game object.
	 */
	protected Game game;
	
	/**
	 * Actions that can be performed within a Scene.
	 * Other than the Actions specified by concrete scenes via
	 * Definition of getActions() this list changes depending
	 * on the situation.
	 */
	private List<Action> actions = null;

	/**
	 * Scene title. (To be specified by concrete Scenes)
	 * Function is called every time a Scene is visited
	 * @return title
	 */
	abstract protected String getTitle();
	
	/**
	 * A short text describing the scene.
	 * (To be specified by concrete Scenes)
	 * Function is called every time a Scene is visited.
	 * @return scene description text
	 */
	abstract protected String getText();
	
	/**
	 * A short text describing the scene.
	 * (To be specified by concrete Scenes)
	 * Function is called when a Scene is being visited for the very first
	 * time!
	 * @return the Scenes initial Actions
	 */
	abstract protected Action[] getActions();
	
	/**
	 * Sets up a Scene within the game environment.
	 * To be called by the Game instance every time the player enters the Scene.
	 * 
	 * @param game The Game instance.
	 */
	public final void init(Game game) {
		this.game = game;
		if (actions == null) {
			actions = new ArrayList<Action>();
			Collections.addAll(actions, getActions());
		}
	}

	/**
	 * Returns the selection-th applicable Action of a Scene.
	 * Null if no action with such an id is applicable.
	 * 
	 * @param selection id of selected Action
	 * @return Action with specified id or null
	 */
	public Action getAction(int selection) {
		for (Action a : actions) {
			if (a.applicable(game) && --selection <= 0) {
				return a;
			}
		}
		return null;
	}

	/**
	 * Prints a scene description and the applicable actions
	 * to System.out
	 */
	public void draw() {
		System.out.println(getTitle().toUpperCase());
		System.out.println("--------------------------------");
		System.out.println(getText());
		System.out.println("--------------------------------");
		drawActions();
	}
	
	/**
	 * Prints a numbered list of applicable actions to System.out
	 */
	public void drawActions() {
		int i = 1;
		for (Action a : actions) {
			if (a.applicable(game)) {
				System.out.println("("+(i++)+") " + a.toString());
			}
		}
	}
	
	/**
	 * Adds new (inter-)Actions to a Scene.
	 * @param additionalActions
	 */
	public final void addActions(Action[] additionalActions) {
		Collections.addAll(actions, additionalActions);
	}
}

