package;

import openfl.display.FPS;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{

	var fpsDisplay:FPS;

	public function new()
	{
		super();

		//Game was lagging and being weird on HTML5 on my laptop so I made the target FPS on HTML lower.  
		var fpsTarget = 60;

		#if desktop
		fpsTarget = 144; //ALL HAIL DESKTOP TARGET!!!!!!!
		#end

		addChild(new FlxGame(576, 324, Startup, fpsTarget, fpsTarget, true));
		FlxG.autoPause = false;
		
		fpsDisplay = new FPS(10, 3, 0xFFFFFF);
		fpsDisplay.visible = true;
		//addChild(fpsDisplay);
		
	}
}
