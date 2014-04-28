package entities
{
	import org.flixel.*;
	import db.ResourceDb;
	
	public class EnemySubmarine extends FlxSprite
	{
		
		public static const DIRECTION_LEFT:int  = 1;
		public static const DIRECTION_RIGHT:int = 2;
		
		public var fireMissileCallback:Function;
		
		public var canUpdateAi:Boolean = true;
		public var isExploding:Boolean = false;
		public var isSunk:Boolean = false;
		private var _direction:int;
		public var aggression:Number;
		
		public var isReactingToPing:Boolean = false;
		private var _pingLength:Number;
		
		private var _missileTimer:int;
		
		
		public function get direction():int 
		{
			return this._direction;
		}
		
		public function reactToSonarPing(length:Number) : void
		{
			if (!this.isReactingToPing) {
				this.isReactingToPing = true;
				this._pingLength = length;
				this.alpha = 1;
			}
		}
		
		override public function update() : void
		{
			
			super.update();
			
			if (this.y >= 274 && !this.isSunk) {
				
				this.isSunk = true;
				
				FlxG.shake(0.005);
				FlxG.play(ResourceDb.snd_Explosions[Math.floor(Math.random() * ResourceDb.snd_Explosions.length)]);
				
				this.stop();
				
			}
			
			// Wrap!
			if (this.direction == DIRECTION_LEFT && this.x < 0 - this.width) {
				this.x = FlxG.width + (Math.random() * 10);
			}
			
			if (this.direction == DIRECTION_RIGHT && this.x > FlxG.width) {
				this.x = 0 - this.width - (Math.random() * 10);
			}
			
			if (this.canUpdateAi) {
				this.updateAi();
			}
			
			if (this.isReactingToPing) {
				this.alpha -= (1 / this._pingLength);
				
				if (this.alpha == 0) {
					this.isReactingToPing = false;
				}
			}
			
		}
		
		public function updateAi() : void
		{
			
			// Handle missile firing
			if (this.health > 0) {
				
				// Check if visible
				if (this.x > 0 && this.x < (FlxG.width - this.width)) {
					
					this._missileTimer--;
					
					// Only fire if not fired in last few seconds
					if (this.canFireMissile()) {
						
						this._missileTimer = 90;
						
						if (this.shouldFireMissile()) {
							this.fireMissile();
						}
					}
				}
				
			}
			
		}
		
		public function canFireMissile() : Boolean
		{
			
			// Has already fired recently
			if (this._missileTimer > 0) {
				return false;
			}
			
			// Not aggressive enough
			if (this.aggression == 0) {
				return false;
			}
			
			return true;
			
		}
		
		public function shouldFireMissile() : Boolean
		{
			
			// Roll two numbers (i.e. two 6 sided dice)
			var fireChance:Number = Math.ceil(6 * Math.random()) + Math.ceil(6 * Math.random());
			
			// Higher aggression means more likely to fire
			// (e.g. aggression of 12 will fire every time)
			return (fireChance <= this.aggression);
			
		}
		
		public function fireMissile() : void
		{
			this.fireMissileCallback(this);
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
			if (this.alpha < 1) {
				this.isReactingToPing = false;
				this.alpha = 0.5;
			}
			this.health = 0;
			this.acceleration.y = 4 + (2 * Math.random());
			this.velocity.x = (this.velocity.x / 2);
			this.isExploding = true;
		}
		
		override public function EnemySubmarine(yPos:Number) : void
		{
			
			super(0, yPos);
			this.health = 1;
			
			this._missileTimer  = 0;
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