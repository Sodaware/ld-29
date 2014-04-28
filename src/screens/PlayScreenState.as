package screens
{
	import db.ContentDb;
	import db.ResourceDb;
	import db.SessionDb;
	import entities.DepthCharge;
	import entities.EnemyMine;
	import entities.EnemyMissile;
	import entities.EnemySubmarine;
	import entities.Fish;
	import entities.Player;
	import entities.PowerupCrate;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import game.StageData;
	import net.sodaware.ArrayUtil;
	import net.sodaware.FlxSpriteUtil;
	import org.flixel.*;
	import particles.BubbleParticle;
	import particles.ExplosionParticle;
	import particles.FireParticle;
	import particles.FireworkParticle;
	import particles.ScoreFlyoffParticle;
	import particles.SmokeParticle;
	import particles.WaterSplashParticle;
	
	public class PlayScreenState extends FlxState
	{
		
		// Available States
		public const STATE_LEVEL_START:int  = 1;
		public const STATE_PLAYING:int      = 2;
		public const STATE_LEVEL_OVER:int   = 3;
		public const STATE_LEVEL_FAILED:int = 4;
		public const STATE_DEAD:int         = 5;
		public const STATE_GAME_OVER:int    = 6;
		
		// Available powerups
		public const POWERUP_EXTRA_BOMB:int   = 1;
		public const POWERUP_EXTRA_SONAR:int  = 2;
		public const POWERUP_EXTRA_TIME:int   = 3;
		public const POWERUP_SMART_BOMB:int   = 4;
		public const POWERUP_MEGA_BARREL:int  = 5;
		public const POWERUP_MISSILE_BOMB:int = 6;
		public const POWERUP_CLUSTER_BOMB:int = 7;
		public const POWERUP_HOMING_BOMB:int  = 8;
		public const POWERUP_REPAIR:int       = 9;
		
		private var _currentPowerup:int       = 0;
		private var _powerupTimeLeft:int      = 0;
		
		// Gameplay stuff
		private var isDroppingCharge:Boolean = false;
		private var isRunningSonar:Boolean   = false;
		private var state:int;
		private var _subsDestroyedWithCurrentMine:int = 0;
		
		// Background
		private var _bgMoon:FlxSprite;
		private var _bgSky:FlxSprite;
		private var _bgClouds:FlxGroup;
		private var _bgSea:FlxSprite;
		
		// Transition helpers
		private var _transitionTimer:Timer;
		private var _skyTransition:FlxSprite;
		private var _seaTransition:FlxSprite;
		
		// Player
		private var _player:Player;
		private var _playerParts:FlxGroup;
		private var _hasSploded:Boolean = false;
		
		// Powerups
		private var _powerupCrate:PowerupCrate;
		
		// Enemies
		private var _enemies:FlxGroup;
		private var _mineLayer:FlxSprite;
		
		// Ambient stuff
		private var _animals:FlxGroup;
		
		// Explosions
		private var _explosions:FlxGroup;
		
		// Bullets and things
		private var _charge:DepthCharge;
		private var _depthCharges:FlxGroup;
		private var _missiles:FlxGroup;
		private var _mines:FlxGroup;
		private var _bubbles:FlxEmitter;
		private var _splashes:FlxEmitter;
		private var _smoke:FlxEmitter;
		private var _fire:FlxEmitter;
		
		// Sonar...
		private var _sonarWave:FlxSprite;
		
		// User interface
		private var _overlay:ScreenOverlay;
		private var _scoreLabel:FlxText;
		private var _highscoreLabel:FlxText;
		private var _timerLabel:FlxText;
		private var _chargesLabel:FlxText;
		private var _sonarLabel:FlxText;
		
		// Current session data
		private var _stage:StageData;
		private var _currentLevelType:int;
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
			
			// Smoke
			if (!this.player.isDead() && this.player.isDamaged()) {
				
				if (Math.random() > 0.95) {
					
					for (var i:int = 0; i < (this.player.maxHealth - this._player.health); i++) {
						this._smoke.x = this._player.x + (Math.random() * this._player.width);
						this._smoke.y = this._player.y + (Math.random() * this._player.height);
						
						this._smoke.emitParticle();
					}
					
					if (this._player.health <= 2) {
						
						for (var i:int = 0; i < (this.player.maxHealth - this._player.health - 2); i++) {
							this._fire.x = this._player.x + (Math.random() * this._player.width);
							this._fire.y = this._player.y + (Math.random() * this._player.height);
							this._fire.emitParticle();
						}
						
					}
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
			
			// Update remaining charges etc
			if (this._chargesLabel.visible && this._stage) {
				var chargesLeft:int = this._stage.chargeLimit - this._usedCharges;
				
				this._chargesLabel.text = chargesLeft.toString();
				this._chargesLabel.text += (chargesLeft == 1) ? " charge left" : " charges left";
			}
			
			// Update remaining charges etc
			if (this._sonarLabel.visible && this._stage) {
				var sonarsLeft:int = this._stage.sonarLimit - this._usedSonars;
				
				this._sonarLabel.text = sonarsLeft.toString();
				this._sonarLabel.text += (sonarsLeft == 1) ? " sonar left" : " sonars left";
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
				
				if (SessionDb.currentLevel == ContentDb.levels.length) {
					FlxG.switchState(new GameOverScreenState());
				} else {
					this.enterState(STATE_LEVEL_START);
				}
			}
			
		}
		
		public function updateFailureState() : void
		{
			
			this.updateEffects();
			this.updateEntities();
			
			if (this._overlay.isFinished()) {
				FlxG.switchState(new GameOverScreenState());
			}
			
		}
		
		public function updatePlayState() : void
		{
			
			this.updateEffects();
			this.updateEntities();
			this.updateAi();
			this.updateSonar();
			
			// Spawn powerups
			if (!this._powerupCrate.visible && Math.random() > 0.9995) {
				this._powerupCrate.respawn();
			}
			
			
			// Splode?
			if (this._powerupCrate.visible) {
				
				// Hit the player?
				if (this._player.overlaps(this._powerupCrate)) {
					this.givePowerup();
					this._powerupCrate.visible = false;
				}
				
				if (this._powerupCrate.y >= 56) {
					this._powerupCrate.visible = false;
					
					// Explode
					for (var i:int = 0; i < 3; i++) {
						var explosion:ExplosionParticle = new ExplosionParticle(this._powerupCrate.x + (13 * Math.random()), this._powerupCrate.y + 14 + (6 * Math.random()));
						explosion.isDepthChargeExplosion = false;
						explosion.isEnemyExplosion       = false;
						this._explosions.add(explosion);
					}
					
					// Make a splash
					this.makeSplash(this._powerupCrate.x + 7);
				}
				
			}
			
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
			
			if (this._player.x < 0) {
				this._player.x = 0;
				this._player.stop();
			}
			
			if (this._player.x + this._player.width > FlxG.width) {
				this._player.x = FlxG.width - this._player.width;
				this._player.stop();
			}
			
			// Running sonars
			if (FlxG.keys.justPressed("S")) {
				this.emitSonar();
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
			if (this._enemies.length < this._stage.targetEnemies * 2) {
				if (Math.random() > 0.995) {
					this.createEnemy();
				}
			}
			
			// Check if the level has finished
			if (this._destroyedSubs >= this._stage.targetEnemies) {
				this.disableAi();
				this.destroyMissiles();
				this.destroyMines();
				this.destroyPowerup();
				this.enterState(STATE_LEVEL_OVER);
				return;
			}
			
			if (this._timeRemaining <= 0) {
				this.disableAi();
				this.destroyMissiles();
				this.destroyMines();
				this.destroyPowerup();
				this.enterState(STATE_LEVEL_FAILED);
				return;
			}
			
			// Did we use all of our depth charges?
			if (this._stage.chargeLimit > 0) {
				if (this._usedCharges == this._stage.chargeLimit && this._explosions.length == 0) {
					this.disableAi();
					this.destroyMissiles();
					this.destroyMines();
					this.destroyPowerup();
					this.enterState(STATE_LEVEL_FAILED);
					return;
				}
			}
			
		}
		
		public function updateSonar() : void
		{
			
			this._sonarWave.alpha -= 0.001;
			
			if (this._sonarWave.y > FlxG.height) {
				this.isRunningSonar = false;
				this._sonarWave.visible = false;
			}
			
			for each (var sub:EnemySubmarine in this._enemies.members) {
				
				if (this._sonarWave.overlaps(sub)) {
					
					// Ping
					sub.reactToSonarPing(600);
					
				}
				
			}
			
		}
		
		public function givePowerup(powerup:int = 0) : void
		{
			
			FlxG.play(ResourceDb.snd_Powerup);
			
			// Decide on the powerup
			var allowedPowerups:Array = [
				POWERUP_EXTRA_BOMB,
				POWERUP_EXTRA_SONAR,
				POWERUP_EXTRA_TIME,
				POWERUP_SMART_BOMB,
				POWERUP_MEGA_BARREL,
				POWERUP_MISSILE_BOMB,
				POWERUP_CLUSTER_BOMB,
				POWERUP_HOMING_BOMB,
				POWERUP_REPAIR
			];
			
			// Remove useless powerups
			if (this._stage.sonarLimit < 1) {
				allowedPowerups = ArrayUtil.removeObject(allowedPowerups, POWERUP_EXTRA_SONAR);
			}
			
			if (this._stage.chargeLimit < 1) {
				allowedPowerups = ArrayUtil.removeObject(allowedPowerups, POWERUP_EXTRA_BOMB);
			}
			
			if (this._missiles.length == 0 && this._mines.length == 0) {
				allowedPowerups = ArrayUtil.removeObject(allowedPowerups, POWERUP_SMART_BOMB);
			}
			
			if (!this.player.isDamaged()) {
				allowedPowerups = ArrayUtil.removeObject(allowedPowerups, POWERUP_REPAIR);
			}
			
			// Decide on the powerup (if not set)
			if (powerup == 0) {
				powerup = allowedPowerups[Math.floor(Math.random() * allowedPowerups.length)];
			}
			
			this._currentPowerup = powerup;
			var text:String = "";
			
			switch (this._currentPowerup) {
				
				case POWERUP_EXTRA_SONAR:
					text = "+ 5 Sonars";
					this._usedSonars -= 5;
					this._currentPowerup = 0;
					break;
					
				case POWERUP_EXTRA_BOMB:
					text = "+ 5 Depth Charges";
					this._currentPowerup = 0;
					this._usedCharges -= 5;
					break;
					
				case POWERUP_EXTRA_TIME:
					text = "+15 Seconds";
					this._currentPowerup = 0;
					this._timeRemaining += 15;
					break;
					
				case POWERUP_SMART_BOMB:
					text = "Smart bomb";
					FlxG.flash();
					FlxG.shake(0.025, 0.25);
					this._currentPowerup = 0;
					this.destroyMissiles();
					this.destroyMines();
					break;
					
				case POWERUP_MEGA_BARREL:
					text = "Mega Depth Charge";
					break;
					
				case POWERUP_MISSILE_BOMB:
					text = "Missile Charge";
					break;
					
				case POWERUP_CLUSTER_BOMB:
					text = "Cluster Charge";
					break;
					
				case POWERUP_HOMING_BOMB:
					text = "Homing Charge";
					break;
					
				case POWERUP_REPAIR:
					text = "REPAIRED";
					this._player.health = this._player.maxHealth;
					this._currentPowerup = 0;
					break;
				
			}
			
			this.add(new ScoreFlyoffParticle(this.player.x + (this.player.width / 2), this.player.y, text));
		}
		
		public function updateEffects() : void
		{
			
			// Make bubbles on the depth charge
			if (this.isDroppingCharge) {
				
				if (Math.random() > 0.9) {
					this.spawnBubble(this._charge.x + 3, this._charge.y + 3);
				}
				
				if (this._charge.y > 280) {
					this.detonateCharge();
				}
				
			}
			
		}
		
		public function updateAi() : void
		{
			
			// Can we spawn a mine layer?
			if (this._mineLayer.visible == false) {
				
				if (this._stage.mineFrequency > 0) {
					
					if (this._mines.length < this._stage.mineFrequency && Math.random() > 0.95) {
						this.createMineLayer();
					}
					
				}
				
			}
			
			// Update the mine layer
			if (this._mineLayer.visible) {
				
				if (this._mineLayer.x > FlxG.width + 20) {
					this._mineLayer.visible = false;
				}
				
				if (this._mineLayer.health == 1) {
					
					// Check not in the region of the player
					if (this._mineLayer.x + this._mineLayer.width < this._player.x - 10 || this._mineLayer.x > this._player.x + this._player.width + 10) {
						
						// Drop the mine
						if (Math.random() > 0.995) {
							this._mineLayer.health = 0;
							
							var mine:EnemyMine = new EnemyMine(this._mineLayer.x + 18, this._mineLayer.y + 8);
							mine.onDetonateCallback = this.onMineDetonated;
							mine.onLandCallback     = this.onMineLanded;
							
							this._mines.add(mine);
							
						}
						
					}
					
				}
				
			}
			
		}
		
		/**
		 * Updates all enemies, explosions and missiles.
		 */
		public function updateEntities() : void
		{
			
			var playerExplosions:int = 0;
			
			// Create explosions as the sub sinks
			if (this._playerParts.length > 0) {
				for each (var part:FlxSprite in this._playerParts.members) {
					
					if (part.y >= 269) {
						
						if (!this._hasSploded) {
							this._hasSploded = true;
							FlxG.shake(0.005);
							FlxG.play(ResourceDb.snd_Explosions[Math.floor(Math.random() * ResourceDb.snd_Explosions.length)]);
						}
						
						part.acceleration.y = 0;
						part.acceleration.x = 0;
						part.velocity.x     = 0;
						part.velocity.y     = 0;
						
						if (Math.random() > 0.95) {
							this._bubbles.x = part.x + (part.frameHeight * Math.random());
							this._bubbles.y = part.y + (part.frameHeight * Math.random());;
							this._bubbles.emitParticle();
						}
				
					} else if (Math.random() > 0.95) {
						var ex:ExplosionParticle = new ExplosionParticle(part.x + (part.frameWidth * Math.random()), part.y + (part.frameWidth * Math.random()));
						this._explosions.add(ex);
					}
				}
			}
			
			// Check for enemies being exploded
			for each (var explosion:ExplosionParticle in this._explosions.members) {
				
				// Skip none-depth charge explosions (for enemies)
				if (explosion.isDepthChargeExplosion) {
					
					playerExplosions++;
					
					// Did it hit an enemy?
					for each (var enemy:EnemySubmarine in this._enemies.members) {
						
						// Damage the enemy
						if (enemy.health > 0 && enemy.overlaps(explosion)) {
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
								SessionDb.destroyedSubs++;
								this._destroyedSubs++;
								
								
								this._subsDestroyedWithCurrentMine ++;
								
							}
						}
					}
					
					// Did you destroy a missile
					for each (var missile:EnemyMissile in this._missiles.members) {
						
						if (missile.overlaps(explosion)) {
							
							// Destroy the missile
							this.add(new ScoreFlyoffParticle(missile.x + 2, missile.y, "25"));
							SessionDb.score += 25;
							
							this.detonateMissile(missile);
						}
					}
					
					// Did you kill a fish (you monster)
					for each (var animal:Fish in this._animals.members) {
						
						if (animal.isDead) {
							continue;
						}
						
						if (explosion.isDepthChargeExplosion && animal.overlaps(explosion)) {
							
							// BAD PERSON!
							this.add(new ScoreFlyoffParticle(animal.x + (animal.width / 2), animal.y, "-250", true));
							SessionDb.score -= 250;
							
							animal.makeDead();
						}
					}
					
				}
				
				// Check if explosion hit the player
				if (explosion.isEnemyExplosion) {
					
					if (!this.player.isDead() && this.player.overlaps(explosion)) {
						
						// Damage from this explosion
						this.player.damage(1);
						
						if (this.player.health <= 0) {
							
							// YOU DEAD
							this._player.makeDead();
							this.disableAi();
							
							// Spawn some parts
							this.makePlayerParts();
							
							this.enterState(STATE_LEVEL_FAILED);
							
						}
						
					}
					
				}
				
				// Check if explosion has finished (delegate this);
				if (explosion.frame == 5) {
					this._explosions.remove(explosion, true);
					explosion.destroy();
				}
				
			}
			
			// Display bonuses
			if (playerExplosions == 0 && this._subsDestroyedWithCurrentMine > 1) {
				
				// BONUS!
				this.add(new ScoreFlyoffParticle(this.player.x + (this.player.width / 2), this.player.y, "Bonus X " + this._subsDestroyedWithCurrentMine));
				SessionDb.score += (100 * this._subsDestroyedWithCurrentMine);
				
				if (SessionDb.highestCombo < this._subsDestroyedWithCurrentMine) {
					SessionDb.highestCombo = this._subsDestroyedWithCurrentMine;
				}
				this._subsDestroyedWithCurrentMine = 0;
				
			}
			
			// Update enemies
			for each (enemy in this._enemies.members) {
				
				// Make some homing things
				for each (var charge:DepthCharge in this._depthCharges.members) {
					if (charge.type != 0 && charge.overlaps(enemy)) {
						charge.onDetonateCallback(charge);
					}
				}
				
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
					
					if (this._stage.levelType != ContentDb.LEVEL_TYPE_NIGHT) {
						this._bubbles.x = enemy.propellerX();
						this._bubbles.y = enemy.propellerY();
						
						this._bubbles.emitParticle();
					} else if (enemy.alpha > 0) {
						this._bubbles.x = enemy.propellerX();
						this._bubbles.y = enemy.propellerY();
						
						this._bubbles.emitParticle();
					}
				}
				
			}
			
			// Update mines
			for each (var mine:EnemyMine in this._mines.members) {
				
				if (!this.player.isDead() && this.player.overlaps(mine)) {
					
					this.onMineDetonated(mine);
					
					// YOU DEAD
					this._player.makeDead();
					this.disableAi();
					this.enterState(STATE_LEVEL_FAILED);
					
				}
				
			}
			
			this.updateMissiles();
			
		}
		
		public function updateMissiles() : void
		{
			
			// Update missiles
			for each (var missile:EnemyMissile in this._missiles.members) {
				
				// Did it hit the charge
				if (this.isDroppingCharge && this._charge.overlaps(missile)) {
					this.detonateCharge();
				}
				
				for each (var charge:DepthCharge in this._depthCharges.members) {
					if (charge.overlaps(missile)) {
						charge.onDetonateCallback(charge);
					}
				}
				
				// Did it reach the surface?
				if (missile.y <= 71) {
					
					// Make a splash
					this._splashes.x = missile.x + 3;
					this._splashes.y = missile.y;
					
					for (var i:int = 0; i < 25; i++) {
						this._splashes.emitParticle();
					}
					
					// Explode
					this.detonateMissile(missile);
					
				}
				
			}
			
		}
		
		public function detonateMissile(missile:EnemyMissile) : void
		{
			
			FlxG.play(ResourceDb.snd_Explosions[Math.floor(Math.random() * ResourceDb.snd_Explosions.length)]);
			
			// Explode
			for (var i:int = 0; i < 3; i++) {
				var explosion:ExplosionParticle = new ExplosionParticle(missile.x + (5 * Math.random()), missile.y - 3 + (5 * Math.random()));
				explosion.isDepthChargeExplosion = false;
				explosion.isEnemyExplosion       = true;
				this._explosions.add(explosion);
			}
			
			// Destroy the missile
			this._missiles.remove(missile, true);
			missile.kill();
			missile.destroy();
			
		}
		
		
		// ----------------------------------------------------------------------
		// -- Mines
		// ----------------------------------------------------------------------
		
		public function onMineDetonated(mine:EnemyMine) : void
		{
			
			
			FlxG.play(ResourceDb.snd_Explosions[Math.floor(Math.random() * ResourceDb.snd_Explosions.length)]);
			
			// Explode
			for (var i:int = 0; i < 3; i++) {
				var explosion:ExplosionParticle = new ExplosionParticle(mine.x + (9 * Math.random()), mine.y + (9 * Math.random()));
				explosion.isDepthChargeExplosion = false;
				explosion.isEnemyExplosion       = true;
				this._explosions.add(explosion);
			}
			
			// Make a splash
			if (mine.y > 68) {
				this.makeSplash(mine.x + 4.5);
			}
			
			// Destroy the mine
			mine.kill();
			mine.destroy();
			this._mines.remove(mine, true);
			
		}
		
		public function onMineLanded(mine:EnemyMine) : void
		{
			this.makeSplash(mine.x + 4.5, 70, 25);			
		}
		
		
		// ----------------------------------------------------------------------
		// -- Sonar
		// ----------------------------------------------------------------------
		
		public function emitSonar() : void
		{
			
			if (this._stage.levelType != ContentDb.LEVEL_TYPE_NIGHT) {
				return;
			}
			
			if (this.isRunningSonar) {
				return;
			}
			
			if (this._usedSonars >= this._stage.sonarLimit) {
				return;
			}
			
			FlxG.play(ResourceDb.snd_Sonar);
			
			this._usedSonars += 1;
			
			this.isRunningSonar = true;
			
			this._sonarWave.visible = true;
			this._sonarWave.y = 72;
			this._sonarWave.alpha = 0.5;
			this._sonarWave.velocity.y = 100;
		}

		
		// ----------------------------------------------------------------------
		// -- Atmospheric Effects
		// ----------------------------------------------------------------------
		
		public function makeSplash(xPos:Number, yPos:Number = 70, amount:int = 25) : void
		{
			
			FlxG.play(ResourceDb.snd_Splashes[Math.floor(Math.random() * ResourceDb.snd_Splashes.length)]);
			
			this._splashes.x = xPos;
			this._splashes.y = yPos;
			
			for (var i:int = 0; i < amount; i++) {
				this._splashes.emitParticle();
			}
		}
		
		public function spawnBubble(xPos:Number, yPos:Number) : void
		{
			this._bubbles.x = xPos;
			this._bubbles.y = yPos;
			this._bubbles.emitParticle();

		}
		
		public function dropCharge() : void
		{
			
			// Don't drop a charge if it's done
			if (this._stage.chargeLimit > 0 && this._usedCharges >= this._stage.chargeLimit) {
				return;
			}
			
			SessionDb.chargesDropped++;
			
			this._subsDestroyedWithCurrentMine = 0;
			this.isDroppingCharge = true;
			
			// Drop the charge!
			this._charge.drop(this._player.x + 24, 66, this._currentPowerup);
			this.makeSplash(this._charge.x + (this._charge.width / 2));
			
			if (this._currentPowerup == POWERUP_HOMING_BOMB) {
				this._charge.target = this._enemies.getRandom() as EnemySubmarine;
			}
			
			
			// Reset the powerup
			this._currentPowerup = 0;
			
		}
		
		public function onChargeDetonated(charge:DepthCharge) : void
		{
			// Calculate explosion radius
			var radius:int = charge.explosionRadius();
			var amount:int = charge.explosionSize();
			
			FlxG.play(ResourceDb.snd_Explosions[Math.floor(Math.random() * ResourceDb.snd_Explosions.length)]);
			
			// Spawn some explosions
			for (var i:int = 0; i < amount; i++) {
				
				var explosion:ExplosionParticle = new ExplosionParticle(
					charge.x - (radius / 2) + (Math.random() * radius), 
					charge.y - (radius / 2) + (Math.random() * radius)
				);
				
				explosion.isDepthChargeExplosion = true;
				this._explosions.add(explosion);
			}
			
			this._depthCharges.remove(charge, true);
			
		}
		
		public function detonateCharge(charge:DepthCharge = null) : void
		{
			
			if (!charge) {
				charge = this._charge;
			}
			
			// Can spawn again
			this.isDroppingCharge = false;
			
			// Update internal state
			this._usedCharges++;
			
			// Hide the charge
			charge.visible        = false;
			charge.velocity.y     = 0;
			charge.acceleration.y = 0;
			
			// Calculate explosion radius
			var radius:int = charge.explosionRadius();
			var amount:int = charge.explosionSize();
			
			FlxG.play(ResourceDb.snd_Explosions[Math.floor(Math.random() * ResourceDb.snd_Explosions.length)]);
			
			// Spawn some explosions
			for (var i:int = 0; i < amount; i++) {
				
				var explosion:ExplosionParticle = new ExplosionParticle(
					charge.x - (radius / 2) + (Math.random() * radius), 
					charge.y - (radius / 2) + (Math.random() * radius)
				);
				
				explosion.isDepthChargeExplosion = true;
				this._explosions.add(explosion);
			}
			
			// Spawn cluster bombs
			if (charge.type == POWERUP_CLUSTER_BOMB) {
				
				// Spawn 5 more
				this._depthCharges.add(DepthCharge.createClusterPart(this._charge.x, this._charge.y, -10, 2.5, this.onChargeDetonated));
				this._depthCharges.add(DepthCharge.createClusterPart(this._charge.x, this._charge.y, -5,  5, this.onChargeDetonated));
				this._depthCharges.add(DepthCharge.createClusterPart(this._charge.x, this._charge.y,  0,  7, this.onChargeDetonated));
				this._depthCharges.add(DepthCharge.createClusterPart(this._charge.x, this._charge.y,  5,  5, this.onChargeDetonated));
				this._depthCharges.add(DepthCharge.createClusterPart(this._charge.x, this._charge.y,  10, 2.5, this.onChargeDetonated));
				
			}
			
			if (charge.type == POWERUP_MISSILE_BOMB) {
				
				// Spawn 5 more
				this._depthCharges.add(DepthCharge.createHomingPart(this._enemies.getRandom() as EnemySubmarine, this._charge.x, this._charge.y, -10, -2.5, this.onChargeDetonated));
				this._depthCharges.add(DepthCharge.createHomingPart(this._enemies.getRandom() as EnemySubmarine, this._charge.x, this._charge.y, -5,  -5, this.onChargeDetonated));
				this._depthCharges.add(DepthCharge.createHomingPart(this._enemies.getRandom() as EnemySubmarine, this._charge.x, this._charge.y,  0,  -7, this.onChargeDetonated));
				this._depthCharges.add(DepthCharge.createHomingPart(this._enemies.getRandom() as EnemySubmarine, this._charge.x, this._charge.y,  5,  -5, this.onChargeDetonated));
				this._depthCharges.add(DepthCharge.createHomingPart(this._enemies.getRandom() as EnemySubmarine, this._charge.x, this._charge.y,  10, -2.5, this.onChargeDetonated));
				
			}
			
			if (this._stage.levelType == ContentDb.LEVEL_TYPE_NIGHT) {
				for each (var sub:EnemySubmarine in this._enemies.members) {
					sub.reactToSonarPing(60);
				}
			}
			
		}
		
		public function makePlayerParts(limit:int = 4) : void
		{
			
			this._player.visible = false;
			
			var sectionWidth:Number = this.player.width / limit;
			var middle:Number       = limit / 2;
			
			for (var i:int = 0; i < limit; i++) {
				
				var part:FlxSprite = new FlxSprite(this.player.x + (i * sectionWidth), this.player.y);
				part.loadGraphic(ResourceDb.gfx_Player, true, false, sectionWidth, this.player.height);
				part.frame = i;
				
				part.velocity.x = (i - middle) * 2;
				
				part.acceleration.y = 4 + (Math.abs(i - middle) * 0.75);
				
				this._playerParts.add(part);
			}
			
		}
		
		public function createMineLayer() : void
		{
			
			FlxG.play(ResourceDb.snd_Plane);
			
			this._mineLayer.x = -10;
			this._mineLayer.y = 10 + (Math.random() * 10);
			this._mineLayer.visible = true;
			this._mineLayer.velocity.x = 50 + (25 * Math.random());
			this._mineLayer.health = 1;
			this._mineLayer.play("fly");
		}
		
		public function createEnemy() : void
		{
			
			// Create the submarine
			var enemy:EnemySubmarine = new EnemySubmarine(90 + (180 * Math.random()));
			
			// Update speed based on multiplier
			enemy.velocity.x = enemy.velocity.x * this._stage.speedMultiplier;
			
			// Update aggression and callbacks
			enemy.aggression = this._stage.enemyAggression;
			enemy.fireMissileCallback = this.fireMissile;
			
			// Hide the enemy if at night
			if (this._stage.levelType == ContentDb.LEVEL_TYPE_NIGHT) {
				enemy.alpha = 0;
			}
			
			this._enemies.add(enemy);
			
		}

		/**
		 * Make an enemy fire a missile.
		 * 
		 * @param	enemy
		 */
		public function fireMissile(enemy:EnemySubmarine) : void
		{
			
			// Create the missile
			var missile:EnemyMissile = new EnemyMissile(enemy.x + enemy.width / 2, enemy.y, 1);
			
			// Add to the main loop
			this._missiles.add(missile);
			
		}
		
		/**
		 * Destroys all missiles. Called at the end of the level so that when
		 * the player is stationary they're not destroyed.
		 */
		public function destroyMissiles() : void
		{
			for each (var missile:EnemyMissile in this._missiles.members) {
				this.detonateMissile(missile);
			}
			this._missiles.clear();
		}
		
		public function destroyMines() : void
		{
			for each (var mine:EnemyMine in this._mines.members) {
				this.onMineDetonated(mine);
			}
			this._mines.clear();
		}
		
		public function destroyPowerup() : void
		{
			if (this._powerupCrate.visible) {
				
				this._powerupCrate.visible = false;
				
				// Explode
				for (var i:int = 0; i < 3; i++) {
					var explosion:ExplosionParticle = new ExplosionParticle(this._powerupCrate.x + (13 * Math.random()), this._powerupCrate.y + 14 + (6 * Math.random()));
					explosion.isDepthChargeExplosion = false;
					explosion.isEnemyExplosion       = false;
					this._explosions.add(explosion);
				}
				
				// Make some smoke
				for (var i:int = 0; i < 10; i++) {
					this._smoke.x = this._powerupCrate.x + (13 * Math.random());
					this._smoke.y = this._powerupCrate.y + 14 + (6 * Math.random());
					
					this._smoke.emitParticle();
				}
				
			}
		}

		
		public function clearMissiles() : void
		{
			for each (var missile:EnemyMissile in this._missiles.members) {
				missile.visible = false;
				missile.kill();
				missile.destroy();
				this._missiles.remove(missile, true);
			}
		}
		
		public function clearEnemies() : void
		{
			
			for each (var enemy:EnemySubmarine in this._enemies.members) {
				enemy.kill();
				enemy.destroy();
			}
			
			this._enemies.clear();
			
		}
		
		public function disableAi() : void
		{
			for each (var enemy:EnemySubmarine in this._enemies.members) {
				enemy.canUpdateAi = false;
			}
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
					
					// Stop the ship
					this.player.stop();
					
					this._overlay = new LevelCompleteOverlay(this);
					this.add(this._overlay);
					break;
				
				// Level complete - player failed
				case STATE_LEVEL_FAILED:
					
					// Stop the timer
					this._timer.stop();
					
					// Stop the ship
					this.player.stop();
					
					// Set the high score
					if (SessionDb.score > SessionDb.highScore) {
						SessionDb.highScore = SessionDb.score;
						this._highscoreLabel.text = this.formatNumber(SessionDb.highScore) + "\nhigh";
					}
					
					this._overlay = new MissionFailedOverlay();
					this.add(this._overlay);
					break;
				
				case STATE_PLAYING:
					
					// Load the stage data
					this._stage = ContentDb.getLevel(SessionDb.currentLevel);
					
					if (this._stage.stageNumber == 1 && this._player.isDamaged()) {
						this.givePowerup(POWERUP_REPAIR);
					}
					
					// Setup data based on session
					this._usedCharges    = 0;
					this._usedSonars     = 0;
					this._destroyedSubs  = 0;
					this._timeRemaining  = this._stage.timeLimit;
					this._currentPowerup = 0;
					
					this._chargesLabel.visible = (this._stage.chargeLimit > 0);
					this._sonarLabel.visible   = (this._stage.sonarLimit  > 0);
					
					// Background changes
					if (this._stage.levelType != this._currentLevelType) {
						this.changeTimeOfDay();
					}
					
					// Set the current level type
					this._currentLevelType = this._stage.levelType;
					
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
		
		public function changeTimeOfDay() : void
		{
			
			switch (this._stage.levelType) {
				
				case ContentDb.LEVEL_TYPE_SUNNY:				
					this._skyTransition.loadGraphic(ResourceDb.gfx_DaySky);
					this._seaTransition.loadGraphic(ResourceDb.gfx_DaySea);
					break;
				
				case ContentDb.LEVEL_TYPE_SUNSET:
					this._skyTransition.loadGraphic(ResourceDb.gfx_SunsetSky);
					this._seaTransition.loadGraphic(ResourceDb.gfx_SunsetSea);
					break;
				
				case ContentDb.LEVEL_TYPE_NIGHT:
					this._skyTransition.loadGraphic(ResourceDb.gfx_NightSky);
					this._seaTransition.loadGraphic(ResourceDb.gfx_NightSea);
					this._bgMoon.visible = true;
					this._bgMoon.alpha   = 0;
					break;
				
			}
			
			this._skyTransition.visible = true;
			this._skyTransition.alpha   = 0;
			
			this._seaTransition.visible = true;
			this._seaTransition.alpha   = 0;
			
			this._transitionTimer = new Timer(64, 30);
			this._transitionTimer.addEventListener(TimerEvent.TIMER, this.fadeBackground);
			this._transitionTimer.start();
			
		}
		
		public function fadeBackground(data:Object) : void
		{
			
			this._skyTransition.alpha += (1 / 29);
			this._seaTransition.alpha += (1 / 29);
			
			if (this._stage.levelType == ContentDb.LEVEL_TYPE_NIGHT) {
				this._bgMoon.alpha += (1 / 29);
			} else {
				if (this._bgMoon.visible) {
					this._bgMoon.alpha -= (1 / 29);
				}
			}
			
			if (this._skyTransition.alpha >= 1) {
				this._transitionTimer.stop();
				this._transitionTimer = null;
				this.rebuildBackground();
				this._skyTransition.visible = false;
				this._seaTransition.visible = false;
			}
			
		}
		
		/**
		 * Redraw the background...
		 */
		public function rebuildBackground() : void
		{
			
			trace("Called!");
			
			switch (this._stage.levelType) {
				
				case ContentDb.LEVEL_TYPE_SUNNY:
					
					this._bgSky.loadGraphic(ResourceDb.gfx_DaySky);
					this._bgSea.loadGraphic(ResourceDb.gfx_DaySea);
					
					for each (var cloud:FlxSprite in this._bgClouds.members) {
						cloud.loadGraphic(ResourceDb.gfx_DayClouds, true, false, 42, 4);
						cloud.frame = Math.floor(Math.random() * 5);
						cloud.alpha = 0.8;
					}
					this._bgMoon.visible = false;
					
					break;
				
				case ContentDb.LEVEL_TYPE_SUNSET:
					
					this._bgSky.loadGraphic(ResourceDb.gfx_SunsetSky);
					this._bgSea.loadGraphic(ResourceDb.gfx_SunsetSea);
					
					for each (var cloud:FlxSprite in this._bgClouds.members) {
						cloud.loadGraphic(ResourceDb.gfx_SunsetClouds, true, false, 42, 4);
						cloud.frame = Math.floor(Math.random() * 5);
						cloud.alpha = 0.5;
					}
					
					this._bgMoon.visible = false;	
					
					break;
				
				case ContentDb.LEVEL_TYPE_NIGHT:
					
					this._bgSky.loadGraphic(ResourceDb.gfx_NightSky);
					this._bgSea.loadGraphic(ResourceDb.gfx_NightSea);
					
					for each (var cloud:FlxSprite in this._bgClouds.members) {
						cloud.loadGraphic(ResourceDb.gfx_NightClouds, true, false, 42, 4);
						cloud.frame = Math.floor(Math.random() * 5);
						cloud.alpha = 0.5;
					}
					this._bgMoon.visible = true;
					break;
				
			}
			
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
		
		public function get player() : Player
		{
			return this._player;
		}		
		
		// ----------------------------------------------------------------------
		// -- Construction
		// ----------------------------------------------------------------------
		
		override public function create():void
		{
			
			super.create();
			
			this._currentLevelType = ContentDb.LEVEL_TYPE_SUNNY;
			
			// Create the initial sky
			this._bgSky         = new FlxSprite(0, 0, ResourceDb.gfx_DaySky);
			this._skyTransition = new FlxSprite(0, 0, ResourceDb.gfx_DaySky);
			
			this._bgMoon = new FlxSprite(FlxG.width - 32, 8, ResourceDb.gfx_NightMoon);
			this._bgMoon.visible = false;
			
			// Add some clouds
			this._bgClouds = new FlxGroup();
			for (var i:int = 0; i < 5; i++) {
				var cloud:FlxSprite = new FlxSprite(FlxG.width, Math.floor(Math.random() * 40));
				cloud.loadGraphic(ResourceDb.gfx_DayClouds, true, false, 42, 4);
				cloud.frame = Math.floor(Math.random() * 5);
				cloud.velocity.x = -1 * (Math.random() * 2);
				cloud.x = (Math.random() * FlxG.width);
				cloud.alpha = 0.8;
				this._bgClouds.add(cloud);
			}
			
			
			// Create the sea
			this._bgSea         = new FlxSprite(0, 71, ResourceDb.gfx_DaySea);
			this._seaTransition = new FlxSprite(0, 71, ResourceDb.gfx_DaySea);
			
			// Add some objects
			this._player = new Player((FlxG.width - 48) / 2, 55, ResourceDb.gfx_Player);
			this._player.drag.x = 10;
			this._player.maxVelocity.x = 25;
			this._playerParts = new FlxGroup();
			
			this._charge = new DepthCharge(-100, -100);
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

			this._smoke = new FlxEmitter(0, 0, 100);
			this._smoke.setRotation(0, 0);
			this._smoke.lifespan = 3;
			this._smoke.particleClass = SmokeParticle;
			
			for (var i:int = 0; i < 100; i++) {
				this._smoke.add(new SmokeParticle());
			}

			this._fire = new FlxEmitter(0, 0, 100);
			this._fire.setRotation(0, 0);
			this._fire.lifespan = 3;
			this._fire.particleClass = FireParticle;
			
			for (var i:int = 0; i < 100; i++) {
				this._fire.add(new FireParticle());
			}
			
			this._splashes = new FlxEmitter(0, 0, 250);
			this._splashes.setRotation(0, 0);
			this._splashes.lifespan = 2;
			this._splashes.particleClass = WaterSplashParticle;
			
			for (var i:int = 0; i < 250; i++) {
				this._splashes.add(new WaterSplashParticle());
			}
			
			// Create the UI
			this._scoreLabel = new FlxText(2, 0, 60, "00000000\nScore");
			this._scoreLabel.font = "tinyfont";
			this._scoreLabel.size = 10;
			
			this._highscoreLabel = new FlxText(162, 0, 60, this.formatNumber(SessionDb.highScore) + "\nhigh");
			this._highscoreLabel.font = "tinyfont";
			this._highscoreLabel.alignment = "right";
			this._highscoreLabel.size = 10;
			
			this._timerLabel = new FlxText(0, 0, FlxG.width, "");
			this._timerLabel.font = "tinyfont";
			this._timerLabel.size = 20;
			this._timerLabel.alignment = "center";
			
			this._chargesLabel = new FlxText(0, FlxG.height - 12, 120, "X Charges Left");
			this._chargesLabel.font = "tinyfont";
			this._chargesLabel.alignment = "left";
			this._chargesLabel.size = 10;
			
			this._sonarLabel = new FlxText(FlxG.width - 120, FlxG.height - 12, 120, "X Sonars Remaining");
			this._sonarLabel.font = "tinyfont";
			this._sonarLabel.alignment = "right";
			this._sonarLabel.size = 10;
			
			// Hide labels
			this._sonarLabel.visible = false;
			this._chargesLabel.visible = false;
			
			// Plane!
			this._mineLayer = new FlxSprite(0, 0);
			this._mineLayer.loadGraphic(ResourceDb.gfx_MineLayer, true, false, 26, 11);
			this._mineLayer.addAnimation("fly", [0, 1, 2, 1], 20);
			this._mineLayer.visible = false;
			
			this._powerupCrate = new PowerupCrate(-100);
			
			// Missiles and things
			this._missiles     = new FlxGroup();
			this._mines        = new FlxGroup();
			this._depthCharges = new FlxGroup();
			
			// Animals
			this._animals = new FlxGroup();
			
			// Sonar
			this._sonarWave = new FlxSprite(0, 72);
			this._sonarWave.makeGraphic(FlxG.width, 2);
			this._sonarWave.visible = false;
			
			// Add everything!
			this.add(this._bgSky);
			this.add(this._skyTransition);
			
			this.add(this._bgMoon);

			this.add(this._bgClouds);
			
			this.add(this._bgSea);
			this.add(this._seaTransition);
			
			this.add(this._bubbles);
			
			this.add(this._fire);
			this.add(this._smoke);
			
			this.add(this._player);
			this.add(this._playerParts);
			
			this.add(this._enemies);
			this.add(this._charge);
			this.add(this._depthCharges);
			this.add(this._missiles);
			this.add(this._mines);
			this.add(this._animals);
			
			this.add(this._mineLayer);
			
			this.add(this._powerupCrate);

			this.add(this._splashes);
			this.add(this._explosions);
			
			this.add(this._sonarWave);
			
			// Add the UI
			this.add(this._scoreLabel);
			this.add(this._highscoreLabel);
			this.add(this._timerLabel);
			
			this.add(this._sonarLabel);
			this.add(this._chargesLabel);
			
			// Enter the initial play state
			this.enterState(STATE_LEVEL_START);
			//this.enterState(this.STATE_PLAYING);
			
		}
		
	}

}