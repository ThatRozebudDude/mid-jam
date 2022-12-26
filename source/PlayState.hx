package;

import Achievements.KeySpamCheck;
import transition.data.BasicTransition;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import openfl.utils.Assets;
import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

import flash.media.Sound;

using StringTools;

class PlayState extends GameplaySongState
{
	public static var instance:PlayState;
	public static var songName:String = "jads";

	//var song:Array<FlxSound> = [];
	var song:FlxSound;
	var songPart:Int = 0;

	var sectionLoops:Array<Int> = [];
	var sectionNotesHit:Int = 0;
	var sectionNotesTotal:Int = 0;
	var continueToNextSection:Bool = true;

	final noteY = 245;
	final noteYOffset = [-11, 0, 11];
	//var noteHitX:Array<Int> = [539, 417, 268];

	var noteSpeed:Float = 0.4;
	public static var stage:String = "bar";

	//For better readability for some parts of code
	static final RED = 0;
	static final BLUE = 1;
	static final GREEN = 2;
	
	var characters:Array<Dynamic> = ["donny", "johnny", "olive"];
	final charPos:Array<Array<Float>> = [[502, 264], [372, 264], [234, 264]];
	final handPos:Array<Array<Float>> = [[540, 243], [410, 243], [280, 243]];
	
	var guys:Array<Character> = [];
	var hands:Array<Character> = [];
	var handShadows:Array<FlxSprite> = [];

	var cameoCount:Int = 0;
	var bgCameos:FlxTypedSpriteGroup<BackgroundCharacter> = new FlxTypedSpriteGroup<BackgroundCharacter>();

	var notes:FlxTypedSpriteGroup<Note> = new FlxTypedSpriteGroup<Note>();

	var combo:Combo;
	var hpIcons:Health;
	var warning:FlxSprite;

	var crowdAmbientLoop:FlxSound = new FlxSound().loadEmbedded("assets/sounds/crowdLoop.ogg", true); 

	var noHudElementsMode:Bool = false;

	var aria:FlxSprite;
	var tutorialText:FlxText;

	var latestHit:Bool = false;

	var mashCheck:KeySpamCheck;

