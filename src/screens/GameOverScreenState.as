package screens
{
	import db.ContentDb;
	import db.ResourceDb;
	import db.SessionDb;
	import org.flixel.*;
	
	public class GameOverScreenState extends FlxState
	{
		
		private var gameOverLabel:FlxText;
		private var subsDestroyedLabel:FlxText;
		private var totalScoreLabel:FlxText;
		private var droppedBombsLabel:FlxText;
		private var highestComboLabel:FlxText;
		private var pushSpace:FlxText;
		
		
		// ----------------------------------------------------------------------
		// -- Updating / Rendering
		// ----------------------------------------------------------------------
		
		override public function update():void 
		{
			
			super.update();
			
			if (FlxG.keys.justPressed("SPACE")) {
				if (SessionDb.score >= SessionDb.highScore && SessionDb.score > 0) {
					FlxG.switchState(new HighScoreScreenState());
				}
			}
			
		}
		
		
		// ----------------------------------------------------------------------
		// -- Construction
		// ----------------------------------------------------------------------
		
		override public function create():void
		{
			
			super.create();
			
			// Game over!
			this.gameOverLabel = new FlxText(0, 60, FlxG.width, "Game Over", true);
			this.gameOverLabel.font = "tinyfont";
			this.gameOverLabel.size = 20;
			this.gameOverLabel.alignment = "center";
			
			if (SessionDb.currentLevel == ContentDb.levels.length) {
				this.gameOverLabel.text = "Congratulations!";
			}
			
			this.subsDestroyedLabel = new FlxText(0, 100, FlxG.width, "Subs Destroyed: " + SessionDb.destroyedSubs, true);
			this.droppedBombsLabel  = new FlxText(0, 120, FlxG.width, "Charges Dropped: " + SessionDb.chargesDropped, true);
			this.highestComboLabel  = new FlxText(0, 140, FlxG.width, "Highest Combo: x " + SessionDb.highestCombo, true);
			this.totalScoreLabel    = new FlxText(0, 160, FlxG.width, "Final Score: " + SessionDb.score, true);
			
			this.pushSpace          = new FlxText(0, 200, FlxG.width, "Press Space to Continue", true);
			
			// Appearance
			this.subsDestroyedLabel.alignment = "center";
			this.droppedBombsLabel.alignment  = "center";
			this.highestComboLabel.alignment  = "center";
			this.totalScoreLabel.alignment    = "center";
			this.pushSpace.alignment          = "center";
			
			this.subsDestroyedLabel.font = "tinyfont";
			this.droppedBombsLabel.font  = "tinyfont";
			this.highestComboLabel.font  = "tinyfont";
			this.totalScoreLabel.font    = "tinyfont";
			this.pushSpace.font          = "tinyfont";
			
			this.subsDestroyedLabel.size = 10;
			this.droppedBombsLabel.size = 10;
			this.highestComboLabel.size = 10;
			this.totalScoreLabel.size = 10;
			this.pushSpace.size = 10;
			
			
			this.add(this.gameOverLabel);
			this.add(this.subsDestroyedLabel);
			this.add(this.droppedBombsLabel);
			this.add(this.highestComboLabel);
			this.add(this.totalScoreLabel);
			this.add(this.pushSpace);
			
			
			
		}
		
		
	}

}