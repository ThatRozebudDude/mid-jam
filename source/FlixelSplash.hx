package;

import flixel.system.FlxAssets;
import flixel.util.FlxTimer;
import transition.data.BasicTransition;
import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

class FlixelSplash extends UIStateExt
{

	var logo:FlxSprite;
	var text:FlxSprite;
	
	var curFrame:Int = -1;

	//final scales = [0.36, 0.52, 0.68, 0.84, 1];
	final times = [0.041, 0.184, 0.334, 0.495, 0.636];

	override public function create(){

		customTransIn = new BasicTransition();
		customTransOut = new BasicTransition();

		#if web
        FlxG.sound.play(FlxAssets.getSound("flixel/sounds/flixel"), 0);
        #end

		super.create();

		var bg = new FlxSprite().makeGraphic(1280, 720, 0xFF4F2632);

		logo = new FlxSprite().loadGraphic("assets/images/flixelSplash/logo.png", true, 238, 238);
		logo.animation.add("anim", [0, 1, 2, 3, 4], 0, false);
		logo.animation.play("anim");
		logo.screenCenter(XY);
		logo.visible = false;

		text = new FlxSprite().loadGraphic("assets/images/flixelSplash/text.png", true, 208, 36);
		text.animation.add("anim", [1, 2, 3, 4, 5, 0], 0, false);
		text.animation.play("anim");
		text.screenCenter(XY);
		text.animation.curAnim.curFrame = 6;
		text.visible = true;

		add(bg);
		add(logo);
		add(text);

		for (x in times){
				new FlxTimer().start(x, advanceAnims);
		}

		FlxG.sound.load(FlxAssets.getSound("flixel/sounds/flixel")).play();

	}

	override function update(elapsed){
		super.update(elapsed);

		if(FlxG.keys.justPressed.NINE){
			switchState(new FlixelSplash());
		}
		else if(FlxG.keys.justPressed.SPACE){
			switchState(new StartCutscene());
		}
	}

	function advanceAnims(_timer:FlxTimer){
		curFrame++;

		logo.animation.curAnim.curFrame = curFrame;
		logo.visible = true;

		if (curFrame == 4){
			new FlxTimer().start(0.75, function(t){
				FlxG.camera.fade(0xFF4F2632, 1.3, false, onComplete);
			});
		}

	}

	function onComplete():Void{
		switchState(new StartCutscene());
	}

}