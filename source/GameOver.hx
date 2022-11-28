package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import transition.data.StrangeExpandIn;
import flixel.text.FlxText;
import flixel.input.keyboard.FlxKey;
import transition.data.BasicTransition;
import flixel.system.FlxSound;
import openfl.desktop.ClipboardFormats;
import openfl.desktop.Clipboard;
import haxe.ds.ArraySort;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUI;
import lime.ui.FileDialogType;
import lime.ui.FileDialog;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.addons.ui.FlxUITabMenu;

class GameOver extends UIStateExt
{

	var retry:FlxSprite;
	var canRetry:Bool = false;

	override public function create()
	{
		super.create();

		var bg = new FlxSprite().makeGraphic(600, 600, 0xFF4F2632);
		retry = new FlxSprite().loadGraphic("assets/images/tryAgain.png");
		retry.screenCenter(XY);
		retry.alpha = 0;

		FlxG.sound.play("assets/sounds/bigGlassShatter.ogg", 1, false, null, true, function(){
			canRetry = true;
			FlxTween.tween(retry, {alpha: 1}, 0.5);
		});
		FlxG.sound.play("assets/sounds/crowdGasp.ogg");
		FlxG.sound.playMusic("assets/sounds/crowdLoop.ogg", 0.7);

		add(bg);
		add(retry);

	}

	override function update(elapsed){
		super.update(elapsed);

		if(FlxG.keys.justPressed.ESCAPE){
			FlxG.sound.play("assets/sounds/catchSound.ogg");
			switchState(new SongSelect());
			FlxG.sound.music.stop();
			canRetry = false;
		}

		if(canRetry){
			if(FlxG.keys.anyJustPressed([SPACE, ENTER, Settings.binds[0], Settings.binds[1], Settings.binds[2]])){
				FlxG.sound.play("assets/sounds/catchSound.ogg");
				switchState(new PlayState());
				canRetry = false;
			}
		}
		
	}

}
