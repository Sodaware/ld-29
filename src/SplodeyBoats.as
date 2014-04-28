package
{
	
	// Import Flixel library & main game code
	import db.SessionDb;
	import org.flixel.*; 
	import screens.TitleScreenState;
	import screens.PlayScreenState;

	// Set options for Flash file
	[SWF(width = "448", height = "576", backgroundColor = "#000000")]
 	//[Frame(factoryClass = "Preloader")]
	
	public class SplodeyBoats extends FlxGame
	{
		
		public function SplodeyBoats()
        {
            SessionDb.createSession();
//			super(224, 288, PlayScreenState, 2);
			super(224, 288, TitleScreenState, 2, 60, 60);
		}

	}

}