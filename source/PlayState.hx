package;

import transition.data.BasicTransition;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import haxe.Json;
import flixel.group.FlxGroup;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import openfl.utils.Assets;
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

import flash.media.Sound;

using StringTools;

class PlayState extends GameplaySongState
{
	public static var instance:PlayState;
	public static var songName:String = "jads";

	var song:FlxSound;

	var noteY = 250;
	var noteHitX:Array<Int> = [539, 411, 256];

	var noteSpeed:Float = 0.6;

	var guyRed:Character;
	var guyBlue:Character;
	var guyGreen:Character;

	var handRed:Character;
	var handBlue:Character;
	var handGreen:Character;

	var notes:FlxTypedSpriteGroup<Note> = new FlxTypedSpriteGroup<Note>();

	var combo:Combo = new Combo(4, 6);
	var hpIcons:Health = new Health(8, 8, 5);

	var crowdAmbientLoop:FlxSound = new FlxSound().loadEmbedded("assets/sounds/crowdLoop.ogg", true); 

	var noHudElementsMode:Bool = false;

	var aria:FlxSprite;
	final tutorialDialogue:Array<Array<String>> = [["talk", "Hey, you must be new 'round these parts."],
													["talk", "You'll need to catch the drinks I slide \nover to you."],
													["talk", "That's just how it works at this bar. You'll \nget used to it."],
													["laugh", "Here, give it a try!"],
													["laugh", "Nice one!"],
													["talk", "I'll just put that on your tab..."],
													["talk", "Oh, are these friends of yours?"],
													["laugh", "I suppose it doesn't really matter..."],
													["talk", "They look thirsty too... Guess I'll need \nto slide over even more drinks!"],
													["laugh", "Make sure you grab the right drink!"],
													["laugh", "Alright, seems like you got the hang of \nthis! I hope you're ready to get \nfuckin' trashed!"]];
	var tutorialText:FlxText;

	var latestHit:Bool = false;

	override public function create()
	{
		super.create();

		instance = this;

		if(FlxG.sound.music != null) {
			FlxG.sound.music.stop();
		}

		var bg = new FlxSprite().loadGraphic("assets/images/bg.png");
		var bar = new FlxSprite().loadGraphic("assets/images/counter.png");
		//var strumGuide = new FlxSprite().loadGraphic("assets/images/temp/strumGuide.png");
		//strumGuide.alpha = 0.3;

		guyRed = new Character(427, 133, "assets/images/guyRed.png", 150, 142);
		guyBlue = new Character(273, 90, "assets/images/guyBlue.png", 171, 184);
		guyGreen = new Character(124, 72, "assets/images/galGreen.png", 175, 200);

		handRed = new Character(508, 223, "assets/images/handRed.png", 63, 72);
		handBlue = new Character(377, 223, "assets/images/handBlue.png", 63, 72);
		handGreen = new Character(231, 241, "assets/images/handGreen.png", 55, 51);

		guyRed.child = handRed;
		guyBlue.child = handBlue;
		guyGreen.child = handGreen;

		add(bg);

		add(guyGreen);
		add(guyBlue);
		add(guyRed);

		add(bar);

		add(handRed);
		add(handBlue);
		add(handGreen);

		//add(hands);
		add(notes);
		add(hpIcons);
		add(combo);
		//add(strumGuide);

		var songPath = "assets/songs/" + songName + "/song.ogg";
		var chartPath = "assets/songs/" + songName + "/chart.json";
		
		song = new FlxSound().loadEmbedded(songPath);
		song.onComplete = endSong;
		add(song);

		Conductor.audioReference = song;
		generateNotes(chartPath);

		if(songName == "tutorial"){
			noHudElementsMode = true;
			remove(hpIcons);
			remove(combo);

			var ariaShadow = new FlxSprite(6, 110).loadGraphic("assets/images/ariaIndicator.png");

			aria = new FlxSprite(14, 9).loadGraphic("assets/images/aria.png", true, 136, 157);
			aria.animation.add("talk", [0, 1, 2, 0, 1, 2, 0, 1, 2], 12, false);
			aria.animation.add("laugh", [3, 4, 5, 3, 4, 5, 3, 4, 5], 12, false);
			aria.animation.add("polish", [6, 7], 2, true);
			aria.animation.play(tutorialDialogue[0][0], true);

			tutorialText = new FlxText(142, 32, 0, tutorialDialogue[0][1], 16);
			tutorialText.setFormat(null, 16, 0xFFFBD0B5, LEFT, OUTLINE, 0xFF4F2632);
			tutorialText.borderSize = 3;

			var redBindText = new FlxText(0, 0, 0, "["+Settings.binds[0].toString().toUpperCase()+"]", 24);
			redBindText.setFormat(null, 24, 0xFFF2EDE5, LEFT, OUTLINE, 0xFF4F2632);
			redBindText.borderSize = 3;
			redBindText.x = (guyRed.getMidpoint().x - redBindText.width/2) - 5;
			redBindText.y = (FlxG.height/2) + 72;
			FlxTween.tween(redBindText, {alpha: 0}, Conductor.quarterNoteTime/1000, {startDelay: 14*Conductor.quarterNoteTime/1000, onComplete: function(t){
				redBindText.destroy();
			}});
			FlxTween.tween(redBindText, {y: redBindText.y+5}, Conductor.quarterNoteTime/1000, {ease: FlxEase.sineInOut, type: PINGPONG});

			add(ariaShadow);
			add(aria);
			add(tutorialText);
			add(redBindText);

			guyGreen.alpha = 0;
			guyBlue.alpha = 0;
			handBlue.alpha = 0;
			handGreen.alpha = 0;
			
		}

		crowdAmbientLoop.play();
		crowdAmbientLoop.volume = 0.5;

		song.play();
	}

