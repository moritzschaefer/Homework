package adventure;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

import adventure.scenes.TutScene;

/**
 * The main class of our adventure game.
 * 
 * It handles the user interaction and the current game state.
 * Actions use call-backs to the game instance (via the Game
 * interface) to alter the game state.
 * 
 * @author MPGI2 Team
 *
 */
public class Adventure implements Game {
	/**
	 * Current game Scene
	 */
	private Scene scene;
	
	/**
	 * List of items the player carries around
	 */
	private List<String> inventory = new ArrayList<String>();
	
	public static void main(String[] args) {
		Adventure game = new Adventure();
		game.setScene(TutScene.scene); 
		//game.setScene(LivingRoom.scene); //alternative Startszene
		game.run();
	}

	/**
	 * The main game method.
	 */
	private void run() {
		Scanner inputScanner = new Scanner(System.in);
		Scene oldScene = null;
		while(true) {
			if (oldScene != scene) {
				scene.draw();
			} else {
				scene.drawActions();
			}
			oldScene = scene;
			
			String input = inputScanner.next();
			if ("q".equals(input)) {
				System.out.println("Bye.");
				System.exit(0);
			} else if (input.matches("\\d")) {
				int selection = Integer.parseInt(input);
				Action action = scene.getAction(selection);
				if (action == null) {
					System.out.println("Das ist keine gültige Aktion!");
				} else {
					action.apply(this);
				}
			} else {
				System.out.println("Bitte gib eine Zahl für " +
						"eine Aktion oder [q] zum Beenden ein!");
			}
		}
	}
	
	@Override
	public void setScene(Scene scene) {
		scene.init(this);
		this.scene = scene;
	}
	
	@Override
	public Scene getScene() {
		return scene;
	}

	@Override
	public boolean addItem(String item) {
		return inventory.add(item);
	}
	
	@Override
	public boolean hasItem(String item) {
		return inventory.contains(item);
	}
}

