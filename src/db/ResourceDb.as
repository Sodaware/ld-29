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
		
		// Objects
		[Embed(source = "../../assets/objects/player.png")] public static var gfx_Player:Class;
		[Embed(source = "../../assets/objects/submarine.png")] public static var gfx_Submarine:Class;
		
		[Embed(source = "../../assets/objects/depth-charge.png")] public static var gfx_DepthCharge:Class;
		
	}
	
}