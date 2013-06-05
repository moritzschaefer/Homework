package adventure.scenes;

import adventure.Action;
import adventure.ActionExamine;
import adventure.ActionGoto;
import adventure.ActionTakeItem;
import adventure.Scene;

// This class will only work after you have finished the
// homework of implementing the Action classes.
public class LivingRoom extends Scene {
	public static Scene scene = new LivingRoom();

	@Override
	protected String getTitle() {
		return "Im Wohnzimmer";
	}

	@Override
	protected String getText() {
		return "Du stehst in einem großen schäbigen Raum.\n" +
				"Es riecht etwas nach schimmliger Pizza.";
	}

	@Override
	protected Action[] getActions() {
		return new Action[]{
			new ActionExamine("Den Tisch betrachten",
					"Auf dem Tisch liegt etwas, was mal Pizza gewesen \n" +
					"sein könnte.", new Action[]{
						new ActionExamine("Iss etwas von der Pizza.",
								"Schon beim ersten Bissen überkommt dich ein\n" +
								"unbeschreiblicher Brechreiz. Komisch, du\n" +
								"könntest schwören, dass die gestern noch\n" +
								"echt gut war!\n" +
								"Oh, unter der Pizza liegt ein Autoschlüssel!",
								new Action[]{
									new ActionTakeItem("Nimm den Autoschlüssel.",
											"Autoschlüssel aufgenommen.","carkey")
						})
			}),
			new ActionGoto("Die Wohnung verlassen", Street.scene)
		};
	}

}

