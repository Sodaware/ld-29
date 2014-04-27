package particles
{
	import org.flixel.*;
	import db.ResourceDb;
	
	public class ScoreFlyoffParticle extends FlxText
	{
		
		
		
		override public function update() : void
		{
			super.update();
			
			this.alpha -= 0.01;
			
			if (this.velocity.y > 0) {
				this.health = 0;
				this.kill();
			}
			
		}
		
		override public function ScoreFlyoffParticle(xPos:Number, yPos:Number, value:String, isNegative:Boolean = false) : void
		{
			
			super(xPos - 30, yPos, 60, value);
			
			this.velocity.y = -10;
			this.acceleration.y = 5;
			
			this.alignment = "center";
			this.font = "tinyfont";
			this.size = 10;
			
			if (isNegative) {
				this.color = 0x880000;
			}
			
		}
		
	}
	
}