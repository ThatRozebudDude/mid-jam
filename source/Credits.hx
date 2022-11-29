package;

import flixel.text.FlxText;
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

class Credits extends UIStateExt
{
	
	var guys:FlxSprite;
	var curGuy:Int = 0;

	override public function create()
	{
		super.create();

		var bg = new FlxSprite().loadGraphic("assets/images/bg.png");
		var backButton = new FlxSprite().loadGraphic("assets/images/pressEscape.png");

		guys = new FlxSprite().loadGraphic("assets/images/creditsGuys.png", true, 576, 324);
		guys.animation.add("the", [0, 1, 2, 3, 4, 5], 0, false);
		guys.animation.play("the");

		add(bg);
		add(guys);
		add(backButton);

	}

	override function update(elapsed){
		super.update(elapsed);

		if(FlxG.keys.justPressed.ESCAPE){
			FlxG.sound.play("assets/sounds/catchSound.ogg");
			switchState(new MainMenu());
		}

		if(FlxG.keys.anyJustPressed([W, UP, D, RIGHT, SPACE, ENTER])){
			moveSelection(1);
			FlxG.sound.play("assets/sounds/catchSound.ogg");
		}
		else if(FlxG.keys.anyJustPressed([S, DOWN, A, LEFT])){
			moveSelection(-1);
			FlxG.sound.play("assets/sounds/catchSound.ogg");
		}
	}

	function moveSelection(change:Int = 0){
		curGuy += change;
		if(curGuy < 0) { curGuy = 5; }
		if(curGuy > 5) { curGuy = 0; }
		guys.animation.frameIndex = curGuy;
	}

}