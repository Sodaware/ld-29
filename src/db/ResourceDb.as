package db 
{
	
	import flash.text.Font;
	
	public class ResourceDb 
	{
		
		// Fonts
		[Embed(source = "../../assets/ui/smallest_pixel-7.ttf", fontFamily="tinyfont", embedAsCFF="false", mimeType="application/x-font")] public static var fnt_TinyFont : String;
		
		// Title Screen
		[Embed(source = "../../assets/ui/logo.png")] public static var gfx_Logo:Class;
		
		// Backgrounds - Day
		[Embed(source = "../../assets/backgrounds/sky-day.png")] public static var gfx_DaySky:Class;
		[Embed(source = "../../assets/backgrounds/clouds-day.png")] public static var gfx_DayClouds:Class;
		[Embed(source = "../../assets/backgrounds/sea-day.png")] public static var gfx_DaySea:Class;
		
		// Backgrounds - Sunset
		[Embed(source = "../../assets/backgrounds/sky-sunset.png")] public static var gfx_SunsetSky:Class;
		[Embed(source = "../../assets/backgrounds/clouds-sunset.png")] public static var gfx_SunsetClouds:Class;
		[Embed(source = "../../assets/backgrounds/sea-sunset.png")] public static var gfx_SunsetSea:Class;
		
		// Backgrounds - Night
		[Embed(source = "../../assets/backgrounds/sky-night.png")] public static var gfx_NightSky:Class;
		[Embed(source = "../../assets/backgrounds/clouds-night.png")] public static var gfx_NightClouds:Class;
		[Embed(source = "../../assets/backgrounds/sea-night.png")] public static var gfx_NightSea:Class;
		[Embed(source = "../../assets/backgrounds/moon-night.png")] public static var gfx_NightMoon:Class;
		
		// Objects
		[Embed(source = "../../assets/objects/player.png")] public static var gfx_Player:Class;
		[Embed(source = "../../assets/objects/submarine-left.png")] public static var gfx_SubmarineLeft:Class;
		[Embed(source = "../../assets/objects/submarine-right.png")] public static var gfx_SubmarineRight:Class;
		[Embed(source = "../../assets/objects/depth-charge.png")] public static var gfx_DepthCharge:Class;
		[Embed(source = "../../assets/objects/missile.png")] public static var gfx_Missile:Class;
		[Embed(source = "../../assets/objects/mine-layer.png")] public static var gfx_MineLayer:Class;
		[Embed(source = "../../assets/objects/mine.png")] public static var gfx_Mine:Class;
		[Embed(source = "../../assets/objects/powerup-crate.png")] public static var gfx_PowerupCrate:Class;
		
		// Ambient stuff
		[Embed(source = "../../assets/objects/fish.png")] public static var gfx_Fish:Class;
		
		// Particles
		[Embed(source = "../../assets/particles/explosion-small.png")] public static var gfx_ExplosionSmall:Class;
		
		// Audio
		[Embed(source = '../../assets/audio/explosion-01.mp3')] public static var snd_Explode1:Class;
		[Embed(source = '../../assets/audio/explosion-02.mp3')] public static var snd_Explode2:Class;
		[Embed(source = '../../assets/audio/explosion-03.mp3')] public static var snd_Explode3:Class;
		[Embed(source = '../../assets/audio/explosion-04.mp3')] public static var snd_Explode4:Class;
		[Embed(source = '../../assets/audio/explosion-05.mp3')] public static var snd_Explode5:Class;
		[Embed(source = '../../assets/audio/explosion-06.mp3')] public static var snd_Explode6:Class;
		[Embed(source = '../../assets/audio/explosion-07.mp3')] public static var snd_Explode7:Class;
		public static var snd_Explosions:Array = [snd_Explode1, snd_Explode2, snd_Explode3, snd_Explode4, snd_Explode5, snd_Explode6, snd_Explode7];
		
		[Embed(source = '../../assets/audio/splash-01.mp3')] public static var snd_Splash1:Class;
		[Embed(source = '../../assets/audio/splash-02.mp3')] public static var snd_Splash2:Class;
		public static var snd_Splashes:Array = [snd_Splash1, snd_Splash2];
		
		[Embed(source = '../../assets/audio/firework-01.mp3')] public static var snd_Firework1:Class;
		[Embed(source = '../../assets/audio/firework-02.mp3')] public static var snd_Firework2:Class;
		[Embed(source = '../../assets/audio/firework-03.mp3')] public static var snd_Firework3:Class;
		public static var snd_Fireworks:Array = [snd_Firework1, snd_Firework2, snd_Firework3];
		
		[Embed(source = '../../assets/audio/plane.mp3')] public static var snd_Plane:Class;
		[Embed(source = '../../assets/audio/powerup.mp3')] public static var snd_Powerup:Class;
		[Embed(source = '../../assets/audio/sonar.mp3')] public static var snd_Sonar:Class;
		
	}
	
}