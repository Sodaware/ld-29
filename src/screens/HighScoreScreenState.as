package screens
{
	import db.ResourceDb;
	import db.SessionDb;
	import org.flixel.*;
	import flash.net.*;
	
	public class HighScoreScreenState extends FlxState
	{
		
		private var scoreLabel:FlxText;
		private var enterNameLabel:FlxText;
		private var instructionsLabel:FlxText;
		private var nameEntry:FlxInputText;
		
		
		// ----------------------------------------------------------------------
		// -- Updating / Rendering
		// ----------------------------------------------------------------------
		
		override public function update():void 
		{
			
			super.update();
			
			this.nameEntry.hasFocus = true;
			
			if (FlxG.keys.justPressed("ENTER")) {
				this.submitScore();
				SessionDb.previousName = this.nameEntry.text;
				FlxG.switchState(new TitleScreenState());
			}
			
		}
		
		public function submitScore() : void
		{
			
			if (this.nameEntry.text == "") {
				return;
			}
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			
			try {
				
				// Create the POST request
				var request:URLRequest= new URLRequest("http://lab.sodaware.net/1gam-2014/04-splodey-boats/scores/");
				request.method = URLRequestMethod.POST;
				
				// Set variables
				var data:URLVariables = new URLVariables();
				data.name  = this.nameEntry.text;
				data.score = SessionDb.score;
				data.currentLevel = SessionDb.currentLevel;
				
				data.destroyedSubs  = SessionDb.destroyedSubs;
				data.chargesDropped = SessionDb.chargesDropped;
				data.highestCombo   = SessionDb.highestCombo;
				
				// Send
				request.data = data;				
				loader.load(request);
				
			} catch (error:Error) {
				
			}
			
		}
		
		
		// ----------------------------------------------------------------------
		// -- Construction
		// ----------------------------------------------------------------------
		
		override public function create():void
		{
			
			super.create();
			
			this.scoreLabel = new FlxText(0, 60, FlxG.width, "You got a high score!", true);
			this.scoreLabel.font = "tinyfont";
			this.scoreLabel.size = 20;
			this.scoreLabel.alignment = "center";
			
			this.enterNameLabel = new FlxText(0, 120, FlxG.width, "Enter your name", true);
			this.enterNameLabel.font = "tinyfont";
			this.enterNameLabel.size = 10;
			this.enterNameLabel.alignment = "center";
			
			this.instructionsLabel = new FlxText(0, 140, FlxG.width, "(Leave blank to skip)", true);
			this.instructionsLabel.font = "tinyfont";
			this.instructionsLabel.size = 10;
			this.instructionsLabel.alignment = "center";
			
			this.nameEntry = new FlxInputText(20, 160, FlxG.width - 40, SessionDb.previousName, 0xFFFFFF, 0xFF222222);
			this.nameEntry.font = "tinyfont";
			this.nameEntry.size = 20;
			this.nameEntry.hasFocus = true;
			this.nameEntry.setMaxLength(16);
			this.nameEntry.border = true;
			this.nameEntry.borderColor = 0xFF888888;
			
			this.add(this.scoreLabel);
			this.add(this.enterNameLabel);
			this.add(this.instructionsLabel);
			this.add(this.nameEntry);
			
		}
		
		
	}

}