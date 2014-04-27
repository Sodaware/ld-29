package particles
{
	import org.flixel.*;
	import db.ResourceDb;
	
	public class ExplosionParticle extends FlxSprite
	{
		
		public var isDepthChargeExplosion:Boolean;
		public var isEnemyExplosion:Boolean;
		
		override public function update() : void
		{
			super.update();
		}
		
		override public function ExplosionParticle(xPos:Number, yPos:Number) : void
		{
			super(xPos, yPos);
			
			this.loadGraphic(ResourceDb.gfx_ExplosionSmall, true, false, 4, 4);
			this.addAnimation("splode1", [0, 1, 2, 3, 5], 8, false);
			this.addAnimation("splode2", [0, 1, 2, 3, 5], 10, false);
			this.addAnimation("splode3", [0, 1, 2, 3, 5], 12, false);
			this.addAnimation("splode4", [0, 1, 2, 3, 5], 14, false);
			this.addAnimation("splode5", [4, 4, 0, 1, 2, 3, 5], 8, false);
			this.addAnimation("splode6", [4, 4, 0, 1, 2, 3, 5], 10, false);
			this.addAnimation("splode7", [4, 4, 0, 1, 2, 3, 5], 12, false);
			this.addAnimation("splode8", [4, 4, 0, 1, 2, 3, 5], 14, false);
				
			this.alpha = 0.8;
			this.play("splode" + (1 + (Math.floor(Math.random() * 8)))) ;
			
		}
		
	}
	
}