	override public function update(elapsed:Float):Void{
		super.update(elapsed);

		updateNotePosition();
		inputCheck();

		if(combo.combo >= 10){
			guyRed.drunk = true;
			guyBlue.drunk = true;
			guyGreen.drunk = true;
		}

		if(FlxG.keys.justPressed.ESCAPE){
			song.fadeOut(0.25);
			endSong();
		}
	}

	//Beat hit overrides ===============================================

	override public function beatHit(){
		super.beatHit();

		guyRed.bop();
		guyBlue.bop();
		guyGreen.bop();

		switch(songName){
			case "tutorial":
				switch(beat){
					case 4:
						aria.animation.play(tutorialDialogue[1][0], true);
						tutorialText.text = tutorialDialogue[1][1];
					case 8:
						aria.animation.play(tutorialDialogue[2][0], true);
						tutorialText.text = tutorialDialogue[2][1];
					case 12:
						aria.animation.play(tutorialDialogue[3][0], true);
						tutorialText.text = tutorialDialogue[3][1];
					case 15:
						aria.animation.play("polish", true);
						tutorialText.text = "";
					case 16:
						if(latestHit){
							aria.animation.play(tutorialDialogue[4][0], true);
							tutorialText.text = tutorialDialogue[4][1];
						}
						else{
							aria.animation.play(tutorialDialogue[5][0], true);
							tutorialText.text = tutorialDialogue[5][1];
						}
					case 18:
						aria.animation.play("polish", true);
						tutorialText.text = "";
					case 31:
						FlxTween.tween(guyGreen, {alpha: 1}, Conductor.quarterNoteTime/1000);
						FlxTween.tween(guyBlue, {alpha: 1}, Conductor.quarterNoteTime/1000);
						FlxTween.tween(handBlue, {alpha: 1}, Conductor.quarterNoteTime/1000);
						FlxTween.tween(handGreen, {alpha: 1}, Conductor.quarterNoteTime/1000);

						var blueBindText = new FlxText(0, 0, 0, "["+Settings.binds[1].toString().toUpperCase()+"]", 24);
						blueBindText.setFormat(null, 24, 0xFFF2EDE5, LEFT, OUTLINE, 0xFF4F2632);
						blueBindText.borderSize = 3;
						blueBindText.x = (guyBlue.getMidpoint().x - blueBindText.width/2) - 5;
						blueBindText.y = (FlxG.height/2) + 72;
						blueBindText.alpha = 0;
						FlxTween.tween(blueBindText, {alpha: 1}, Conductor.quarterNoteTime/1000, {onComplete: function(t){
							FlxTween.tween(blueBindText, {alpha: 0}, Conductor.quarterNoteTime/1000, {startDelay: 14*Conductor.quarterNoteTime/1000, onComplete: function(t){
								blueBindText.destroy();
							}});
						}});
						FlxTween.tween(blueBindText, {y: blueBindText.y+5}, Conductor.quarterNoteTime/1000, {ease: FlxEase.sineInOut, type: PINGPONG});

						var greenBindText = new FlxText(0, 0, 0, "["+Settings.binds[2].toString().toUpperCase()+"]", 24);
						greenBindText.setFormat(null, 24, 0xFFF2EDE5, LEFT, OUTLINE, 0xFF4F2632);
						greenBindText.borderSize = 3;
						greenBindText.x = guyGreen.getMidpoint().x - greenBindText.width/2;
						greenBindText.y = (FlxG.height/2) + 72;
						greenBindText.alpha = 0;
						FlxTween.tween(greenBindText, {alpha: 1}, Conductor.quarterNoteTime/1000, {onComplete: function(t){
							FlxTween.tween(greenBindText, {alpha: 0}, Conductor.quarterNoteTime/1000, {startDelay: 14*Conductor.quarterNoteTime/1000, onComplete: function(t){
								greenBindText.destroy();
							}});
						}});
						FlxTween.tween(greenBindText, {y: greenBindText.y+5}, Conductor.quarterNoteTime/1000, {ease: FlxEase.sineInOut, type: PINGPONG});

						add(blueBindText);
						add(greenBindText);

					case 32:
						aria.animation.play(tutorialDialogue[6][0], true);
						tutorialText.text = tutorialDialogue[6][1];
					case 36:
						aria.animation.play(tutorialDialogue[7][0], true);
						tutorialText.text = tutorialDialogue[7][1];
					case 40:
						aria.animation.play(tutorialDialogue[8][0], true);
						tutorialText.text = tutorialDialogue[8][1];
					case 44:
						aria.animation.play(tutorialDialogue[9][0], true);
						tutorialText.text = tutorialDialogue[9][1];
					case 48:
						aria.animation.play("polish", true);
						tutorialText.text = "";
					case 64:
						aria.animation.play(tutorialDialogue[10][0], true);
						tutorialText.text = tutorialDialogue[10][1];
						
				}
		}
	}

