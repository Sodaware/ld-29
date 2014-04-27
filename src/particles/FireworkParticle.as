package particles
{
	import org.flixel.*;
	
	public class FireworkParticle extends FlxParticle
	{
		
		override public function update() : void
		{
			super.update();
			
			this.alpha = this.alpha - 0.005;
			
			if (this.y > 71) {
				this.kill();
			}
		}
		
		override public function FireworkParticle() : void
		{
			super();
			this.makeGraphic(1, 1);
		}
		
		override public function onEmit():void 
		{
			super.onEmit();
			
			this.color = Math.random() * 0xFFFFFF;
			
			this.alpha = 1;
		}
	}
	
}