	override public function create()
	{
		super.create();

		instance = this;

		if(FlxG.sound.music != null) {
			FlxG.sound.music.stop();
		}

		var songPath = "assets/songs/" + songName + "/song.ogg";
		var chartPath = "assets/songs/" + songName + "/chart.json";
		
		if(Assets.exists("assets/songs/" + songName + "/song0.ogg")){
			song = new FlxSound().loadEmbedded("assets/songs/" + songName + "/song0.ogg");
			song.onComplete = nextSongPart;
			sectionLoops[0] = 0;
			chartPath = "assets/songs/" + songName + "/chart0.json";
		}
		else{
			song = new FlxSound().loadEmbedded(songPath);
			song.onComplete = endSong;
		}

		generateSongInfo(chartPath);

		add(song);

		combo = new Combo(4, 6);
		hpIcons = new Health(8, 8, 5);

		var bg = new FlxSprite().loadGraphic("assets/images/stages/" + stage + "/bg.png");
		var bar = new FlxSprite().loadGraphic("assets/images/stages/" + stage + "/counter.png");
		cameoCount = Std.parseInt(Assets.getText("assets/images/stages/" + stage + "/cameos/count.txt"));
		//var strumGuide = new FlxSprite().loadGraphic("assets/images/temp/strumGuide.png");
		//strumGuide.alpha = 0.3;

		guys[RED] = new Character(charPos[0][0], charPos[0][1], "assets/images/characters/" + characters[RED] + "/body.png");
		guys[RED].x -= guys[RED].width/2;
		guys[RED].y -= guys[RED].height;
		guys[RED].truePos = new FlxPoint(guys[RED].x, guys[RED].y);

		guys[BLUE] = new Character(charPos[1][0], charPos[1][1], "assets/images/characters/" + characters[BLUE] + "/body.png");
		guys[BLUE].x -= guys[BLUE].width/2;
		guys[BLUE].y -= guys[BLUE].height;
		guys[BLUE].truePos = new FlxPoint(guys[BLUE].x, guys[BLUE].y);

		guys[GREEN] = new Character(charPos[2][0], charPos[2][1], "assets/images/characters/" + characters[GREEN] + "/body.png");
		guys[GREEN].x -= guys[GREEN].width/2;
		guys[GREEN].y -= guys[GREEN].height;
		guys[GREEN].truePos = new FlxPoint(guys[GREEN].x, guys[GREEN].y);

		hands[RED] = new Character(handPos[0][0], handPos[0][1], "assets/images/characters/" + characters[RED] + "/hand.png");
		hands[RED].x -= hands[RED].width/2;
		hands[RED].y -= hands[RED].height/2;
		
		hands[BLUE] = new Character(handPos[1][0], handPos[1][1], "assets/images/characters/" + characters[BLUE] + "/hand.png");
		hands[BLUE].x -= hands[BLUE].width/2;
		hands[BLUE].y -= hands[BLUE].height/2;

		hands[GREEN] = new Character(handPos[2][0], handPos[2][1], "assets/images/characters/" + characters[GREEN] + "/hand.png");
		hands[GREEN].x -= hands[GREEN].width/2;
		hands[GREEN].y -= hands[GREEN].height/2;

		guys[RED].child = hands[RED];
		guys[BLUE].child = hands[BLUE];
		guys[GREEN].child = hands[GREEN];

		var shadowColor = 0xFF4F2632;
		switch(stage){
			case "deadEstate":
				shadowColor = 0xFF0D0B2D;
		}

		for(i in 0...3){
			handShadows.push(new FlxSprite().loadGraphic("assets/images/handShadow.png"));
			handShadows[i].x = hands[i].x + hands[i].width/2 - handShadows[i].width/2;
			handShadows[i].y = 264;
			handShadows[i].alpha = 0.5;
			handShadows[i].color = shadowColor;
		}

		BackgroundCharacter.totalBGCharacters = [];

		warning = new FlxSprite(560, 4).loadGraphic("assets/images/warning.png");
		warning.visible = false;
		FlxTween.tween(warning, {y: warning.y+4}, 1, {ease: FlxEase.sineInOut, type: PINGPONG});

		add(bg);

		add(bgCameos);

		add(guys[GREEN]);
		add(guys[BLUE]);
		add(guys[RED]);

		add(bar);

		for(x in handShadows){
			add(x);
		}

		for(x in hands){
			add(x);
			x.truePos = new FlxPoint(x.x, x.y);
		}

		//add(hands);
		add(notes);
		add(hpIcons);
		add(combo);
		add(warning);
		//add(strumGuide);

		Conductor.audioReference = song;

		if(songName == "tutorial"){
			noHudElementsMode = true;
			combo.silent = true;
			remove(hpIcons);
			remove(combo);

			var ariaShadow = new FlxSprite(6, 110).loadGraphic("assets/images/ariaIndicator.png");

			aria = new FlxSprite(14, 9).loadGraphic("assets/images/aria.png", true, 136, 157);
			aria.animation.add("talk", [0, 1, 2], 12, true);
			aria.animation.add("talk-end", [2], 0, false);
			aria.animation.add("laugh", [3, 4, 5], 12, true);
			aria.animation.add("laugh-end", [5], 0, false);
			aria.animation.add("polish", [6, 7], 2, true);
			aria.animation.play("polish", true);

			tutorialText = new FlxText(142, 32, 0, "", 16);
			tutorialText.setFormat(null, 16, 0xFFFBD0B5, LEFT, OUTLINE, 0xFF4F2632);
			tutorialText.borderSize = 3;

			var redBindText = new FlxText(0, 0, 0, "["+SaveData.binds[0].toString().toUpperCase()+"]", 24);
			redBindText.setFormat(null, 24, 0xFFF2EDE5, LEFT, OUTLINE, 0xFF4F2632);
			redBindText.borderSize = 3;
			redBindText.x = (guys[RED].getMidpoint().x - redBindText.width/2) - 5;
			redBindText.y = (FlxG.height/2) + 62;
			FlxTween.tween(redBindText, {alpha: 0}, Conductor.quarterNoteTime/1000, {startDelay: 14*Conductor.quarterNoteTime/1000, onComplete: function(t){
				redBindText.destroy();
			}});
			FlxTween.tween(redBindText, {y: redBindText.y+5}, Conductor.quarterNoteTime/1000, {ease: FlxEase.sineInOut, type: PINGPONG});

			add(ariaShadow);
			add(aria);
			add(tutorialText);
			add(redBindText);

			guys[GREEN].alpha = 0;
			guys[BLUE].alpha = 0;
			hands[GREEN].alpha = 0;
			hands[BLUE].alpha = 0;
			handShadows[BLUE].alpha = 0;
			handShadows[BLUE].visible = false;
			handShadows[GREEN].alpha = 0;
			handShadows[GREEN].visible = false;
			
		}

		crowdAmbientLoop.play();
		crowdAmbientLoop.volume = 0.5;

		createBackgroundCameo();

		if(!Achievements.achievementMap.get("buttonMash")[2]){
			mashCheck = new KeySpamCheck();
			add(mashCheck);
		}

		song.play();
	}

