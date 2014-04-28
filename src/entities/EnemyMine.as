package entities
{
	import org.flixel.*;
	import db.ResourceDb;
	
	public class EnemyMine extends FlxSprite
	{
		private var _startY:Number;
		private var _waveOffset:Number;
		
		private var _isFalling:Boolean;
		
		public var onDetonateCallback:Function;
		public var onLandCallback:Function;
		
		override public function update() : void
		{
			
			super.update();
			
			if (this._isFalling) {
				
				if (this.y >= 70) {
					this._isFalling = false;
					this.acceleration.y = 0;
					this.velocity.y = 0;
					this._isFalling = false;
					this.onLandCallback(this);
					this._startY = this.y;
				}
				
			} else {
				
				this._waveOffset += 0.01;
				this.y = (this._startY + (1 * Math.sin(this._waveOffset)));
				
				this.health--;
				
				if (this.health == 500) {
					this.play("flash_medium");
				} else if (this.health == 200) {
					this.play("flash_fast");
				}
				
				if (this.health <= 0) {
					this.detonate();
				}
				
			}
			
		}
		
		public function detonate() : void
		{
			this.onDetonateCallback(this);
		}
		
		public function makeDead() : void
		{
		
		}
		
		override public function EnemyMine(xPos:Number, yPos:Number) : void
		{
			
			super(xPos, yPos);
			
			this.loadGraphic(ResourceDb.gfx_Mine, true, false, 9, 9);
			this.addAnimation("flash_slow", [0, 1], 0.5);
			this.addAnimation("flash_medium", [0, 1], 5);
			this.addAnimation("flash_fast", [0, 1], 10);
			this.play("flash_slow");
			
			this._startY     = this.y;
			this._waveOffset = 180 * Math.random();
			
			this.health = 1000;
			
			this.acceleration.y = 9.8;
			this.velocity.y = 20;
			this._isFalling = true;
			
		}
		
	}
	
}