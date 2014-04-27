package screens
{
	import db.ContentDb;
	import db.ResourceDb;
	import db.SessionDb;
	import entities.EnemySubmarine;
	import game.StageData;
	import org.flixel.*;
	import particles.FireworkParticle;
	
	public class MissionFailedOverlay extends ScreenOverlay
	{
		
		// Labels and such
		private var missionStatusLabel:FlxText;
		
		private var _timer:int = 600;
		
		
		// ----------------------------------------------------------------------
		// -- Updating / Rendering
		// ----------------------------------------------------------------------
		
		override public function update():void 
		{
			
			super.update();
			
			this._timer--;
			
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
		
		public function MissionFailedOverlay() : void
		{
			
			super();
			
			this.missionStatusLabel = new FlxText(0, 120, FlxG.width, "Mission Failed", true);
			this.missionStatusLabel.alignment = "center";
			
			this.add(this.missionStatusLabel);
			
		}
		
		
	}

}