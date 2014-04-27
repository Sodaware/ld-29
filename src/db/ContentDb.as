package db 
{
	import game.StageData;
	
	public class ContentDb 
	{
		
		public static function getLevel(id:int) : StageData
		{
			// [todo] - Add a range check!
			return new StageData(ContentDb.levels[id]);
		}
		
		// Possible states
		// day, evening, sunset, night
		// number of enemies, must destroy at least, number of fish
		// enemy speed
		// total charges
		// has mines
		// mine frequency
		// total sonars
		
		public static const LEVEL_TYPE_SUNNY:int  = 1;
		public static const LEVEL_TYPE_SUNSET:int = 2;
		public static const LEVEL_TYPE_NIGHT:int  = 3;
		
		// level, stage, Level type, number of enemies to splode, time limit, wildlife, speed multiplier, total depth charges (0 = unlimited)
		// mine frequency (0 = no mines), total sonars (-1 = disabled), aggression
		
		public static var levels:Array = [
		
			// Level 1 - 4 stages and then a bonus
			[1, 1, ContentDb.LEVEL_TYPE_SUNNY, 1, 60, 0, 1,   0, -1, 0, 0],
			[1, 2, ContentDb.LEVEL_TYPE_SUNNY, 3, 60, 0, 1,   0, -1, 0, 0],
			[1, 3, ContentDb.LEVEL_TYPE_SUNNY, 4, 60, 1, 1,   0, -1, 0, 0],
			[1, 4, ContentDb.LEVEL_TYPE_SUNNY, 5, 60, 2, 1.1, 0, -1, 0, 0],
			//[1, 5, ContentDb.LEVEL_TYPE_SUNNY, 50, 15, 2, 1.1, 0, -1, 0, 0],
			
		];
		
	}
	
}