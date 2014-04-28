package entities
{
	import org.flixel.*;
	import db.ResourceDb;
	
	public class PowerupCrate extends FlxSprite
	{
		private var _startX:Number;
		private var _waveOffset:Number;
		
		private var _isFalling:Boolean;
		
		override public function update() : void
		{
			
			super.update();
			
			if (this._isFalling) {
				this._waveOffset += 0.05;
				this.x = (this._startX + (10 * Math.sin(this._waveOffset)));
			}
			
		}
		
		public function respawn() : void
		{
			this.x = 10 + (Math.random() * (FlxG.width - 20));
			this.y = -32;
			
			this._startX = this.x;
			this.visible = true;
			
			this.acceleration.y = 1;
			this.velocity.y = 10;
			
			this._isFalling = true;
			this._waveOffset = Math.random() * 180;
			
		}
		
		override public function PowerupCrate(xPos:Number) : void
		{
			
			super(xPos, -32);
			
			this.loadGraphic(ResourceDb.gfx_PowerupCrate, true, false, 13, 18);
			this.addAnimation("falling", [0, 2, 0, 1], 2);
			this.play("falling");
			
			this._startX = this.x;
			
			this.acceleration.y = 1;
			this.velocity.y = 10;
			
			this._isFalling = true;
			this._waveOffset = Math.random() * 180;
			
		}
		
	}
	
}