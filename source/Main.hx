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
		addChild(new FlxGame(576, 324, Startup, 1, 144, 144, true));
		FlxG.autoPause = false;
		
		fpsDisplay = new FPS(10, 3, 0xFFFFFF);
		fpsDisplay.visible = true;
		addChild(fpsDisplay);
		
	}
}
