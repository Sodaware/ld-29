package particles
{
	import org.flixel.*;
	
	public class FireParticle extends FlxParticle
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
			this.x = (this._startX + (3 * Math.sin(this._waveOffset)));
			
			this.alpha = this.alpha - 0.005;
			
		}
		
		override public function FireParticle() : void
		{
			super();
			this.makeGraphic(1, 1);
			var type:Number = Math.random() ;
			
			if (type < 0.5) {
				this.color = 0xFFFF00;
			} else if (type < 0.75) {
				this.color = 0xFF8040;
			} else {
				this.color = 0xFF0000;
			}
		}
		
		override public function onEmit():void 
		{
			super.onEmit();
			this.alpha = 1;
			
			this.velocity.x = 0;
			this.acceleration.x = 0;
			
			this._waveOffset = 180 * Math.random();
			this._startX = this.x;
			
			this.velocity.y = -15;
			this.acceleration.y = 0;
			
		}
		
	}
	
}