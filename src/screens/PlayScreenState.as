package screens
{
	import db.ContentDb;
	import db.ResourceDb;
	import db.SessionDb;
	import entities.EnemySubmarine;
	import entities.Fish;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import game.StageData;
	import org.flixel.*;
	import particles.BubbleParticle;
	import particles.ExplosionParticle;
	import particles.FireworkParticle;
	import particles.ScoreFlyoffParticle;
	
	public class PlayScreenState extends FlxState
	{
		
		// Available States
		public const STATE_LEVEL_START:int  = 1;
		public const STATE_PLAYING:int      = 2;
		public const STATE_LEVEL_OVER:int   = 3;
		public const STATE_LEVEL_FAILED:int = 4;
		public const STATE_DEAD:int         = 5;
		public const STATE_GAME_OVER:int    = 6;
		
		// Gameplay stuff
		private var isDroppingCharge:Boolean = false;
		private var state:int;
		
		// Background
		private var _bgSky:FlxSprite;
		private var _bgClouds:FlxGroup;
		private var _bgSea:FlxSprite;
		
		// Player
		private var _player:FlxSprite;
		
		// Enemies
		private var _enemies:FlxGroup;
		
		// Ambient stuff
		private var _animals:FlxGroup;
		
		// Explosions
		private var _explosions:FlxGroup;
		
		// Bullets and things
		private var _charge:FlxSprite;
		private var _bubbles:FlxEmitter;
		
		// User interface
		private var _overlay:ScreenOverlay;
		private var _scoreLabel:FlxText;
		private var _highscoreLabel:FlxText;
		private var _timerLabel:FlxText;
		
		// Current session data
		private var _stage:StageData;
		private var _timer:Timer;
		private var _timeRemaining:Number;
		private var _destroyedSubs:int;
		private var _usedCharges:int;
		private var _usedSonars:int;

		
		// ----------------------------------------------------------------------
		// -- Updating
		// ----------------------------------------------------------------------
		
		override public function update():void 
		{
			
			super.update();
			
			this.updateUi();
			this.updateAmbience();
			
			switch (this.state) {
				
				case STATE_LEVEL_START:
					this.updateLevelIntroState();
					break;
				
				case STATE_LEVEL_OVER:
					this.updateLevelOverState();
					break;
				
				case STATE_LEVEL_FAILED:
					this.updateFailureState();
					break;
					
				case STATE_PLAYING:
					this.updatePlayState();
					break;
				
			}
			
		}
		
		/**
		 * Update clouds, weather etc
		 */
		public function updateAmbience() : void
		{
			for each (var cloud:FlxSprite in this._bgClouds.members) {
				
				if (cloud.x < (0 - cloud.width)) {
					cloud.x = FlxG.width + (10 * Math.random());
					cloud.y = Math.floor(Math.random() * 28);
				}
				
			}
		}
		
		/**
		 * Update the main gameplay UI.
		 */
		public function updateUi() : void
		{
			
			// Redraw if scores changes
			if (this._scoreLabel.health != SessionDb.score) {
				this._scoreLabel.text = this.formatNumber(SessionDb.score) + "\nscore";
			}
			
			this._scoreLabel.health = SessionDb.score;
			
			if (this._timer) {
				this._timerLabel.text   = Math.ceil(this._timeRemaining).toString();
			}
			
		}
		
		
		// ----------------------------------------------------------------------
		// -- States
		// ----------------------------------------------------------------------
		
		public function updateLevelIntroState() : void
		{
			
			this.updateEffects();

			if (this._overlay.isFinished()) {
				this.removeOverlay();
				this.enterState(STATE_PLAYING);
			}
		}
		
		public function updateLevelOverState() : void
		{
			
			this.updateEffects();
			this.updateEntities();
			
			if (this._overlay.isFinished()) {
				this.removeOverlay();
				SessionDb.currentLevel++;
				this.enterState(STATE_LEVEL_START);
			}
			
		}
		
		public function updateFailureState() : void
		{
			
			this.updateEffects();
			this.updateEntities();
			
			if (this._overlay.isFinished()) {
				FlxG.switchState(new TitleScreenState());
			}
			
		}
		
		public function updatePlayState() : void
		{
			
			this.updateEffects();
			this.updateEntities();
			
			// Player movement
			if (FlxG.keys.pressed("LEFT")) {
				this._player.acceleration.x -= 2.5;
				if (this._player.acceleration.x < -25) {
					this._player.acceleration.x = -25;
				}
				
			} else if (FlxG.keys.pressed("RIGHT")) {
				this._player.acceleration.x += 2.5;
				if (this._player.acceleration.x > 25) {
					this._player.acceleration.x = 25;
				}
				
			} else {
				this._player.acceleration.x = 0;
			}
			
			// Dropping and detonating a charge
			if (FlxG.keys.justPressed("SPACE")) {
				if (this.isDroppingCharge) {
					this.detonateCharge();
				} else {
					this.dropCharge();
				}
			}
			
			// Spawning an enemy
			// [todo] - Add a timer here...
			if (Math.random() > 0.995) {
				this.createEnemy();
			}
			
			
			// Check if the level has finished
			if (this._destroyedSubs >= this._stage.targetEnemies) {
				this.enterState(STATE_LEVEL_OVER);
				return;
			}
			
			if (this._timeRemaining <= 0) {
				this.enterState(STATE_LEVEL_FAILED);
				return;
			}
			
			// Did we use all of our depth charges?
			if (this._stage.chargeLimit > 0) {
				if (this._usedCharges == this._stage.chargeLimit && this._explosions.length == 0) {
					this.enterState(STATE_LEVEL_FAILED);
					return;
				}
			}
			
		}
		
		public function updateEffects() : void
		{
			
			// Make bubbles on the depth charge
			if (this.isDroppingCharge) {
				
				if (Math.random() > 0.9) {
					this._bubbles.x = this._charge.x + 3;
					this._bubbles.y = this._charge.y + 3;
					
					this._bubbles.emitParticle();
				}
				
				if (this._charge.y > 280) {
					this.detonateCharge();
				}
				
			}
			
		}
		
		/**
		 * Updates all enemies and explosions
		 */
		public function updateEntities() : void
		{
			
			var barrelExplosions:int = 0;
			
			// Check for enemies being exploded
			for each (var explosion:ExplosionParticle in this._explosions.members) {
				
				// Did it hit an enemy?
				for each (var enemy:EnemySubmarine in this._enemies.members) {
					
					// Damage the enemy
					if (explosion.isDepthChargeExplosion && enemy.health > 0 && enemy.overlaps(explosion)) {
						enemy.damage(1);
						
						if (enemy.health == 0) {
							
							// Increase the score (use enemy difficulty * depth as a guide)
							var depthMultiplier:Number = 1;
							var scoreText:String       = "100";
							
							if (enemy.y > 230) {
								depthMultiplier = 1.5;
								scoreText += " x 1.5";
							} else if (enemy.y > 135) {
								depthMultiplier = 1.25;
								scoreText += " x 1.25";
							}
							
							this.add(new ScoreFlyoffParticle(enemy.x + (enemy.width / 2), enemy.y, scoreText));
							
							SessionDb.score += (100 * depthMultiplier);
							this._destroyedSubs += 1;
							
						}
					}
				}
				
				// Did you kill a fish (you monster)
				for each (var animal:Fish in this._animals.members) {
					
					if (animal.isDead) {
						continue;
					}
					
					if (explosion.isDepthChargeExplosion && animal.overlaps(explosion)) {
						
						// BAD PERSON!
						this.add(new ScoreFlyoffParticle(animal.x + (animal.width / 2), animal.y, "-10", true));
						SessionDb.score -= 10;
						
						animal.makeDead();
					}
				}
				
				// Check if explosion has finished (delegate this);
				if (explosion.frame == 5) {
					this._explosions.remove(explosion, true);
					explosion.destroy();
				}
				
			}
			
			
			
			for each (enemy in this._enemies.members) {
				
				if (enemy.isExploding) {
					
					// Create explosions as the sub sinks
					if (!enemy.isSunk && Math.random() > 0.9) {
						var ex:ExplosionParticle = new ExplosionParticle(enemy.x + (34 * Math.random()), enemy.y + (12 * Math.random()));
						ex.isDepthChargeExplosion = false;
						this._explosions.add(ex);
					}
					
				}
				
				// Bubbles if at the bottom
				if (enemy.isSunk && Math.random() > 0.95) {
					this._bubbles.x = enemy.x + (enemy.width  * Math.random());
					this._bubbles.y = enemy.y + (enemy.height * Math.random());;
					this._bubbles.emitParticle();
				}
				
				// Bubbles from the engine
				if ((!enemy.isExploding && !enemy.isSunk) && Math.random() > 0.9) {
					this._bubbles.x = enemy.propellerX();
					this._bubbles.y = enemy.propellerY();
					
					this._bubbles.emitParticle();
				}
				
			}
			
		}
		
		
		public function dropCharge() : void
		{
			
			// Don't drop a charge if it's done
			if (this._stage.chargeLimit > 0 && this._usedCharges >= this._stage.chargeLimit) {
				return;
			}
			
			this.isDroppingCharge = true;
			
			this._charge.x = this._player.x + 24;
			this._charge.y = 66;
			
			this._charge.visible = true;
			
			this._charge.acceleration.y = 9.8;
			this._charge.maxVelocity.y  = 98;
		}
		
		public function detonateCharge() : void
		{
			
			// Can spawn again
			this.isDroppingCharge = false;
			
			// Update internal state
			this._usedCharges++;
			
			// Hide the charge
			this._charge.visible        = false;
			this._charge.velocity.y     = 0;
			this._charge.acceleration.y = 0;
			
			// Spawn some explosions
			for (var i:int = 0; i < 10; i++) {
				var explosion:ExplosionParticle = new ExplosionParticle(this._charge.x - 6 + (12 * Math.random()), this._charge.y - 6 + (12 * Math.random()));
				explosion.isDepthChargeExplosion = true;
				this._explosions.add(explosion);
			}
			
		}
		
		public function createEnemy() : void
		{
			
			// Create the submarine
			var enemy:EnemySubmarine = new EnemySubmarine(90 + (180 * Math.random()));
			
			// Update speed based on multiplier
			enemy.velocity.x = enemy.velocity.x * this._stage.speedMultiplier;
			
			// Update aggression
			enemy.aggression = this._stage.enemyAggression;
			
			this._enemies.add(enemy);
		}
		
		public function clearEnemies() : void
		{
			
			for each (var enemy:EnemySubmarine in this._enemies.members) {
				enemy.kill();
				enemy.destroy();
			}
			
			this._enemies.clear();
			
		}
		
		public function clearFish() : void
		{
			
			for each (var animal:Fish in this._animals.members) {
				animal.kill();
				animal.destroy();
			}
			
			this._animals.clear();
			
		}
		
		// ----------------------------------------------------------------------
		// -- State Helpers
		// ----------------------------------------------------------------------
		
		/**
		 * Change the current substate.
		 * @param	newState The new state to switch to.
		 */
		public function enterState(newState:int = 0) : void
		{
			
			if (newState != 0) {
				this.state = newState;
			}
			
			switch (this.state) {
				
				// Start a new level
				case STATE_LEVEL_START:
					this.clearEnemies();
					this.clearFish();
					this._overlay = new LevelStartOverlay();
					this.add(this._overlay);
					break;
				
				// Level complete - player won
				case STATE_LEVEL_OVER:
					
					// Stop the timer
					this._timer.stop();
					
					// Add bonus time
					SessionDb.score += (this.timeRemaining * 10);
					
					this._overlay = new LevelCompleteOverlay(this);
					this.add(this._overlay);
					break;
				
				// Level complete - player failed
				case STATE_LEVEL_FAILED:
					
					// Stop the timer
					this._timer.stop();
					
					this._overlay = new MissionFailedOverlay();
					this.add(this._overlay);
					break;
				
				case STATE_PLAYING:
					
					// Load the stage data
					this._stage = ContentDb.getLevel(SessionDb.currentLevel);
					
					// Setup data based on session
					this._usedCharges   = 0;
					this._usedSonars    = 0;
					this._destroyedSubs = 0;
					this._timeRemaining = this._stage.timeLimit;
					
					// Setup the timer
					this._timer = new Timer(1000);
					this._timer.addEventListener(TimerEvent.TIMER, this._updateTimer);
					this._timer.start();
					
					// Spawn animals
					if (this._stage.totalAnimals) {
						for (var i:int = 0; i < this._stage.totalAnimals; i++) {
							this._animals.add(new Fish());
						}
					}
					
					// Create an initial enemy
					this.createEnemy();
					
					break;
			}
		}
		
		private function _updateTimer(data:Object) : void
		{
			this._timeRemaining--;
		}
		
		private function removeOverlay():void 
		{
			// Hide the overlay
			this.remove(this._overlay);
			this._overlay.destroy();
			this._overlay = null;
			
		}
		
		
		// ----------------------------------------------------------------------
		// -- Appearance Helpers
		// ----------------------------------------------------------------------
		
		public function formatNumber(n:int): String
		{
			var formattedScore:String = n.toString();
			while (formattedScore.length < 8) {
				formattedScore = "0" + formattedScore;
			}
			return formattedScore;
		}
		
		
		// ----------------------------------------------------------------------
		// -- Getters
		// ----------------------------------------------------------------------
		
		public function get destroyedSubs() : int 
		{
			return this._destroyedSubs;
		}
		
		public function get timeRemaining() : int 
		{
			return this._timeRemaining;
		}
		
		public function get player() : FlxSprite
		{
			return this._player;
		}		
		
		// ----------------------------------------------------------------------
		// -- Construction
		// ----------------------------------------------------------------------
		
		override public function create():void
		{
			
			super.create();
			
			// Create the initial sky
			this._bgSky = new FlxSprite(0, 0, ResourceDb.gfx_DaySky);
			
			// Add some clouds
			this._bgClouds = new FlxGroup();
			for (var i:int = 0; i < 5; i++) {
				var cloud:FlxSprite = new FlxSprite(FlxG.width, Math.floor(Math.random() * 28));
				cloud.loadGraphic(ResourceDb.gfx_DayClouds, true, false, 42, 4);
				cloud.frame = Math.floor(Math.random() * 5);
				cloud.velocity.x = -1 * (Math.random() * 2);
				cloud.x = (Math.random() * FlxG.width);
				this._bgClouds.add(cloud);
			}
			
			
			// Create the sea
			this._bgSea = new FlxSprite(0, 71, ResourceDb.gfx_DaySea);
			
			// Add some objects
			this._player = new FlxSprite((FlxG.width - 48) / 2, 55, ResourceDb.gfx_Player);
			this._player.drag.x = 10;
			
			this._player.maxVelocity.x = 25;
			
			this._charge = new FlxSprite(-100, -100);
			this._charge.loadGraphic(ResourceDb.gfx_DepthCharge, true, false, 6, 6);
			this._charge.addAnimation("spin", [0, 1, 2, 3], 5, true);
			this._charge.play("spin");
			this._charge.visible = false;
			
			this._enemies = new FlxGroup();
			
			// Explosions and particles
			this._explosions = new FlxGroup();
			
			this._bubbles = new FlxEmitter(0, 0, 250);
			this._bubbles.setRotation(0, 0);
			
			this._bubbles.lifespan = 2;
			this._bubbles.particleClass = BubbleParticle;
			
			for (var i:int = 0; i < 250; i++) {
				this._bubbles.add(new BubbleParticle());
			}
			
			// Create the UI
			this._scoreLabel = new FlxText(2, 0, 60, "00000000\nScore");
			this._scoreLabel.font = "tinyfont";
			this._scoreLabel.size = 10;
			
			this._highscoreLabel = new FlxText(162, 0, 60, "00000000\nHigh");
			this._highscoreLabel.font = "tinyfont";
			this._highscoreLabel.alignment = "right";
			this._highscoreLabel.size = 10;
			
			this._timerLabel = new FlxText(82, -2, 60, "");
			this._timerLabel.font = "tinyfont";
			this._timerLabel.size = 20;
			this._timerLabel.alignment = "center";
			
			// Animals
			this._animals = new FlxGroup();
			
			// Add everything!
			this.add(this._bgSky);
			this.add(this._bgClouds);
			this.add(this._bgSea);
			
			this.add(this._bubbles);
			
			this.add(this._player);
			this.add(this._enemies);
			this.add(this._charge);
			this.add(this._animals);
			
			this.add(this._explosions);
			
			// Add the UI
			this.add(this._scoreLabel);
			this.add(this._highscoreLabel);
			this.add(this._timerLabel);
			
			// Enter the initial play state
			this.enterState(STATE_LEVEL_START);
			
		}
		
	}

}