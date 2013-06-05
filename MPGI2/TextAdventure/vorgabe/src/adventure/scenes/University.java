package adventure.scenes;

import adventure.Action;
import adventure.ActionExamine;
import adventure.ActionGoto;
import adventure.Scene;

//This class will only work after you have finished the
//homework of implementing the Action classes.
public class University extends Scene {
	public static Scene scene = new University();

	@Override
	protected String getTitle() {
		return "In der Uni";
	}

	@Override
	protected String getText() {
		return "Oh, MPGI2 fällt heute offenbar aus. Sonst ist auch\n" +
				"nichts los in der Uni.";
	}

	@Override
	protected Action[] getActions() {
		return new Action[]{
			new ActionExamine("Weinen.","Du weinst."),
			new ActionGoto("Wieder nach Hause fahren", Street.scene)
		};
	}

}

