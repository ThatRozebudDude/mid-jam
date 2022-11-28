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

class MainMenu extends UIStateExt
{

	static final VERSION = "Test 6";
	
	var menuButtons:Array<FlxSprite> = [];
	final menuButtonStrings:Array<String> = ["play", "settings", "credits"];
	var menuSelected = 0;

	override public function create()
	{
		super.create();

		//var titleBG = new FlxSprite().loadGraphic("assets/images/temp/title.png");
		//add(titleBG);

		if(FlxG.sound.music != null) {
			if(!FlxG.sound.music.playing){
				FlxG.sound.playMusic("assets/music/menuMusic.ogg", 0.9);
			}
		}

		var bg = new FlxSprite().loadGraphic("assets/images/menu/bg.png");
		var counter = new FlxSprite().loadGraphic("assets/images/menu/counter.png");
		var logo = new FlxSprite(0, 12).loadGraphic("assets/images/menu/logo.png");
		logo.screenCenter(X);

		var aria = new FlxSprite(87, 91).loadGraphic("assets/images/aria.png", true, 136, 157);
		aria.animation.add("polish", [6, 7], 2, true);
		aria.animation.play("polish", true);

		var versionText = new FlxText(4, FlxG.height, 0, "Version: " + VERSION, 8);
		versionText.setFormat(null, 8, 0xFFFBD0B5, LEFT, OUTLINE, 0xFF4F2632);
		versionText.borderSize = 2;
		versionText.y -= versionText.height + 4;

		for(i in 0...menuButtonStrings.length){
			var button = new FlxSprite(300, 105 + 70*i).loadGraphic("assets/images/menu/" + menuButtonStrings[i] + ".png", true, 200, 50);
			button.animation.add("off", [0], 0, false);
			button.animation.add("on", [1], 0, false);
			button.animation.play("off");
			menuButtons.push(button);
		}
		updateButtons();

		add(bg);
		add(aria);
		add(counter);
		add(logo);
		add(versionText);
		for(x in menuButtons){
			add(x);
		}

	}

	override function update(elapsed){
		super.update(elapsed);

		if(FlxG.keys.justPressed.O){
			PlayState.songName = "kickback";
			switchState(new PlayState());
		}

		if(FlxG.keys.anyJustPressed([W, UP])){
			moveSelection(-1);
			FlxG.sound.play("assets/sounds/catchSound.ogg");
		}
		else if(FlxG.keys.anyJustPressed([S, DOWN])){
			moveSelection(1);
			FlxG.sound.play("assets/sounds/catchSound.ogg");
		}
		else if(FlxG.keys.anyJustPressed([SPACE, ENTER])){
			switch(menuSelected){
				case 0:
					FlxG.sound.play("assets/sounds/catchSound.ogg");
					switchState(new SongSelect());
				case 1:
					FlxG.sound.play("assets/sounds/catchSound.ogg");
					switchState(new Settings());
			}
		}
	}

	function moveSelection(change:Int = 0){
		menuSelected += change;
		if(menuSelected < 0) { menuSelected = menuButtons.length-1; }
		if(menuSelected > menuButtons.length-1) { menuSelected = 0; }
		updateButtons();
	}

	function updateButtons(){
		for(i in 0...menuButtons.length){
			if(i == menuSelected){
				menuButtons[i].animation.play("on");
			}
			else{
				menuButtons[i].animation.play("off");
			}
		}
	}

}