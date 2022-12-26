package;

import flixel.FlxG;
import flixel.FlxSprite;

class Credits extends UIStateExt
{
	
	var guys:FlxSprite;
	var curGuy:Int = 0;
	static final links:Array<String> = [
								"https://dojimadog.newgrounds.com/",
								"https://thatrozebudguy.newgrounds.com/",
								"https://elikapika.newgrounds.com/",
								"https://j4ds.newgrounds.com/",
								"https://cval.newgrounds.com/",
								"https://crocid.newgrounds.com/",
								];

	override public function create()
	{
		super.create();

		var bg = new FlxSprite().loadGraphic("assets/images/stages/bar/bg.png");
		var backButton = new FlxSprite().loadGraphic("assets/images/pressEscape.png");

		guys = new FlxSprite().loadGraphic("assets/images/creditsGuys.png", true, 576, 324);
		guys.animation.add("the", [0, 1, 2, 3, 4, 5], 0, false);
		guys.animation.play("the");

		add(bg);
		add(guys);
		add(backButton);

		Achievements.unlock("thanks");

	}

	override function update(elapsed){
		super.update(elapsed);

		if(FlxG.keys.justPressed.ESCAPE){
			FlxG.sound.play("assets/sounds/catchSound.ogg");
			switchState(new MainMenu());
		}

		if(FlxG.keys.justPressed.ENTER){
			FlxG.openURL(links[curGuy]);
		}
		else if(FlxG.keys.anyJustPressed([W, UP, D, RIGHT, SPACE])){
			moveSelection(1);
		}
		else if(FlxG.keys.anyJustPressed([S, DOWN, A, LEFT])){
			moveSelection(-1);
		}
	}

	function moveSelection(change:Int = 0){
		curGuy += change;
		if(curGuy < 0) { curGuy = 5; }
		if(curGuy > 5) { curGuy = 0; }
		guys.animation.frameIndex = curGuy;
		FlxG.sound.play("assets/sounds/catchSound.ogg");
	}

}