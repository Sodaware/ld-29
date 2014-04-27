package screens
{
	import db.ContentDb;
	import db.ResourceDb;
	import db.SessionDb;
	import entities.EnemySubmarine;
	import game.StageData;
	import org.flixel.*;
	
	public class LevelStartOverlay extends ScreenOverlay
	{
		
		private var levelLabel:FlxText;
		private var enemiesLabel:FlxText;
		private var timeLimitLabel:FlxText;
		
		private var _timer:int = 120;
		
		
		// ----------------------------------------------------------------------
		// -- Updating / Rendering
		// ----------------------------------------------------------------------
		
		override public function update():void 
		{
			
			super.update();
			
			this._timer --;
			
			if (FlxG.keys.justPressed("SPACE") && this._timer < 30) {
				this._isFinished = true;
			}
			
			if (this._timer < 0) {
				this._isFinished = true;
			}
			
		}
		
		
		// ----------------------------------------------------------------------
		// -- Construction
		// ----------------------------------------------------------------------
		
		public function LevelStartOverlay() : void
		{
			
			var level:StageData = ContentDb.getLevel(SessionDb.currentLevel);
			
			super();
			
			this.levelLabel = new FlxText(0, 120, FlxG.width, "Mission " + level.levelNumber + "-" + level.stageNumber, true);
			this.levelLabel.alignment = "center";
			
			this.enemiesLabel = new FlxText(0, 140, FlxG.width, "Destroy " + level.targetEnemies + " Subs", true);
			this.enemiesLabel.alignment = "center";
			
			this.timeLimitLabel = new FlxText(0, 160, FlxG.width, "in under " + level.timeLimit + " seconds", true);
			this.timeLimitLabel.alignment = "center";
			
			this.add(this.levelLabel);
			this.add(this.enemiesLabel);
			this.add(this.timeLimitLabel);
			
		}
		
		
	}

}