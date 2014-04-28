package entities
{
	import org.flixel.*;
	import db.ResourceDb;
	
	public class DepthCharge extends FlxSprite
	{
		
		public static const POWERUP_NORMAL:int       = 0;
		public static const POWERUP_EXTRA_BOMB:int   = 1;
		public static const POWERUP_EXTRA_SONAR:int  = 2;
		public static const POWERUP_EXTRA_TIME:int   = 3;
		public static const POWERUP_SMART_BOMB:int   = 4;
		public static const POWERUP_MEGA_BARREL:int  = 5;
		public static const POWERUP_MISSILE_BOMB:int = 6;
		public static const POWERUP_CLUSTER_BOMB:int = 7;
		public static const POWERUP_HOMING_BOMB:int  = 8;
		
		public var type:int = 0;
		public var lifespan:int;
		public var onDetonateCallback:Function;
		
		public var target:EnemySubmarine;
		
		override public function update() : void
		{
			super.update();
			
			if (this.lifespan > 0) {
				this.lifespan--;
				if (this.lifespan == 0) {
					this.onDetonateCallback(this);
				}
			}
			
			if (this.type == POWERUP_HOMING_BOMB) {
				
				if (this.target) {
					
					if (this.target.x < this.x) {
						this.acceleration.x = -5;
					}
					
					if (this.target.x > this.x) {
						this.acceleration.x = 5;
					}
					
				}
				
			}
		}
		
		public function drop(xPos:Number, yPos:Number, powerup:int = 0) : void
		{
			
			this.x = xPos;
			this.y = yPos;
			
			this.visible = true;
			
			this.type = powerup;
			
			this.acceleration.x = 0;
			this.velocity.x = 0;
			this.acceleration.y = 9.8;
			this.maxVelocity.y  = 98;

		}
		
		
		public static function createClusterPart(xPos:Number, yPos:Number, xSpeed:Number, ySpeed:Number, callback:Function) : DepthCharge
		{
			var charge:DepthCharge = new DepthCharge(xPos, yPos);
			
			charge.lifespan = 200;
			charge.velocity.x = xSpeed;
			charge.velocity.y = ySpeed;
			charge.onDetonateCallback = callback;
			
			return charge;
			
		}
		
		public static function createHomingPart(target:EnemySubmarine, xPos:Number, yPos:Number, xSpeed:Number, ySpeed:Number, callback:Function) : DepthCharge
		{
			
			var charge:DepthCharge = new DepthCharge(xPos, yPos);
			charge.type = POWERUP_HOMING_BOMB;
			charge.target = target;
			charge.lifespan = 500;
			charge.velocity.x = xSpeed;
			charge.velocity.y = ySpeed;
			charge.acceleration.y = 5;
			charge.onDetonateCallback = callback;
			
			return charge;
			
		}
		
		public function explosionRadius() : int
		{
			return (this.type == POWERUP_MEGA_BARREL) ? 32 : 12;
		}
		
		public function explosionSize() : int
		{
			return (this.type == POWERUP_MEGA_BARREL) ? 32 : 8;
		}

		
		override public function DepthCharge(xPos:Number, yPos:Number, type:int = 0) : void
		{
			
			super(xPos, yPos);
			
			this.loadGraphic(ResourceDb.gfx_Missile, true, false, 6, 8);
			this.loadGraphic(ResourceDb.gfx_DepthCharge, true, false, 6, 6);
			this.addAnimation("spin", [0, 1, 2, 3], 5, true);
			this.play("spin");
			
		}
		
	}
	
}