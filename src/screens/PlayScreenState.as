package screens
{
	import db.ResourceDb;
	import org.flixel.*;
	
	public class PlayScreenState extends FlxState
	{
		
		// Background
		private var _bgSky:FlxSprite;
		private var _bgClouds:FlxGroup;
		private var _bgSea:FlxSprite;
		
		// Player
		private var _player:FlxSprite;
		
		// Enemies
		private var _enemy:FlxSprite;
		
		private var _charge:FlxSprite;
		private var isDroppingCharge:Boolean = false;
		
		// ----------------------------------------------------------------------
		// -- Updating / Rendering
		// ----------------------------------------------------------------------
		
		override public function update():void 
		{
			super.update();
			
			// Player movement
			if (FlxG.keys.pressed("LEFT")) {
				this._player.acceleration.x -= 2.5;
				if (this._player.acceleration.x < -25) {
					this._player.acceleration.x = -25;
				}
				
			} else if (FlxG.keys.pressed("RIGHT")) {
				this._player.acceleration.x += 2.5;
				if (this._player.acceleration.x > 25) {
					this._player.acceleration.x = 25;
				}
				
			} else {
				this._player.acceleration.x = 0;
			}
			
			// Dropping and detonating a charge
			if (FlxG.keys.justPressed("SPACE")) {
				if (this.isDroppingCharge) {
					this.detonateCharge();
				} else {
					this.dropCharge();
				}
			}
			
		}
		
		
		public function dropCharge() : void
		{
			this.isDroppingCharge = true;
			
			this._charge.x = this._player.x + 24;
			this._charge.y = 66;
			
			this._charge.visible = true;
			
			this._charge.acceleration.y = 9.8;
			this._charge.maxVelocity.y  = 98;
		}
		
		public function detonateCharge() : void
		{
			
			// Can spawn again
			this.isDroppingCharge = false;
			
			// Hide the charge
			this._charge.visible        = false;
			this._charge.velocity.y     = 0;
			this._charge.acceleration.y = 0;
			
			// Spawn some explosions
			
			// Check for any submarines nearby
			if (this._enemy.overlaps(this._charge)) {
				this._enemy.visible = false;
			}
			
		}
		
		// ----------------------------------------------------------------------
		// -- Construction
		// ----------------------------------------------------------------------
		
		override public function create():void
		{
			
			super.create();
			
			// Create the initial sky
			this._bgSky = new FlxSprite(0, 0, ResourceDb.gfx_DaySky);
			
			// Add some clouds
			this._bgClouds = new FlxGroup();
			for (var i:int = 0; i < 5; i++) {
				var cloud:FlxSprite = new FlxSprite(FlxG.width, Math.floor(Math.random() * 28));
				cloud.loadGraphic(ResourceDb.gfx_DayClouds, true, false, 42, 4);
				cloud.frame = Math.floor(Math.random() * 5);
				cloud.velocity.x = -1 * (Math.random() * 2);
				cloud.x = (Math.random() * FlxG.width);
				this._bgClouds.add(cloud);
			}
			
			
			// Create the sea
			this._bgSea = new FlxSprite(0, 71, ResourceDb.gfx_DaySea);
			
			// Add some objects
			this._player = new FlxSprite((FlxG.width - 48) / 2, 55, ResourceDb.gfx_Player);
			this._player.drag.x = 10;
			
			this._player.maxVelocity.x = 25;
			
			this._charge = new FlxSprite(-100, -100);
			this._charge.loadGraphic(ResourceDb.gfx_DepthCharge, true, false, 6, 6);
			this._charge.addAnimation("spin", [0, 1, 2, 3], 5, true);
			this._charge.play("spin");
			this._charge.visible = false;
			
			this._enemy = new FlxSprite(0, 140, ResourceDb.gfx_Submarine);
			this._enemy.velocity.x = 10;
			
			// Add everything!
			this.add(this._bgSky);
			this.add(this._bgClouds);
			this.add(this._bgSea);
			
			this.add(this._player);
			this.add(this._enemy);
			this.add(this._charge);
			
		}
		
		
	}

}