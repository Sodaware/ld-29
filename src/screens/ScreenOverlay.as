package screens
{
	
	import org.flixel.FlxGroup;
	
	public class ScreenOverlay extends FlxGroup
	{
		
		protected var _isFinished:Boolean = false;
		
		public function isFinished() : Boolean
		{
			return this._isFinished;
		}
		
	}

}