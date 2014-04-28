package db 
{
	
	public class SessionDb 
	{
		
		// Scoring
		public static var score:int;
		public static var highScore:int;
		public static var previousName:String;
		
		// Current level etc
		public static var currentLevel:int;
		
		// Totals (current session)
		public static var destroyedSubs:int;
		public static var chargesDropped:int;
		public static var highestCombo:int;
		
		
		
		public static function resetSession() : void
		{
			SessionDb.createSession();
		}
		
		public static function createSession() : void
		{
			SessionDb.score          = 0;
			SessionDb.currentLevel   = 0;
			
			SessionDb.destroyedSubs  = 0;
			SessionDb.chargesDropped = 0;
			SessionDb.highestCombo   = 0;
		}
		
	}

}