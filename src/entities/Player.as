package entities
{
	import org.flixel.*;
	import db.ResourceDb;
	
	public class Player extends FlxSprite
	{
		
		public var isExploding:Boolean = false;
		public var isSunk:Boolean = false;
		public var _damageTimer:int = 0;
		public var maxHealth:int = 5;
		
		public function isDead() : Boolean
		{
			return (this.isExploding || this.isSunk);
		}
		
		override public function update() : void
		{
			
			super.update();
			
			if (this.y >= 274) {
				this.isSunk = true;
				this.stop();
			}
			
			this._damageTimer--;
			
		}
		
		public function isDamaged() : Boolean
		{
			return (this.health < this.maxHealth);
		}
		
		public function damage(amount:int) : void
		{
			
			if (this._damageTimer < 0) {
				this._damageTimer = 60;
				this.health -= amount;
			}
			
		}
		
		public function stop() : void
		{
			this.velocity.x = 0;
			this.velocity.y = 0;
			
			this.acceleration.x = 0;
			this.acceleration.y = 0;
		}
		
		public function makeDead() : void
		{
			this.health = 0;
			this.acceleration.y = 5;
			this.velocity.x = (this.velocity.x / 2);
			this.isExploding = true;
		}
		
		override public function Player(xPos:Number, yPos:Number, graphic:Class) : void
		{
			super(xPos, yPos, graphic);
			
			this.health = this.maxHealth;
		}
		
	}
	
}