	override public function eighthHit(){
		super.eighthHit();
	}

	override public function stepHit(){
		super.stepHit();
	}

	//Input & Note stuff ===========================================================

	function inputCheck(){
		if(FlxG.keys.anyJustPressed([Settings.binds[0], Settings.binds[1], Settings.binds[2]])){
			var hitableNotes = new Array<Note>();
			var hitKeys = [FlxG.keys.anyJustPressed([Settings.binds[0]]), FlxG.keys.anyJustPressed([Settings.binds[1]]), FlxG.keys.anyJustPressed([Settings.binds[2]])];
			var colorsContained = [false, false, false];

			for(note in notes){
				if(note.inHitWindow && !note.hit){
					hitableNotes.push(note);
					if(note.type == "red") { colorsContained[0] = true; }
					if(note.type == "blue") { colorsContained[1] = true; }
					if(note.type == "green") { colorsContained[2] = true; }
				}
			}

			if(hitableNotes.length == 0){
				missNote(hitKeys, true);
			}
			else{
				var maybeMiss = [false, false, false];
				var alreadyHit = [false, false, false];

				if(hitKeys[0] && !colorsContained[0]){
					missNote([true, false, false], true);
				}
				if(hitKeys[1] && !colorsContained[1]){
					missNote([false, true, false], true);
				}
				if(hitKeys[2] && !colorsContained[2]){
					missNote([false, false, true], true);
				}

				for(note in hitableNotes){
					switch(note.type){
						case "red":
							if(hitKeys[0] && !alreadyHit[0]){
								hitNote([true, false, false]);

								alreadyHit[0] = true;
								maybeMiss[0] = false;

								var glow = new NoteHitGlow(note.x, note.y, "assets/images/drinkRedGlow.png");
								add(glow);

								note.hit = true;

								note.destroy();
							}
							else if(alreadyHit[0] || !hitKeys[0]){}
						case "blue":
							if(hitKeys[1] && !alreadyHit[1]){
								hitNote([false, true, false]);

								alreadyHit[1] = true;
								maybeMiss[1] = false;

								var glow = new NoteHitGlow(note.x, note.y, "assets/images/drinkBlueGlow.png");
								add(glow);

								note.hit = true;

								note.destroy();
							}
							else if(alreadyHit[1] || !hitKeys[1]){}
						case "green":
							if(hitKeys[2] && !alreadyHit[2]){
								hitNote([false, false, true]);

								alreadyHit[2] = true;
								maybeMiss[2] = false;

								note.hit = true;

								var glow = new NoteHitGlow(note.x, note.y, "assets/images/drinkGreenGlow.png");
								add(glow);
								
								note.destroy();
							}
							else if(alreadyHit[2] || !hitKeys[1]){}
					}
				}
				if(maybeMiss[0] || maybeMiss[1] || maybeMiss[2]) { missNote(maybeMiss); }
			}
		}
	}

