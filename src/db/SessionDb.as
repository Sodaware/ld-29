package db 
{
	
	public class SessionDb 
	{
		
		// Scoring
		public static var score:int;
		public static var highScore:int;
		
		// Current level etc
		public static var currentLevel:int;
		
		// Totals
		public static var destroyedSubs:int;
		
		
		public static function resetSession() : void
		{
			SessionDb.createSession();
		}
		
		public static function createSession() : void
		{
			SessionDb.score        = 0;
			SessionDb.currentLevel = 0;
		}
		
	}

}