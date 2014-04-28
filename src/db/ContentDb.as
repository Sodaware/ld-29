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
		// total sonars (-1 = disabled), mine frequency (0 = no mines), aggression
		
		public static var levels:Array = [
		
			// Level 1 - 4 stages
			[1, 1, ContentDb.LEVEL_TYPE_SUNNY, 2, 60, 0, 1,   0, -1, 0, 0],
			[1, 2, ContentDb.LEVEL_TYPE_SUNNY, 3, 60, 0, 1,   0, -1, 0, 0],
			[1, 3, ContentDb.LEVEL_TYPE_SUNNY, 4, 60, 1, 1,   0, -1, 0, 0],
			[1, 4, ContentDb.LEVEL_TYPE_SUNNY, 5, 60, 2, 1.1, 0, -1, 0, 0],
			
			// Level 2
			[2, 1, ContentDb.LEVEL_TYPE_SUNNY, 2, 50, 5, 1.2, 0, -1, 0, 1],
			[2, 2, ContentDb.LEVEL_TYPE_SUNNY, 3, 50, 5, 1.2, 0, -1, 0, 1],
			[2, 3, ContentDb.LEVEL_TYPE_SUNNY, 4, 50, 5, 1.2, 0, -1, 0, 1.5],
			[2, 4, ContentDb.LEVEL_TYPE_SUNNY, 5, 50, 5, 1.2, 0, -1, 0, 2],
			
			// Level 3
			[3, 1, ContentDb.LEVEL_TYPE_SUNSET, 2, 50, 5, 1.2, 20, -1, 1, 2],
			[3, 2, ContentDb.LEVEL_TYPE_SUNSET, 3, 50, 5, 1.2, 15, -1, 1, 2],
			[3, 3, ContentDb.LEVEL_TYPE_SUNSET, 4, 50, 5, 1.2, 15, -1, 1, 2],
			[3, 4, ContentDb.LEVEL_TYPE_SUNSET, 5, 50, 5, 1.1, 10, -1, 1, 4],
			
			// Level 4
			[4, 1, ContentDb.LEVEL_TYPE_NIGHT, 1, 60, 0, 1, 0, 10, 0, 0],
			[4, 2, ContentDb.LEVEL_TYPE_NIGHT, 1, 60, 0, 1, 0, 8, 0, 0],
			[4, 3, ContentDb.LEVEL_TYPE_NIGHT, 1, 60, 0, 1, 0, 6, 0, 0],
			[4, 4, ContentDb.LEVEL_TYPE_NIGHT, 1, 60, 0, 1, 0, 4, 0, 0],
			
			// Level 5
			[5, 1, ContentDb.LEVEL_TYPE_SUNNY, 4,  50, 10, 1.2, 0, -1, 2, 2],
			[5, 2, ContentDb.LEVEL_TYPE_SUNNY, 8,  50, 10, 1.2, 0, -1, 3, 3],
			[5, 3, ContentDb.LEVEL_TYPE_SUNNY, 12, 50, 20, 1.2, 0, -1, 4, 4],
			[5, 4, ContentDb.LEVEL_TYPE_SUNNY, 16, 50, 20, 1.2, 0, -1, 5, 5],
			
			// Level 6
			[6, 1, ContentDb.LEVEL_TYPE_SUNSET, 4,  45, 0, 1.4, 16, 10, 4, 1],
			[6, 2, ContentDb.LEVEL_TYPE_SUNSET, 8,  60, 0, 1.4, 16, 8, 4, 2],
			[6, 3, ContentDb.LEVEL_TYPE_SUNSET, 12, 75, 0, 1.4, 16, 6, 4, 3],
			[6, 4, ContentDb.LEVEL_TYPE_SUNSET, 16, 90, 0, 104, 16, 4, 4, 4],
			
			// Level 4
			[7, 1, ContentDb.LEVEL_TYPE_NIGHT, 2, 45, 0, 1, 4, 4, 0, 0],
			[7, 2, ContentDb.LEVEL_TYPE_NIGHT, 3, 50, 0, 1, 6, 6, 0, 0],
			[7, 3, ContentDb.LEVEL_TYPE_NIGHT, 4, 55, 0, 1, 8, 8, 0, 0],
			[7, 4, ContentDb.LEVEL_TYPE_NIGHT, 5, 60, 0, 1, 10, 10, 0, 0]
			
		];
		
	}
	
}