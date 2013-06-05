package adventure.scenes;

import adventure.Action;
import adventure.ActionExamine;
import adventure.ActionGoto;
import adventure.ActionUseItem;
import adventure.Scene;

//This class will only work after you have finished the
//homework of implementing the Action classes.
public class Street extends Scene {
	public static Scene scene = new Street();

	@Override
	protected String getTitle() {
		return "Vor dem Haus auf der Straße";
	}

	@Override
	protected String getText() {
		String text = "Das gleißende Tageslicht blendet dich, WELCOME TO \n" +
				"THE REAL WORLD. Auf der Straße steht dein Auto.";
		if (!game.hasItem("carkey")) {
			text += "\nJa, das wäre jetzt praktisch, wenn du wüsstest,\n" +
					"wo die Autoschlüssel sind.";
		}
		return text;
	}

	@Override
	protected Action[] getActions() {
		return new Action[] {
				new ActionExamine("Klingel bei dir.",
						"Du klingelst. Irgendwie passiert nichts."),
				new ActionGoto("Zurück in die Wohnung gehen.",LivingRoom.scene),
				new ActionUseItem("Schließe das Auto auf.",
						"Die Türverriegelung springt auf.", "carkey",
						new Action[]{new ActionGoto("Zur Uni fahren", University.scene)})
		};
	}
}

