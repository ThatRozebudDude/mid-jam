package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import transition.data.BasicTransition;
import flixel.FlxG;
import flixel.FlxSprite;

class StartCutscene extends UIStateExt
{

	var curFrame:Int = 0;
	var frames = ["p0-0", "p0-1", "p0-2", "p1-0", "p2-0", "p2-1"];
	var frameSprite:FlxSprite;

	var pressAnyKey:FlxSprite;

	override public function create()
	{
		customTransOut = new BasicTransition();

		super.create();
		
		FlxG.mouse.visible = false;

		frameSprite = new FlxSprite().loadGraphic("assets/images/cutscene/" + frames[0] + ".png");
		add(frameSprite);

		pressAnyKey = new FlxSprite().loadGraphic("assets/images/cutscene/pressAnyKey.png");
		add(pressAnyKey);

		FlxTween.tween(pressAnyKey, {alpha: 0}, 1, {type: PINGPONG});

		FlxG.sound.playMusic("assets/music/cutscene.ogg", 0.9);

	}

	override function update(elapsed){
		super.update(elapsed);

		if(FlxG.keys.anyJustPressed(FlxG.sound.volumeDownKeys.concat(FlxG.sound.volumeUpKeys).concat(FlxG.sound.muteKeys))){}
		else if(FlxG.keys.justPressed.ANY){
			advance();
		}
	}

	function advance(){
		if(curFrame >= frames.length){
			return;
		}
		FlxG.sound.play("assets/sounds/catchSound.ogg");
		curFrame++;
		if(curFrame == frames.length){
			FlxG.camera.fade(0xFF4F2632, 1, false, function(){
				new FlxTimer().start(0.5, function(t){
					switchState(new MainMenu());
				});
			});
			FlxG.sound.music.fadeOut(1, 0, function(t){
				FlxG.sound.music.stop();
			});
			
		}
		else if(curFrame < frames.length){
			frameSprite.loadGraphic("assets/images/cutscene/" + frames[curFrame] + ".png");
		}
	}

}