package particles
{
	import org.flixel.*;
	
	public class WaterSplashParticle extends FlxParticle
	{
		
		override public function update() : void
		{
			
			super.update();
			
			if (!this.visible) {
				return;
			}
			
			
			this.alpha = this.alpha - 0.005;
			
			// Collide with surface
			if (this.y >= 71) {
				this.kill();
			}
			
		}
		
		override public function WaterSplashParticle() : void
		{
			super();
			this.makeGraphic(1, 1);
			this.color = 0xFFFFFF;
		}
		
		override public function onEmit():void 
		{
			super.onEmit();
			
			// Randomize the appearance
			this.alpha = 1 - (0.5 * Math.random());
			this.velocity.x = -10 + (20 * Math.random());
			this.acceleration.x = 0;
			
			
			this.velocity.y = -50 + (20 * Math.random());
			this.acceleration.y = 100 + (20 * Math.random());
			
		}
		
	}
	
}