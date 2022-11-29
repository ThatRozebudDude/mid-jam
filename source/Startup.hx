package;

import transition.data.FadeOut;
import transition.data.FadeIn;
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

class Startup extends FlxState
{

	override public function create()
	{
		super.create();

		//"Uncapped" fps. maybe some other time
		//openfl.Lib.current.stage.frameRate = 999;
		
		FlxG.mouse.visible = false;

		UIStateExt.defaultTransIn = FadeIn;
        UIStateExt.defaultTransInArgs = [0.25];
        UIStateExt.defaultTransOut = FadeOut;
        UIStateExt.defaultTransOutArgs = [0.25];

		//used to prevent weird audio issues on html5, idk if its just me but shit gets weird
		FlxG.sound.play("assets/sounds/silence.ogg");
	}

	override function update(elapsed){
		super.update(elapsed);
		FlxG.switchState(new StartCutscene());
	}

}