package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;

class Settings extends UIStateExt
{
	var mode = "select";
	var bindNumber = 0;

	var overlay = new FlxSprite().makeGraphic(600, 600, 0xAA4F2632);
	var pressToRebind:FlxText;

	var redBindText:FlxText;
	var blueBindText:FlxText;
	var greenBindText:FlxText;

	var guyRed:Character;
	var guyBlue:Character;
	var guyGreen:Character;

	override public function create()
	{
		super.create();

		var bg = new FlxSprite().loadGraphic("assets/images/stages/bar/bg.png");
		var bar = new FlxSprite().loadGraphic("assets/images/stages/bar/counter.png");
		var backButton = new FlxSprite().loadGraphic("assets/images/pressEscape.png");

		var instructions = new FlxText(0, 32, 0, "PRESS THE KEY YOU WANT TO REBIND", 16);
		instructions.setFormat(null, 16, 0xFFFBD0B5, LEFT, OUTLINE, 0xFF4F2632);
		instructions.borderSize = 3;
		instructions.screenCenter(X);

		guyRed = new Character(0, 123, "assets/images/characters/donny/body.png");
		guyBlue = new Character(0, 80, "assets/images/characters/johnny/body.png");
		guyGreen = new Character(0, 62, "assets/images/characters/olive/body.png");
		guyRed.x = (FlxG.width/4)*3 - (guyRed.width/2) + 40;
		guyBlue.x = FlxG.width/2 - guyBlue.width/2;
		guyGreen.x = (FlxG.width/4) - (guyGreen.width/2) - 40;

		pressToRebind = new FlxText(0, 0, 0, "PRESS ANY KEY", 16);
		pressToRebind.setFormat(null, 16, 0xFFFBD0B5, LEFT, OUTLINE, 0xFF4F2632);
		pressToRebind.borderSize = 3;
		pressToRebind.screenCenter(XY);

		overlay.visible = false;
		pressToRebind.visible = false;

		redBindText = new FlxText(0, 0, 0, "["+SaveData.binds[0].toString().toUpperCase()+"]", 24);
		redBindText.setFormat(null, 24, 0xFFF2EDE5, LEFT, OUTLINE, 0xFF4F2632);
		redBindText.borderSize = 3;
		redBindText.x = (guyRed.getMidpoint().x - redBindText.width/2) - 5;
		redBindText.y = (FlxG.height/2) + 72;
		FlxTween.tween(redBindText, {y: redBindText.y+5}, Conductor.quarterNoteTime/1000, {ease: FlxEase.sineInOut, type: PINGPONG});


		blueBindText = new FlxText(0, 0, 0, "["+SaveData.binds[1].toString().toUpperCase()+"]", 24);
		blueBindText.setFormat(null, 24, 0xFFF2EDE5, LEFT, OUTLINE, 0xFF4F2632);
		blueBindText.borderSize = 3;
		blueBindText.x = (guyBlue.getMidpoint().x - blueBindText.width/2) - 5;
		blueBindText.y = (FlxG.height/2) + 72;
		FlxTween.tween(blueBindText, {y: blueBindText.y+5}, Conductor.quarterNoteTime/1000, {ease: FlxEase.sineInOut, type: PINGPONG});

		greenBindText = new FlxText(0, 0, 0, "["+SaveData.binds[2].toString().toUpperCase()+"]", 24);
		greenBindText.setFormat(null, 24, 0xFFF2EDE5, LEFT, OUTLINE, 0xFF4F2632);
		greenBindText.borderSize = 3;
		greenBindText.x = guyGreen.getMidpoint().x - greenBindText.width/2;
		greenBindText.y = (FlxG.height/2) + 72;
		FlxTween.tween(greenBindText, {y: greenBindText.y+5}, Conductor.quarterNoteTime/1000, {ease: FlxEase.sineInOut, type: PINGPONG});


		add(bg);

		add(guyRed);
		add(guyBlue);
		add(guyGreen);

		add(bar);

		add(instructions);
		add(redBindText);
		add(blueBindText);
		add(greenBindText);

		add(overlay);
		add(pressToRebind);

		add(backButton);

		Conductor.bpm = 100;
	}

	override function update(elapsed){
		switch(mode){
			case "changingBind":
				overlay.visible = true;
				pressToRebind.visible = true;

				if(FlxG.keys.justPressed.ESCAPE){
					mode = "select";
					updateText();
					FlxG.sound.play("assets/sounds/catchSound.ogg");
					switch(bindNumber){
						case 1:
							guyBlue.idle();
							guyBlue.bop(2);
						case 2:
							guyGreen.idle();
							guyGreen.bop(2);
						default:
							guyRed.idle();
							guyRed.bop(2);
					}
				}
				else if(FlxG.keys.anyJustPressed(FlxG.sound.volumeDownKeys.concat(FlxG.sound.volumeUpKeys).concat(FlxG.sound.muteKeys))){}
				else if(FlxG.keys.justPressed.ANY){
					var justPressed = FlxG.keys.getIsDown()[0].ID;
					if(!SaveData.binds.contains(justPressed)){ SaveData.binds[bindNumber] = justPressed; }
					mode = "select";
					updateText();
					FlxG.sound.play("assets/sounds/catchSound.ogg");
					switch(bindNumber){
						case 1:
							guyBlue.idle();
							guyBlue.bop(2);
						case 2:
							guyGreen.idle();
							guyGreen.bop(2);
						default:
							guyRed.idle();
							guyRed.bop(2);
					}
				}

			default:
				overlay.visible = false;
				pressToRebind.visible = false;

				if(FlxG.keys.justPressed.ESCAPE){
					FlxG.sound.play("assets/sounds/catchSound.ogg");
					SaveData.write();
					switchState(new MainMenu());
				}
				else if(FlxG.keys.anyJustPressed([SaveData.binds[0]])){
					mode = "changingBind";
					bindNumber = 0;
					FlxG.sound.play("assets/sounds/catchSound.ogg");
					guyRed.drink();
				}
				else if(FlxG.keys.anyJustPressed([SaveData.binds[1]])){
					mode = "changingBind";
					bindNumber = 1;
					FlxG.sound.play("assets/sounds/catchSound.ogg");
					guyBlue.drink();
				}
				else if(FlxG.keys.anyJustPressed([SaveData.binds[2]])){
					mode = "changingBind";
					bindNumber = 2;
					FlxG.sound.play("assets/sounds/catchSound.ogg");
					guyGreen.drink();
				}
		}
		
	}

	function updateText(){
		redBindText.text = "["+SaveData.binds[0].toString().toUpperCase()+"]";
		blueBindText.text = "["+SaveData.binds[1].toString().toUpperCase()+"]";
		greenBindText.text = "["+SaveData.binds[2].toString().toUpperCase()+"]";
		redBindText.x = (guyRed.getMidpoint().x - redBindText.width/2) - 5;
		blueBindText.x = (guyBlue.getMidpoint().x - blueBindText.width/2) - 5;
		greenBindText.x = guyGreen.getMidpoint().x - greenBindText.width/2;
	}

}
