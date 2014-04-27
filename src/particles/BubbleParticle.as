package particles
{
	import org.flixel.*;
	
	public class BubbleParticle extends FlxParticle
	{
		
		private var _waveOffset:Number;
		private var _startX:Number;
		
		override public function update() : void
		{
			super.update();
			
			if (!this.visible) {
				return;
			}
			
			// Update the bubble wave
			this._waveOffset += 0.01;
			this.x = (this._startX + (2 * Math.sin(this._waveOffset)));
			
			this.alpha = this.alpha - 0.005;
			
			// Collide with surface
			if (this.y <= 71) {
				this.kill();
			}
			
		}
		
		override public function BubbleParticle() : void
		{
			super();
			this.makeGraphic(1, 1);
			this.color = 0x85B0CB;
		}
		
		override public function onEmit():void 
		{
			super.onEmit();
			this.alpha = 1;
			
			this.velocity.x = 0;
			this.acceleration.x = 0;
			
			this._waveOffset = 180 * Math.random();
			this._startX = this.x;
			
			this.velocity.y = -10;
			this.acceleration.y = 0;
			
		}
		
	}
	
}