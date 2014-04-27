package entities
{
	import org.flixel.*;
	import db.ResourceDb;
	
	public class Fish extends FlxSprite
	{
		
		public static const DIRECTION_LEFT:int  = 1;
		public static const DIRECTION_RIGHT:int = 2;
		
		private var _xOffset:int;
		private var _startY:Number;
		private var _startX:Number;
		private var _waveOffset:Number;
		public var isDead:Boolean = false;
		
		private var _direction:int;
		
		public function get direction():int 
		{
			return this._direction;
		}
		
		override public function update() : void
		{
			super.update();
			
			// Make it move! (if it's alive)
			if (!this.isDead) {
				
				this._waveOffset += 0.01;
				this.y = (this._startY + (1 * Math.sin(this._waveOffset)));
				
				// Wrap!
				if (this.direction == DIRECTION_LEFT && this.x < 0 - this.width) {
					this.x = FlxG.width + (Math.random() * 10);
				}
				
				if (this.direction == DIRECTION_RIGHT && this.x > FlxG.width) {
					this.x = 0 - this.width - (Math.random() * 10);
				}
				
				// Turn around?
				if (Math.abs(this._startX - this.x) > 50) {
					this.flip();
				}
				
				
				
			} else {
				
				if (this.y <= 71) {
					this.acceleration.y = 0;
					this.velocity.y     = 0;
				}
				
				if (this.velocity.y < -100) {
					this.acceleration.y = 0;
				}
				
			}
			
		}
		
		public function flip() : void
		{
			
			this._direction = (this._direction == DIRECTION_RIGHT) ? DIRECTION_LEFT : DIRECTION_RIGHT;
			
			switch (this._direction) {
				
				case DIRECTION_LEFT:
					this.x--;
					this.velocity.x = -5 + (Math.random() * -5);
					this.frame = 0;
					break;
				
				case DIRECTION_RIGHT:
					this.x++;
					this.velocity.x = 5 + (Math.random() * 5);
					this.frame = 3;
					break;
				
			}
			
		}
		
		public function makeDead() : void
		{
			this.isDead = true;
			this.acceleration.y = -5;
			this.maxVelocity.y = 100;
			this.velocity.x = 0;
		}
		
		override public function Fish() : void
		{
			
			// Create somewhere random
			super(Math.random() * 224, 90 + (180 * Math.random()));
			this.loadGraphic(ResourceDb.gfx_Fish, false, false, 5, 3);
			
			// Set up WAVEY motion
			this._startX     = this.x;
			this._startY     = this.y;
			this._waveOffset = 180 * Math.random();
			
			// Choose a random direction
			this._direction = (Math.random() > 0.5) ? DIRECTION_LEFT : DIRECTION_RIGHT;
			
			switch (this._direction) {
				
				case DIRECTION_LEFT:
					this.velocity.x = -5 + (Math.random() * -5);
					this.frame = 0;
					break;
				
				case DIRECTION_RIGHT:
					this.velocity.x = 5 + (Math.random() * 5);
					this.frame = 3;
					break;
				
			}
			
		}
		
	}
	
}