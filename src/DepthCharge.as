package
{
	
	// Import Flixel library & main game code
//	import db.SessionDb;
	import org.flixel.*; 
	import screens.TitleScreenState;
	import screens.PlayScreenState;

	// Set options for Flash file
	[SWF(width = "448", height = "576", backgroundColor = "#000000")]
 	//[Frame(factoryClass = "Preloader")]
	
	public class DepthCharge extends FlxGame
	{
		
		public function DepthCharge()
        {
            //	SessionDb.createSession();
			super(224, 288, PlayScreenState, 2);
			
		}

	}

}