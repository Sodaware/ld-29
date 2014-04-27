package screens
{
	import db.ContentDb;
	import db.ResourceDb;
	import db.SessionDb;
	import entities.EnemySubmarine;
	import game.StageData;
	import org.flixel.*;
	import particles.FireworkParticle;
	import particles.ScoreFlyoffParticle;
	
	public class LevelCompleteOverlay extends ScreenOverlay
	{
		
		// Labels and such
		private var levelCompleteLabel:FlxText;
		private var subsDestroyedLabel:FlxText;
		private var bonusTimeLabel:FlxText;
		
		private var _fireworks:FlxEmitter;
		
		private var _parent:PlayScreenState;
		private var _timer:int = 600;
		
		
		// ----------------------------------------------------------------------
		// -- Updating / Rendering
		// ----------------------------------------------------------------------
		
		override public function update():void 
		{
			
			super.update();
			
			this._timer --;
			
			// Make some fireworks
			if (Math.random() > 0.995) {
				
				this._fireworks.x = (FlxG.width * Math.random());
				this._fireworks.y = (32 * Math.random());
				
				for (var i:int = 0; i < 50; i++) {
					this._fireworks.emitParticle();
				}
			}
			
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
		
		public function LevelCompleteOverlay(parent:PlayScreenState) : void
		{
			
			super();
			
			this.levelCompleteLabel = new FlxText(0, 120, FlxG.width, "Mission Complete", true);			
			this.subsDestroyedLabel = new FlxText(0, 140, FlxG.width, "Destroyed: " + parent.destroyedSubs, true);
			this.bonusTimeLabel = new FlxText(0, 160, FlxG.width, "Time Bonus: " + parent.timeRemaining + " x 10" , true);
			
			this.levelCompleteLabel.alignment = "center";
			this.subsDestroyedLabel.alignment = "center";
			this.bonusTimeLabel.alignment = "center";
			
			this._fireworks = new FlxEmitter(0, 0, 250);
			this._fireworks.setRotation(0, 0);
			
			this._fireworks.lifespan = 2;
			this._fireworks.particleClass = FireworkParticle;
			
			for (var i:int = 0; i < 250; i++) {
				this._fireworks.add(new FireworkParticle());
			}
			
			this._parent = parent;
			
			this.add(this._fireworks);
			
			this.add(this.levelCompleteLabel);
			this.add(this.subsDestroyedLabel);
			this.add(this.bonusTimeLabel);
			
			this.add(new ScoreFlyoffParticle(this._parent.player.x + (this._parent.player.width / 2), this._parent.player.y, "" + (parent.timeRemaining * 10)));
			
			
			
		}
		
		
	}

}