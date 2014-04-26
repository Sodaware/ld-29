package screens
{
	import db.ResourceDb;
	import org.flixel.*;
	
	public class TitleScreenState extends FlxState
	{
		
		private var _logo:FlxSprite;
		private var _pushStart:FlxText;
		
		
		// ----------------------------------------------------------------------
		// -- Updating / Rendering
		// ----------------------------------------------------------------------
		
		override public function update():void 
		{
			super.update();
			
			if (FlxG.keys.justPressed("SPACE")) {
				FlxG.flash(0xFF00000000, 2);
				FlxG.switchState(new PlayScreenState());
			}
			
		}
		
		
		// ----------------------------------------------------------------------
		// -- Construction
		// ----------------------------------------------------------------------
		
		override public function create():void
		{
			
			super.create();
			
			this._logo = new FlxSprite((FlxG.width - 156) / 2, 24, ResourceDb.gfx_Logo);
			
			this._pushStart = new FlxText(0, 120, FlxG.width, "Push Space", true);
			this._pushStart.alignment = "center";
			this._pushStart.font = "tinyfont";
			this._pushStart.size = 10;
			
			this.add(this._logo);
			this.add(this._pushStart);
			
		}
		
		
	}

}