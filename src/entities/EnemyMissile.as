package entities
{
	import org.flixel.*;
	import db.ResourceDb;
	
	public class EnemyMissile extends FlxSprite
	{
		
		public var isExploding:Boolean = false;
		
		override public function update() : void
		{
			super.update();
			
		}
		
	
		
		public function propellerX() : int
		{
			return this.x + 3;
		}
		
		public function propellerY() : int
		{
			return this.y + 8;
		}		
		
		public function makeDead() : void
		{
		
		}
		
		override public function EnemyMissile(xPos:Number, yPos:Number, speed:Number = 1) : void
		{
			
			super(xPos, yPos);
			
			this.loadGraphic(ResourceDb.gfx_Missile, true, false, 6, 8);
			this.addAnimation("spin", [0, 1, 2, 3], 10);
			this.play("spin");
			this.velocity.y = -10;
			
		}
		
	}
	
}