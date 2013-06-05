package adventure.scenes;

import adventure.Action;
import adventure.ActionExamine;
import adventure.Scene;

public class TutScene extends Scene {
	public static Scene scene = new TutScene();
	
	@Override
	protected String getTitle() {
    return "my title string";
	}

	@Override
	protected String getText() {
    return "what happens on TutScene";
	}

	@Override
	protected Action[] getActions() {
    return new Action[] {
				new ActionExamine("Klingel bei dir.",
						"Du klingelst. Irgendwie passiert nichts."),
		};
	}

}

