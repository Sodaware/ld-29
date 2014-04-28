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
		private var extraRulesLabel:FlxText;
		
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
			
			this.levelLabel = new FlxText(0, 100, FlxG.width, "Mission " + level.levelNumber + "-" + level.stageNumber, true);
			this.levelLabel.alignment = "center";
			
			this.enemiesLabel = new FlxText(0, 140, FlxG.width, "Destroy " + level.targetEnemies + " Subs", true);
			this.enemiesLabel.alignment = "center";
			
			this.timeLimitLabel = new FlxText(0, 160, FlxG.width, "in under " + level.timeLimit + " seconds", true);
			this.timeLimitLabel.alignment = "center";
			
			this.extraRulesLabel = new FlxText(0, 180, FlxG.width, "", true);
			this.extraRulesLabel.alignment = "center";
			
			if (level.chargeLimit > 0) {
				this.extraRulesLabel.text += "with only " + level.chargeLimit;
				this.extraRulesLabel.text += (level.chargeLimit == 1) ? " depth charge" : " depth charges";
				this.extraRulesLabel.text += "\n\n";
			}
			
			if (level.sonarLimit > 0) {
				this.extraRulesLabel.text += "only " + level.sonarLimit;
				this.extraRulesLabel.text += (level.sonarLimit == 1) ? " sonar available" : " sonars available";
				this.extraRulesLabel.text += "\n";
			}
			
			this.levelLabel.font = "tinyfont";
			this.levelLabel.size = 20;
			
			this.enemiesLabel.font = "tinyfont";
			this.enemiesLabel.size = 10;
			
			this.timeLimitLabel.font = "tinyfont";
			this.timeLimitLabel.size = 10;
			
			this.extraRulesLabel.font = "tinyfont";
			this.extraRulesLabel.size = 10;
			
			this.add(this.levelLabel);
			this.add(this.enemiesLabel);
			this.add(this.timeLimitLabel);
			this.add(this.extraRulesLabel);
			
		}
		
		
	}

}