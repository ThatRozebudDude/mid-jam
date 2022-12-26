package;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;

class SongSelect extends UIStateExt
{

	public static final songList:Array<String> = ["tutorial", "earlyMorninBooze", "drunkenDoSiDo", "moonshineMedley", "christmas", "hereWeGoAgain"];
	final songNames:Array<String> = ["Tutorial", "Early Mornin' Booze", "Drunken Do-Si-Do", "Moonshine Melody", "Holly Jolly Jivin'", "Here We Go Again"];
	static var selected = 0;
	public static var maxCombo:Map<String, Int> = new Map();
	public static var songHash:Array<String> = [];

	var currAlbum:FlxSprite;
	var prevAlbum:FlxSprite;
	var nextAlbum:FlxSprite;

	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var songNameText:FlxText;
	var songComboText:FlxText;

	var started:Bool = false;

	override public function create()
	{
		super.create();

		if(FlxG.sound.music != null) {
			if(!FlxG.sound.music.playing){
				FlxG.sound.playMusic("assets/music/menuMusic.ogg", 0.9);
			}
		}

		var bg = new FlxSprite().loadGraphic("assets/images/stages/bar/bg.png");
		var overlay = new FlxSprite().makeGraphic(600, 600, 0x774F2632);
		var backButton = new FlxSprite().loadGraphic("assets/images/pressEscape.png");

		currAlbum = new FlxSprite().loadGraphic("assets/songs/" + songList[keepInRange(selected)] + "/album.png");
		currAlbum.screenCenter(XY);
		
		prevAlbum = new FlxSprite().loadGraphic("assets/songs/" + songList[keepInRange(selected-1)] + "/album.png");
		prevAlbum.x = currAlbum.x - 110;
		prevAlbum.scale.set(0.8, 0.8);
		prevAlbum.screenCenter(Y);
		prevAlbum.alpha = 0.6;	

		nextAlbum = new FlxSprite().loadGraphic("assets/songs/" + songList[keepInRange(selected+1)] + "/album.png");
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

		songComboText = new FlxText(0, 0, 0, ""+maxCombo.get(songList[keepInRange(selected)]), 24);
		songComboText.setFormat(null, 24, 0xFFFBD0B5, LEFT, OUTLINE, 0xFF4F2632);
		songComboText.borderSize = 3;
		songComboText.screenCenter(X);
		songComboText.y = (FlxG.height * 0.125) - songNameText.height/2;

		rotateAlbums();

		add(bg);
		add(overlay);

		add(prevAlbum);
		add(nextAlbum);
		add(currAlbum);

		add(leftArrow);
		add(rightArrow);
		add(songNameText);
		add(songComboText);

		add(backButton);

		//achievement check
		if(SaveData.scores.get("tutorial").score > 0){
			Achievements.unlock("beatTutorial");
		}
		if(SaveData.scores.get("earlyMorninBooze").score == maxCombo.get("earlyMorninBooze")){
			Achievements.unlock("fcEMB");
		}
		if(SaveData.scores.get("drunkenDoSiDo").score == maxCombo.get("drunkenDoSiDo")){
			Achievements.unlock("fcDDSD");
		}
		if(SaveData.scores.get("hereWeGoAgain").score == maxCombo.get("hereWeGoAgain")){
			Achievements.unlock("fcHWGA");
		}
		if(SaveData.scores.get("moonshineMedley").score == maxCombo.get("moonshineMedley")){
			Achievements.unlock("liverFailure");
		}
		if(SaveData.scores.get("christmas").score == maxCombo.get("christmas")){
			Achievements.unlock("fcChristmas");
		}

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

			if(FlxG.keys.anyPressed([A, LEFT])){
				leftArrow.scale.set(0.8, 0.8);
			}
			else{
				leftArrow.scale.set(1, 1);
			}
			if(FlxG.keys.anyPressed([D, RIGHT])){
				rightArrow.scale.set(0.8, 0.8);
			}
			else{
				rightArrow.scale.set(1, 1);
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

		currAlbum.loadGraphic("assets/songs/" + songList[selected] + "/album.png");
		prevAlbum.loadGraphic("assets/songs/" + songList[keepInRange(selected-1)] + "/album.png");
		nextAlbum.loadGraphic("assets/songs/" + songList[keepInRange(selected+1)] + "/album.png");

		songNameText.text = songNames[selected];
		songNameText.screenCenter(X);
		
		if(SaveData.scores.get(songList[selected]).score == maxCombo.get(songList[selected])){
			songComboText.text = "Full Combo'd!";
			songComboText.setFormat(null, 24, 0xFFF5BB73, LEFT, OUTLINE, 0xFF4F2632);
		}
		else{
			songComboText.text = "Highest Combo: " + SaveData.scores.get(songList[selected]).score + "/" + maxCombo.get(songList[selected]);
			songComboText.setFormat(null, 24, 0xFFFBD0B5, LEFT, OUTLINE, 0xFF4F2632);
		}
		songComboText.borderSize = 3;
		songComboText.screenCenter(X);
	}

}
