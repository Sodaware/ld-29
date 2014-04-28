package screens
{
	import db.ResourceDb;
	import db.SessionDb;
	import org.flixel.*;
	import particles.BubbleParticle;
	
	public class TitleScreenState extends FlxState
	{
		
		private var _bgSky:FlxSprite;
		private var _bgSea:FlxSprite;
		private var _bgClouds:FlxGroup;
		private var _bubbles:FlxEmitter;
		
		private var _logo:FlxSprite;
		private var _pushStart:FlxText;
		
		private var _credits:FlxText;
		private var _date:FlxText;
		
		
		// ----------------------------------------------------------------------
		// -- Updating / Rendering
		// ----------------------------------------------------------------------
		
		override public function update():void 
		{
			
			super.update();
			
			if (Math.random() > 0.9) {
				this._bubbles.x = (Math.random() * FlxG.width);
				this._bubbles.emitParticle();
			}
			
			if (FlxG.keys.justPressed("SPACE")) {
				SessionDb.resetSession();
				FlxG.switchState(new PlayScreenState());
			}
			
		}
		
		
		// ----------------------------------------------------------------------
		// -- Construction
		// ----------------------------------------------------------------------
		
		override public function create():void
		{
			
			super.create();
			
			// Background
			this._bgSky         = new FlxSprite(0, 0, ResourceDb.gfx_DaySky);
			
			// Add some clouds
			this._bgClouds = new FlxGroup();
			for (var i:int = 0; i < 5; i++) {
				var cloud:FlxSprite = new FlxSprite(FlxG.width, Math.floor(Math.random() * 40));
				cloud.loadGraphic(ResourceDb.gfx_DayClouds, true, false, 42, 4);
				cloud.frame = Math.floor(Math.random() * 5);
				cloud.velocity.x = -1 * (Math.random() * 2);
				cloud.x = (Math.random() * FlxG.width);
				cloud.alpha = 0.8;
				this._bgClouds.add(cloud);
			}
			
			// Create the sea
			this._bgSea         = new FlxSprite(0, 71, ResourceDb.gfx_DaySea);
			
			this._bubbles = new FlxEmitter(0, FlxG.height - 4, 250);
			this._bubbles.setRotation(0, 0);
			this._bubbles.lifespan = 2;
			this._bubbles.particleClass = BubbleParticle;
			
			for (var i:int = 0; i < 250; i++) {
				this._bubbles.add(new BubbleParticle());
			}

			
			this._logo = new FlxSprite(21, 21, ResourceDb.gfx_Logo);
			
			this._pushStart = new FlxText(0, 180, FlxG.width, "Push Space", true);
			this._pushStart.alignment = "center";
			this._pushStart.font = "tinyfont";
			this._pushStart.shadow = 0x88000000;
			this._pushStart.size = 20;
			
			this._credits = new FlxText(0, FlxG.height - 15, FlxG.width / 2, "sodaware.net", true);
			this._credits.alignment = "left";
			this._credits.font = "tinyfont";
			this._credits.shadow = 0x88000000;
			this._credits.size = 10;
			
			this._date = new FlxText(FlxG.width / 2, FlxG.height - 15, FlxG.width / 2, "Ludum Dare #29", true);
			this._date.alignment = "right";
			this._date.font = "tinyfont";
			this._date.shadow = 0x88000000;
			this._date.size = 10;

			
			this.add(this._bgSea);
			this.add(this._bgSky);
			this.add(this._bgClouds);
			
			this.add(this._bubbles);
			
			this.add(this._logo);
			this.add(this._pushStart);
			
			this.add(this._credits);
			this.add(this._date);
			
		}
		
		
	}

}