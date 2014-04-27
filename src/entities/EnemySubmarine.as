package entities
{
	import org.flixel.*;
	import db.ResourceDb;
	
	public class EnemySubmarine extends FlxSprite
	{
		
		public static const DIRECTION_LEFT:int  = 1;
		public static const DIRECTION_RIGHT:int = 2;
		
		public var isExploding:Boolean = false;
		public var isSunk:Boolean = false;
		private var _direction:int;
		public var aggression:Number;
		
		
		public function get direction():int 
		{
			return this._direction;
		}
		
		override public function update() : void
		{
			super.update();
			
			if (this.y >= 274) {
				this.isSunk = true;
				this.stop();
			}
			
			// Wrap!
			if (this.direction == DIRECTION_LEFT && this.x < 0 - this.width) {
				this.x = FlxG.width + (Math.random() * 10);
			}
			
			if (this.direction == DIRECTION_RIGHT && this.x > FlxG.width) {
				this.x = 0 - this.width - (Math.random() * 10);
			}
			
		}
		
		public function stop() : void
		{
			this.velocity.x = 0;
			this.velocity.y = 0;
			
			this.acceleration.x = 0;
			this.acceleration.y = 0;
		}
		
		public function propellerX() : int
		{
			return (this._direction == DIRECTION_LEFT) ? this.x + this.width : this.x;
		}
		
		public function propellerY() : int
		{
			return this.y + 6;
		}
		
		public function damage(d:int) : void
		{
			this.health -= d;
			
			if (this.health <= 0) {
				this.makeDead();
			}
		}
		
		public function makeDead() : void
		{
			this.health = 0;
			this.acceleration.y = 5;
			this.velocity.x = (this.velocity.x / 2);
			this.isExploding = true;
		}
		
		override public function EnemySubmarine(yPos:Number) : void
		{
			
			super(0, yPos);
			this.health = 1;
			
			this.maxVelocity.y = 50;
			
			//
			this._direction = (Math.random() > 0.5) ? DIRECTION_LEFT : DIRECTION_RIGHT;
			
			switch (this._direction) {
				
				case DIRECTION_LEFT:
					this.loadGraphic(ResourceDb.gfx_SubmarineLeft);
					this.velocity.x = -10;
					this.x = FlxG.width + 5;
					break;
				
				case DIRECTION_RIGHT:
					this.loadGraphic(ResourceDb.gfx_SubmarineRight);
					this.velocity.x = 10;
					this.x = 0 - this.width;
					break;
				
			}
			
		}
		
	}
	
}