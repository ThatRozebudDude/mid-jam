package;

import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;

class GameOver extends UIStateExt
{

	var retry:FlxSprite;
	var canRetry:Bool = false;

	override public function create()
	{
		super.create();

		var bg = new FlxSprite().makeGraphic(600, 600, 0xFF4F2632);
		retry = new FlxSprite().loadGraphic("assets/images/tryAgain.png");
		retry.screenCenter(XY);
		retry.alpha = 0;

		FlxG.sound.play("assets/sounds/bigGlassShatter.ogg", 1, false, null, true, function(){
			canRetry = true;
			FlxTween.tween(retry, {alpha: 1}, 0.5);
		});
		FlxG.sound.play("assets/sounds/crowdGasp.ogg");
		FlxG.sound.playMusic("assets/sounds/crowdLoop.ogg", 0.7);

		add(bg);
		add(retry);

	}

	override function update(elapsed){
		super.update(elapsed);

		if(FlxG.keys.justPressed.ESCAPE){
			FlxG.sound.play("assets/sounds/catchSound.ogg");
			switchState(new SongSelect());
			FlxG.sound.music.stop();
			canRetry = false;
		}

		if(canRetry){
			if(FlxG.keys.anyJustPressed([SPACE, ENTER, SaveData.binds[0], SaveData.binds[1], SaveData.binds[2]])){
				FlxG.sound.play("assets/sounds/catchSound.ogg");
				switchState(new PlayState());
				canRetry = false;
			}
		}
		
	}

}