	override public function update(elapsed:Float):Void{
		super.update(elapsed);

		updateNotePosition();
		inputCheck();

		if(combo.combo >= 10){
			guys[RED].drunk = true;
			guys[BLUE].drunk = true;
			guys[GREEN].drunk = true;
		}

		if(FlxG.keys.justPressed.ESCAPE){
			song.fadeOut(0.25);
			quit();
		}

		switch(songName){
			case "tutorial":
				switch(songPart){
					case 0:
						continueToNextSection = sectionNotesHit >= 4;
					case 1:
						continueToNextSection = sectionNotesHit >= 9;
				}
		}
	}

	//Beat hit overrides ===============================================

	override public function beatHit(){
		super.beatHit();

		for(x in guys){
			x.bop();
		}
		
		bgCameos.forEachAlive(function(x){
			x.bop();
		});

		switch(songName){
			case "tutorial":
				switch(beat){
					case 0:
						switch(songPart){
							case 0:
								if(sectionLoops[songPart] < 1){ sayDialogue("talk", "Hey, you must be new 'round these parts."); }
								else{ sayDialogue("talk", "Yeah... Let's try that again..."); }

								if(sectionLoops[songPart] == 4){ Achievements.unlock("tutorialFail"); }

							case 1:
								if(sectionLoops[songPart] < 1){ 
									sayDialogue("talk", "Oh, are these guys friends of yours?"); 
									FlxTween.tween(guys[GREEN], {alpha: 1}, Conductor.quarterNoteTime/1000);
									FlxTween.tween(guys[BLUE], {alpha: 1}, Conductor.quarterNoteTime/1000);
									FlxTween.tween(hands[GREEN], {alpha: 1}, Conductor.quarterNoteTime/1000);
									FlxTween.tween(hands[BLUE], {alpha: 1}, Conductor.quarterNoteTime/1000);
									handShadows[BLUE].alpha = 0;
									handShadows[BLUE].visible = true;
									handShadows[GREEN].alpha = 0;
									handShadows[GREEN].visible = true;
									FlxTween.tween(handShadows[GREEN], {alpha: 0.5}, Conductor.quarterNoteTime/1000);
									FlxTween.tween(handShadows[BLUE], {alpha: 0.5}, Conductor.quarterNoteTime/1000);

									var blueBindText = new FlxText(0, 0, 0, "["+SaveData.binds[1].toString().toUpperCase()+"]", 24);
									blueBindText.setFormat(null, 24, 0xFFF2EDE5, LEFT, OUTLINE, 0xFF4F2632);
									blueBindText.borderSize = 3;
									blueBindText.x = (guys[BLUE].getMidpoint().x - blueBindText.width/2) - 5;
									blueBindText.y = (FlxG.height/2) + 62;
									blueBindText.alpha = 0;
									FlxTween.tween(blueBindText, {alpha: 1}, Conductor.quarterNoteTime/1000, {onComplete: function(t){
										FlxTween.tween(blueBindText, {alpha: 0}, Conductor.quarterNoteTime/1000, {startDelay: 13*Conductor.quarterNoteTime/1000, onComplete: function(t){
											blueBindText.destroy();
										}});
									}});
									FlxTween.tween(blueBindText, {y: blueBindText.y+5}, Conductor.quarterNoteTime/1000, {ease: FlxEase.sineInOut, type: PINGPONG});

									var greenBindText = new FlxText(0, 0, 0, "["+SaveData.binds[2].toString().toUpperCase()+"]", 24);
									greenBindText.setFormat(null, 24, 0xFFF2EDE5, LEFT, OUTLINE, 0xFF4F2632);
									greenBindText.borderSize = 3;
									greenBindText.x = guys[GREEN].getMidpoint().x - greenBindText.width/2;
									greenBindText.y = (FlxG.height/2) + 62;
									greenBindText.alpha = 0;
									FlxTween.tween(greenBindText, {alpha: 1}, Conductor.quarterNoteTime/1000, {onComplete: function(t){
										FlxTween.tween(greenBindText, {alpha: 0}, Conductor.quarterNoteTime/1000, {startDelay: 13*Conductor.quarterNoteTime/1000, onComplete: function(t){
											greenBindText.destroy();
										}});
									}});
									FlxTween.tween(greenBindText, {y: greenBindText.y+5}, Conductor.quarterNoteTime/1000, {ease: FlxEase.sineInOut, type: PINGPONG});

									add(blueBindText);
									add(greenBindText);
								}
								else{ sayDialogue("talk", "You aren't ready... Let's try again."); }
							case 2:
								sayDialogue("laugh", "Alright, seems like you got the hang of \nthis! I hope you're ready to get \nfuckin' trashed!");
						}
					case 4:
						switch(songPart){
							case 0:
								if(sectionLoops[songPart] < 1){ sayDialogue("talk", "You'll need to catch the drinks I slide \nover to you."); }
								else{
									aria.animation.play("polish", true);
									tutorialText.text = "";
								}
							case 1:
								if(sectionLoops[songPart] < 1){ sayDialogue("laugh", "I suppose it doesn't really matter..."); }
								else{
									aria.animation.play("polish", true);
									tutorialText.text = "";
								}
						}
					case 8:
						switch(songPart){
							case 0:
								if(sectionLoops[songPart] < 1){ sayDialogue("talk", "That's just how it works at this bar. You'll \nget used to it."); }
							case 1:
								if(sectionLoops[songPart] < 1){ sayDialogue("talk", "They look thirsty too... Guess I'll need \nto slide over even more drinks!"); }
						}
					case 12:
						switch(songPart){
							case 0:
								if(sectionLoops[songPart] < 1){ sayDialogue("laugh", "Here, give it a try!"); }
								else{ sayDialogue("laugh", "Let's try to actually catch them this time!"); }
							case 1:
								if(sectionLoops[songPart] < 1){ sayDialogue("laugh", "Make sure you grab the right drink!"); }
								else{ sayDialogue("laugh", "Good luck, buddy!"); }
						}
					case 15:
						switch(songPart){
							case 0:
								aria.animation.play("polish", true);
								tutorialText.text = "";
						}
					case 16:
						switch(songPart){
							case 0:
								if(latestHit){
									sayDialogue("laugh", "Nice one!");
								}
								else{
									if(sectionLoops[songPart] < 1){ sayDialogue("talk", "I'll just put that on your tab..."); }
									else{ sayDialogue("talk", "Really?"); }
								}	
							case 1:
								aria.animation.play("polish", true);
								tutorialText.text = "";
						}
					case 18:
						switch(songPart){
							case 0:
								aria.animation.play("polish", true);
								tutorialText.text = "";
						}					
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
		if(FlxG.keys.anyJustPressed([SaveData.binds[0], SaveData.binds[1], SaveData.binds[2]])){
			var hitableNotes = new Array<Note>();
			var hitKeys = [FlxG.keys.anyJustPressed([SaveData.binds[0]]), FlxG.keys.anyJustPressed([SaveData.binds[1]]), FlxG.keys.anyJustPressed([SaveData.binds[2]])];
			var colorsContained = [false, false, false];

			for(note in notes){
				if(note.inHitWindow && !note.hit){
					hitableNotes.push(note);
					if(note.lane == 0) { colorsContained[0] = true; }
					if(note.lane == 1) { colorsContained[1] = true; }
					if(note.lane == 2) { colorsContained[2] = true; }
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
					switch(note.lane){
						case 0:
							if(hitKeys[0] && !alreadyHit[0]){
								hitNote(0);

								alreadyHit[0] = true;
								maybeMiss[0] = false;

								var glow = new NoteHitGlow(note.x, note.y, note.type);
								add(glow);

								note.hit = true;

								note.destroy();
							}
							else if(alreadyHit[0] || !hitKeys[0]){}
						case 1:
							if(hitKeys[1] && !alreadyHit[1]){
								hitNote(1);

								alreadyHit[1] = true;
								maybeMiss[1] = false;

								var glow = new NoteHitGlow(note.x, note.y, note.type);
								add(glow);

								note.hit = true;

								note.destroy();
							}
							else if(alreadyHit[1] || !hitKeys[1]){}
						case 2:
							if(hitKeys[2] && !alreadyHit[2]){
								hitNote(2);

								alreadyHit[2] = true;
								maybeMiss[2] = false;

								note.hit = true;

								var glow = new NoteHitGlow(note.x, note.y, note.type);
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
			guys[GREEN].miss();
			FlxTween.cancelTweensOf(handShadows[GREEN]);
			FlxTween.cancelTweensOf(handShadows[GREEN].scale);
			handShadows[GREEN].alpha = 0.5;
			handShadows[GREEN].scale.set(1, 1);
		}
		if(hitArr[1]){
			guys[BLUE].miss();
			FlxTween.cancelTweensOf(handShadows[BLUE]);
			FlxTween.cancelTweensOf(handShadows[BLUE].scale);
			handShadows[BLUE].alpha = 0.5;
			handShadows[BLUE].scale.set(1, 1);
		}
		if(hitArr[0]){
			guys[RED].miss();
			FlxTween.cancelTweensOf(handShadows[RED]);
			FlxTween.cancelTweensOf(handShadows[RED].scale);
			handShadows[RED].alpha = 0.5;
			handShadows[RED].scale.set(1, 1);
		}	

		if(!noNotes){
			combo.totalMissed++;
			FlxG.sound.play("assets/sounds/glass" + FlxG.random.int(0, 3) + ".ogg");
			latestHit = false;
		}
		else{
			FlxG.sound.play("assets/sounds/emptyMiss.ogg", 0.8);
		}

		//If any miss
		for(x in guys){
			x.drunk = false;
			if(x.animation.curAnim.name == "drunk"){ x.idle(); }
		}

		if(combo.combo >= 10){
			hpIcons.show();
			hpIcons.curHealth = hpIcons.maxHealth;
			hpIcons.updateHpIcons();
			crowdAmbientLoop.volume = 0.5;
		}
		else if(hpIcons.curHealth > 0){
			if(!noNotes && !noHudElementsMode){
				hpIcons.hpDec();
			}
		}
		else{
			lose();
		}

		if(!warning.visible){
			if(SongSelect.maxCombo.get(songName) - (combo.totalHit + combo.totalMissed) < SaveData.scores.get(songName).score){
				warning.visible = true;
			}
		}

		combo.breakCombo();
	}

	function hitNote(hitLane:Int) {
		guys[hitLane].drink();
		sectionNotesHit++;

		FlxTween.cancelTweensOf(handShadows[hitLane]);
		FlxTween.cancelTweensOf(handShadows[hitLane].scale);
		handShadows[hitLane].alpha = 0.25;
		handShadows[hitLane].scale.set(1.3, 1.15);
		FlxTween.tween(handShadows[hitLane], {alpha: 0.5}, Conductor.eighthNoteTime/1000);
		FlxTween.tween(handShadows[hitLane].scale, {x: 1, y: 1}, Conductor.eighthNoteTime/1000);

		combo.comboInc();
		FlxG.sound.play("assets/sounds/catchSound.ogg", 0.7);

		if(combo.combo == 10){
			crowdAmbientLoop.volume = 1;
		}

		if(combo.combo >= 10){
			hpIcons.hide();
		}

		latestHit = true;
		if(mashCheck != null){
			mashCheck.keyMash -= KeySpamCheck.addAmmount;
		}
	}

	//Other stuff =====================================================
	

	function generateSongInfo(_path:String){

		var json = Assets.getText(_path).trim();
		while (!json.endsWith("}")){json = json.substr(0, json.length - 1);}

		Conductor.bpm = cast Json.parse(json).bpm;
		noteSpeed = cast Json.parse(json).speed;
		characters = cast Json.parse(json).characters;
		stage = cast Json.parse(json).stage;
		
		generateNotes(_path);

	}

	function generateNotes(_path:String){

		var json = Assets.getText(_path).trim();
		while (!json.endsWith("}")){json = json.substr(0, json.length - 1);}

		var notesToAdd:Array<Array<Dynamic>> = cast Json.parse(json).notes;

		sectionNotesTotal = notesToAdd.length;

		var greenNotes = new Array<Note>();
		var blueNotes = new Array<Note>();
		var redNotes = new Array<Note>();

		for(i in notesToAdd){
			var note = new Note(i[0], i[1], i[2]);
			if(i[1] == 2){ greenNotes.push(note); }
			else if(i[1] == 1){ blueNotes.push(note); }
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
		
			var noteTimeDiff = (Conductor.audioReference.time - note.hitTime);
			
			note.x = (hands[note.lane].x + hands[note.lane].width/2) + (noteTimeDiff * (noteSpeed) * (noteTimeDiff < 0 ? (-noteTimeDiff/1900 + 0.725) : 0.725));
			note.y = noteY + noteYOffset[note.lane];
			
			if(inHitWindow(note.hitTime)){
				//note.color = 0xFF77AAFF;
				note.inHitWindow = true;
			}
			else{
				note.color = 0xFFFFFFFF;
				note.inHitWindow = false;
				if(note.missed && !note.missedAnim){
					note.missedAnim = true;
					missNote([note.lane == 0, note.lane == 1, note.lane == 2]);
				}
			}
		}
	}
	
	function inHitWindow(time:Float){
		var diff = (Conductor.audioReference.time - time);
		return (diff >= -Conductor.hitWindow/2 && diff <= Conductor.hitWindow/2);
	}

	function quit(){
		crowdAmbientLoop.stop();
		switchState(new SongSelect());
	}
	
	function sayDialogue(_anim:String, _text:String){
		tutorialText.text = "";
		for(i in 0..._text.length){
			new FlxTimer().start(1/60 * i, function(t){
				aria.animation.play(_anim);
				tutorialText.text += _text.charAt(i);
				if(i == _text.length-1){
					switch (aria.animation.curAnim.name){
						case "talk" | "laugh":
							aria.animation.play(_anim + "-end");
					}
				}
			});
		}
	}

	function nextSongPart(){
		sectionLoops[songPart]++;
		sectionNotesHit = 0;

		if(continueToNextSection){ 
			songPart++; 
			if(!Assets.exists("assets/songs/" + songName + "/song" + songPart + ".ogg")){
				endSong();
				return;
			}
			else{ sectionLoops[songPart] = 0; }
		}

		remove(song);
		song = new FlxSound().loadEmbedded("assets/songs/" + songName + "/song" + songPart + ".ogg");
		song.onComplete = nextSongPart;
		add(song);

		Conductor.audioReference = song;

		resetSong();
		generateNotes("assets/songs/" + songName + "/chart" + songPart + ".json");
		song.play();
	}

	function endSong(){
		if(combo.maxCombo > SaveData.scores.get(songName).score){
			SaveData.scores.get(songName).score = combo.maxCombo;
			SaveData.write();
		}
		quit();
	}

	function lose() {
		crowdAmbientLoop.stop();
		customTransOut = new BasicTransition();
		switchState(new GameOver());
	}

	function createBackgroundCameo(){
		if(cameoCount > 0){
			new FlxTimer().start(FlxG.random.float(4.5, 16 * (combo.combo >= 10 ? 0.65 : 1)), function(t){
				if(BackgroundCharacter.totalBGCharacters.length < cameoCount){
					var exclude:Array<Int> = [];
					for(x in BackgroundCharacter.totalBGCharacters){ exclude.push(x.cameoID); }
					var cameoValue = FlxG.random.int(0, cameoCount-1, exclude);
					var cameoCharacter = new BackgroundCharacter("assets/images/stages/" + stage + "/cameos/" + cameoValue + ".png", FlxG.random.bool(50), cameoValue);
					bgCameos.add(cameoCharacter);
				}
				createBackgroundCameo();
			});
		}
	}

}