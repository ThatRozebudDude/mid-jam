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

class SongSelect extends UIStateExt
{

	final songList:Array<String> = ["tutorial", "earlyMorninBooze", "drunkenDoSiDo"];
	final songNames:Array<String> = ["Tutorial", "Early Mornin' Booze", "Drunken So-Si-Do"];
	static var selected = 0;

	var currAlbum:FlxSprite;
	var prevAlbum:FlxSprite;
	var nextAlbum:FlxSprite;

	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var songNameText:FlxText;

	var started:Bool = false;

	override public function create()
	{
		super.create();

		if(FlxG.sound.music != null) {
			if(!FlxG.sound.music.playing){
				FlxG.sound.playMusic("assets/music/menuMusic.ogg", 0.9);
			}
		}

		var bg = new FlxSprite().loadGraphic("assets/images/bg.png");
		var overlay = new FlxSprite().makeGraphic(600, 600, 0x774F2632);
		var backButton = new FlxSprite().loadGraphic("assets/images/pressEscape.png");

		currAlbum = new FlxSprite().loadGraphic("assets/images/album/"+songList[keepInRange(selected)]+".png");
		currAlbum.screenCenter(XY);
		
		prevAlbum = new FlxSprite().loadGraphic("assets/images/album/"+songList[keepInRange(selected-1)]+".png");
		prevAlbum.x = currAlbum.x - 110;
		prevAlbum.scale.set(0.8, 0.8);
		prevAlbum.screenCenter(Y);
		prevAlbum.alpha = 0.6;	

		nextAlbum = new FlxSprite().loadGraphic("assets/images/album/"+songList[keepInRange(selected+1)]+".png");
		nextAlbum.x = currAlbum.x + currAlbum.width - 70;
		nextAlbum.scale.set(0.8, 0.8);
		nextAlbum.screenCenter(Y);
		nextAlbum.alpha = 0.6;

		leftArrow = new FlxSprite(36).loadGraphic("assets/images/arrowButton.png");
		leftArrow.flipX = true;
		leftArrow.screenCenter(Y);

		rightArrow = new FlxSprite().loadGraphic("assets/images/arrowButton.png");
		rightArrow.x = FlxG.width - rightArrow.width - 36;
		rightArrow.screenCenter(Y);

		songNameText = new FlxText(0, 0, 0, songNames[keepInRange(selected)], 24);
		songNameText.setFormat(null, 24, 0xFFFBD0B5, LEFT, OUTLINE, 0xFF4F2632);
		songNameText.borderSize = 3;
		songNameText.screenCenter(X);
		songNameText.y = (FlxG.height * 0.875) - songNameText.height/2;

		add(bg);
		add(overlay);

		add(prevAlbum);
		add(nextAlbum);
		add(currAlbum);

		add(leftArrow);
		add(rightArrow);
		add(songNameText);

		add(backButton);

	}

	override function update(elapsed){
		super.update(elapsed);

		if(!started){
			if(FlxG.keys.justPressed.ESCAPE){
				FlxG.sound.play("assets/sounds/catchSound.ogg");
				switchState(new MainMenu());
			}
			else if(FlxG.keys.anyJustPressed([A, LEFT])){
				rotateAlbums(-1);
				FlxG.sound.play("assets/sounds/catchSound.ogg");
			}
			else if(FlxG.keys.anyJustPressed([D, RIGHT])){
				rotateAlbums(1);
				FlxG.sound.play("assets/sounds/catchSound.ogg");
			}
			else if(FlxG.keys.anyJustPressed([SPACE, ENTER])){
				PlayState.songName = songList[selected];
				FlxG.sound.play("assets/sounds/catchSound.ogg");
				switchState(new PlayState());
				started = true;
			}
		}
		
	}

	function keepInRange(value:Int){
		if(value > songList.length-1) { return 0; }
		else if(value < 0) { return songList.length-1; }
		return value;
	}

	function rotateAlbums(change:Int = 0){
		selected = keepInRange(selected+change);

		currAlbum.loadGraphic("assets/images/album/"+songList[selected]+".png");
		prevAlbum.loadGraphic("assets/images/album/"+songList[keepInRange(selected-1)]+".png");
		nextAlbum.loadGraphic("assets/images/album/"+songList[keepInRange(selected+1)]+".png");

		songNameText.text = songNames[selected];
		songNameText.screenCenter(X);
	}

}