	function missNote(hitArr:Array<Bool>, noNotes:Bool = false) {
		if(hitArr[2]){
			guyGreen.miss();
		}
		if(hitArr[1]){
			guyBlue.miss();
		}
		if(hitArr[0]){
			guyRed.miss();
		}	

		if(!noNotes){
			FlxG.sound.play("assets/sounds/glass" + FlxG.random.int(0, 3) + ".ogg");
			latestHit = false;
		}
		else{
			FlxG.sound.play("assets/sounds/emptyMiss.ogg", 0.8);
		}

		//If any miss
		guyRed.drunk = false;
		guyBlue.drunk = false;
		guyGreen.drunk = false;
		if(guyRed.animation.curAnim.name == "drunk"){ guyRed.idle(); }
		if(guyBlue.animation.curAnim.name == "drunk"){ guyBlue.idle(); }
		if(guyGreen.animation.curAnim.name == "drunk"){ guyGreen.idle(); }

		

		if(combo.combo >= 10){
			hpIcons.show();
			hpIcons.curHealth = hpIcons.maxHealth;
			hpIcons.updateHpIcons();
			crowdAmbientLoop.volume = 0.5;
			FlxG.sound.play("assets/sounds/crowdGasp.ogg");
		}
		else if(hpIcons.curHealth > 0){
			if(!noNotes && !noHudElementsMode){
				hpIcons.hpDec();
			}
		}
		else{
			lose();
		}

		combo.breakCombo();
	}

	function hitNote(hitArr:Array<Bool>) {
		if(hitArr[2]){
			guyGreen.drink();
		}
		if(hitArr[1]){
			guyBlue.drink();
		}
		if(hitArr[0]){
			guyRed.drink();
		}	

		if(!noHudElementsMode){
			combo.comboInc();
		}
		FlxG.sound.play("assets/sounds/catchSound.ogg", 0.7);

		if(combo.combo == 10){
			FlxG.sound.play("assets/sounds/cheer.ogg");
			crowdAmbientLoop.volume = 1;
		}

		if(combo.combo >= 10){
			hpIcons.hide();
		}

		latestHit = true;
	}

	//Other stuff =====================================================
	

	function generateNotes(_path:String){

		var json = Assets.getText(_path).trim();
		while (!json.endsWith("}")){json = json.substr(0, json.length - 1);}

		Conductor.bpm = cast Json.parse(json).bpm;
		noteSpeed = cast Json.parse(json).speed;

		var notesToAdd:Array<Array<Dynamic>> = cast Json.parse(json).notes;

		var greenNotes = new Array<Note>();
		var blueNotes = new Array<Note>();
		var redNotes = new Array<Note>();

		for(i in notesToAdd){
			var note = new Note(i[0], i[1]);
			if(i[1] == "green"){ greenNotes.push(note); }
			else if(i[1] == "blue"){ blueNotes.push(note); }
			else { redNotes.push(note); }
		}

		//Layering the notes correctly
		for(x in redNotes){ notes.add(x); }
		for(x in blueNotes){ notes.add(x); }
		for(x in greenNotes){ notes.add(x); }
		
	}

	function updateNotePosition(){
		for(note in notes){
			if(note.x >= 480 + note.width && note.missedAnim){
				note.destroy();
				continue;
			}
			
			note.y = noteY;
			var noteTimeDiff = (Conductor.audioReference.time - note.hitTime);
			switch(note.type){
				case "blue":
					note.x = noteHitX[1] + (noteTimeDiff * (noteSpeed) * (noteTimeDiff < 0 ? (-noteTimeDiff/1600 + 0.7) : 0.7));

				case "green":
					note.x = noteHitX[2] + (noteTimeDiff * (noteSpeed) * (noteTimeDiff < 0 ? (-noteTimeDiff/1000 + 0.6) : 0.6));

				default:
					note.x = noteHitX[0] + (noteTimeDiff * (noteSpeed) * (noteTimeDiff < 0 ? (-noteTimeDiff/1600 + 0.7) : 0.7));
			}
			
			if(inHitWindow(note.hitTime)){
				//note.color = 0xFF77AAFF;
				note.inHitWindow = true;
			}
			else{
				note.color = 0xFFFFFFFF;
				note.inHitWindow = false;
				if(note.missed && !note.missedAnim){
					note.missedAnim = true;
					missNote([note.type == "red", note.type == "blue", note.type == "green"]);
				}
			}
		}
	}
	
	function inHitWindow(time:Float){
		var diff = (Conductor.audioReference.time - time);
		return (diff >= -Conductor.hitWindow/2 && diff <= Conductor.hitWindow/2);
	}

	function endSong(){
		crowdAmbientLoop.stop();
		switchState(new SongSelect());
	}

	function lose() {
		crowdAmbientLoop.stop();
		customTransOut = new BasicTransition();
		switchState(new GameOver());
	}

}