package;

import flixel.util.FlxGradient;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;

class AchievementMenu extends UIStateExt
{
	var achievementList:Array<AchievementBanner> = [];

	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var started:Bool = false;

	var selected:Int = 0;

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

		add(bg);
		add(overlay);

		for(i in 0...Achievements.achievementNames.length){
			var name = Achievements.achievementNames[i];
			var banner = new AchievementBanner(name, i, Achievements.achievementMap.get(name)[2], Achievements.achievementMap.get(name)[3]);
			add(banner);
			achievementList.push(banner);
		}

		leftArrow = new FlxSprite(36).loadGraphic("assets/images/arrowButton.png");
		leftArrow.flipX = true;
		leftArrow.screenCenter(Y);

		rightArrow = new FlxSprite().loadGraphic("assets/images/arrowButton.png");
		rightArrow.x = FlxG.width - rightArrow.width - 36;
		rightArrow.screenCenter(Y);

		rotateAchievements();

		add(backButton);
	}

	override function update(elapsed){
		super.update(elapsed);

		if(!started){
			if(FlxG.keys.justPressed.ESCAPE){
				FlxG.sound.play("assets/sounds/catchSound.ogg");
				switchState(new MainMenu());
			}
			else if(FlxG.keys.anyJustPressed([W, UP])){
				rotateAchievements(-1);
				FlxG.sound.play("assets/sounds/catchSound.ogg");
			}
			else if(FlxG.keys.anyJustPressed([S, DOWN])){
				rotateAchievements(1);
				FlxG.sound.play("assets/sounds/catchSound.ogg");
			}

			if(FlxG.keys.anyPressed([W, UP])){
				leftArrow.scale.set(0.8, 0.8);
			}
			else{
				leftArrow.scale.set(1, 1);
			}

			if(FlxG.keys.anyPressed([S, DOWN])){
				rightArrow.scale.set(0.8, 0.8);
			}
			else{
				rightArrow.scale.set(1, 1);
			}
		}
		
	}

	function keepInRange(value:Int){
		if(value > achievementList.length-1) { return 0; }
		else if(value < 0) { return achievementList.length-1; }
		return value;
	}

	function rotateAchievements(change:Int = 0){
		selected = keepInRange(selected+change);

		for(x in achievementList){
			x.visible = false;
		}

		remove(achievementList[keepInRange(selected+1)]);
		achievementList[keepInRange(selected+1)].screenCenter(X);
		achievementList[keepInRange(selected+1)].x += 24;
		achievementList[keepInRange(selected+1)].y = (FlxG.height/4)*3 - (achievementList[keepInRange(selected-1)].height/2);
		achievementList[keepInRange(selected+1)].visible = true;
		achievementList[keepInRange(selected+1)].alpha = 0.5;
		//achievementList[keepInRange(selected+1)].scale.set(0.6, 0.6);
		add(achievementList[keepInRange(selected+1)]);

		remove(achievementList[keepInRange(selected-1)]);
		achievementList[keepInRange(selected-1)].screenCenter(X);
		achievementList[keepInRange(selected-1)].x += 24;
		achievementList[keepInRange(selected-1)].y = (FlxG.height/4) - (achievementList[keepInRange(selected+1)].height/2);
		achievementList[keepInRange(selected-1)].visible = true;
		achievementList[keepInRange(selected-1)].alpha = 0.5;
		//achievementList[keepInRange(selected-1)].scale.set(0.6, 0.6);
		add(achievementList[keepInRange(selected-1)]);

		remove(achievementList[selected]);
		achievementList[selected].screenCenter(XY);
		achievementList[selected].x += 24;
		achievementList[selected].visible = true;
		achievementList[selected].alpha = 1;
		//achievementList[selected].scale.set(1, 1);
		add(achievementList[selected]);
	}

}

class AchievementBanner extends FlxSpriteGroup
{   

	public var name:String;
	public var index:Int;
	public var unlocked:Bool;
	public var secret:Bool;

	static final hiddenDesc:Array<String> = ["It's a secret.", "Figure it out.", "You don't get to know.", "You'll know one day.", "Who knows...", "It's a mystery."];

    override public function new(_name:String, _index:Int, _unlocked:Bool, _secret:Bool = false){

        super(0, 0);

		name = _name;
		index = _index;
		unlocked = _unlocked;
		secret = _secret;

		trace(name + " " + index + " " + unlocked + " " + secret);

        var icon = new FlxSprite(4, 4).loadGraphic("assets/images/achievements/" + name + ".png");
        var lock = new FlxSprite(4, 4).loadGraphic("assets/images/achievements/lock.png");
		lock.visible = !unlocked;

        var text = new FlxText(72, 0, 0, Achievements.achievementMap.get(name)[0], 24);
        text.color = 0xFFF5BB73;
        text.y = 24 - text.height/2;

        var desc = new FlxText(72, 0, 0, Achievements.achievementMap.get(name)[1], 16);
        desc.color = 0xFFF5BB73;
        desc.y = 52 - desc.height/2;

		if(!unlocked && secret){
			text.text = "???";
			desc.text = hiddenDesc[FlxG.random.int(0, hiddenDesc.length-1)];
			icon.loadGraphic("assets/images/achievements/_hidden.png");
		}

        var bgWidth = Std.int(text.width);
        if(desc.width > text.width) { bgWidth = Std.int(desc.width); }

        var bg = new FlxSprite().makeGraphic(76 + bgWidth, 72, 0xFF4F2632);
        var bgFadeR = FlxGradient.createGradientFlxSprite(24, 72, [0xFF4F2632, 0x004F2632], 1, 0);
        bgFadeR.x = bg.width;
		var bgFadeL = FlxGradient.createGradientFlxSprite(24, 72, [0xFF4F2632, 0x004F2632], 1, 180);
        bgFadeL.x = -24;

        add(bg);
        add(bgFadeR);
        add(bgFadeL);
        add(text);
        add(desc);
		add(icon);
		if(!unlocked) { add(lock); }

		//screenCenter(XY);
    }
}